-- PrecisionCare Database Schema
-- Legacy database for the Classic ASP application

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'PrecisionCareDB')
BEGIN
    CREATE DATABASE PrecisionCareDB;
END
GO

USE PrecisionCareDB;
GO

-- Users table (NOTE: passwords stored as plain text - security issue to fix)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Users] (
        [UserID]    INT           IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Username]  VARCHAR(50)   NOT NULL UNIQUE,
        [Password]  VARCHAR(100)  NOT NULL,   -- Plain text password storage - DO NOT do this in modern app
        [FullName]  VARCHAR(100)  NOT NULL,
        [Email]     VARCHAR(150)  NOT NULL,
        [Role]      VARCHAR(20)   NOT NULL DEFAULT 'Staff',  -- Admin, Staff, ReadOnly
        [IsActive]  BIT           NOT NULL DEFAULT 1,
        [CreatedAt] DATETIME      NOT NULL DEFAULT GETDATE(),
        [LastLogin] DATETIME      NULL
    );
END
GO

-- Patients table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Patients]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Patients] (
        [PatientID]    INT           IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [FirstName]    VARCHAR(50)   NOT NULL,
        [LastName]     VARCHAR(50)   NOT NULL,
        [DateOfBirth]  DATE          NOT NULL,
        [Gender]       VARCHAR(10)   NOT NULL,
        [Email]        VARCHAR(150)  NULL,
        [Phone]        VARCHAR(20)   NULL,
        [Address]      VARCHAR(250)  NULL,
        [City]         VARCHAR(100)  NULL,
        [State]        VARCHAR(50)   NULL,
        [ZipCode]      VARCHAR(10)   NULL,
        [InsuranceID]  VARCHAR(50)   NULL,
        [Notes]        TEXT          NULL,
        [CreatedAt]    DATETIME      NOT NULL DEFAULT GETDATE(),
        [UpdatedAt]    DATETIME      NULL,
        [CreatedBy]    INT           NULL REFERENCES [dbo].[Users]([UserID])
    );
END
GO

-- Appointments table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Appointments]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Appointments] (
        [AppointmentID]   INT           IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [PatientID]       INT           NOT NULL REFERENCES [dbo].[Patients]([PatientID]),
        [AppointmentDate] DATETIME      NOT NULL,
        [Duration]        INT           NOT NULL DEFAULT 30,  -- minutes
        [Reason]          VARCHAR(500)  NOT NULL,
        [Status]          VARCHAR(20)   NOT NULL DEFAULT 'Scheduled',  -- Scheduled, Completed, Cancelled, NoShow
        [ProviderName]    VARCHAR(100)  NOT NULL,
        [Notes]           TEXT          NULL,
        [CreatedAt]       DATETIME      NOT NULL DEFAULT GETDATE(),
        [CreatedBy]       INT           NULL REFERENCES [dbo].[Users]([UserID])
    );
END
GO
