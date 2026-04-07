<%
' appointment_add.asp - Add a new appointment
' SECURITY ISSUES:
'   1. Missing authentication check
'   2. SQL Injection: all form values concatenated directly into INSERT
'   3. XSS: form values echoed back without HTML encoding
'   4. No input validation (date format, duration as integer, etc.)
'   5. No CSRF protection
'   6. Patient dropdown loaded with SQL injection risk via patientId query param
%>
<!-- #include file="conn.asp" -->
<%
' NOTE: No authentication check
' If Session("UserID") = "" Then Response.Redirect "login.asp"

Dim errorMsg
errorMsg = ""

If Request.Form("submit") = "Save" Then
    Dim patientID, apptDate, duration, reason, status, provider, notes
    Dim conn, sql

    patientID = Request.Form("patientID")
    apptDate  = Request.Form("apptDate")
    duration  = Request.Form("duration")
    reason    = Request.Form("reason")
    status    = Request.Form("status")
    provider  = Request.Form("provider")
    notes     = Request.Form("notes")

    If patientID = "" Or apptDate = "" Or reason = "" Or provider = "" Then
        errorMsg = "Patient, Appointment Date, Reason, and Provider are required."
    Else
        ' SQL INJECTION VULNERABILITY: all values concatenated without parameterization
        ' Additionally, duration is not validated as an integer
        sql = "INSERT INTO Appointments (PatientID, AppointmentDate, Duration, Reason, Status, ProviderName, Notes, CreatedBy) " & _
              "VALUES (" & patientID & ", '" & apptDate & "', " & duration & ", '" & reason & "', '" & status & "', '" & provider & "', '" & notes & "', " & Session("UserID") & ")"

        Set conn = GetConnection()
        conn.Execute(sql)
        conn.Close
        Set conn = Nothing

        Response.Redirect "appointments.asp"
    End If
End If

' Pre-select patient if coming from patient detail page
' SQL INJECTION: preselectedPatientId from querystring not validated
Dim preselectedPatientId
preselectedPatientId = Request.QueryString("patientId")

' Load patient list for dropdown - no filtering, loads all patients
Dim patientConn, patientRs, patientSql
patientSql = "SELECT PatientID, FirstName, LastName FROM Patients ORDER BY LastName, FirstName"
Set patientConn = GetConnection()
Set patientRs   = patientConn.Execute(patientSql)
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PrecisionCare - Add Appointment</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f0f4f8; }
        .navbar { background: #2c3e50; color: #fff; padding: 12px 24px; display: flex; justify-content: space-between; align-items: center; }
        .navbar a { color: #fff; text-decoration: none; margin-left: 16px; font-size: 14px; }
        .container { max-width: 700px; margin: 30px auto; padding: 0 20px; }
        h1 { color: #2c3e50; }
        .card { background: #fff; border-radius: 8px; padding: 28px; box-shadow: 0 1px 6px rgba(0,0,0,0.1); }
        .form-row { margin-bottom: 16px; }
        .form-row label { display: block; margin-bottom: 4px; font-weight: bold; color: #555; font-size: 14px; }
        .form-row input, .form-row select, .form-row textarea {
            width: 100%; padding: 9px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-size: 14px;
        }
        .form-row textarea { height: 80px; }
        .form-row .required { color: #e74c3c; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 0 20px; }
        .btn-save { padding: 10px 24px; background: #27ae60; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 15px; }
        .btn-cancel { padding: 10px 24px; background: #95a5a6; color: #fff; text-decoration: none; border-radius: 4px; font-size: 15px; margin-left: 10px; }
        .error { color: #e74c3c; background: #fdecea; padding: 10px; border-radius: 4px; margin-bottom: 16px; font-size: 14px; }
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
        <h1>Add Appointment</h1>
        <div class="card">
            <% If errorMsg <> "" Then %>
                <!-- XSS: errorMsg echoed without encoding -->
                <div class="error"><%= errorMsg %></div>
            <% End If %>
            <form method="POST" action="appointment_add.asp">
                <div class="form-row">
                    <label>Patient <span class="required">*</span></label>
                    <select name="patientID">
                        <option value="">-- Select Patient --</option>
                        <% Do While Not patientRs.EOF %>
                            <%
                            Dim selPatID
                            selPatID = patientRs("PatientID")
                            Dim selectedAttr
                            If Request.Form("patientID") <> "" Then
                                selectedAttr = If(Request.Form("patientID") = CStr(selPatID), "selected", "")
                            Else
                                selectedAttr = If(preselectedPatientId = CStr(selPatID), "selected", "")
                            End If
                            %>
                            <!-- XSS: patient name echoed without encoding -->
                            <option value="<%= selPatID %>" <%= selectedAttr %>>
                                <%= patientRs("LastName") %>, <%= patientRs("FirstName") %>
                            </option>
                            <% patientRs.MoveNext %>
                        <% Loop %>
                    </select>
                </div>
                <div class="form-grid">
                    <div class="form-row">
                        <label>Appointment Date &amp; Time <span class="required">*</span></label>
                        <!-- XSS: value echoed without encoding -->
                        <input type="text" name="apptDate" value="<%= Request.Form("apptDate") %>" placeholder="MM/DD/YYYY HH:MM">
                    </div>
                    <div class="form-row">
                        <label>Duration (minutes)</label>
                        <input type="text" name="duration" value="<%= If(Request.Form("duration")="", "30", Request.Form("duration")) %>">
                    </div>
                </div>
                <div class="form-row">
                    <label>Reason <span class="required">*</span></label>
                    <input type="text" name="reason" value="<%= Request.Form("reason") %>">
                </div>
                <div class="form-grid">
                    <div class="form-row">
                        <label>Provider <span class="required">*</span></label>
                        <input type="text" name="provider" value="<%= Request.Form("provider") %>">
                    </div>
                    <div class="form-row">
                        <label>Status</label>
                        <select name="status">
                            <option value="Scheduled"  <%= If(Request.Form("status")="Scheduled"  Or Request.Form("status")="", "selected","") %>>Scheduled</option>
                            <option value="Completed"  <%= If(Request.Form("status")="Completed",  "selected","") %>>Completed</option>
                            <option value="Cancelled"  <%= If(Request.Form("status")="Cancelled",  "selected","") %>>Cancelled</option>
                            <option value="NoShow"     <%= If(Request.Form("status")="NoShow",     "selected","") %>>No Show</option>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <label>Notes</label>
                    <textarea name="notes"><%= Request.Form("notes") %></textarea>
                </div>
                <div>
                    <input type="submit" name="submit" value="Save" class="btn-save">
                    <a href="appointments.asp" class="btn-cancel">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
<%
patientRs.Close
patientConn.Close
Set patientRs   = Nothing
Set patientConn = Nothing
%>
