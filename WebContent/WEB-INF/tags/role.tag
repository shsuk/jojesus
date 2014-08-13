<%@ tag language="java" pageEncoding="UTF-8" body-content="tagdependent"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ attribute name="type" type="java.lang.String" required="true" description="read,save,excel" %>
<%//롤 변경 후 1분후 적용됨 %>
<sp:sp queryPath="menu_system/role" action="role" processorList="role" exception="true">
	{
		role_cd:'1'
	}
</sp:sp>
<c:set var="key" value="${1}.${pageContext.request.requestURI}"/>
<c:set var="page" value="${ROLE_MAP[key]}"/>
<c:if test="${!empty(page)}">
	<c:set var="role_key" value="acc_${type}"/>
	<c:if test="${page[role_key]=='Y' }">
		<jsp:doBody/>
	</c:if>
</c:if>