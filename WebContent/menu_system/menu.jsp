<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<sp:sp queryPath="menu_system/menu" action="m" processorList="db" exception="true">
	{
		role_cd:'1'
	}
</sp:sp>
<c:set var="left_menu">
	<c:set var="hasAccess" value="false"/>
	<div id="_sub_menu_list" style="clear: both;width:100%;" >
		<c:forEach var="row" items="${sub_rows }">
			<c:set var="isCurPage" value="${req.current_menu==row.menu_id }"/>
			<div class="_sub${row.level==2 ? '' : '_sub'}_menu" style=" margin: 2px; border:1px solid #cccccc; background:; " upp_menu_id="${row.upp_menu_id}" menu_id="${row.menu_id}" page_url='${row.page_url}'>
				<div style=" margin: 2px; padding:5px; overflow: hidden;border:${row.sub_count>0 ? '1' : '0'}px solid #cccccc; background: ${isCurPage ? '' : '#eeeeee'};" title="${row.page_url}(${cur_page })">
					<a href="../..${row.page_url}">${row.menu_name}</a>
				</div>
				<c:if test="${row.sub_count>0}">
					<div class="sub_group _sub_menu" sub_group_id="${row.menu_id }" upp_menu_id="${row.upp_menu_id}" menu_id="${row.menu_id}" style="margin: 2px; border:0px solid red; "></div>
				</c:if>
			</div>
			
			<c:if test="${isCurPage }">
				<c:set var="hasAccess" value="true"/>
				<c:set var="main_menu_id">${row.upp_menu_id }</c:set>
			</c:if>
		</c:forEach>
	</div>
</c:set>

<div id="main_layer" style="margin: 0 auto;width: 90%; min-width:1000px; border:1px solid #cccccc;">
	<table style="width: 100%">
		<tr><td colspan="2">
			<div id="_main_menu" style="clear: both;">
				<c:forEach var="row" items="${main_rows }">
					<div style="cursor:pointer; width:150px;height:20px; overflow: hidden;float: left;text-align: center;border:1px solid #cccccc; background: ${main_menu_id==row.menu_id ? '#B5B2FF' : ''};"  onclick="defaultMenu('${row.menu_id}')">${row.menu_name}</div>
				</c:forEach>
			</div>
		</td></tr>
		<tr>
			<td style="width: 150px;" valign="top">
				<div id="left_menu" >
					${left_menu}
				</div>
			</td>
			<td valign="top" style=" padding: 5px;">
				<div id="body_contents" style=" float: left;width: 100%">
				</div>
			</td>
		</tr>
	</table>

</div>

<script type="text/javascript">

	$(function() {
		var sub_groups = $('.sub_group');
		for(var i=0; i<sub_groups.length; i++){
			var s_g = $(sub_groups[i]);
			s_g.append($('[upp_menu_id='+s_g.attr('sub_group_id')+']'));
		}
		$('._sub_menu').hide();
		$('[upp_menu_id=${main_menu_id}]').show();
		
		//$('#left_menu').append($('#_sub_menu_list'));
		$('#body_contents').append($('#main_body'));
	});
	
	function defaultMenu(upp_menu_id){
		var menus = $('[upp_menu_id='+upp_menu_id+']');
		
		if(menus.length<1){
			return;
		}
		
		document.location.href='../..' + $(menus[0]).attr('page_url');
	}
	<%//메뉴에 등록된 페이지이면서 권한이 없는 경우 접근불가%>
	${access_row.access_menu>0 && hasAccess ? '' : 'document.location.href="http://naver.com";'}
	
	function valid(formId){
		var ctls = $('[valid]',$(formId));
		
		for(var i=0; i<ctls.length ; i++){
			var ctl = $(ctls[i]);
			valids = ctl.attr('valid').split(',');
			
			for(var n=0; n<valids.length; n++){
				var opt = valids[n].split(':');
				var fnc = opt[0].trim();
				
				var isValid = eval(fnc)(ctl, opt);
				if(!isValid){
					return false;
				}
			}
		}
		//if($('#subject').val().indexOf('<')>-1){
		//	alert("'<' 문자는 사용할수 없습니다.");
		//	$('#subject').focus();
		//	return false;
		//}
		return true;
	}	
	function notempty(ctl){
		if(ctl.val().trim()=='' || ctl.val().trim()=='<br>'){
			alert($('[label='+ctl.attr('name')+']').text() + '에 값이 없습니다.');
			ctl.focus();
			return false;
		}
		return true;
	}
	function rangedate(ctl, opt){
		if($('#'+opt[1]).val() > $('#'+opt[2]).val()){
			alert($('[label='+ctl.attr('name')+']').text() + "의 시작일이 종료일보다 클 수 없습니다.");
			ctl.focus();
			return false;
		}
		return true;
	}
	function ext(ctl, opt){
		var val = ctl.val().toLowerCase();
		
		for(i=1; i<opt.length; i++){
			if(val.endsWith('.'+opt[i])){
				return true;
			}
		}
		
		alert($('[label='+ctl.attr('name')+']').text() + "에 첨부한 문서 종류는 등록 할 수 없습니다.");
		ctl.focus();
		return false;
		
	}
	function mask(){
		//Get the screen height and width
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();
		//Set height and width to mask to fill up the whole screen
		var mask = $('#mask');

		if(mask.length<1){
			$('body').append($('<div style="background: #cccccc;position: absolute;top: 0px;left: 0px;z-index: 9999; text-align: center;padding-top: 200px;" id="mask"><span style="background: #ffffff;color:#0000ff;border:1px solid #ffffff;">처리중...</span></div>'));
			mask = $('#mask');
		}
		mask.css({'width':maskWidth,'height':maskHeight});
		
		//$('#mask').fadeIn(100);	//여기가 중요해요!!!1초동안 검은 화면이나오고
		$('#mask').fadeTo("slow",0.3);   //80%의 불투명도로 유지한다 입니다. ㅋ

	}
	function mask_off(){
		
		setInterval(function () {
			$('#mask').hide();
		}, 1000);		
	}
</script>
