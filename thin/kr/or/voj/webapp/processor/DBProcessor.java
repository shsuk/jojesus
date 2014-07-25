package kr.or.voj.webapp.processor;

import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.ServletRequest;
import javax.sql.DataSource;

import kr.or.voj.webapp.utils.DefaultMapRowMapper;
import net.sf.json.JSONObject;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.core.simple.SimpleJdbcDaoSupport;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedCaseInsensitiveMap;


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
public class DBProcessor extends SimpleJdbcDaoSupport implements ProcessorService{
	@Autowired
	private DataSource baseDataSource;

	@PostConstruct
	void init() {
		setDataSource(baseDataSource);
	}

	public ApplicationContext getApplicationContext() {
		return ProcessorServiceFactory.getApplicationContext();
	}

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
						executeQuery(id, query, isSingleRow, params, resultSet);
					}
				}
			}else{
				executeQuery(id, query, isSingleRow, params, resultSet);
			}
		}
		
		return resultSet;
	}
	/**
	 * 쿼리를 실행하고 기타 정보를 설정한 후 결과를 반환한다.
	 * @param id
	 * @param query
	 * @param isSingleRow
	 * @param params
	 * @param resultSet
	 * @throws Exception
	 */
	private void executeQuery(String id, String query, boolean isSingleRow, CaseInsensitiveMap params, Map<String, Object> resultSet) throws Exception {
		Object result = null;
		
		queryLogPrint(query, params);

		long st = System.currentTimeMillis();
		
		if(StringUtils.startsWithIgnoreCase(query, "select")){//SELECT쿼리 실행
			List<Map<String,Object>> rows = getSimpleJdbcTemplate().query(query, new DefaultMapRowMapper(), params);
			//메타데이타 설정
			setMetaData(id, rows, resultSet);
			
			result = isSingleRow ? makeSingleRow(id, params, rows) : rows;
		}else{//기타 쿼리 실행
			result = new Integer(getSimpleJdbcTemplate().update(query, params));
		}
		
		queryExecuteTimePrint(st, System.currentTimeMillis());
		
		//결과저장
		resultSet.put(id, result);
		
	}
	/**
	 * 단일레코드 반환인 경우 첫번째 레코드 반환하고,
	 * 각필드의 값이 다음 쿼리의 인자로 사용될 수 있도록 파라메터에 추가해준다. 
	 * @param id
	 * @param params
	 * @param rows
	 * @return
	 */
	private Map<String,Object> makeSingleRow(String id, CaseInsensitiveMap params, List<Map<String,Object>> rows) {
		if(rows.size()<1){
			return new HashMap<String,Object>();
		}
		
		Map<String,Object> row = rows.get(0);
		//단일 레코드인 경우 결과를 쿼리의 파라메터에 추가해 준다.
		for(String fld : row.keySet()){
			params.put(id+"."+fld, rows.get(0).get(fld));
		}
		
		return row;
	}
	/**
	 * 메타데이타를 반환한다.
	 * @param id
	 * @param rows
	 * @param resultSet
	 */
	private void setMetaData(String id, List<Map<String,Object>> rows, Map<String, Object> resultSet) throws Exception {
		ResultSetMetaData rsmd = null;
		
		if(rows.size()>0){
			rsmd = (ResultSetMetaData)rows.get(0).get("_META_DATA_");
			rows.get(0).remove("_META_DATA_");
		}
		
		if(rsmd==null){
			return;
		}
		
		LinkedCaseInsensitiveMap meta = new LinkedCaseInsensitiveMap();
		int count = rsmd.getColumnCount()+1;
		
		for(int i=1; i<count; i++){
			LinkedCaseInsensitiveMap data = new LinkedCaseInsensitiveMap();
			String key = rsmd.getColumnLabel(i);
			
			data.put("label", key);
			data.put("name", rsmd.getColumnName(i));
			//data.put("schema", rsmd.getSchemaName(i));
			//data.put("catalog", rsmd.getCatalogName(i));
			//data.put("table", rsmd.getTableName(i));
			data.put("type", rsmd.getColumnTypeName(i));
			data.put("size", rsmd.getColumnDisplaySize(i));
			data.put("precision", rsmd.getPrecision(i));
			data.put("scale", rsmd.getScale(i));
			
			meta.put(key, data);
		}
		
		resultSet.put(id+"_meta_", meta);	
		
		
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

	private boolean getBoolean(String key, JSONObject queryInfo, boolean defaultValue) throws Exception {
		return queryInfo.containsKey(key) ? queryInfo.getBoolean(key) : defaultValue;
	}
	
	private String getString(String key, JSONObject queryInfo, String defaultValue) throws Exception {
		Object val = queryInfo.get(key);
		return val==null ? "" : val.toString();
	}

	private void queryLogPrint(String sql, CaseInsensitiveMap params) {
		String log_line = "\n--------------------------------------------------------------"
		                + "--------------------------------------------------------------\n";
		logger.info(log_line+paramMarkingValue(sql, params)+log_line);
	}
	private String paramMarkingValue(String sql, CaseInsensitiveMap params) {
    	String[] s = sql.split(":");

    	for(int i=1; i<s.length; i++){
    		String[] names = s[i].split("[, ();='\n\r\t/*-+%^|]");
    		if (!(names[0].toUpperCase()).equals("MI")&&!(names[0].toUpperCase()).equals("SS")) {
    			if (params.get(names[0]) != null && !params.get(names[0]).equals("")) {
    				sql = sql.replace(":"+names[0], "'"+params.get(names[0])+"'");
    			}
    		}
    	}
		return sql;
	}
	private void queryExecuteTimePrint(long st, long et) {
		String log_line = "\n--------------------------------------------------------------"
			+ "--------------------------------------------------------------\n";
		
		logger.info(log_line+"-- query execute time : " + (et-st)/1000);
	}


}
