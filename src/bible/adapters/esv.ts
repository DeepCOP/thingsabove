import { Parser } from 'htmlparser2';
import { esvBooks } from '../../../supabase/functions/_shared/esvBooks';
import { findBookInBible } from '../books';
import type { BibleChapter } from '../types';
import type { BibleBookMetadata, BibleReadingAdapter } from './types';

export type EsvRequest = (request: {
  action: 'chapter';
  bookId: string;
  chapterNumber: number;
}) => Promise<unknown>;

const record = (value: unknown): Record<string, unknown> => {
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    throw new Error('ESV returned an invalid response.');
  }
  return value as Record<string, unknown>;
};
const whitespace = (value: string) => value.replace(/\s+/g, ' ').trim();
const isBlock = (tag: string) => /^(?:p|div|br|table|tr|td|th|li)$/.test(tag);
const voidTags = new Set([
  'area',
  'base',
  'br',
  'col',
  'embed',
  'hr',
  'img',
  'input',
  'link',
  'meta',
  'param',
  'source',
  'track',
  'wbr',
]);

type HtmlNode = {
  tag: string;
  attrs: Record<string, string>;
  children: HtmlNode[];
  text?: string;
};
const classes = (node: HtmlNode) => (node.attrs.class ?? '').split(/\s+/);
const ignored = (node: HtmlNode) =>
  /^(?:script|style|template|h[1-6])$/.test(node.tag) ||
  classes(node).some((name) =>
    /^(?:extra_text|footnote|footnotes|fn|crossref|crossrefs|chapter-num|audio)$/.test(name),
  );
const textContent = (node: HtmlNode): string => {
  if (/^(?:script|style|template)$/.test(node.tag)) return '';
  if (node.text != null) return node.text;
  const text = node.children.map(textContent).join('');
  return isBlock(node.tag) ? ` ${text} ` : text;
};

/** ESV's printed markers contain BBCCCVVV references, including omitted verse gaps. */
export const parseEsvChapter = (
  response: unknown,
  bookId: string,
  chapterNumber: number,
): BibleChapter => {
  const data = record(record(response).data);
  const book = esvBooks.find((candidate) => candidate.id === bookId);
  if (
    !book ||
    !Number.isInteger(chapterNumber) ||
    chapterNumber < 1 ||
    chapterNumber > book.chapterCount ||
    data.bookId !== bookId ||
    data.chapterNumber !== chapterNumber ||
    !Array.isArray(data.passages) ||
    data.passages.length !== 1 ||
    typeof data.passages[0] !== 'string' ||
    data.passages[0].length > 2_000_000 ||
    !Array.isArray(data.parsed) ||
    data.parsed.length !== 1 ||
    !Array.isArray(data.passage_meta) ||
    data.passage_meta.length !== 1
  ) {
    throw new Error('ESV returned unexpected chapter content.');
  }
  const prefix = book.ordinal * 1_000_000 + chapterNumber * 1000;
  const range = data.parsed[0];
  const meta = record(data.passage_meta[0]);
  if (
    !Array.isArray(range) ||
    range.length !== 2 ||
    range[0] !== prefix + 1 ||
    !Number.isInteger(range[1]) ||
    range[1] < range[0] ||
    range[1] >= prefix + 1000 ||
    ![meta.chapter_start, meta.chapter_end].every(
      (value) =>
        Array.isArray(value) &&
        value.length === 2 &&
        value[0] === range[0] &&
        value[1] === range[1],
    )
  ) {
    throw new Error('ESV returned an incomplete or different chapter.');
  }
  const lastVerse = Number(range[1]) - prefix;
  const root: HtmlNode = { tag: '', attrs: {}, children: [] };
  const stack = [root];
  let nodeCount = 0;
  const countNode = () => {
    if (++nodeCount > 50000 || stack.length > 50) {
      throw new Error('ESV returned overly complex content.');
    }
  };
  const parser = new Parser(
    {
      onopentag: (tag, attrs) => {
        countNode();
        const node: HtmlNode = { tag, attrs, children: [] };
        stack[stack.length - 1].children.push(node);
        stack.push(node);
      },
      ontext: (text) => {
        countNode();
        stack[stack.length - 1].children.push({ tag: '', attrs: {}, children: [], text });
      },
      onclosetag: (tag, isImplied) => {
        const node = stack.pop();
        if (node?.tag !== tag || (isImplied && !voidTags.has(tag))) {
          throw new Error('ESV returned malformed chapter HTML.');
        }
      },
    },
    { decodeEntities: true },
  );
  parser.end(data.passages[0]);

  const copyrightBlocks = new Set<HtmlNode>();
  const collectCopyright = (node: HtmlNode, paragraph?: HtmlNode) => {
    const enclosingParagraph = node.tag === 'p' ? node : paragraph;
    if (classes(node).includes('copyright')) {
      copyrightBlocks.add(enclosingParagraph ?? node);
      return;
    }
    // Full notices may have no CSS class, unlike the short ESV copyright link.
    if (
      node.tag === 'p' &&
      /^(?:Scripture quotations? (?:are|is) from|The Holy Bible, English Standard Version)/i.test(
        whitespace(textContent(node)),
      )
    ) {
      copyrightBlocks.add(node);
      return;
    }
    node.children.forEach((child) => collectCopyright(child, enclosingParagraph));
  };
  collectCopyright(root);
  const copyright = [...copyrightBlocks].map((node) => whitespace(textContent(node))).join(' ');
  if (!copyright || !/(?:\bESV\b|English Standard Version)/i.test(copyright)) {
    throw new Error('ESV did not return the copyright notice for this chapter.');
  }

  const verses = new Map<number, string>();
  let currentVerse: number | null = null;
  const append = (text: string) => {
    if (currentVerse == null) {
      if (text.trim()) throw new Error('ESV returned text without a verse reference.');
      return;
    }
    verses.set(currentVerse, (verses.get(currentVerse) ?? '') + text);
  };
  const walk = (node: HtmlNode) => {
    if (copyrightBlocks.has(node) || ignored(node)) return;
    if (classes(node).includes('verse-num')) {
      const match = /^v(\d{7,8})-[1-9]\d*$/.exec(node.attrs.id ?? '');
      const label = whitespace(textContent(node));
      if (!/^[1-9]\d*$/.test(label)) {
        throw new Error(
          'This chapter uses combined or partial verse numbers that this reader does not support yet.',
        );
      }
      const verse = Number(label);
      if (!match || Number(match[1]) !== prefix + verse || verse > lastVerse) {
        throw new Error('ESV returned inconsistent verse references.');
      }
      if (currentVerse != null && verse <= currentVerse) {
        throw new Error('ESV returned duplicate or unordered verse references.');
      }
      currentVerse = verse;
      verses.set(verse, '');
      return;
    }
    if (node.text != null) {
      append(node.text);
      return;
    }
    if (isBlock(node.tag)) append(' ');
    node.children.forEach(walk);
    if (isBlock(node.tag)) append(' ');
  };
  walk(root);
  // Some omitted verses retain only a marker after footnotes are disabled.
  const normalized = [...verses]
    .map(([verse, text]) => ({ verse, text: whitespace(text) }))
    .filter((verse) => verse.text);
  if (
    !normalized.length ||
    normalized[0].verse !== 1 ||
    normalized[normalized.length - 1].verse !== lastVerse
  ) {
    throw new Error('ESV returned incomplete verse text for this chapter.');
  }
  return {
    chapter: chapterNumber,
    verses: normalized,
    copyright,
    attributionUrl: 'https://www.esv.org/',
  };
};

export const createEsvAdapter = (versionId: string, request: EsvRequest): BibleReadingAdapter => {
  const books: BibleBookMetadata[] = esvBooks.map((book) => ({
    id: book.id,
    name: book.name,
    chapters: Array.from({ length: book.chapterCount }, (_, index) => index + 1),
  }));
  const pendingChapters = new Map<string, Promise<BibleChapter>>();
  return {
    sourceId: 'esv',
    versionId,
    async getBooks() {
      return books.map((book) => ({ ...book, chapters: [...book.chapters] }));
    },
    async getChapter(bookId, chapterNumber) {
      const book = findBookInBible(books, bookId);
      if (!book || !Number.isInteger(chapterNumber) || !book.chapters.includes(chapterNumber)) {
        return null;
      }
      const key = `${book.id}.${chapterNumber}`;
      let pending = pendingChapters.get(key);
      if (!pending) {
        pending = Promise.resolve()
          .then(() => request({ action: 'chapter', bookId: book.id, chapterNumber }))
          .then((response) => parseEsvChapter(response, book.id, chapterNumber))
          .finally(() => {
            pendingChapters.delete(key);
          });
        pendingChapters.set(key, pending);
      }
      return pending;
    },
  };
};
