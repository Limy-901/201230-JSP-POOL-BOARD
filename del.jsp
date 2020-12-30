<%@page contentType="text/html; charset=utf-8" import="java.sql.*"%>
<jsp:useBean id="pool" class="soo.db.ConnectionPoolBean" scope="application"/>


<%!
	Connection con;
	PreparedStatement pstmt;

	public void jspInit(){
		String url = "jdbc:oracle:thin:@127.0.0.1:1521:JAVA";
		String sql = "delete from BOARD where SEQ=?";
		try{
			Class.forName("oracle.jdbc.driver.OracleDriver");
			con = DriverManager.getConnection(url, "servlet", "java");
			pstmt = con.prepareStatement(sql);
		}catch(ClassNotFoundException cnfe){
		}catch(SQLException se){
		}
	}
	public void jspDestroy(){
		try{
			if(pstmt != null) pstmt.close();
			if(con != null) con.close();
		}catch(SQLException se){ }
	}
%>

<%
	Connection con=null;
	PreparedStatement pstmt=null;
	String sql = "delete from BOARD where SEQ=?";


	request.setCharacterEncoding("utf-8");
	String seqStr = request.getParameter("seq");
	int seq = -1;
	if(seqStr != null){
		seqStr = seqStr.trim();
		if(seqStr.length() != 0){
			try{
				con = pool.getConnection();
				pstmt = con.prepareStatement(sql);
				seq = Integer.parseInt(seqStr);
				pstmt.setInt(1, seq);
				pstmt.executeUpdate();
				System.out.println("Delete Success!");
			}catch(NumberFormatException ne){
			}catch(SQLException se){
			}finally{
				try{
					if(pstmt != null) pstmt.close();
					if(con != null) pool.returnConnection(con);
				}catch(SQLException se){ }
			}
		}
	response.sendRedirect("list.jsp");
	}
%>