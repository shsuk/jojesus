<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags/tag" %> 
<sp:sp queryPath="menu_system/favorite" action="items" processorList="attach,db" exception="false">
	{
		user_seq:1
	}
</sp:sp>

<input type="hidden" name="favorite_seq" value="${row.favorite_seq }" >
<table class="lst" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<th>즐겨찾기명</th>
		<td>
			<input type="hidden" name="favorite_seq" value="${row.favorite_seq}"  >
			<input type="text" id="favorite_name" name="favorite_name" value="${row.favorite_name }" maxlength="30" valid="notempty" style="width: 90%;">			
		</td>
	</tr>
	<tr>
		<th>사용유무</th>
		<td>
			<tag:radio_array codes="Y=사용,N=미사용" name="use_yn"  checked="${empty(row.use_yn) ? 'Y' : row.use_yn }" />		
		</td>
	</tr>
</table>
<table class="lst" border="0" cellspacing="0" cellpadding="0" style="margin-top: 10px;">
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
	<tbody id="item_list">
	<c:forEach var="row" items="${rows }" varStatus="status">
		<tr class="row_${status.index + 1}">
			<td align="center">
				<input type="checkbox"  name="check_item" value="${row.item_code}">			
			</td>
			<td align="center">
				<input  class="item_code" type="hidden" name="item_code" value="${row.item_code}"  >
				<span name=""item_code"" value="${row.item_code}"  row_index="row_${status.index + 1}"> ${row.item_code}</span>
			</td>
			<td>
				<span name="favorite_name" value="${row.item_code}"  row_index="row_${status.index + 1}"> ${row.item_code}</span>
			</td>
			<td align="center">
				<span name="favorite_name" value="${row.item_code}"  row_index="row_${status.index + 1}"> ${row.item_code}</span>
			</td>
		</tr>
	</c:forEach>
	</tbody>
</table>

				