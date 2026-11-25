#!/usr/bin/env node
// Reports what catalogue.json expects and this machine lacks, per Claude profile and Codex. Reads only.
import { existsSync, lstatSync, readFileSync, readdirSync, realpathSync } from "node:fs"
import { homedir } from "node:os"
import { join } from "node:path"

const c = JSON.parse(readFileSync(new URL("../catalogue.json", import.meta.url), "utf8"))
const home = homedir()
const shared = join(home, ".agents/skills")
const core = c.skills.filter(s => s.scope === "core").flatMap(s => s.skills)
const isDropped = n => c.dropped.skills.includes(n) || c.dropped.skillPrefixes.some(p => n.startsWith(p))
const ls = d => (existsSync(d) ? readdirSync(d) : [])
// Unreadable or invalid files throw on purpose: a wrong "all present" is worse than a crash.
const json = f => (existsSync(f) ? JSON.parse(readFileSync(f, "utf8")) : {})
const hasSkill = (d, n) => existsSync(join(d, n, "SKILL.md"))
let problems = 0
const report = (where, label, items) => {
  if (!items.length) return
  problems += items.length
  console.log(`${where}: ${label} (${items.length}): ${items.join(", ")}`)
}

report("shared", "missing", core.filter(n => !hasSkill(shared, n)))
report("shared", "dropped but present", ls(shared).filter(isDropped))

const profiles = ls(home).filter(d => /^\.claude(-[a-z0-9]+)?$/.test(d) && existsSync(join(home, d, "settings.json")))
if (!profiles.length) report("claude", "missing", ["no profile found"])
for (const d of profiles) {
  const dir = join(home, d, "skills")
  report(d, "missing", core.filter(n => !hasSkill(dir, n)))
  report(d, "not the shared copy", core.filter(n => hasSkill(dir, n) && hasSkill(shared, n) && realpathSync(join(dir, n)) !== realpathSync(join(shared, n))))
  report(d, "broken links", ls(dir).filter(n => lstatSync(join(dir, n)).isSymbolicLink() && !existsSync(join(dir, n))))
  report(d, "dropped but present", ls(dir).filter(isDropped))
  const enabled = json(join(home, d, "settings.json")).enabledPlugins ?? {}
  const installed = json(join(home, d, "plugins/installed_plugins.json")).plugins ?? {}
  const on = p => enabled[p] && installed[p]?.some(i => existsSync(i.installPath))
  report(d, "plugins missing", c.plugins.filter(p => p.scope === "core" && p.claude && !on(p.claude.plugin)).map(p => p.claude.plugin))
  report(d, "dropped plugins on", c.dropped.plugins.filter(p => enabled[p]))
  const config = d === ".claude" ? join(home, ".claude.json") : join(home, d, ".claude.json")
  const servers = json(config).mcpServers ?? {}
  report(d, "connections missing", c.connections.filter(m => m.harnesses.includes("claude") && servers[m.name]?.url !== m.url).map(m => m.name))
}

const codex = join(home, ".codex/config.toml")
if (!existsSync(codex)) report("codex", "missing", ["no ~/.codex/config.toml"])
else {
  const toml = readFileSync(codex, "utf8")
  const table = head => toml.split(/^(?=\[)/m).find(t => t.startsWith(head))
  const on = p => /^enabled\s*=\s*true/m.test(table(`[plugins."${p}"]`) ?? "")
  report("codex", "plugins missing", c.plugins.filter(p => p.scope === "core" && p.codex && !on(p.codex.plugin)).map(p => p.codex.plugin))
  report("codex", "connections missing", c.connections.filter(m => m.harnesses.includes("codex") && !table(`[mcp_servers.${m.name}]`)?.includes(`"${m.url}"`)).map(m => m.name))
}

console.log(problems ? `${problems} problems` : "ok")
process.exit(problems ? 1 : 0)
