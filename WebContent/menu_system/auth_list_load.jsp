<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags" %> 

<sp:sp queryPath="menu_system/menu" action="al" processorList="db" exception="true"/>

<c:forEach var="row" items="${rows }">
	<table>
		<tr id="${row.menu_id }" upp_menu_id="${row.upp_menu_id }" class="${row.upp_menu_id } sub_menu menu_load jqgfirstrow ovr_sub_menu" dep="${req.dep+1}">
			<td align="left"><input type="checkbox" class="menu_ckeck" menu_id="${row.menu_id }" upp_menu_id="${row.upp_menu_id }" ${row.acc_page=='Y' ? 'checked=true' : '' }></td>
			<td>
				<c:set var="m_id"><img style="vertical-align:bottom;" id="${row.menu_id}_f" src="${row.menu_count > 0 ? 'folder.png' : 'menu.png' }"></c:set>
				<div style="vertical-align: middle; margin-left:${req.dep*25-25}px;" >
					<span id="${row.menu_id}_tree">${m_id} </span> 
					<span  class="menu_name" style="" menu_id="${row.menu_id}" >${row.menu_name}</span>
				</div>
			</td>
			<td><div  style="width:430px; overflow: hidden;">${row.page_url}</div></td>
			<td align="center"><input type="checkbox" name="acc_read"  ${row.acc_page=='Y' ? '' : 'disabled="disabled"'} class="btn_acc" menu_id="${row.menu_id }" ${row.acc_read=='Y' ? 'checked=true' : ''}></td>
			<td align="center"><input type="checkbox" name="acc_save"  ${row.acc_page=='Y' ? '' : 'disabled="disabled"'} class="btn_acc" menu_id="${row.menu_id }" ${row.acc_save=='Y' ? 'checked=true' : '' }></td>
			<td align="center"><input type="checkbox" name="acc_excel" ${row.acc_page=='Y' ? '' : 'disabled="disabled"'} class="btn_acc" menu_id="${row.menu_id }" ${row.acc_excel=='Y' ? 'checked=true' : ''}></td>
		</tr>
	</table>	
	<div id="${row.menu_id}__sub" class="menu_load"></div>
</c:forEach>
