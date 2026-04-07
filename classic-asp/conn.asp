<%
' conn.asp - Database connection helper
' NOTE: Connection string pulled from Application object (set in global.asa with hardcoded credentials)

Function GetConnection()
    Dim conn
    Set conn = Server.CreateObject("ADODB.Connection")
    ' Opens using the globally configured connection string
    conn.Open Application("ConnString")
    Set GetConnection = conn
End Function
%>
