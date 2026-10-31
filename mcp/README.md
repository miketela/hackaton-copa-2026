# MCP servers

## Azure MCP Server (enabled in `/.mcp.json`)

Official Microsoft server (`@azure/mcp`, from the microsoft/azure-skills plugin). It runs locally with `npx` and authenticates with **your Azure CLI session** (`az login`). It gives the agent structured tools to:
- list resources;
- read App Service configuration;
- query Log Analytics / Application Insights;
- and more.

Requirements: Node.js 18+ and `az login`. Claude Code asks you to approve the server the first time you open the repo.

Challenge rules still apply. The agent asks before any tool call that changes something, and it acts only on `rg-team-<id>`.

## Dynatrace MCP (optional: `mcp/dynatrace.mcp.json`)

Official Dynatrace remote MCP gateway, from the Dynatrace/dynatrace-for-ai repo. It needs:

```bash
export DT_ENVIRONMENT=https://<env>.apps.dynatrace.com
export DT_PLATFORM_TOKEN=<platform token with the MCP gateway scopes>
```

The organizers said that **access to the challenge tenant's data from outside is restricted**, and that teams get a user login, not tokens. So this will probably **not** work on challenge day; it is useful for practicing on your own environment. To enable it in Claude Code, merge its `dynatrace` entry into `/.mcp.json`. Never commit the token.

Without MCP, the Dynatrace skills still work. The agent writes the DQL, you run it in a Notebook in the tenant, and you paste the result back.
