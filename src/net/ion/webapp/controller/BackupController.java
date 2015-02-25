package net.ion.webapp.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.controller.DefaultAutoController;
import net.ion.webapp.utils.DbUtils;
import net.ion.webapp.utils.HttpUtils;
import net.ion.webapp.utils.LowerCaseMap;
import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class BackupController extends DefaultAutoController {
	protected static final Logger LOGGER = Logger.getLogger(BackupController.class);
	protected static final SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
	
	@Value("#{system['backup.backupListUrl']}")
	private String backupListUrl;
	@Value("#{system['backup.serverActionUrl']}")
	private String actUrl;
	@Value("#{system['backup.dowonLoadUrl']}")
	private String dowonLoadUrl;

	/**
	 * 서버에 있는 파일을 백업서버로 백업한다.
	 * 백업서버에서 동작
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/backup.sh")
	@ResponseBody
	public Map<String, Object> backupMain(HttpServletRequest request, HttpServletResponse response) throws Exception {	
		Map<String, Object> resultSet = null;
		System.out.println("백업 시작");
		resultSet = backup(request, response);
		System.out.println("백업 완료");
		return resultSet;
	}
	/**
	 * 백업된 파일중 3개월전 이미지 파일을 삭제한다.
	 * 웹서버에서 동작
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/del_backup.sh")
	@ResponseBody
	public Map<String, Object> deleteMain(HttpServletRequest request, HttpServletResponse response) throws Exception {	
		System.out.println("삭제 시작");
		Map<String, Object> resultSet = delete(request, response);
		System.out.println("삭제 완료");
		
		return resultSet;
	}

	private Map<String, Object> backup(HttpServletRequest request, HttpServletResponse response) throws Exception {	
		Map<String, Object> resultSet = new HashMap<String, Object>();

		Map<String, Object> params = new HashMap<String, Object>();
		Date lastDate = null;
		String startDate = null;
		String backRep = request.getServletContext().getRealPath("/web_rep");

		try {
			resultSet.put("sucess", true);
			File fi = new File(backRep, "last_date.dat");
			
			if(fi.exists()){
				startDate = FileUtils.readFileToString(fi);
			}
			String listUrl = backupListUrl + (StringUtils.isEmpty(startDate) ? "2010-01-01" : startDate);
			String json = HttpUtils.getString(listUrl, params);

			Map map = JSONObject.fromObject(json);
			List<Map> list = (List<Map>)map.get("list");
			
			System.out.println("백업 리스트 URL : " + listUrl);
			System.out.println("백업 데이타 갯수 : " + list.size());
			
			for(Map row:list){
				try {
					String dwUrl = dowonLoadUrl + row.get("file_id");
					System.out.println(dwUrl);
					//첨부파일 백업
					String filePath = backRep + row.get("file_path");
					File f = new File(filePath + "." + (String)row.get("file_ext"));
					f.getParentFile().mkdirs();
					HttpUtils.getFile(dwUrl, params, f);
					if(f.length()==0){
						params.put("backup", "0");						
					}else{
						params.put("backup", "Y");
					}

					//파일정보 기록
					File fInfo = new File(filePath+".json");
					FileUtils.writeStringToFile(fInfo, row.toString(),"utf-8");
					Object date = row.get("created");
					if (date instanceof Long) {
						lastDate = new Date((Long)date);
						//System.out.println(lastDate);
					}else if (date instanceof Date) {
						lastDate = (Date)date;
					}else{
						System.out.println("알수없는 타입");
					}
					
				} catch (Exception e) {
					e.printStackTrace();
					params.put("backup", "E");
				}
				
				json = HttpUtils.getString(actUrl+row.get("file_id"), params);
				System.out.println(json);
			}
			startDate = dateFormater.format(lastDate);
			FileUtils.writeStringToFile(fi, startDate);
			System.out.println("마자막 자료의 생성일 : " + startDate);
			
		} catch (Exception e) {
			e.printStackTrace();
			resultSet = new HashMap<String, Object>();
			resultSet.put("sucess", false);
			resultSet.put("message", e.toString());
		}
		
		return resultSet;
	}
	
	private Map<String, Object> delete(HttpServletRequest request, HttpServletResponse response) throws Exception {	
		Map<String, Object> resultSet = new HashMap<String, Object>();

		Map<String, Object> params = new HashMap<String, Object>();

		try {
			resultSet.put("sucess", true);
			
			List<LowerCaseMap<String, Object>> list = DbUtils.select("system/attach/delete_list", params);
;
			
			System.out.println("삭제대상 데이타 갯수 : " + list.size());
			
			for(Map row:list){
				try {
					File f = new File((String)row.get("volume") + row.get("file_path"));
					boolean isOk = f.delete();

					params.put("backup", "D");
					params.put("file_id", row.get("file_id"));
					int i = DbUtils.update("system/attach/back_ok", params);
					System.out.println(i + ":" + isOk);
				} catch (Exception e) {
					e.printStackTrace();
				}
				
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
