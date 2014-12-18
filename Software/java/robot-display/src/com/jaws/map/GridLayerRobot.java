package com.jaws.map;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Shape;
import java.awt.geom.Ellipse2D;

import javax.swing.JLabel;
import javax.swing.JPanel;

import com.jaws.comms.createStatus;

public class GridLayerRobot extends JPanel {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected createStatus status;

	public GridLayerRobot(createStatus status) {
		this.status = status;
		setOpaque(false);
	}

	public void setData(createStatus update) {
		this.status = update;
		repaint();
	}

	public void paintComponent(Graphics g) {
		// super.paintComponent(g);
		Graphics2D g2d = (Graphics2D) g;
		double scale = getWidth()/7000.0;
		double rw = 330*scale;
		Shape circle = new Ellipse2D.Double(status.getPosY()*scale-rw/2,(8000-status.getPosX())*scale-rw/2, rw, rw);
		System.out.println(circle.getBounds());
		g2d.setColor(Color.BLACK);
		g2d.setStroke(new BasicStroke(2));
		g2d.draw(circle);
		if(status.getCatagory() == createStatus.FIGHTER_FRIENDLY)
			g2d.setColor(Color.CYAN);
		else if (status.getCatagory() == createStatus.FIGHTER_ENEMY)
			g2d.setColor(Color.RED);
		else
			g2d.setColor(Color.GRAY);
		g2d.fill(circle);
		g2d.setColor(Color.BLACK);

		FontMetrics metrics = g2d.getFontMetrics();
		int fh = metrics.getHeight();
		int fw = metrics.stringWidth(status.getUID());
		g2d.drawString(status.getUID(), (int)(status.getPosY()*scale)-fw/2,
				(int)((8000-status.getPosX())*scale));
		fw = metrics.stringWidth(status.getCategoryText());
		g2d.drawString(status.getCategoryText(), (int)(status.getPosY()*scale)-fw/2,
				(int)((8000-status.getPosX())*scale)+fh);
	}

}
