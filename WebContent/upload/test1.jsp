<%@page import="net.ion.webapp.fleupload.Upload"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>파일업로드 상태바 예제</title>
<script src="../jquery/js/jquery-1.9.1.min.js"></script>
</head>

<script type="text/javascript">

var url = '../at.sh?_ps=test/test1_upload';

function send(){

	var fd = new FormData($('#main_form')[0]);
	if(fd==null){
	    $('#msg').text('업로드 정보 없습');
	    $('#main_form').attr('target','submit_frame');
		$('#main_form').submit();
	}else{
		sendFormData(fd);
	}
}
function sendFormData(fd){
	var xhr = new XMLHttpRequest();
	 
	xhr.upload.addEventListener("progress", function(e, a1, a2) {
	       if (e.lengthComputable) {
	            var percentage = Math.round((e.loaded * 100) / e.total);
	           // $("#msg").text( ' - ' + percentage + '%');
	        	$('#msg').animate({width: percentage + '%'},70);	        }
	    }, false
	);
	
	xhr.onreadystatechange = function() { 
	    if (xhr.readyState == 4 && xhr.status == 200) {
	        //alert(xhr.responseText);
	    }
	};
	
	xhr.upload.addEventListener("load", function(e){
	       $('#msg').text('전송완료');
	    }, false
	);
	     
	xhr.open("POST", url);
	      
	xhr.send(fd);

}
</script>
<body>
<c:import url="../menu_system/menu.jsp">
	<c:param name="current_menu" value="me04-2"/>
</c:import>
<div  id="main_body" >
	<form id="main_form" method="post" enctype="multipart/form-data">
		<input type="file" id="file0" name="file0"><br>
		<input type="file" id="file1" name="file1">
	</form>
	<div id="progress" style="width: 200px; height:20px; border:1px solid #cccccc; "><div id="msg" style="background:red;height:20px; width:0px; "></div></div>
	
	<button onclick="send()">전송</button>
</div>
 	<iframe name="submit_frame" style="width: 0px; height: 0px;"></iframe>
</body>
</html>