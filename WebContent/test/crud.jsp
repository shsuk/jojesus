<%@ page contentType="text/html; charset=utf-8"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="t"  tagdir="/WEB-INF/tags/test" %> 

<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script src="../jquery/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript">
	
	$(function() {
		$('tr[img_id]').click(function(e){
			document.location.href = $(e.currentTarget).attr('link_url');
		});
		
		alert($('.bb',$('.aa')).length);
	});
</script> 
</head>
<body >

<sp:sp queryPath="test/crud" actionFild="act" processorList="db" exception="true">
	{
		act:'${empty(param.bd_id) ? "i" : "u" }',
		bd_id: '${req.bd_id }'
	}
</sp:sp> 

${row_meta_ }
<br>
${test }
<t:fieldSet data="${row }" meta="${row_meta_ }" isEdit="true" labelTag="div">
<table style="c" class="aa bb" border="0">
	<t:fild field="bd_id" isLabel="true" isEdit="false"><br>설명</t:fild>
	<t:fild field="title" isLabel="true"  label="제목" />
	<t:fild field="contents" isLabel="true" />
	<t:fild field="view_count" isLabel="true" />
	<t:fild field="reg_dt" isLabel="true" />
	<t:fild field="test" isLabel="true" />
</table>
</t:fieldSet>
<br>

</body>
</htm>