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
	
	var url = 'list_load.jsp';
	var dialog = null;
	
	$(function() {
		loadSubMenu('#root');
		initDialog();
		<%//마우스 오버시 리스트 색상 변경%>
		$('#main_body').on('mouseover','.ovr_sub_menu',
			function(e) {
				$(e.currentTarget).addClass('over_tr');
			}
		);
		$('#main_body').on('mouseout','.ovr_sub_menu',
			function(e) {
				$(e.currentTarget).removeClass('over_tr');
			}
		);
		<%//윈도우 사이즈 변경시 리스트 높이 변경%>
		$( window ).resize(function() {
			$("#list_contents").height($(window ).height()-200);		
		}).resize();
	});
	
	function initDialog(){
		 dialog = $( "#menu_detail" ).dialog({
			 title: '메뉴 상세 정보 관리',
			 autoOpen: false,
			 resizable: false,
			 width: '890',
			 height: '360',
			 modal: true
	 	});
	}
	function loadSubMenu(sel){
		var menus = $(sel);
		for(var i=0; i<menus.length; i++){
			loadMenu(menus[i]);
		}
	}
	function loadMenu(obj){
		var menu_id = $(obj).attr('id');
		
		$(obj).removeClass('sub_menu');
		
		$('#'+menu_id+'__sub').load(url, {group_id: $('#group_id').val(), upp_menu_id: menu_id, dep: $(obj).attr('dep')},function(){
			var menu_data = $('.'+menu_id);
			$('#'+menu_id).after(menu_data);
			
			loadSubMenu('.sub_menu');
		});
	}
	
	function editMenu(obj){
		
		var menu_id = $(obj).attr('menu_id');
		$('#menu_detail').load('view.jsp',{menu_id: menu_id}, function(){
			$( "#order_no" ).spinner({ min: 1 });
			dialog.dialog( "open" );
			$('[role=dialog]').css('z-index', 999999);
		});
		
	}
	function addSubMenu(menu_id, level){
		dialog.dialog( "open" );

		$('#menu_detail').load('view.jsp',{upp_menu_id: menu_id, level: level}, function(){
			$( "#order_no" ).spinner({ min: 1 });
		}).show();
		
	}
	function del_menu(){
		if(!confirm("정말로 삭제하시겠습니까?")){
			return;
		}
		var form = $('#menu_form');

		$('[name=action]').val('d');
		
		var formData =$(form).serializeArray();
		

		var url = 'update.jsp';
		
		
		$.post(url, formData, function(response, textStatus, xhr){

			var data = $.parseJSON(response);
			
			if(data.success){
				document.location.href='list.jsp';
			}else{
				alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.message);
			}
			
		});
	}
	
	function form_submit(){	
		var url = 'update.jsp';
		var form = $('#menu_form');

		//폼 정합성 체크
		
		if(!valid(form)){
			return;
		};
		

		var formData =$(form).serializeArray();
		
		$.post(url, formData, function(response, textStatus, xhr){

			var data = $.parseJSON(response);
			
			if(data.success){
				document.location.href='list.jsp';
			}else{
				if(data.message.indexOf('Duplicate')>0){
					alert("이미 등록된 메뉴아이디 입니다.");
				}else{
					alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.message);					
				}
			}
			
		});
	}
</script>
</head>
<body >
<div id="menu_detail" style=""></div>

<c:import url="menu.jsp">
	<c:param name="current_menu" value="me01-1"/>
</c:import>

<div id="main_body">
	<div class="ui-jqgrid-titlebar ui-widget-header ui-corner-top ui-helper-clearfix" style="padding: 3px;width: 170px;">
		<b style="font-size: 14px;padding: 20px;">메뉴목록</b>
	</div>

	<table class="lst" >
		<colgroup>
			<col width="300">
			<col width="*">
			<col width="100">
			<col width="60">
			<col width="40">
			<col width="17">
		</colgroup>
		<thead>
			<tr>
				<th>메뉴명</th>
				<th>메뉴경로</th>
				<th>메뉴아이디</th>
				<th>순서</th>
				<th><span id="btn_save" class="" style=" cursor:pointer;" onclick="addSubMenu('root', '1')" title="메인메뉴 추가"><img src="add-icon.png"></span></th>
				<th></th>
			</tr>
		</thead>
	</table>

	<div id="list_contents" style=" height:600px; overflow-y: scroll;">
		<table class="lst" border="0" style="width: 100%;margin: 0px;" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="300">
				<col width="*">
				<col width="100">
				<col width="60">
				<col width="40">
			</colgroup>
			<tbody>
				<tr id="root"  class="root_sub sub_menu" dep="1">
				</tr>
			</tbody>
		</table>
	</div>
	
	<div id="root__sub"></div>
</div>
</body>
</htm>