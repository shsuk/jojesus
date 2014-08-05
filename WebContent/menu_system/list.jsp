<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">

<head>
<link href="contents.css" rel="stylesheet" type="text/css" />
<script src="../jquery/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript">
	
	$(function() {
		$('#menu_list').load('load_menu.jsp', function(){
			var menu_data = $('[uid=root]');
			$('#menu_datas').append(menu_data);
		});

		
	});
	
	function loadMenu(obj, dep){
		var menu_id = $(obj).attr('menu_id');
		if(menu_id==''){
			return;
		}
		$('#'+menu_id+'_f').attr('src','fd_o.png');
		$(obj).attr('menu_id','');
		$(obj).css('cursor','');
		$('#'+menu_id+'__sub').load('load_menu.jsp',{upp_menu_id: menu_id, dep:dep},function(){
			var menu_data = $('[uid='+menu_id+']');
			$('.'+menu_id+'__sub').after(menu_data);
		});
		
	}
	function editMenu(obj){
		var menu_id = $(obj).attr('menu_id');
		$('#menu_detail').load('view.jsp',{menu_id: menu_id}).show();
		
	}
	function addSubMenu(menu_id){


		$('#menu_detail').load('view.jsp',{upp_menu_id: menu_id}).show();
		
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
		$.post(url, formData, function(response, textStatus, xhr){

			var data = $.parseJSON(response);
			
			if(data.success){
				document.location.href='list.jsp';
			}else{
				alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.message);
			}
			
		});
	}
</script>
</head>
<body >

<c:import url="menu.jsp">
	<c:param name="page_id">me02</c:param>
</c:import>
	
<div id="menu_body" style="margin: 0 auto;width: 1100px;position: relative; clear: both;">
	<table style="width: 100%;"><tr>
		<td><b style="font-size: 14px;">메뉴목록</b></td>
	</tr></table>

	<table class="bd" border="0" style=" " >
		<colgroup>
				<col width="300" align="left">
				<col width="440" align="left">
				<col width="180" align="left">
				<col width="60" align="left">
				<col width="120" align="left">
		</colgroup>
		<tr>
			<th>메뉴아이디</th>
			<th>메뉴경로</th>
			<th>접근권한</th>
			<th>순서</th>
			
			<th><span id="btn_save" class="btn_sm" style=" cursor:pointer;" onclick="addSubMenu('root')">메인메뉴등록</span></th>
		</tr>
		<tbody id="menu_datas"></tbody>
	</table>
	
	<div id="menu_list"></div>
	<div id="menu_detail" style="display:none; width: 900px;position: absolute;top:30px;left:200px;background: #ffffff;border:1px solid #cccccc;padding: 10px;"></div>
</div>
</body>
</htm>