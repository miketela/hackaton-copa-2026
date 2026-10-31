---
name: copa-microsoft-challenge
description: "Context, rules and runbook for the Hackatón Copa 2026 Microsoft/Azure challenge (flight-operations monitoring app on App Service, Terraform, .NET 10 backend, React Native Web frontend, Application Insights, 6 planted errors, CTFd). Load FIRST for any work on the Azure challenge: deploying, diagnosing, fixing, redeploying or answering CTFd questions."
license: Proprietary (team use)
---

# Hackatón Copa 2026 — Microsoft / Azure Challenge: Agent Context

> Load this file as your working context (it can be used as `AGENTS.md`, `CLAUDE.md`, or pasted into a chat).
> Sources: the organizers' talks, slides and workshops (Business IT × Microsoft, Oct 30 2026). Items marked **[VERIFY]** were not fully confirmed; check them against the official narrative.
> The official challenge narrative published on challenge day **overrides anything in this file**.

---

## 1. Your role

You are an engineering assistant for one 4-person team. The team receives a broken web platform and must, with a DevOps cycle:

1. Deploy the infrastructure.
2. Publish the frontend and backend.
3. Diagnose and fix **6 planted errors (E1–E6)**.
4. Redeploy after each fix.
5. Answer the scoring questions in **CTFd**.

You **may run commands, read and edit code, and query telemetry**, but you **must ask a human for explicit confirmation before any action in §8 (Confirmation gates)**. When in doubt, ask.

You never submit answers in CTFd. You propose an answer with its evidence; a human submits it.

---

## 2. The application: "Centro de Monitoreo de Operaciones de Vuelo"

A web app for ground teams with two features:

1. **Real-time flight status**, with these values: `Programado` (scheduled), `En tránsito` (in transit), `Retrasado` (delayed), `Cancelado` (cancelled), `Aterrizado` (landed).
2. **Health of the supporting services**, with these values: `Disponible` (available), `Degradado` (degraded), `No disponible` (unavailable).

Theme: **DevOps + APIs + Observability on Azure.**

Architecture (two apps, one contract), all inside the team's resource group:

```
Browser ──► Frontend (App Service, SKU B1)          ──HTTPS+JSON──► Backend (App Service, SKU B2)
            React Native Web                                         ASP.NET Core REST API, .NET 10, Linux
            reads API_BASE_URL, calls the API with fetch()           validates origin (CORS), reads App Settings,
                                                                     emits telemetry
                         └──────────── telemetry (requests, dependencies, exceptions, traces) ──► Application Insights
                                                                                                  + Log Analytics workspace
                                                                                                  + Dashboard
```

**Three agreements that must match** (the slide's checklist for "the frontend shows no data"):
1. **Base URL**: the frontend must point to the real backend host.
2. **Allowed origin**: the backend must accept the frontend's exact origin.
3. **Contract**: routes and JSON fields must be identical on both sides.

---

## 3. Event rules that affect how you work

- **AI and the open internet are allowed.** **Communicating with anyone outside the 4 team members is forbidden.** Never suggest contacting an outside person.
- **Attempts per question: plan for ONE.** The Microsoft slide said "2 or 3 attempts depending on complexity", but the later logistics briefing said that **this year every question has a single attempt**. Treat each submission as final.
- **All or nothing:** no partial credit.
- **Hints cost points.** Use them only if truly needed.
- **Grading is automatic. A tie goes to the team that finished first.** Speed matters, but only after accuracy.
- **All teams start at the same time** (countdown in CTFd).
- A human audit team reviews each team's Azure resources and activity and can deduct points after the event if answers were submitted without the actual work. Do the work for real and keep evidence (§10).
- **Answers are exact values**, case-insensitive. For numbers, follow the decimal and thousands separator the question specifies. Before answering, explore the Azure Portal and App Insights, read each question carefully and respect the exact answer format.

### CTFd scoring: 880 points in 7 categories (the 6 errors are worth 600)

| Cat | Topic | Points |
|---|---|---|
| 1 | Access & start | 30 |
| 2 | IaC deployment | 90 |
| 3 | Errors E1–E3 | 180 |
| 4 | Error E4 | 125 |
| 5 | Error E5 | 120 |
| 6 | Error E6 | 175 |
| 7 | DevOps / Azure theory | 150 |

**Categories 3–6 are chained:** each opens only after the previous one is completed. The errors are sequential, with increasing difficulty; E(n) may only become visible after E(n−1) is fixed. **Category 7 (theory) does not depend on the chain**, so one team member can work it in parallel ([VERIFY] that it is open from the start).

---

## 4. Scope

**In scope**
- Deploy the team's infrastructure.
- Publish the provided frontend and backend.
- Diagnose and fix the 6 errors.
- Answer the questions in CTFd.

**Out of scope (official slide)**
- Developing the application from scratch.
- Changing the business logic.
- **Changing the resource group configuration.**
- **Writing IaC scripts.**

So the fixes are **minimal, targeted edits** to the provided code, its configuration files and the provided Terraform variables or settings, followed by a redeploy. If a fix seems to require new scripts or new business logic, you are probably looking at the wrong cause: re-check the evidence.

---

## 5. Environment and access

| Item | Details |
|---|---|
| Tenant / subscription | "Tenant Hackathon · Suscripción 1", **shared by all teams** |
| Team resource group | **`rg-team-{id}`**: each team gets a number, which identifies its RG. Slides showed `rg-team-1`, `rg-team-2`, … and also `rg-team-047`. **Copy the exact name from the invitation or portal.** |
| Permissions | **Contributor only on your own RG.** No access to other teams' RGs or to tenant configuration. Anything outside the RG fails with authorization errors; that is expected, not a bug to fix. |
| Resources in the RG | Frontend App Service (B1), backend App Service (B2), Application Insights, Log Analytics workspace, Dashboard. App Service Plans are **shared** across teams (the Terraform reads the plan with a `data` source; there are 60 shared plans for 240 App Services). Do not try to create or modify plans. |
| Example names | backend `team-47-api` (`https://team-47-api.azurewebsites.net`), RG `rg-team-047`. The frontend name is likely similar ([VERIFY], e.g. `team-47-web`). |
| Repositories | **3 public GitHub repos, shared by all teams:** **IaC (Terraform)**, **Frontend**, **Backend**. They are the source of what you deploy. |
| CTFd | Shared scoring platform with a global scoreboard. Its URL is shown on screens on the day. Login: registration email + generic password; change the password on first login. |
| Identity | Teams sign in as **B2B guests** with the **Hotmail/Outlook account registered with Copa**. **Sign-in without MFA works only from the venue network**; outside it, access is blocked. |
| Who signs in | **Only 1, at most 2, people per team, each with their own account, one at a time, never simultaneously.** Simultaneous sign-ins from several places trigger alerts and blocks. Never share user, password or MFA codes, even within the team. |
| Invitation | Look for the Azure invitation email (check Spam). **Accept it on event day, when the narrative says so.** If it did not arrive or expired, tell the organizers; never use someone else's access. |
| Not in this challenge | Key Vault. |

### First commands (read-only)

```bash
az account show -o table                 # are we in "Suscripción 1" of the hackathon tenant?
az account list -o table                 # if not, find it
az account set --subscription "<hackathon subscription>"
az group show -n rg-team-<id> -o table   # the team RG is visible
az resource list -g rg-team-<id> -o table
```

---

## 6. The challenge cycle, with the organizers' time estimates

| Step | Time | What |
|---|---|---|
| 1. Deploy infrastructure | 15–30 min | Terraform **from Azure Cloud Shell**: creates App Services, App Insights and the Log Analytics workspace |
| 2. Publish the apps | 15–30 min | Backend and frontend to their App Services: ZIP, GitHub, Azure DevOps or local |
| 3. Diagnose | 10–20 min per error | Exceptions and traces in App Insights; browser Network tab and console |
| 4. Fix and redeploy | iterative | Adjust configuration or code; `dotnet build` / `npm run build`; redeploy |
| 5. Answer in CTFd | throughout | Answer as you progress; the scoreboard is live |

**Steps 3 and 4 repeat for E1 … E6.**

### 6.1 Step 1: Terraform (IaC repo, Azure Cloud Shell)

The template is parameterized by `team_id` (a number):

```bash
terraform init                         # downloads providers (azurerm)
terraform plan  -var="team_id=<id>"    # READ: "X to add, Y to change, Z to destroy"
terraform apply -var="team_id=<id>"    # GATE: human confirmation
terraform output                       # names and URLs of what was created
```

The backend resource in the template looks like this (illustrative excerpt from the slides):

```hcl
variable "team_id" { type = number }

resource "azurerm_linux_web_app" "backend" {
  name                = "team-${var.team_id}-api"
  resource_group_name = azurerm_resource_group.team.name
  service_plan_id     = data.azurerm_service_plan.backend.id
  site_config { application_stack { dotnet_version = "10.0" } }
  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.team.connection_string
    "ASPNETCORE_ENVIRONMENT"                = "Production"
  }
}
```

Rules:
- **Use the correct `team_id`.** A wrong ID means touching or creating resources outside your RG, which fails with authorization errors.
- **Read the plan summary every time.** Any unexpected `destroy` or `change` stops the work until a human reviews it.
- **Never fix infrastructure in the portal.** A portal fix is reverted by the next apply, and changing RG configuration is out of scope anyway.
- **The state file (`.tfstate`) is Terraform's memory: never edit it, delete it or commit it.** In Cloud Shell, keep working from the same folder so the state persists.
- **Do not run `terraform destroy` during the challenge** unless the narrative says so.
- If apply fails halfway, what was created stays. Fix the cause, then `plan` and `apply` again.
- `terraform validate` only checks syntax. Azure can still reject the deployment (permissions, quota, region, names).

**App Settings are injected by Terraform.** Application Insights receives telemetry from the first deploy thanks to the connection string that Terraform puts in App Settings. If the IaC defines a variable, the code must read **exactly the same name**.

### 6.2 Step 2: Publish the backend (.NET 10)

Manual redeploy as shown in the slides ("during the challenge"):

```bash
dotnet build
dotnet test                      # if tests exist
dotnet publish -c Release -o out
cd out && zip -r ../app.zip . && cd ..
# GATE:
az webapp deploy \
  --resource-group rg-team-<id> \
  --name team-<id>-api \
  --src-path app.zip --type zip
```

The Azure DevOps pipeline equivalent (`azure-pipelines.yml`): trigger on `main`, run `dotnet publish -c Release -o out`, deploy with `AzureWebApp@1` (`appName: 'team-<id>-api'`, `package: 'out'`), then smoke test with `curl -f https://team-<id>-api.azurewebsites.net/health`.

### 6.3 Step 2: Publish the frontend (React Native Web)

```bash
npm install
npm run build        # check the README for the exact build script and output folder [VERIFY]
# zip the build output, then (GATE):
az webapp deploy -g rg-team-<id> -n <frontend-app-name> --src-path web.zip --type zip
```

`API_BASE_URL` must be the real backend URL (`https://team-<id>-api.azurewebsites.net`). Check **how** the frontend reads it: from App Settings at runtime, or **baked in at build time**. If it is baked in, editing App Settings does nothing: rebuild and redeploy.

### 6.4 Smoke tests after every deploy

The backend **contract** (the slides say these are "the same endpoints as the challenge backend"):

| Method | Route | Purpose | Expected |
|---|---|---|---|
| GET | `/health` | Liveness: does the process respond? | `200 OK`; `500` if startup failed |
| GET | `/health/deep` | Readiness: are dependencies and configuration OK? | `200 Healthy`; `503` / degraded state otherwise |
| GET | `/api/products` | List the catalog | `200` + JSON; `500` on internal error |
| POST | `/api/products` | Create an item | `201 Created`; `400 Bad Request` |
| GET | `/api/status` | Final validation: ready for production? | `200 {"ready": true \| false}` |

**[VERIFY]** In the flight app the resource is likely flights or services instead of `products`. Map the same pattern to the real routes in the backend repo (Swagger file, controllers).

```bash
curl -i https://team-<id>-api.azurewebsites.net/health
curl -i https://team-<id>-api.azurewebsites.net/health/deep
curl -i https://team-<id>-api.azurewebsites.net/api/status      # goal: {"ready": true}
curl -i https://team-<id>-api.azurewebsites.net/api/<resource>
```

**Swagger is usually disabled in Production**, so use `curl -i`, Postman or the browser, and check the HTTP code **and** the body.

Frontend check: open it with **DevTools → Network + Console** and "Preserve log" on. You should see no CORS errors and no 4xx/5xx, and the flights and service health should render.

**Target end state: production-ready.** `/health` returns 200, `/health/deep` is Healthy, `/api/status` returns `ready: true`, the frontend shows data, and App Insights receives telemetry.

---

## 7. Diagnosis

### 7.1 Method: never jump to a hypothesis without evidence

Organizers framed it as SRE mentality: diagnosis by evidence. The workshop framework:

1. **Symptom.** What fails, for whom, since when, always or intermittently.
2. **Evidence.** HTTP codes, console, Network tab, App Insights, log stream, configuration.
3. **Hypothesis.** One probable cause that follows from the evidence.
4. **Verification.** Change **one thing at a time**, then re-test.
5. **Fix.** Fix in code or configuration, redeploy, and validate with evidence.

If the hypothesis fails, go back to step 2. A charla slide mentions a **6-step** framework ("Operación Bajo Presión"); the extra step is likely validation or a post-mortem [VERIFY].

What each signal tells you:
- **Metrics tell you WHAT is wrong** (error rate, latency, CPU).
- **Traces tell you WHERE** (the request's path between services).
- **Logs tell you WHY** (exceptions, messages, stack traces).

### 7.2 "Compiles ≠ works in production": the 4 families of causes

User symptom: *"the page loads… but the products / flights don't appear."* One symptom can have many causes; observing beats guessing.

| Family | Typical cause | Where to look |
|---|---|---|
| **Configuration** | Variable with a different name; wrong environment | App Settings vs. what the code reads; `ASPNETCORE_ENVIRONMENT`; `appsettings.{Env}.json` |
| **Integration** | Wrong backend URL; different route or contract | Frontend `API_BASE_URL`; Network tab (404s, wrong host); routes and JSON field names on both sides |
| **Web security** | CORS blocks the browser even though the API responds | Console "blocked by CORS policy"; preflight `OPTIONS`; `Cors:AllowedOrigins` |
| **Operational validation** | The app responds but is not ready | `/health/deep`, `/api/status`, feature flags |

### 7.3 Prime suspects in the backend code

The organizers showed this `Program.cs`. Compare the challenge's version against it line by line:

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddMediatR(cfg =>
    cfg.RegisterServicesFromAssembly(typeof(Program).Assembly));
builder.Services.AddSingleton<IProductRepository, InMemoryProductRepository>();

// Telemetry to Application Insights
builder.Services.AddApplicationInsightsTelemetry();
// Allowed origins read from configuration
builder.Services.AddCors(o => o.AddPolicy("front", p => p
    .WithOrigins(builder.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>()!)
    .AllowAnyHeader().AllowAnyMethod()));
builder.Services.AddSwaggerGen();

var app = builder.Build();
if (app.Environment.IsDevelopment()) { app.UseSwagger(); app.UseSwaggerUI(); }
app.UseCors("front");
app.MapControllers();
app.Run();
```

Checklist:
1. **`AddApplicationInsightsTelemetry()` present, and `APPLICATIONINSIGHTS_CONNECTION_STRING` set in App Settings with that exact name.** Without both there is no telemetry and no other error can be diagnosed. If App Insights is empty, fix this first.
2. **CORS:**
   - `AddCors` must define the policy, and `UseCors("front")` must use the **same policy name**, placed before `MapControllers`.
   - The origins come from configuration key **`Cors:AllowedOrigins`**. In App Settings on Linux, hierarchy uses a **double underscore** and array index: **`Cors__AllowedOrigins__0 = https://<frontend-host>`**.
   - The value must be the exact frontend origin: scheme + host, with **no trailing slash**.
3. **Dependency injection:** every interface a Handler needs must be registered (e.g. `IProductRepository` → `InMemoryProductRepository`). A missing registration gives `500` errors with "Unable to resolve service for type…".
4. **MediatR:** `RegisterServicesFromAssembly` must point to the assembly that contains the handlers.
5. **Nothing hard-coded ("quemado"):** URLs, CORS origins and flags are read from configuration per environment.
6. **Swagger only in Development**, never exposed in Production.
7. **Environment:** `ASPNETCORE_ENVIRONMENT` decides which `appsettings.{Environment}.json` loads (Terraform sets `Production`). A value that exists only in `appsettings.Development.json` is missing in production.

**Configuration layers** (the last layer wins):

| Priority | Layer |
|---|---|
| lowest | `appsettings.json` (common defaults) |
|  | `appsettings.{Environment}.json` (per environment) |
|  | Environment variables / App Settings (ideally set via Terraform) |
| highest | Command line (occasional use) |

**Golden rules** (from the slides):
- The name must match **exactly**: casing, dashes, suffixes, and no stray spaces.
- `ASPNETCORE_ENVIRONMENT` decides which file is loaded.
- Secrets stay out of the repo (App Settings or Key Vault).
- **If the IaC defines the variable, the code must read the same name.**

**Request path inside the API**: HTTP request → **Controller** (translates HTTP to a Query or Command, no business logic) → **MediatR** (routes the message) → **Handler** (the only class with the use-case logic) → **Repository** (data access, **in memory in the challenge**). CQRS: Queries only read (`GET`); Commands modify (`POST`/`PUT`/`DELETE`). Each has its own handler, in separate folders. **Follow the stack trace to the layer that fails.**

```csharp
[ApiController]
[Route("api/products")]
public class ProductsController : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> Get(CancellationToken ct)
        => Ok(await _mediator.Send(new GetProductsQuery(), ct));
}
```

Check the routes (`[Route]`, `[HttpGet]`), the HTTP verbs (queries are `GET`, not `POST`), the status codes, the JSON field names and types, and pagination. A changed field name or type breaks the frontend silently.

**Capacity** ("Black Friday": an app with 2 GB of RAM and 1,000 users saturates). If the evidence shows saturation, that is plan or scale territory, which is out of scope for the team (shared plans). Report it rather than change it [VERIFY].

### 7.4 Status codes

| Code | Meaning | Look at |
|---|---|---|
| 400 | Malformed request | Payload or params |
| 401 / 403 | Not authenticated / not allowed | Credentials, roles |
| 404 | Route or resource does not exist | URL, `[Route]`, `API_BASE_URL` |
| 500 | Unhandled exception | `exceptions` table, stack trace, DI |
| 503 | Unavailable / degraded | `/health/deep`, dependencies |
| (blocked:cors) | Browser blocked the response | CORS config (backend logs show **no** error) |

### 7.5 KQL (Application Insights / Log Analytics)

Classic table names are shown below. Workspace-based resources may use `AppRequests`, `AppExceptions`, `AppDependencies` and `AppTraces` with `TimeGenerated`. Times are **UTC** (Panama = UTC−5).

```kusto
// When did failures start?
requests
| where timestamp > ago(1h) and success == false
| summarize failures = count() by bin(timestamp, 5m)
| order by timestamp asc

// Which endpoint fails, and with what code?
requests
| where timestamp > ago(24h) and success == false
| summarize failures = count() by name, resultCode
| order by failures desc

// Top exceptions
exceptions
| where timestamp > ago(24h)
| summarize total = count() by type, outerMessage
| order by total desc
| take 10

// Failing dependencies
dependencies
| where timestamp > ago(24h) and success == false
| summarize count() by target, type, resultCode

// Failed request + its exception
requests
| where timestamp > ago(1h) and success == false
| join kind=inner (exceptions) on operation_Id
| project timestamp, name, resultCode, type, outerMessage

// App logs by severity
traces
| where timestamp > ago(1h) and severityLevel >= 2
| order by timestamp desc
```

---

## 8. Confirmation gates: ask a human first

For each gated action, present: what you will run, why (the evidence), the expected effect, and how to roll it back. Then wait for an explicit "yes".

- `terraform apply` / `destroy` / `import`, or any state operation.
- Any `az` command that creates, modifies, restarts or deletes something (`webapp deploy`, `config appsettings set`, `cors add`, `restart`, `delete`, …).
- Any deploy of the frontend or backend.
- Any code or config edit: show the **diff** first, minimal and on a `fix/<error>` branch.
- `git push`, merges, history rewrites.
- Proposing a final CTFd answer (§9).
- Signing in to Azure: only the 1–2 designated people, one at a time.

No confirmation needed for read-only work: `az … show/list`, `terraform plan/output`, KQL queries, `curl` GETs, reading files, `dotnet build`, local runs.

**Never:**
- Print or commit secrets.
- Open CORS to `*` or disable security as a "fix" (it can be a short isolated test only if a human approves it).
- Touch anything outside `rg-team-<id>`.
- Change the RG configuration or the shared plans.

---

## 9. Answering in CTFd (plan for one attempt each)

Before a human submits, produce:

```
Question:   <category / id / title>
Answer:     <exact value in the required format>
Evidence:   <query / command / file:line / portal screen>
Confidence: high / medium / low
Format check: units, decimal separator, exact names (case irrelevant), no extra spaces or quotes
```

- Re-read the question: most or least? Name or ID? Which unit? Which time range?
- If confidence is not high, say what evidence is missing and get it first.
- A second team member verifies the answer before submitting.
- Answer each category as soon as it is solved. The chained categories open sooner, and ties go to whoever finished first.

---

## 10. Evidence log

Keep `EVIDENCE.md` (no secrets in it). For each error and each answer, record:
- the time;
- the symptom;
- the query or command used;
- the change made (commit hash);
- before/after validation (HTTP code, screenshot, log).

Mentors or the audit team may ask how you got a result.

Git hygiene from the slides:
- `main` is always deployable.
- Use `fix/<error>` branches.
- Each PR has a single purpose and a small change.
- PR title and description say what changed and why, with before/after evidence.

---

## 11. Suggested team split (team decides)

- **DevOps / infra:** Terraform in Cloud Shell, deployments. One of the max-2 Azure users.
- **Backend:** .NET code, App Insights, KQL.
- **Frontend / integration:** React Native Web config, `API_BASE_URL`, DevTools, CORS.
- **CTFd + theory:** reads the narrative, works **Cat 7 (DevOps/Azure theory, 150 pts)** in parallel, and double-checks every answer card before submit.

The Microsoft and Dynatrace challenges are **independent**; they open and close at the same time.

---

## 12. Quick reference

```bash
az webapp list -g rg-team-<id> -o table
az webapp config appsettings list -g rg-team-<id> -n <app> -o table
az webapp cors show -g rg-team-<id> -n <app>
az webapp log tail -g rg-team-<id> -n <app>
az webapp show -g rg-team-<id> -n <app> --query "{state:state, host:defaultHostName}"

git switch -c fix/e<n>-<short-name>
git commit -m "fix(e<n>): <what and why>"
```

**Kudu** (`https://<app>.scm.azurewebsites.net`) shows the deployed files (`site/wwwroot`). Use it to confirm what is really deployed, for example a base URL baked into the frontend build.

**DevOps theory refresher for Cat 7:**
- **DevOps** = culture + practices + tools. A shared dev/ops responsibility, not a role or a tool.
- **Git** gives traceability; **GitHub** adds PRs, reviews and Actions.
- **IaC** gives repeatability, traceability and review. Terraform is declarative and idempotent; the state is its memory; `init` / `plan` / `apply` / `destroy`.
- **API First:** the contract (OpenAPI) is agreed first, and front and back work in parallel with mocks. A good contract reduces integration errors, the most common cause of "the frontend shows no data".
- **REST principles:**
  - Resources are nouns (`/products`).
  - HTTP verbs keep their semantics (GET reads, POST creates).
  - Status codes are honest.
  - JSON is the format.
  - Requests are stateless.
- **App Service plans:** B1 / B2 are Basic. Deployment slots and autoscale start at Standard.
- **Observability:** metrics say what, traces say where, logs say why.
- **CI/CD flow:**
  - Commit or PR to `main` triggers the pipeline.
  - Build and test: `dotnet build`, `dotnet test`, `dotnet publish`, plus `npm build` for the frontend.
  - `terraform plan` then `terraform apply` with approval.
  - Deploy the zip.
  - Smoke test: `/health` must return 200, or the pipeline fails.
