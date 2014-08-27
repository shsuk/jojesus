<%@ page contentType="text/html; charset=utf-8"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags/tag" %> 

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
<script src="../menu_system/commonUtil.js" type="text/javascript"></script>
<script type="text/javascript">
	
	$(function() {
		$( window ).resize(function(e,e1) {
			$("textarea").css('height', (window.innerHeight-170) + 'px');		
		}).resize();
	});
	
	function loadData(){
		var data = $('#main_form').serializeArray();
		var formData = $('#formData').val();
		
		if(formData!=''){
			data = $.parseJSON(formData);
		}

		$('#source').load('at.sh?_ps=admin/src/src_make',data, function(){
			$( window ).resize();
			$('#formData').val('');
			$( "#tab" ).tabs();
		});
	}
	function save(){
		var data = $('#src_form').serializeArray();

		$.post('at.sh?_ps=admin/src/src_save', data, function(){
			alert('저장되었습니다.');
		});
	}
	
	function loadQuery(){
		var data = $('#main_form').serializeArray();
		var formData = $('#formData').val();
		
		if(formData!=''){
			data = $.parseJSON(formData);
		}

		$('#query').load('at.sh?_ps=admin/src/src_query',data, function(){
			$( "#query" ).dialog();
		});
		
	}
	function openPage(){
		var frm = $('#new_form');
		var param = '{'+$('#defaultValue').val()+'}';
		frm.attr('action', '/test/main.sh?_ps=temp&' + $.param($.parseJSON(param)));
		frm.submit();
		
	}
</script> 
</head>
<body >

	<form id="main_form" action="aa" method="post">
		<div id="defaultData"  style="float: left;padding:1px;">
			<div class="border f_l p_1 m_3 ui-widget-header" >쿼리경로 <input type="text" id="queryPath" name="queryPath" value="notice"></div>
			<div class="border f_l p_1 m_3 ui-widget-header" >실행쿼리 그룹 <input type="text" id="action" name="action" value="list"></div>
			<div class="border f_l p_1 m_3 ui-widget-header" >기본값 <input type="text" id="defaultValue" name="defaultValue" value="rows:10,_start:1,notice_id=72"></div>
			<div class=" ui-widget-header ui-corner-all  m_3" style="float: left; cursor:pointer;  margin-left: 10px; padding: 3px;" onclick="loadData()">읽기</div>
		</div>
		<div class=" ui-widget-header ui-corner-all  m_3" style="float: right; cursor:pointer;  margin-left: 10px; padding: 3px;" onclick="save()">임시저장</div>
		<div class=" ui-widget-header ui-corner-all  m_3" style="float: right; cursor:pointer;  margin-left: 10px; padding: 3px;" onclick="openPage()" >미리보기</div>
		<div class=" ui-widget-header ui-corner-all  m_3" style="float: right; cursor:pointer;  margin-left: 10px; padding: 3px;" onclick="loadQuery()">쿼리보기</div>
		<input type="text" id="formData" name="formData" value="" style="width: 100%" placeholder="소스 생성 정보 (생성된 소스의 하단 주석에 있는 코드)">
		<div id="source" style="clear: both;"></div>
	</form>
	<div id="query" title="쿼리보기"></div>
	<form id="new_form" action="/test/main.sh?_ps=temp" method="post" target="_new"></form>
</body>
</htm>