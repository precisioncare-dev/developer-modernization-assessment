<%
' logout.asp - Destroys the session and redirects to login

Session.Abandon
Response.Redirect "login.asp"
%>
