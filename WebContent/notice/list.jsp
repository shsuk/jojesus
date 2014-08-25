<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>
<%@ taglib prefix="tag"  tagdir="/WEB-INF/tags" %> 

<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">

<head>
<link href="../jquery/development-bundle/themes/redmond/jquery.ui.all.css"  rel="stylesheet" type="text/css" media="screen" />
<link href="../jquery/jqGrid/css/ui.jqgrid.css"  rel="stylesheet" type="text/css" media="screen" />
<link href="../jquery/jqGrid/plugins/ui.multiselect.css" rel="stylesheet" type="text/css" media="screen" />
<link href="../menu_system/contents.css" rel="stylesheet" type="text/css" />

<script src="../jquery/js/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="../jquery/js/jquery-ui-1.10.0.custom.min.js" type="text/javascript"></script>
<script src="../jquery/jqGrid/js/i18n/grid.locale-en.js" type="text/javascript"></script>
<script src="../jquery/jqGrid/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script src="../menu_system/commonUtil.js" type="text/javascript"></script>

<script type="text/javascript">

	String.prototype.replaceAll = function( searchStr, replaceStr )
	{
		return this.split( searchStr ).join( replaceStr );
	};
	
	String.prototype.trim = function()
	{
		return this.replace(/^\s+|\s+$/g,"");
	};

	var url = '../../notice/action.jsp';
	$(function() {
		initJqGrid();
		
		$( window ).resize(function() {
			jQuery("#list6").jqGrid('setGridWidth',$( '#main_layer' ).width()-160);		
		}).resize();
	});
	
	function initJqGrid(){
		jQuery("#list6").jqGrid({
		    url: url + '?action=l',
		    datatype: "json",
		    mtype: 'POST',
		    colNames: [
		        '번호', '파일', '제목',  '공지기간', '작성자', '작성일', '조회수'
		    ],
		    colModel: [
				{
				    name: 'notice_id', index: 'notice_id', width: 50, sortable:false,  align: "center"
				},{
				    name: 'attach',  index: 'attach', width: 30,
				    formatter : function(value, options, rData){ return value==0 ? '' : value; },
		            sortable:false, align: "center"
				}, {
		            name: 'subject', index: 'subject',  width: 400,
				    formatter : function(value, options, rData){ return value.replaceAll('<', '&lt;'); },
		            sortable:false
		        }, {
		            name: 'noti_dt', index: 'noti_dt', align: "center", width: 160, sortable:false
		        }, {
		            name: 'reg_id', index: 'reg_id', align: "center", width: 100, sortable:false
		        }, {
		            name: 'reg_dt', index: 'reg_dt', align: "center", width: 80, sortable:false
		        }, {
		            name: 'qry_cnt', index: 'qry_cnt', align: "center", width: 60, sortable:false
		        }
		    ],
		    rowNum: 15,
		    //rowList: [   10, 20, 30  ],
		    pager: '#pager6',
		    viewrecords: true,
		    ondblClickRow: function(id){
		    	var ret = jQuery("#list6").jqGrid('getRowData',id);
		    	var notice_id = ret.notice_id;
		    	
		        document.location.href = 'view.jsp?notice_id='+notice_id;
		    },
		    shrinkToFit: true,
		    
		    height: 380,
		    width: 800
		});
		
		jQuery("#list6").jqGrid('navGrid');
		jQuery("#list6").jqGrid('setFrozenColumns');
		
	}
	function add(){
        document.location.href = 'edit.jsp?notice_id=0';
	}
	function search(){
		//if($("#search_text").val()==''){
		//	alert('검색어를 입력하세요.');
		//	return;
		//}
		$("#list6").jqGrid(
			'setGridParam',
			{
				url:url,
				page:1,
				postData : {
					action : 'l',
			        search_type: $("#search_type").val(),
			        search_text: $("#search_text").val(),
				}

			}
		).trigger("reloadGrid");
		
		$("#search_text").val('');
	}
</script>
</head>
<body >
<c:import url="../menu_system/menu.jsp">
	<c:param name="current_menu" value="mm3-1"/>
</c:import>

<div id="main_body" >
	<div class="ui-jqgrid-titlebar ui-widget-header ui-corner-top ui-helper-clearfix" style="padding: 3px;width: 170px; float: left;">
		<b style="font-size: 14px;padding: 20px;">공지사항 리스트</b>
	</div>
	<div style="padding: 3px; float: right;">
		<tag:select_array codes="subject=제목,reg_id=작성자,contents=내용" name="search_type"/>
		<input type="text" id="search_text" name="search_text">
		<div id="btn_add" class="btn"  style="cursor:pointer; float: right; margin-left: 2px; padding-top: 0px;" onclick="search()">검색</div>
	</div>
	<div  style="clear: both;"></div>
	<div id="main_list">
		<table id="list6"></table>
		<div id="pager6"></div>
	</div>
	<div style="margin-top: 20px;">
		<tag:role type="save">
		</tag:role>
			<div id="btn_add" class="btn"  style="cursor:pointer; float: right;" onclick="add()">등록</div>
	</div>
</div>
</body>
</htm>