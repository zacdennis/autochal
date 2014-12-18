% ORBIT2LATLON Computes the Lat/Lon Points for a Racetrack Orbit
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Orbit2LatLon:
%     Computes the latitude/longitude points for a racetrack orbit.  A
%     standard racetrack orbit is defined based on a 
% 
% SYNTAX:
%	[arrLat_deg, arrLon_deg, arrTime_sec] = Orbit2LatLon(LatStart_deg, LonStart_deg, HeadingRef_deg, Vtas, varargin, 'PropertyName', PropertyValue)
%	[arrLat_deg, arrLon_deg, arrTime_sec] = Orbit2LatLon(LatStart_deg, LonStart_deg, HeadingRef_deg, Vtas, varargin)
%	[arrLat_deg, arrLon_deg, arrTime_sec] = Orbit2LatLon(LatStart_deg, LonStart_deg, HeadingRef_deg, Vtas)
%
% INPUTS: 
%	Name            Size    Units           Description
%	LatStart_deg	[1]     [deg]           Reference latitude for orbit
%	LonStart_deg	[1]     [deg]           Reference longitude for orbit
%   HeadingRef_deg  [1]     [deg]           Reference heading for front leg
%   Vtas            [1]     [ft/sec]        True Airspeed for orbit
%                            or [m/sec]
%	varargin        [N/A]	[varies]        Optional function inputs that
%                                            should be entered in pairs.
%                                            See the 'VARARGIN' section
%                                            below for more details
%
% OUTPUTS: 
%	Name            Size		Units		Description
%	arrLat_deg      [1 x n]     [deg]       Latitude points of orbit
%	arrLon_deg      [1 x n]     [deg]       Longitude points of orbit
%   arrTime_sec     [1 x n]     [sec]       Time
%
% NOTES:
%   The units on Vtas must match the units in 'CentralBody' (varargin
%   input).  If 'CentralBody' is in standard english units (e.g.
%   CentralBodyEarth_init(0)), Vtas will be in [ft/sec].  If 'CentralBody'
%   is in standard metric units (e.g. CentralBodyEarth_init(1)), Vtas will
%   be in [m/sec].
%
%	VARARGIN PROPERTIES:
%	PropertyName    PropertyValue	Default     Description
%	'CentralBody'      struct       CentralBodyEarth_init(0)
%                                               Information on the central
%                                               body (e.g. Earth)
%   'LegTime_sec'      [sec]        2 min       Length of time to spend on
%                                               each leg (downleg/backleg)
%   'LeftOrbit'        'bool'       true        1/true: Left turn orbit
%                                               0/false: Right turn orbit
%   'StartOnDownleg'   'bool'       true        1/true: Starts orbit on the
%                                               front/downleg portion
%                                               0/false: Starts orbit on
%                                               the turn from frontleg to
%                                               backleg
%   'TurnRate_dps'     [deg/sec]    3           Turn rate to use for orbit
%   'dt_sec'           [sec]        0.1         Decimation to use for
%                                                computing orbit path
%   'TimeStart_sec'    [sec]        0           Starting Time
%
% EXAMPLES:
%	% Example 1: Create a simple left orbit starting on the front leg
%   CentralBody = CentralBodyEarth_init(0);     % English units
%   LatStart_deg = 0;       % [deg]
%   LonStart_deg = 0;       % [deg]
%   HeadingRef_deg = 45;    % [deg]
%   Vtas = 100;             % [ft/sec]
%	[arrLat_deg, arrLon_deg] = Orbit2LatLon(LatStart_deg, LonStart_deg, HeadingRef_deg, Vtas, 'CentralBody', CentralBody);
%
%   figure(); plot(arrLon_deg, arrLat_deg, 'b-', 'LineWidth', 1.5);
%   hold on; plot(LonStart_deg, LatStart_deg, 'bo', 'MarkerSize', 12);
%   axis equal; grid on; set(gca, 'FontWeight', 'bold');
%   xlabel('\bfLongitude [deg]'); ylabel('\bfLatitude [deg]');
%   quiver(LonStart_deg, LatStart_deg, cosd(HeadingRef_deg)*.005, sind(HeadingRef_deg)*.005, 'LineWidth', 1.5, 'Color', 'r', 'MaxHeadSize', 5)
%    
%	% Example 2: Create a simple right orbit starting on the turn to from
%	%            the front leg to the backleg
%   CentralBody = CentralBodyEarth_init(0);     % English units
%   LatStart_deg = 0;       % [deg]
%   LonStart_deg = 0;       % [deg]
%   HeadingRef_deg = 45;    % [deg]
%   Vtas = 100;             % [ft/sec]
%	[arrLat_deg, arrLon_deg] = Orbit2LatLon(LatStart_deg, LonStart_deg, HeadingRef_deg, Vtas, ...
%       'CentralBody', CentralBody, 'LeftOrbit', 0, 'StartOnDownleg', 0);
%
%   figure(); plot(arrLon_deg, arrLat_deg, 'b-', 'LineWidth', 1.5);
%   hold on; plot(LonStart_deg, LatStart_deg, 'bo', 'MarkerSize', 12);
%   axis equal; grid on; set(gca, 'FontWeight', 'bold');
%   xlabel('\bfLongitude [deg]'); ylabel('\bfLatitude [deg]');
%   quiver(LonStart_deg, LatStart_deg, cosd(HeadingRef_deg)*.005, sind(HeadingRef_deg)*.005, 'LineWidth', 1.5, 'Color', 'r', 'MaxHeadSize', 5)
%    
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Orbit2LatLon.m">Orbit2LatLon.m</a>
%	  Driver script: <a href="matlab:edit Driver_Orbit2LatLon.m">Driver_Orbit2LatLon.m</a>
%	  Documentation: <a href="matlab:pptOpen('Orbit2LatLon_Function_Documentation.pptx');">Orbit2LatLon_Function_Documentation.pptx</a>
%
% See also invvincenty 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/757
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $
function [arrLat_deg, arrLon_deg, arrTime_sec] = Orbit2LatLon(LatStart_deg, LonStart_deg, HeadingRef_deg, Vtas, varargin)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

% Examples of Different Display Formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfnam '>> ERROR: <define error here> See ' mlink ' help'];      % <-- Couple with error function
% error([mfnam 'class:file:Identifier'], errstr);    % Call error function with error string

%% Initialize Outputs:

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
conversions;

[CentralBody, varargin]     = format_varargin('CentralBody', CentralBodyEarth_init(0), 2, varargin);
[LegTime_sec, varargin]     = format_varargin('LegTime_sec', 2*C.MIN2SEC, 2, varargin);
[LeftOrbit, varargin]       = format_varargin('LeftOrbit', 1, 2, varargin);
[StartOnDownleg, varargin]  = format_varargin('StartOnDownleg', 1, 2, varargin);
[TurnRate_dps, varargin]    = format_varargin('TurnRate_dps', 3, 2, varargin);
[dt_sec, varargin]          = format_varargin('dt_sec', 0.1, 2, varargin);
[TimeStart_sec, varargin]   = format_varargin('TimeStart_sec', 0, 2, varargin);

%% Main Function:
arrLat_deg = [];
arrLon_deg = [];
arrTime_sec = [];
iLL = 0;
iLL = iLL + 1;
arrLat_deg(iLL) = LatStart_deg;
arrLon_deg(iLL) = LonStart_deg;
arrTime_sec(iLL)= TimeStart_sec;

if(LeftOrbit)
    TurnRate_dps = TurnRate_dps * -1;
end

if(StartOnDownleg)
    % Frontleg
    [arrLat_deg, arrLon_deg, arrTime_sec] = AddLegSegment(arrLat_deg(end), arrLon_deg(end), HeadingRef_deg, Vtas, LegTime_sec, ...
        CentralBody, arrLat_deg, arrLon_deg, arrTime_sec);

    % Turn to Backleg
    [arrLat_deg, arrLon_deg, arrTime_sec] = AddTurnLeg(arrLat_deg(end), arrLon_deg(end), HeadingRef_deg, TurnRate_dps, ...
        Vtas, CentralBody, arrLat_deg, arrLon_deg, arrTime_sec, dt_sec);
    
    % Backleg
    [arrLat_deg, arrLon_deg, arrTime_sec] = AddLegSegment(arrLat_deg(end), arrLon_deg(end), HeadingRef_deg+180, Vtas, LegTime_sec, ...
        CentralBody, arrLat_deg, arrLon_deg, arrTime_sec);
    
    % Turn to Frontleg
    [arrLat_deg, arrLon_deg, arrTime_sec] = AddTurnLeg(arrLat_deg(end), arrLon_deg(end), HeadingRef_deg+180, TurnRate_dps, ...
        Vtas, CentralBody, arrLat_deg, arrLon_deg, arrTime_sec, dt_sec);

else    
    % Turn to Backleg
    [arrLat_deg, arrLon_deg, arrTime_sec] = AddTurnLeg(arrLat_deg(end), arrLon_deg(end), HeadingRef_deg, TurnRate_dps, ...
        Vtas, CentralBody, arrLat_deg, arrLon_deg, arrTime_sec, dt_sec);
    
    % Backleg
    [arrLat_deg, arrLon_deg, arrTime_sec] = AddLegSegment(arrLat_deg(end), arrLon_deg(end), HeadingRef_deg+180, Vtas, LegTime_sec, ...
        CentralBody, arrLat_deg, arrLon_deg, arrTime_sec);
    
    % Turn to Frontleg
    [arrLat_deg, arrLon_deg, arrTime_sec] = AddTurnLeg(arrLat_deg(end), arrLon_deg(end), HeadingRef_deg+180, TurnRate_dps, ...
        Vtas, CentralBody, arrLat_deg, arrLon_deg, arrTime_sec, dt_sec);

    % Frontleg
    [arrLat_deg, arrLon_deg, arrTime_sec] = AddLegSegment(arrLat_deg(end), arrLon_deg(end), HeadingRef_deg, Vtas, LegTime_sec, ...
        CentralBody, arrLat_deg, arrLon_deg, arrTime_sec);

end

end

%%
function [arrLat_deg, arrLon_deg, arrTime_sec] = AddTurnLeg(LatStart_deg, LonStart_deg, ...
    HeadingRef_deg, TurnRate_dps, Vtas, CentralBody, arrLat_deg, arrLon_deg, arrTime_sec, dt_sec)

TurnTime = 180.0 / abs(TurnRate_dps);
arrTime = [0:dt_sec:TurnTime];
Dist = Vtas * dt_sec;
iLL = length(arrLat_deg);

Lat2_deg = LatStart_deg;
Lon2_deg = LonStart_deg;

CurrHeading_deg = HeadingRef_deg;
for iTime = 2:length(arrTime)
    Lat_deg = Lat2_deg;
    Lon_deg = Lon2_deg;
    
    CurrHeading_deg = CurrHeading_deg + (TurnRate_dps * dt_sec);
    
    [Lat2_deg, Lon2_deg] = invvincenty(Lat_deg, Lon_deg, CurrHeading_deg, Dist, ...
        CentralBody.a, CentralBody.flatten);
    
    iLL = iLL + 1;
    arrLat_deg(iLL) = Lat2_deg;
    arrLon_deg(iLL) = Lon2_deg;
    arrTime_sec(iLL)= arrTime_sec(iLL-1) + dt_sec;
end
end

%%
function [arrLat_deg, arrLon_deg, arrTime_sec] = AddLegSegment(LatStart_deg, LonStart_deg, ...
    HeadingRef_deg, Vtas, LegTime_sec, CentralBody, arrLat_deg, arrLon_deg, arrTime_sec)

    LegDist = Vtas * LegTime_sec;
    [Lat2_deg, Lon2_deg] = invvincenty(LatStart_deg, LonStart_deg, HeadingRef_deg, LegDist, ...
        CentralBody.a, CentralBody.flatten);
    iLL = length(arrLat_deg) + 1;
    arrLat_deg(iLL)     = Lat2_deg;
    arrLon_deg(iLL)     = Lon2_deg;
    arrTime_sec(iLL)    = arrTime_sec(iLL-1) + LegTime_sec;
end

%% REVISION HISTORY
% YYMMDD INI: note
% 120725 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         : Email                 : NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi

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
