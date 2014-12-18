
// Import some needed classes
package com.jaws.comms;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.MulticastSocket;
import java.net.NetworkInterface;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;

import com.jaws.display.ArenaDisplay.Listener;


public class iServer implements Runnable {
	
	
	public static final int MSG_TYPE_STATUS = 1;
	
	public static final int MSG_TYPE_TERMINATION = 2;
	
	public static final int MSG_TYPE_DETECTION = 3;
	
	/***/
	protected static final int CREATE_PORT = 1500;
	
	/***/
	protected static final String CREATE_GROUP = "225.0.0.37";
	
	/***/
	protected MulticastSocket s;
	
	protected boolean not_done;
	
	protected Map<String, createStatus> map_status = 
			new HashMap<String, createStatus>();
	
	protected Listener listener;

	public iServer(Listener listener) {
		not_done = true;
		this.listener = listener;
	}
	
	public void initializeServer() throws IOException {
	    // Create the socket and bind it to port 'port'.
		System.out.println("Initializing socket...");
	    s = new MulticastSocket(CREATE_PORT);
	    
	    // join the multicast group
	    System.out.println("Joining multicast group...");
	    
	    InetSocketAddress socketAddress = new InetSocketAddress(CREATE_GROUP, CREATE_PORT);
	    NetworkInterface ni = NetworkInterface.getByName("wlan0");
	    s.joinGroup(socketAddress,ni);
	    
	    System.out.println("Listening for data...");
	    (new Thread(this)).start(); //TODO confirm this is correct
	}
	
	protected void listen() throws IOException {
		while(not_done) {
		    // Create a DatagramPacket and do a receive
		    //createStatus status = new createStatus();
		    //DatagramPacket pack = new DatagramPacket(status, sizeof(status));
			byte buf[] = new byte[1024];
			DatagramPacket packet = new DatagramPacket(buf, buf.length);
			s.receive(packet);
			ByteArrayInputStream b_in = new ByteArrayInputStream(
					packet.getData());
			//check for message type
			byte mt[] = new byte[1];
			b_in.read(mt, 0, 1);
			int msg_type = (int)mt[0];
			switch (msg_type) {
			case MSG_TYPE_STATUS:
				createStatus stat = readStatus(b_in);
				map_status.put(stat.getUID(), stat);
				listener.recv(stat);
				System.out.println(stat.uid + " POS: [" + stat.pos_x + "," + stat.pos_y
						+ "]");
				break;
			case MSG_TYPE_TERMINATION:
				assetTerminated at = readTermination(b_in);
				System.out.println(at.getUID() + " terminated.");
				break;
			case MSG_TYPE_DETECTION:
				radarDetection rd = readDetection(b_in);
				System.out.println(rd.getUID() + " detected by radar.");
				break;
			default:
				System.out.println("Unknown message type received");
				break;
			}
			
			System.out.println("Received data from: "
					+ packet.getAddress().toString() + ":" + packet.getPort()
					+ " with length: " + packet.getLength());
		}
	}
	
	public void run() {
		try {
			listen();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/**
	 * 
	 * @param b_in
	 * @return
	 */
	protected createStatus readStatus(ByteArrayInputStream b_in) {
		createStatus stat = new createStatus();
		byte buffer[] = new byte[4];
		b_in.read(buffer, 0, 4);
		stat.pos_x = (buffer[3] << 24 | (buffer[2] & 0xFF) << 16 | (buffer[1] & 0xFF) << 8 | (buffer[0] & 0xFF));
		b_in.read(buffer, 0, 4);
		stat.pos_y = (buffer[3] << 24 | (buffer[2] & 0xFF) << 16 | (buffer[1] & 0xFF) << 8 | (buffer[0] & 0xFF));
		b_in.read(buffer, 0, 4);
		//heading
		stat.heading = (buffer[3] << 24 | (buffer[2] & 0xFF) << 16 | (buffer[1] & 0xFF) << 8 | (buffer[0] & 0xFF));
		//velocity
		b_in.read(buffer, 0, 4);
		stat.velocity = (buffer[3] << 24 | (buffer[2] & 0xFF) << 16 | (buffer[1] & 0xFF) << 8 | (buffer[0] & 0xFF));
		//catagory
		b_in.read(buffer, 0, 4);
		stat.category = (buffer[3] << 24 | (buffer[2] & 0xFF) << 16 | (buffer[1] & 0xFF) << 8 | (buffer[0] & 0xFF));
		//UID
		byte str_buf[] = new byte[32];
		
		b_in.read(str_buf,0,32);
		stat.uid = new String(str_buf);
		return stat;
	}
	
	/**
	 * 
	 * @param b_in
	 * @return
	 */
	protected assetTerminated readTermination(ByteArrayInputStream b_in) {
		assetTerminated at = new assetTerminated();
		// UID
		byte str_buf[] = new byte[32];
		b_in.read(str_buf, 0, 32);
		at.uid = new String(str_buf);
		return at;
	}
	
	/**
	 * 
	 * @param b_in
	 * @return
	 */
	protected radarDetection readDetection(ByteArrayInputStream b_in) {
		radarDetection rd = new radarDetection();
		// UID
		byte str_buf[] = new byte[32];
		b_in.read(str_buf, 0, 32);
		rd.uid = new String(str_buf);
		return rd;
	}
	
	public createStatus getStatus(String uid) {
		return map_status.get(uid);
	}
	
	public void closeServer() throws UnknownHostException, IOException {
		not_done = false;
	    s.leaveGroup(InetAddress.getByName(CREATE_GROUP));
	    s.close();
	}
}

