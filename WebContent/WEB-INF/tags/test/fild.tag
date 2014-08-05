<%@tag import="org.apache.commons.lang.StringUtils"%><%@tag import="net.ion.webapp.db.Lang"%><%@tag import="java.util.Date"%><%@tag import="net.ion.webapp.utils.Function"%>
<%@ tag language="java" pageEncoding="UTF-8" body-content="scriptless"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="field" type="java.lang.String" description="필드"
%><%@ attribute name="label" type="java.lang.String" description="라벨에 표시될 값 기본값은 필드에 대한 등록된 다어값 없는 경우는 필드아이디값 "
%><%@ attribute name="format" type="java.lang.String" description="기본값 date:yyy-MM-dd HH:mm:ss int:#,##0"
%><%@ attribute name="isLabel" type="java.lang.Boolean" description="라벨을 출력할지 설정 기본값 : false"
%><%@ attribute name="labelTag" type="java.lang.String" description="label:true인 경우 라벨과 데이타를 출력할 tag 기본갑 <tr><th>필드명</th><td>필드값</td></tr>"
%><%@ attribute name="isEdit" type="java.lang.Boolean" description="수정가능한 여부 기본값 : false"
%><%@ attribute name="type" type="java.lang.String" description="필드의 입출력 형식을 지정한다. 기본값 db 속성사용"
%><c:set var="html" 
><c:set var="lblText"><%= StringUtils.isEmpty(label) ? Lang.getMessage(field  , "", field) : label %></c:set
><c:set var="val" value="${__DATA__[field]}"
/><c:set var="fieldType" value="${__META__[field].type}"
/><c:set var="labelTag" value="${empty(labelTag) ? __labelTag__  : labelTag }${labelTag }"
/><c:set var="isEdit" value="${empty(isEdit) ? __isEdit__  : isEdit }"/>
<c:choose>
	<c:when test="${!isEdit && ( fieldType=='INT' || fieldType=='INT UNSIGNED')}">
		<c:set var="fieldFmt" value="${field}@${empty(format) ? '#,##0' : format}"/>
		<c:set var="val" value="${__DATA__[fieldFmt]}"/>
	</c:when><c:when test="${fieldType=='DATETIME'}">
		<c:set var="fieldFmt" value="${field}@${empty(format) ? 'yyy-MM-dd HH:mm:ss' : format}"/>
		<c:set var="val" value="${__DATA__[fieldFmt]}"/>
	</c:when>
</c:choose>
<c:if test="${isEdit }">
	<c:choose>
		<c:when test="${type=='date' || empty(type) && fieldType=='DATETIME'}">
			<c:set var="val"><input type="text" value="${val}"></c:set>
		</c:when><c:otherwise>
			<c:set var="val"><input type="text" value="${val}"></c:set>
		</c:otherwise>
	</c:choose>
</c:if>
<c:choose>
	<c:when test="${isLabel }">
		<c:choose>
			<c:when test="${empty(labelTag) }">
				<tr>
					<th title="${field }">${lblText }</th>
					<td class="${field }">${val}<jsp:doBody/></td>
				</tr>
			</c:when><c:otherwise>
				<${labelTag } title="${field }">${lblText }</${labelTag }>
				<${labelTag } class="${field }">${val}</${labelTag }>
			</c:otherwise>
		</c:choose>
	</c:when><c:otherwise>
		${val}
	</c:otherwise>
</c:choose>
</c:set>${fn:trim(html) }
	