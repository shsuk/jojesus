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

	var isMobileView = false;
	

	$(function($){
	    var bef_over_menu='';
	    $("#main_body").hover(function(e){
	    	;
	    },function(e){
	    	menu_out();
		    $('.sub_menu_list').hide();
	    });
	    
	    $(".top_menu div.top_menu_item").hover(function(e){
	    	menu_out();
	    	var t = $(e.currentTarget);

        	var menu_img = $('img', t);
        	var src = menu_img.attr('value');
        	var url = 'voj/images/menu${mb }/' + src + '_1.png';
        	
        	menu_img.attr('src', url);
        	
    	   	$('.sub_menu_list').hide();

	        var submenu = t.attr('id');
    	   	$('.'+submenu).show();
	    },function(e){
	    	var t = $(e.currentTarget);
        	bef_over_menu = $('img', t);
	    });
	    
	    function menu_out(){
			if(bef_over_menu){
	           	var src = bef_over_menu.attr('value');
	        	
	        	if(bef_over_menu.attr('org')){
	        		;
	        	}else{
	            	var url = 'voj/images/menu${mb }/' + src + '.png';
	            	bef_over_menu.attr('src', url);
	        	}
			}
	    	
	    }
	    //old
	    $(".sub_menu_list div").hover(function(e){
	    	$(e.currentTarget).removeClass('m_out');
	    	$(e.currentTarget).addClass('m_over');
	    },function(e){
	    	$(e.currentTarget).addClass('m_out');
	    	$(e.currentTarget).removeClass('m_over');
	    });
		//new
	    $('.on', $('.sub_menu_list')).hide();
		
	    $(".sub_menu_list div").hover(function(e){
	    	$('.off', $(e.currentTarget)).hide();
	    	$('.on', $(e.currentTarget)).show();
	    	$(e.currentTarget).removeClass('m_out');
	    	$(e.currentTarget).addClass('m_over');
	    },function(e){
	    	$('.on', $(e.currentTarget)).hide();
	    	$('.off', $(e.currentTarget)).show();
	    	$(e.currentTarget).addClass('m_out');
	    	$(e.currentTarget).removeClass('m_over');
	    });

	    
	    $('#body_main_contents').click(function(){
	    	$('.sub_menu_list').hide();
	    });
	    $('header').click(function(){
	    	$('.sub_menu_list').hide();
	    });
	    
	    $(document).on('click', '.sub_menu_item',function(e){
			document.location.href=$(e.currentTarget).attr('value');
	    });

    	var submenu = $('div[bd_cat=${empty(req.bd_cat) ? req.id : req.bd_cat}]').parent();
    	
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
	/**
	*선택된 메뉴 처리
	*/
	function setCurrentMenu(menuid){
		//선택표시
		var menu = $('#' + menuid);
		menu.css({'color': 'rgb(158, 172, 0)', 'border-bottom' : '3px solid rgb(158, 172, 0)'});
		
		//서브메뉴가 상단에 노출되는 경우 처리
		if(${req.bd_cat == 'voj'}){
			return;
		}
		var sub2_menu_old = $('.sub2_' +menuid);
		var sub2_menu = sub2_menu_old.clone();
		sub2_menu.show();
		if(sub2_menu.length==1){
			$('#sub2_menu').append(sub2_menu).show();
		}
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
</script>
	<table style="width: 1100px; margin: 0 auto; padding:0; border: 0;  " cellpadding="0" cellspacing="0" >
		<tr id="top_menu_body">
			<td class="top_menu" style="padding:0px; ">
				<div class="d_ib">
					<a href="/"><div id="m0" class="top_menu_item" memo="메인">
						메인
					</div></a>
				</div>
				<div class="d_ib">
					<div id="m1" class="top_menu_item" onclick0${mb }="openPage('voj/intro/show&id=pst')" onclick1${mb }="openPage('voj/intro/show&id=bow')"  memo="교회소개">
						교회소개
					</div>
					<div class="sub_menu_list m1" value="m1">
						<div class="sub_menu_item sub_menu_item_line" value="at.sh?_ps=voj/intro/show&id=pst" bd_cat="pst" desc="담임목사소개">담임목사 인사말</div>
						<div class="sub_menu_item sub_menu_item_line" value="at.sh?_ps=voj/intro/show&id=serve" bd_cat="serve" desc="교역자소개">섬기는 이들</div>
						<div class="sub_menu_item sub_menu_item_line" value="at.sh?_ps=voj/intro/show&id=vision" bd_cat="vision" desc="핵심가치 및 비전">핵심가치 및 비전</div>
						<div class="sub_menu_item sub_menu_item_line" value="at.sh?_ps=voj/intro/show&id=his" bd_cat="his" desc="연역">교회발자취</div>
						<div class="sub_menu_item " value="at.sh?_ps=voj/intro/show&id=rough" bd_cat="rough" desc="오시는길">오시는길</div>
					</div>
				</div>
				<div class="d_ib">
					<div id="m2" class="top_menu_item" onclick0${mb }="openPage('voj/intro/show&id=chtm')" memo="예배">
						예배
					</div>
	
					<div class="sub_menu_list m2" value="m2">
						<div class="sub_menu_item sub_menu_item_line" value="at.sh?_ps=voj/intro/show&id=chtm" bd_cat="chtm" desc="예배안내">예배안내</div>
						<div class="sub_menu_item sub_menu_item_line" value="at.sh?_ps=voj/vod/list&bd_cat=sun" bd_cat="sun" desc="설교영상">설교영상</div> 
						<div class="sub_menu_item sub_menu_item_line" value="at.sh?_ps=voj/bd/list&&bd_cat=praise" bd_cat="praise" desc="경배와 찬양">경배와 찬양</div> 
 						<div class="sub_menu_item " value="at.sh?_ps=voj/well/well_list&bd_id=max" bd_cat="well" desc="우물가">우물가</div>
					</div>
				</div>
<!-- 				<div class="d_ib">
					<div id="m3" class="top_menu_item" onclick${mb }="openPage('voj/intro/show&id=eduw')" memo="교육">
						교육
					</div>
					<div class="sub_menu_list m3" value="m3">
						<div class="sub_menu_item " value="at.sh?_ps=voj/intro/show&id=eduw" bd_cat="eduw" desc="수요성서대학">수요성서대학</div>
					</div>
				</div>
-->			
				<div class="d_ib">
					<div id="m5" class="top_menu_item" onclick0${mb }="openPage('voj/intro/show&id=mission')" memo="사역">
						사역
					</div>
					<div class="sub_menu_list m5" value="m5">
						<div class="sub_menu_item sub_menu_item_line" value="at.sh?_ps=voj/intro/show&id=mission"  bd_cat="mission" desc="선교">선교</div>
						<div class="sub_menu_item " value="at.sh?_ps=voj/intro/show&id=village"  bd_cat="village" desc="마을">마을</div>
					</div>
				</div>
				<div class="d_ib">
				
					<c:if test="${rs.crow.cnt > 0 || rs.grow.cnt > 0  || rs.nrow.cnt > 0 }" >
						<img style="position: absolute;margin-left: 35px;" src="images/icon/new_ico.gif">
						<c:set var="title0">title="${rs.crow.b_hour < rs.grow.b_hour ? rs.crow.b_hour+1 : rs.grow.b_hour+1}시간 내에 등록된 글이 있습니다."</c:set>
					</c:if>
					<div id="m4" class="top_menu_item" onclick0${mb }="openPage('voj/bd/list&bd_cat=notice')" desc="커뮤니티">
						커뮤니티
					</div>
					<div class="sub_menu_list m4" value="m4" >
						<div class="sub_menu_item sub_menu_item_line" value="at.sh?_ps=voj/bd/list&bd_cat=notice" bd_cat="notice" desc="공지사항">
							<c:set scope="request" var="new_count">최근 등록된 글이 없습니다.</c:set>
							<c:if test="${rs.nrow.cnt > 0}" >
								<img src="images/icon/new_ico.gif">
								<c:set var="new_count" scope="request" >${rs.crow.b_hour+1}시간 내에 등록된<br>글이 있습니다.</c:set>
								<c:set var="title1">title="${rs.crow.b_hour+1}시간 내에 등록된 글이 있습니다."</c:set>
							</c:if>
							공지사항
						</div>
						<div class="sub_menu_item sub_menu_item_line" value="at.sh?_ps=voj/bd/list&bd_cat=cafe" bd_cat="cafe" desc="자유게시판">
							<c:set scope="request" var="new_count">최근 등록된 글이 없습니다.</c:set>
							<c:if test="${rs.crow.cnt > 0}" >
								<img  src="images/icon/new_ico.gif">
								<c:set var="new_count" scope="request" >${rs.crow.b_hour+1}시간 내에 등록된<br>글이 있습니다.</c:set>
								<c:set var="title1">title="${rs.crow.b_hour+1}시간 내에 등록된 글이 있습니다."</c:set>
							</c:if>
							자유게시판
						</div>
						<div class="sub_menu_item sub_menu_item_line" value="at.sh?_ps=voj/vod/list&&bd_cat=newfam" bd_cat="newfam" desc="새가족">
							새가족
						</div>
						<div class="sub_menu_item sub_menu_item_line" value="at.sh?_ps=voj/bd/list&&bd_cat=help" bd_cat="help" desc="Help">
							Help
						</div>
						<div class="sub_menu_item sub_menu_item_line" value="at.sh?_ps=voj/bd/list&&bd_cat=ghouse" bd_cat="ghouse" desc="Gest House">
							Gest House
						</div>
						<div class="sub_menu_item " value="at.sh?_ps=voj/gal/list&bd_cat=voj" bd_cat="voj" desc="갤러리">
							<c:if test="${rs.grow.cnt > 0}" >
								<img src="images/icon/new_ico.gif">
								<c:set var="title2">title="${rs.grow.b_hour+1}시간 내에 등록된 이미지나 댓글이 있습니다."</c:set>
							</c:if>
							갤러리
						</div>
 					</div>
					
					<div class="sub2_m4" style="display:none;">
						<table class="sub2_menu"  ><tr>
						
							<td class="${req.bd_cat=='notice' ? 'sub2_menu_on' : '' }">
								<div class="sub_menu_item" value="at.sh?_ps=voj/bd/list&bd_cat=notice" >
									공지사항
								</div>
							</td><td class="${req.bd_cat=='cafe' ? 'sub2_menu_on' : '' }">
								<div class="sub_menu_item " value="at.sh?_ps=voj/bd/list&bd_cat=cafe" >
									자유게시판
								</div>
							</td><td class="${req.bd_cat=='newfam' ? 'sub2_menu_on' : '' }">
								<div class="sub_menu_item " value="at.sh?_ps=voj/vod/list&&bd_cat=newfam" >
									새가족
								</div>
							</td><td class="${req.bd_cat=='help' ? 'sub2_menu_on' : '' }">
								<div class="sub_menu_item " value="at.sh?_ps=voj/bd/list&&bd_cat=help" >
									Help
								</div>
							</td><td class="${req.bd_cat=='ghouse' ? 'sub2_menu_on' : '' }">
								<div class="sub_menu_item " value="at.sh?_ps=voj/bd/list&&bd_cat=ghouse" >
									Gest House
								</div>
							</td>
						</tr></table>
					</div>
				</div>

				<c:if test="${session.myGroups['admin']}">
					<div class="d_ib">
						<div id="m8"  class="top_menu_item" style="margin-top: 3px;">
							<a href="#">관리자</a>
						</div>
		 				<div class="sub_menu_list m8" value="m8" >
							<div class="sub_menu_item m_out" value="at.sh?_ps=voj/usr/user_list">회원관리</div>
							<div style="background: #cccccc;height: 1px;margin: 3px;"></div>
							<div class="sub_menu_item m_out" value="at.sh?_ps=voj/gal/list&bd_cat=img">메인 이미지 관리</div>
							<div class="sub_menu_item m_out" value="at.sh?_ps=voj/header/list">게시판 제목 관리</div>
							<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/list">페이지 내용 관리</div>
							<div style="background: #cccccc;height: 1px;margin: 3px;"></div>
							<!-- <div class="sub_menu_item m_out" value="at.sh?_ps=voj/bd/list&bd_cat=sch">일정 관리</div> -->
							<div class="sub_menu_item m_out" value="at.sh?_ps=main">시스템 관리</div>
						</div>
					</div>
					
					<div id="admin_btn" class="d_ib link" style="margin-top: 15px; float: right;" onclick="showBtn()"><img title="관리버튼 (보기/숨김)" style="height: 24px;${viewAdminButton ? '' : 'opacity:0.5; filter:alpha(opacity=50);'}" src="../images/icon/gear-icon.png"></div>
						
				</c:if>		

			</td>
		</tr>
	</table>
	