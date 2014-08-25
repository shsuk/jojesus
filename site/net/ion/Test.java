package net.ion;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibatis.sqlmap.client.SqlMapClient;

public class Test {

	@Autowired
	SqlMapClient sqlMapClient;
	/**
	 * @param args
	 */
	public static void main(String[] args)throws Exception {
		

	}
	public void test()throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		String[] list = {"022ed2cd-99f4-41ae-ac69-b5580ffe6672","0577dd81-7d2e-4c8d-95a4-7e2657570979"};
		
		params.put("file_id", list);
		Object obj = sqlMapClient.queryForList("test.test", params);

	}

}
