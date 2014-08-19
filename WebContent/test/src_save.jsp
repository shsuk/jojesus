<%@page import="java.io.File"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="kr.or.voj.webapp.db.QueryInfoFactory"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags/tag" %> 
<%
String path = request.getServletContext().getRealPath("/WEB-INF/jsp/test");
File file = new File(path, "temp.jsp");
System.out.print(file.getAbsolutePath());
FileUtils.writeStringToFile(file, request.getParameter("src"), "utf-8");

%>

