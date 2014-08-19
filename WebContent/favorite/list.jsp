<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags/tag" %> 
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
<script src="../menu_system/commonUtil.js" type="text/javascript"></script>
<script type="text/javascript">
	$(function() {
		$(document).on('change', '.check_all', function(e){
			var srcId = $(e.target).attr('name');
			$('[type=checkbox]',$('#'+srcId)).prop('checked', $(e.target).prop('checked'));
		});
		add();
	});
	function search(){
		var form = $('#search_form');
		//폼 정합성 체크
		if ($('#search_val').val().trim().length < 2) {
			alert('검색어는 2자 이상이 되어야 합니다.');
			return;
		}
		
		var formData = $(form).serializeArray();
		$('#org_items').load('org_items.jsp',formData);
		
	}
	function link_favorite_name(obj) {
		var favorite_seq = getVal('favorite_seq', obj);
		//alert(favorite_seq);
		$('#favorite_items').load('favorite_items.jsp',{favorite_seq: favorite_seq});
		
		$('#save_btn').show();
	}
	function add() {
		$('#favorite_items').load('favorite_items.jsp',{favorite_seq: 0});
		$('#save_btn').show();
	}
	function add_item(){
		move($('#org_items'), $('#item_list'));
	}
	function del_item(){
		move($('#item_list'), $('#org_items'));
		
	}
	function move(src, trg){
		$('.check_all').prop('checked', false)
		var items = $(':checked[name=check_item]', src);
		
		for(var i=items.length-1; i >= 0; i--){
			var item = $(items[i]);
			var item_code = item.val();
			//중복체크
			var titems = $('.item_code[value='+item_code+']', trg);
			
			if(titems.length>0){
				item.parent().parent().remove();
			}else{
				trg.append(item.prop('checked', false).parent().parent());
			}
		}
	}
	function form_submit() {
		var form = $('#main_form');
		//폼 정합성 체크
		if (!valid(form)) {
			return;
		}
		
		var formData = $(form).serializeArray();
		
		var action = $('[name=favorite]', form).val();
		action = action=='' ? 'i' : 'u';
		formData.push({ name: 'action' , value: action});
		var url = form.attr('action');
	
		$.post(url, formData, function(response, textStatus, xhr) {
	
			var data = $.parseJSON(response);
	
			if (data.success) {
				document.location.href = 'list.jsp';
			} else {
				alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n"
						+ data.message);
			}
		});
	
	}
</script>
</head>
<body>
	<div id="menu_detail" style=""></div>

	<c:import url="../menu_system/menu.jsp">
		<c:param name="current_menu" value="me01-1" />
	</c:import>

	<div id="main_body" >

		<sp:sp queryPath="menu_system/favorite" action="l" processorList="attach,db" exception="false">
			{
				user_seq:1
			}
		</sp:sp>

		<div id="main_layer" style="margin: 0 auto; padding: 0px; width: 100%; min-width: 900px; ">
				<table  class="lst" style="width: 100%;">
					<tr>
						<td  style="width: 150px;" valign="top">
							<table class="lst" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<th label="favorite_name">즐겨찾기</th>
								</tr>
								<c:forEach var="row" items="${rows }" varStatus="status">
									<tr class="row_${status.index + 1}">
										<td>
											<input type="hidden" name="use_yn" value="${row.use_yn}"  >
											<input type="hidden" name="favorite_seq" value="${row.favorite_seq}" >
											<span name="favorite_name" value="${row.favorite_name}" onclick="link_favorite_name(this)" class="link" row_index="row_${status.index + 1}"> ${row.favorite_name}</span>
										</td>
									</tr>
								</c:forEach>
							</table>
						</td>
						<td valign="top">
						
							<table style="width: 100%; border: 0px; height: 500px;" >
								<tr>
									<%//즐겨찾기 입력폼 %>
									<td valign="top"  style="width: 50%;">
										<form id="main_form" action="action.jsp" >
											<div id="favorite_items" >
												
											</div>
										</form>
									</td>
									<%//이동 버튼 %>
									<td style="width: 60px;border: 0px;" align="center" valign="middle">
									
										<div class=" btn ui-corner-all" style="width:40px; cursor: pointer; padding: 3px;" onclick="add_item()">< 추가</div><br><br>
										<div class=" btn ui-widget-header ui-corner-all" style="width:40px; cursor: pointer; padding: 3px;" onclick="del_item()">> 삭제</div>
										
									</td>
									<%//자재검색 %>
									<td valign="top"  style="width: 50%;">
										<form id="search_form">
										<div style="padding: 5px;">
											<tag:select_array codes="name=자재명,code=자재코드" name="search_type" style="width: 70px;"/>
											<input type="text" id="search_val" name="search_val" style="width: 200px;">
											<span class=" ui-widget-header ui-corner-all" style=" cursor: pointer; padding: 3px 10px;" onclick="search()">검색</span>
										</div>
										</form>
										
										<table class="lst" border="0" cellspacing="0" cellpadding="0" >
											<colgroup>
												<col width="40">
												<col width="100">
												<col width="*">
												<col width="50">
											</colgroup>
											<tr>
												<th><input type="checkbox" class="check_all" name="org_items"></th>
												<th>자재코드</th>
												<th>자재명</th>
												<th>단위</th>
											</tr>
										</table>
										<table class="lst" border="0" cellspacing="0" cellpadding="0" >
											<colgroup>
												<col width="40">
												<col width="100">
												<col width="*">
												<col width="50">
											</colgroup>
											<tbody  id="org_items"></tbody>
										</table>
									</td>
								</tr>
							</table>
							<%//저장버튼 %>
							<div style="clear: both; width: 100%; height: 25px; margin-top: 10px;">
								<div id="save_btn" class=" ui-widget-header ui-corner-all" style="float: right; cursor: pointer; display:none; padding: 3px 10px;margin-left: 10px;" onclick="form_submit()">저장</div>
								<div class=" ui-widget-header ui-corner-all" style="float: right; cursor: pointer; padding: 3px 10px;margin-left: 10px;" onclick="add()">신규등록</div>
							</div>
							
							
						</td>
					</tr>
				</table>

		</div>
		<!-- 
{ "favorite_seq_type":"number", "favorite_seq_label":"favorite_seq", "favorite_name_type":"text", "create_date_edit":"", "create_date_link":"", "use_yn_valid":"", "formData":"", "use_yn_type":"select", "action":"l", "defaultValue":"user_seq:1", "_dumy":"1408336032548", "use_yn_link":"", "create_date_label":"create_date", "use_yn_label":"use_yn", "create_date_valid":"", "use_yn_edit":"", "favorite_seq_link":"", "user_seq_type":"number", "queryPath":"menu_system/favorite", "view_type":"list", "favorite_seq_edit":"", "user_seq_edit":"", "user_seq_label":"user_seq", "favorite_name_label":"favorite_name", "favorite_name_edit":"", "user_seq_link":"", "favorite_seq_valid":"", "favorite_name_link":"link", "create_date_type":"date", "user_seq_valid":"", "favorite_name_valid":""}
-->


	</div>
</body>
</htm>