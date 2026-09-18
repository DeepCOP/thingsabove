# Bible reading adapters

`BibleReadingAdapter` is the boundary between Bible text sources and the reader.
`BibleContext` selects an adapter and exposes its book metadata. Screens use
`useBibleChapter` to request text asynchronously instead of accessing a complete
`BibleJSON` object.

- `getBooks()` returns book IDs, display names, and actual chapter numbers, without
  verse text. Navigation uses these numbers instead of array positions.
- `getChapter(bookId, chapterNumber)` returns a complete chapter, returns `null`
  for a missing reference, or rejects when reading fails.
- Book IDs and verse numbers must match the app's existing reference scheme.
  For example, John is `JOH`. Highlights use `JOH:3:16`, while note scopes use
  `john:3:16`; the adapter must not change either stored identity.
- An adapter's source and version identities remain fixed. A version switch
  selects that version's adapter, and `useBibleChapter` ignores outdated results.

The offline adapter lazily loads and normalizes one bundled or installed JSON
file, shares concurrent reads, and allows retry after a failed read. Download,
installation, and removal still belong to `bibleVersionService`.

`bibleReadingService` selects the offline, YouVersion, ESV, or API.Bible adapter. Online versions
are selectable without installation. They have a separate provider Bible ID and
a stable `YOUVERSION_...` or `ESV_API` app ID; labels in the reader use the translation's
abbreviation. Existing offline version IDs and annotation keys are unchanged.

## YouVersion setup

1. Register the app at [YouVersion Platform](https://platform.youversion.com/) and
   accept the licenses for the translations you want to offer.
2. Create a local `.env.youversion.local` file (ignored by Git) containing
   `YOUVERSION_APP_KEY=...`. Optionally set `YOUVERSION_BIBLE_IDS=3034,...` to limit
   the catalog to specific numeric provider IDs. With no allowlist, the catalog
   includes the translations licensed to the app key across all languages.
3. Configure the linked Supabase project and deploy the proxy:

   ```sh
   pnpm exec supabase secrets set --env-file .env.youversion.local
   pnpm exec supabase functions deploy youversion
   ```

4. Set `EXPO_PUBLIC_YOUVERSION_ENABLED=true` in the app's local environment and
   restart Expo/rebuild. The app key stays in Supabase secrets and must never
   have an `EXPO_PUBLIC_` prefix.
5. Choose a translation marked **Online · YouVersion**. Guests can browse, add,
   and read online versions without signing in or linking a YouVersion account.
   Existing highlights and notes continue to use this app's storage.

The YouVersion proxy uses the official `api.youversion.com/v1` REST API. The
client follows catalog pagination, stores a separate numeric provider ID, and
merges results with the offline and ESV catalogs. Metadata comes from the
Bible index and version endpoints; chapters use the passages endpoint with
HTML formatting and publisher notes/headings disabled. The adapter reads verse
markers with `htmlparser2` and returns plain verse text to the existing reader;
provider HTML is not executed or displayed in a WebView.

The adapter maps USFM book IDs to existing annotation IDs, retains chapter and
printed verse numbers, and includes the translation's copyright with each
chapter. Combined/partial verse numbers and unsupported numbering are rejected
instead of assigning text to the wrong annotation. Cross-translation
versification remapping is not implemented. Test the intended translations
before enabling them in production.

Only metadata is cached for the adapter's lifetime. Chapter requests are shared
while in flight and are not accumulated or downloaded for offline reading.
Copyright appears in the reader, note previews, and copied/shared passages.
No database migration is needed. Online providers can be enabled together or
independently. Guests can use offline and online translations.

The online Bible proxies are public endpoints: their entries in `supabase/config.toml`
set `verify_jwt = false`, and their handlers do not require an app session.
Provider keys remain in Supabase secrets. Request validation, translation
allowlists, response limits, and provider throttling still apply. The proxies do
not add a separate per-user or per-IP quota. Redeploy every enabled function when
upgrading an existing deployment so the old session checks and gateway JWT
requirement are removed. See [Supabase's public function configuration](https://supabase.com/docs/guides/functions/auth-headers).

Fixture-based tests cover parsing, reference identities, retries, factory
selection, catalog pagination, and proxy validation. Live access requires the
project's licensed YouVersion app key and a deployed Edge Function; it has not
been verified against a live account.

Provider references: [REST API](https://developers.youversion.com/api/bibles),
[API usage](https://developers.youversion.com/api-usage), and
[copyright attribution](https://developers.youversion.com/sdks/javascript/guides/copyright-and-attribution).

Run `pnpm run test:bible-adapter` for all adapter and proxy regression tests and
`pnpm run typecheck` to check all consumers.

## ESV.org setup

1. Create an API application at [ESV.org](https://api.esv.org/docs/) and review
   [Crossway's current usage terms](https://api.esv.org/) for your app and its
   sharing features. The standard API terms cover non-commercial use, including
   qualifying mobile apps; other uses may require a separate license.
2. Create a local `.env.esv.local` file (ignored by Git) with `ESV_API_KEY=...`.
   Keep this key server-side, without an `EXPO_PUBLIC_` prefix.
3. Configure the linked Supabase project and deploy the proxy:

   ```sh
   pnpm exec supabase secrets set --env-file .env.esv.local
   pnpm exec supabase functions deploy esv
   ```

4. Set `EXPO_PUBLIC_ESV_ENABLED=true` in the app's local environment and restart
   Expo/rebuild. This optional switch uses the same opt-in behavior as the other
   online providers. Select **ESV**, marked **Online · ESV.org**; no sign-in is
   required for browsing, adding, or reading.

ESV offers one translation rather than a multi-translation catalog. Its app ID
is `ESV_API`, so it stays distinct from downloaded ESV files or ESV editions
available through another provider. Since the API has no book-list endpoint,
the adapter and proxy share a static 66-book chapter index containing no
Scripture text. The existing canonical book IDs continue to identify highlights,
references, and notes.

The proxy only accepts a supported book and one valid chapter number; it builds
the passage query itself, keeps the Token credential private, and uses the
[HTML passage endpoint](https://api.esv.org/docs/passage-html/). The adapter
validates the returned chapter range and verse IDs, removes publisher headings,
footnotes, and verse labels from selectable text, and extracts the full copyright
notice. Unsupported numbering and malformed responses produce an error.

The reader, devotional reader, and note previews show the returned copyright and
a link to ESV.org. Copied/shared passages retain both attribution and the link.
The adapter shares in-flight requests but does not persist or accumulate chapter
text. The app's existing note storage remains separate from the text provider.

Crossway's published limits include 60 requests/minute, 1,000/hour, and
5,000/day. The client observes throttling responses; it does not centrally meter
all users' aggregate requests. The standard terms also limit passage size,
local storage, display, and redistribution (including book-percentage and
quotation-percentage limits). A single chapter and no persistent chapter cache
do not by themselves guarantee every sharing or display use is permitted.
Check intended use against those terms or your separate license before enabling
production access, particularly for short books and standalone shared quotations.

No database migration is needed. Local tests use synthetic responses; deployment
and live chapter retrieval still require verification with the project's API key.

## API.Bible setup

1. Create an account and API key in [API.Bible](https://api.bible/). The API key
   must remain server-side. Make sure the account has access to every translation
   you intend to show.
2. Create a local `.env.api-bible.local` file (ignored by Git):

   ```sh
   API_BIBLE_API_KEY=...
   # Optional: restrict the catalog to these API.Bible translation IDs.
   API_BIBLE_BIBLE_IDS=
   ```

3. Configure the linked Supabase project and deploy the proxy:

   ```sh
   pnpm exec supabase secrets set --env-file .env.api-bible.local
   pnpm exec supabase functions deploy api-bible
   ```

4. Set `EXPO_PUBLIC_API_BIBLE_ENABLED=true` in the app environment and restart
   Expo or rebuild. Guests can browse, add, and read API.Bible translations;
   this does not require an app account or an API.Bible account.

The API.Bible adapter uses the server proxy for the Bible catalog, book index,
and one HTML chapter at a time. It maps the provider's book and verse IDs to the
same canonical keys the offline reader uses, so highlights, references, and
notes stay attached to the selected reference. It returns plain selectable verse
text, preserves the provider copyright, and does not persist chapter text for
offline use.

The proxy requests API.Bible's FUMS v3 token with each chapter. The app reports
that token with an anonymous local device ID and a fresh session ID; it sends no
account ID or other personal information. This supports API.Bible's web usage
reporting requirement. Review [API.Bible licensing](https://docs.api.bible/quick-start/working-with-bibles/)
and [FUMS guidance](https://docs.api.bible/guides/fair-use/) before enabling the
provider in production.
