<%@ page contentType="text/html; charset=utf-8"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>

<sp:sp queryPath="menu_system/notice" action="v" processorList="db" exception="true"/>

<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">

<head>
<link href="../jquery/development-bundle/themes/redmond/jquery.ui.all.css"  rel="stylesheet" type="text/css" media="screen" />
<link href="../menu_system/contents.css" rel="stylesheet" type="text/css" />

<script src="../jquery/js/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="../jquery/js/jquery-ui-1.10.0.custom.min.js" type="text/javascript"></script>
<script src="../jquery/jqgrid/js/i18n/grid.locale-en.js" type="text/javascript"></script>
<script src="../menu_system/commonUtil.js" type="text/javascript"></script>

<script src="../se/js/HuskyEZCreator.js" type="text/javascript"  charset="utf-8"></script>

<script type="text/javascript">
	
	$(function() {
		$('.datepicker').datepicker(option);
		var currentDate = $( "#stt_dt" ).datepicker( "getDate" );
		if(currentDate==null){
			$( "#stt_dt" ).datepicker( "setDate" , new Date());
			$( "#end_dt" ).datepicker( "setDate" , new Date());
		}
		addAttach();
		initEditor();
	});
	
	function list(){
		document.location.href = 'list.jsp';
	}
	function addAttach(){
		$('#attachs').append($('.attachTpl').clone().removeClass('attachTpl').show());
	}
	function save(){
		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
		var ir = $('#ir1');
		var val = ir.val();
		//alert(val);
		if(!valid('#noti_form')){
			return;	
		}
		var form = $('#noti_form');
		//form.attr('target' , "uploadIFrame");
		form.submit();
	}
	function delFile(file_id){
		$('#'+file_id).val(file_id);
		$('.'+file_id).hide();
	}
	
	//에디터 소스 시작
	function initEditor() {
		// 추가 글꼴 목록
		//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];
	
		nhn.husky.EZCreator.createInIFrame({
			oAppRef: oEditors,
			elPlaceHolder: "ir1",
			sSkinURI: "../se/SmartEditor2Skin.html",	
			htParams : {
				bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : false,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : false,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
				fOnBeforeUnload : function(){
					//alert("완료!");
				}
			}, //boolean
			fOnAppLoad : function(){
				//에디터 로딩이 완료된 후에 본문에 삽입
				oEditors.getById["ir1"].exec("PASTE_HTML", ['']);
				$($('iframe')[0]).contents().find('.se2_multy').hide();
			},
			fCreator: "createSEditor2"
		});
	}
	//에디터 소스 끝

</script>
</head>
<body >

<c:import url="../menu_system/menu.jsp">
	<c:param name="current_menu" value="mm3-1"/>
</c:import>


<div id="main_body" >
	<div class="ui-jqgrid-titlebar ui-widget-header ui-corner-top ui-helper-clearfix" style="padding: 3px;width: 170px;">
		<b style="font-size: 14px;padding: 20px;">공지사항 상세</b>
	</div>
	<form id="noti_form" action="../at.sh?_ps=voj/action" method="post" enctype="multipart/form-data">
		<input type="hidden" name="action" id="action" value="${req.notice_id== 0 ? 'i' : 'u'}">
		<input type="hidden" name="notice_id" id="notice_id" value="${row.notice_id}">
		<table class="vw" cellspacing="0" cellpadding="0" border="0" style="width: 100%;margin-bottom: 10px;">
			<tr>
				<th style="color:#0100FF; width: 150px;">작성자</th>
				<td >${row.reg_id }</td>
			</tr>
			<tr>
				<th style="color:#0100FF; width: 150px;" label="subject">제목</th>
				<td ><input type="text" name="subject" id="subject" value="${row.subject }" valid="notempty" style="width: 90%;"></td>
			</tr>
			<tr>
				<th style="color:#0100FF; width: 150px;"  label="stt_dt"><span  label="end_dt">공지기간</span></th>
				<td >
					<input type="text" class="datepicker" name="stt_dt" id="stt_dt" value="${row.stt_dt }" readonly="readonly" valid="notempty,rangedate:stt_dt:end_dt" style="100px;" > ~
					<input type="text" class="datepicker" name="end_dt" id="end_dt" value="${row.end_dt }" readonly="readonly" valid="notempty,rangedate:stt_dt:end_dt" style="100px;" > 
				</td>
			</tr>
			<tr>
				<th style="color:#0100FF; width: 150px;" label="ir1">내용</th>
				<td height="300" >
					<div style="overflow: hidden; height: 337px;">
						<textarea name="ir1" id="ir1" title="내용" style="width:100%; height:300px; display:none;" valid="notempty">${row.CONTENTS }</textarea>
					</div>
				</td>
			</tr>
			
		</table>	
		<div style="float: left; ">파일용량이 크면 업로드시 많은 시간이 소요됩니다.</div>
		<div style="float: right; cursor: pointer;padding-right: 25px;" onclick="addAttach()">추가</div>
		<table class="vw" cellspacing="0" cellpadding="0" border="0" style="clear:both; width: 100%; margin-top: 10px;margin-bottom: 20px;">
			<tr>
				<th style="color:#0100FF; width: 150px;" label="attach">첨부파일</th>
				<td style="color:#6799FF; ">
					<c:forEach var="row" items="${rows }">
						<div style="margin: 2px;" class="${row.file_id}">
							<div style="float: left; width: 87%;">${row.file_name }<input type="hidden" name="del_file_id" id="${row.file_id}" value=""></div>
							<div style="float: right;   padding-right: 20px; cursor: pointer;" onclick="delFile('${row.file_id}')">삭제</div>
						</div>
					</c:forEach>
					<div id="attachs" style="clear:both; width: 100%;">
					</div>
				</td>
			</tr>
		</table>	
	</form>
	<div class="attachTpl" style="display: none; padding: 1px;">
		<input type="file" name="attach"  style="width: 87%;float: left;margin: 2px;" valid="ext:jpg:png:xls:doc:ppt:xlsx:docx:pptx:pdf">
		<div  style="float: right; padding-right: 20px; cursor: pointer; margin: 2px;" onclick="$($(this).parent()).remove()" >삭제</div>
	</div>
	<div>
		<div id="btn_list" class="btn"  style="cursor:pointer; float: right; " onclick="list()">목록</div>
		<div id="btn_update" class="btn"  style="cursor:pointer; float: right; " onclick="save()">저장</div>
	</div>
</div>		

<iframe id="uploadIFrame" name="uploadIFrame" style="display:none;visibility:hidden"></iframe>

</body>
</htm>