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
		
		$('#role_cd').change(function(){
			$('.menu_load').remove();
			loadSubMenu('#root');
		});
		
		$('#menu_body').on('change', 'input.menu_ckeck[type=checkbox]', function(e){
			var ctl = $(e.currentTarget);
			var isChecked = ctl.is(':checked');

			var menu_id = ctl.attr('menu_id');
			var upp_menu_id = ctl.attr('upp_menu_id');
			var root_id = upp_menu_id=='root' ? 'root' : $('#'+upp_menu_id).attr('upp_menu_id');
			
			if(isChecked){
				$('.menu_ckeck[menu_id='+upp_menu_id+']').prop('checked',true).trigger('change');
				$('.menu_ckeck[menu_id='+root_id+']').prop('checked',true).trigger('change');
			}else{
				var sub = $('.menu_ckeck[upp_menu_id='+menu_id+']');
				sub.prop('checked',false).trigger('change');
				var sub_id = sub.attr('menu_id');
				$('.menu_ckeck[upp_menu_id='+sub_id+']').prop('checked',false).trigger('change');
			}
			
			var row = $('#'+menu_id);
			$.post('update.jsp',{
					action: isChecked ? 'acc' : 'noacc', 
					menu_id: menu_id,
					upp_menu_id: upp_menu_id,
					root_id: root_id,
					role_cd: $('#role_cd').val(),
					acc_read: $('[name=acc_read]', row).is(':checked') ? 'Y' : 'N' ,
					acc_save: $('[name=acc_save]', row).is(':checked') ? 'Y' : 'N',
					acc_excel: $('[name=acc_excel]', row).is(':checked') ? 'Y' : 'N'
				},function(data){
					var data = $.parseJSON(response);
					
					if(data.success){
						//document.location.href='list.jsp';
					}else{
						alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n");
					}
				}
			);
		});

	
		$('#menu_body').on('change', 'input.btn_acc[type=checkbox]', function(e){
			var ctl = $(e.currentTarget);
			var menu_id = ctl.attr('menu_id');
			
			var row = $('#'+menu_id);
			
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

</script>
</head>
<body >

<c:import url="menu.jsp">
	<c:param name="menu_id">03</c:param>
</c:import>
	
<div id="menu_body" style="margin: 0 auto;width: 1100px;position: relative; clear: both;">
	<div>
		<tag:select_array codes="1=직원,2=대리점,3=고객" name="role_cd" selected="${param.role_cd }" style="width:200px;"/>
	</div>
	<div class="ui-jqgrid-titlebar ui-widget-header ui-corner-top ui-helper-clearfix" style="padding: 3px;">
		<b style="font-size: 14px;padding: 20px;">페이지 접근 권한</b>
	</div>

	<table class="bd" cellspacing="0" cellpadding="0" border="0"  >
		<colgroup>
			<col width="30">
			<col width="300">
			<col width="440">
			<col width="40">
			<col width="40">
			<col width="40">
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