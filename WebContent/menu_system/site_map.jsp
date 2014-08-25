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
<link href="contents.css" rel="stylesheet" type="text/css" />

<script src="../jquery/js/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="../jquery/js/jquery-ui-1.10.0.custom.min.js" type="text/javascript"></script>
<script src="../jquery/jqgrid/js/i18n/grid.locale-en.js" type="text/javascript"></script>
<script src="../jquery/jqgrid/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script src="commonUtil.js" type="text/javascript"></script>


<script type="text/javascript">

	$(function() {
		//서브메뉴를 메인메뉴 아래로 이동시킨다.
		var main_menus = $('._main_menu');
		
		for(var i=0; i<main_menus.length; i++){
			var main_menu = $(main_menus[i]);
			var menu_id = main_menu.attr('menu_id');
			main_menu.append($('.'+ menu_id));
		}

	});
</script>
</head>
<body>
	<sp:sp queryPath="menu_system/site_map" action="site_map" processorList="db" exception="true">
		{
			role_cd:'1'
		}
	</sp:sp>
	<table>
		<c:forEach var="row" items="${rows}">
			<tr>
				<td><a href="/at/notice/view?notice_id=${row.notice_id }">${row.subject }</a> </td>
			</tr>
		</c:forEach>
	</table>
	
	<!-- 메인메뉴 -->
	<div style="width: 900px; height:900px; background: url('site_map_bg.png') ;">
		<c:forEach var="row" items="${main_rows }">
			<div style="float:left; width: 250px; height:300px; padding:25px; position:relative; background: url('${row.menu_id}.jpg') no-repeat 60% 90%;">
				<div style="padding:3px; width:150px; "><b>${row.menu_name}(${row.menu_id})</b></div>
				<div class="_main_menu"  menu_id="${row.menu_id}"  style="width:150px; text-align:center; "></div>
			</div>
		</c:forEach>
	</div>
	<!-- 서브메뉴 -->
	<c:forEach var="row" items="${sub_rows }">
		<div class="_sub_menu ${row.upp_menu_id}" style=" margin: 2px;padding:3px; width:150px; text-align:left; " upp_menu_id="${row.upp_menu_id}" menu_id="${row.menu_id}" page_url='${row.page_url}'>
				>> <a href="../..${row.page_url}">${row.menu_name}</a>
		</div>
	</c:forEach>
	
</body>
</html>