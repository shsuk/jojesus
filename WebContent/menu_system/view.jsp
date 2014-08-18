<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags" %> 


<sp:sp queryPath="menu_system/menu" action="${empty(param.menu_id) ? 'a' : 'v' }" processorList="db" exception="true">
	{
		menu_id: ''
	}
</sp:sp> 
<div  style="width: 850px;"> 
	<form id="menu_form">
		<input type="hidden" name="action" value="${empty(row.menu_id) ? 'i' : 'u' }" >
		<table border="0" class="vw" >
			<tr>
				<th width="150" label="upp_menu_id">상위메뉴</th>
				<td width="*" class="tdt">
					${empty(row.upp_menu_id) ? req.upp_menu_id : row.upp_menu_id} (${empty(row.upp_menu_name) ? '최상위메뉴' : row.upp_menu_name})
					<input type="hidden" name="upp_menu_id" value="${empty(row.upp_menu_id) ? req.upp_menu_id : row.upp_menu_id}">
				</td>
			</tr>
			<tr>
				<th  label="menu_id">아이디</th>
				<td><input type="text" name="menu_id" value="${row.menu_id}" maxlength="10" ${empty(row.menu_id) ? '' : 'readonly=true' } valid="notempty" key_press="alpa_numeric" >&nbsp;</td>
			</tr>
			<tr>
				<th  label="menu_name">메뉴명</th>
				<td><input type="text" name="menu_name" value="${row.menu_name}" maxlength="15" valid="notempty" style="width: 90%;;"></td>
			</tr>
			<tr>
				<th  label="level">LEVEL</th>
				<td><input type="text" name="level" value="${empty(req.level) ? row.level : req.level}" maxlength="3" readonly="readonly"  style=""></td>
			</tr>
			<tr>
				<th  label="page_url">페이지 경로</th>
				<td><input type="text" name="page_url" value="${empty(row.page_url) ? '#' : row.page_url}"  maxlength="200" valid="notempty" style="width: 90%;padding: 1px;"></td>
			</tr>
			<tr>
				<th  label="order_no">노출 순서</th>
				<td><input type="text" name="order_no" id="order_no" value="${empty(row.order_no) ? '1' : row.order_no}"  maxlength="5" valid="notempty"  key_press="numeric" style=""></td>
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
	
	<table style="width: 100%; margin-top: 10px;"><tr>
		<td align="right">		
			<span id="btn_del" class="btn"  style="cursor:pointer; " onclick="del_menu()">삭제</span>
			<span id="btn_save" class="btn" style="cursor:pointer; " onclick="form_submit()">저장</span>
			<span class="btn" style="cursor:pointer;"  onclick="dialog.dialog( 'close' );">닫기</span> 
		</td>
	</tr></table>
</div>