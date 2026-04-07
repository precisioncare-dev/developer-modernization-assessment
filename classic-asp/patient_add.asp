<%
' patient_add.asp - Add a new patient
' SECURITY ISSUES:
'   1. Missing authentication check
'   2. SQL Injection: form values concatenated directly into INSERT statement
'   3. XSS: form values echoed back without encoding on validation errors
'   4. No input validation (e.g., date format, required fields)
'   5. No CSRF protection
%>
<!-- #include file="conn.asp" -->
<%
' NOTE: No authentication check
' If Session("UserID") = "" Then Response.Redirect "login.asp"

Dim errorMsg, successMsg
errorMsg   = ""
successMsg = ""

If Request.Form("submit") = "Save" Then
    Dim firstName, lastName, dob, gender, email, phone
    Dim address, city, state, zipCode, insuranceID, notes
    Dim conn, sql

    ' Collect form data - no sanitization whatsoever
    firstName   = Request.Form("firstName")
    lastName    = Request.Form("lastName")
    dob         = Request.Form("dob")
    gender      = Request.Form("gender")
    email       = Request.Form("email")
    phone       = Request.Form("phone")
    address     = Request.Form("address")
    city        = Request.Form("city")
    state       = Request.Form("state")
    zipCode     = Request.Form("zipCode")
    insuranceID = Request.Form("insuranceID")
    notes       = Request.Form("notes")

    If firstName = "" Or lastName = "" Or dob = "" Or gender = "" Then
        errorMsg = "First Name, Last Name, Date of Birth, and Gender are required."
    Else
        ' SQL INJECTION VULNERABILITY: All values concatenated directly
        sql = "INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, Email, Phone, Address, City, State, ZipCode, InsuranceID, Notes, CreatedBy) " & _
              "VALUES ('" & firstName & "', '" & lastName & "', '" & dob & "', '" & gender & "', " & _
              "'" & email & "', '" & phone & "', '" & address & "', '" & city & "', '" & state & "', " & _
              "'" & zipCode & "', '" & insuranceID & "', '" & notes & "', " & Session("UserID") & ")"

        Set conn = GetConnection()
        conn.Execute(sql)

        Dim newIDRs
        Set newIDRs = conn.Execute("SELECT @@IDENTITY AS NewID")
        Dim newPatientID
        newPatientID = newIDRs("NewID")
        newIDRs.Close
        Set newIDRs = Nothing

        conn.Close
        Set conn = Nothing

        Response.Redirect "patient_detail.asp?id=" & newPatientID
    End If
End If
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PrecisionCare - Add Patient</title>
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
        <h1>Add New Patient</h1>
        <div class="card">
            <% If errorMsg <> "" Then %>
                <!-- XSS: errorMsg echoed without encoding -->
                <div class="error"><%= errorMsg %></div>
            <% End If %>
            <form method="POST" action="patient_add.asp">
                <div class="form-grid">
                    <div class="form-row">
                        <label>First Name <span class="required">*</span></label>
                        <!-- XSS: form values echoed back without encoding -->
                        <input type="text" name="firstName" value="<%= Request.Form("firstName") %>">
                    </div>
                    <div class="form-row">
                        <label>Last Name <span class="required">*</span></label>
                        <input type="text" name="lastName" value="<%= Request.Form("lastName") %>">
                    </div>
                    <div class="form-row">
                        <label>Date of Birth <span class="required">*</span></label>
                        <input type="text" name="dob" value="<%= Request.Form("dob") %>" placeholder="MM/DD/YYYY">
                    </div>
                    <div class="form-row">
                        <label>Gender <span class="required">*</span></label>
                        <select name="gender">
                            <option value="">-- Select --</option>
                            <option value="Male"   <%= If(Request.Form("gender")="Male",   "selected", "") %>>Male</option>
                            <option value="Female" <%= If(Request.Form("gender")="Female", "selected", "") %>>Female</option>
                            <option value="Other"  <%= If(Request.Form("gender")="Other",  "selected", "") %>>Other</option>
                        </select>
                    </div>
                    <div class="form-row">
                        <label>Email</label>
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
                <div>
                    <input type="submit" name="submit" value="Save" class="btn-save">
                    <a href="patients.asp" class="btn-cancel">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
