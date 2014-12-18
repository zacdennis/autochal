package com.jaws.map;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Shape;
import java.awt.geom.Ellipse2D;

import javax.swing.JPanel;

/**
 * Layer to draw a radar.
 * 
 * @author Alexis Mackenzie
 */
public class GridLayerRadar extends JPanel {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/** The width and height of the grid */
	protected int width, height;
	
	protected int center_x, center_y;
	
	protected double radius;

	public GridLayerRadar(int w, int h, int c_x, int c_y, int r) {
		setSize(width = w, height = h);
		center_x = c_x; //in millimeters
		center_y = c_y; //in mm
		radius = r;
		setOpaque(false);
	}

	public void paintComponent(Graphics g) {
		// super.paintComponent(g);
		Graphics2D g2d = (Graphics2D) g;
		double scale = getWidth() / 7000.0;
		double rw = radius * scale;
		Shape circle = new Ellipse2D.Double(center_y * scale - rw, (8000-center_x)
				* scale - rw, 2*rw, 2*rw);
		g2d.setColor(Color.BLACK);
		g2d.setStroke(new BasicStroke(4));
		g2d.draw(circle);
		g2d.setColor(new Color(255, 0, 0, 125));
		g2d.fill(circle);
		g2d.setColor(Color.BLACK);
		String text = "RADAR";
		FontMetrics metrics = g.getFontMetrics(g.getFont());
		int w = metrics.stringWidth(text);
		g2d.drawString(text, (int) circle.getBounds().getCenterX() - w / 2,
				(int) circle.getBounds().getCenterY());
	}
}
