package kr.or.voj.webapp.processor;

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
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;


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
public class MainTransactionProcessor implements ProcessorService{

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object execute(ProcessorParam processorParam) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		List<String> processorList = processorParam.getProcessorList();
		
		for(String processorId : processorList){
			Object obj = ProcessorServiceFactory.getProcessorService(processorId).execute(processorParam);
			
			if (obj instanceof Map) {
				Map map = (Map) obj;
				result.putAll(map);
			}else{
				result.put(processorId, obj);
			}
		}
		return result;
	}
	

}
