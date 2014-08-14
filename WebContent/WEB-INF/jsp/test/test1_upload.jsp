<%@page import="net.ion.webapp.utils.ParamUtils"%>
<%@page import="net.ion.webapp.fleupload.FileInfo"%>
<%@page import="net.ion.webapp.fleupload.Upload"%>
<%@page import="net.ion.webapp.utils.Aes"%>
<%@page import="net.ion.webapp.processor.ProcessorFactory"%>
<%@page import="net.ion.webapp.process.ReturnValue"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sp" uri="/WEB-INF/tlds/sp.tld"%>


<sp:sp queryPath="menu_system/notice" actionFild="action" processorList="attach" exception="false">
	{
		session.user_id:'test'
	}
</sp:sp> 
