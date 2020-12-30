<%@page contentType="text/html; charset=utf-8" import="java.sql.*"%>
<jsp:useBean id="pool" class="soo.db.ConnectionPoolBean" scope="application"/>

<%
	Connection con=null;
	PreparedStatement pstmt1=null;
	PreparedStatement pstmt2=null;
	String sql1 = "select * from BOARD where SEQ=?";
	String sql2 = "update BOARD set EMAIL=?, SUBJECT=?, CONTENT=? where SEQ=?";

	request.setCharacterEncoding("utf-8");
	String seqStr = request.getParameter("seq");
	String getEmail = request.getParameter("email");
	String getSubject = request.getParameter("subject");
	String getContent = request.getParameter("content");
	int seq = -1;
	if(seqStr != null){
		seqStr = seqStr.trim();
		if(seqStr.length() != 0){
			try{
				seq = Integer.parseInt(seqStr);
			}catch(NumberFormatException ne){ }
		}
	}
	if(getEmail != null){
		seqStr = seqStr.trim();
		getEmail = getEmail.trim();
		getSubject = getSubject.trim();
		getContent = getContent.trim();
		try{
			con = pool.getConnection();
			pstmt2 = con.prepareStatement(sql2);
			seq = Integer.parseInt(seqStr);
			pstmt2.setString(1,getEmail);
			pstmt2.setString(2,getSubject);
			pstmt2.setString(3,getContent);
			pstmt2.setInt(4,seq);
			pstmt2.executeUpdate();
			response.sendRedirect("list.jsp");
		}catch(NumberFormatException ne){
		}catch(SQLException se){
		}finally{
			try{
				if(pstmt1 != null) pstmt1.close();
				if(con != null) pool.returnConnection(con);
			}catch(SQLException se){ }
		}
	}else{
		ResultSet rs = null;
		out.println("<meta charset='utf-8'>");
		try{
			con = pool.getConnection();
			pstmt1 = con.prepareStatement(sql1);
			pstmt1.setInt(1, seq);
			rs = pstmt1.executeQuery();
			boolean flag = false;
			while(rs.next()){
				flag = true;
				String writer = rs.getString(2);
				String email = rs.getString(3);
				String subject = rs.getString(4);
				String content = rs.getString(5);
				Date rdate = rs.getDate(6);
%>

<style>
table, th, td {
border: 1px solid black;
border-collapse: collapse;
}
th, td {
padding: 5px;
}
a { text-decoration:none }
</style>
<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js'></script>
<script>
function f(){
input.email.value = '';
input.subject.value = '';
$('#ta').text('');
input.email.focus();
}
</script>
</head>
<body>
<center>
<font color='gray' size='4' face='휴먼편지체'>
<hr width='600' size='2' noshade>
<h2>Simple Board with JSP</h2>
&nbsp;&nbsp;&nbsp;
<a href='list.jsp'>글목록</a>
<hr width='600' size='2' noshade>
<form name='f' method='post' action='update.jsp'>
<input type='hidden' name='seq' value='<%=seq%>'>
<input type='hidden' name='writer' value='<%=writer%>'>
<table border='1' width='600' align='center' cellpadding='3' cellspacing='1'>
<tr>
<td width='30%' align='center'>글쓴이</td>
<td align='center'><input type='text' name='aa' size='60' value='<%=writer%>' disabled></td>
</tr>
<tr>
<td width='30%' align='center'>이메일</td>
<td align='center'><input type='text' name='email' size='60' value='<%=email%>'></td>
</tr>
<tr>
<td width='30%' align='center'>글제목</td>
<td align='center'><input type='text' name='subject' size='60' value='<%=subject%>'></td>
</tr>
<tr>
<td width='30%' align='center'>글내용</td>
<td align='center'><textarea name='content' rows='5' cols='53'><%=content%></textarea></td>
</tr>
<tr>
<td colspan='2' align='center'>
<input type='submit' value='수정'>
</td>
</tr>
</table>
</form>
<hr width='600' size='2' noshade>
<b>
<a href='update.jsp?seq=<%=seq%>'>수정</a>
<a href='del.jsp?seq=<%=seq%>'>삭제</a>
<a href='list.jsp'>목록</a>
</b>
<hr width='600' size='2' noshade>
</center>
<%
			}
		}catch(SQLException se){
		}finally{
			try{
				if(pstmt1 != null) pstmt1.close();
				if(con != null) pool.returnConnection(con);
			}catch(SQLException se){ }
		}
	}
%>