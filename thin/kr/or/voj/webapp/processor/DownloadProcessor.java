package kr.or.voj.webapp.processor;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.stereotype.Service;

@Service
public class DownloadProcessor  implements ProcessorService {
	public Object execute(ProcessorParam processorParam) throws Exception {
		
		
		OutputStream out = null;
		InputStream is = null;

		try {
			Map<String, Object> data = getFileDate(processorParam);
			
			String fileName = (String)data.get("file_name");
			String filePath = (String)data.get("file_path");
			HttpServletResponse response = (HttpServletResponse)processorParam.getResponse();
			out = response.getOutputStream();
			
			writeHeader(response, (HttpServletRequest)processorParam.getRequest(), fileName, 0);
			
			is = new FileInputStream(new File(filePath));
			
			IOUtils.copyLarge(is, out);
				
		}finally{
			if (out != null){
				try {
					out.close();
				} catch (Exception e) { }
			}
			if(is!=null){
				try {
					is.close();
				} catch (Exception e) { }
			}
		}
		
		return null;
	}
	private Map<String, Object> getFileDate(ProcessorParam processorParam) throws Exception {
		
		try {
			
			Map<String, Object> rtnMap = processorParam.getProcessorResult();
			Map<String, Object> data = null;
			for(String key : rtnMap.keySet()){
				if(key.endsWith("_meta_")){
					continue;
				}
				Object obj = rtnMap.get(key);
				if (obj instanceof List) {
					List<Object> list = (List) obj;
					obj = list.get(0);
				}
				
				if (obj instanceof Map) {
					data = (Map) obj;
					if(data.containsKey("file_name") && data.containsKey("file_path")){
						return data;
					}
				}
			}
						
		} catch (Exception e) {}

		throw new RuntimeException("파일 테이타가 존재하지 않습니다.");
		
	}
	private void writeHeader(HttpServletResponse response, HttpServletRequest request, String filename, long size) throws Exception {
		response.setContentType("application/octet-stream; charset=utf-8");
		response.setHeader("Content-Disposition", getDisposition(filename, getBrowser(request)));
		response.setCharacterEncoding("utf-8");
		
		response.setHeader("Content-Transfer-Encoding", "binary"); 
		if (size > 0) response.setHeader("Content-Length", String.valueOf(size));		
	}
	
	private String getBrowser(HttpServletRequest request) {

		String header = request.getHeader("User-Agent");

		if (header.indexOf("MSIE") > -1) return "MSIE";
		else if (header.indexOf("Chrome") > -1) return "Chrome";
		else if (header.indexOf("Opera") > -1) return "Opera";
		
		return "Firefox";

	}

	private String getDisposition(String filename, String browser) throws Exception {

		String dispositionPrefix = "attachment;filename=";

		String encodedFilename = null;

		if (browser.equals("MSIE")) {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Firefox")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Opera")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
			StringBuffer sb = new StringBuffer();

			for (int i = 0; i < filename.length(); i++) {
				char c = filename.charAt(i);

				if (c > '~') sb.append(URLEncoder.encode("" + c, "UTF-8"));
				else sb.append(c);
			}

			encodedFilename = sb.toString();
		} else {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		}

		return dispositionPrefix + encodedFilename;
	}
}
