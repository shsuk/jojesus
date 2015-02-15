<%@ page contentType="text/html; charset=utf-8"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<uf:organism >
[
	<job:db id="rs" query="voj/new" />
]
</uf:organism>
<c:set var="mb" value="${mobile=='m' ? 'm' : ''}"/>
<script type="text/javascript">

var isMobile = true;
var isMobileView = false;
	

	$(function($){
		initMenu();
		var bef_over_menu='';
		$("#main_body").hover(function(e){
			;
		},function(e){
			menu_out();
			$('.sub_menu_list').hide();
		});
		
		$(".top_menu div.top_menu_item").click(function(e){
			showMenu();
/* 			
			menu_out();
			var t = $(e.currentTarget);

		 	t.css('background', "url('voj/images/menu/untitled-2.jpg') repeat-x  scroll 0 0 #F5F5F3")
			
		   	$('.sub_menu_list').hide();

			var submenu = t.attr('id');
		   	$('.'+submenu).show({
				effect: "fade",
				duration: 300
			});
 */		   	
		});
		
		function menu_out(){
			if(bef_over_menu){
				bef_over_menu.css('background', "url('voj/images/menu/untitled-1.jpg') repeat-x  scroll 0 0 #F5F5F3")
			}
			
		}
		
		$(".sub_menu_list div").hover(function(e){
			$(e.currentTarget).addClass('m_over');
		},function(e){
			$(e.currentTarget).removeClass('m_over');
		});
		
		$('#body_main_contents').click(function(){
			$('.sub_menu_list').hide();
		});
		$('header').click(function(){
			$('.sub_menu_list').hide();
		});
		
		$('.sub_menu_item').click(function(e){
			document.location.href=$(e.currentTarget).attr('value');
		});

		var submenu = $('div[bd_cat=${req.bd_cat}]').parent();
		
		setCurrentMenu(submenu.attr('value'));
		
		var font_size = $.cookie('F_S');
		if(font_size){
			$('.bible').css('font-size', font_size+'px');
		}
		
		$('.font_size').click(function(tar){
			var font_size = $.cookie('F_S');
			var step = -2;
			
			if($(tar.currentTarget).attr('value')=='+'){				
				step = 2;	
			}
			
			if(font_size){
				font_size = Number(font_size) + step;
			}else{
				font_size = 14;					
			}
			
			if(font_size > 20){
				font_size = 20;
			}else if(font_size < 14){
				font_size = 14;
			}

			$.cookie('F_S', font_size,{expires:30});
			$('.bible').css('font-size', font_size+'px');
		});

	});
	
	function setCurrentMenu(menuid){	
	 	$('#'+menuid).css('background', "url('voj/images/menu/untitled-2.jpg') repeat-x  scroll 0 0 #F5F5F3");
	 	$('#'+menuid).css('border-bottom', "2px solid #ff0000");
	}
	function goVillage(vil_id){
		
		document.location.href='at.sh?_ps=voj/bd/list&bd_cat=vil&bd_key=' + vil_id;
	}
	function openPage(param){
		
		document.location.href='at.sh?_ps=' + param;
	}
	function showBtn(){
		$('#admin_btn').load('at.sh?_ps=voj/admin_view',function(){
			document.location.reload();
		});
		
	}

	//메뉴 초기화
	function initMenu(){
		var menu = $('.menu');

		if(menu.length<1){
			return;
		}
		if(menu.attr('type')!='user'){
			menu.menu({
				items: '> :not(.ui-widget-header)',
				select: function( event, ui ) {
					hideMenu();
				}
			});
		}
		
		//if(menu.length<1 || $.cookie('isMobile') != 'Y'){//모바일이 아닌 경우 
		//	return;
		//}
		
		menu.removeClass('_menu');
		menu.removeClass('menu');
		//모바일인 경우
		var body = $('body');
		body.append('<div id="menu_left_div" class=""  style="position: fixed; left: 0; top: 0; height: 100%;width: 15px;"></div>');
		body.append('<div id="menu_div" style="position: fixed;left: 0; top: 0; height: 100%; overflow: auto; background:#D9E5FF; z-index:1001;"></div>');
		body.append('<div id="menu_mask" style="position: fixed;left: 0; top: 0; width:100%; height: 100%; background:#D9E5FF; border:1px solid #cccccc; opacity: 0.6; filter: alpha(opacity=60); z-index:1000; disply:none;"></div>');
		body.append('<div id="menu-btn" class="" style="position: fixed;left: 0; bottom: 0; opacity: 0.6; filter: alpha(opacity=60); background: #D9E5FF; z-index:1002;"><img src="../images/icon/menu-icon.png"></div>');

		//메뉴버튼 생성
		$('#menu-btn').button().click(function( event ) {
			showMenu();
		});
		$('#menu_mask').click(function( event ) {
			hideMenu();
		});
		//메뉴를 바디로 옮기고 숨김
		hideMenu(1);
		
		$('#menu_div').append(menu);
		
		if(!isMobile){
			$('#menu_left_div').mouseenter(function( event ) {
				showMenu();
			});
			$('#menu_div').mouseleave(function( event ) {
				hideMenu();
			});
		}
		try {
			var mc1 = new Hammer(document.getElementById('menu_div'));

			mc1.on("panleft", function(ev) {
				hideMenu();
			});
			
			var mc2 = new Hammer(document.getElementById('menu_left_div'));

			mc2.on("panright", function(ev) {
				showMenu();
			});
		} catch (e) {
			;
		}
		
		menu.show();
	}
	function showMenu(){
		$('#menu_mask').show();
		$('#menu_div').show( 'slide', {}, 500 );
		$('#menu-btn').hide();
	}
	function hideMenu(t){
		$('#menu_div').hide( 'slide', {}, t ? t : 700 );
		$('#menu_mask').hide();
		$('#menu-btn').show();
	}
	
</script>
	<ul class="menu" style="width: 160px;display: none;">
		<a href="/"><img src="./voj/images/log.png" border="0" height="50" style="margin: 3px;"></a>
		<li class="ui-widget-header">교회안내</li>
			<li class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_bow">인사말</li>
			<li class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_church">교회소개</li>
			<li class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_pst">담임목사소개</li>
			<li class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_serve">섬기는이</li>
			<li class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_rough">오시는길</li>
			<li class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_chtm">예배시간</li>
		
		<li class="ui-widget-header">말씀과찬양</li>
			<li class="sub_menu_item m_out" value="at.sh?_ps=voj/vod/list&&bd_cat=sun" bd_cat="sun">주일예배</li> 
			<li class="sub_menu_item m_out" value="at.sh?_ps=voj/mc/day_viewm">성경읽기</li> 

		<li class="ui-widget-header">커뮤니티</li>
			<li class="sub_menu_item m_out" value="at.sh?_ps=voj/bd/list&bd_cat=cafe" bd_cat="cafe">
				<c:set scope="request" var="new_count">최근 등록된 글이 없습니다.</c:set>
				<c:if test="${rs.crow.cnt > 0}" >
					<img style="position: absolute;" src="images/icon/new_ico.gif">
					<c:set var="new_count" scope="request" >${rs.crow.b_hour+1}시간 내에 등록된<br>글이 있습니다.</c:set>
					<c:set var="title1">title="${rs.crow.b_hour+1}시간 내에 등록된 글이 있습니다."</c:set>
				</c:if>
				이야기나눔/카페
			</li>
			<li class="sub_menu_item m_out" value="at.sh?_ps=voj/gal/list&bd_cat=voj" bd_cat="voj">
				<c:if test="${rs.grow.cnt > 0}" >
					<img style="position: absolute;" src="images/icon/new_ico.gif">
				</c:if>
				갤러리
			</li>
			<li class="sub_menu_item m_out" value="at.sh?_ps=voj/well/well_list&bd_id=max" bd_cat="well">우물가소식</li>
			<li class="sub_menu_item m_out" value="at.sh?_ps=voj/sch/show" bd_cat="sch">교회일정</li>
			<li class="sub_menu_item m_out" value="at.sh?_ps=voj/vod/list&&bd_cat=newfam" bd_cat="newfam">새가족</li>
			<li class="sub_menu_item m_out" value="at.sh?_ps=voj/bd/list&bd_cat=pst" bd_cat="pst">담임목사와 함께</li>
			<c:if test="${session.myGroups['mj']}">
				<li class="ui-widget-header">예당</li>

					<li id="m10"  class="top_menu_item" style="margin-top: 3px;" onclick="openPage('voj/bd/list&bd_cat=mj')">
						<a class="cc_bt" href="#">예당</a>
					</li>
			</c:if>
			<c:if test="${session.myGroups['admin']}">
				<li class="ui-widget-header">관리자</li>
					
						<li id="admin_btn" onclick="showBtn()">관리버튼 ${viewAdminButton ? '숨김' : '보기' }</li>
						<li class="sub_menu_item m_out" value="at.sh?_ps=voj/usr/user_list">회원관리</li>
						<li class="sub_menu_item m_out" value="atm.sh?_t=list&_q=voj/header/list">게시판 제목 관리</li>
						<li class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/list">홈페이지 내용 관리</li>
						<li class="sub_menu_item m_out" value="at.sh?_ps=voj/gal/list&bd_cat=img">메인 이미지 관리</li>
						<li class="sub_menu_item m_out" value="at.sh?_ps=voj/bd/list&bd_cat=sch">일정 관리</li>
						<li class="sub_menu_item m_out" value="at.sh?_ps=main">시스템 관리</li>

				</li>
			</c:if>		
	</ul>

	<table style="width: 100%">
		<tr>
			<td class="top_menu" style="padding:0px; padding-left:10px; background: url('voj/images/menu/untitled-1.jpg') repeat-x  scroll 0 0 #F5F5F3;font: bold;color: white;">
				<div class="d_ib">
					<div id="m1" class="top_menu_item" onclick${mb }="openPage('voj/intro/show&id=bow')"  title="교회안내">
						교회안내
					</div>
					<div class="sub_menu_list m1" value="m1">
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_bow">인사말</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_church">교회소개</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_pst">담임목사소개</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_serve">섬기는이</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_rough">오시는길</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_chtm">예배시간</div>
					</div>
				</div>
				<div class="d_ib">
					<div id="m2" class="top_menu_item" onclick${mb }="openPage('voj/vod/list&&bd_cat=sun')" title="말씀과찬양">
						말씀과찬양
					</div>
	
					<div class="sub_menu_list m2" value="m2">
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/vod/list&&bd_cat=sun" bd_cat="sun">주일예배</div> 
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/mc/day_viewm">성경읽기</div> 
					</div>
				</div>
				<div class="d_ib" style="position: relative; ">
					<c:if test="${rs.crow.cnt > 0 || rs.grow.cnt > 0 }" >
						<img style="position: absolute;" src="images/icon/new_ico.gif">
					</c:if>
					<div id="m4" class="top_menu_item" onclick${mb }="openPage('voj/bd/list&bd_cat=cafe')" title="커뮤니티">
						커뮤니티
					</div>
					<div class="sub_menu_list m4" value="m4" >
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/bd/list&bd_cat=cafe" bd_cat="cafe">
							<c:set scope="request" var="new_count">최근 등록된 글이 없습니다.</c:set>
							<c:if test="${rs.crow.cnt > 0}" >
								<img style="position: absolute;" src="images/icon/new_ico.gif">
								<c:set var="new_count" scope="request" >${rs.crow.b_hour+1}시간 내에 등록된<br>글이 있습니다.</c:set>
								<c:set var="title1">title="${rs.crow.b_hour+1}시간 내에 등록된 글이 있습니다."</c:set>
							</c:if>
							이야기나눔/카페
						</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/gal/list&bd_cat=voj" bd_cat="voj">
							<c:if test="${rs.grow.cnt > 0}" >
								<img style="position: absolute;" src="images/icon/new_ico.gif">
							</c:if>
							갤러리
						</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/well/well_list&bd_id=max" bd_cat="well">우물가소식</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/sch/show" bd_cat="sch">교회일정</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/vod/list&&bd_cat=newfam" bd_cat="newfam">새가족</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/bd/list&bd_cat=pst" bd_cat="pst">담임목사와 함께</div>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<div id="body_main_contents" >
				</div>
			</td>
		</tr>		
	</table>
	