<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="checked" type="java.lang.String" %>
<%@ attribute name="title" type="java.lang.String" %>
<%@ attribute name="className" type="java.lang.String"%>
<%@ attribute name="attr" type="java.lang.String" %>
<%@ attribute name="view" type="java.lang.Boolean" required="true" %>
<c:set var="codes" value="1=직원,2=대리점,3=고객" />
<c:set var="codeList" value="${fn:split(codes, ',')}" />
<c:set var="checked" value=",${fn:replace(checked, ' ', '')}," />
<div  title="${title }"  class="${className }">
<c:forEach var="row" items="${codeList}"> 
	<c:set var="code" value="${fn:split(row, '=')}" />
	<c:set var="val" value="${fn:trim(code[0])}" />
	<c:set var="sel_val" value=",${val}," />
	<c:if test="${!view }">
		<input name="${name}" id="${name}_${val }"  type="checkbox" value="${val }" ${att } ${fn:contains(checked, sel_val) ? 'checked' : ''}  title="${title }" style="float: left;"  ${attr } ><label style="float: left;line-height: 20px;" for="${name}_${val }">${fn:trim(code[1])}&nbsp;&nbsp;</label>
	</c:if>
	<c:if test="${view && fn:contains(checked, sel_val) }">
		${fn:trim(code[1])}&nbsp;&nbsp;
	</c:if>
</c:forEach>
</div>