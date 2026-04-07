<%
' patient_detail.asp - View patient details and appointment history
' SECURITY ISSUES:
'   1. Missing authentication check
'   2. SQL Injection: PatientID from querystring concatenated directly into query
'   3. XSS: all patient fields echoed without HTML encoding
'   4. No authorization check - any logged-in user (or unauthenticated user) can view any patient
%>
<!-- #include file="conn.asp" -->
<%
' NOTE: No authentication check
' If Session("UserID") = "" Then Response.Redirect "login.asp"

Dim patientID, sql, conn, rs

' SQL INJECTION: PatientID is never validated to be a number
patientID = Request.QueryString("id")

If patientID = "" Then
    Response.Redirect "patients.asp"
End If

Set conn = GetConnection()

' SQL INJECTION VULNERABILITY
sql = "SELECT * FROM Patients WHERE PatientID = " & patientID
Set rs = conn.Execute(sql)

If rs.EOF Then
    Response.Write "<p>Patient not found.</p>"
    Response.End
End If

' SQL INJECTION VULNERABILITY: appointment query uses same unsanitized patientID
Dim apptSql, apptRs
apptSql = "SELECT * FROM Appointments WHERE PatientID = " & patientID & " ORDER BY AppointmentDate DESC"
Set apptRs = conn.Execute(apptSql)
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PrecisionCare - Patient Detail</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f0f4f8; }
        .navbar { background: #2c3e50; color: #fff; padding: 12px 24px; display: flex; justify-content: space-between; align-items: center; }
        .navbar a { color: #fff; text-decoration: none; margin-left: 16px; font-size: 14px; }
        .container { max-width: 900px; margin: 30px auto; padding: 0 20px; }
        h1, h2 { color: #2c3e50; }
        .card { background: #fff; border-radius: 8px; padding: 24px; box-shadow: 0 1px 6px rgba(0,0,0,0.1); margin-bottom: 24px; }
        .field-row { display: flex; margin-bottom: 12px; }
        .field-label { width: 160px; font-weight: bold; color: #555; font-size: 14px; }
        .field-value { color: #333; font-size: 14px; }
        .btn { display: inline-block; padding: 8px 16px; border-radius: 4px; text-decoration: none; font-size: 14px; margin-right: 8px; }
        .btn-edit { background: #3498db; color: #fff; }
        .btn-back { background: #95a5a6; color: #fff; }
        .btn-add-appt { background: #27ae60; color: #fff; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #ecf0f1; padding: 10px 12px; text-align: left; font-size: 13px; color: #555; }
        td { padding: 9px 12px; border-bottom: 1px solid #eee; font-size: 14px; }
        .status-Scheduled  { color: #2980b9; font-weight: bold; }
        .status-Completed  { color: #27ae60; font-weight: bold; }
        .status-Cancelled  { color: #e74c3c; font-weight: bold; }
        .status-NoShow     { color: #e67e22; font-weight: bold; }
    </style>
</head>
<body>
    <div class="navbar">
        <span><strong>PrecisionCare</strong></span>
        <div>
            <a href="patients.asp">Patients</a>
            <a href="appointments.asp">Appointments</a>
            <a href="logout.asp">Logout</a>
        </div>
    </div>
    <div class="container">
        <!-- XSS: All values output without HTML encoding -->
        <h1><%= rs("FirstName") %> <%= rs("LastName") %></h1>
        <div style="margin-bottom: 16px;">
            <a href="patient_edit.asp?id=<%= patientID %>" class="btn btn-edit">Edit Patient</a>
            <a href="appointment_add.asp?patientId=<%= patientID %>" class="btn btn-add-appt">+ Add Appointment</a>
            <a href="patients.asp" class="btn btn-back">Back to List</a>
        </div>
        <div class="card">
            <h2>Patient Information</h2>
            <div class="field-row"><span class="field-label">Patient ID:</span>   <span class="field-value"><%= rs("PatientID") %></span></div>
            <div class="field-row"><span class="field-label">First Name:</span>   <span class="field-value"><%= rs("FirstName") %></span></div>
            <div class="field-row"><span class="field-label">Last Name:</span>    <span class="field-value"><%= rs("LastName") %></span></div>
            <div class="field-row"><span class="field-label">Date of Birth:</span><span class="field-value"><%= rs("DateOfBirth") %></span></div>
            <div class="field-row"><span class="field-label">Gender:</span>       <span class="field-value"><%= rs("Gender") %></span></div>
            <div class="field-row"><span class="field-label">Email:</span>        <span class="field-value"><%= rs("Email") %></span></div>
            <div class="field-row"><span class="field-label">Phone:</span>        <span class="field-value"><%= rs("Phone") %></span></div>
            <div class="field-row"><span class="field-label">Address:</span>      <span class="field-value"><%= rs("Address") %></span></div>
            <div class="field-row"><span class="field-label">City:</span>         <span class="field-value"><%= rs("City") %></span></div>
            <div class="field-row"><span class="field-label">State:</span>        <span class="field-value"><%= rs("State") %></span></div>
            <div class="field-row"><span class="field-label">Zip Code:</span>     <span class="field-value"><%= rs("ZipCode") %></span></div>
            <div class="field-row"><span class="field-label">Insurance ID:</span> <span class="field-value"><%= rs("InsuranceID") %></span></div>
            <div class="field-row"><span class="field-label">Notes:</span>        <span class="field-value"><%= rs("Notes") %></span></div>
        </div>

        <div class="card">
            <h2>Appointments</h2>
            <% If apptRs.EOF Then %>
                <p style="color:#888;">No appointments on record.</p>
            <% Else %>
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Duration</th>
                            <th>Reason</th>
                            <th>Provider</th>
                            <th>Status</th>
                            <th>Notes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% Do While Not apptRs.EOF %>
                            <tr>
                                <!-- XSS on all appointment fields -->
                                <td><%= apptRs("AppointmentDate") %></td>
                                <td><%= apptRs("Duration") %> min</td>
                                <td><%= apptRs("Reason") %></td>
                                <td><%= apptRs("ProviderName") %></td>
                                <td class="status-<%= apptRs("Status") %>"><%= apptRs("Status") %></td>
                                <td><%= apptRs("Notes") %></td>
                            </tr>
                            <% apptRs.MoveNext %>
                        <% Loop %>
                    </tbody>
                </table>
            <% End If %>
        </div>
    </div>
</body>
</html>
<%
rs.Close
apptRs.Close
conn.Close
Set rs     = Nothing
Set apptRs = Nothing
Set conn   = Nothing
%>
