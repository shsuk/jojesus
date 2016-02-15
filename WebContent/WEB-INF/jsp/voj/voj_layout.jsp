<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="job" tagdir="/WEB-INF/tags/job"%>
<uf:organism noException="true">[
	<job:db id="hRow" query="voj/header" isCache="false" refreshTime="5" singleRow="true">
		defaultValues:{
			bd_cat: "${empty(req.bd_cat) ? (empty(param.bd_cat) ? 'well' : param.bd_cat) : req.bd_cat}"
		}
	</job:db>
]</uf:organism>
<c:set scope="session" var="HEADER">
	${empty(hRow.HEADER) ? header_edit : hRow.HEADER }
</c:set>

<c:set scope="request" var="tpl_class_title" value="ui-widget ui-widget-content contents-contain ui-state-default title" />
<c:set scope="request" var="tpl_class_search" value="" />
<c:set scope="request" var="tpl_class_table" value="ui-widget ui-widget-content contents-contain" />
<c:set scope="request" var="tpl_class_table_header" value="ui-state-default" />

<c:if test="${ req._layout!='n'}">
	<!doctype html>
	<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">

<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta property="og:type" content="website">
<meta property="og:title" content="예수마을교회">
<meta property="og:url" content="http://vojesus.org">
<meta property="og:description" content="예수님을 따라가는 교회">
<meta property="og:image" content="http://vojesus.org/voj/images/info/2016_02/23a46f08-329e-4bcc-8069-755e6243dc4c.png"> 
<title>예수마을교회 :: 예수님을 따라가는 교회</title>
<link href="./voj/css/contents_w.css" rel="stylesheet" type="text/css" />
<link href="./voj/css/contents.css" rel="stylesheet" type="text/css" />
<link href="./jquery/development-bundle/themes/redmond/jquery.ui.all.css" rel="stylesheet" id="css" />
<link href="./jquery/dynatree/src/skin/ui.dynatree.css" rel="stylesheet" type="text/css" />
<link href="./jquery/dynatree/doc/skin-custom/custom.css" rel="stylesheet" type="text/css" />

<script src="./jquery/js/jquery-1.9.1.min.js"></script>
<script src="./jquery/js/jquery-ui-1.10.0.custom.min.js"></script>
<script src="./jquery/js/jquery.json-2.3.js"></script>
<script src="./jquery/js/jquery.cookie.js" type="text/javascript"></script>

<script src="./at.sh?_ps=js/message" type="text/javascript"></script>
<script src="./js/formValid.js" type="text/javascript"></script>

<script src="./js/commonUtil.js"></script>
<c:if test="${!empty(param.inc) }">
	<script src="./voj/js/${param.inc }.js"></script>
</c:if>
<script type="text/javascript">
	var isMobileView = false;

	$(function($) {
		$('#body_main_contents').append($('#body_main'));
		$('.prev_item').click(function() {
			if (goPrev) {
				goPrev();
			}
		});
		$('.next_item').click(function() {
			if (goNext) {
				goNext();
			}
		});

		init_load();

	});

	var bible_bg = true;
	function rev() {
		bible_bg = $.cookie('bible_bg') == 'bible_bg_b';
		$('.bible').toggleClass('bible_bg_w', bible_bg);
		$('.bible').toggleClass('bible_bg_b', !bible_bg);
		bible_bg = !bible_bg;
		$.cookie('bible_bg', (bible_bg ? 'bible_bg_w' : 'bible_bg_b'), {
			expires : 30
		});
	}

	function init_load(option) {
		$('#body_main').hide();
		$('#body_main').show(option);

	}

	function checkFunction(a, b) {
		alert(1);
	}
	function show(layer, ur, data, noHide, callBack) {

		layer.html('');
		layer.load(ur, data, function() {
			layer.show();
			if (callBack)
				callBack();
		});
	}

	function callUrl(url, data) {
		document.location.href = url + '?' + $.param(data);
	}
</script>

</head>

<body>

	<div style="margin: 0 auto; width: 1100px; ">
		<header id="header">
			<table style="width: 100%; height: 175px;">
				<tr>
					<td valign="top" width="300"></td>
					<td valign="bottom" align="center">
						<uf:organism >[<job:db id="rset" query="voj/intro/main"  singleRow="true">
							defaultValues:{bd_key_id: 'top_log'}
						</job:db>]</uf:organism>
						<a href="/">${rset['CONTENTS'] }</a>
					</td>
					<td valign="top" width="300">
						<!-- 로그인 -->
						<div style="vertical-align: top;;float: right;">
							<c:if test="${session.user_id!='guest'}">
								<div class="btn-r" style="margin-top: 10px; margin-right: 20px;">
									<a href="at.sh?_ps=voj/usr/user_edit"><b>${session.nick_name }</b></a>님 안녕하세요. <a href="at.sh?_ps=login/logout"><img src="./voj/images/btn_gnb_logout.gif" style="vertical-align: bottom;" border="0"></a>
								</div>
							</c:if> 
							<c:if test="${session.user_id=='guest' }">
								<div class="btn-r" style="margin-top: 10px; margin-right: 20px;">
									<a href="at.sh?_ps=login/login_form"><img src="./voj/images/btn_gnb_login.gif" style="vertical-align: bottom;" border="0"></a>
								</div>
							</c:if>
						</div>
						<!-- 맥체인 -->
						<uf:organism>[<job:db id="rset" query="voj/mc/day_view" singleRow="false">
								defaultValues:{
									mc_dt:${empty(req.mc_dt) ? uf:getDate('MM-dd') : req.mc_dt }
								}
						</job:db>]</uf:organism>
						<div style="vertical-align: bottom;float: right;margin-top : 70px;">
							<a href="at.sh?_ps=voj/mc/day_view">
								<img src="./voj/images/info/bible.png" style="margin-left: 6px; height: 24px;vertical-align: top;;"/> <b style="line-height: 25px;">맥체인 성경읽기</b>
							
								<table>
									<tr>
										<c:forEach var="row" items="${rset.rows }">
											<td>
												<div style="padding: 2px;">${row.wr_subject }</div>
											</td>
										</c:forEach>
									</tr>
								</table>
							</a>
						</div>
					</td>
				</tr>
			</table>

		</header>
	</div>
	<!-- 메뉴 -->
	<div style=" min-width: 1120px; border-top:1px solid #eeeeee;background: url('./voj/images/menu/black.png') repeat-x bottom ; background-position: ">
		<jsp:include page="voj_menu.jsp" />
	</div>
	<div style="margin: 5px auto 0; width: 1120px; padding: 0 10px;" id="main_body">
		<!-- 메인 컨텐츠 영역 -->
		<div id="body_main_contents" style="clear: both; width: 1100px; overflow: hidden;"></div>

	</div>
	
	<footer class="footer" style="text-align: center; margin-top:30px;  min-width: 1120px; clear: both; ">
		<div style="font-size: 12px; text-align: center; width: 100%;">
			<div style="  border-top:1px solid #000000;; border-bottom : 1px solid #000000; margin-bottom: 10px;">
				<div style="margin: 0px auto 0; width: 1100px;  padding:10px; text-align:left; vertical-align:middle; ; ">
					<a href="http://kmc.or.kr" target="_blank" style="margin-left: 20px;color: #000000;"><img height="10" src="./voj/images/info/check.png"> 감리교본부</a> 
					<a href="http://www.methodist.or.kr" target="_blank" style="margin-left: 20px;color: #000000;"><img height="10" src="./voj/images/info/check.png"> 서울연회</a>
					<a href="at.sh?_ps=voj/main&mb=y" style="margin-left: 20px;color: #000000;"><img height="10" src="./voj/images/info/check.png"> 모바일 보기</a>
				</div>
			</div>
			<img src="./voj/images/log.png" border="0" height="24" style="vertical-align: middle;">예수마을교회 | (132-834) 서울 도봉구 시루봉로5길 38 - (방학3동496번지)  TEL : 0707-124-0000, 02-954-0254 | E-MAIL : info@vojesus.org  Copyright(c) 2016 All right reserved
		</div>
		<br>
	</footer>

	<div id="prev_layer" style="position: fixed; bottom: 50px; right: 0px;">
		<div class="next_item content_nevi" title="최신 자료" style="width: 100px; opacity: .3; filter: Alpha(Opacity = 30); display: none; cursor: pointer; text-align: center;">
			다음글<br>
			<img src="./voj/images/up-icon.png">
		</div>
		<div class="prev_item content_nevi" title="이전 자료" style="width: 100px; opacity: .3; filter: Alpha(Opacity = 30); display: none; cursor: pointer; text-align: center; margin-top: 20px;">
			<img src="./voj/images/down-icon.png"><br>이전글
		</div>
	</div>

</body>
	</html>
</c:if>