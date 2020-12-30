<%@page contentType="text/html; charset=utf-8" import="java.sql.*"%>
<jsp:useBean id="pool" class="soo.db.ConnectionPoolBean" scope="application"/>

<%
	Connection con=null;
	PreparedStatement pstmt=null;
	String sql = "select * from BOARD where SEQ=?";
	ResultSet rs = null;
		int seq = -1;
		String seqStr = request.getParameter("seq");
        if(seqStr != null){
			seqStr = seqStr.trim();
			if(seqStr.length() != 0){
				try{
					seq = Integer.parseInt(seqStr);
				}catch(NumberFormatException ne){ }
			}
		}
		try{
			con = pool.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, seq);
			rs = pstmt.executeQuery();
			boolean flag = false;
			while(rs.next()){
				flag = true;
				String writer = rs.getString(2);
				String email = rs.getString(3);
				String subject = rs.getString(4);
				String content = rs.getString(5);
				Date rdate = rs.getDate(6);
%>
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
<center>
<hr width='600' size='2' noshade>
<h2>Simple Board with Servlet</h2>
&nbsp;&nbsp;&nbsp;
<a href='write.html'>글쓰기</a>
<hr width='600' size='2' noshade>
<table border='1' width='600' align='center' cellpadding='3'>
<tr>
<td width='100' align='center'>글번호</td>
<%
	out.println("<td>"+seq+"</td>");
	out.println("</tr>");
	out.println("<tr>");
		out.println("<td align='center'>글쓴이</td>");
		out.println("<td>"+writer+"</td>");
	out.println("</tr>");
	out.println("<tr>");
		out.println("<td align='center'>이메일</td>");
		out.println("<td>"+email+"</td>");
	out.println("</tr>");
	out.println("<tr>");
		out.println("<td align='center'>글제목</td>");
		out.println("<td>"+subject+"</td>");
	out.println("</tr>");
	out.println("<tr>");
		out.println("<td align='center'>글내용</td>");
		out.println("<td>"+content+"</td>");
	out.println("</tr>");
out.println("</table>");
out.println("<hr width='600' size='2' noshade>");
	out.println("<b>");
		out.println("<a href='update.jsp?seq="+seq+"'>수정</a>");
		out.println("<a href='del.jsp?seq="+seq+"'>삭제</a>");
%>
<a href='list.jsp'>목록</a>
</b>
<hr width='600' size='2' noshade>
</center>
<%
			}
	}catch(SQLException se){ 
	}finally{
		try{
			if(pstmt != null) pstmt.close();
			if(con != null) pool.returnConnection(con);
		}catch(SQLException sse){}
	}
%>