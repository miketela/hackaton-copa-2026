# Hackatón Copa 2026: espacio de trabajo para agentes

Repo local con todo el contexto que un agente de IA (Claude Code, Codex, Copilot, Cursor, Gemini, OpenCode…) necesita para ayudarnos en los dos retos: **Microsoft/Azure** y **Dynatrace**.

## Qué hay adentro

- **`AGENTS.md`**: la entrada para cualquier agente. Le dice qué reto es, qué leer primero y qué reglas no puede romper. `CLAUDE.md` lo importa.
- **`context/`**: los dos context files, uno por reto:
  - qué hay que hacer y cómo;
  - reglas de CTFd;
  - comandos, consultas KQL y DQL;
  - cuándo pedir confirmación.
- **`skills/`**: 23 skills en el formato estándar *Agent Skills*:
  - **`copa-microsoft-challenge`** y **`copa-dynatrace-challenge`**: los nuestros, el mismo contenido que `context/`.
  - **7 oficiales de Microsoft** ([microsoft/azure-skills](https://github.com/microsoft/azure-skills), MIT): `azure-diagnostics`, `appinsights-instrumentation`, `azure-validate`, `azure-resource-lookup`, `azure-resource-visualizer`, `azure-quotas`, `azure-kusto`.
  - **14 oficiales de Dynatrace** ([Dynatrace/dynatrace-for-ai](https://github.com/Dynatrace/dynatrace-for-ai), Apache-2.0): `dt-dql-essentials`, `dt-obs-problems`, `dt-obs-services`, `dt-obs-tracing`, `dt-obs-logs`, `dt-obs-kubernetes`, `dt-obs-hosts`, `dt-obs-frontends`, `dt-obs-analytics`, `dt-sec-insights`, `dt-sec-contextualization`, `dt-app-notebooks`, `dt-app-dashboards`, `dt-migration`.
- **Carpetas por agente:** `.claude/skills`, `.agents/skills`, `.github/skills`, `.cursor/skills`, `.opencode/skills` y `.gemini/skills` apuntan a `skills/`, así que cada agente las encuentra solo.
- **`.mcp.json`**: el servidor MCP oficial de Azure. Usa tu sesión de `az login`.
- **`mcp/dynatrace.mcp.json`**: el MCP oficial de Dynatrace. Es opcional y necesita un token del tenant; ver `mcp/README.md`.
- **`templates/`**: `EVIDENCE.md` (registro de evidencia para la auditoría) y `ANSWER-CARD.md` (lo que se revisa antes de cada submit).
- **`scripts/preflight.sh`**: revisa que estén instalados Git, Terraform, Azure CLI, .NET 10 y Node, y en qué suscripción estás.
- **`scripts/update-skills.sh`**: vuelve a bajar las skills oficiales.

Las skills que dejé fuera, como `azure-prepare`, `azure-deploy` o las de AKS, empujan a crear infraestructura nueva con `azd`, algo que el reto prohíbe. Si las necesitan, `scripts/update-skills.sh --all` las trae todas.

## Cómo usarlo mañana

```bash
cd ~/dev/hackaton-copa-2026
./scripts/preflight.sh
git clone <repo-IaC> challenge/iac      # los 3 repos que dé la organización
git clone <repo-backend> challenge/backend
git clone <repo-frontend> challenge/frontend
claude        # o codex, copilot, cursor…, abierto en esta carpeta
```

El primer mensaje al agente puede ser:

> «Vamos con el reto de Microsoft. Lee AGENTS.md y la skill copa-microsoft-challenge. Nuestro team_id es <N>.»

## Reglas que el agente ya trae

- Un solo intento por pregunta.
- Nada de comunicación externa.
- Pide confirmación antes de `apply`, de un deploy, de editar código o de cualquier cambio.
- Nunca envía respuestas: arma la answer card y una persona del equipo la revisa y la envía.
