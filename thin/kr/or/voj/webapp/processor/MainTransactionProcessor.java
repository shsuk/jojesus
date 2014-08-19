package kr.or.voj.webapp.processor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;


@Service
public class MainTransactionProcessor implements ProcessorService{

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object execute(ProcessorParam processorParam) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		List<String> processorList = processorParam.getProcessorList();
		
		for(String processorId : processorList){
			Object obj = ProcessorServiceFactory.getProcessorService(processorId.toLowerCase()).execute(processorParam);
			
			if (obj instanceof Map) {
				Map map = (Map) obj;
				result.putAll(map);
			}else{
				result.put(processorId, obj);
			}
			processorParam.setProcessorResult(result);
		}
		return result;
	}
	

}
