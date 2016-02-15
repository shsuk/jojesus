package net.ion.webapp.processor.system;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import sun.misc.BASE64Decoder;
import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;

@Service
public class ImageDataConvertorProcessor extends ImplProcessor{
	private static final SimpleDateFormat YYYYMM_FORMAT = new SimpleDateFormat("/yyyy_MM/");
	/**
	 * 프로그램에서 사용할 기본값들을 설정한다.
	 */
	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {

		Map<String, Object> params = (Map<String, Object>)processInfo.getSourceDate();
		String root = request.getServletContext().getRealPath("/");
		String path = processInfo.getString("path") + YYYYMM_FORMAT.format(new Date());
		
		for(String key : params.keySet()){
			Object val = params.get(key);
			
			if (! (val instanceof String[])) {
				continue;
			}
			
			String[] str = (String[]) val;
			String newStr = save(str[0], path, root);
			str[0] = newStr;
			params.put(key, str);
		}
		ReturnValue returnValue = new ReturnValue();
		returnValue.setResult("");
		
		return returnValue;
	}
	
	private String save(String str, String path, String root) {
		BASE64Decoder base64Decoder = new BASE64Decoder();
		String[] imgs = StringUtils.splitByWholeSeparator(str, "<img ");
		
		for(String img : imgs){
			String imageStr = StringUtils.substringBetween(img, "src=\"data:image/", "\"");
			
			if(StringUtils.isEmpty(imageStr)){
				continue;
			}
			String image = StringUtils.substringAfter(imageStr, ",");
			String ext = StringUtils.substringBefore(imageStr, ";");
			path = path + UUID.randomUUID().toString() + "." + ext;
			String filePath = root + path;
			try {
				byte[] b = base64Decoder.decodeBuffer(image);
				
				FileUtils.writeByteArrayToFile(new File(filePath), b);
				str = StringUtils.replaceOnce(str, "src=\"data:image/" + imageStr, "src=\"../" + path);
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		return str;
		
	}
}
