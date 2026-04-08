-- PrecisionCare Seed Data
-- Sample data for development and testing

USE PrecisionCareDB;
GO

-- Seed Users (passwords stored plain text - intentional legacy issue)
-- Passwords: admin123, staff123, readonly123
INSERT INTO [dbo].[Users] ([Username], [Password], [FullName], [Email], [Role])
VALUES
    ('admin',    'admin123',    'System Administrator', 'admin@precisioncare.local',    'Admin'),
    ('jdoe',     'staff123',    'Jane Doe',             'jdoe@precisioncare.local',     'Staff'),
    ('msmith',   'staff123',    'Mark Smith',           'msmith@precisioncare.local',   'Staff'),
    ('readonly', 'readonly123', 'Read Only User',       'readonly@precisioncare.local', 'ReadOnly');
GO

-- Seed Patients
INSERT INTO [dbo].[Patients] ([FirstName], [LastName], [DateOfBirth], [Gender], [Email], [Phone], [Address], [City], [State], [ZipCode], [InsuranceID], [Notes], [CreatedBy])
VALUES
    ('Robert',  'Johnson',   '1965-03-12', 'Male',   'rjohnson@email.com',  '555-0101', '123 Oak Street',    'Springfield', 'IL', '62701', 'INS-10012', 'Patient has a known penicillin allergy.', 1),
    ('Mary',    'Williams',  '1978-07-24', 'Female', 'mwilliams@email.com', '555-0102', '456 Maple Ave',     'Springfield', 'IL', '62702', 'INS-10034', 'Diabetic - monitor blood sugar levels.',  1),
    ('James',   'Brown',     '1990-11-05', 'Male',   'jbrown@email.com',    '555-0103', '789 Pine Road',     'Springfield', 'IL', '62703', 'INS-20078', NULL,                                      2),
    ('Patricia','Davis',     '1955-01-30', 'Female', 'pdavis@email.com',    '555-0104', '321 Elm Street',    'Shelbyville', 'IL', '62565', 'INS-30056', 'Hypertension - on medication.',           2),
    ('Michael', 'Miller',    '1982-09-18', 'Male',   NULL,                  '555-0105', '654 Cedar Blvd',    'Springfield', 'IL', '62704', NULL,        'No insurance on file.',                   3),
    ('Linda',   'Wilson',    '1971-04-08', 'Female', 'lwilson@email.com',   '555-0106', '987 Birch Lane',    'Capital City','IL', '62906', 'INS-40091', NULL,                                      3),
    ('William', 'Moore',     '1948-12-22', 'Male',   'wmoore@email.com',    '555-0107', '111 Walnut Court',  'Springfield', 'IL', '62701', 'INS-50023', 'Heart condition - cardiologist referral.', 1),
    ('Barbara', 'Taylor',    '2001-06-15', 'Female', 'btaylor@email.com',   '555-0108', '222 Poplar Drive',  'Shelbyville', 'IL', '62565', 'INS-60047', NULL,                                      2);
GO

-- Seed Appointments
INSERT INTO [dbo].[Appointments] ([PatientID], [AppointmentDate], [Duration], [Reason], [Status], [ProviderName], [Notes], [CreatedBy])
VALUES
    (1, DATEADD(day, -30, GETDATE()), 30, 'Annual physical exam',              'Completed', 'Dr. Sarah Connor', 'All vitals normal.',         1),
    (2, DATEADD(day, -14, GETDATE()), 45, 'Diabetes follow-up',                'Completed', 'Dr. Sarah Connor', 'A1C improved to 7.2.',       1),
    (3, DATEADD(day,  -7, GETDATE()), 30, 'Upper respiratory infection',        'Completed', 'Dr. John Miles',   'Prescribed antibiotics.',    2),
    (4, DATEADD(day,   1, GETDATE()), 30, 'Blood pressure check',              'Scheduled', 'Dr. Sarah Connor', NULL,                         2),
    (5, DATEADD(day,   3, GETDATE()), 60, 'New patient consultation',          'Scheduled', 'Dr. John Miles',   NULL,                         3),
    (1, DATEADD(day,   7, GETDATE()), 30, 'Follow-up on lab results',          'Scheduled', 'Dr. Sarah Connor', NULL,                         1),
    (7, DATEADD(day,  -5, GETDATE()), 45, 'Cardiac evaluation',                'Completed', 'Dr. Rachel Green',  'Referred to cardiologist.', 1),
    (6, DATEADD(day,  10, GETDATE()), 30, 'Routine check-up',                  'Scheduled', 'Dr. John Miles',   NULL,                         3),
    (2, DATEADD(day, -60, GETDATE()), 30, 'Medication review',                 'Cancelled', 'Dr. Sarah Connor', 'Patient no-showed.',         1),
    (8, DATEADD(day,  14, GETDATE()), 30, 'Sports physical',                   'Scheduled', 'Dr. John Miles',   NULL,                         2);
GO
