package kr.or.voj.webapp.processor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.map.CaseInsensitiveMap;

public class ProcessorParam {
	private String queryPath;
	private String action;
	private CaseInsensitiveMap params;
	private Map<String, Object> context;
	private ServletRequest request;
	private List<String> processorList;
	private Map<String, Object> processorResult;
	
	public Map<String, Object> getProcessorResult() {
		return processorResult;
	}
	public Object getProcessorResultByid(String key) {
		return processorResult.get(key);
	}
	public void setProcessorResult(Map<String, Object> processorResult) {
		this.processorResult = processorResult;
	}
	public void setProcessorList(List<String> processorList) {
		this.processorList = processorList;
	}
	public List<String> getProcessorList() {
		return processorList;
	}
	public void addProcessor(String processorId){
		processorList.add(processorId);
	}
	public ProcessorParam(){
		context = new HashMap<String, Object>();
		processorList = new ArrayList<String>();
	}
	public String getQueryPath() {
		return queryPath;
	}
	public void setQueryPath(String queryPath) {
		this.queryPath = queryPath;
	}
	public CaseInsensitiveMap getParams() {
		return params;
	}
	public void setParams(CaseInsensitiveMap params) {
		this.params = params;
		ProcessorServiceFactory.setReqParam((HttpServletRequest)request, params);

	}
	public String getAction() {
		return action;
	}
	public void setAction(String action) {
		this.action = action;
	}
	public ServletRequest getRequest() {
		return request;
	}
	public void setRequest(ServletRequest request) {
		this.request = request;
		ProcessorServiceFactory.setReqParam((HttpServletRequest)request, params);
	}
	public Map<String, Object> getContext() {
		return context;
	}
	public void setAttribute(String key, Object value){
		context.put(key, value);
		
	}
	public Object getAttribute(String key){
		return context.get(key);
		
	}
}
