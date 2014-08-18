<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags" %> 

<sp:sp queryPath="menu_system/notice" action="v" processorList="db" exception="true"/>

<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">

<head>
<link href="../jquery/development-bundle/themes/redmond/jquery.ui.all.css"  rel="stylesheet" type="text/css" media="screen" />
<link href="../jquery/jqgrid/css/ui.jqgrid.css"  rel="stylesheet" type="text/css" media="screen" />
<link href="../jquery/jqgrid/plugins/ui.multiselect.css" rel="stylesheet" type="text/css" media="screen" />
<link href="../menu_system/contents.css" rel="stylesheet" type="text/css" />

<script src="../jquery/js/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="../jquery/js/jquery-ui-1.10.0.custom.min.js" type="text/javascript"></script>
<script src="../jquery/jqgrid/js/i18n/grid.locale-en.js" type="text/javascript"></script>
<script src="../jquery/jqgrid/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script src="../menu_system/commonUtil.js" type="text/javascript"></script>

<script type="text/javascript">
	
	$(function() {

	});
	
	function list(){
		document.location.href = 'list.jsp';
	}
	function edit(){
		document.location.href = 'edit.jsp?notice_id=${req.notice_id}';
	}
	function del(){
		if(!confirm("정말로 삭제하시겠습니까?")) {
			return;
		}
		$.post('action.jsp',{
			action: 'd', 
			notice_id: '${req.notice_id}'
		},function(response){
			var data = $.parseJSON(response);
			
			if(data.success){
				list();
			}else{
				alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n");
			}
		}
	);
	}

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
	<table class="vw" cellspacing="0" cellpadding="0" border="0" style="width: 100%">
		<tr>
			<td class="tdt tdl" align="center" style="color:#0100FF; "><b>${row.subject }</b></td>
		</tr>
		<tr>
			<td class="tdl">
				<div style=" float: left;padding-left: 20px;">
					*${row.reg_dt }
					*공지기간 : ${row.stt_dt } ~ ${row.end_dt }
			 	</div>
				<div style=" float: right;padding-right: 20px; ">
					*작성자 : ${row.reg_id }
					*hit : ${row.qry_cnt }
				</div>
			</td>
		</tr>
		<tr>
			<td class="tdl"><div style="min-height: 300px; width: 100%">${row.CONTENTS }</div></td>
		</tr>
	</table>	
	<table class="vw" cellspacing="0" cellpadding="0" border="0" style="width: 100%; margin-top: 10px;margin-bottom: 20px;">
		<tr>
			<th style="color:#0100FF; width: 150px;">첨부파일</th>
			<td style="color:#6799FF; ">
				<c:forEach var="row" items="${rows }">
					<img src="../menu_system/attach.png"  ><a href="${row.file_path }">${row.file_name }</a>&nbsp;
				</c:forEach>
			</td>
		</tr>
	</table>	

	<div>
		<div id="btn_list" class="btn"  style="cursor:pointer; float: right; " onclick="list()">목록</div>
		<tag:role type="save">
			<div id="btn_del" class="btn"  style="cursor:pointer; float: right; " onclick="del()">삭제</div>
			<div id="btn_update" class="btn"  style="cursor:pointer; float: right; " onclick="edit()">수정</div>
		</tag:role>
	</div>
</div>		

</body>
</htm>