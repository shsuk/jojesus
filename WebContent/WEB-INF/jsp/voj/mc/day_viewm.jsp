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
<style>
   .bible {}
   .bible div{padding:8px;border-bottom: solid 1px #f6f6f6;line-height:180%; font-size: 18px;  }
   .bible_bg_s{background: #aaaaaa;color: #222222;}

	html, body, #carousel, #carousel ul, #carousel li {
		min-height: 100%;
		height: 100%;
		padding: 0;
		margin: 0;
		position: relative;
	}

	#carousel {
		background: #444444;
		color: #cccccc;
		overflow: hidden;
		width: 100%;
		-webkit-backface-visibility: hidden;
		-webkit-transform: translate3d(0,0,0) scale3d(1,1,1);
		-webkit-transform-style: preserve-3d;
	}

	#carousel ul.animate {
		-webkit-transition: all .3s;
		-moz-transition: all .3s;
		-o-transition: all .3s;
		transition: all .3s;
	}

	#carousel ul {
		-webkit-transform: translate3d(0%,0,0) scale3d(1,1,1);
		-moz-transform: translate3d(0%,0,0) scale3d(1,1,1);
		-ms-transform: translate3d(0%,0,0) scale3d(1,1,1);
		-o-transform: translate3d(0%,0,0) scale3d(1,1,1);
		transform: translate3d(0%,0,0) scale3d(1,1,1);
		overflow: hidden;
		-webkit-backface-visibility: hidden;
		-webkit-transform-style: preserve-3d;
	}

	#carousel ul {
		-webkit-box-shadow: 0 0 20px rgba(0,0,0,.2);
		box-shadow: 0 0 20px rgba(0,0,0,.2);
		position: relative;
	}

	#carousel li {
		float: left;
		overflow: hidden;
		-webkit-transform-style: preserve-3d;
		-webkit-transform: translate3d(0,0,0);
	}

	#carousel li h2 {
		color: #fff;
		font-size: 30px;
		text-align: center;
		position: absolute;
		top: 40%;
		left: 0;
		width: 100%;
		text-shadow: -1px -1px 0 rgba(0,0,0,.2);
	}

	#carousel li.pane01 { background: #cd74e6; }
	#carousel li.pane11 { background: #42d692; }
	#carousel li.pane21 { background: #4986e7; }
	#carousel li.pane31 { background: #d06b64; }
	
	.bible_bookmark0{background: #FFF612;color:#0100FF;}
	.bible_bookmark1{background: #FFF612;color:#0100FF;}
	.bible_bookmark2{background: #FFF612;color:#0100FF;}
	.bible_bookmark3{background: #FFF612;color:#0100FF;}

	.button_bookmark{
		border: 1px solid #cccccc;
		border-radius: 3px;
		box-sizing: border-box;
		margin-right:3px;
		padding:3px;
		color: #000000;
		cursor: pointer;
		font-size: 12px;
		//line-height: 25px;
		text-align: center;
	}
</style>
</head>


<!-- jQuery is just for the demo! Hammer.js works without jQuery :-) -->
<script src="./jquery/js/jquery-1.9.1.min.js"></script>
<script src="./js/modernizr.js"></script>
<script src="./js/hammer/hammer.min.2.0.4.js" type="text/javascript" ></script>
<script src="./js/hammer/touch-emulator.js" type="text/javascript" ></script>
<script src="./jquery/js/jquery.cookie.js" type="text/javascript"></script>

<script>
	var carousel;
	var bible_header;
	var bHeight;

	$(function() {
		
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

		setTimeout(function(){
			$('#tip').hide();
		},3000);
		
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

		//모바일 위 아래 밀기시 헤더 숨김
		var scrollTop = -1;
		var isTouch = false;
		TouchEmulator();
		document.body.addEventListener('touchstart', touchStart, false);
		//document.body.addEventListener('touchmove', touchMove, false);
		document.body.addEventListener('touchend', touchEnd, false);
		carousel.showPane('${empty(req.pg) ? 0 : req.pg}', true);
		bible_header = $("#bible_header");
		bHeight = bible_header.height();
		
		function touchStart(ev) {
			isTouch = true;
			scrollTop = ev.touches[0].clientY;
		}

		function touchEnd(ev) {
			isTouch = false;
			
			if(ev.changedTouches.length < 1){
				return;
			}
			
			var h =  ev.changedTouches[0].clientY - scrollTop;
			
			var top = bible_header.position().top;
			
			if(h < -10 && top > -20){
				hide();
			}else if(h > 10 && top < -20){
				show();
			}
		
		}
		
		if(${!empty(req.section)}){
			setTimeout(function(){
				var top = $('#${req.section}').position().top;
				var bible = $('.bible');
				bible.scrollTop(top-100);
				hide();
			},500);
		}

		var mc2 = new Hammer(document.getElementById('bible_header')).on("panleft panright", function(ev) {
			callJang(ev.type=='panleft' ? 'a' : 'b');
		});
	});
	
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
				bm.html('<b>'+(i+1)+'</b>:' + bDay.replace('-','월') + '일');
			}else{
				bm.html('<b>'+(i+1)+'</b>:');
			}
		}
		show();
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
///
		new Hammer(element[0], { dragLockToAxis: true }).on("release dragleft dragright swipeleft swiperight press panup pandown", handleHammer);
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
</script>

<body>
	<table id="bible_header" style="position:fixed;left: 0px; top:0; z-index: 100;width: 100%; background-color: #ffffff"><tr>
		<td width="70">
			<a href="/"><img src="./voj/images/log.png" border="0" height="45" style="vertical-align: middle;"></a>
		</td>
		<td align="center">
			<div style="font-size: 20px;font-weight:;width: 100%;">
				<span style="color:#2fb9d1;"> 맥체인</span>&nbsp;
				<c:set var="day" value="_${mc_dt }일"/>
				<c:set var="day" value="${fn:replace(day,'_0','') }"/>
				<c:set var="day" value="${fn:replace(day,'_','') }"/>
				<c:set var="day" value="${fn:replace(day,'-0','-') }"/>
				<a href="at.sh?_ps=voj/sch/show"><span style="font-size: 16px;font-weight: bold;color:#f6a400;">${fn:replace(day,'-','월') }(<tp:week m_d="${mc_dt}"/>)</span></a>
				<br>
				<img onclick="befPane()" src="../images/icon/back-icon.png" border="0">
				<span id="bible_title" style="vertical-align:40%;"></span>
				<img onclick="nextPane()" src="../images/icon/next-icon.png" border="0">
			</div>
		</td>
		<td align="right">
			<div style="margin: 2px 2px 2px 5px;font-size: 14px;">
				<div class="font_size cc_bt" style="padding: 5px; min-width: 30px; font-weight:bold;" value="+">가+</div>
				<div class="font_size cc_bt" style="padding: 5px; margin-top:3px; min-width: 30px; " value="-">가-</div> 
			</div>
		</td>
	</tr><tr>
		<td colspan="2">
			<div id="bookmark" style=" ">
				<div style="float: left;"><img src="../images/icon/bookmark-icon.png"></div>
				<div id="bookmark0" idx="0" style="float: left;"></div>
				<div id="bookmark1" idx="1" style="float: left;"></div>
				<div id="bookmark2" idx="2" style="float: left;"></div>
				<div id="bookmark3" idx="3" style="float: left;"></div>
			</div>
		</td>
		<td align="right">
			<img src="../images/icon/help-icon.png" onclick="$('#tip').slideToggle()" style="margin-right: 10px;">
		</td>
	</tr></table>

	<div id="carousel">
		<ul>
		<c:forEach var="row" items="${rset.rows }" varStatus="status">
			<li class="bible ${row.ca_name } pane${status.index }" style="overflow:auto;">
				<br/><br/><br/>	
			
				<div id="bible_${status.index }" class="bible_title" style="display: none;"><b style="color: #980000;">${status.index+1 }.</b> ${row.wr_subject }</div>
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

	 
	<div id="tip" style="position:fixed; bottom: 0px; z-index: 100; padding:20px; background-color: #B2CCFF; display: ${!empty(req.nevi) ? 'none' : ''};" onclick="$(this).hide()">
		1) 파트별로 절을 길게 눌러 <img src="../images/icon/bookmark-icon.png">북마크를 생성해 읽은 위치를 표시 할 수 있습니다.<br>
		2) 타이틀을 좌우로 밀면 동일 파트의 다른 날짜로 이동합니다.<br>
		2) 본문을 상하좌우로 밀어 보세요.<br>
		3) 본문 좌우로 밀면 양 끝에서는 다른 날짜로 이동합니다.<br>
		4) 상하로 밀기가 잘 안될 때에는 클릭 후 잠시 멈추었다가 밀어 보세요.<br>
		5) <img src="../images/icon/help-icon.png" >클릭시 이 화면을 다시 볼 수 있습니다.
	</div>
</body>
</html>
