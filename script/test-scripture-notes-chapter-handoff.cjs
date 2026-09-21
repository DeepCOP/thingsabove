/* global __dirname */
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { test } = require('node:test');
const ts = require('typescript');

const filename = path.resolve(__dirname, '../src/lib/scriptureNotesChapterHandoff.ts');
const { outputText } = ts.transpileModule(fs.readFileSync(filename, 'utf8'), {
  compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 },
  fileName: filename,
});
const compiled = { exports: {} };
new Function('require', 'module', 'exports', outputText)(require, compiled, compiled.exports);
const {
  clearScriptureNotesChapter,
  getScriptureNotesChapter,
  stageScriptureNotesChapter,
} = compiled.exports;

const adapter = {
  sourceId: 'fixture',
  versionId: 'FIXTURE',
  getBooks: async () => [],
  getChapter: async () => null,
};
const scope = { adapter, bookId: 'JOH', chapterNumber: 3 };
const chapter = { chapter: 3, verses: [{ verse: 16, text: 'Fixture verse.' }] };

test('notes receives a matching staged chapter without route serialization', () => {
  stageScriptureNotesChapter(scope, chapter);
  assert.equal(getScriptureNotesChapter({ ...scope, chapterNumber: 4 }), null);
  assert.equal(getScriptureNotesChapter(scope), chapter);
  clearScriptureNotesChapter(scope);
  assert.equal(getScriptureNotesChapter(scope), null);
});
