<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<sp:sp queryPath="menu_system/favorite" action="org_items" processorList="attach,db" exception="false">
	{}
</sp:sp>

<c:forEach var="row" items="${rows }" varStatus="status">
	<tr class="row_${status.index + 1}">
		<td align="center">
			<input type="checkbox"  name="check_item" value="${row.item_code}">			
		</td>
		<td align="center">
			<input class="item_code" type="hidden" name="item_code" value="${row.item_code}" >
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
					