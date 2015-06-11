package net.ion.webapp.utils;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;

import javax.imageio.ImageIO;

/**
 * RotateImage45Degrees.java - 1. scales an image's dimensions by a factor of
 * two 2. rotates it 45 degrees around the image center 3. displays the
 * processed image
 */
public class RotateImage90 {

	public static void rotate(File file, boolean isRight) throws Exception {

		
		BufferedImage bi = ImageIO.read(file);
		BufferedImage rotated = null;

		if(!isRight) {
			rotated = rotate90CCW(bi);
		}else{
			rotated = rotate90CW(bi);
		}
		
		
		ImageIO.write(rotated, "jpg", file);

	}

	public static BufferedImage rotate90CW(BufferedImage bi) {
		int width = bi.getWidth();
		int height = bi.getHeight();

		BufferedImage biFlip = new BufferedImage(height, width, bi.getType());

		for (int i = 0; i < width; i++)
			for (int j = 0; j < height; j++)
				biFlip.setRGB(height - 1 - j, i, bi.getRGB(i, j));

		return biFlip;
	}

	public static BufferedImage rotate90CCW(BufferedImage bi) {
		int width = bi.getWidth();
		int height = bi.getHeight();

		BufferedImage biFlip = new BufferedImage(height, width, bi.getType());

		for (int i = 0; i < width; i++)
			for (int j = 0; j < height; j++)
				biFlip.setRGB(j, width - 1 - i, bi.getRGB(i, j));

		return biFlip;
	}
}