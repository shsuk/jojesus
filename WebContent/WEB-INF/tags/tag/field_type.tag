<%@ tag language="java" pageEncoding="UTF-8" body-content="scriptless"%>
<%@ tag trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="src" type="java.util.Map" required="true"%>
<c:choose>
	<c:when test="${!empty(code:list(src.name))}">select</c:when>
	<c:when test="${src.type=='datetime' || src.type=='date'}">date</c:when>
	<c:when test="${src.type=='decimal' || src.type=='int'}">number</c:when>
	<c:when test="${src.type=='datetime'}">date</c:when>
	<c:otherwise>text</c:otherwise>
</c:choose>