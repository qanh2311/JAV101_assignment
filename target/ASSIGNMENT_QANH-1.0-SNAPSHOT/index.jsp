<%-- File: webapp/index.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Chuyển hướng người dùng đến Servlet AD_DangNhap (đường dẫn /dang-nhap)
    response.sendRedirect(request.getContextPath() + "/login");
%>