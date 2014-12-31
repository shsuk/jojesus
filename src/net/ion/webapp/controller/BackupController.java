package net.ion.webapp.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.controller.DefaultAutoController;
import net.ion.webapp.utils.HttpUtils;
import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class BackupController extends DefaultAutoController {
	protected static final Logger LOGGER = Logger.getLogger(BackupController.class);

	@RequestMapping(value = "/backup.sh")
	@ResponseBody
	public Map<String, Object> api(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, Object> resultSet = new HashMap<String, Object>();
		resultSet.put("sucess", true);
		String url = "http://vojesus.org/system-attach-back_list/api.sh?act=S";
		String actUrl = "http://vojesus.org/system-attach-back_ok/api.sh?act=U&file_id=";
		try {
			Map<String, Object> params = new HashMap<String, Object>();
			Map<String, Object> param = new HashMap<String, Object>();
			String json = HttpUtils.getString(url, params);

			Map map = JSONObject.fromObject(json);
			List<Map> list = (List<Map>)map.get("list");
			
			for(Map row:list){
				try {
					String dwUrl = "http://vojesus.org/at.sh?_ps=at/upload/dl&file_id=" + row.get("file_id");
					System.out.println(dwUrl);
					String filePath = "D:/voj_web_file" + row.get("file_path");
					File f = new File(filePath);
					File fInfo = new File(filePath+"."+row.get("file_ext")+".json");
					
					f.getParentFile().mkdirs();
					FileUtils.writeStringToFile(fInfo, row.toString(),"utf-8");
					
					HttpUtils.getFile(dwUrl, params, f);
					if(f.length()==0){
						param.put("backup", "0");						
					}else{
						param.put("backup", "Y");
					}
					
				} catch (Exception e) {
					param.put("backup", "E");
				}
				
				json = HttpUtils.getString(actUrl+row.get("file_id"), param);
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultSet = new HashMap<String, Object>();
			resultSet.put("sucess", false);
			resultSet.put("message", e.toString());
		}
		
		return resultSet;
	}
}
