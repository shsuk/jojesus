<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags" %> 


<sp:sp queryPath="menu_system/notice" action="w" processorList="db" exception="true">
	{
		menu_id: ''
	}
</sp:sp> 
<table style="width: 100%;"><tr>
	<td><b style="font-size: 14px;">메뉴정보관리</b></td>
	<td align="right">
		<div style=" cursor:pointer;"  onclick="$('#menu_detail').hide()"><img src="../images/icon/Close-2-icon.png"></div>
	</td>
</tr></table>
<form id="menu_form">
	<input type="hidden" name="action" value="${empty(row.menu_id) ? 'i' : 'u' }" >
	<table border="1" class="bd">
		<tr>
			<th width="150">상위메뉴</th>
			<td width="400">${empty(row.upp_menu_id) ? req.upp_menu_id : row.upp_menu_id}<input type="hidden" name="upp_menu_id" value="${empty(row.upp_menu_id) ? req.upp_menu_id : row.upp_menu_id}"></td>
		</tr>
		<tr>
			<th width="150">아이디</th>
			<td width="400"><input type="text" name="menu_id" value="${row.menu_id}" maxlength="10" ${empty(row.menu_id) ? '' : 'readonly=true' }>&nbsp;</td>
		</tr>
		<tr>
			<th>메뉴명</th>
			<td><input type="text" name="menu_name" value="${row.menu_name}" maxlength="15" valid="[[notempty]]" style="width: 90%;;"></td>
		</tr>
		<tr>
			<th>페이지 경로</th>
			<td><input type="text" name="page_url" value="${row.page_url}"  maxlength="200" valid="[[notempty]]" style="width: 90%;"></td>
		</tr>
		<tr>
			<th>접근권한</th>
			<td>
				<tag:check_array  name="page_access_group_view" checked="${row.page_access_group}" view="false"/>
				<input type="hidden" name="page_access_group" value="${row.page_access_group}" valid="[[notempty]]">
			</td>
		</tr>
		<tr>
			<th>노출 순서</th>
			<td><input type="text" name="order_no" value="${empty(row.order_no) ? '1' : row.order_no}" maxlength="3" valid="[[notempty]]" style=""></td>
		</tr>
		<tr>
			<th>수정자</th>
			<td>${row.chg_id}</td>
		</tr>
		<tr>
			<th>등록일</th>
			<td>${row.reg_dt}</td>
		</tr>
	
	</table>
</form>
<br>
<table style="width: 100%;"><tr>
	<td align="right">		
		<span id="btn_del" class="btn"  style="cursor:pointer; " onclick="del_menu()">삭제</span>
		<span id="btn_save" class="btn" style="cursor:pointer; " onclick="form_submit()">저장</span>
		<span class="btn" style="cursor:pointer;"  onclick="$('#menu_detail').hide()">닫기</span> 
	</td>
</tr></table>
