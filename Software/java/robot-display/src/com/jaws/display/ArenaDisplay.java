package com.jaws.display;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.swing.JFrame;
import javax.swing.JLayeredPane;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import com.jaws.comms.createStatus;
import com.jaws.comms.iServer;
import com.jaws.map.Grid;
import com.jaws.map.GridLayerRadar;
import com.jaws.map.GridLayerRobot;
import com.jaws.objects.Radar;
import com.jaws.objects.RadarList;

public class ArenaDisplay extends JFrame {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	protected iServer server;
	protected int x=0;
	protected int layer_count = 0;
	protected JLayeredPane layeredPane;
	protected Map<String, GridLayerRobot> map_layers = new HashMap<String, GridLayerRobot>();
	
	public class Listener {
		public void recv(Object message) {
			if(message instanceof createStatus) {
				createStatus status = (createStatus) message;
				if(map_layers.get(status.getUID())==null) {
					GridLayerRobot robo = new GridLayerRobot(status);
					robo.setSize(layeredPane.getSize());
					map_layers.put(status.getUID(), robo);
					//add layer to main panel so it gets drawn
					layeredPane.add(robo, new Integer(layer_count++));
				}
				map_layers.get(status.getUID()).setData(status);
			}
		}
	}
	
	protected Listener listener = new Listener();
	
	public ArenaDisplay() {
		setSize(700,800);
		setLayout(new BorderLayout());
		layer_count = 0;
		server = new iServer(listener);
		try {
			server.initializeServer();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		layeredPane = new JLayeredPane();
		Grid background = new Grid(700,800,16,14);
		background.setBackground(Color.WHITE);
		layeredPane.add(background , new Integer(layer_count++));
		//TODO: initialize radars
		RadarList radars = readRadars();
		if (radars != null) {
			for (Radar r : radars.getRadars()) {
				GridLayerRadar radar = new GridLayerRadar(700, 800,
						r.getCenterX(), r.getCenterY(), r.getRadius());
				radar.setBackground(Color.BLACK);
				radar.setOpaque(false);
				layeredPane.add(radar, new Integer(layer_count++));
			}
		}
		
		getContentPane().add(layeredPane, BorderLayout.CENTER);
        setSize(700, 800);
	}
	
	protected static RadarList readRadars() {
        try {
            JAXBContext context = JAXBContext.newInstance(RadarList.class, Radar.class);
            Unmarshaller un = context.createUnmarshaller();
            RadarList rl = (RadarList) un.unmarshal(new File("radars.xml"));
            return rl;
        } catch (JAXBException e) {
            e.printStackTrace();
        }
        return null;
    }
	
	public static void main(String[] args) {
		ArenaDisplay arena = new ArenaDisplay();
		arena.setTitle("Robo-Arena");
		arena.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		arena.setPreferredSize(new Dimension(700,800));
		arena.setVisible(true);
	}

}
