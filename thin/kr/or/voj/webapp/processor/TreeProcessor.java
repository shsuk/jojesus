package kr.or.voj.webapp.processor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;

import kr.or.voj.webapp.db.DefaultDaoSupportor;
import kr.or.voj.webapp.db.QueryInfoFactory;
import net.sf.json.JSONObject;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;


@Service
public class TreeProcessor implements ProcessorService{
	@Override
	public Object execute(ProcessorParam processorParam) throws Exception {
		CaseInsensitiveMap params = processorParam.getParams();
		
		String _upper_field_name = (String)params.get("_upper_id_field_name");
		String _field_name =  (String)params.get("_id_field_name");
		String _level_name =  (String)params.get("_level_name");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		Map<String, Object> resultSet = new HashMap<String, Object>();
		List<Map<String, Object>> rows = (List<Map<String, Object>>)processorParam.getProcessorResult().get(params.get("_source"));
		
		addLevel(rows, list, _upper_field_name, _field_name, _level_name, 1);
		
		return list;
	}

	private void addLevel(List<Map<String, Object>> src, List<Map<String, Object>> trg, String _upper_field_name, String _field_name, String _level_name, int level) {
		String lev = Integer.toString(level);
		for(Map<String, Object> row : src){
			if(!lev.equals(row.get(_level_name).toString())){
				continue;
			}
			trg.add(row);
			addSub(src, trg, _upper_field_name, _field_name, row.get(_field_name).toString());
			//addLevel(src, trg, _upper_field_name, _field_name, level+1);
		}
		
	}
	private void addSub(List<Map<String, Object>> src, List<Map<String, Object>> trg, String _upper_field_name, String _field_name, String uVal ) {
		for(Map<String, Object> row : src){
			String uid= row.get(_upper_field_name).toString();
			
			if(uVal.equals(uid)){				
				trg.add(row);
				addSub(src, trg, _upper_field_name, _field_name, row.get(_field_name).toString());
			}
		}
	}
}
