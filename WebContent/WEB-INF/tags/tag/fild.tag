<%@ tag language="java" pageEncoding="UTF-8" body-content="scriptless"%>
<%@ tag trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags/tag" %> 
<%@ attribute name="type" type="java.lang.String" description="콘트롤 타입"%>
<%@ attribute name="name" type="java.lang.String" description="필드명"%>
<%@ attribute name="edit" type="java.lang.String" description="Edit"%>
<%@ attribute name="link" type="java.lang.String" description="Edit"%>
<%@ attribute name="index" type="java.lang.String" description="row index"%>
<%@ attribute name="valid" type="java.lang.String" description="필드 정합성 체크 정보"%>
<%@ attribute name="keyValid" type="java.lang.String" description="필드 정합성 체크 정보"%>
<%@ attribute name="src" type="java.util.Map" required="true"%>

<c:if test="${!empty(link) }">
	<c:set var="linkName">onclick="link_${name }(this)"</c:set>
	<c:set var="linkClass">link</c:set>
</c:if>
<c:if test="${!empty(valid) }"><c:set var="valid">valid="${valid }"</c:set></c:if>
<c:if test="${!empty(keyValid) }"><c:set var="keyValid">key_press="${keyValid }"</c:set></c:if>

<c:choose>
	<c:when test="${edit=='edit'}">
		<c:choose>
			<c:when test="${type=='text'}">
				<input type="text" name="${name }"  value="${'$'}{row.${name }}" style="width: 90%;" maxlength="${src.precision }" ${valid } ${keyValid } >
			</c:when>
			<c:when test="${type=='label'}">
				<span name="${name }" ${linkName } class="${linkClass }">${'$'}{row.${name }}</span>
			</c:when>
			<c:when test="${type=='date'}">
				<input type="text" name="${name }" value="${'$'}{row.${name }}" class="datepicker" style="width: 100px;" maxlength="${src.precision }" ${valid } ${keyValid } >
			</c:when>
			<c:when test="${type=='number'}">
				<input type="text" name="${name }" value="${'$'}{row.${name }}" class="spinner" style="width: 100px;" maxlength="${src.precision }" ${valid } ${keyValid } >
			</c:when>
			<c:when test="${type=='select'}">
				&lt;tag:select name="${name }" groupId="${name }" selected="${'$'}{row.${name }}" ${valid }/>
			</c:when>
			<c:when test="${type=='check'}">
				&lt;tag:check name="${name }" groupId="${name }" checked="${'$'}{row.${name }}" ${valid }/>
			</c:when>
			<c:when test="${type=='radio'}">
				&lt;tag:radio name="${name }" groupId="${name }" checked="${'$'}{row.${name }}" ${valid }/>
			</c:when>
			<c:when test="${type=='files'}">
				<tag:files name="${name }" style="width: 90%;"/>
			</c:when>
			<c:otherwise>
				<input type="${type }" name="${name }" value="${'$'}{row.${name }}" style="width: 90%;" maxlength="${src.precision }" ${valid } ${keyValid } >
			</c:otherwise>
		</c:choose>	
	</c:when>
	<c:otherwise>
		<span name="${name }" value="${'$'}{row.${name }}"  ${linkName } class="${linkClass }" row_index="${index }">
		<c:choose>
			<c:when test="${type=='select'}">${'$'}{code:name('${name }', row['${name}'],null)}</c:when>
			<c:when test="${type=='date'}">${'$'}{row['${name }@yyyy-MM-dd']}</c:when>
			<c:when test="${type=='number'}">${'$'}{row['${name }@#,##0']}</c:when>
			<c:otherwise>${'$'}{row.${name }}</c:otherwise>
		</c:choose>
		</span>
	</c:otherwise>
</c:choose>

	