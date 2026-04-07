<%
' login.asp - User login page
' SECURITY ISSUES:
'   1. SQL Injection: user input concatenated directly into SQL query
'   2. Plain text password comparison (no hashing)
'   3. No CSRF protection
'   4. Session ID not regenerated after login (session fixation risk)

Dim errorMsg
errorMsg = ""

If Request.Form("submit") = "Login" Then
    Dim username, password, sql, conn, rs
    username = Request.Form("username")
    password = Request.Form("password")

    ' SQL INJECTION VULNERABILITY: Input is concatenated directly into the query.
    ' An attacker can log in as any user with: username = ' OR '1'='1' --
    sql = "SELECT * FROM Users WHERE Username = '" & username & "' AND Password = '" & password & "' AND IsActive = 1"

    Set conn = GetConnection()
    Set rs = conn.Execute(sql)

    If Not rs.EOF Then
        ' NOTE: Session ID is not regenerated - session fixation vulnerability
        Session("UserID")   = rs("UserID")
        Session("Username") = rs("Username")
        Session("FullName") = rs("FullName")
        Session("Role")     = rs("Role")

        ' Update last login timestamp
        Dim updateSql
        ' SQL INJECTION here too - username not sanitized
        updateSql = "UPDATE Users SET LastLogin = GETDATE() WHERE Username = '" & username & "'"
        conn.Execute(updateSql)

        rs.Close
        conn.Close
        Set rs   = Nothing
        Set conn = Nothing

        Response.Redirect "patients.asp"
    Else
        errorMsg = "Invalid username or password."
    End If

    If Not rs Is Nothing Then
        If rs.State = 1 Then rs.Close
        Set rs = Nothing
    End If
    If Not conn Is Nothing Then
        If conn.State = 1 Then conn.Close
        Set conn = Nothing
    End If
End If
%>
<!-- #include file="conn.asp" -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PrecisionCare - Login</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f4f8; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: #fff; padding: 40px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); width: 340px; }
        h2 { color: #2c3e50; text-align: center; margin-bottom: 24px; }
        label { display: block; margin-bottom: 4px; color: #555; font-size: 14px; }
        input[type=text], input[type=password] { width: 100%; padding: 10px; margin-bottom: 16px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        input[type=submit] { width: 100%; padding: 10px; background: #3498db; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        input[type=submit]:hover { background: #2980b9; }
        .error { color: #e74c3c; text-align: center; margin-bottom: 12px; font-size: 14px; }
        .brand { text-align: center; color: #3498db; font-size: 22px; font-weight: bold; margin-bottom: 8px; }
    </style>
</head>
<body>
    <div class="login-box">
        <div class="brand">PrecisionCare</div>
        <h2>Sign In</h2>
        <% If errorMsg <> "" Then %>
            <!-- XSS VULNERABILITY: errorMsg is never sanitized/encoded before output -->
            <div class="error"><%= errorMsg %></div>
        <% End If %>
        <form method="POST" action="login.asp">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" value="<%= Request.Form("username") %>">
            <label for="password">Password</label>
            <input type="password" id="password" name="password">
            <input type="submit" name="submit" value="Login">
        </form>
    </div>
</body>
</html>
