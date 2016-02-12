package net.ion.webapp.controller;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
 
import javax.imageio.ImageIO;
 
import org.apache.poi.hslf.model.Slide;
import org.apache.poi.hslf.usermodel.SlideShow;
 
/**
 * PPT파일을 이미지로 변환
 * @author falbb
 * 
 * 
 * http://forum.falinux.com/zbxe/index.php?mid=lecture_tip&page=7&document_srl=785178&sort_index=readed_count&order_type=desc
http://poi.apache.org/download.html
다운로드후 압축을 풀면 여러게의 파일이 있는데....

이번에 필요한 파일은 아래와 같습니다.

- poi-3.9-20121203.jar
- poi-scratchpad-3.9-20121203.jar

 *
 */
public class PPTConvterImage {
 
	private String pptFile;
	private String cvtImgFile;
 
	public PPTConvterImage(String pptFile, String cvtImgFile) {
		this.pptFile = pptFile;
		this.cvtImgFile = cvtImgFile;
	}
 
	/**
	 * 이미지 변환 실행
	 * @throws IOException
	 */
	public void convter(String type) throws IOException {
 
		// PPT파일
		FileInputStream is = new FileInputStream(pptFile);
 
		SlideShow ppt = new SlideShow(is);
 
		// PPT파일 닫기
		is.close();
 
		Dimension pgsize = ppt.getPageSize();
 
		Slide[] slide = ppt.getSlides();
 
		for (int i = 0; i < slide.length; i++) {
 
			BufferedImage img = new BufferedImage(pgsize.width, pgsize.height,
					BufferedImage.TYPE_INT_RGB);
			Graphics2D graphics = img.createGraphics();
			// 이미지 영역을 클리어
			graphics.setPaint(Color.white);
			graphics.fill(new Rectangle2D.Float(0, 0, pgsize.width,
					pgsize.height));
 
			// 이미지 그리기
			slide[i].draw(graphics);
 
			// 파일로 저장
			FileOutputStream out = new FileOutputStream(cvtImgFile + (i + 1)
					+ "."+type);
			ImageIO.write(img, type, out);
			out.close();
		}
	}
 
	/**
	 * @param args
	 */
	public static void main(String[] args) {
 
		String pptFile = "C:/temp/test.ppt";
		String cvtImgFile = "C:/temp/";
 
		PPTConvterImage cvtImage = new PPTConvterImage(pptFile, cvtImgFile);
		try {
			cvtImage.convter("png");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}