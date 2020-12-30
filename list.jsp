<%@page contentType="text/html;charset=utf-8" import="java.sql.*"%>
<jsp:useBean id="pool" class="soo.db.ConnectionPoolBean" scope="application"/>

<meta charset='utf-8'>
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
</head>
<body>
<center>
<font color='gray' size='4' face='휴먼편지체'>
<hr width='600' size='2' color='gray' noshade>
<h3> MVC Board </h3>
<font color='gray' size='4' face='휴먼편지체'>
<a href='../'>인덱스</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href='write.html'>글쓰기</a><br/>
</font>
<hr width='600' size='2' color='gray' noshade>
<TABLE border='2' width='600' align='center' noshade>
<TR size='2' align='center' noshade bgcolor='AliceBlue'>
<th bgcolor='AliceBlue'>번호</th>
<th align='center' width='10%'>작성자</th>
<th align='center' width='30%'>이메일</th>
<th align='center' width='30%'>글제목</th>
<th align='center' width='15%'>작성일</th>
</TR>
<%
	Connection con=null;
	Statement stmt=null;
	ResultSet rs = null;
	String sql = "select * from BOARD order by SEQ desc";
	try{
		con = pool.getConnection();
		stmt = con.createStatement();
		rs = stmt.executeQuery(sql);
		boolean flag = false;
		while(rs.next()){
			flag = true;
			int seq = rs.getInt(1);
			String writer = rs.getString(2);
			String email = rs.getString(3);
			String subject = rs.getString(4);
			String content = rs.getString(5);
			Date rdate = rs.getDate(6);
%>
<TR>
<TD align='center'><%=seq%></TD>
<TD align='center'><%=writer%></TD>
<TD align='center'><%=email%></TD>
<TD align='center'><a href='content.jsp?seq=<%=seq%>'><%=subject%></a></TD>
<TD align='center'><%=rdate%></TD>
</TR>
<%
			if(!flag){
				out.println("<tr>");
					out.println("<td colspan='5' align='center'>게시글 없음</a>");
				out.println("</tr>");
			}
		}
		out.println("</TABLE>");
		out.println("</center>");
	}catch(SQLException se){
	}finally{
		try{
			if(stmt != null) stmt.close();
			if(con != null) pool.returnConnection(con);
		}catch(SQLException se){}
	}

%>