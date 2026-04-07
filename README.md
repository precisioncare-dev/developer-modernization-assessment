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
├── api/                  # NEW: .NET Core Web API project
│   └── ...
├── frontend/             # NEW: Angular project
│   └── ...
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

### Code Quality & Practices (20 points)
- [ ] Project structure is clean and follows conventions for each technology
- [ ] No dead code or debugging artifacts
- [ ] Meaningful commit history
- [ ] `README.md` updated with instructions on how to run the project locally
- [ ] Environment configuration is handled properly (no secrets in source)

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

Once you have built your `/api` and `/frontend` projects, add setup instructions to this README describing:

1. How to set up and seed the database
2. How to configure and run the .NET Core API
3. How to install dependencies and run the Angular front-end
4. Any environment variables required (provide an `.env.example` or `appsettings.example.json`)

---

## Submission

1. Fork this repository
2. Implement the requirements in your fork
3. Ensure your application runs locally end-to-end
4. Submit the link to your fork

Good luck!
