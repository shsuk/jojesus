<%@ page contentType="text/html; charset=utf-8"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<link href="../jquery/development-bundle/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" media="screen" />
<link href="../jquery/jqgrid/css/ui.jqgrid.css" rel="stylesheet" type="text/css" media="screen" />
<link href="../jquery/jqgrid/plugins/ui.multiselect.css" rel="stylesheet" type="text/css" media="screen" />
<link href="../menu_system/contents.css" rel="stylesheet" type="text/css" />

<script src="../jquery/js/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="../jquery/js/jquery-ui-1.10.0.custom.min.js" type="text/javascript"></script>
<script src="../jquery/jqgrid/js/i18n/grid.locale-en.js" type="text/javascript"></script>
<script src="../jquery/jqgrid/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script src="../menu_system/commonUtil.js" type="text/javascript"></script>
<script type="text/javascript">
	$(function() {

	});

</script>
</head>
<body>
	<div id="main_layer" style="margin: 0 auto; padding: 3px; width: 90%; min-width: 1000px; border: 1px solid #cccccc;">
		<div>test system</div>
		<c:import url="${req._ps }.jsp"/>
		<div>ccc</div>
	</div>
</body>
</htm>