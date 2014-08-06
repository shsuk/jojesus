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
		    url: '../../notice/update.jsp?'+new Date().getTime(),
		    datatype: "json",
		    colNames: [
		        'InvNo',
		        'Date',
		        'Client',
		        'Amount',
		        'Tax',
		        'Total',
		        'Notes'
		    ],
		    colModel: [
		        {
		            name: 'id',
		            index: 'id',
		            width: 55
		        }, {
		            name: 'invdate',
		            index: 'invdate',
		            width: 190
		        }, {
		            name: 'name',
		            index: 'name',
		            width: 100
		        },{
		            name: 'amount',
		            index: 'amount',
		            width: 180,
		            align: "right"
		        },{
		            name: 'tax',
		            index: 'tax',
		            width: 180,
		            align: "right"
		        },{
		            name: 'total',
		            index: 'total',
		            width: 80,
		            align: "right"
		        }, {
		            name: 'note',
		            index: 'note',
		            width: 150,
		            sortable: false
		        }
		    ],
		    rowNum: 10,
		    //rowList: [   10, 20, 30  ],
		    pager: '#pager6',
		    sortname: 'id',
		    viewrecords: true,
		    sortorder: "desc",
		    onSortCol: function(name,
		    index){
		        alert("Column Name: "+name+" Column Index: "+index);
		    },
		    ondblClickRow: function(id){
		        alert("You double click row with id: "+id);
		    },
		    caption: " Get Methods",
		    shrinkToFit: false,
		    height: 200,
		    width: 500
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
	<br />
	<a href="javascript:void(0)" id="g1"
		onclick="alert(jQuery('#list6').jqGrid('getGridParam','url'));">Get
		url</a>
	<br />
	<a href="javascript:void(0)" id="g2"
		onclick="alert(jQuery('#list6').jqGrid('getGridParam','sortname'));">Get
		Sort Name</a>
	<br />
	<a href="javascript:void(0)" id="g3"
		onclick="alert(jQuery('#list6')jqGrid('getGridParam','sortorder'));">Get
		Sort Order</a>
	<br />
	<a href="javascript:void(0)" id="g4"
		onclick="alert(jQuery('#list6')jqGrid('getGridParam','selrow'));">Get
		Selected Row</a>
	<br />
	<a href="javascript:void(0)" id="g5"
		onclick="alert(jQuery('#list6')jqGrid('getGridParam','page'));">Get
		Current Page</a>
	<br />
	<a href="javascript:void(0)" id="g6"
		onclick="alert(jQuery('#list6').jqGrid('getGridParam','rowNum'));">Get
		Number of Rows requested</a>
	<br />
	<a href="javascript:void(0)" id="g7"
		onclick="alert('See Multi select rows example');">Get Selected
		Rows</a>
	<br />
	<a href="javascript:void(0)" id="g8"
		onclick="alert(jQuery('#list6').jqGrid('getGridParam','datatype'));">Get
		Data Type requested</a>
	<br />
	<a href="javascript:void(0)" id="g9"
		onclick="alert(jQuery('#list6').jqGrid('getGridParam','records'));">Get
		number of records in Grid</a>

</body>
</htm>