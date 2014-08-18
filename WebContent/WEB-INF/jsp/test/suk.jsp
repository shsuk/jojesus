<%@ page contentType="text/html; charset=utf-8"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/tag"%>

<sp:sp queryPath="test/crud" action="test" processorList="attach,db" exception="false">
	{
		//
	}
	
</sp:sp>

<script type="text/javascript">
	$(function() {
		//콘트롤 변경시 정합성 체크(미사용시 삭제)
		checkValidOnChange();
	});

	function form_submit() {
		var form = $('#main_form');
		//폼 정합성 체크
		if (!valid(form)) {
			return;
		}

		var formData = $(form).serializeArray();
		var url = form.attr('action');

		$.post(url, formData, function(response, textStatus, xhr) {

			var data = $.parseJSON(response);

			if (data.success) {
				document.location.href = 'list.jsp';
			} else {
				alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.message);
			}

		});
	}
</script>

<div id="main_layer" style="margin: 0 auto; padding: 3px; width: 90%; min-width: 1000px; border: 1px solid #cccccc;">
	<form id="main_form" action="">
		<table class="vw" border="0" cellspacing="0" cellpadding="0">
			<c:set var="row" value="${rows }"></c:set>
			<colgroup>
				<col width="150">
				<col width="*">
			</colgroup>

			<tr>
				<th label="rid">rid</th>
				<td><span name="rid" value="${row.rid}" class="" row_index=""> ${row['rid@#,##0']}</span></td>
			</tr>
			<tr>
				<th label="group_id">group_id</th>
				<td><span name="group_id" value="${row.group_id}" class="" row_index=""> ${code:name('group_id', row['group_id'],null)}</span></td>
			</tr>
			<tr>
				<th label="code_value">code_value</th>
				<td><input type="file" name="code_value" value="${row.code_value}" style="width: 90%;" maxlength="50"></td>
			</tr>
			<tr>
				<th label="code_name">code_name</th>
				<td><script type="text/javascript">
					$(function() {
						addAttach();
					});

					function addAttach() {
						$('#attachs').append($('.attachTpl').clone().removeClass('attachTpl').show());
					}

					function delFile(file_id) {
						$('#' + file_id).val(file_id);
						$('.' + file_id).hide();
					}
				</script>
					<div>
						<div style="float: right; cursor: pointer; padding-right: 20px;" onclick="addAttach()">
							<img src="menu_system/add-icon.png">
						</div>
						<!-- 이전파일 목록을 이곳에 추가하세요.
			아래 소스는 예제 입니다
		&c:forEach var="row" items="">
			<div style="margin: 2px;" class="">
				<div style="float: left; width: 87%;"><input type="hidden" name="del_file_id" id="" value=""></div>
				<div style="float: right;   padding-right: 20px; cursor: pointer;" onclick="delFile('')">삭제</div>
			</div>
		&/c:forEach>
		 -->
						<div id="attachs" style="clear: both; width: 100%;"></div>

					</div>

					<div class="attachTpl" style="display: none; padding: 1px;">
						<input type="file" name="code_name" style="width: 90%;" class="">
						<div style="float: right; padding-right: 17px; cursor: pointer; margin: 2px;" onclick="$($(this).parent()).remove()">
							<img src="menu_system/close-icon.png">
						</div>
					</div></td>
			</tr>
			<tr>
				<th label="reference_value">reference_value</th>
				<td><span name="reference_value" value="${row.reference_value}" class="" row_index=""> ${row.reference_value}</span></td>
			</tr>
			<tr>
				<th label="order_no">order_no</th>
				<td><span name="order_no" value="${row.order_no}" class="" row_index=""> ${row['order_no@#,##0']}</span></td>
			</tr>
			<tr>
				<th label="depth">depth</th>
				<td><span name="depth" value="${row.depth}" class="" row_index=""> ${code:name('depth', row['depth'],null)}</span></td>
			</tr>
			<tr>
				<th label="use_yn">use_yn</th>
				<td><span name="use_yn" value="${row.use_yn}" class="" row_index=""> ${code:name('use_yn', row['use_yn'],null)}</span></td>
			</tr>
			<tr>
				<th label="edit_type">edit_type</th>
				<td><span name="edit_type" value="${row.edit_type}" class="" row_index=""> ${code:name('edit_type', row['edit_type'],null)}</span></td>
			</tr>
			<tr>
				<th label="reg_dt">reg_dt</th>
				<td><span name="reg_dt" value="${row.reg_dt}" class="" row_index=""> ${row['reg_dt@yyyy-MM-dd']}</span></td>
			</tr>
			<tr>
				<th label="mod_dt">mod_dt</th>
				<td><span name="mod_dt" value="${row.mod_dt}" class="" row_index=""> ${row['mod_dt@yyyy-MM-dd']}</span></td>
			</tr>
			<tr>
				<th label="mod_user">mod_user</th>
				<td><span name="mod_user" value="${row.mod_user}" class="" row_index=""> ${row.mod_user}</span></td>
			</tr>
			<tr>
				<th label="code_img_id">code_img_id</th>
				<td><span name="code_img_id" value="${row.code_img_id}" class="" row_index=""> ${row.code_img_id}</span></td>
			</tr>
		</table>
	</form>
	<div style="clear: both; width: 100%; height: 25px; margin-top: 10px;">
		<div class=" ui-widget-header ui-corner-all" style="float: right; cursor: pointer; padding: 3px 10px;" onclick="form_submit()">저장</div>
	</div>
</div>
<!-- 
{ "mod_dt_valid":"", "rid_label":"rid", "rid_valid":"", "reg_dt_edit":"", "order_no_valid":"", "code_name_type":"files", "reference_value_valid":"", "edit_type_type":"select", "code_value_label":"code_value", "order_no_type":"number", "rid_type":"number", "mod_dt_type":"date", "reg_dt_label":"reg_dt", "code_name_label":"code_name", "formData":"", "code_img_id_valid":"", "code_name_edit":"edit", "depth_link":"", "group_id_link":"", "action":"test", "_dumy":"1408332701830", "defaultValue":"", "code_name_link":"", "order_no_label":"order_no", "code_img_id_edit":"", "use_yn_label":"use_yn", "mod_dt_edit":"", "reference_value_type":"text", "mod_user_type":"text", "group_id_valid":"", "order_no_edit":"", "use_yn_edit":"", "mod_user_valid":"", "code_value_valid":"", "code_value_edit":"edit", "edit_type_label":"edit_type", "code_value_type":"file", "rid_edit":"", "edit_type_valid":"", "code_img_id_type":"text", "reg_dt_type":"date", "reference_value_label":"reference_value", "code_name_valid":"", "order_no_link":"", "mod_user_edit":"", "group_id_edit":"", "code_img_id_label":"code_img_id", "rid_link":"", "group_id_label":"group_id", "depth_edit":"", "use_yn_valid":"", "use_yn_type":"select", "mod_user_label":"mod_user", "depth_type":"select", "mod_user_link":"", "use_yn_link":"", "code_value_link":"", "reference_value_edit":"", "depth_valid":"", "reg_dt_link":"", "queryPath":"test/crud", "code_img_id_link":"", "group_id_type":"select", "mod_dt_label":"mod_dt", "edit_type_edit":"", "mod_dt_link":"", "edit_type_link":"", "reg_dt_valid":"", "reference_value_link":"", "depth_label":"depth"}
-->
