#!/usr/bin/env node
// Checks catalogue.json. With --online, also checks that every listed skill exists in its source repo (needs `gh`).
import { execFileSync } from "node:child_process"
import { readFileSync } from "node:fs"

const c = JSON.parse(readFileSync(new URL("../catalogue.json", import.meta.url), "utf8"))
const errors = []
const REPO = /^[\w-][\w.-]*\/[\w-][\w.-]*$/
const SKILL = /^[a-z0-9]+(-[a-z0-9]+)*$/
const PLUGIN = /^[\w.-]+@[\w.-]+$/
const SCOPES = ["core", "project"]
const UPDATES = ["auto", "approve"]
const check = (ok, message) => ok || errors.push(message)

check(c.version === 1, "version must be 1")
const seen = new Map()
const sources = new Set()
for (const s of c.skills) {
  check(REPO.test(s.source), `bad source: ${s.source}`)
  check(!sources.has(s.source), `source listed twice: ${s.source}`)
  sources.add(s.source)
  check(SCOPES.includes(s.scope) && UPDATES.includes(s.update), `bad scope or update: ${s.source}`)
  check(s.skills.length > 0, `no skills: ${s.source}`)
  for (const n of s.skills) {
    check(SKILL.test(n), `bad skill name: ${n}`)
    check(!seen.has(n), `${n} listed under both ${seen.get(n)} and ${s.source}`)
    seen.set(n, s.source)
    check(!c.dropped.skills.includes(n) && !c.dropped.skillPrefixes.some(p => n.startsWith(p)), `${n} is listed and dropped`)
  }
}
const plugins = new Set()
for (const p of c.plugins) {
  check(!plugins.has(p.name), `plugin listed twice: ${p.name}`)
  plugins.add(p.name)
  check(SCOPES.includes(p.scope) && UPDATES.includes(p.update), `bad scope or update: ${p.name}`)
  check(p.claude || p.codex, `no harness for plugin: ${p.name}`)
  for (const h of [p.claude, p.codex].filter(Boolean)) {
    check(REPO.test(h.marketplace) && PLUGIN.test(h.plugin), `bad plugin entry: ${p.name}`)
    check(!c.dropped.plugins.includes(h.plugin), `${h.plugin} is listed and dropped`)
  }
}

if (process.argv.includes("--online")) {
  for (const s of c.skills) {
    try {
      const out = execFileSync("gh", ["api", `repos/${s.source}/git/trees/HEAD?recursive=1`, "--jq", ".truncated, (.tree[].path | select(test(\"(^|/)SKILL.md$\")))"], { encoding: "utf8", maxBuffer: 1 << 26 })
      const [truncated, ...paths] = out.trim().split("\n")
      check(truncated === "false", `${s.source}: file list truncated, cannot check`)
      // A skill's frontmatter name can differ from its folder, and installs use the name.
      // Read likely folders first, then the rest only if something is still missing.
      const missing = new Set(s.skills)
      const likely = p => p === "SKILL.md" || s.skills.includes(p.split("/").at(-2))
      for (const p of [...paths].sort((a, b) => likely(b) - likely(a))) {
        if (!missing.size) break
        const text = execFileSync("gh", ["api", `repos/${s.source}/contents/${p}`, "-H", "Accept: application/vnd.github.raw"], { encoding: "utf8" })
        missing.delete(text.match(/^name:\s*["']?([a-z0-9-]+)/m)?.[1])
      }
      for (const n of missing) check(false, `${s.source} has no skill named ${n}`)
    } catch (e) {
      errors.push(`${s.source}: ${String(e.stderr || e.message).trim().slice(0, 200)}`)
    }
  }
}

if (errors.length) {
  console.error(errors.join("\n"))
  process.exit(1)
}
console.log(`ok: ${seen.size} skills from ${sources.size} sources, ${plugins.size} plugins`)
