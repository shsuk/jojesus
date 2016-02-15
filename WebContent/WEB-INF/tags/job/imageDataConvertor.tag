<%@ tag language="java" pageEncoding="UTF-8" body-content="scriptless"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="리턴받을 변수명"%>
<%@ attribute name="path" type="java.lang.String" required="true" description="저장할 경로"%>
{
	jobId: 'imageDataConvertor',
	id: '${id}',
	path: '${path}'
},