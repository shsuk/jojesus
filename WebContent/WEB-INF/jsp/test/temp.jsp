<%@ page contentType="text/html; charset=utf-8"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags/tag" %>

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
	
	
	
	function form_submit(){	
		var form = $('#main_form');
		//폼 정합성 체크
		if(!valid(form)){
			return;
		}
	
		var formData =$(form).serializeArray();		
		var url = form.attr('action');

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

<div id="main_layer" style="margin: 0 auto; padding:3px; width: 90%; min-width:1000px; border:1px solid #cccccc;">
	<form id="main_form" action="" >
	<table class="vw" border="0" cellspacing="0" cellpadding="0" >
		<c:set var="row" value="${rows }"></c:set>
					<colgroup>
						<col width="150">
						<col width="*">
					</colgroup>
				
					<tr>
							<th label="rid">rid</th>
							<td><span name="rid" value="${row.rid}"   class="" row_index="">
		${row['rid@#,##0']}</span>
	</td>
						</tr>
					<tr>
							<th label="group_id">group_id</th>
							<td><span name="group_id" value="${row.group_id}"   class="" row_index="">
		${code:name('group_id', row['group_id'],null)}</span>
	</td>
						</tr>
					<tr>
							<th label="code_value">code_value</th>
							<td><span name="code_value" value="${row.code_value}"   class="" row_index="">
		${row.code_value}</span>
	</td>
						</tr>
					<tr>
							<th label="code_name">code_name</th>
							<td><span name="code_name" value="${row.code_name}"   class="" row_index="">
		${row.code_name}</span>
	</td>
						</tr>
					<tr>
							<th label="reference_value">reference_value</th>
							<td><span name="reference_value" value="${row.reference_value}"   class="" row_index="">
		${row['reference_value@yyyy-MM-dd']}</span>
	</td>
						</tr>
					<tr>
							<th label="order_no">order_no</th>
							<td><input type="text" name="order_no" value="${row.order_no}" class="spinner" style="width: 100px;" maxlength="10"  >
			</td>
						</tr>
					<tr>
							<th label="depth">depth</th>
							<td>
				<tag:select name="depth" groupId="depth" selected="${row.depth}" />
			</td>
						</tr>
					<tr>
							<th label="use_yn">use_yn</th>
							<td>
				<tag:select name="use_yn" groupId="use_yn" selected="${row.use_yn}" />
			</td>
						</tr>
					<tr>
							<th label="edit_type">edit_type</th>
							<td>
				<tag:select name="edit_type" groupId="edit_type" selected="${row.edit_type}" />
			</td>
						</tr>
					<tr>
							<th label="reg_dt">reg_dt</th>
							<td><input type="text" name="reg_dt" value="${row.reg_dt}" class="datepicker" style="width: 100px;" maxlength="19"  >
			</td>
						</tr>
					<tr>
							<th label="mod_dt">mod_dt</th>
							<td><span name="mod_dt" value="${row.mod_dt}"   class="" row_index="">
		${row['mod_dt@yyyy-MM-dd']}</span>
	</td>
						</tr>
					<tr>
							<th label="mod_user">mod_user</th>
							<td><span name="mod_user" value="${row.mod_user}"   class="" row_index="">
		${row.mod_user}</span>
	</td>
						</tr>
					<tr>
							<th label="code_img_id">code_img_id</th>
							<td><span name="code_img_id" value="${row.code_img_id}"   class="" row_index="">
		${row.code_img_id}</span>
	</td>
						</tr></table>
	</form>
		<div style="clear: both;width: 100%;height: 25px;margin-top: 10px;">
			<div class=" ui-widget-header ui-corner-all" style="float: right; cursor: pointer; padding: 3px 10px;" onclick="form_submit()">저장</div>
		</div>
</div>
<!-- 
{ "rid_label":"rid", "reg_dt_edit":"edit", "code_name_type":"text", "edit_type_type":"select", "code_img_id_label":"code_img_id", "code_value_label":"code_value", "order_no_type":"number", "group_id_label":"group_id", "depth_edit":"edit", "rid_type":"number", "mod_dt_type":"date", "reg_dt_label":"reg_dt", "code_name_label":"code_name", "formData":"", "use_yn_type":"select", "mod_user_label":"mod_user", "action":"test", "depth_type":"select", "defaultValue":"", "_dumy":"1408436218316", "order_no_label":"order_no", "use_yn_label":"use_yn", "reference_value_type":"date", "mod_user_type":"text", "order_no_edit":"edit", "use_yn_edit":"edit", "edit_type_label":"edit_type", "code_value_type":"text", "queryPath":"test/crud", "code_img_id_type":"text", "group_id_type":"select", "mod_dt_label":"mod_dt", "edit_type_edit":"edit", "reg_dt_type":"date", "reference_value_label":"reference_value", "depth_label":"depth"}
-->
