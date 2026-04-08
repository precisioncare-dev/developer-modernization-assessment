# PrecisionCare Developer Modernization Assessment

## Overview

Welcome to the **PrecisionCare Developer Modernization Assessment**. This repository contains a Classic ASP web application that simulates a legacy patient management system for a fictional healthcare organization. Your task is to **modernize** it with a **.NET Core Web API** back-end and an **Angular** front-end.

**The primary skills this assessment evaluates are:**

1. **Angular Reactive Forms** — every data-entry form must use `ReactiveFormsModule` / `FormBuilder` with proper validation, error messages, and form-state management
2. **API Design & Integration** — well-structured REST endpoints consumed cleanly from Angular via `HttpClient` and an auth interceptor
3. **Security** — identifying and fixing the deliberate vulnerabilities present in the legacy code

---

## The Legacy Application

The entire legacy application lives in **one self-contained file**: `classic-asp/app.asp`.  
`classic-asp/global.asa` is the IIS application-level config (loaded automatically; demonstrates hardcoded credentials).

`app.asp` is a single-file Classic ASP app that handles:

- Login / logout (session-based)
- Patient list with name search
- Add patient form
- Edit patient form
- Appointment list with status and date filters
- Add appointment form

Read through `app.asp` carefully — every view and every SQL statement is in one place, making the vulnerabilities easy to spot and cross-reference.

### Deliberate Security Vulnerabilities

All ten issues below are present in `app.asp`. **Your modernized application must fix every one of them.**

| # | Vulnerability | Where in `app.asp` |
|---|---------------|--------------------|
| 1 | **SQL Injection** — input concatenated directly into every SQL statement | Login query, search `LIKE`, INSERT, UPDATE, DELETE |
| 2 | **Plain-text passwords** — compared as raw strings | Login `WHERE Password = '...'` |
| 3 | **XSS** — all DB/form values written to HTML without `Server.HTMLEncode` | Every `<%= %>` expression in HTML context |
| 4 | **Missing authentication checks** — patient list, add, edit, delete skip session check | Every view except login |
| 5 | **Missing authorization checks** — no role verification before delete or edit | `delete-patient` action, edit-patient view |
| 6 | **Hardcoded credentials** — `sa / Admin123!` connection string | `global.asa` (referenced by `GetConnection()`) |
| 7 | **No CSRF protection** — no anti-forgery token on any form | All `<form>` elements and the delete link |
| 8 | **Session fixation** — session not regenerated after login | Login POST handler |
| 9 | **GET-based delete** — delete triggered by a plain `<a href>` link | Patient list "Delete" anchor |
| 10 | **No input validation** — no format, length, or type checks server-side | Add/edit patient form, add appointment form |

---

## Your Task

Fork this repository and implement the following:

### 1. .NET Core Web API (`/api`)

A scaffold is already in place — **your job is to implement the stub service methods and controller action bodies.**

#### Authentication
| Method | Route | Description |
|--------|-------|-------------|
| `POST` | `/api/auth/login` | Authenticate a user, return a JWT token |
| `POST` | `/api/auth/logout` | Invalidate the current session/token |

#### Patients
| Method | Route | Description |
|--------|-------|-------------|
| `GET` | `/api/patients` | List all patients (supports `?search=` query param) |
| `GET` | `/api/patients/{id}` | Get a single patient by ID |
| `POST` | `/api/patients` | Create a new patient |
| `PUT` | `/api/patients/{id}` | Update an existing patient |
| `DELETE` | `/api/patients/{id}` | Delete a patient |

#### Appointments
| Method | Route | Description |
|--------|-------|-------------|
| `GET` | `/api/appointments` | List appointments (supports `?status=` and `?date=` filters) |
| `GET` | `/api/appointments/{id}` | Get a single appointment by ID |
| `GET` | `/api/patients/{id}/appointments` | Get all appointments for a patient |
| `POST` | `/api/appointments` | Create a new appointment |
| `PUT` | `/api/appointments/{id}` | Update an existing appointment |

#### Security Requirements for the API
- Use **Entity Framework Core** (parameterized queries) — never concatenate user input into SQL strings
- Hash passwords with **BCrypt** before storing; compare hashes on login
- Protect all endpoints (except `/api/auth/login`) with **JWT Bearer authentication**
- Implement **role-based authorization** (e.g., only `Admin` can delete patients)
- Return appropriate HTTP status codes (`200`, `201`, `400`, `401`, `403`, `404`, etc.)
- Validate all incoming request payloads using **Data Annotations** or **FluentValidation**
- Do not store secrets in source code — use `appsettings.json` / user secrets for local dev

### 2. Angular Front-End (`/frontend`)

A scaffold is already in place — **your job is to implement the stub components, services, guards, and resolvers.**

> ⭐ **Angular Reactive Forms are the centrepiece of this assessment.** Every data-entry form (login, patient add/edit, appointment add) must be built with `ReactiveFormsModule` / `FormBuilder`. Template-driven forms are not acceptable.

#### Form Requirements (applies to every form)
- Built with `FormBuilder` and a typed `FormGroup`
- Validators applied: `Validators.required`, `Validators.email`, `Validators.pattern`, `Validators.min` / `Validators.max` as appropriate
- Validation error messages shown inline, only after the field is touched or the form is submitted
- Submit button disabled (or form marked invalid) until the form is valid
- Form resets or navigates away cleanly on successful submission

#### Pages / Components to implement
| Feature | Reactive Form? | Notes |
|---------|---------------|-------|
| Login | ✅ Yes | Username + password; `401` shows inline error |
| Patient list | — | Table with search input; delete confirmation |
| **Patient add / edit** | ✅ Yes | All fields from `app.asp`; date of birth; phone pattern |
| Appointment list | — | Status dropdown + date filter |
| **Add appointment** | ✅ Yes | Patient select; date/time; duration (number input); status |

#### Other Angular Requirements
- **JWT auth flow**: store token in `localStorage` or `sessionStorage`, attach via HTTP interceptor, redirect to `/login` on `401`
- **Route guards**: `authGuard` protects all non-login routes; `roleGuard('Admin')` protects the delete action
- **Resolvers**: pre-fetch patient/appointment data before activating edit routes
- **Error handling**: display API error messages gracefully in the UI
- Consistent layout with the `NavbarComponent` showing the logged-in user and a Logout button

### 3. Database

Use the schema in `database/schema.sql` as the baseline. You may:
- Migrate to **Entity Framework Core** with Code First migrations
- Modify the schema as needed (e.g., add a `PasswordHash` column, replace the `Password` column)
- Keep the seed data representative of the original `database/seed.sql`

---

## Project Structure

Your submission should follow this structure:

```
developer-modernization-assessment/
├── classic-asp/          # Legacy reference — do not modify
│   ├── global.asa        # IIS app-level config; hardcoded credentials (vulnerability #6)
│   └── app.asp           # Single-file legacy app — all 10 vulnerabilities in one place
├── database/
│   ├── schema.sql        # Original schema
│   └── seed.sql          # Sample data
├── api/                  # .NET Core 8 Web API scaffold
│   ├── Controllers/      # Stub controllers (route/auth attributes set; action bodies TBD)
│   ├── Data/             # AppDbContext — fully configured EF Core context
│   ├── DTOs/             # Request/response models (complete)
│   ├── Models/           # User, Patient, Appointment entities (complete)
│   ├── Services/         # Interfaces (complete) + stub implementations (bodies TBD)
│   ├── Program.cs        # DI, JWT, CORS, Swagger — fully wired (do not modify)
│   ├── appsettings.json
│   └── appsettings.example.json
├── api.tests/            # xUnit test project — implement the TODO stubs
│   ├── Controllers/
│   │   ├── AuthControllerTests.cs         # HTTP-layer tests for AuthController
│   │   ├── PatientsControllerTests.cs     # HTTP-layer tests for PatientsController
│   │   └── AppointmentsControllerTests.cs # HTTP-layer tests for AppointmentsController
│   ├── Services/
│   │   ├── AuthServiceTests.cs            # Unit tests for AuthService
│   │   ├── PatientServiceTests.cs         # Unit tests for PatientService
│   │   └── AppointmentServiceTests.cs     # Unit tests for AppointmentService
│   └── PrecisionCare.Api.Tests.csproj
├── frontend/             # Angular 19 standalone app scaffold
│   └── src/app/
│       ├── app.config.ts     # Providers wired (do not modify)
│       ├── app.routes.ts     # Routes + guard/resolver wiring (do not modify)
│       ├── core/
│       │   ├── guards/       # auth.guard, role.guard — partial stubs (implement logic)
│       │   ├── interceptors/ # auth.interceptor — partial stub (implement JWT attachment)
│       │   ├── models/       # Typed interfaces (complete)
│       │   ├── resolvers/    # Four stub resolvers (implement data-fetching logic)
│       │   └── services/     # AuthService, PatientService, AppointmentService — stub methods
│       ├── features/
│       │   ├── auth/login/           # Stub component + placeholder template (implement)
│       │   ├── patients/             # Stub components + placeholder templates (implement)
│       │   └── appointments/         # Stub components + placeholder templates (implement)
│       └── shared/
│           ├── components/           # NavbarComponent, LayoutComponent (complete)
│           └── validators/           # pastDateValidator, futureDateValidator, phoneValidator
└── README.md
```

---

## Evaluation Criteria

Your submission will be evaluated on the following:

### Angular Reactive Forms (30 points)
- [ ] **All data-entry forms use `ReactiveFormsModule` / `FormBuilder`** — this is a hard requirement
- [ ] Each form has a typed `FormGroup` with appropriate `FormControl` instances
- [ ] Validators applied correctly: `required`, `email`, `pattern`, `min` / `max`, `minLength` / `maxLength`
- [ ] Validation error messages appear inline next to the offending field, only after the field is touched or the form is submitted
- [ ] Submit button is disabled (or the form is otherwise blocked) while the form is invalid
- [ ] Patient add/edit form covers all fields shown in `app.asp` (including optional fields)
- [ ] Add appointment form validates date format, duration as positive integer, required selections

### API Design & Integration (25 points)
- [ ] RESTful endpoint design with correct HTTP verbs and status codes
- [ ] Angular `HttpClient` calls are clean, typed, and centralized in service classes
- [ ] JWT auth interceptor attaches the `Authorization: Bearer <token>` header to every protected request
- [ ] `authGuard` redirects unauthenticated users to `/login`; `401` responses from the API trigger the same redirect
- [ ] Proper error handling: API errors are caught and surfaced to the user (not swallowed silently)
- [ ] Role-based authorization enforced on the API side

### Security (25 points)
- [ ] All SQL injection vulnerabilities eliminated (EF Core / parameterized queries)
- [ ] Passwords hashed with BCrypt; plain-text comparison removed
- [ ] JWT authentication enforced on all protected endpoints
- [ ] XSS prevention (Angular escapes template output by default; verify no `innerHTML` / `bypassSecurityTrust` misuse)
- [ ] Input validation on both the API (FluentValidation / Data Annotations) and Angular (Validators) sides
- [ ] No secrets committed to source code

### Code Quality & Practices (10 points)
- [ ] Project structure is clean and follows conventions for each technology
- [ ] No dead code or debugging artifacts
- [ ] Meaningful commit history
- [ ] `README.md` updated with instructions on how to run the project locally
- [ ] Environment configuration handled properly (no secrets in source)

### Unit Testing (10 points)
- [ ] All TODO stubs in `api.tests/` are replaced with real test implementations
- [ ] Service tests use an EF Core in-memory database (no live SQL Server required)
- [ ] Controller tests mock all service dependencies with Moq
- [ ] Every test follows the **Arrange / Act / Assert** pattern with clear variable names
- [ ] Tests cover both the happy path and error/edge cases for each method
- [ ] `dotnet test` passes with 0 failures

---

## Getting Started

### Prerequisites

- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [Node.js 20+](https://nodejs.org/) and npm
- [Angular CLI](https://angular.io/cli): `npm install -g @angular/cli`
- SQL Server (local instance, Docker, or SQL Server Express)

### Reading the Legacy Application (reference only)

The `classic-asp/` files are provided as reference only. They require IIS with Classic ASP enabled to run — **you do not need to run them.** Instead, open `classic-asp/app.asp` and read through it. All application logic (login, patient CRUD, appointment management) is in a single file, making it straightforward to see every vulnerability and understand the data model before you build the modern replacement.

### Setting Up the Modern Application

The `/api` and `/frontend` directories contain scaffolded starting points. Follow the steps below to get the projects running, then implement the required functionality.

#### 1. Database

Run the scripts against a local SQL Server instance in order:

```bash
sqlcmd -S localhost -E -i database/schema.sql
sqlcmd -S localhost -E -i database/seed.sql
```

> **Note:** The seed data uses plain-text passwords — one of your first tasks is to hash these using BCrypt and update the schema accordingly.

#### 2. .NET Core API (`api/`)

```bash
cd api

# Copy the example config and fill in your connection string and JWT key
cp appsettings.example.json appsettings.Development.json

dotnet restore
dotnet run
# Swagger UI: https://localhost:5001/swagger
```

**What's already provided:**

| File(s) | Description |
|---|---|
| `PrecisionCare.Api.csproj` | NuGet references: EF Core + SQL Server, JWT Bearer, BCrypt.Net-Next, FluentValidation, Swashbuckle |
| `Program.cs` | DI container, JWT authentication middleware, CORS, and Swagger configured |
| `appsettings.json` / `appsettings.example.json` | Configuration schema with `JwtSettings` and `ConnectionStrings` sections |
| `Data/AppDbContext.cs` | EF Core `DbContext` with `Users`, `Patients`, `Appointments` `DbSet`s |
| `Models/` | Entity classes (`User`, `Patient`, `Appointment`) matching the legacy schema |
| `DTOs/` | Request and response DTO classes for Auth, Patients, and Appointments |
| `Services/I*.cs` | Service interfaces (`IAuthService`, `IPatientService`, `IAppointmentService`) |
| `Services/*.cs` | **Stub** service classes — every method throws `NotImplementedException` with a TODO hint |
| `Controllers/` | **Stub** controllers — route attributes and `[Authorize]` roles are set; action bodies throw `NotImplementedException` |

**Your job:** implement the service methods and controller action bodies. Pay close attention to the security requirements: password hashing, parameterized queries, JWT generation, and role-based authorization.

#### 3. Unit Tests (`api.tests/`)

```bash
cd api.tests
dotnet test
# Runs all 50 test stubs — all skip until you implement them.

# Run with code coverage report:
dotnet test --collect:"XPlat Code Coverage"
```

**What's already provided:**

| File(s) | Description |
|---|---|
| `PrecisionCare.Api.Tests.csproj` | xUnit + Moq + FluentAssertions + Microsoft.AspNetCore.Mvc.Testing |
| `Services/AuthServiceTests.cs` | 5 stub tests covering `LoginAsync` (happy path, wrong password, unknown user, inactive account, JWT claims) |
| `Services/PatientServiceTests.cs` | 10 stub tests covering all 5 `IPatientService` methods including edge cases |
| `Services/AppointmentServiceTests.cs` | 12 stub tests covering all 5 `IAppointmentService` methods including filter combinations |
| `Controllers/AuthControllerTests.cs` | 3 stub tests for HTTP response codes from `AuthController` |
| `Controllers/PatientsControllerTests.cs` | 9 stub tests covering all `PatientsController` actions |
| `Controllers/AppointmentsControllerTests.cs` | 8 stub tests covering all `AppointmentsController` actions |

**Your job:** replace every `throw new NotImplementedException(...)` in `api.tests/` with a real test body. Each stub has a detailed `// TODO:` comment explaining the exact Arrange / Act / Assert steps expected.

> **Tip:** Service tests should use `new DbContextOptionsBuilder<AppDbContext>().UseInMemoryDatabase(Guid.NewGuid().ToString()).Options` so each test gets a fresh, isolated store without a SQL Server connection. Add the `Microsoft.EntityFrameworkCore.InMemory` package to `api.tests` if it is not already present.

#### 4. Angular Front-End (`frontend/`)

```bash
cd frontend
npm install
npx ng serve
# App: http://localhost:4200
```

**What's already provided:**

| File(s) | Description |
|---|---|
| `package.json` | Angular 19, RxJS, zone.js dependencies |
| `src/app/app.config.ts` | `provideRouter`, `provideHttpClient` with the auth interceptor, and `provideAnimations` wired up |
| `src/app/app.routes.ts` | Full route tree with `canActivate: [authGuard]`, `canActivate: [roleGuard('Admin','Staff')]`, and `resolve:` keys attached — wiring is complete; **implement the guard/resolver bodies** |
| `src/environments/` | `environment.ts` and `environment.prod.ts` with `apiUrl` |
| `src/styles.scss` | Global SCSS utilities (card, btn, alert, form-field, table) |
| `core/models/` | Typed interfaces for `User`, `Patient`, `Appointment` |
| `core/services/` | **Stub** `AuthService`, `PatientService`, `AppointmentService` — class structure and method signatures are defined; **implement the bodies** |
| `core/guards/auth.guard.ts` | **Partial stub** — redirects to `/login` when not authenticated; **complete the `returnUrl` query param handling** |
| `core/guards/role.guard.ts` | **Partial stub** — auth check structure in place; **implement the role check** |
| `core/interceptors/auth.interceptor.ts` | **Partial stub** — 401 handler skeleton present; **implement JWT token attachment** |
| `core/resolvers/` | **Stub** resolvers with JSDoc hints — **implement the data-fetching logic** |
| `features/**/` | **Stub** component classes (imports declared, TODO comments guide implementation) and **placeholder HTML templates** — **implement Reactive Forms, data binding, and validation** |
| `shared/components/` | `NavbarComponent` and `LayoutComponent` (complete — no changes needed) |
| `shared/validators/` | Custom validators: `pastDateValidator`, `futureDateValidator`, `phoneValidator` |

---

## Submission

1. Fork this repository
2. Implement the requirements in your fork
3. Ensure your application runs locally end-to-end
4. Submit the link to your fork

Good luck!
