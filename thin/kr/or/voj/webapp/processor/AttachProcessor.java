package kr.or.voj.webapp.processor;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.security.util.FieldUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Service
public class AttachProcessor implements ProcessorService{

	private static final SimpleDateFormat YYYYMM_FORMAT = new SimpleDateFormat("yyyy_MM");

	public  Object execute(ProcessorParam processorParam) throws Exception {
		CaseInsensitiveMap params = processorParam.getParams();
		HttpServletRequest request = (HttpServletRequest)processorParam.getRequest();

		Map<String, List<Map<String, Object>>> result = new HashMap<String, List<Map<String,Object>>>();

		
		if (! (request instanceof MultipartHttpServletRequest)) {
			return null;
		}
		MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
		
		Iterator<String> it = mRequest.getFileNames();
		
		while (it.hasNext()) {
			int idx = -1;
			String attachId = it.next();
			List<MultipartFile> files = mRequest.getFiles(attachId);
			
			for(MultipartFile file : files){
				long fileSize = file.getSize();
				String fileName = file.getOriginalFilename();
				
				if(fileSize<1) continue;

				String ext = StringUtils.substringAfterLast(fileName, ".");
				ext = ext!=null ? ext.toLowerCase() : "";

				InputStream is = file.getInputStream();
				//파일을 저장소에 파일을 저장한다.
				saveFile(result, attachId, idx, is, fileName, fileSize);

			}
		}
		
		Map<String, String[]> parameterMap = request.getParameterMap();
		//request의 파일콘트롤 값을 파일 아이디로 치환한다. ParameterMap과 가공된 정보 모두 치환한다.
		//Map<String, String[]> reqParameterMap = mRequest.getParameterMap();
		//Map<String, String[]> parameterMap = new HashMap<String, String[]>(); //(Map<String, String[]>)request.getAttribute(ProcessService.REQUEST_REPLACE_PARAMS);
		//List<String> attIds1 = new ArrayList<String>();
		
		for(String key : result.keySet()){
			List<Map<String, Object>> attchFileList = result.get(key);
			
			//attIds.add(key);//오류시 롤백을 위해 첨부파일의 필드명을 저장한다.
			List<String> ids = new ArrayList<String>();
			List<String> names = new ArrayList<String>();
			List<String> paths = new ArrayList<String>();
			
			for(Map<String, Object> map : attchFileList){
				Object o = map.get("fileId");
				String fileId = o==null ? null : o.toString();
				ids.add(fileId);

				o = map.get("fileName");
				String name = o==null ? null : o.toString();
				names.add(name);
				
				o = map.get("filePath");
				String path = o==null ? null : o.toString();
				paths.add(path);
			}
			parameterMap.put(key, ids.toArray(new String[0]));
			parameterMap.put(key+".name", names.toArray(new String[0]));
			parameterMap.put(key+".path", paths.toArray(new String[0]));
		}
		//request.getParameterMap();
		FieldUtils.setProtectedFieldValue("multipartParameters", mRequest, parameterMap);
		//첨부파일의 추가정보를 반영하기 위해 다시 설정한다.
		processorParam.setRequest(mRequest);
		return null;
	}

	private void saveFile(Map<String, List<Map<String, Object>>> result, String attachId, int idx, InputStream is, String fileName, long fileSize) throws Exception{
		
		String ext = StringUtils.substringAfterLast(fileName, ".");
		ext = ext!=null ? ext.toLowerCase() : "";


		List<Map<String, Object>> attchFileList = result.get(attachId);
		
		if(attchFileList==null){
			attchFileList = new ArrayList<Map<String,Object>>();
			result.put(attachId, attchFileList);
		}
		
		
		String fileId = UUID.randomUUID().toString();
		Map<String, Object> fileMap = new HashMap<String, Object>();
		//파일저장 TODO
		String filePath = ProcessorServiceFactory.getRepositoryPath() + fileId;
		FileOutputStream fos = null;
		
		try {
			fos = new FileOutputStream(new File(filePath));
			IOUtils.copyLarge(is, fos);
		}finally{
			if(fos!=null){
				try {
					fos.close();
				} catch (Exception e2) {
					// TODO: handle exception
				}
			}
		}
		fileMap.put("id", attachId);
		fileMap.put("fileId", fileId);
		fileMap.put("fileName", fileName);
		fileMap.put("filePath", filePath);
		fileMap.put("ext", ext);
		fileMap.put("size", fileSize);
		
		if(idx<0){
			attchFileList.add(fileMap);
		}else{
			setList(attchFileList, idx, fileMap);
		}
	}

	private void setList(List<Map<String, Object>> attchFileList, int idx, Map<String, Object> map) {

		if(attchFileList.size()<idx) setList(attchFileList, idx-1, null);
		
		if(attchFileList.size()==idx) attchFileList.add(idx, map);
		else attchFileList.set(idx, map);
	}
	
	
}
