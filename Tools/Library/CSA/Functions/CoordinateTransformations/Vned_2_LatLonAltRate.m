% VNED_2_LATLONALTRATE Compute Latitude/Longitude/Altitude Rate from Velocity North/East/Down
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Vned_2_LatLonAltRate:
%     Compute Latitude/Longitude/Altitude Rate from Velocity North/East/Down 
% 
% SYNTAX:
%	[LatRate_dps, LonRate_dps, AltRate] = Vned_2_LatLonAltRate(Vned, GeodeticLat_deg, Alt_msl,  CB_flatten, CB_a)
%
% INPUTS: 
%	Name            Size	Units           Description
%	Vned            [3]     [length/sec]    Velocity in the North/East/Down
%                                            frame
%	GeodeticLat_deg	[1]     [deg]           Geodetic Latitude
%	Alt_msl	        [1]     [length]        Altitude mean sea level
%   CB_flatten      [1]     [ND]            Central Body flattening parameter
%                                            Default:  1/298.257223563 (WGS-84)
%   CB_a            [1]     [length]        Central Body semi-major axis
%                                            Default: 6378137.0 [m] (WGS-84)
%
% OUTPUTS: 
%	Name           	Size	Units           Description
%	LatRate_dps	    [1]     [deg/sec]       Latitude Rate
%	LonRate_dps	    [1]     [deg/sec]       Longitude Rate
%	AltRate	        [1]     [length/sec]    Altitude Rate
%
% NOTES:
%	This function uses RadiusAtGeodeticLat.
%
% EXAMPLES:
%	% Example #1:
%   % Gamma_deg      = 3;
%   % Chi_deg        = 45;
%   % Vtrue_fps      = 500;
%   % V_ned_fps      = GammaChiVtrue2Vned(Gamma_deg, Chi_deg, Vtrue_fps)
%   % GeodeticLat_deg= 45;
%   % Alt_msl_ft     = 1000;
%   % CentralBody    = CentralBodyEarth_init(0);
%   % [LatRate_dps, LonRate_dps, AltRate_fps] = Vned_2_LatLonAltRate(V_ned_fps, ...
%   %     GeodeticLat_deg, Alt_msl_ft, CentralBody.flatten, CentralBody.a)
%
% SOURCE DOCUMENTATION:
%   [1]    Stevens, Brian L. and Lewis, Frank L.  "Aircraft Control and
%           Simulation. 2nd Edition" New York: John Wiley & Sons, Inc. 2003.
%           Pages 36-38.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Vned_2_LatLonAltRate.m">Vned_2_LatLonAltRate.m</a>
%	  Driver script: <a href="matlab:edit Driver_Vned_2_LatLonAltRate.m">Driver_Vned_2_LatLonAltRate.m</a>
%	  Documentation: <a href="matlab:winopen(which('Vned_2_LatLonAltRate_Function_Documentation.pptx'));">Vned_2_LatLonAltRate_Function_Documentation.pptx</a>
%
% See also RadiusAtGeodeticLat 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/844
%  
% Copyright Northrop Grumman Corp 2014
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/Vned_2_LatLonAltRate.m $
% $Rev: 3125 $
% $Date: 2014-03-25 21:12:07 -0500 (Tue, 25 Mar 2014) $
% $Author: sufanmi $

function [LatRate_dps, LonRate_dps, AltRate] = Vned_2_LatLonAltRate(Vned, GeodeticLat_deg, Alt_msl,  CB_flatten, CB_a)

%% Main Function:
conversions;

% Compute M (Ref 1, pg. 37, Eqn 1.4-3)
% Compute N (Ref 1, pg. 38, Eqn 1.4-5)
[~, M, N] = RadiusAtGeodeticLat(GeodeticLat_deg, CB_flatten, CB_a);
Vn  = Vned(1);
Ve  = Vned(2);
h   = Alt_msl;

% Ref 1, pg 38, Eqn 1.4-4
LatRate_dps = ( Vn/(M+h) )*C.R2D;
% Ref 1, pg 38, Eqn 1.4-6
LonRate_dps = ( Ve/((N+h)*cos(GeodeticLat_deg*C.D2R)) )*C.R2D;
AltRate = -Vned(3);

end % << End of function Vned_2_LatLonAltRate >>

%% AUTHORS
% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username 
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

%% FOOTER
%
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
