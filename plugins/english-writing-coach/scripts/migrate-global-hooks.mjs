#!/usr/bin/env node
/**
 * Retire only the legacy direct English Layer SessionStart registration.
 * Default mode is dry-run; --apply writes timestamped sibling backups first.
 */
import fs from "node:fs";
import os from "node:os";
import path from "node:path";

const apply = process.argv.includes("--apply");
const legacyFragment = "/dev/english-layer/inject.sh";
const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
const files = [
  path.join(os.homedir(), ".codex", "hooks.json"),
  path.join(os.homedir(), ".claude", "settings.json"),
];

let changed = 0;
for (const file of files) {
  if (!fs.existsSync(file)) {
    console.log(`skip missing: ${file}`);
    continue;
  }

  const payload = JSON.parse(fs.readFileSync(file, "utf8"));
  const sessionStart = payload.hooks?.SessionStart;
  if (!Array.isArray(sessionStart)) {
    console.log(`unchanged: ${file} (no SessionStart hook)`);
    continue;
  }

  const retained = sessionStart.filter(
    (entry) =>
      !entry?.hooks?.some(
        (hook) => typeof hook?.command === "string" && hook.command.includes(legacyFragment),
      ),
  );

  if (retained.length === sessionStart.length) {
    console.log(`unchanged: ${file} (legacy hook not found)`);
    continue;
  }

  changed += 1;
  console.log(`${apply ? "migrate" : "would migrate"}: ${file}`);
  if (!apply) continue;

  const backup = `${file}.before-english-writing-coach-${timestamp}.bak`;
  fs.copyFileSync(file, backup, fs.constants.COPYFILE_EXCL);
  payload.hooks.SessionStart = retained;
  fs.writeFileSync(file, `${JSON.stringify(payload, null, 2)}\n`);
  console.log(`backup: ${backup}`);
}

if (!apply && changed > 0) {
  console.log("Dry run only. Re-run with --apply after both plugins are installed.");
}
