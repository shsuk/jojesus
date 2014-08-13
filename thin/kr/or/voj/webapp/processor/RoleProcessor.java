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
		Map<String,Object> roleMap = (Map<String,Object>)session.getAttribute("ROLE_MAP");
		
		if(roleMap==null){
			roleMap = init(session, processorParam);
		}else if( (new Date()).getTime() - (Long)session.getAttribute("ROLE_MAP_INIT_TIME") > 60000){
			roleMap = init(session, processorParam);	
			//System.out.println(new Date());
		}
		//System.out.println(new Date());
		
		return roleMap;
	}
	private Map<String,Object> init(HttpSession session, ProcessorParam processorParam) throws Exception {
		Map<String,Object> roleMap = new HashMap<String, Object>();
		
		Map<String,Object> map = (Map<String,Object>)ProcessorServiceFactory.getProcessorService("db").execute(processorParam);
		List<Map<String, Object>> list = (List<Map<String, Object>>)map.get("rows");
		
		for(Map<String, Object> row : list){
			roleMap.put(row.get("role_cd")+"."+row.get("page_url"), row);
		}
		
		session.setAttribute("ROLE_MAP", roleMap);
		session.setAttribute("ROLE_MAP_INIT_TIME", (new Date()).getTime());
		
		return roleMap;
		
	}
}
