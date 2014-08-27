package kr.or.voj.webapp.processor;

import java.io.File;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import kr.or.voj.webapp.db.DefaultDaoSupportor;
import kr.or.voj.webapp.utils.CacheService;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.core.io.Resource;

/**
 * <pre>
 * 시스템명 : KT_MVNO_KPM
 * 작 성 자 : 석승한
 * 작 성 일 : 2014. 3. 18
 * 설    명 : Test
 * 
 * </pre>
 */
public class ProcessorServiceFactory  implements ApplicationContextAware {
	private static Map<String, ProcessorService> processorServiceMap = new HashMap<String, ProcessorService>();;
	private static Map<String, DefaultDaoSupportor> daoSupportorMap = new HashMap<String, DefaultDaoSupportor>();;
	private static ApplicationContext applicationContext;
	private static final Logger logger = Logger.getLogger(ProcessorServiceFactory.class);
	private static String queryFullPath = null;
	private static String repositoryPath = null;
	private static String defaultDataSourceName = null;
	private static CacheService cacheService = null;

	public static Object getCache(String key) {
		return cacheService.get(key);
	}
	public static void setCache(String key, Object data) {
		
		cacheService.put(key, data);
	}
	
	public static String getRepositoryPath() {
		new File(repositoryPath).mkdirs();
		return repositoryPath;
	}

	public void setRepositoryPath(String repositoryPath) {
		
		ProcessorServiceFactory.repositoryPath = repositoryPath.toString();
		new File(repositoryPath).mkdirs();
	}
	
	public static String getQueryFullPath() {
		return queryFullPath;
	}

	public void setApplicationContext(ApplicationContext applicationContext) {
		ProcessorServiceFactory.applicationContext = applicationContext;
		//프로세서 서비스를 초기화 한다.
		init();
	}

	public static ApplicationContext getApplicationContext() {
		return applicationContext;
	}
	public void setQueryPath(Resource queryPath) {
		try {
			queryFullPath = queryPath.getFile().getAbsolutePath() + "/";
			if(repositoryPath==null){
				setRepositoryPath(queryPath.getFile().getParent() + "/rep/");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public void setDefaultDataSourceName(String defaultDataSourceName) {
		this.defaultDataSourceName = defaultDataSourceName;
	}
	/**
	 * 프로세서 서비스를 초기화 한다.
	 */
	public static void init(){

		cacheService = new CacheService();
		cacheService.start();

		if(processorServiceMap.size() > 0){
			//return;
		}
		String[] serviceList = applicationContext.getBeanNamesForType(ProcessorService.class);

		for(String key : serviceList) {
			String name = "";
			try {
				ProcessorService autoProcessor = (ProcessorService)applicationContext.getBean(key);
				name = autoProcessor.toString();
				
				name = StringUtils.substringBetween(name, "kr.or.voj.webapp.processor.", "Processor").toLowerCase();
				name = name.replace('.', '_');
				processorServiceMap.put(name , autoProcessor);
				
			} catch (Exception e) {
				logger.error(name + "의 이름이 Processor 로 끝나지 않아 등록되지 않았습니다.");
			}
		}
		
		serviceList = applicationContext.getBeanNamesForType(DataSource.class);

		for(String key : serviceList) {
			DataSource dataSource = (DataSource)applicationContext.getBean(key);
			
			DefaultDaoSupportor defaultDaoSupportor = new DefaultDaoSupportor();
			defaultDaoSupportor.setDataSource(dataSource);
			
			daoSupportorMap.put(key, defaultDaoSupportor);
		}
		
		if(StringUtils.isEmpty(defaultDataSourceName) && serviceList.length>0){
			defaultDataSourceName = serviceList[0];
		}
	}
	
	public static Object getBean(Class cls){
		String[] idList =applicationContext.getBeanNamesForType(cls);
		
		if(idList.length>0){
			return applicationContext.getBean(idList[0]);
		}
		
		return null;
	}
	public static ProcessorService getProcessorService(String method) {
		return processorServiceMap.get(method);
	}
	
	public static DefaultDaoSupportor getDaoSupportor(String dataSourceName) {
		
		dataSourceName = StringUtils.isEmpty(dataSourceName) ? defaultDataSourceName : dataSourceName;
		
		return daoSupportorMap.get(dataSourceName);
	}
	
	public static Map<String, Object> executeMainTransaction(List<String> processorList, CaseInsensitiveMap params, String queryPath, String action, String loopId, ServletRequest request, ServletResponse response) throws Exception{
		ProcessorParam processorParam = new ProcessorParam(loopId);
		processorParam.setQueryPath(queryPath);
		processorParam.setAction(action);
		processorParam.setParams(params);
		processorParam.setRequest(request);
		processorParam.setResponse(response);;
		processorParam.setProcessorList(processorList);
		
		return executeMainTransaction(processorParam);

	}
	public static Map<String, Object> executeMainTransaction(ProcessorParam processorParam) throws Exception{
		
		return (Map<String, Object>)processorServiceMap.get("maintransaction").execute(processorParam);

	}
	public static CaseInsensitiveMap getReqParam(HttpServletRequest request){
		CaseInsensitiveMap req = new CaseInsensitiveMap();
		return setReqParam(request, req, null);
		
	}
	public static CaseInsensitiveMap setReqParam(HttpServletRequest request, CaseInsensitiveMap params, String loopId){
		if(request==null || params==null){
			return params;
		}
		
		Map<String, String[]> parameterMap = request.getParameterMap();
		
		String[] loopValue = parameterMap.get(loopId);
		List<Map<String, String>> loopList = new ArrayList<Map<String,String>>();
		if(loopValue!=null){
			for(int i=0; i<loopValue.length; i++){
				loopList.add(new HashMap<String, String>());
			}
		}
		//request정보를 맵에 추가한다.
		
		for(String key :  parameterMap.keySet()){
			String[] vals = parameterMap.get(key);
			params.put(key, vals[0]);
			params.put(key+"_", vals);
			String allVal = "";
			for(int i=0; i<vals.length; i++){
				String val = vals[i];
				params.put(key+"[" +i + "]", val);
				allVal += "," + val;
			}
			
			allVal = allVal.length() > 0 ? allVal.substring(1) : allVal;
			params.put(key+"[]",allVal);
			params.put(key+"_all",allVal);
			
			if(loopValue==null){
				continue;
			}
			
			for(int i=0; i<loopValue.length; i++){
				Map<String, String> map = loopList.get(i);
				if(i<vals.length){
					map.put(key, vals[i]);
				}
			}
		}
		
		if(StringUtils.isNotEmpty(loopId)){
			params.put("loop_", loopList);
		}
		
		CaseInsensitiveMap sessionMap = new CaseInsensitiveMap();
		HttpSession session = request.getSession();
		Enumeration<String> en = session.getAttributeNames();
		
		while(en.hasMoreElements()){
			String key = en.nextElement();
			Object val = session.getAttribute(key);
			
			if (! (val instanceof String)) {
				continue;
			}
			sessionMap.put(key, val);
			params.put("session."+key, val);
		}
		
		params.put("session", sessionMap);
		params.put("request.servletPath", request.getServletPath());
		
		return params;
	}	
	
	public static Object executeQuery(String queryPath, String action, CaseInsensitiveMap params) throws Exception {
		List<String> processorList = new ArrayList<String>();
		processorList.add("db");
		ProcessorParam processorParam = new ProcessorParam(null);
		processorParam.setQueryPath(queryPath);
		processorParam.setAction(action);
		processorParam.setParams(params);
		processorParam.setProcessorList(processorList);
		Object obj = ProcessorServiceFactory.getProcessorService("db").execute(processorParam);
		
		return obj;
	}
	
}
