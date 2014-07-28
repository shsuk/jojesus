package kr.or.voj.webapp.processor;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletRequest;

import kr.or.voj.webapp.db.DefaultDaoSupportor;
import kr.or.voj.webapp.db.QueryInfoFactory;
import net.sf.json.JSONObject;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;


/**
 * <pre>
 * 시스템명 : KT_MVNO_KPM
 * 작 성 자 : 석승한
 * 작 성 일 : 2014. 3. 18
 * 설    명 : Test
 * 
 * </pre>
 */
@Service
public class DBProcessor implements ProcessorService{
	@Override
	public Object execute(ProcessorParam processorParam) throws Exception {
		String path = processorParam.getQueryPath();
		CaseInsensitiveMap params = processorParam.getParams();
		String action = processorParam.getAction();
		ServletRequest request = processorParam.getRequest();
		
		Map<String, Object> resultSet = new HashMap<String, Object>();
		//쿼리정보를 가지고 온다.
		Map<String, JSONObject> queryInfos = QueryInfoFactory.findQuerys(path, params);
		
		if(queryInfos==null){
			return resultSet;
		}

		DefaultDaoSupportor defaultDaoSupportor = ProcessorServiceFactory.getDaoSupportor(null);
		DefaultDaoSupportor daoSupportor = null;
		//쿼리 목록에서 조건에 부합하는 쿼리를 순차적으로 실행한다.
		for(String key : queryInfos.keySet()){
			JSONObject queryInfo = queryInfos.get(key);
			String queryAction = getString("action", queryInfo, "");
			//action이 없거나 같은 쿼리만 실행한다.
			if(!"".equals(queryAction) && !StringUtils.equals(action, queryAction)){
				continue;
			}
			//다른 쿼리의 부속 쿼리는 스킵한다.
			if(getBoolean("subQuery", queryInfo, false)){
				continue;
			}
			//접속할 데이타 소스를 가지고 온다.
			String ds = getString("ds", queryInfo, "");
			daoSupportor = StringUtils.isNotEmpty(ds) ? ProcessorServiceFactory.getDaoSupportor(ds) : defaultDaoSupportor;				
			
			if(daoSupportor==null){
				throw new RuntimeException(ds + "로 정의된 데이타 소스가 존재하지 않습니다.");
			}
			
			String query = queryInfo.getString("query");
			query = makeQuery(key, query, queryInfos);
			boolean isSingleRow = getBoolean("singleRow", queryInfo, false);
			String id = queryInfo.getString("id");
			String loop = getString("loop", queryInfo, "");
			//반복실행할 커리에 대한 처리
			if(request!=null && !"".equals(loop)){
				Map<String, String[]> reqParamMap = request.getParameterMap();
				String[] vals = reqParamMap.get(loop);
				if(vals!=null){
					//loop필드 값의 갯수 만큼 반복실행한다.
					for(int i=0; i<vals.length; i++){
						setRequestValue(i, params, reqParamMap);//해당 인덱스의 request값을 파라메터값에 설정한다.
						daoSupportor.executeQuery(id, query, isSingleRow, params, resultSet);
					}
				}
			}else{
				daoSupportor.executeQuery(id, query, isSingleRow, params, resultSet);
			}
		}
		
		return resultSet;
	}


	/**
	 * 서브쿼리를 찾아 완전한 쿼리로 만들어 준다.
	 * @param queryId
	 * @param query
	 * @param queryInfos
	 * @return
	 * @throws Exception
	 */
	private String makeQuery(String queryId, String query, Map<String, JSONObject> queryInfos) throws Exception {
		String[] subQueryIds = StringUtils.substringsBetween(query, "${", "}");
		
		if(subQueryIds==null){
			return query;
		}
		
		for(String subQueryId : subQueryIds){
			JSONObject queryInfo = queryInfos.get(subQueryId);
			if(queryInfo==null){
				throw new RuntimeException(queryId + "쿼리에서 사용하는 서브쿼리 " + subQueryId + "가 존재하지 않습니다.");
			}
			String subQuery = queryInfo.getString("query");
			query = StringUtils.replace(query, "${"+subQueryId+"}", subQuery);
		}
		
		return query;
	}
	/**
	 * 반복실행 할 커리에 대한 처리 Request정보에서 해당 인텍스 데이타를 현재정보로 설정해준다
	 * @param i
	 * @param params
	 * @param reqParamMap
	 * @return
	 */
	private CaseInsensitiveMap setRequestValue(int i, CaseInsensitiveMap params, Map<String, String[]> reqParamMap) {
		for(String ctl : reqParamMap.keySet()){
			String[] pvs = reqParamMap.get(ctl);
			String pv = pvs[i<pvs.length ? i: (pvs.length-1)];
			params.put(ctl, pv);
		}
		return params;
	}

	private boolean getBoolean(String key, JSONObject queryInfo, boolean defaultValue) throws Exception {
		return queryInfo.containsKey(key) ? queryInfo.getBoolean(key) : defaultValue;
	}
	
	private String getString(String key, JSONObject queryInfo, String defaultValue) throws Exception {
		Object val = queryInfo.get(key);
		return val==null ? "" : val.toString();
	}
}
