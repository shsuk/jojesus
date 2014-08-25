<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags" %> 

<sp:sp queryPath="menu_system/menu" action="l" processorList="db" exception="true"/>


<c:forEach var="row" items="${rows }">
	<table>
		<tr id="${row.menu_id }" class="${row.upp_menu_id } sub_menu ovr_sub_menu" dep="${row.level+1}">
			<td>
				<c:set var="m_id"><img style="vertical-align: bottom;" id="${row.menu_id}_f" src="${row.menu_count > 0 ? 'folder.png' : 'menu.png'  }"></c:set>
				<div style=" margin-left:${row.level*25-25}px;" >
					<span id="${row.menu_id}_tree">${m_id} </span> 
					<span  class="menu_name" style="cursor:pointer; color: #003399;" menu_id="${row.menu_id}" onclick="editMenu(this)">${row.menu_name}</span>
				</div>
			</td>
			<td><div  style=" overflow: hidden;">${row.page_url}</div></td>
			<td>${row.menu_id}</td>
			<td align="right">${row.order_no}</td>
			<td align="center"  style=" padding: 0px; ">
				<span id="btn_save" class="" style=" cursor:pointer;margin:0px; ${req.dep=='3' ? 'display:none;' : ''}" onclick="addSubMenu('${ row.menu_id }','${req.dep+1 }')" title="하위메뉴 추가"><img src="add-icon.png"></span>
			</td>
		</tr>
	</table>
			
	<div id="${row.menu_id}__sub"></div>
</c:forEach>
