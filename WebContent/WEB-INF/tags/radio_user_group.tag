<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="userGroup" type="java.lang.String" required="true"%>
<%@ attribute name="checked" type="java.lang.String" %>
<%@ attribute name="title" type="java.lang.String" %>
<%@ attribute name="valid" type="java.lang.String" %>
<%@ attribute name="attr" type="java.lang.String" %>
<c:set var="groupList" value="${fn:split(userGroup, ',')}" />
<input name="${name}" id="${name}_"  type="radio" value="" ${att } ${empty(checked) ? 'checked' : ''} valid="${valid }"  title="${title }" style="float: left;"  ${attr } ><label style="float: left;line-height: 20px;" for="${name}_">닉네임&nbsp;&nbsp;</label>
<c:forEach var="group" items="${groupList}"> 
	<c:set var="grp_name" value="${code:name('user_group', group, lang)}"/>
	<input name="${name}" id="${name}_${group }"  type="radio" value="${grp_name}" ${att } ${checked == grp_name ? 'checked' : ''} valid="${valid }"  title="${title }" style="float: left;"  ${attr } ><label style="float: left;line-height: 20px;" for="${name}_${group}">${grp_name}&nbsp;&nbsp;</label>
</c:forEach>