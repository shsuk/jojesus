<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%>
<%@ tag trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="className" type="java.lang.String"%>
<%@ attribute name="style" type="java.lang.String" %>
<%@ attribute name="valid" type="java.lang.String" %>
<%@ attribute name="attr" type="java.lang.String" %>
<script type="text/javascript">
	$(function() {
		addAttach();
	});

	function addAttach(){
		$('#attachs').append($('.attachTpl').clone().removeClass('attachTpl').show());
	}

	function delFile(file_id){
		$('#'+file_id).val(file_id);
		$('.'+file_id).hide();
	}
</script>
<c:if test="${!empty(valid)}">
	<c:set var="valid">valid="${valid }"</c:set>
</c:if>
<div>
		<div style="float: right; cursor: pointer; padding-right: 20px;" title="첨부항목 추가" onclick="addAttach()">
			<img src="menu_system/add-icon.png">
		</div>
		<!-- 이전파일 목록을 이곳에 추가하세요.
			아래 소스는 예제 입니다
		&c:forEach var="row" items="${files }">
			<div style="margin: 2px;" class="${row.file_id}">
				<div style="float: left; width: 87%;">${row.file_name }<input type="hidden" name="del_file_id" id="${row.file_id}" value=""></div>
				<div style="float: right;   padding-right: 20px; cursor: pointer;" title="첨부파일 삭제"  onclick="delFile('${row.file_id}')">
					<img src="menu_system/close-icon.png">
				</div>
			</div>
		&/c:forEach>
		 -->
	<div id="attachs" style="clear:both; width: 100%;">
	</div>

</div>

<div class="attachTpl" style="display: none; padding: 1px;">
	<input type="file" name="code_name" style="width: 90%;" class="">
	<div style="float: right; padding-right: 17px; cursor: pointer; margin: 2px;" title="첨부항목 삭제" onclick="$($(this).parent()).remove()">
		<img src="menu_system/close-icon.png">
	</div>
</div></td>
