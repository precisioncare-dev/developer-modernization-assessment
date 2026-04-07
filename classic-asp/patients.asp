<%
' patients.asp - Patient listing page
' SECURITY ISSUES:
'   1. Missing authentication check - any unauthenticated user can access this page
'   2. SQL Injection: search term concatenated directly into query
'   3. XSS: search term and patient data echoed without HTML encoding

' NOTE: No authentication check here - should verify Session("UserID") is set
' If Session("UserID") = "" Then Response.Redirect "login.asp"

' #include file="conn.asp"
%>
<!-- #include file="conn.asp" -->
<%
Dim searchTerm, sql, conn, rs, errorMsg
searchTerm = Request.QueryString("search")
errorMsg = ""

Dim deleteID
deleteID = Request.QueryString("delete")

If deleteID <> "" Then
    ' SQL INJECTION: deleteID is not validated as an integer
    Dim delSql, delConn
    delSql = "DELETE FROM Patients WHERE PatientID = " & deleteID
    Set delConn = GetConnection()
    delConn.Execute(delSql)
    delConn.Close
    Set delConn = Nothing
End If

Set conn = GetConnection()

' SQL INJECTION VULNERABILITY: searchTerm is concatenated directly into the SQL query
If searchTerm <> "" Then
    sql = "SELECT PatientID, FirstName, LastName, DateOfBirth, Gender, Phone, Email " & _
          "FROM Patients " & _
          "WHERE LastName LIKE '%" & searchTerm & "%' " & _
          "   OR FirstName LIKE '%" & searchTerm & "%' " & _
          "ORDER BY LastName, FirstName"
Else
    sql = "SELECT PatientID, FirstName, LastName, DateOfBirth, Gender, Phone, Email " & _
          "FROM Patients ORDER BY LastName, FirstName"
End If

Set rs = conn.Execute(sql)
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PrecisionCare - Patients</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f0f4f8; }
        .navbar { background: #2c3e50; color: #fff; padding: 12px 24px; display: flex; justify-content: space-between; align-items: center; }
        .navbar a { color: #fff; text-decoration: none; margin-left: 16px; font-size: 14px; }
        .container { max-width: 1100px; margin: 30px auto; padding: 0 20px; }
        h1 { color: #2c3e50; }
        .toolbar { display: flex; justify-content: space-between; margin-bottom: 16px; }
        .search-form input[type=text] { padding: 8px; border: 1px solid #ccc; border-radius: 4px; width: 260px; }
        .search-form input[type=submit] { padding: 8px 16px; background: #3498db; color: #fff; border: none; border-radius: 4px; cursor: pointer; }
        .btn-add { padding: 8px 16px; background: #27ae60; color: #fff; text-decoration: none; border-radius: 4px; font-size: 14px; }
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 6px rgba(0,0,0,0.1); }
        th { background: #2c3e50; color: #fff; padding: 12px 14px; text-align: left; font-size: 13px; }
        td { padding: 10px 14px; border-bottom: 1px solid #eee; font-size: 14px; color: #333; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #f7fbff; }
        .actions a { color: #3498db; text-decoration: none; margin-right: 8px; font-size: 13px; }
        .actions a.del { color: #e74c3c; }
        .no-results { text-align: center; padding: 30px; color: #888; }
    </style>
</head>
<body>
    <div class="navbar">
        <span><strong>PrecisionCare</strong></span>
        <div>
            <a href="patients.asp">Patients</a>
            <a href="appointments.asp">Appointments</a>
            <!-- XSS: Session variable echoed without encoding -->
            <span style="margin-left:20px; font-size:13px;">Logged in as: <%= Session("FullName") %></span>
            <a href="logout.asp">Logout</a>
        </div>
    </div>
    <div class="container">
        <h1>Patients</h1>
        <div class="toolbar">
            <form class="search-form" method="GET" action="patients.asp">
                <!-- XSS: searchTerm echoed back without HTML encoding -->
                <input type="text" name="search" value="<%= searchTerm %>" placeholder="Search by name...">
                <input type="submit" value="Search">
            </form>
            <a href="patient_add.asp" class="btn-add">+ Add Patient</a>
        </div>
        <% If searchTerm <> "" Then %>
            <!-- XSS VULNERABILITY: searchTerm output without sanitization -->
            <p>Showing results for: <strong><%= searchTerm %></strong></p>
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
                <% If rs.EOF Then %>
                    <tr><td colspan="8" class="no-results">No patients found.</td></tr>
                <% Else %>
                    <% Do While Not rs.EOF %>
                        <tr>
                            <!-- XSS: All fields output without HTML encoding -->
                            <td><%= rs("PatientID") %></td>
                            <td><%= rs("LastName") %></td>
                            <td><%= rs("FirstName") %></td>
                            <td><%= rs("DateOfBirth") %></td>
                            <td><%= rs("Gender") %></td>
                            <td><%= rs("Phone") %></td>
                            <td><%= rs("Email") %></td>
                            <td class="actions">
                                <a href="patient_detail.asp?id=<%= rs("PatientID") %>">View</a>
                                <a href="patient_edit.asp?id=<%= rs("PatientID") %>">Edit</a>
                                <!-- No CSRF protection on delete -->
                                <a href="patients.asp?delete=<%= rs("PatientID") %>" class="del"
                                   onclick="return confirm('Delete this patient?')">Delete</a>
                            </td>
                        </tr>
                        <% rs.MoveNext %>
                    <% Loop %>
                <% End If %>
            </tbody>
        </table>
    </div>
</body>
</html>
<%
rs.Close
conn.Close
Set rs   = Nothing
Set conn = Nothing
%>
