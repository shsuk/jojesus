<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<sp:sp queryPath="menu_system/menu" action="m" processorList="db" exception="true">
	{
		user_group:'1'
	}
</sp:sp>
<script type="text/javascript">
	
	$(function() {
		
		$('#top_menu').append($('#main_menu'));

	});
</script>
<div id="top_menu" style="clear: both;"></div> 
<br>
<c:set var="hasAccess" value="false"/>
<div id="sub_menu" style="clear: both;width:150px;" >
	<c:forEach var="row" items="${sub_rows }">
		<a href="${row.page_url}"><div style="width:200px; overflow: hidden;border:1px solid #cccccc; background: ${param.menu_id==row.menu_id ? '#eeeeee' : ''};" menu_id="${row.menu_id}" page_url="${row.page_url}" onclick="">${row.menu_name}</div></a>
		<c:if test="${param.menu_id==row.menu_id }">
			<c:set var="hasAccess" value="true"/>
			<c:set var="main_menu_id">${row.upp_menu_id }</c:set>
		</c:if>
	</c:forEach>
</div>

<div id="main_menu" style="clear: both;">
	<c:forEach var="row" items="${main_rows }">
		<a href="menu.jsp?menu_id=${row.menu_id}"><div style="width:150px;height:20px; overflow: hidden;float: left;text-align: center;border:1px solid #cccccc; background: ${main_menu_id==row.menu_id ? '#B5B2FF' : ''};" menu_id="${row.menu_id}" page_url="${row.page_url}" onclick="">${row.menu_name}</div></a>
	</c:forEach>
</div>
[${access_row.access_menu }<%=request.getRequestURI() %>]
<script type="text/javascript">
	${hasAccess || access_row.access_menu>0 ? '' : '//document.location.href="http://naver.com";'}
</script>
