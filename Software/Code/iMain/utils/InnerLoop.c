/*
 * Functions to set up the inner loop control of the vehicles
 *
 */

#include "InnerLoop.h"

void yawCommand(float yaw, float yaw_cmd) {
	float yaw_err = 0;
	float Kp_yaw   = 2;
	float SpeedTurn = 0;
	yaw_err = yaw_cmd - yaw;

    SpeedTurn = -Kp_yaw*yaw_err; // TODO: Initialize within this function, or make global?
    WheelSpeedCmd = SpeedTurn;   // Global?
    TurnRadiusCmd = 1;          // Global?

    if(SpeedTurn < 0) {
        WheelSpeedCmd = -1*SpeedTurn;
        TurnRadiusCmd = -1;	
    }

    if (WheelSpeedCmd > 100)  {
        WheelSpeedCmd = 100;
    }
    
	if (abs(yaw_err) < 0.5 )  {
		WheelSpeedCmd = 0;
		TurnRadiusCmd  = 0;
		yaw_cmd = -1; 
	}
	
	//drive(WheelSpeedCmd,TurnRadiusCmd);
	//return yaw_cmd;
}

void PositionCommand(float Pn_cmd, float Pe_cmd, float Pn, float Pe) {
	// Calculate Speed and Heading Command from Position commands (Pn, Pe)
	float diff_Pn = 0;
	float diff_Pe = 0;

	diff_Pn = Pn_cmd - Pn;
	diff_Pe = Pe_cmd - Pe;

	dist_PnPe = sqrt(diff_Pn*diff_Pn + diff_Pe*diff_Pe);
	SpeedCmd   = 0.2 * dist_PnPe;

	HeadingCmd_deg = atan2(diff_Pe, diff_Pn)*180/M_PI;

}

void SpeedHeadingCommand(float SpeedCmd, float HeadingCmd_deg,float Speed, float Heading_deg, float delta_t, int cycle_count) {

	// Calculate wheel speed and turn radius from Speed and Heading commands
	float HeadingErr   = 0;
	float CorrectedErr = 0;
	float k_heading    = 10000;
	float Ti_heading   = 10000000;
	float Ti_INUSE   = 0;
	float Td_heading   = 0.05;

	// Calc Heading Error, ensure correct/closest direction
	HeadingErr = atan2(sin((HeadingCmd_deg-Heading_deg)*M_PI/180), cos((HeadingCmd_deg-Heading_deg)*M_PI/180) ) * 180/M_PI;
	// Correct error, turn radius is in the opposite sign and inversely related to the Heading error
	CorrectedErr = -1/HeadingErr;
    
	if (cycle_count <=1) {
		HeadingErr_hist[0]  = 0;
		HeadingErr_hist[1]  = 0;
		HeadingErr_hist[2]  = 0;
        //Turn Radius Cmd
		TurnRadiusCmd_hist[0] = 0;
		TurnRadiusCmd_hist[1] = 0;
        // Wheel Speed Cmd
        WheelSpeedCmd_hist[1] = 0;
        WheelSpeedCmd_hist[0] = 0.1*(SpeedCmd-Speed)+WheelSpeedCmd_hist[1]; 	
	}
	else if (cycle_count == 2) {
		HeadingErr_hist[0]  = 0;
        //Turn Radius Cmd
		TurnRadiusCmd_hist[0] = 0;
		TurnRadiusCmd_hist[1] = 0;
        // Wheel Speed Cmd
        WheelSpeedCmd_hist[0] = 0.1*(SpeedCmd-Speed)+WheelSpeedCmd_hist[1]; 
	}
	else if (cycle_count >= 3) {
		HeadingErr_hist[0] = CorrectedErr;
        //Turn Radius Cmd
		TurnRadiusCmd_hist[0]    = TurnRadiusCmd_hist[1] 
		+ k_heading*((1 + (delta_t/Ti_heading)*Ti_INUSE + (Td_heading/delta_t)) * HeadingErr_hist[0] 
		- (1 + 2 * (Td_heading/delta_t)) * HeadingErr_hist[1]
		+ (Td_heading/delta_t) * HeadingErr_hist[2]);
        // Wheel Speed Cmd
        WheelSpeedCmd_hist[0] = 0.1*(SpeedCmd-Speed)+WheelSpeedCmd_hist[1]; 
	}
	
	if ((TurnRadiusCmd_hist[0] < 1) && (TurnRadiusCmd_hist[0] > 0))  {
		TurnRadiusCmd_hist[0] = 1;
	}

	if ((TurnRadiusCmd_hist[0] > -1) && (TurnRadiusCmd_hist[0] < 0))  {
		TurnRadiusCmd_hist[0] = -1;
	}
	 
	WheelSpeedCmd = WheelSpeedCmd_hist[0];
	TurnRadiusCmd = TurnRadiusCmd_hist[0];

	if (WheelSpeedCmd < 200)  {
		WheelSpeedCmd = 200;
	} 

	HeadingErr_hist[2] = HeadingErr_hist[1];
	HeadingErr_hist[1] = HeadingErr_hist[0];

	TurnRadiusCmd_hist[1] = TurnRadiusCmd_hist[0];
        WheelSpeedCmd_hist[1] = WheelSpeedCmd_hist[0];

}

