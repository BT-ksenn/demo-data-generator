---
description: Create a new Odoo demo-data package for a customer (autonomous, no clarifying questions; --20 / --19 pick the Odoo line)
agent: demo
---

Create a new Odoo demo-data package for: $ARGUMENTS

Work autonomously - no clarifying questions. Follow the `odoo-demo-data` skill
and its reference files.

1. **Target version / branch.** If the arguments contain `--20`, work on the
   `main` branch (`main` follows 20.0); if they contain `--19`, work on the
   `19.0` branch. Switch first, before anything else (`git switch main` resp.
   `git switch 19.0`) so the whole pipeline runs with that line's engine and
   target instance. Without `--20`/`--19` stay on the current branch. If the
   switch fails (e.g. a dirty working tree would be overwritten), stop and report
   exactly what blocks it. Strip the flag from the customer name/arguments.
2. Decide the capability bundles from the customer's business model
   (`python3 -m engine.cli capabilities --json`); dependencies close
   automatically. Derive the demo-data language from the company country unless
   the arguments name one. Capture the reasoning once in `customer_profile`.
3. Scaffold and author `examples/<customer>.json`:
   `python3 -m engine.cli new --with <bundles> --name "<Customer>" --country <cc>
   --out examples/<customer>.json`, then fill it per
   `skills/odoo-demo-data/reference/spec-format.md`. Use compact tables and aim
   for the "rich demo" volume. Leave no leftover `TODO`.
4. Build:
   `python3 -m engine.cli generate --spec examples/<customer>.json --out output`.
5. Install smoke test in one shot (fresh DB, no `--test-enable`, Postgres check):
   on the 20.0 line `engine/docker/smoke.sh --module <technical_name>`; on the
   19.0 line follow `skills/odoo-demo-data/reference/install-test-protocol.md`
   (there is no `smoke.sh` there). Set the bash tool `timeout` to at least
   1800000 ms - the 120 s default aborts it.
6. On an install error: read the full traceback first, fix, retry. Never guess
   Odoo field names - verify against the target line's Odoo source per
   `skills/odoo-demo-data/reference/verification-protocol.md`.

Report at the end: spec path, bundles, ZIP path, install result, open points.
