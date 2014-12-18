package com.jaws.comms;

import java.io.Serializable;

public class createStatus implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public static final int UNKNOWN = 0;
	public static final int SURVEILLOBOMBER = 1;
	public static final int SUVALIENCE = 2;
	public static final int BOMBER = 3;
	public static final int JAMMER = 4;
	public static final int FIGHTER_FRIENDLY = 5;
	public static final int FIGHTER_ENEMY = 6;
	
	protected int pos_x;
	protected int pos_y;
	protected int heading;
	protected int velocity;
	protected int category;
	protected String uid;
	
	public createStatus() {
		pos_x = 0;
		pos_y = 0;
		heading = 0;
		velocity = 0;
		category = FIGHTER_FRIENDLY;
		uid = "iRobot Create";
	}
	
	public int getPosX() {
		return pos_x;
	}
	
	public int getPosY() {
		return pos_y;
	}
	
	public int getHeading() {
		return heading;
	}
	
	public int getVelocity() {
		return velocity;
	}
	
	public int getCatagory() {
		return category;
	}
	
	public String getCategoryText() {
		switch(category) {
		case FIGHTER_FRIENDLY:
			return "FIGHTER";
		case FIGHTER_ENEMY:
			return "ENEMY FIGHTER";
		default:
			return "UNKNOWN";
		}
	}
	
	public String getUID() {
		return uid;
	}
}
