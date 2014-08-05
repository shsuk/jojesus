<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags" %> 

<sp:sp queryPath="menu_system/crud" actionFild="act" processorList="db" exception="true">
	{
		act:'l'
	}
</sp:sp> 
<c:forEach var="row" items="${rows }">
	<table>
		<tr class="${row.menu_id}__sub" uid="${row.upp_menu_id }">
			<td>
				<c:set var="m_id"><img id="${row.menu_id}_f" src="fd_c.png"></c:set>
				<div class="sub_menu" style="${row.menu_count > 0 ? 'cursor:pointer;' : ''  } margin-left:${req.dep*10}px;" menu_id="${row.menu_id}" onclick="loadMenu(this, ${req.dep+1})"><span id="${row.menu_id}_tree">${row.menu_count > 0 ? m_id : '+'  }--</span> <span  class="menu_name" style="cursor:pointer; color: #003399;" menu_id="${row.menu_id}" onclick="editMenu(this)">${row.menu_name}</span></div>
			</td>
			<td><div  style="width:430px; overflow: hidden;">${row.page_url}</div></td>
			<td><tag:check_array  name="page_access_group_view" checked="${row.page_access_group}" view="true"/></td>
			<td align="right">${row.order_no}</td>
			<td align="center">
				<span id="btn_save" class="btn_sm" style=" cursor:pointer;" onclick="addSubMenu('${ row.menu_id }')">하위메뉴등록</span>
			</td>
		</tr>
	</table>
			
	<div id="${row.menu_id}__sub"></div>
</c:forEach>
