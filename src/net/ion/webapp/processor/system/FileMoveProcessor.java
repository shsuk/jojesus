package net.ion.webapp.processor.system;

import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;

import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Service;

@Service
public class FileMoveProcessor  extends ImplProcessor {

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();
		returnValue.setResult(false);

		String source = processInfo.getString("source");
		
		if(source.endsWith("/") || source.endsWith("\\") || source.indexOf("..")>-1){
			throw new IOException("source에 ../ 값이 오거나, '/' 또는 '\\'로 끝날 수 없습니다.");
		}
		
		String target = processInfo.getString("target");
		boolean isDelete = processInfo.getBooleanValue("isDelete", false);

		File src = new File(source);
		File dest = new File(target);
		
		move(src, dest, isDelete);
		
		returnValue.setResult(true);
		return returnValue;
	}
	
	private void move(File src, File dest, boolean isDelete)throws IOException {
		boolean isSuccess = dest.getParentFile().mkdirs();

		if(isDelete && dest.exists()){
			if(dest.isDirectory()){
				FileUtils.deleteDirectory(dest);
			}else{
				dest.delete();
			}
		}
		
		isSuccess = src.renameTo(dest);
		
		if(!isSuccess){
			throw new IOException("파일 복사에 실패하였습니다.");
		}
	}
	
	public static void main(String[] args) throws IOException {
		FileMoveProcessor fM = new FileMoveProcessor();
		//FileUtils.moveDirectoryToDirectory(new File("c:/temp1"), new File("c:/temp2"), true);
		fM.move(new File("c:/temp2/headerBg.jpg"), new File("c:/temp3/headerBg.jpg"), false);
	}
}
