package com.jaws.objects;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

@XmlRootElement(name = "Radar")
@XmlType(propOrder = {"centerX", "centerY", "radius"})
public class Radar {
	
	/** Center of the radar, in mm */
	protected int center_x;
	
	/** Center of the radar, in mm */
	protected int center_y;
	
	/** Radius of the radar, in mm */
	protected int radius;
	
	public Radar() {
		center_x = 0;
		center_y = 0;
		radius = 0;
	}
	
	public Radar(int x, int y, int r) {
		this.center_x = x;
		this.center_y = y;
		this.radius = r;
	}
	
	@XmlElement(name = "centerX")
	public int getCenterX() {
		return center_x;
	}
	
	@XmlElement(name = "centerY")
	public int getCenterY() {
		return center_y;
	}
	
	@XmlElement(name = "radius")
	public int getRadius() {
		return radius;
	}
	
	public void setCenterX(int x)
	{
		center_x = x;
	}
	
	public void setCenterY(int y)
	{
		center_y = y;
	}
	
	public void setRadius(int r) {
		radius = r;
	}
}
