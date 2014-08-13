<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags" %> 
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
	var url = 'auth_list_load.jsp';
	
	$(function() {
		loadSubMenu('#root');
		
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
		
		$('#role_cd').change(function(){
			$('.menu_load').remove();
			loadSubMenu('#root');
		});
		<%//페이지 접근권한 설정%>
		$('#main_body').on('change', 'input.menu_ckeck[type=checkbox]', function(e){
			var ctl = $(e.currentTarget);
			var isChecked = ctl.is(':checked');

			var menu_id = ctl.attr('menu_id');
			var upp_menu_id = ctl.attr('upp_menu_id');
			var root_id = upp_menu_id=='root' ? 'root' : $('#'+upp_menu_id).attr('upp_menu_id');
			
			if(isChecked){
				$('.btn_acc',$('#'+menu_id)).prop('disabled',false);
				$('.btn_acc',$('#'+menu_id)).prop('checked',true);//UI상에서 버튼권한 설정
				$('.menu_ckeck[menu_id='+upp_menu_id+']').prop('checked',true).trigger('change');//상위메뉴 접근권한 설정
				$('.menu_ckeck[menu_id='+root_id+']').prop('checked',true).trigger('change');//상위의 상위메뉴 접근권한 설정
			}else{
				$('.btn_acc',$('#'+menu_id)).prop('disabled',true);
				$('.btn_acc',$('#'+menu_id)).prop('checked',false);//UI상에서 버튼권한 해제
				var sub = $('.menu_ckeck[upp_menu_id='+menu_id+']');
				sub.prop('checked',false).trigger('change');//하위메뉴 접근권한 해제
				var sub_id = sub.attr('menu_id');
				$('.menu_ckeck[upp_menu_id='+sub_id+']').prop('checked',false).trigger('change');//하위의 하위메뉴 접근권한 해제]
			}
			
			var row = $('#'+menu_id);
			mask();
			
			$.post('update.jsp',{
					action: isChecked ? 'acc' : 'noacc', 
					menu_id: menu_id,
					upp_menu_id: upp_menu_id,
					root_id: root_id,
					role_cd: $('#role_cd').val(),
					acc_read: $('[name=acc_read]', row).is(':checked') ? 'Y' : 'N' ,
					acc_save: $('[name=acc_save]', row).is(':checked') ? 'Y' : 'N',
					acc_excel: $('[name=acc_excel]', row).is(':checked') ? 'Y' : 'N'
				},function(response){
					var data = $.parseJSON(response);
					
					if(data.success){
						//document.location.href='list.jsp';
					}else{
						alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n");
					}
					mask_off();
				}
			);
		});

		<%//버튼 권한 설정%>
		$('#main_body').on('change', 'input.btn_acc[type=checkbox]', function(e){
			var ctl = $(e.currentTarget);
			var menu_id = ctl.attr('menu_id');
			
			var row = $('#'+menu_id);
			mask();
			$.post('update.jsp',{
					action: 'accbtn', 
					menu_id: menu_id,
					role_cd: $('#role_cd').val(),
					acc_read: $('[name=acc_read]', row).is(':checked') ? 'Y' : 'N' ,
					acc_save: $('[name=acc_save]', row).is(':checked') ? 'Y' : 'N',
					acc_excel: $('[name=acc_excel]', row).is(':checked') ? 'Y' : 'N'
				},function(response){
					var data = $.parseJSON(response);
					
					if(data.success){
						//document.location.href='list.jsp';
					}else{
						alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n");
					}
					mask_off();
				}
			);
		});
	
	});
	function loadSubMenu(sel){
		var menus = $(sel);
		for(var i=0; i<menus.length; i++){
			loadMenu(menus[i]);
		}
	}
	function loadMenu(obj){
		var menu_id = $(obj).attr('id');
		
		$(obj).removeClass('sub_menu');
		
		$('#'+menu_id+'__sub').load(url, {
				role_cd: $('#role_cd').val(), 
				upp_menu_id: menu_id, 
				dep: $(obj).attr('dep')
			},function(){
			var menu_data = $('.'+menu_id);
			$('#'+menu_id).after(menu_data);
			
			loadSubMenu('.sub_menu');
		});
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
	<c:param name="current_menu" value="me01-2"/>
</c:import>
	
<div id="main_body" >
	<div class="ui-jqgrid-titlebar ui-widget-header ui-corner-top ui-helper-clearfix" style="padding: 3px;width: 170px;float: left;">
		<b style="font-size: 14px;padding: 20px;">페이지 접근 권한</b>
	</div>
	<div style=" float: right;">
		<tag:select_array codes="1=직원,2=대리점,3=고객" name="role_cd" selected="${param.role_cd }" style="width:200px;"/>
	</div>

	<table style=" clear:both;;" class="bd" cellspacing="0" cellpadding="0" border="0"  >
		<colgroup>
			<col width="30">
			<col width="300">
			<col width="400">
			<col width="30">
			<col width="30">
			<col width="30">
		</colgroup>
		<tr id="root" dep="1" class="root_sub ui-jqgrid-labels" >
			<th class="ui-state-default ui-th-column ui-th-ltr">&nbsp;</th>
			<th class="ui-state-default ui-th-column ui-th-ltr">메뉴명</th>
			<th class="ui-state-default ui-th-column ui-th-ltr">메뉴경로</th>
			<th class="ui-state-default ui-th-column ui-th-ltr">조회</th>
			<th class="ui-state-default ui-th-column ui-th-ltr">저장</th>
			<th class="ui-state-default ui-th-column ui-th-ltr">엑셀</th>
		</tr>
	</table>
	
	<div id="root__sub"></div>
</div>
</body>
</htm>