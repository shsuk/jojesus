<%@ page contentType="text/html; charset=utf-8"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 

<c:choose >
	<c:when test="${req.action=='u' }">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/mc/update"/>
		]</uf:organism>
	
		<c:set var="JSON" scope="request" value="${JSON }"/>
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
</c:choose>

<jsp:include page="../voj_layout${mobile}.jsp" />
<uf:organism >
[	<job:db id="rset" query="voj/mc/edit" />
]
</uf:organism>
<c:set var="row" value="${rset.row }"/>

<script src="./se/js/HuskyEZCreator.js" type="text/javascript"  charset="utf-8"></script>
<script type="text/javascript">
	var oEditors = [];
	
	$(function() {
		<c:if test="${!empty(req.wr_id) && empty(row)}">
			document.location.href= 'at.sh?_ps=voj/mc/day_view';

			return;
		</c:if>
		
		initEditor();
		
	    init_load();
	});
	

	//에디터 소스 시작
	function initEditor() {
		// 추가 글꼴 목록
		//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];
	
		nhn.husky.EZCreator.createInIFrame({
			oAppRef: oEditors,
			elPlaceHolder: "ir1",
			sSkinURI: "se/SmartEditor2Skin.html",	
			htParams : {
				bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
				fOnBeforeUnload : function(){
					//alert("완료!");
				}
			}, //boolean
			fOnAppLoad : function(){
				//에디터 로딩이 완료된 후에 본문에 삽입
				oEditors.getById["ir1"].exec("PASTE_HTML", [$('#_contemts').html()]);
			},
			fCreator: "createSEditor2"
		});
	}

	//에디터 소스 끝
	function form_submit(){	
		var form = $('#content_form');
		if(form.attr('isSubmit')==='true') return false;

		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
		var ir = $('#ir1');
		var val = ir.val();
		
		
		if(val=='<br>'){
			ir.val('');
		}
		
		//폼 정합성 체크
		var isSuccess = $.valedForm($('[valid]',form));
		if(!isSuccess) return false;			
		
		var formData =$(form).serializeArray();
		
		if($(form).attr('isSubmit')==='true') return false;
		$(form).attr('isSubmit',true);

		var url = 'at.sh';
		$.post(url, formData, function(response, textStatus, xhr){
			$(form).attr('isSubmit',false);

			var data = $.parseJSON(response);
			//checkFunction(data);
			if(data.success){
				document.location.href= 'at.sh?_ps=voj/mc/day_view&mc_dt=${req.mc_dt}';
			}else{
				alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.error_message);
			}
			goPage(PAGENO);
		});
		return false;
	}
	
</script>
<div  id="body_main"  class="bd_title" style="display: none;">
	
	<form id="content_form" method="post" style="clear: both;" enctype="multipart/form-data">
		<input type="hidden" name="action" value="u">
		<input type="hidden" name="_ps" value="voj/mc/edit">
		<input type="hidden" name="wr_id" value="${req.wr_id }">
		<table style="width: 100%">
			<tr >
				<th>${row.mc_dt} ${row.wr_subject }</th>
			</tr>
		</table>
		
		<textarea name="ir1" id="ir1" title="내용" rows="10" cols="100" style="width:100%; height:412px; display:none;" valid="[['notempty'],['maxlen:1900000']]"></textarea>
		
	</form>
	<p>

	<table style="width: 100%">
		<tr>
			<td width="250"></td>
			<td></td>
			<td width="250">
				<a style="float:right;" class="cc_bt" href="at.sh?_ps=voj/mc/day_view&mc_dt=${req.mc_dt}" >취 소</a>
				<a href="#" class="cc_bt" onclick="form_submit()" style="float: right;margin-right: 10px;">저 장</a>
			</td>
		</tr>
	</table>
	
	<div id="_contemts" style="display: none;">${row['WR_CONTENT@dec'] }</div>
</div>	
	