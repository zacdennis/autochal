package com.jaws.map;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;

import javax.swing.JPanel;

/**
 * Background to draw a grid.
 * 
 * @author Alexis Mackenzie
 */
public class Grid extends JPanel {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/** The width and height of the grid */
	protected int width, height;

	/** The number of rows */
	protected int rows;

	/** The number of columns */
	protected int cols;

	public Grid(int w, int h, int r, int c) {
		setSize(width = w, height = h);
		rows = r;
		cols = c;
	}

	public void paintComponent(Graphics g) {
		super.paintComponent(g);
		int i;
		width = getSize().width;
		height = getSize().height;

		// draw the rows
		int rowHt = height / (rows);
		for (i = 0; i < rows; i++)
			g.drawLine(0, i * rowHt, width, i * rowHt);

		// draw the columns
		int rowWid = width / (cols);
		for (i = 0; i < cols; i++)
			g.drawLine(i * rowWid, 0, i * rowWid, height);
		
		//draw center
		//TODO change line thickness to bolder
		Graphics2D g2d = (Graphics2D) g;
		g2d.setStroke(new BasicStroke(2));
		g2d.setColor(Color.BLACK);
		g2d.drawLine(cols/2*rowWid - rowWid/4, rows/2*rowHt-rowHt/4, cols/2*rowWid + rowWid/4, rows/2*rowHt+rowHt/4);
		g2d.drawLine(cols/2*rowWid - rowWid/4, rows/2*rowHt+rowHt/4, cols/2*rowWid + rowWid/4, rows/2*rowHt-rowHt/4);
	}
}