# PrecisionCare Developer Modernization Assessment

## Overview

Welcome to the **PrecisionCare Developer Modernization Assessment**. This repository contains a classic ASP (Active Server Pages) web application that simulates a real-world legacy patient management system. Your task is to **modernize** this application by converting it to a **.NET Core Web API** back-end and an **Angular** front-end.

This assessment evaluates your ability to:

- Identify and remediate security vulnerabilities in legacy code
- Design and implement a RESTful Web API using .NET Core
- Build a responsive Angular front-end using **Reactive Forms**
- Follow modern development best practices

---

## The Legacy Application

The `classic-asp/` directory contains a Classic ASP patient management system for a fictional healthcare organization called PrecisionCare. The application allows staff to:

- Log in and manage sessions
- View, search, add, edit, and delete patients
- View and add appointments for patients

### Known Issues in the Legacy Code

The legacy code contains multiple deliberate security vulnerabilities and poor practices. **Your modernized application must identify and fix all of them.** Issues include (but are not limited to):

| # | Vulnerability / Issue | Location(s) |
|---|----------------------|-------------|
| 1 | **SQL Injection** – user input is concatenated directly into SQL queries with no parameterization | `login.asp`, `patients.asp`, `patient_add.asp`, `patient_edit.asp`, `patient_detail.asp`, `appointments.asp`, `appointment_add.asp` |
| 2 | **Plain-text password storage** – passwords are stored and compared in plain text | `database/schema.sql`, `database/seed.sql`, `login.asp` |
| 3 | **Cross-Site Scripting (XSS)** – user-supplied data is rendered in HTML without encoding | All `.asp` pages |
| 4 | **Missing authentication checks** – most pages do not verify the user is logged in | `patients.asp`, `patient_detail.asp`, `patient_edit.asp`, `patient_add.asp`, `appointments.asp`, `appointment_add.asp` |
| 5 | **Missing authorization checks** – any authenticated user can modify any record regardless of role | All data-mutation pages |
| 6 | **Hardcoded database credentials** – connection string with `sa` credentials is hardcoded in `global.asa` | `global.asa` |
| 7 | **No CSRF protection** – state-changing operations (add, edit, delete) are not protected against cross-site request forgery | All form pages |
| 8 | **Session fixation** – session ID is not regenerated after a successful login | `login.asp` |
| 9 | **GET-based delete** – records can be deleted via a plain link (GET request), enabling CSRF via URL | `patients.asp` |
| 10 | **No input validation** – date formats, integer fields, required fields are not validated server-side | `patient_add.asp`, `patient_edit.asp`, `appointment_add.asp` |

---

## Your Task

Fork this repository and implement the following:

### 1. .NET Core Web API (`/api`)

Create a .NET Core 8 Web API project in the `/api` directory that exposes the following endpoints:

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
- Use **parameterized queries** or an ORM (e.g., Entity Framework Core) to prevent SQL injection — **never** concatenate user input into SQL strings
- Hash passwords using **bcrypt** or **ASP.NET Core Identity**'s password hasher before storing; compare hashes on login
- Protect all endpoints (except `/api/auth/login`) with **JWT Bearer authentication**
- Implement **role-based authorization** where applicable (e.g., only `Admin` can delete patients)
- Return appropriate HTTP status codes (`200`, `201`, `400`, `401`, `403`, `404`, `409`, etc.)
- Validate all incoming request payloads using **Data Annotations** or **FluentValidation**
- Do not store secrets (connection strings, JWT keys) in source code — use environment variables or `appsettings.json` with user secrets for local development

### 2. Angular Front-End (`/frontend`)

Create an Angular 17+ project in the `/frontend` directory that replicates all the functionality of the Classic ASP application.

#### Requirements
- **All forms must be implemented using Angular Reactive Forms** (`ReactiveFormsModule` / `FormBuilder`) — template-driven forms are not acceptable
- Each form must include:
  - Client-side validation with visible error messages
  - Proper use of `Validators` (required, email, pattern, min/max, etc.)
  - Form state management (pristine/dirty/touched/valid indicators)
- Use the **Angular HTTP Client** to communicate with the .NET Core API
- Implement **JWT-based authentication**: store the token securely, attach it to outgoing requests via an HTTP interceptor, and redirect to login when receiving a `401`
- Create the following pages/components:
  - **Login page**
  - **Patient list** (with search)
  - **Patient detail** (view-only with appointment history)
  - **Add / Edit patient form** (reactive form)
  - **Appointment list** (with status and date filters)
  - **Add appointment form** (reactive form)
- Use a consistent layout with a navigation bar that shows the logged-in user and a logout button
- Handle and display API errors gracefully

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
├── classic-asp/          # Legacy code — do not modify
│   ├── global.asa
│   ├── conn.asp
│   ├── login.asp
│   ├── logout.asp
│   ├── patients.asp
│   ├── patient_detail.asp
│   ├── patient_add.asp
│   ├── patient_edit.asp
│   ├── appointments.asp
│   └── appointment_add.asp
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

### Security (30 points)
- [ ] All SQL injection vulnerabilities are eliminated (parameterized queries / EF Core)
- [ ] Passwords are hashed, not stored in plain text
- [ ] JWT authentication is implemented and enforced
- [ ] XSS prevention (Angular escapes output by default; API does not echo raw HTML)
- [ ] CSRF protection (stateless JWT + Angular's HttpClient handles this for API calls)
- [ ] Input validation on both the API and client side
- [ ] No secrets committed to source code

### API Design & Quality (25 points)
- [ ] RESTful endpoint design with correct HTTP verbs and status codes
- [ ] Proper error handling and meaningful error responses
- [ ] Request model validation
- [ ] Role-based authorization
- [ ] Clean, readable, and well-organized code

### Angular Front-End (25 points)
- [ ] **All forms use Reactive Forms** (this is a hard requirement)
- [ ] Form validation with user-friendly error messages
- [ ] JWT auth flow (login → token storage → interceptor → protected routes)
- [ ] Consistent UI/UX matching the feature set of the legacy app
- [ ] Proper error handling for API failures

### Code Quality & Practices (15 points)
- [ ] Project structure is clean and follows conventions for each technology
- [ ] No dead code or debugging artifacts
- [ ] Meaningful commit history
- [ ] `README.md` updated with instructions on how to run the project locally
- [ ] Environment configuration is handled properly (no secrets in source)

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

### Running the Legacy Application (optional reference)

The `classic-asp/` files are provided as reference only. They require IIS with Classic ASP enabled and a SQL Server database configured using the scripts in `database/`. You do not need to run the legacy app — review the source code to understand the features and data model.

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
