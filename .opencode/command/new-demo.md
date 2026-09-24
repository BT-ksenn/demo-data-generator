---
description: Create a new Odoo demo-data package for a customer (autonomous, no clarifying questions)
agent: demo
---

Create a new Odoo demo-data package for: $ARGUMENTS

Work autonomously - no clarifying questions. Follow the `odoo-demo-data` skill
and its reference files.

1. Decide the capability bundles from the customer's business model
   (`python3 -m engine.cli capabilities --json`); dependencies close
   automatically. Derive the demo-data language from the company country unless
   the arguments name one. Capture the reasoning once in `customer_profile`.
2. Scaffold and author `examples/<customer>.json`:
   `python3 -m engine.cli new --with <bundles> --name "<Customer>" --country <cc>
   --out examples/<customer>.json`, then fill it per
   `skills/odoo-demo-data/reference/spec-format.md`. Use compact tables and aim
   for the "rich demo" volume. Leave no leftover `TODO`.
3. Build:
   `python3 -m engine.cli generate --spec examples/<customer>.json --out output`.
4. Install smoke test in one shot (fresh DB, no `--test-enable`, Postgres check):
   `engine/docker/smoke.sh --module <technical_name>`.
   Set the bash tool `timeout` to at least 1800000 ms - the 120 s default aborts
   it.
5. On an install error: read the full traceback first, fix, retry. Never guess
   Odoo field names - verify against the 20.0 source per
   `skills/odoo-demo-data/reference/verification-protocol.md`.

Report at the end: spec path, bundles, ZIP path, install result, open points.
