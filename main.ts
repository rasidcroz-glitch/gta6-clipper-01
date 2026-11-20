// gta6-clipper-01 entry program (Node 22, standard library only).
//
// The entry is the YouTube video itself: this program's only job is to hand
// the house the video's address. It reads VIDEO.json from the repository
// root and copies it to the output directory, where the gate reads it.
// It never touches the network and needs nothing installed.
//
// Run it locally the way the grader does:
//   mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts

import { copyFileSync, existsSync, mkdirSync, readFileSync } from "node:fs";
import { join } from "node:path";

const BOT_DIR = process.env.MAKEFUN_BOT_DIR ?? "/bot";
const OUTPUT_DIR = process.env.MAKEFUN_OUTPUT_DIR ?? "/output";

const source = join(BOT_DIR, "VIDEO.json");
const target = join(OUTPUT_DIR, "VIDEO.json");

if (!existsSync(source)) {
  console.error(`VIDEO.json not found in ${BOT_DIR}`);
  process.exit(1);
}

// Refuse to copy a VIDEO.json that is not even valid JSON: a broken link
// file would fail the gate anyway, so fail loudly here instead.
const parsed: unknown = JSON.parse(readFileSync(source, "utf8"));
if (
  typeof parsed !== "object" ||
  parsed === null ||
  typeof (parsed as { url?: unknown }).url !== "string"
) {
  console.error("VIDEO.json must be a JSON object with a string url field");
  process.exit(1);
}

const url = (parsed as { url: string }).url;

// The gate only accepts a real YouTube video address. Warn loudly when
// VIDEO.json still holds the placeholder (or something else entirely),
// but copy it anyway: failing here would hide the problem from the gate.
if (
  !/^https:\/\/(www\.|m\.)?(youtube\.com\/(shorts\/|watch\?v=)|youtu\.be\/)[\w-]{11}/.test(
    url,
  )
) {
  console.error(
    `warning: VIDEO.json url does not look like a YouTube video address: ${url}`,
  );
}

mkdirSync(OUTPUT_DIR, { recursive: true });
copyFileSync(source, target);
console.log(`Copied VIDEO.json to ${target}`);
