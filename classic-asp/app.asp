<%
' =============================================================================
' app.asp  —  PrecisionCare Patient Management  (Classic ASP, single-file)
' =============================================================================
' This is the ONLY legacy reference file for the assessment.
' It deliberately contains all ten vulnerabilities listed below.
' Your modernized .NET Core API + Angular application must identify
' and fix every one of them.
'
' VULNERABILITIES IN THIS FILE
' ============================
'  #1  SQL Injection        — user input concatenated directly into every SQL
'                             statement (login, search, insert, update, delete)
'  #2  Plain-text passwords — passwords stored and compared as plain strings
'  #3  XSS                  — all database/form values written to HTML without encoding
'  #4  Missing auth checks  — patient list, add, edit, and delete do not verify
'                             that a user is logged in
'  #5  Missing authz        — any logged-in user can delete or edit any record;
'                             no role check is performed
'  #6  Hardcoded credentials— connection string with sa / Admin123! lives in
'                             global.asa (loaded automatically by IIS)
'  #7  No CSRF protection   — no anti-forgery token on any form or action link
'  #8  Session fixation     — session ID is not regenerated after successful login
'  #9  GET-based delete     — records are deleted via a plain <a href> link
'  #10 No input validation  — no server-side checks for data type, length, or format

' =============================================================================
' CONNECTION HELPER
' (Credentials come from global.asa via the Application object — see #6)
' =============================================================================
Function GetConnection()
    Dim c
    Set c = Server.CreateObject("ADODB.Connection")
    c.Open Application("ConnString")
    Set GetConnection = c
End Function

' =============================================================================
' ROUTING — driven by ?view= and ?action= query-string parameters
' =============================================================================
Dim currentView, actionParam
currentView = Request.QueryString("view")
actionParam = Request.QueryString("action")
If currentView = "" And actionParam = "" Then currentView = "patients"

' =============================================================================
' ACTION: logout
' =============================================================================
If actionParam = "logout" Then
    Session.Abandon
    Response.Redirect "app.asp?view=login"
End If

' =============================================================================
' ACTION: login POST
' =============================================================================
Dim loginError
loginError = ""

If currentView = "login" And Request.Form("submit") = "Login" Then
    Dim uname, pwd, loginSql, loginConn, loginRs
    uname = Request.Form("username")
    pwd   = Request.Form("password")

    ' VULNERABILITY #1 (SQL Injection) + #2 (plain-text password comparison):
    ' An attacker can log in as any user with: username = ' OR '1'='1' --
    loginSql = "SELECT * FROM Users " & _
               "WHERE Username = '" & uname & "' AND Password = '" & pwd & "' AND IsActive = 1"
    Set loginConn = GetConnection()
    Set loginRs   = loginConn.Execute(loginSql)

    If Not loginRs.EOF Then
        ' VULNERABILITY #8 (Session Fixation): session ID is not regenerated
        Session("UserID")   = loginRs("UserID")
        Session("Username") = loginRs("Username")
        Session("FullName") = loginRs("FullName")
        Session("Role")     = loginRs("Role")

        ' VULNERABILITY #1 again in the LastLogin UPDATE:
        loginConn.Execute "UPDATE Users SET LastLogin = GETDATE() WHERE Username = '" & uname & "'"

        loginRs.Close : loginConn.Close
        Set loginRs = Nothing : Set loginConn = Nothing
        Response.Redirect "app.asp"
    Else
        loginError = "Invalid username or password."
    End If

    If Not loginRs   Is Nothing Then If loginRs.State   = 1 Then loginRs.Close   : Set loginRs   = Nothing
    If Not loginConn Is Nothing Then If loginConn.State = 1 Then loginConn.Close : Set loginConn = Nothing
End If

' =============================================================================
' ACTION: delete-patient  —  VULNERABILITY #9 (GET-based delete)
' =============================================================================
If actionParam = "delete-patient" Then
    ' VULNERABILITY #4 (missing auth): no Session("UserID") check
    ' VULNERABILITY #5 (missing authz): no role check; any user (or no user) can delete
    Dim delID, delConn
    delID = Request.QueryString("id")
    ' VULNERABILITY #1 (SQL Injection): delID is not validated as an integer
    Set delConn = GetConnection()
    delConn.Execute "DELETE FROM Patients WHERE PatientID = " & delID
    delConn.Close : Set delConn = Nothing
    Response.Redirect "app.asp"
End If

' =============================================================================
' ACTION: save patient (add / edit)  —  VULNERABILITY #7 (no CSRF token)
' =============================================================================
Dim saveError
saveError = ""

If Request.Form("formType") = "patient" And Request.Form("submit") = "Save" Then
    ' VULNERABILITY #4 (missing auth): no Session("UserID") check
    Dim pfirst, plast, pdob, pgender, pemail, pphone, paddress, pcity, pstate, pzip, pins, pnotes, pid
    pfirst    = Request.Form("firstName")
    plast     = Request.Form("lastName")
    pdob      = Request.Form("dob")
    pgender   = Request.Form("gender")
    pemail    = Request.Form("email")
    pphone    = Request.Form("phone")
    paddress  = Request.Form("address")
    pcity     = Request.Form("city")
    pstate    = Request.Form("state")
    pzip      = Request.Form("zipCode")
    pins      = Request.Form("insuranceID")
    pnotes    = Request.Form("notes")
    pid       = Request.Form("patientId")

    ' VULNERABILITY #10 (no input validation): only a trivial empty-string check;
    ' no email format, phone format, date format, or length enforcement
    If pfirst = "" Or plast = "" Or pdob = "" Or pgender = "" Then
        saveError = "First Name, Last Name, Date of Birth, and Gender are required."
        If pid = "" Then currentView = "add-patient" Else currentView = "edit-patient"
    Else
        Dim saveSql, saveConn
        Set saveConn = GetConnection()

        If pid = "" Then
            ' INSERT — VULNERABILITY #1 (SQL Injection): all values raw-concatenated
            saveSql = "INSERT INTO Patients " & _
                      "  (FirstName,LastName,DateOfBirth,Gender,Email,Phone," & _
                      "   Address,City,State,ZipCode,InsuranceID,Notes,CreatedBy) " & _
                      "VALUES " & _
                      "  ('" & pfirst & "','" & plast & "','" & pdob & "','" & pgender & "'," & _
                      "   '" & pemail & "','" & pphone & "','" & paddress & "','" & pcity & "'," & _
                      "   '" & pstate & "','" & pzip & "','" & pins & "','" & pnotes & "'," & _
                      "   " & Session("UserID") & ")"
        Else
            ' UPDATE — VULNERABILITY #1 (SQL Injection): same concatenation problem
            saveSql = "UPDATE Patients SET " & _
                      "  FirstName='"    & pfirst    & "'," & _
                      "  LastName='"     & plast     & "'," & _
                      "  DateOfBirth='"  & pdob      & "'," & _
                      "  Gender='"       & pgender   & "'," & _
                      "  Email='"        & pemail    & "'," & _
                      "  Phone='"        & pphone    & "'," & _
                      "  Address='"      & paddress  & "'," & _
                      "  City='"         & pcity     & "'," & _
                      "  State='"        & pstate    & "'," & _
                      "  ZipCode='"      & pzip      & "'," & _
                      "  InsuranceID='"  & pins      & "'," & _
                      "  Notes='"        & pnotes    & "'," & _
                      "  UpdatedAt=GETDATE() " & _
                      "WHERE PatientID=" & pid
        End If

        saveConn.Execute(saveSql)
        saveConn.Close : Set saveConn = Nothing
        Response.Redirect "app.asp"
    End If
End If

' =============================================================================
' ACTION: save appointment  —  VULNERABILITY #7 (no CSRF token)
' =============================================================================
Dim apptSaveError
apptSaveError = ""

If Request.Form("formType") = "appointment" And Request.Form("submit") = "Save" Then
    ' VULNERABILITY #4 (missing auth): no Session("UserID") check
    Dim aptPatID, aptDate, aptDur, aptReason, aptStatus, aptProvider, aptNotes
    aptPatID    = Request.Form("patientID")
    aptDate     = Request.Form("apptDate")
    aptDur      = Request.Form("duration")
    aptReason   = Request.Form("reason")
    aptStatus   = Request.Form("status")
    aptProvider = Request.Form("provider")
    aptNotes    = Request.Form("notes")

    If aptPatID = "" Or aptDate = "" Or aptReason = "" Or aptProvider = "" Then
        apptSaveError = "Patient, Date, Reason, and Provider are required."
        currentView = "add-appointment"
    Else
        ' VULNERABILITY #1 (SQL Injection): all values raw-concatenated
        ' VULNERABILITY #10 (no validation): aptDur is not validated as an integer
        Dim aptSql, aptConn
        Set aptConn = GetConnection()
        aptSql = "INSERT INTO Appointments " & _
                 "  (PatientID,AppointmentDate,Duration,Reason,Status,ProviderName,Notes,CreatedBy) " & _
                 "VALUES " & _
                 "  (" & aptPatID & ",'" & aptDate & "'," & aptDur & ",'" & aptReason & "'," & _
                 "   '" & aptStatus & "','" & aptProvider & "','" & aptNotes & "'," & Session("UserID") & ")"
        aptConn.Execute(aptSql)
        aptConn.Close : Set aptConn = Nothing
        Response.Redirect "app.asp?view=appointments"
    End If
End If

' =============================================================================
' PRE-LOAD DATA FOR CURRENT VIEW
' =============================================================================

' -- Patient list ---------------------------------------------------------------
Dim searchTerm, listConn, listRs, listSql
searchTerm = Request.QueryString("search")

If currentView = "patients" Then
    ' VULNERABILITY #4 (missing auth): page loads without checking Session("UserID")
    Set listConn = GetConnection()
    If searchTerm <> "" Then
        ' VULNERABILITY #1 (SQL Injection): searchTerm concatenated directly
        listSql = "SELECT PatientID,FirstName,LastName,DateOfBirth,Gender,Phone,Email " & _
                  "FROM Patients " & _
                  "WHERE LastName  LIKE '%" & searchTerm & "%' " & _
                  "   OR FirstName LIKE '%" & searchTerm & "%' " & _
                  "ORDER BY LastName, FirstName"
    Else
        listSql = "SELECT PatientID,FirstName,LastName,DateOfBirth,Gender,Phone,Email " & _
                  "FROM Patients ORDER BY LastName, FirstName"
    End If
    Set listRs = listConn.Execute(listSql)
End If

' -- Edit patient: load current record ------------------------------------------
Dim editPatID
Dim fFirstName, fLastName, fDob, fGender, fEmail, fPhone
Dim fAddress, fCity, fState, fZipCode, fInsuranceID, fNotes

If currentView = "edit-patient" Then
    ' VULNERABILITY #4 (missing auth): no Session("UserID") check
    ' VULNERABILITY #5 (missing authz): any user can edit any patient record
    editPatID = Request.QueryString("id")
    If editPatID = "" Then editPatID = Request.Form("patientId")

    Dim editConn, editRs
    Set editConn = GetConnection()
    ' VULNERABILITY #1 (SQL Injection): editPatID not validated as integer
    Set editRs = editConn.Execute("SELECT * FROM Patients WHERE PatientID = " & editPatID)

    If editRs.EOF Then
        Response.Redirect "app.asp"
    End If

    If saveError <> "" Then
        ' Re-populate from submitted form on validation error
        fFirstName   = Request.Form("firstName")   : fLastName   = Request.Form("lastName")
        fDob         = Request.Form("dob")         : fGender     = Request.Form("gender")
        fEmail       = Request.Form("email")       : fPhone      = Request.Form("phone")
        fAddress     = Request.Form("address")     : fCity       = Request.Form("city")
        fState       = Request.Form("state")       : fZipCode    = Request.Form("zipCode")
        fInsuranceID = Request.Form("insuranceID") : fNotes      = Request.Form("notes")
    Else
        ' VULNERABILITY #3 (XSS): values from DB are output unencoded later in HTML
        fFirstName   = editRs("FirstName")   : fLastName   = editRs("LastName")
        fDob         = editRs("DateOfBirth") : fGender     = editRs("Gender")
        fEmail       = editRs("Email")       : fPhone      = editRs("Phone")
        fAddress     = editRs("Address")     : fCity       = editRs("City")
        fState       = editRs("State")       : fZipCode    = editRs("ZipCode")
        fInsuranceID = editRs("InsuranceID") : fNotes      = editRs("Notes")
    End If

    editRs.Close : editConn.Close : Set editRs = Nothing : Set editConn = Nothing
End If

' -- Appointments list ----------------------------------------------------------
Dim filterStatus, filterDate, apptConn, apptRs, apptSql
filterStatus = Request.QueryString("status")
filterDate   = Request.QueryString("date")

If currentView = "appointments" Then
    ' VULNERABILITY #4 (missing auth): no Session("UserID") check
    Set apptConn = GetConnection()
    apptSql = "SELECT a.AppointmentID, a.AppointmentDate, a.Duration, a.Reason, " & _
              "       a.Status, a.ProviderName, a.Notes, " & _
              "       p.PatientID, p.FirstName, p.LastName " & _
              "FROM Appointments a " & _
              "INNER JOIN Patients p ON a.PatientID = p.PatientID " & _
              "WHERE 1=1 "

    If filterStatus <> "" Then
        ' VULNERABILITY #1 (SQL Injection): filterStatus concatenated directly
        apptSql = apptSql & "AND a.Status = '" & filterStatus & "' "
    End If
    If filterDate <> "" Then
        ' VULNERABILITY #1 (SQL Injection): filterDate concatenated directly
        apptSql = apptSql & "AND CONVERT(date, a.AppointmentDate) = '" & filterDate & "' "
    End If

    apptSql = apptSql & "ORDER BY a.AppointmentDate"
    Set apptRs = apptConn.Execute(apptSql)
End If

' -- Add appointment: patient dropdown ------------------------------------------
Dim aptPatConn, aptPatRs
If currentView = "add-appointment" Then
    ' VULNERABILITY #4 (missing auth): no Session("UserID") check
    Set aptPatConn = GetConnection()
    Set aptPatRs = aptPatConn.Execute( _
        "SELECT PatientID, FirstName, LastName FROM Patients ORDER BY LastName, FirstName")
End If
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PrecisionCare</title>
    <style>
        body        { font-family: Arial, sans-serif; margin: 0; background: #f0f4f8; }
        .navbar     { background: #2c3e50; color: #fff; padding: 12px 24px;
                      display: flex; justify-content: space-between; align-items: center; }
        .navbar a   { color: #fff; text-decoration: none; margin-left: 16px; font-size: 14px; }
        .container  { max-width: 1100px; margin: 30px auto; padding: 0 20px; }
        h1, h2      { color: #2c3e50; }
        .card       { background: #fff; border-radius: 8px; padding: 28px;
                      box-shadow: 0 1px 6px rgba(0,0,0,.1); max-width: 720px; }
        .form-row   { margin-bottom: 16px; }
        .form-row label { display: block; margin-bottom: 4px; font-weight: bold;
                          color: #555; font-size: 14px; }
        .form-row input, .form-row select, .form-row textarea {
            width: 100%; padding: 9px; border: 1px solid #ccc;
            border-radius: 4px; box-sizing: border-box; font-size: 14px; }
        .form-row textarea { height: 80px; }
        .form-grid  { display: grid; grid-template-columns: 1fr 1fr; gap: 0 20px; }
        .required   { color: #e74c3c; }
        .error      { color: #e74c3c; background: #fdecea; padding: 10px;
                      border-radius: 4px; margin-bottom: 16px; font-size: 14px; }
        table       { width: 100%; border-collapse: collapse; background: #fff;
                      border-radius: 8px; overflow: hidden;
                      box-shadow: 0 1px 6px rgba(0,0,0,.1); }
        th          { background: #2c3e50; color: #fff; padding: 12px 14px;
                      text-align: left; font-size: 13px; }
        td          { padding: 10px 14px; border-bottom: 1px solid #eee;
                      font-size: 14px; color: #333; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #f7fbff; }
        .toolbar    { display: flex; justify-content: space-between;
                      align-items: center; margin-bottom: 16px; flex-wrap: wrap; gap: 10px; }
        .no-results { text-align: center; padding: 30px; color: #888; }
        .login-wrap { display: flex; justify-content: center;
                      align-items: center; min-height: 80vh; }
        .login-box  { background: #fff; padding: 40px; border-radius: 8px;
                      box-shadow: 0 2px 10px rgba(0,0,0,.1); width: 340px; }
        .brand      { text-align: center; color: #3498db; font-size: 22px;
                      font-weight: bold; margin-bottom: 8px; }
        .btn        { display: inline-block; padding: 8px 18px; border-radius: 4px;
                      font-size: 14px; text-decoration: none; border: none; cursor: pointer; }
        .btn-sm     { padding: 5px 12px; font-size: 13px; }
        .btn-primary   { background: #3498db; color: #fff; }
        .btn-success   { background: #27ae60; color: #fff; }
        .btn-secondary { background: #95a5a6; color: #fff; }
        .btn-danger    { color: #e74c3c; background: none; border: none;
                         cursor: pointer; font-size: 13px; }
        .status-Scheduled { color: #2980b9; font-weight: bold; }
        .status-Completed { color: #27ae60; font-weight: bold; }
        .status-Cancelled { color: #e74c3c; font-weight: bold; }
        .status-NoShow    { color: #e67e22; font-weight: bold; }
    </style>
</head>
<body>

<%
' =============================================================================
' NAVBAR (shown on all views except login)
' =============================================================================
If currentView <> "login" Then
%>
<div class="navbar">
    <span><strong>PrecisionCare</strong></span>
    <div>
        <a href="app.asp">Patients</a>
        <a href="app.asp?view=appointments">Appointments</a>
        <%
        ' VULNERABILITY #3 (XSS): session variable written directly to HTML without encoding
        %>
        <span style="margin-left:20px; font-size:13px;">Logged in as: <%= Session("FullName") %></span>
        <a href="app.asp?action=logout">Logout</a>
    </div>
</div>
<% End If %>

<div class="container">
<%

' =============================================================================
' VIEW: LOGIN
' =============================================================================
If currentView = "login" Then
%>
<div class="login-wrap">
    <div class="login-box">
        <div class="brand">PrecisionCare</div>
        <h2 style="text-align:center; margin-bottom:24px;">Sign In</h2>
        <% If loginError <> "" Then %>
            <%
            ' VULNERABILITY #3 (XSS): loginError output directly — not Server.HTMLEncode'd
            %>
            <div class="error" style="text-align:center;"><%= loginError %></div>
        <% End If %>
        <%
        ' VULNERABILITY #7 (No CSRF): form has no anti-forgery token whatsoever
        %>
        <form method="POST" action="app.asp?view=login">
            <div class="form-row">
                <label>Username</label>
                <%
                ' VULNERABILITY #3 (XSS): request value echoed back without encoding
                %>
                <input type="text" name="username" value="<%= Request.Form("username") %>">
            </div>
            <div class="form-row">
                <label>Password</label>
                <input type="password" name="password">
            </div>
            <input type="submit" name="submit" value="Login"
                   class="btn btn-primary" style="width:100%; padding:10px; font-size:16px;">
        </form>
    </div>
</div>

<%
' =============================================================================
' VIEW: PATIENT LIST
' =============================================================================
ElseIf currentView = "patients" Then
    ' VULNERABILITY #4 (missing auth): page renders without checking Session("UserID")
%>
<h1>Patients</h1>
<div class="toolbar">
    <%
    ' VULNERABILITY #7 (No CSRF): no token on any form in this application
    %>
    <form method="GET" action="app.asp" style="display:flex; gap:8px; align-items:center;">
        <input type="hidden" name="view" value="patients">
        <%
        ' VULNERABILITY #3 (XSS): searchTerm echoed without Server.HTMLEncode
        %>
        <input type="text" name="search" value="<%= searchTerm %>"
               placeholder="Search by name..."
               style="padding:8px; border:1px solid #ccc; border-radius:4px; width:260px;">
        <input type="submit" value="Search" class="btn btn-primary btn-sm">
        <% If searchTerm <> "" Then %>
            <a href="app.asp" class="btn btn-secondary btn-sm">Clear</a>
        <% End If %>
    </form>
    <a href="app.asp?view=add-patient" class="btn btn-success">+ Add Patient</a>
</div>

<% If searchTerm <> "" Then %>
    <%
    ' VULNERABILITY #3 (XSS): searchTerm output unencoded inside <p>
    %>
    <p>Results for: <strong><%= searchTerm %></strong></p>
<% End If %>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Last Name</th>
            <th>First Name</th>
            <th>Date of Birth</th>
            <th>Gender</th>
            <th>Phone</th>
            <th>Email</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <% If listRs.EOF Then %>
            <tr><td colspan="8" class="no-results">No patients found.</td></tr>
        <% Else %>
            <% Do While Not listRs.EOF %>
                <tr>
                    <%
                    ' VULNERABILITY #3 (XSS): all columns written directly without Server.HTMLEncode
                    %>
                    <td><%= listRs("PatientID") %></td>
                    <td><%= listRs("LastName") %></td>
                    <td><%= listRs("FirstName") %></td>
                    <td><%= listRs("DateOfBirth") %></td>
                    <td><%= listRs("Gender") %></td>
                    <td><%= listRs("Phone") %></td>
                    <td><%= listRs("Email") %></td>
                    <td>
                        <a href="app.asp?view=edit-patient&id=<%= listRs("PatientID") %>"
                           style="color:#3498db; font-size:13px; margin-right:8px;">Edit</a>
                        <%
                        ' VULNERABILITY #9 (GET-based delete): delete is a plain link — no POST,
                        '   no CSRF token; anyone who can load the URL deletes the record
                        ' VULNERABILITY #5 (missing authz): no role check before deleting
                        %>
                        <a href="app.asp?action=delete-patient&id=<%= listRs("PatientID") %>"
                           class="btn-danger btn-sm"
                           onclick="return confirm('Delete this patient?')">Delete</a>
                    </td>
                </tr>
                <% listRs.MoveNext %>
            <% Loop %>
        <% End If %>
    </tbody>
</table>
<%
    listRs.Close : listConn.Close : Set listRs = Nothing : Set listConn = Nothing

' =============================================================================
' VIEW: ADD PATIENT
' =============================================================================
ElseIf currentView = "add-patient" Then
    ' VULNERABILITY #4 (missing auth): no Session("UserID") check
%>
<h1>Add New Patient</h1>
<div class="card">
    <% If saveError <> "" Then %>
        <%
        ' VULNERABILITY #3 (XSS): saveError output without encoding
        %>
        <div class="error"><%= saveError %></div>
    <% End If %>
    <%
    ' VULNERABILITY #7 (No CSRF): no anti-forgery token
    %>
    <form method="POST" action="app.asp?view=add-patient">
        <input type="hidden" name="formType" value="patient">
        <div class="form-grid">
            <div class="form-row">
                <label>First Name <span class="required">*</span></label>
                <%
                ' VULNERABILITY #3 (XSS): form values echoed without Server.HTMLEncode
                %>
                <input type="text" name="firstName" value="<%= Request.Form("firstName") %>">
            </div>
            <div class="form-row">
                <label>Last Name <span class="required">*</span></label>
                <input type="text" name="lastName" value="<%= Request.Form("lastName") %>">
            </div>
            <div class="form-row">
                <label>Date of Birth <span class="required">*</span></label>
                <%
                ' VULNERABILITY #10 (no validation): no date-format check; any string accepted
                %>
                <input type="text" name="dob" value="<%= Request.Form("dob") %>" placeholder="YYYY-MM-DD">
            </div>
            <div class="form-row">
                <label>Gender <span class="required">*</span></label>
                <select name="gender">
                    <option value="">-- Select --</option>
                    <option value="Male"   <%= If(Request.Form("gender")="Male",   "selected","") %>>Male</option>
                    <option value="Female" <%= If(Request.Form("gender")="Female", "selected","") %>>Female</option>
                    <option value="Other"  <%= If(Request.Form("gender")="Other",  "selected","") %>>Other</option>
                </select>
            </div>
            <div class="form-row">
                <label>Email</label>
                <%
                ' VULNERABILITY #10 (no validation): no email format check
                %>
                <input type="text" name="email" value="<%= Request.Form("email") %>">
            </div>
            <div class="form-row">
                <label>Phone</label>
                <input type="text" name="phone" value="<%= Request.Form("phone") %>">
            </div>
            <div class="form-row">
                <label>Insurance ID</label>
                <input type="text" name="insuranceID" value="<%= Request.Form("insuranceID") %>">
            </div>
        </div>
        <div class="form-row">
            <label>Address</label>
            <input type="text" name="address" value="<%= Request.Form("address") %>">
        </div>
        <div class="form-grid">
            <div class="form-row">
                <label>City</label>
                <input type="text" name="city" value="<%= Request.Form("city") %>">
            </div>
            <div class="form-row">
                <label>State</label>
                <input type="text" name="state" value="<%= Request.Form("state") %>">
            </div>
            <div class="form-row">
                <label>Zip Code</label>
                <input type="text" name="zipCode" value="<%= Request.Form("zipCode") %>">
            </div>
        </div>
        <div class="form-row">
            <label>Notes</label>
            <textarea name="notes"><%= Request.Form("notes") %></textarea>
        </div>
        <input type="submit" name="submit" value="Save" class="btn btn-success">
        <a href="app.asp" class="btn btn-secondary" style="margin-left:10px;">Cancel</a>
    </form>
</div>

<%
' =============================================================================
' VIEW: EDIT PATIENT
' =============================================================================
ElseIf currentView = "edit-patient" Then
    ' VULNERABILITY #4 (missing auth): no Session("UserID") check
    ' VULNERABILITY #5 (missing authz): any user can edit any patient record
%>
<%
' VULNERABILITY #3 (XSS): fFirstName / fLastName written to <h1> without encoding
%>
<h1>Edit Patient: <%= fFirstName %> <%= fLastName %></h1>
<div class="card">
    <% If saveError <> "" Then %>
        <div class="error"><%= saveError %></div>
    <% End If %>
    <%
    ' VULNERABILITY #7 (No CSRF): no anti-forgery token
    %>
    <form method="POST" action="app.asp?view=edit-patient">
        <input type="hidden" name="formType" value="patient">
        <%
        ' VULNERABILITY #1 (SQL Injection): editPatID flows into the hidden field and
        '   is also used unvalidated in the SELECT and UPDATE statements above
        %>
        <input type="hidden" name="patientId" value="<%= editPatID %>">
        <div class="form-grid">
            <div class="form-row">
                <label>First Name <span class="required">*</span></label>
                <%
                ' VULNERABILITY #3 (XSS): all DB values echoed without Server.HTMLEncode
                %>
                <input type="text" name="firstName" value="<%= fFirstName %>">
            </div>
            <div class="form-row">
                <label>Last Name <span class="required">*</span></label>
                <input type="text" name="lastName" value="<%= fLastName %>">
            </div>
            <div class="form-row">
                <label>Date of Birth <span class="required">*</span></label>
                <input type="text" name="dob" value="<%= fDob %>">
            </div>
            <div class="form-row">
                <label>Gender <span class="required">*</span></label>
                <select name="gender">
                    <option value="">-- Select --</option>
                    <option value="Male"   <%= If(fGender="Male",   "selected","") %>>Male</option>
                    <option value="Female" <%= If(fGender="Female", "selected","") %>>Female</option>
                    <option value="Other"  <%= If(fGender="Other",  "selected","") %>>Other</option>
                </select>
            </div>
            <div class="form-row">
                <label>Email</label>
                <input type="text" name="email" value="<%= fEmail %>">
            </div>
            <div class="form-row">
                <label>Phone</label>
                <input type="text" name="phone" value="<%= fPhone %>">
            </div>
            <div class="form-row">
                <label>Insurance ID</label>
                <input type="text" name="insuranceID" value="<%= fInsuranceID %>">
            </div>
        </div>
        <div class="form-row">
            <label>Address</label>
            <input type="text" name="address" value="<%= fAddress %>">
        </div>
        <div class="form-grid">
            <div class="form-row">
                <label>City</label>
                <input type="text" name="city" value="<%= fCity %>">
            </div>
            <div class="form-row">
                <label>State</label>
                <input type="text" name="state" value="<%= fState %>">
            </div>
            <div class="form-row">
                <label>Zip Code</label>
                <input type="text" name="zipCode" value="<%= fZipCode %>">
            </div>
        </div>
        <div class="form-row">
            <label>Notes</label>
            <textarea name="notes"><%= fNotes %></textarea>
        </div>
        <input type="submit" name="submit" value="Save" class="btn btn-primary">
        <a href="app.asp" class="btn btn-secondary" style="margin-left:10px;">Cancel</a>
    </form>
</div>

<%
' =============================================================================
' VIEW: APPOINTMENTS LIST
' =============================================================================
ElseIf currentView = "appointments" Then
    ' VULNERABILITY #4 (missing auth): no Session("UserID") check
%>
<h1>Appointments</h1>
<div class="toolbar">
    <form method="GET" action="app.asp" style="display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
        <input type="hidden" name="view" value="appointments">
        <label style="font-size:13px;">Status:</label>
        <select name="status" style="padding:7px; border:1px solid #ccc; border-radius:4px; font-size:13px;">
            <option value="">All</option>
            <%
            ' VULNERABILITY #3 (XSS): filterStatus used in comparison without encoding
            %>
            <option value="Scheduled" <%= If(filterStatus="Scheduled","selected","") %>>Scheduled</option>
            <option value="Completed" <%= If(filterStatus="Completed","selected","") %>>Completed</option>
            <option value="Cancelled" <%= If(filterStatus="Cancelled","selected","") %>>Cancelled</option>
            <option value="NoShow"    <%= If(filterStatus="NoShow",   "selected","") %>>No Show</option>
        </select>
        <label style="font-size:13px;">Date:</label>
        <%
        ' VULNERABILITY #3 (XSS): filterDate echoed without encoding
        %>
        <input type="text" name="date" value="<%= filterDate %>" placeholder="YYYY-MM-DD"
               style="padding:7px; border:1px solid #ccc; border-radius:4px; font-size:13px; width:130px;">
        <input type="submit" value="Filter" class="btn btn-primary btn-sm">
        <a href="app.asp?view=appointments" class="btn btn-secondary btn-sm">Clear</a>
    </form>
    <a href="app.asp?view=add-appointment" class="btn btn-success">+ Add Appointment</a>
</div>
<table>
    <thead>
        <tr>
            <th>Date &amp; Time</th>
            <th>Patient</th>
            <th>Reason</th>
            <th>Duration</th>
            <th>Provider</th>
            <th>Status</th>
        </tr>
    </thead>
    <tbody>
        <% If apptRs.EOF Then %>
            <tr><td colspan="6" class="no-results">No appointments found.</td></tr>
        <% Else %>
            <% Do While Not apptRs.EOF %>
                <tr>
                    <%
                    ' VULNERABILITY #3 (XSS): all columns output without Server.HTMLEncode
                    %>
                    <td><%= apptRs("AppointmentDate") %></td>
                    <td>
                        <a href="app.asp?view=edit-patient&id=<%= apptRs("PatientID") %>">
                            <%= apptRs("LastName") %>, <%= apptRs("FirstName") %>
                        </a>
                    </td>
                    <td><%= apptRs("Reason") %></td>
                    <td><%= apptRs("Duration") %> min</td>
                    <td><%= apptRs("ProviderName") %></td>
                    <td class="status-<%= apptRs("Status") %>"><%= apptRs("Status") %></td>
                </tr>
                <% apptRs.MoveNext %>
            <% Loop %>
        <% End If %>
    </tbody>
</table>
<%
    apptRs.Close : apptConn.Close : Set apptRs = Nothing : Set apptConn = Nothing

' =============================================================================
' VIEW: ADD APPOINTMENT
' =============================================================================
ElseIf currentView = "add-appointment" Then
    ' VULNERABILITY #4 (missing auth): no Session("UserID") check
%>
<h1>Add Appointment</h1>
<div class="card">
    <% If apptSaveError <> "" Then %>
        <%
        ' VULNERABILITY #3 (XSS): error message echoed without encoding
        %>
        <div class="error"><%= apptSaveError %></div>
    <% End If %>
    <%
    ' VULNERABILITY #7 (No CSRF): no anti-forgery token
    %>
    <form method="POST" action="app.asp?view=add-appointment">
        <input type="hidden" name="formType" value="appointment">
        <div class="form-row">
            <label>Patient <span class="required">*</span></label>
            <select name="patientID">
                <option value="">-- Select Patient --</option>
                <%
                Dim selPID, selAttr
                Do While Not aptPatRs.EOF
                    selPID  = aptPatRs("PatientID")
                    selAttr = If(Request.Form("patientID") = CStr(selPID), "selected", "")
                %>
                <%
                ' VULNERABILITY #3 (XSS): patient names echoed without encoding
                %>
                <option value="<%= selPID %>" <%= selAttr %>><%= aptPatRs("LastName") %>, <%= aptPatRs("FirstName") %></option>
                <%
                    aptPatRs.MoveNext
                Loop
                aptPatRs.Close : aptPatConn.Close
                Set aptPatRs = Nothing : Set aptPatConn = Nothing
                %>
            </select>
        </div>
        <div class="form-grid">
            <div class="form-row">
                <label>Date &amp; Time <span class="required">*</span></label>
                <%
                ' VULNERABILITY #3 (XSS): form value echoed without encoding
                ' VULNERABILITY #10 (no validation): no date/time format enforcement
                %>
                <input type="text" name="apptDate" value="<%= Request.Form("apptDate") %>"
                       placeholder="YYYY-MM-DD HH:MM">
            </div>
            <div class="form-row">
                <label>Duration (minutes)</label>
                <%
                ' VULNERABILITY #10 (no validation): duration not validated as positive integer
                %>
                <input type="text" name="duration"
                       value="<%= If(Request.Form("duration")="","30",Request.Form("duration")) %>">
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
                    <option value="Scheduled" <%= If(Request.Form("status")="Scheduled" Or Request.Form("status")="","selected","") %>>Scheduled</option>
                    <option value="Completed" <%= If(Request.Form("status")="Completed","selected","") %>>Completed</option>
                    <option value="Cancelled" <%= If(Request.Form("status")="Cancelled","selected","") %>>Cancelled</option>
                    <option value="NoShow"    <%= If(Request.Form("status")="NoShow",   "selected","") %>>No Show</option>
                </select>
            </div>
        </div>
        <div class="form-row">
            <label>Notes</label>
            <textarea name="notes"><%= Request.Form("notes") %></textarea>
        </div>
        <input type="submit" name="submit" value="Save" class="btn btn-success">
        <a href="app.asp?view=appointments" class="btn btn-secondary" style="margin-left:10px;">Cancel</a>
    </form>
</div>

<% End If ' end of view routing %>

</div><!-- /.container -->
</body>
</html>
