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
<script type="text/javascript">
	
	var url = 'list_load.jsp';
	var dialog = null;
	
	$(function() {
		loadSubMenu('#root');
		initDialog();
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
		dialog.dialog( "open" );
		
		var menu_id = $(obj).attr('menu_id');
		$('#menu_detail').load('view.jsp',{menu_id: menu_id}, function(){
			$( "#order_no" ).spinner({ min: 1 });
		}).show();
		
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
		var form = $('#menu_form');

		//폼 정합성 체크
		//var isSuccess = $.valedForm($('[valid]',form));
		//if(!isSuccess) return false;	
		var page_access_group = '';
		var page_access_group_view = $('input:checked[name=page_access_group_view]');
		
		for(var i=0; i<page_access_group_view.length; i++){
			page_access_group += ',' + $(page_access_group_view[i]).val();
		}
		page_access_group = page_access_group.substring(1);
		$('[name=page_access_group]').val(page_access_group);
		
		var formData =$(form).serializeArray();
		

		var url = 'update.jsp';
		if(!valid('#menu_form')){
			return;
		};
		mask();
		
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
			
			mask_off();
		});
	}
	function valid(formId){
		var ctls = $('[valid=notempty]',$(formId));
		
		for(var i=0; i<ctls.length ; i++){
			var ctl = $(ctls[i]);
			var val = ctl.val().trim();
			ctl.val(val);
			if(val==''){
				alert($('[label='+ctl.attr('name')+']').text() + '에 값이 없습니다.');
				ctl.focus();
				return false;
			}
		}
		
		return true;
	}
	function mask(){
		//Get the screen height and width
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();
		//Set height and width to mask to fill up the whole screen
		var mask = $('#mask');

		if(mask.length<1){
			$('body').append($('<div style="background: #cccccc;position: absolute;top: 0px;left: 0px;z-index: 9999; text-align: center;padding-top: 200px;" id="mask"><span style="background: #ffffff;color:#0000ff;border:1px solid #ffffff;">처리중...</span></div>'));
			mask = $('#mask');
		}
		mask.css({'width':maskWidth,'height':maskHeight});
		
		//$('#mask').fadeIn(100);	//여기가 중요해요!!!1초동안 검은 화면이나오고
		$('#mask').fadeTo("slow",0.3);   //80%의 불투명도로 유지한다 입니다. ㅋ

	}
	function mask_off(){
		
		setInterval(function () {
			$('#mask').hide();
		}, 1000);		
	}
</script>
</head>
<body >

<c:import url="menu.jsp">
	<c:param name="current_menu" value="me01-1"/>
</c:import>


	
<div id="main_body">
	<div class="ui-jqgrid-titlebar ui-widget-header ui-corner-top ui-helper-clearfix" style="padding: 3px;width: 170px;">
		<b style="font-size: 14px;padding: 20px;">메뉴목록</b>
	</div>
	<table class="bd" border="0" style=" " >
		<colgroup>
			<col width="300">
			<col width="420">
			<col width="100">
			<col width="60">
			<col width="120">
		</colgroup>
		<tr id="root"  class="root_sub sub_menu ui-jqgrid-labels" dep="1">
			<th class="ui-state-default ui-th-column ui-th-ltr">메뉴명</th>
			<th class="ui-state-default ui-th-column ui-th-ltr">메뉴경로</th>
			<th class="ui-state-default ui-th-column ui-th-ltr">메뉴아이디</th>
			<th class="ui-state-default ui-th-column ui-th-ltr">순서</th>
			<th class="ui-state-default ui-th-column ui-th-ltr"><span id="btn_save" class="btn_sm" style=" cursor:pointer;" onclick="addSubMenu('root', '1')">메인메뉴등록</span></th>
		</tr>
	</table>
	
	<div id="root__sub"></div>
	
	<div id="menu_detail" style="display:none;"></div>
</div>
</body>
</htm>