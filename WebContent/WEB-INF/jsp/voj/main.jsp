<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<jsp:include page="voj_layout${mobile}.jsp" />

<uf:organism >[
	<job:db id="rset" query="voj/mc/day_view" singleRow="false" >
		defaultValues:{
			mc_dt:${empty(req.mc_dt) ? uf:getDate('MM-dd') : req.mc_dt }
		}
	</job:db>
	<job:db id="imgRows" query="voj/image"  isCache="true" refreshTime="1"  >
		defaultValues:{
			img_id: 'top_img'
		}
	</job:db>
	<job:db id="pops" query="voj/image" isCache="true" refreshTime="1"  >
		defaultValues:{
			img_id: 'pop'
		}
	</job:db>
]</uf:organism>

<link href="./js/coin-slider/coin-slider-styles.css" rel="stylesheet" type="text/css" />
<script src="./js/coin-slider/coin-slider.min.js"></script>

<script type="text/javascript">
	var isMobile = ${isMobile};
	
	$(function() {
		/* 팝업창 */
		if(!$.cookie("NO_POPUP")){
			setTimeout(function(){open_popup('popup_win');}, 500);
		}
		/* 상단배너 */
		var main_img = $('.main_img');
		var main_img_count = main_img.length;
		var main_img_current = 0;

		if(isMobile){
			showMainImage();
			
			setInterval(function () {
				showMainImage();
			}, 8000);
			
		}else{
			$('#coin-slider').coinslider({
				height: 320,
				width: 850,
				delay: 10000,
				navigation:false
			});
		}
		/* 모바일에서 상단배너처리 */
		function showMainImage(){
			main_img.hide();
			if(!isMobile) {
				$(main_img[main_img_current]).effect( 'slide', {}, 2000 );
			}
			$(main_img[main_img_current]).show();
			main_img_current = (++main_img_current) % main_img_count; 
		};
	
		/* 모바일재배치 */
		if(isMobile){
			$('.cunit').css('width','100%');
			$('.gal_item').css({'width':'105px', 'height':'105px'})
		}
	});
	
	/* 팝업창 열기*/
	function open_popup(id){
		
		$('#'+id).dialog({
			title: '공지사항',
			autoOpen: false,
			width: 'auto',
			resizable:false,
			modal: false,
			close: function( event, ui ) {
				$( "#" + id).hide();	
			}
		});

		$( "#" + id).dialog( "open" );
		$('[aria-describedby='+id+']').css('width','253px');
	}
	/* 오늘 팝업창 열지 않기 */
	function notOpenPopup(){
		var time = new Date();
		var h = time.getHours();
		
		$.cookie("NO_POPUP", "YES",{expires:1});
		$( "#popup_win").dialog( "close" );
	}
	
</script>

<div id="body_main" style="display: none;padding-top: 20px;">
	<!-- 왼쪽 -->
	<div class="cunit" style="float: left; width: 850px; ">
		<!-- 상단배너 -->
		<c:if test="${!isMobile }">
			<div id="coin-slider" >
				<c:forEach var="imgRow" items="${imgRows }">
					<tp:img className="main_img" file_id="${imgRow.file_id }" thum="850"/>
				</c:forEach>
			</div>
		</c:if>
		<c:if test="${isMobile }">
			<div class="main_cube mob_1" style="overflow: hidden;  width: 100%;">
				<c:forEach var="imgRow" items="${imgRows }">
					<tp:img className="main_img" file_id="${imgRow.file_id }" thum="850" style="width:100%; display: none;"/>
				</c:forEach>
			</div>
		</c:if>
		<!-- 주일예배, 우물가 -->
		<div class="cunit" style="float: left; width: 450px;padding-top: 20px;">
			<!-- 주일예배 -->
			<a href="at.sh?_ps=voj/vod/list&&bd_cat=sun" style="color: #ffffff; ">
				<div class="cunit" style="height: 150px;padding-left:160px; padding-top:10px; background: url('/voj/images/info/wdh.png') no-repeat 40% 40%;color: white;">
					<uf:organism >[<job:db id="row" query="voj/vod/list" singleRow="true">
							defaultValues:{bd_cat: 'sun',listCount:1,pageNo:1}
					</job:db>]</uf:organism>
						 <b>주일예배</b>
					<table>
					
						<tr><td style="width: 70px;">제목</td><td><div style=" width: 135px;overflow: hidden; text-overflow : ellipsis;"><nobr>${row.title }</nobr></div></td></tr>
						<tr><td >본문</td><td> ${row.bible }</td></tr>
						<c:set var="vod_id" value="${row.vod_id }"/>
					
					</table>
				</div>
			</a>
			<!-- 우물가 -->
			<div class="cunit" style="height: 300px; overflow: hidden;padding-top: 10px;">
				<div class="content_box" >
					<div class="content_box_title" >
						<a href="at.sh?_ps=voj/well/well_list&bd_id=max" style="color: #000000; "> <b>우물가</b></a>
					</div>
					<div class="content_box_line" style="">
						<div class="content_box_line_"  ></div>
					</div>
				</div>
				
				<uf:organism >[<job:db id="row" query="voj/well/view_week"  singleRow="true">
					defaultValues:{bd_cat: 'well'}
				</job:db>]</uf:organism>
				<a href="at.sh?_ps=voj/well/well_list&bd_id=max" style="color: #000000; ">
					<div style="padding: 5px;font-weight: bold;font-size: 15px;">${row['title'] }</div>
					<div style="padding: 5px;">${fn:replace(fn:replace(row['CONTENTS'],'<!--[if !supportEmptyParas]-->', ''), '<!--[endif]-->', '') }</div>
				</a>
			</div>
		</div>
		<!-- 새가족, 사진 -->
		<div class="cunit" style="float: left; width: 400px;padding-top: 20px;padding-left: 10px;">
			<!-- 새가족 -->
			<div >
				<div class="content_box" >
					<div class="content_box_title" >
						<a href="/bbs/board.php?bo_table=qt" style="color: #000000; "> <b>새가족</b></a>
					</div>
					<div class="content_box_line" style="">
						<div class="content_box_line_"  ></div>
					</div>
				</div>
				<uf:organism >[<job:db id="row" query="voj/vod/newfam" singleRow="true" >
					defaultValues:{}
				</job:db>]</uf:organism>
		
				<div style="background: url('/voj/images/info/newfam.jpg') no-repeat ;padding: 5px 5px;">
					<div style="width:115px; height:115px; overflow:hidden;">
						<tp:img file_id="${row.file_id}" thum="100" style="height:115px;" />
					</div>
				</div>
			</div>
			<!-- 사진 -->
			<div  style="height: 300px; margin-top: 10px;">
				<div class="content_box" >
					<div class="content_box_title" >
						<a href="/bbs/board.php?bo_table=qt" style="color: #000000; "> <b>사진</b></a>
					</div>
					<div class="content_box_line" style="">
						<div class="content_box_line_"  ></div>
					</div>
				</div>

				<uf:organism >[<job:db id="rows" query="voj/gal/list"  singleRow="false">
						defaultValues:{bd_cat: 'voj',listCount:6,pageNo:1}
				</job:db>]</uf:organism>

				<c:forEach var="row" items="${rows }">
					<div class="gal_item" style="width:125px;height:125px; margin-right:5px; margin-bottom:5px; border: 1px solid #cccccc; float:left; overflow:hidden;text-align: center;vertical-align: middle;">
						<a href="at.sh?_ps=voj/gal/list&bd_cat=voj&gal_id=${row.gal_id }">
							<tp:img file_id="${row.file_id}" thum="160" style=" border: 1px solid #cccccc; height:130px;"/>
						</a>
					</div>
				</c:forEach>
									
			</div>
		</div>
	</div>
	<!-- 오른쪽 -->
	<div class="cunit" style="float: left; width: 250px;padding-left: 10px; ">
		<!-- 알려드려요 -->
		<div style="height: 160px;">
			<div class="content_box" >
				<div class="content_box_title" >
					<a href="at.sh?_ps=voj/bd/list&bd_cat=notice" style="color: #000000; "> <b>알려드려요</b></a>
				</div>
				<div class="content_box_line" style="">
					<div class="content_box_line_"  ></div>
				</div>
			</div>
			<uf:organism >[<job:db id="rows" query="voj/bd/list" singleRow="false" >
				defaultValues:{
					bd_cat: 'notice', listCount:5, pageNo:1
				}
			</job:db>]</uf:organism>
			<c:forEach var="row" items="${rows }">
				<div style="overflow: hidden;width: 280px; height:20px;text-overflow : ellipsis;">
					<a href="at.sh?_ps=voj/bd/list&bd_cat=notice&bd_id=${row.bd_id }"><nobr>. ${row['title'] }</nobr></a>
				</div>
			</c:forEach>
		</div>
		
		
		
		
		<!-- 우물가 -->
		<div style="margin-top: 10px; height: 160px;">
			<div class="content_box" >
				<div class="content_box_title" >
					<a href="at.sh?_ps=voj/well/well_list&bd_id=max" style="color: #000000; "> <b>우물가</b></a>
				</div>
				<div class="content_box_line" style="">
					<div class="content_box_line_"  ></div>
				</div>
			</div>
			
			<uf:organism >[<job:db id="rows" query="voj/well/list" singleRow="false" >
				defaultValues:{
					listCount:5,pageNo:1
				}
			</job:db>]</uf:organism>
			<c:forEach var="row" items="${rows }">
				<div style="overflow: hidden;width: 280px; height:20px;text-overflow : ellipsis;">
					<a href="at.sh?_ps=voj/well/well_list&bd_id=${row.bd_id }"><nobr>. ${row['title'] }</nobr></a>
				</div>
			</c:forEach>
		</div>
		
		
		
		<!-- 자유게시판 -->
		<div style="margin-top: 10px;height: 160px;">
			<div class="content_box" >
				<div class="content_box_title" >
					<a href="at.sh?_ps=voj/bd/list&bd_cat=cafe" style="color: #000000; "> <b>자유게시판</b></a>
				</div>
				<div class="content_box_line" style="">
					<div class="content_box_line_"  ></div>
				</div>
			</div>
			
			<uf:organism >[<job:db id="rows" query="voj/bd/list" singleRow="false" >
				defaultValues:{
					bd_cat: 'cafe', listCount:5, pageNo:1
				}
			</job:db>]</uf:organism>
			<c:forEach var="row" items="${rows }">
				<div style="overflow: hidden;width: 280px; height:20px;text-overflow : ellipsis;">
					<a href="at.sh?_ps=voj/bd/list&bd_cat=cafe&bd_id=${row.bd_id }"><nobr>. ${row['title'] }</nobr></a>
				</div>
			</c:forEach>
		</div>
		
		<!-- 최신댓글 -->
		<div style="margin-top: 10px;height: 160px;">
			<div class="content_box" >
				<div class="content_box_title" >
					<b>최신댓글</b>
				</div>
				<div class="content_box_line" style="">
					<div class="content_box_line_"  ></div>
				</div>
			</div>
			
			<uf:organism >[<job:db id="rows" query="voj/bd/new_com" singleRow="false" >
				defaultValues:{
				}
			</job:db>]</uf:organism>
			<c:forEach var="row" items="${rows }">
				<div style="overflow: hidden;width: 280px; height:20px; line-height:30px; text-overflow : ellipsis;">
					<a href="at.sh?_ps=${row.type == 'cafe' ? 'voj/bd/list&bd_cat=cafe&bd_id=' : 'voj/gal/list&bd_cat=voj&gal_id=' }${row.bd_id }"><nobr>. ${fn:substring(row['rep_text'],0, 100) }</nobr></a>
				</div>
			</c:forEach>
		</div>
	</div>
</div>


<!-- 팝업창 -->
<c:forEach var="pop" items="${pops }">
	<div id="popup_win" style="display: none;position: relative; padding:2px;" title="${pop.title }">
		<a href="${pop.link_url }">
			<tp:img file_id="${pop.file_id }" thum="1000" style="width:${isMobile ? 300 : 249}px;"/>
		</a>
		<div style="position: absolute;; top:7px;right:10px; z-index: 1000;cursor: pointer;background: #efefef;" onclick="notOpenPopup()">오늘하루 열지않음<input type="checkbox"></div>
	</div>
</c:forEach>
