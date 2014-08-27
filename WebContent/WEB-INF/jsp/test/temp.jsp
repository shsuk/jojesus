<%@ page contentType="text/html; charset=utf-8"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags/tag" %>

<sp:sp queryPath="notice" action="list" processorList="attach,mybatis" exception="false">
	{
		//rows:10,_start:1,notice_id=72
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
	
		
			<table class="vw" border="0" cellspacing="0" cellpadding="0"  style="margin-bottom: 10px;">
			<colgroup>
				<col width="150">
				<col width="*">
			</colgroup>
		
			<tr>
					<th label="cnt">cnt</th>
					<td><span name="cnt" value="${cnt.cnt}"   class="" cnt_index="">
		${cnt.cnt}</span>
	</td>
				</tr></table><table class="vw" border="0" cellspacing="0" cellpadding="0"  style="margin-bottom: 10px;">
			<colgroup>
				<col width="150">
				<col width="*">
			</colgroup>
		
			<tr>
					<th label="notice_id">notice_id</th>
					<td><span name="notice_id" value="${row.notice_id}"   class="" row_index="">
		${row.notice_id}</span>
	</td>
				</tr>
			<tr>
					<th label="subject">subject</th>
					<td><span name="subject" value="${row.subject}"   class="" row_index="">
		${row.subject}</span>
	</td>
				</tr>
			<tr>
					<th label="contents">contents</th>
					<td><span name="contents" value="${row.contents}"   class="" row_index="">
		${row.contents}</span>
	</td>
				</tr>
			<tr>
					<th label="stt_dt">stt_dt</th>
					<td><span name="stt_dt" value="${row.stt_dt}"   class="" row_index="">
		${row['stt_dt@yyyy-MM-dd']}</span>
	</td>
				</tr>
			<tr>
					<th label="end_dt">end_dt</th>
					<td><span name="end_dt" value="${row.end_dt}"   class="" row_index="">
		${row.end_dt}</span>
	</td>
				</tr>
			<tr>
					<th label="use_yn">use_yn</th>
					<td><span name="use_yn" value="${row.use_yn}"   class="" row_index="">
		${row.use_yn}</span>
	</td>
				</tr>
			<tr>
					<th label="qry_cnt">qry_cnt</th>
					<td><span name="qry_cnt" value="${row.qry_cnt}"   class="" row_index="">
		${row.qry_cnt}</span>
	</td>
				</tr>
			<tr>
					<th label="reg_id">reg_id</th>
					<td><span name="reg_id" value="${row.reg_id}"   class="" row_index="">
		${row['reg_id@#,##0']}</span>
	</td>
				</tr>
			<tr>
					<th label="reg_dt">reg_dt</th>
					<td><span name="reg_dt" value="${row.reg_dt}"   class="" row_index="">
		${row['reg_dt@yyyy-MM-dd']}</span>
	</td>
				</tr>
			<tr>
					<th label="chg_id">chg_id</th>
					<td><span name="chg_id" value="${row.chg_id}"   class="" row_index="">
		${row.chg_id}</span>
	</td>
				</tr>
			<tr>
					<th label="chg_dt">chg_dt</th>
					<td><span name="chg_dt" value="${row.chg_dt}"   class="" row_index="">
		${row.chg_dt}</span>
	</td>
				</tr></table><table class="lst" border="0" cellspacing="0" cellpadding="0"  style="margin-bottom: 10px;">
			<tr><th label="notice_id">notice_id</th><th label="subject">subject</th><th label="noti_dt">noti_dt</th><th label="use_yn">use_yn</th><th label="qry_cnt">qry_cnt</th><th label="reg_id">reg_id</th><th label="reg_dt">reg_dt</th><th label="chg_id">chg_id</th><th label="chg_dt">chg_dt</th><th label="attach">attach</th></tr><c:forEach var="row" items="${rows }" varStatus="status">
				<tr class="row_${status.index + 1}">
					<td ><span name="notice_id" value="${row.notice_id}"   class="" row_index="row_${status.index + 1}">
		${row.notice_id}</span>
	</td>
					<td ><span name="subject" value="${row.subject}"   class="" row_index="row_${status.index + 1}">
		${row.subject}</span>
	</td>
					<td ><span name="noti_dt" value="${row.noti_dt}"   class="" row_index="row_${status.index + 1}">
		${row.noti_dt}</span>
	</td>
					<td ><span name="use_yn" value="${row.use_yn}"   class="" row_index="row_${status.index + 1}">
		${row.use_yn}</span>
	</td>
					<td ><span name="qry_cnt" value="${row.qry_cnt}"   class="" row_index="row_${status.index + 1}">
		${row.qry_cnt}</span>
	</td>
					<td align="right"><span name="reg_id" value="${row.reg_id}"   class="" row_index="row_${status.index + 1}">
		${row['reg_id@#,##0']}</span>
	</td>
					<td align="center"><span name="reg_dt" value="${row.reg_dt}"   class="" row_index="row_${status.index + 1}">
		${row['reg_dt@yyyy-MM-dd']}</span>
	</td>
					<td ><span name="chg_id" value="${row.chg_id}"   class="" row_index="row_${status.index + 1}">
		${row.chg_id}</span>
	</td>
					<td ><span name="chg_dt" value="${row.chg_dt}"   class="" row_index="row_${status.index + 1}">
		${row.chg_dt}</span>
	</td>
					<td ><span name="attach" value="${row.attach}"   class="" row_index="row_${status.index + 1}">
		${row.attach}</span>
	</td>
					</tr>
			</c:forEach></table></form>
		<div style="clear: both;width: 100%;height: 25px;margin-top: 10px;">
			<div class=" ui-widget-header ui-corner-all" style="float: right; cursor: pointer; padding: 3px 10px;" onclick="form_submit()">저장</div>
		</div>
</div>
<!-- 
{ "stt_dt_type":"date", "subject_label":"subject", "chg_dt_label":"chg_dt", "notice_id_label":"notice_id", "attach_label":"attach", "qry_cnt_label":"qry_cnt", "chg_id_type":"text", "reg_dt_label":"reg_dt", "formData":"", "use_yn_type":"text", "action":"list", "noti_dt_type":"text", "subject_type":"text", "defaultValue":"rows:10,_start:1,notice_id=72", "_dumy":"1409119697612", "chg_dt_type":"text", "end_dt_type":"text", "reg_id_label":"reg_id", "notice_id_type":"text", "qry_cnt_type":"text", "chg_id_label":"chg_id", "use_yn_label":"use_yn", "stt_dt_label":"stt_dt", "cnt_type":"text", "contents_label":"contents", "cnt_label":"cnt", "queryPath":"notice", "_ps":"admin/src/src_make", "reg_dt_type":"date", "contents_type":"text", "attach_type":"text", "reg_id_type":"number", "noti_dt_label":"noti_dt", "end_dt_label":"end_dt"}
-->
