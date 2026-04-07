<%
' appointments.asp - Appointment listing page
' SECURITY ISSUES:
'   1. Missing authentication check
'   2. SQL Injection: filter values concatenated directly into query
'   3. XSS: filter values and appointment data echoed without HTML encoding
'   4. No pagination - loads all records (performance/DoS risk)
%>
<!-- #include file="conn.asp" -->
<%
' NOTE: No authentication check
' If Session("UserID") = "" Then Response.Redirect "login.asp"

Dim filterStatus, filterDate, sql, conn, rs
filterStatus = Request.QueryString("status")
filterDate   = Request.QueryString("date")

Set conn = GetConnection()

' SQL INJECTION VULNERABILITY: filters concatenated directly
sql = "SELECT a.AppointmentID, a.AppointmentDate, a.Duration, a.Reason, a.Status, " & _
      "       a.ProviderName, a.Notes, " & _
      "       p.PatientID, p.FirstName, p.LastName " & _
      "FROM Appointments a " & _
      "INNER JOIN Patients p ON a.PatientID = p.PatientID " & _
      "WHERE 1=1 "

If filterStatus <> "" Then
    ' SQL INJECTION: filterStatus not sanitized
    sql = sql & "AND a.Status = '" & filterStatus & "' "
End If

If filterDate <> "" Then
    ' SQL INJECTION: filterDate not sanitized
    sql = sql & "AND CONVERT(date, a.AppointmentDate) = '" & filterDate & "' "
End If

sql = sql & "ORDER BY a.AppointmentDate"

Set rs = conn.Execute(sql)
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PrecisionCare - Appointments</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f0f4f8; }
        .navbar { background: #2c3e50; color: #fff; padding: 12px 24px; display: flex; justify-content: space-between; align-items: center; }
        .navbar a { color: #fff; text-decoration: none; margin-left: 16px; font-size: 14px; }
        .container { max-width: 1100px; margin: 30px auto; padding: 0 20px; }
        h1 { color: #2c3e50; }
        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; flex-wrap: wrap; gap: 10px; }
        .filter-form label { font-size: 13px; color: #555; margin-right: 6px; }
        .filter-form select, .filter-form input[type=text] { padding: 7px; border: 1px solid #ccc; border-radius: 4px; font-size: 13px; }
        .filter-form input[type=submit] { padding: 7px 14px; background: #3498db; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }
        .filter-form a { padding: 7px 14px; background: #95a5a6; color: #fff; text-decoration: none; border-radius: 4px; font-size: 13px; margin-left: 6px; }
        .btn-add { padding: 8px 16px; background: #27ae60; color: #fff; text-decoration: none; border-radius: 4px; font-size: 14px; }
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 6px rgba(0,0,0,0.1); }
        th { background: #2c3e50; color: #fff; padding: 12px 14px; text-align: left; font-size: 13px; }
        td { padding: 10px 14px; border-bottom: 1px solid #eee; font-size: 14px; color: #333; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #f7fbff; }
        .status-Scheduled  { color: #2980b9; font-weight: bold; }
        .status-Completed  { color: #27ae60; font-weight: bold; }
        .status-Cancelled  { color: #e74c3c; font-weight: bold; }
        .status-NoShow     { color: #e67e22; font-weight: bold; }
        .no-results { text-align: center; padding: 30px; color: #888; }
        td a { color: #3498db; text-decoration: none; font-size: 13px; }
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
        <h1>Appointments</h1>
        <div class="toolbar">
            <form class="filter-form" method="GET" action="appointments.asp">
                <label>Status:</label>
                <select name="status">
                    <option value="">All</option>
                    <!-- XSS: filterStatus not encoded in option selected check -->
                    <option value="Scheduled"  <%= If(filterStatus="Scheduled",  "selected","") %>>Scheduled</option>
                    <option value="Completed"  <%= If(filterStatus="Completed",  "selected","") %>>Completed</option>
                    <option value="Cancelled"  <%= If(filterStatus="Cancelled",  "selected","") %>>Cancelled</option>
                    <option value="NoShow"     <%= If(filterStatus="NoShow",     "selected","") %>>No Show</option>
                </select>
                <label style="margin-left:12px;">Date:</label>
                <!-- XSS: filterDate echoed without encoding -->
                <input type="text" name="date" value="<%= filterDate %>" placeholder="YYYY-MM-DD" style="width:130px;">
                <input type="submit" value="Filter">
                <a href="appointments.asp">Clear</a>
            </form>
            <a href="appointment_add.asp" class="btn-add">+ Add Appointment</a>
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
                    <th>Notes</th>
                </tr>
            </thead>
            <tbody>
                <% If rs.EOF Then %>
                    <tr><td colspan="7" class="no-results">No appointments found.</td></tr>
                <% Else %>
                    <% Do While Not rs.EOF %>
                        <tr>
                            <!-- XSS: All fields output without HTML encoding -->
                            <td><%= rs("AppointmentDate") %></td>
                            <td>
                                <a href="patient_detail.asp?id=<%= rs("PatientID") %>">
                                    <%= rs("LastName") %>, <%= rs("FirstName") %>
                                </a>
                            </td>
                            <td><%= rs("Reason") %></td>
                            <td><%= rs("Duration") %> min</td>
                            <td><%= rs("ProviderName") %></td>
                            <td class="status-<%= rs("Status") %>"><%= rs("Status") %></td>
                            <td><%= rs("Notes") %></td>
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
