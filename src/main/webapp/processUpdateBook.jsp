﻿<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.multipart.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbconn.jsp" %>
<%
	String filename = "";
// 	String realFolder = "./upload2"; //웹 어플리케이션상의 절대 경로
	String realFolder = getServletContext().getRealPath("/") + "upload";
	System.out.println("경로확인---->"+realFolder);
	
	String encType = "utf-8"; //인코딩 타입
	int maxSize = 5 * 1024 * 1024; //최대 업로드될 파일의 크기5Mb

	MultipartRequest multi = new MultipartRequest(request, realFolder, maxSize, encType,
			new DefaultFileRenamePolicy());
	String bookId = multi.getParameter("bookId");
	String name = multi.getParameter("name");
	String author = multi.getParameter("author");
	String publisher = multi.getParameter("publisher");
	String publisher_date = multi.getParameter("publisher_date");
	String bookPrice = multi.getParameter("bookPrice");
	String description = multi.getParameter("description");

	Integer price;

	if (bookPrice.isEmpty())
		price = 0;
	else
		price = Integer.valueOf(bookPrice);

	Enumeration files = multi.getFileNames();
	String fname = (String) files.nextElement();
	String fileName = multi.getFilesystemName(fname);	

	
		String sql = "select * from book where b_id = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, bookId);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			if (fileName != null) {
				sql = "UPDATE book SET b_name=?, author=?, b_publisher=?, b_publisher_date=?, b_price=?, b_fileName=?, b_description=? WHERE b_id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, name);
				pstmt.setString(2, author);
				pstmt.setString(3, publisher);
				pstmt.setString(4, publisher_date);
				pstmt.setInt(5, price);
				pstmt.setString(6, fileName);
				pstmt.setString(7, bookId);
				pstmt.setString(8, description);
				pstmt.executeUpdate();
			} else {
				sql = "UPDATE book SET b_name=?, author=?, b_publisher=?, b_publisher_date=?, b_price=?, b_description=? WHERE b_id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, name);
				pstmt.setString(2, author);
				pstmt.setString(3, publisher);
				pstmt.setString(4, publisher_date);
				pstmt.setInt(5, price);
				pstmt.setString(6, bookId);
				pstmt.setString(7, description);
				pstmt.executeUpdate();
			}
		}
	if (rs != null)
		rs.close();
 	if (pstmt != null)
 		pstmt.close();
 	if (conn != null)
		conn.close();

	response.sendRedirect("editBook.jsp?edit=update");
%>


