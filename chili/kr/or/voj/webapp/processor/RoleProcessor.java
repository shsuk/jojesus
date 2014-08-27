package kr.or.voj.webapp.processor;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
@Service
public class RoleProcessor implements ProcessorService{

	public  Object execute(ProcessorParam processorParam) throws Exception {
		HttpSession session = ((HttpServletRequest)processorParam.getRequest()).getSession();
		String key = session.getId() + "@role_cd";

		Map<String,Object> roleMap = (Map<String,Object>)ProcessorServiceFactory.getCache(key);
		
		if(roleMap==null){
			roleMap = get( processorParam);
			ProcessorServiceFactory.setCache(key, roleMap);
		}
		
		return roleMap;
	}
	private Map<String,Object> get(ProcessorParam processorParam) throws Exception {
		Map<String,Object> roleMap = new HashMap<String, Object>();
		
		Map<String,Object> map = (Map<String,Object>)ProcessorServiceFactory.getProcessorService("db").execute(processorParam);
		List<Map<String, Object>> list = (List<Map<String, Object>>)map.get("rows");
		
		for(Map<String, Object> row : list){
			roleMap.put(row.get("role_cd")+"."+row.get("page_url"), row);
		}
		
		return roleMap;
		
	}
}
