package com.jaws.objects;

import java.util.LinkedList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlElements;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

@XmlRootElement(name = "RadarList")
@XmlType(propOrder = {"radars"})
public class RadarList {
	@XmlElementWrapper(name="radars")
    @XmlElements(
        @XmlElement(name="Radar", type=Radar.class)
    )
	protected List<Radar> radars = new LinkedList<>();
	
	public RadarList() {
		//
	}
	
	public void addRadar(Radar r) {
		radars.add(r);
	}
	
	public List<Radar> getRadars() {
		return radars;
	}
}