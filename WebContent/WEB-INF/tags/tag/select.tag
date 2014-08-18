<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%>
<%@ tag trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="groupId" type="java.lang.String" required="true"%>
<%@ attribute name="selected" type="java.lang.String" %>
<%@ attribute name="emptyText" type="java.lang.String"%>
<%@ attribute name="className" type="java.lang.String"%>
<%@ attribute name="style" type="java.lang.String" %>
<%@ attribute name="valid" type="java.lang.String" %>
<%@ attribute name="attr" type="java.lang.String" %>
<c:if test="${!empty(valid)}">
	<c:set var="valid">valid="${valid }"</c:set>
</c:if>
<select id="${name }" name="${name }" ${valid } style="${style }"  ${attr } class="${className }" >
<c:if test="${!empty(emptyText)}"><option value="">${emptyText}</option></c:if>
<c:forEach var="row" items="${code:list(groupId)}"> 
	<option value="${row.code_value }" ${selected == row.code_value ? 'selected' : ''}>${code:name(groupId, row.code_value, lang)}</option>
</c:forEach>
</select>