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
	<job:db id="rset" query="voj/mc/day_view" singleRow="false" >
		defaultValues:{
			mc_dt:${empty(req.mc_dt) ? uf:getDate('MM-dd') : req.mc_dt }
		}
	</job:db>]
</uf:organism>
<c:set var="mc_dt" value="${rset.rows[0].mc_dt }"/>
<!DOCTYPE html>
<html>
<head>
<title>예수마을교회 :: 신실한 성도. 거룩한 교회. 행복한 공동체.</title>
<meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, maximum-scale=1">
<link href="./voj/css/mc.css" rel="stylesheet" type="text/css" />

<!-- jQuery is just for the demo! Hammer.js works without jQuery :-) -->
<script src="./jquery/js/jquery-1.9.1.min.js"></script>
<script src="./js/modernizr.js"></script>
<script src="./js/hammer/hammer.min.2.0.4.js" type="text/javascript" ></script>
<script src="./jquery/js/jquery.cookie.js" type="text/javascript"></script>

<script>
	var carousel;

	$(function() {
		initMenu();
		
		$('div', $('#carousel')).css({"background-color":''});
		
		carousel = new Carousel("#carousel", function(){
			setTitle(carousel.getIndex());
		});
		carousel.init();
		
		setTitle(0);
		
		function setTitle(idx){
			var html = $('.bible_title', $('.pane' + idx)).html();
			$('#bible_title').html(html);
			
		}
		
		var section = $('div',$('.bible'));
		section.click(function(e){
			if($(e.currentTarget).find('div').length){
				return;
			}
			$(e.currentTarget).toggleClass('bible_bg_s');
		});
		//절표시
		for(var i=0; i<section.length; i++){
			$(section[i]).attr('id', 'section'+i);
		}
		//북마크 표시
		bookMark();
		$('#bookmark').find('div').click(function(e){
			var el = $(e.target);
			if(el.attr('date')){
				var section =$.cookie('bible_bookmark_'+el.attr('idx'));
				document.location.href = 'at.sh?_ps=${req._ps }&mc_dt='+el.attr('date')+'&pg='+el.attr('idx')+'&section='+section;
			}
		});
		
		$('span', $('#carousel')).css({"background": '', "font-size": '', "mso-fareast-font-family":''});


		var font_size = $.cookie('F_S');
		if(font_size){
			$('.bible div').css('font-size', font_size+'px');
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
			
			if(font_size > 24){
				font_size = 24;
			}else if(font_size < 14){
				font_size = 14;
			}

			$.cookie('F_S', font_size,{expires:30});
			$('.bible div').css('font-size', font_size+'px');
			
		});
		
		//bible_header = $("#bible_header");
		//bHeight = bible_header.height();
		//장이동
		carousel.showPane('${empty(req.pg) ? 0 : req.pg}', true);
		//북마크 절이동
		if('${!empty(req.section)}'=='true'){
			setTimeout(function(){
				var top = $('#${req.section}').position().top;
				var bible = $('.bible');
				bible.scrollTop(top-100);
				//hide();
			},500);
		}
		//헤더 좌우 터치
		//var mc2 = new Hammer(document.getElementById('bible_header')).on("panleft panright", function(ev) {
		//	callJang(ev.type=='panleft' ? 'a' : 'b');
		//});
	});
/* 	
	function show(){

		if(!bible_header){
			return;
		}
		var top = bible_header.position().top;

		if(top < -20){
			bible_header.animate({ "top": "+="+bHeight+"px" }, "slow" );
		}

	}
	function hide(){

		if(!bible_header){
			return;
		}
		var top = bible_header.position().top;

		if(top > -20){
			bible_header.animate({ "top": "-="+bHeight+"px" }, "slow" );
		}
 
	}
 */	
	function bookMark(){
		//북마크 표시
		for(var i=0; i<4;++i){
			var bm = $('#bookmark'+i);
			var bDay =$.cookie('bible_bookmark_day_'+i);
			
			$('.bible_bookmark'+i).removeClass();

			var selector = '#'+$.cookie('bible_bookmark_'+i);
			//if(bDay=='${mc_dt}'){
			if(bDay){
				bm.addClass('button_bookmark');
				$(selector).addClass('bible_bookmark'+i);
			}else{
				bm.removeClass('button_bookmark');
				$(selector).removeClass('bible_bookmark'+i);
			}
			bm.attr('date',bDay);
			if(bDay){
				bm.html(bDay.replace('-','월') + '일');
			}else{
				bm.html('');
			}
		}
		//show();
	}
	
	/**
	* super simple carousel
	* animation between panes happens with css transitions
	*/
	function Carousel(element, callback)
	{
		var self = this;
		element = $(element);

		var container = $(">ul", element);
		var panes = $(">ul>li", element);

		var pane_width = 0;
		var pane_count = panes.length;

		var current_pane = 0;


		/**
		 * initial
		 */
		this.init = function() {
			setPaneDimensions();

			$(window).on("load resize orientationchange", function() {
				setPaneDimensions();
			});
		};

		this.getIndex = function(){
			return current_pane;
		};
		/**
		 * set the pane dimensions and scale the container
		 */
		function setPaneDimensions() {
			pane_width = element.width();
			panes.each(function() {
				$(this).width(pane_width);
			});
			container.width(pane_width*pane_count);
		};


		/**
		 * show pane by index
		 */
		this.showPane = function(index, animate) {
			// between the bounds
			if(index > pane_count-1){
				callJang2('a');
				return;
			}
			if(index < 0){
				callJang2('b');
				return;
			}
			index = Math.max(0, Math.min(index, pane_count-1));
			current_pane = index;

			var offset = -((100/pane_count)*current_pane);
			setContainerOffset(offset, animate);
			
			if(callback){
				callback();
			}
		};


		function setContainerOffset(percent, animate) {
			container.removeClass("animate");

			if(animate) {
				container.addClass("animate");
			}

			if(Modernizr.csstransforms3d) {
				container.css("transform", "translate3d("+ percent +"%,0,0) scale3d(1,1,1)");
			}
			else if(Modernizr.csstransforms) {
				container.css("transform", "translate("+ percent +"%,0)");
			}
			else {
				var px = ((pane_width*pane_count) / 100) * percent;
				container.css("left", px+"px");
			}
		}

		this.next = function() { 
			this.showPane(current_pane+1, true); 
			//setTimeout(function(){self.showPane(current_pane, true);}, 50);
		};
		this.prev = function() { 
			this.showPane(current_pane-1, true); 
			//setTimeout(function(){self.showPane(current_pane, true);}, 50);
		};


		function handleHammer(ev) {
			// disable browser scrolling
			//ev.gesture.preventDefault();

			switch(ev.type) {
				case 'dragright':
				case 'dragleft':
					// stick to the finger
					var pane_offset = -(100/pane_count)*current_pane;
					var drag_offset = ((100/pane_width)*ev.gesture.deltaX) / pane_count;

					// slow down at the first and last pane
					if((current_pane == 0 && ev.gesture.direction == "right") ||
						(current_pane == pane_count-1 && ev.gesture.direction == "left")) {
						drag_offset *= .4;
					}

					setContainerOffset(drag_offset + pane_offset);
					break;

				case 'swipeleft':
					self.next();
					//ev.gesture.stopDetect();
					break;

				case 'swiperight':
					self.prev();
					//ev.gesture.stopDetect();
					break;
				case 'release':
					// more then 50% moved, navigate
					if(Math.abs(ev.gesture.deltaX) > pane_width/2) {
						if(ev.gesture.direction == 'right') {
							self.prev();
						} else {
							self.next();
						}
					}
					else {
						self.showPane(current_pane, true);
						if(Math.abs(ev.gesture.deltaX)<5 && Math.abs(ev.gesture.deltaY)<5){
							$(ev.gesture.target).toggleClass('bible_bg_s');
						}
					}
					break;
				case 'press':
					var section = $(ev.target).closest('div');
					var val = section.attr('id');
					var dt = $.cookie('bible_bookmark_day_'+current_pane);
					var sel = $.cookie('bible_bookmark_'+current_pane);
					
					if(dt=='${mc_dt}' && sel==val){
						$.cookie('bible_bookmark_day_'+current_pane, '', {expires:365});
						$.cookie('bible_bookmark_'+current_pane, '', {expires:365});
					}else{
						$.cookie('bible_bookmark_day_'+current_pane, '${mc_dt}', {expires:365});
						$.cookie('bible_bookmark_'+current_pane, val, {expires:365});
					}

					bookMark();
					break;
			}
		}

		new Hammer(element[0], { dragLockToAxis: true }).on("release dragleft dragright panend swipeleft swiperight press", handleHammer);
	}
	
	function callJang(nevi){
		var idx = carousel.getIndex();
		
		document.location.href = 'at.sh?_ps=${req._ps }&mc_dt=${mc_dt}&nevi='+nevi+'&pg='+idx;
	}
	function callJang2(nevi){
		$('#changeDate').show();
		setTimeout(function(){
			document.location.href = 'at.sh?_ps=${req._ps }&mc_dt=${mc_dt}&nevi='+nevi;
		},1000);
	}
	function nextPane(){
		carousel.showPane(carousel.getIndex()+1, true);
	}
	function befPane(){
		carousel.showPane(carousel.getIndex()-1, true);
	}
	
	//===========================================================
	//메뉴 초기화
	function initMenu(){
		var menu = $('.menu');

		if(menu.length<1){
			return;
		}
		
		menu.removeClass('_menu');
		menu.removeClass('menu');
		//모바일인 경우
		var body = $('body');
		body.append('<div id="menu_left_div" class=""  style="position: fixed; left: 0; top: 0; height: 100%;width: 15px;"></div>');
		body.append('<div id="menu_div" style="position: fixed;left: 0; top: 0; width: 210px;height:100%; overflow: auto; background:#D9E5FF; z-index:1001;"></div>');
		body.append('<div id="menu_mask" style="position: fixed;left: 0; top: 0; width:100%; height: 100%; background:#D9E5FF; border:1px solid #cccccc; opacity: 0.6; filter: alpha(opacity=60); z-index:1000; disply:none;"></div>');
		body.append('<div id="menu-btn" class="button_bookmark" style="position: fixed;left: 0; bottom: 0; margin:0px; padding:10px 15px 5px 15px; opacity: 0.4; filter: alpha(opacity=40); background: #D9E5FF; z-index:1002;"><img src="../images/icon/menu-icon.png"></div>');

		//메뉴버튼 생성
		$('#menu-btn').click(function( event ) {
			showMenu();
		});
		$('#menu_mask').click(function( event ) {
			hideMenu();
		});
		//메뉴를 바디로 옮기고 숨김
		hideMenu(1);
		
		$('#menu_div').append(menu);

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
	var isShow = true;
	function showMenu(){
		if(isShow){
			return;
		}
		isShow = true;
		
		$('#menu_mask').show();
		$('#menu_div').animate({left: "+=210"}, 1000 );;
		$('#menu-btn').hide();
	}
	function hideMenu(t){
		if(!isShow){
			return;
		}
		isShow = false;

		$('#menu_div').animate({left: "-=210"}, 1000 );;
		//$('#menu_div').hide();
		$('#menu_mask').hide();
		$('#menu-btn').show();
	}
		
</script>
</head>
<body>
	<div  class="menu" style="display: none;">
		<table style=" width:100%; background: #ffffff;"><tr>
				<td>
					<div style="float:left;"><a href="/"><img src="./voj/images/log.png" border="0" height="45" style="vertical-align: middle;"></a></div>
					<div style="color:#2fb9d1;float:left; margin-top: 15px;font-size: 22px;">&nbsp;&nbsp;맥체인</div>
				</td>
			</tr><tr>
				<td align="center">
					<div style="font-size: 20px;font-weight:;width: 100%;">
						<c:set var="day" value="_${mc_dt }일"/>
						<c:set var="day" value="${fn:replace(day,'_0','') }"/>
						<c:set var="day" value="${fn:replace(day,'_','') }"/>
						<c:set var="day" value="${fn:replace(day,'-0','-') }"/>
						<table style="width: 100%;">
							<tr>
								<td style="width:30px;">
									<img class="cc_bt button" style=" margin-right: 5px;" onclick="callJang('b')" src="../images/icon/back1-icon.png" border="0">
								</td>
								<td align="center">
									<a href="at.sh?_ps=voj/sch/show"><span style="font-size: 16px;font-weight: bold;color:#f6a400;">${fn:replace(day,'-','월') }(<tp:week m_d="${mc_dt}"/>)</span></a>
								</td>
								<td style="width:30px; text-align: right;">
									<img class="cc_bt button" style=" margin-right: 5px;" onclick="callJang('a')" src="../images/icon/next1-icon.png" border="0">
								</td>
							</tr>
							<tr>
								<td style="width:30px;">
									<img class="cc_bt button" style=" margin-right: 5px;" onclick="befPane()" src="../images/icon/back1-icon.png" border="0">
								</td>
								<td align="center"  id="bible_title" style="font-size: 16px;line-height: 17px;">
								</td>
								<td style="width:30px; text-align: right;">
									<img class="cc_bt button" style=" margin-right: 5px;" onclick="nextPane()" src="../images/icon/next1-icon.png" border="0">
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr><tr>
				<td >
					<span id="bookmark">
						<div style=""><img src="../images/icon/bookmark-icon.png"> 북마크</div>
						<div style="padding:3px 3px 3px 30px;">
							<div style="clear:both;float: left; height: 20px; padding-top: 8px;">1&nbsp;</div><div id="bookmark0" idx="0" style="float: left;"></div>
							<div style="clear:both;float: left; height: 20px; padding-top: 8px;">2&nbsp;</div><div id="bookmark1" idx="1" style="float: left;"></div>
							<div style="clear:both;float: left; height: 20px; padding-top: 8px;">3&nbsp;</div><div id="bookmark2" idx="2" style="float: left;"></div>
							<div style="clear:both;float: left; height: 20px; padding-top: 8px;">4&nbsp;</div><div id="bookmark3" idx="3" style="float: left;"></div>
						</div>
					</span>
				</td>
			</tr><tr>
				<td>
					<img src="../images/icon/help-icon.png" onclick="$('#tip').slideToggle()" style=" float:left; margin-top: 5px;">
					<div  class="button" class="label" style="margin-left:15px; padding: 5px;float:left;  width: 80px; font-size: 12px;" onclick="$('#tip').slideToggle();hideMenu();" >도움말</div>
				</td>
			</tr><tr>
				<td style="height: 3px;"></td>
			</tr><tr>
				<td>
					<div class="font_size cc_bt button" style="padding: 5px;float:left; margin-right:5px; min-width: 30px; font-weight:bold;" value="+">가+</div>
					<div class="font_size cc_bt button" style="padding: 5px;float:left; min-width: 30px; " value="-">가-</div> 
					<div class="label" style="padding: 5px;float:left; margin-top: 5px; " >(글자크기 조정)</div>
				</td>
		</tr></table>
	
	
	</div>

	<div id="carousel">
		<ul>
		<c:forEach var="row" items="${rset.rows }" varStatus="status">
			<li class="bible ${row.ca_name } pane${status.index }" style="overflow:auto;">
			
				<div id="bible_${status.index }" class="bible_title" style="display: none;"><b style="color: #980000;">${status.index+1 }.</b> ${row.wr_subject }</div>
				
				<table style="width: 100%;"><tr>
					<td align="center" style=" font-size: 20px;text-align: center;">
						맥체인 - ${fn:replace(day,'-','월') }(<tp:week m_d="${mc_dt}"/>)
					</td>
				</tr><tr>
					<td>
						<span style="color: yellow;"><b style="">${status.index+1 }.</b> ${row.wr_subject }</span>
					</td>
				</tr></table>
				
				${row.WR_CONTENT }
				<c:if test="${session.myGroups['intro'] && viewAdminButton}">
					<a href="at.sh?_ps=voj/mc/edit&wr_id=${row.wr_id }" target="new" class="action_blue btn-r" style="background: #ffffff;">수정</a>
				</c:if>
			</li>
		</c:forEach>
		</ul>
	</div>
	<div id="changeDate" style="position:fixed; top: 100px;left:50px; z-index: 100; padding:20px; display: none; background-color: #B2CCFF">
		날짜를 변경합니다.
	</div>

	 
	<div id="tip" style="position:fixed; bottom: 0px; z-index: 100; padding:20px; background-color: #B2CCFF; display:none;" onclick="$(this).hide()">
		1) 각 페이지별로 절을 길게 눌러 <img src="../images/icon/bookmark-icon.png">북마크를 생성해 읽은 위치를 표시 할 수 있습니다.<br>
		2) 본문을 좌우로 밀어 페이지를 이동할 수 있습니다.<br>
		3) 본문을 좌우로 밀때 양끝 페이지에서는 다른 날짜로 이동합니다.<br>
		4) 본문 좌측끝을 우측으로 밀거나 하단 메뉴를 눌러 메뉴를 표시하고 밀어 숨길 수 있습니다.
		
	</div>
</body>
</html>
