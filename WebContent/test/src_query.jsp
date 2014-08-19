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
String query = QueryInfoFactory.findQueryOfAction(request.getParameter("queryPath"), request.getParameter("action")).toString();
query = query.replaceAll("\\\\n", "\n").replaceAll("\\\\t", "\t").replaceAll("\",\"", "\",\n\t\"").replaceAll(",\"", ",\n\t\"").replaceAll("\\:\\{", "\\:\\{\n\t");
query = query ;
%>
<a href="http://jsonlint.com/" target="_new">JSONLint으로 보기</a><br>
<textarea style="width: 100%;height:90%;"><%=query%></textarea>

