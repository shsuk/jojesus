<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>

<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">

<head>
<link href="../jquery/development-bundle/themes/redmond/jquery.ui.all.css"  rel="stylesheet" type="text/css" media="screen" />
<link href="../jquery/jqgrid/css/ui.jqgrid.css"  rel="stylesheet" type="text/css" media="screen" />
<link href="../jquery/jqgrid/plugins/ui.multiselect.css" rel="stylesheet" type="text/css" media="screen" />
<link href="../menu_system/contents.css" rel="stylesheet" type="text/css" />

<script src="../jquery/js/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="../jquery/js/jquery-ui-1.10.0.custom.min.js" type="text/javascript"></script>
<script src="../jquery/jqgrid/js/i18n/grid.locale-en.js" type="text/javascript"></script>
<script src="../jquery/jqgrid/js/jquery.jqGrid.min.js" type="text/javascript"></script>

<script type="text/javascript">
	
	$(function() {

	});
	
</script>
</head>
<body >

<c:import url="../menu_system/menu.jsp">
	<c:param name="menu_id">me02</c:param>
</c:import>

<sp:sp queryPath="menu_system/notice" action="v" processorList="db" exception="true"/>

<div id="menu_body" style="margin: 0 auto;width: 1100px;position: relative; clear: both;">
	<div class="ui-jqgrid-titlebar ui-widget-header ui-corner-top ui-helper-clearfix" style="padding: 3px;">
		<b style="font-size: 14px;padding: 20px;">공지 내용</b>
	</div>
	<table class="vw" cellspacing="0" cellpadding="0" border="0" style="width: 100%">
		<tr>
			<th align="left"  style="width: 150px;"  class="ui-state-default ui-th-column ui-th-ltr tdt tdl">제목</th>
			<td class="tdt">${row.subject }</td>
		</tr>
		<tr>
			<td colspan="2"  class="tdl">${row.contents }</td>
		</tr>
	</table>	
	<br>
	<span id="btn_add" class="btn"  style="cursor:pointer; " onclick="add()">등록</span>
</div>		

</body>
</htm>