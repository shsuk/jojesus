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
<script src="commonUtil.js" type="text/javascript"></script>
<script type="text/javascript">
	var url = 'auth_list_load.jsp';
	
	$(function() {
		//loadSubMenu('#root');
		
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
		<%//그룹변경시 그룹권한 읽기%>
		$('#role_cd').change(function(){
			$('.menu_load').remove();
			loadSubMenu('#root');
		});
		<%//페이지 접근권한 설정%>
		$('#main_body').on('change', 'input.menu_ckeck[type=checkbox]', function(e){
			var ctl = $(e.currentTarget);
			var isChecked = ctl.is(':checked');

			var menu_id = ctl.attr('_menu_id');
			var upp_menu_id = ctl.attr('_upp_menu_id');
			var root_id = upp_menu_id=='root' ? 'root' : $('#'+upp_menu_id).attr('_upp_menu_id');
			
			if(isChecked){
				$('.btn_acc',$('#'+menu_id)).prop('disabled',false);
				$('.btn_acc',$('#'+menu_id)).prop('checked',true);//UI상에서 버튼권한 설정
				$('.menu_ckeck[_menu_id='+upp_menu_id+']').prop('checked',true).trigger('change');//상위메뉴 접근권한 설정
				$('.menu_ckeck[_menu_id='+root_id+']').prop('checked',true).trigger('change');//상위의 상위메뉴 접근권한 설정
			}else{
				$('.btn_acc',$('#'+menu_id)).prop('disabled',true);
				$('.btn_acc',$('#'+menu_id)).prop('checked',false);//UI상에서 버튼권한 해제
				var sub = $('.menu_ckeck[_upp_menu_id='+menu_id+']');
				sub.prop('checked',false).trigger('change');//하위메뉴 접근권한 해제
				var sub_id = sub.attr('_menu_id');
				$('.menu_ckeck[_upp_menu_id='+sub_id+']').prop('checked',false).trigger('change');//하위의 하위메뉴 접근권한 해제]
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

		<%//버튼 권한 설정%>
		$('#main_body').on('change', 'input.btn_acc[type=checkbox]', function(e){
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
/* 	function loadSubMenu(sel){
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
	 */
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
		권한그룹 : <tag:select_array codes="1=직원,2=대리점,3=고객" name="role_cd" selected="${param.role_cd }" style="width:200px;"/>
	</div>
	
	<table  class="lst" border="0" style=" clear:both;;width: 100%;margin: 0px;" cellspacing="0" cellpadding="0">
		<colgroup>
			<col width="30">
			<col width="300">
			<col width="*">
			<col width="34">
			<col width="34">
			<col width="34">
			<col width="17">
		</colgroup>
		<thead>
			<tr >
				<th>&nbsp;</th>
				<th>메뉴명</th>
				<th>메뉴경로</th>
				<th>조회</th>
				<th>저장</th>
				<th>엑셀</th>
				<th></th>
			</tr>
		</thead>
	</table>

	<div  id="list_contents" style=" height: 600px; overflow-y: scroll;">
		<table  class="lst" border="0"  style=" clear:both;;width: 100%; margin: 0px;" cellspacing="0" cellpadding="0" >
			<colgroup>
				<col width="30">
				<col width="300">
				<col width="*">
				<col width="34">
				<col width="34">
				<col width="34">
			</colgroup>
			<tbody>
				<sp:sp queryPath="menu_system/menu" action="al" processorList="db,tree" exception="true">
					{
						_source:'rows',
						_upper_id_field_name:'upp_menu_id',
						_id_field_name:'menu_id',
						_level_name: 'level'
					}
				</sp:sp>
				
				<c:forEach var="row" items="${tree }">
						<tr id="${row.menu_id }" _upp_menu_id="${row.upp_menu_id }" class="${row.upp_menu_id } jqgfirstrow ovr_sub_menu" dep="${row.level+1}">
							<td align="left"><input type="checkbox" class="menu_ckeck" _menu_id="${row.menu_id }" _upp_menu_id="${row.upp_menu_id }" ${row.acc_page=='Y' ? 'checked=true' : '' }></td>
							<td>
								<c:set var="m_id"><img style="vertical-align:bottom;" id="${row.menu_id}_f" src="${row.menu_count > 0 ? 'folder.png' : 'menu.png' }"></c:set>
								<div style="vertical-align: middle; margin-left:${row.level*25-25}px;" >
									<span id="${row.menu_id}_tree">${m_id} </span> 
									<span  class="menu_name" style="" menu_id="${row.menu_id}" >${row.menu_name}</span>
								</div>
							</td>
							<td><div  style=" overflow: hidden;">${row.page_url}</div></td>
							<td align="center"><input type="checkbox" name="acc_read"  ${row.acc_page=='Y' ? '' : 'disabled="disabled"'} class="btn_acc" menu_id="${row.menu_id }" ${row.acc_read=='Y' ? 'checked=true' : ''}></td>
							<td align="center"><input type="checkbox" name="acc_save"  ${row.acc_page=='Y' ? '' : 'disabled="disabled"'} class="btn_acc" menu_id="${row.menu_id }" ${row.acc_save=='Y' ? 'checked=true' : '' }></td>
							<td align="center"><input type="checkbox" name="acc_excel" ${row.acc_page=='Y' ? '' : 'disabled="disabled"'} class="btn_acc" menu_id="${row.menu_id }" ${row.acc_excel=='Y' ? 'checked=true' : ''}></td>
						</tr>
				</c:forEach>

			</tbody>
		</table>
	</div>
	
</div>
</body>
</htm>