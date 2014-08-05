<%@ tag language="java" pageEncoding="UTF-8" body-content="scriptless"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="data" type="java.util.Map" required="true"
%><%@ attribute name="meta" type="java.util.Map" required="false"%><%@ attribute name="isLabel" type="java.lang.Boolean" description="라벨을 출력할지 설정 기본값 : false"
%><%@ attribute name="labelTag" type="java.lang.String" description="label:true인 경우 라벨과 데이타를 출력할 tag 기본갑 <tr><th>필드명</th><td>필드값</td></tr>"
%><%@ attribute name="isEdit" type="java.lang.Boolean" description="수정가능한 여부 기본값 : false"%>
<c:set var="__DATA__" scope="request" value="${data }"/>
<c:set var="__META__" scope="request" value="${meta }"/>
<c:set var="__labelTag__" scope="request" value="${labelTag }"/>
<c:set var="__isEdit__" scope="request" value="${isEdit }"/>
<jsp:doBody/>
<c:set var="__DATA__" scope="request" value=""/>
<c:set var="__META__" scope="request" value=""/>
