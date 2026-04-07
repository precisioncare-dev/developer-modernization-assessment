<%
' patient_edit.asp - Edit existing patient
' SECURITY ISSUES:
'   1. Missing authentication check
'   2. SQL Injection: PatientID in SELECT and all fields in UPDATE are unparameterized
'   3. XSS: patient fields echoed into form without HTML encoding
'   4. No authorization check - any user can edit any patient record
'   5. No CSRF protection
%>
<!-- #include file="conn.asp" -->
<%
' NOTE: No authentication check
' If Session("UserID") = "" Then Response.Redirect "login.asp"

Dim patientID, conn, rs, sql, errorMsg
errorMsg  = ""

' SQL INJECTION: not validated as integer
patientID = Request.QueryString("id")
If patientID = "" Then patientID = Request.Form("patientID")

If patientID = "" Then
    Response.Redirect "patients.asp"
End If

If Request.Form("submit") = "Save" Then
    Dim firstName, lastName, dob, gender, email, phone
    Dim address, city, state, zipCode, insuranceID, notes

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
        ' SQL INJECTION VULNERABILITY: all values concatenated without parameterization
        sql = "UPDATE Patients SET " & _
              "FirstName = '"   & firstName   & "', " & _
              "LastName = '"    & lastName    & "', " & _
              "DateOfBirth = '" & dob         & "', " & _
              "Gender = '"      & gender      & "', " & _
              "Email = '"       & email       & "', " & _
              "Phone = '"       & phone       & "', " & _
              "Address = '"     & address     & "', " & _
              "City = '"        & city        & "', " & _
              "State = '"       & state       & "', " & _
              "ZipCode = '"     & zipCode     & "', " & _
              "InsuranceID = '" & insuranceID & "', " & _
              "Notes = '"       & notes       & "', " & _
              "UpdatedAt = GETDATE() " & _
              "WHERE PatientID = " & patientID

        Set conn = GetConnection()
        conn.Execute(sql)
        conn.Close
        Set conn = Nothing

        Response.Redirect "patient_detail.asp?id=" & patientID
    End If
End If

' Load current patient data for pre-filling the form
' SQL INJECTION: patientID not validated
Set conn = GetConnection()
sql = "SELECT * FROM Patients WHERE PatientID = " & patientID
Set rs = conn.Execute(sql)

If rs.EOF Then
    Response.Write "<p>Patient not found.</p>"
    Response.End
End If

' Keep field values from form submission if there was a validation error,
' otherwise use values from the database
Dim fFirstName, fLastName, fDob, fGender, fEmail, fPhone
Dim fAddress, fCity, fState, fZipCode, fInsuranceID, fNotes

If Request.Form("submit") = "Save" Then
    fFirstName   = Request.Form("firstName")
    fLastName    = Request.Form("lastName")
    fDob         = Request.Form("dob")
    fGender      = Request.Form("gender")
    fEmail       = Request.Form("email")
    fPhone       = Request.Form("phone")
    fAddress     = Request.Form("address")
    fCity        = Request.Form("city")
    fState       = Request.Form("state")
    fZipCode     = Request.Form("zipCode")
    fInsuranceID = Request.Form("insuranceID")
    fNotes       = Request.Form("notes")
Else
    fFirstName   = rs("FirstName")
    fLastName    = rs("LastName")
    fDob         = rs("DateOfBirth")
    fGender      = rs("Gender")
    fEmail       = rs("Email")
    fPhone       = rs("Phone")
    fAddress     = rs("Address")
    fCity        = rs("City")
    fState       = rs("State")
    fZipCode     = rs("ZipCode")
    fInsuranceID = rs("InsuranceID")
    fNotes       = rs("Notes")
End If

rs.Close
conn.Close
Set rs   = Nothing
Set conn = Nothing
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PrecisionCare - Edit Patient</title>
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
        .btn-save { padding: 10px 24px; background: #3498db; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 15px; }
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
        <!-- XSS: fFirstName, fLastName echoed without encoding -->
        <h1>Edit Patient: <%= fFirstName %> <%= fLastName %></h1>
        <div class="card">
            <% If errorMsg <> "" Then %>
                <div class="error"><%= errorMsg %></div>
            <% End If %>
            <form method="POST" action="patient_edit.asp">
                <input type="hidden" name="patientID" value="<%= patientID %>">
                <div class="form-grid">
                    <div class="form-row">
                        <label>First Name <span class="required">*</span></label>
                        <!-- XSS: values echoed without HTML encoding -->
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
                            <option value="Male"   <%= If(fGender="Male",   "selected", "") %>>Male</option>
                            <option value="Female" <%= If(fGender="Female", "selected", "") %>>Female</option>
                            <option value="Other"  <%= If(fGender="Other",  "selected", "") %>>Other</option>
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
                <div>
                    <input type="submit" name="submit" value="Save" class="btn-save">
                    <a href="patient_detail.asp?id=<%= patientID %>" class="btn-cancel">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
