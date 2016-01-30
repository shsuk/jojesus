<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>


<sp:sp queryPath="notice" actionFild="action" processorList="attach,mybatis" loopId="attach" exception="true">
	{
		session.user_id:'test'
	}
</sp:sp> 
<c:choose>
	<c:when test="${req.action == 'l' }">
		{
			"rows":${JSON.rows},
			"records" : ${cnt.cnt},
			"total": ${cnt.cnt/req.rows + (cnt.cnt % req.rows == 0 ? 0 : 1)},
			"success": ${JSON.success}
		}
	</c:when>
	<c:when test="${req.action == 'i' || req.action == 'u' }">
		<c:if test="${!JSON.success}">
			alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n");
		</c:if>
		<script type="text/javascript">
			document.location.href = 'notice/list.jsp';
		</script>
	</c:when>
	<c:otherwise>
		${JSON }
	</c:otherwise>
</c:choose>
