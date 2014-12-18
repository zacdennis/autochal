package com.jaws.comms;

import java.io.Serializable;

/**
 * 
 * @author computer1
 *
 */
public class assetTerminated implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	protected String uid;
	
	public assetTerminated () {
		uid = null;
	}
	
	public String getUID() {
		return uid;
	}
}
