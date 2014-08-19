<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%>
<%@ tag trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="checked" type="java.lang.String" %>
<%@ attribute name="codes" type="java.lang.String" required="true" description=" =선택, id1=val1 , id2=val2 ...(공백은 앞뒤 공백은 제거됨, 길이가 0인 값을 넣고 싶으면 공백을 넣으세요.)"%>
<%@ attribute name="className" type="java.lang.String"%>
<%@ attribute name="secederRecord" type="java.lang.String" description="레코드 분리자 기본값 (,)"%>
<%@ attribute name="secederField" type="java.lang.String" description="필드 분리자 기본값 (=)"%>
<%@ attribute name="style" type="java.lang.String" %>
<%@ attribute name="valid" type="java.lang.String" %>
<%@ attribute name="attr" type="java.lang.String" %>
<c:set var="secederR" value="${empty(secederRecord) ? ',' : secederRecord}" />
<c:set var="secederF" value="${empty(secederField) ? '=' : secederField}" />
<c:set var="codeList" value="${fn:split(codes, secederR)}" />

<c:if test="${!empty(valid)}">
	<c:set var="valid">valid="${valid }"</c:set>
</c:if>

<c:set var="checked" value=",${fn:replace(checked, ' ', '')}," />

<c:forEach var="row" items="${codeList}"> 
	<c:set var="code" value="${fn:split(row, '=')}" />
	<c:set var="val" value="${fn:trim(code[0])}" />
	<c:set var="sel_val" value=",${val}," />
	<c:if test="${!view }">
		<input name="${name}" id="${name}_${val }"  type="checkbox" value="${val }" ${att } ${fn:contains(checked, sel_val) ? 'checked' : ''}  ${valid }  style="float: left;"  ${attr } ><label style="float: left;line-height: 20px;" for="${name}_${val }">${fn:trim(code[1])}&nbsp;&nbsp;</label>
	</c:if>
	<c:if test="${view && fn:contains(checked, sel_val) }">
		${fn:trim(code[1])}&nbsp;&nbsp;
	</c:if>
</c:forEach>
