<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="groupId" type="java.lang.String" required="true"%>
<%@ attribute name="checked" type="java.lang.String" %>
<%@ attribute name="title" type="java.lang.String" %>
<%@ attribute name="valid" type="java.lang.String" %>
<%@ attribute name="attr" type="java.lang.String" %>
<c:if test="${!empty(valid)}">
	<c:set var="valid">valid="${valid }"</c:set>
</c:if>
<c:set var="checked" value=",${fn:replace(checked, ' ', '')}," />
<c:forEach var="row" items="${code:list(groupId)}"> 
	<c:set var="sel_val" value=",${row.code_value}," />
	<div style="float: left;"><input type="checkbox"  style="float: left;" id="${name}_${row.code_value }" name="${name}" ${att } value="${row.code_value }"  ${valid }  ${fn:contains(checked, sel_val) ? 'checked' : ''} >
		<label  style="float: left; line-height: 20px;" for="${name}_${row.code_value }">${row.code_name}&nbsp;&nbsp;</label>
	</div>
</c:forEach>
