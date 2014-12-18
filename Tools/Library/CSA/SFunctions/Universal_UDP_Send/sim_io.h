
/* Receive / Send Buffer Structure Type
*
* To be sent from the simulation (Simulink) to the
* displays (including VFD)
*
*/

typedef struct{
	/* 6DOF Equations of Motion StateBus Output:							 */
	double P_i[3];				/* Inertial Position                [ft]	 */
	double P_f[3];				/* Central Body Fixed Position  	[ft]	 */
	double Pned[3];				/* North-East-Down Position			[ft]	 */
	double V_i[3];				/* Inertial Velocity                [ft]	 */
	double V_f[3];				/* Central Body Fixed Velocity  	[ft]	 */
	double Vned[3];				/* North-East-Down Velocity			[ft]	 */
	double Vmag;				/* Inertial Velocity Magnitude		[ft/s]	 */
	double Vrel_i[3];			/* Relative Velocity in Inertial Fr [ft/s]	 */
	double Vrel_b[3];			/* Rel Velocity in Body Frame		[ft/s]	 */
	double A_b[3];				/* CG Acceleration in Body Frame	[ft/s^2] */
	double A_i[3];				/* CG Acceleration in Inertial Frm. [ft/s^2] */
	double A_nongrav_b[3];		/* Body Frame Accels. w/o Gravity   [ft/s^2] */
	double A_nongrav_i[3];		/* Inertial Frm Accels. w/o Gravity [ft/s^2] */
	double Apilot[3];			/* Body Frame Accels at Pilot Pos.	[ft/s^2] */
	double g_cg;				/* G's at Center of Gravity			[g]		 */
	double g_pilot;				/* G's at Worst Case Pilot Station	[g]  	 */
	double PQRbody[3];			/* Body Roll, Pitch, & Yaw Rates	[rad/s]	 */
	double PQRbodyDot[3];		/* Body Roll, Pitch, & Yaw Accels.	[rad/s^2]*/
	double Quaternion[4];		/* Quaterions w.r.t Inerital Frame 1,2,3,0	 */
	double Euler_i[3];			/* Euler angles in Inertial Frame   [rad]	 */
	double Euler_f[3];			/* Euler angles in Fixed Frame		[rad]	 */
	double EulerNED[3];			/* Euler angles in North/East/Down	[rad]	 */
	double GeocentricLat;		/* Geocentric Latitude				[deg]	 */
	double GeodeticLat;			/* Geodetic Latitude				[deg]	 */
	double LatDot;				/* Geocentric Latitude Rate			[deg/s]	 */
	double Longitude;			/* Longitude						[deg]	 */
	double LonDot;   			/* Longitude Rate					[deg]	 */
	double LST;     			/* Local Sidereal Time				[deg]	 */
	double Alt;					/* Altitude     					[ft]	 */
	double AltDot;				/* Altitude Rate					[ft/s]	 */
	double simtime;				/* Simulation Time					[sec]	 */
	double negRhat[3];  		/* Vector (inertial) to Cen.Body CG	[ND]	 */
	double Alpha;				/* Angle of Attack					[rad]	 */
	double Beta;				/* Angle of Sideslip				[rad]	 */
	double Vtrue;				/* True total relative Velocity		[ft/s]	 */
	double Mach;				/* Mach number at Altitude			[ND]     */
	double Qbar;				/* Dynamic Pressure				[slug/ft-s^2]*/
	double Gamma;				/* Vertical Flight Path Angle		[rad]	 */
	double Mu;					/* Flight Path Roll (Bank) Angle	[rad]	 */
	/* CM SensorBus:														 */
	double Sensor_PQRbody[3];	/* Body Roll, Pitch, & Yaw Rates	[rad/s]	 */    
	/* CM VehicleBus - CM RCSBus:											 */
	double CM_RCS_FuelMass;		/* CM RCS Fuel Mass                 [slugs]  */
	double CM_RCS_MassFlowRate; /* CM RCS Mass Flow Rate		[slugs/sec]  */
	/*CM GuidanceBus Output:												 */
	double AlphaCmd;			/* Alpha Command                    [rad]    */
	double BankCmd;				/* Bank (Mu) Command                [rad]    */
	double BetaCmd;		        /* Beta Command                     [rad]    */
	double Crange;			    /* Cross Range to Target            [ft]     */
	double Drange;				/* Downrange to Target              [ft]     */
	double TotalRange;			/* Total Range to Target            [ft]     */
	double RefTotRange;			/* Reference Range to Target        [ft]     */
	double GuidancePhase;		/* Guidance Phase                   [ND]     */
	double Time_To_EI;			/* Time to Entry Interface          [sec]    */
	/* RPOD Relative Nav Display											 */
	double P_relTarget[3];     /* Position of the CEV in the ISS frame	*/
    double V_relTarget[3];     /* Velocity of the CEV in the ISS frame	*/
    double Euler_relTarget[3]; /* Euler angles expressed in ISS frame	*/
    double Omega_relTarget[3]; /* Angular rates expressed in ISS frame	*/
    double AttErrVert;		/* Attitude Circle’s Centroid Vertical Location;	-1 is at very bottom; +1 is at top of display */
	double AttErrHorz;		/* Attitude Circle’s Centroid Horizontal Location;	-1 is at very left; +1 is at right of display */
	double AttErrRoll;		/* Attitude Circle’s Rotation of Caret;	-1 is at very bottom; +1 is at top of display */
	double AttCircleRad;	/* Attitude Circle’s Radius;		0 is at ¼ of blue circle; 1 same size */
	double TransErrVert;	/* Pink Vertical Error Line’s Location;	-1 is at very bottom; +1 is at top */
	double TransErrHorz;	/* Pink Horizontal Error Line’s Location;	-1 is at very left; +1 is at right */
	double Range;			/* Numerical Value of Range for Tape;	n/a */
	double RangePhase;		/* Integer for which graduation scale to show; 	1=1 ft (0to10); 2=10 ft (0to100); 3=100ft (0to1000) */
	double RangeRate;		/* Numerical Value of Range Rate meter;	n/a */
	double RangeRatePhase;	/* Integer for which graduation scale to show;	1=+/- 1 ft/sec max; 2=+/- 3 ft/sec max */
	double AbsHorzErr;		/* Pink Diamond Horizontal Location	-1 is very left; +1 is right */
	double AbsVertErr;		/* Pink Diamond Vertical Location		-1 is very bottom; +1 is top */
	double HorzCorridor;	/*	Yellow Region Horizontal Scale		mirrored; 0 is not showing; 1 is fully closed in */
							/* (e.g. 0.5 is left side at -0.25 and right side at +0.75) */
	double VertCorridor;	/*	Yellow Region Vertical Scale		mirrored; 0 is not showing; 1 is fully closed in */
							/* (e.g. 0.5 is bottom side at -0.25 and top side at +0.75) */
	double RPOD1;			/* RPOD Display double 1						 */
	double RPOD2;			/* RPOD Display double 2						 */
	double RPOD3;			/* RPOD Display double 3						 */
	double RPOD4;			/* RPOD Display double 4						 */
	double RPOD5;			/* RPOD Display double 5						 */
	double RPOD6;			/* RPOD Display double 6						 */
	double RPOD7;			/* RPOD Display double 7						 */
	double RPOD8;			/* RPOD Display double 8						 */
	double RPOD9;			/* RPOD Display double 9						 */
	double RPOD10;			/* RPOD Display double 10						 */
	/* CM ControlBus Output:												 */
	double AlphaErr;		/* Alpha Error (AlphaTrim - Alpha)	[rad]		 */
	double BetaErr;			/* Beta Error (BetaCmd - Beta)      [rad]		 */
	double MuErr;			/* Mu Error (MuCmd - Mu)			[rad]	 	 */
	double PQRcmdController[3];	/* Controller Rate Commands	[deg/sec]		 */
	/* RPOD Display	Labels													 */
	char RPODlabel1[8];			  /* RPOD Display Label 1					 */
	char RPODlabel2[8];			  /* RPOD Display Label 2					 */
	char RPODlabel3[8];			  /* RPOD Display Label 3					 */
	char RPODlabel4[8];			  /* RPOD Display Label 4					 */
	char RPODlabel5[8];			  /* RPOD Display Label 5					 */
	char RPODlabel6[8];			  /* RPOD Display Label 6					 */
	char RPODlabel7[8];			  /* RPOD Display Label 7					 */
	char RPODlabel8[8];			  /* RPOD Display Label 8					 */
	char RPODlabel9[8];			  /* RPOD Display Label 9					 */
	char RPODlabel10[8];		  /* RPOD Display Label 10					 */
    bool   CMRCSjets[12];     /* CM RCS Thruster Commands [1/0: on/off]		 */
    bool   SMRCSjets[16];     /* SM RCS Thruster Commands [1/0: on/off]      */
    bool   SMOMSjets[2];      /* SM OMS Thruster Commands [1/0: on/off]      */
	/* CM VehicleBus - CM ComponentBus:										 */
	bool   Jet_SM;				/* SM Jettisoned?             [1/0: yes/no]  */
	bool   Jet_LAS;				/* LAS Jettisoned?            [1/0: yes/no]  */
	bool   Jet_FwdCover;		/* Forward Cover Jettisoned?  [1/0: yes/no]  */
	bool   Jet_DockingEquip;	/* Docking Equip. Jettisoned? [1/0: yes/no]  */
	bool   Jet_HeatShield;		/* Heat Shield Jettisoned?    [1/0: yes/no]  */
	bool   Dep_AirBags;			/* Air Bags Deployed?         [1/0: yes/no]  */
	bool   Dep_Drogues;			/* Drogue Chutes Deployed?    [1/0: yes/no]  */
	bool   Dep_Mains;			/* Main Chutes Deployed?      [1/0: yes/no]  */
	/* Simulation Events			                                         */
	bool   Fail_Displays;		/* Fail Displays              [1/0: yes/no]  */
}buf_type;

/* IO Math:
*      StateBus:   80 doubles * 8 bytes/double = 640 bytes
*     SensorBus:    3 doubles * 8 bytes/double =  24 bytes
*     CM RCSBus:    2 doubles * 8 bytes/double =  16 bytes
*   GuidanceBus:    9 doubles * 8 bytes/double =  72 bytes
* RPOD Displays:   12 doubles * 8 bytes/double =  96 bytes
*					2 ints	  * 4 bytes/int    =   8 bytes
*    ControlBus:    6 doubles * 8 bytes/double =  48 bytes
*                  12 bools   * 1 bytes/bool   =  12 bytes
*  ComponentBus:    8 bools   * 1 byte/bool    =   8 bytes
*     SimEvents:    1 bool    * 1 byte/bool    =   1 bytes
*                                                ----------
*                                      Total:    925 bytes
*/
