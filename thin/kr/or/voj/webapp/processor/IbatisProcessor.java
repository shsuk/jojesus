package kr.or.voj.webapp.processor;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;

import kr.or.voj.webapp.db.DefaultDaoSupportor;
import kr.or.voj.webapp.db.QueryInfoFactory;
import net.sf.json.JSONObject;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.engine.impl.SqlMapClientImpl;
import com.ibatis.sqlmap.engine.impl.SqlMapExecutorDelegate;
import com.ibatis.sqlmap.engine.mapping.statement.MappedStatement;
import com.ibatis.sqlmap.engine.mapping.statement.SelectStatement;

@Service
public class IbatisProcessor implements ProcessorService{
	Map<String, List<MappedStatementInfo>> mappedStatementInfoMap = null;

	SqlMapClient sqlMapClient;
	
	@Override
	public Object execute(ProcessorParam processorParam) throws Exception {
		
		if(sqlMapClient==null){
			sqlMapClient = (SqlMapClient)ProcessorServiceFactory.getBean(SqlMapClient.class);
		}
		String path = processorParam.getQueryPath();
		CaseInsensitiveMap params = processorParam.getParams();
		String action = processorParam.getAction();
		
		Map<String, Object> resultSet = new HashMap<String, Object>();
		List<MappedStatementInfo> msList = getList(path, action);
		
		for(MappedStatementInfo msi : msList){
			if (msi.isSelect) {
				 List list = sqlMapClient.queryForList(msi.id, params);
				 
				 if(msi.isSingleRow){
					 resultSet.put(msi.returnId, list.size()>0 ? list.get(0) : new HashMap());
				 }else{
					 resultSet.put(msi.returnId,list);
				 }
			}else{
				resultSet.put(msi.returnId, sqlMapClient.update(msi.id, params));
			}
			
		}

		return resultSet;
	}

	class MappedStatementInfo{
		boolean isSingleRow = false;
		String id;
		String returnId;
		boolean isSelect = false;
		
		public MappedStatementInfo(String id, String returnId, boolean isSelect, boolean isSingleRow){
			this.isSingleRow = isSingleRow;
			this.id = id;
			this.returnId = returnId;
			this.isSelect = isSelect;
			
		}
	}
	
	private List<MappedStatementInfo> getList(String path, String action) {
		String key = path + "." + action;
		
		if(mappedStatementInfoMap!=null){
			return mappedStatementInfoMap.get(key);
		}
		
		List<String> idList = new ArrayList<String>();
		Map<String, List<MappedStatementInfo>> msInfoMap = new HashMap<String, List<MappedStatementInfo>>();

		SqlMapExecutorDelegate delegate = ((SqlMapClientImpl)sqlMapClient).delegate;
		Iterator<String> it = delegate.getMappedStatementNames();
		
		while(it.hasNext()){
			String id = it.next();
			idList.add(id);
		}
		
		String[] ids =  idList.toArray(new String[0]);
		Arrays.sort(ids);
		
		for(String id : ids){			
			boolean isSingleRow = false;
			boolean isSelect = false;
			
			String keyId = StringUtils.substringBefore(id, "_");
			if(StringUtils.isEmpty(keyId)){
				keyId = id;
			}
			String[] idL = id.split("_");
			String returnId = idL.length == 3 ? idL[2] : "";
			if(StringUtils.isEmpty(returnId)){
				returnId = StringUtils.substringAfter(id, ".");
			}			
			
			if(returnId.startsWith("#")){
				isSingleRow = true;
				returnId = returnId.substring(1);
			}
		
			MappedStatement mappedStatement = delegate.getMappedStatement(id);
			if (mappedStatement instanceof SelectStatement) {
				isSelect = true;
			}

			MappedStatementInfo msi = new MappedStatementInfo(id, returnId, isSelect, isSingleRow);
			
			List<MappedStatementInfo> list = msInfoMap.get(keyId);
			
			if(list==null){
				list = new ArrayList<IbatisProcessor.MappedStatementInfo>();
				msInfoMap.put(keyId, list);
			}
			
			list.add(msi);
		}
		
		mappedStatementInfoMap = msInfoMap;

		return mappedStatementInfoMap.get(key);
	}
}
