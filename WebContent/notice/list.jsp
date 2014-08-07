<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>

<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">

<head>
<link href="../jquery/development-bundle/themes/redmond/jquery.ui.all.css"  rel="stylesheet" type="text/css" media="screen" />
<link href="../jquery/jqgrid/css/ui.jqgrid.css"  rel="stylesheet" type="text/css" media="screen" />
<link href="../jquery/jqgrid/plugins/ui.multiselect.css" rel="stylesheet" type="text/css" media="screen" />

<script src="../jquery/js/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="../jquery/js/jquery-ui-1.10.0.custom.min.js" type="text/javascript"></script>
<script src="../jquery/jqgrid/js/i18n/grid.locale-en.js" type="text/javascript"></script>
<script src="../jquery/jqgrid/js/jquery.jqGrid.min.js" type="text/javascript"></script>

<script type="text/javascript">
	
	$(function() {

		jQuery("#list6").jqGrid({
		    url: '../../notice/action.jsp?action=l&'+new Date().getTime(),
		    datatype: "json",
		    colNames: [
		        '번호',
		        '제목',
		        '게시시작',
		        '게시종료',
		        '작성자',
		        '작성일',
		        '조회수'
		    ],
		    colModel: [
				{
				    name: 'notice_id',
				    index: 'notice_id',
				    width: 50,
				    align: "center"
				}, {
		            name: 'subject',
		            index: 'subject',
		            width: 350
		        }, {
		            name: 'stt_dt',
		            index: 'stt_dt',
				    align: "center",
		            width: 130
		        }, {
		            name: 'end_dt',
		            index: 'end_dt',
				    align: "center",
	           	 width: 130
		        }, {
		            name: 'reg_id',
		            index: 'reg_id',
				    align: "center",
		            width: 100
		        }, {
		            name: 'reg_dt',
		            index: 'reg_dt',
				    align: "center",
		            width: 130
		        }, {
		            name: 'qry_cnt',
		            index: 'qry_cnt',
				    align: "center",
		            width: 60
		        }
		    ],
		    rowNum: 10,
		    //rowList: [   10, 20, 30  ],
		    pager: '#pager6',
		    viewrecords: true,
		    ondblClickRow: function(id){
		    	var ret = jQuery("#list6").jqGrid('getRowData',id);
		    	var notice_id = ret.notice_id;
		    	
		        document.location.href = 'view.jsp?notice_id='+notice_id;
		    },
		    caption: "&nbsp;&nbsp;공지사항",
		    shrinkToFit: false,
		    height: 400,
		    width: 1000
		});
		
		jQuery("#list6").jqGrid('navGrid', "#pager6", {
		    edit: false,
		    add: false,
		    del: false
		});
	});
	jQuery("#list6").jqGrid('setFrozenColumns');
	
</script>
</head>
<body >

<c:import url="../menu_system/menu.jsp">
	<c:param name="menu_id">me02</c:param>
</c:import>

	<table id="list6"></table>
	<div id="pager6"></div>

	<span id="btn_add" class="btn"  style="cursor:pointer; " onclick="add()">등록</span>
	

</body>
</htm>