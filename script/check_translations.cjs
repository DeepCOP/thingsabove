'use strict';

const fs = require('node:fs');
const path = require('node:path');

const root = path.join(process.cwd(), 'src', 'i18n', 'locales');
const locales = ['en', 'es', 'pt', 'zh-Hans', 'zh-Hant'];
const namespaces = ['app', 'bible', 'community', 'plans'];
const errors = [];

const isObject = (value) =>
  value !== null && typeof value === 'object' && !Array.isArray(value);

function readCatalog(locale, namespace) {
  const file = path.join(root, locale, `${namespace}.json`);
  try {
    return JSON.parse(fs.readFileSync(file, 'utf8'));
  } catch (error) {
    errors.push(`${locale}/${namespace}: ${error.message}`);
    return null;
  }
}

function placeholders(value) {
  return [...value.matchAll(/\{\{\s*([^{}]+?)\s*\}\}/g)]
    .map((match) => match[1].trim())
    .sort();
}

function checkShape(locale, namespace, source, translation, key = '<root>') {
  const location = `${locale}/${namespace}:${key}`;
  if (isObject(source)) {
    if (!isObject(translation)) {
      errors.push(`${location}: expected an object`);
      return;
    }
    for (const name of Object.keys(source)) {
      if (!Object.hasOwn(translation, name)) {
        errors.push(`${location}.${name}: missing key`);
      } else {
        checkShape(locale, namespace, source[name], translation[name],
          key === '<root>' ? name : `${key}.${name}`);
      }
    }
    for (const name of Object.keys(translation)) {
      if (!Object.hasOwn(source, name)) {
        errors.push(`${location}.${name}: extra key`);
      }
    }
    return;
  }

  if (typeof source !== 'string') {
    errors.push(`en/${namespace}:${key}: expected a string`);
    return;
  }
  if (typeof translation !== 'string' || !translation.trim()) {
    errors.push(`${location}: expected a nonempty string`);
    return;
  }
  const expected = placeholders(source);
  const actual = placeholders(translation);
  if (expected.join('|') !== actual.join('|')) {
    errors.push(`${location}: placeholders differ (expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)})`);
  }
}

for (const namespace of namespaces) {
  const source = readCatalog('en', namespace);
  if (source === null) continue;
  checkShape('en', namespace, source, source);
  for (const locale of locales.slice(1)) {
    const translation = readCatalog(locale, namespace);
    if (translation !== null) checkShape(locale, namespace, source, translation);
  }
}

if (errors.length) {
  console.error(`Translation check failed (${errors.length} issue${errors.length === 1 ? '' : 's'}):`);
  for (const error of errors) console.error(`- ${error}`);
  process.exitCode = 1;
} else {
  console.log(`Translation check passed: ${locales.length} locales x ${namespaces.length} namespaces.`);
}
