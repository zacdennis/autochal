% VCAL2MACH Converts calibrated airspeed to true airspeed at alt
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% vcal2mach:
%     convert calibrated airspeed to true airspeed at alt
%     not valid for speeds in excess of Mach 1
% 
% SYNTAX:
%	[Mach] = vcal2mach(Vcas_kts, Alt, flgUseEnglish, DeltaTemp)
%	[Mach] = vcal2mach(Vcas_kts, Alt, flgUseEnglish)
%	[Mach] = vcal2mach(Vcas_kts, Alt)
%	[Mach] = vcal2mach(Vcas_kts)
%
% INPUTS: 
%	Name            Size		Units           Description
%	Vcas_kts        [1]         [knots]         Calibrated airspeed
%   Alt             [1]         [m] or [ft]     Altitude
%                                                Default: 0
%   flgUseEnglish   [1]         [bool]          Assume Alt and DeltaTemp
%                                                are in English units?
%                                                Default: 1 (true)
%   DeltaTemp       [1]     [deg K] or [deg R]  Temperature Change from
%                                                Standard
%                                                Default: 0
%
% OUTPUTS: 
%	Name            Size		Units           Description
%   Mach            [1]         [ND]            Mach Number
%
% NOTES:
%
% EXAMPLES:
%	% Example 1
%   Alt_ft = 10000;
%   Mach = 0.2;
%	Vcas_kts = mach2vcal(Mach, Alt_ft)
%
%	Mach2 = vcal2mach(Vcas_kts, Alt_ft)
%   DeltaMach = Mach2 - Mach
%
% SOURCE DOCUMENTATION:
%  	[1]   Nelson, Robert C., Flight Stability and Automatic Control, 
%         The McGraw-Hill Companies, Inc., Boston, MA, 1998, pg 24
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit vcal2mach.m">vcal2mach.m</a>
%	  Driver script: <a href="matlab:edit Driver_vcal2mach.m">Driver_vcal2mach.m</a>
%	  Documentation: <a href="matlab:winopen(which('vcal2mach_Function_Documentation.pptx'));">vcal2mach_Function_Documentation.pptx</a>
%
% See also mach2vcal, Coesa1976 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/115
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/FlightParameters/vcal2mach.m $
% $Rev: 3216 $
% $Date: 2014-07-23 12:51:58 -0500 (Wed, 23 Jul 2014) $
% $Author: sufanmi $

function [Mach] = vcal2mach(Vcas_kts, Alt, flgUseEnglish, DeltaTemp)


%% Input checks
switch(nargin)
    case 1
        DeltaTemp = 0; flgUseEnglish = ''; Alt = 0;
    case 2
        DeltaTemp = 0; flgUseEnglish = '';
    case 3
        DeltaTemp = 0;
    case 4
        % Nominal
end

if(isempty(flgUseEnglish))
    flgUseEnglish = 1;  % Assume ENGLISH units on input
end

%% Main Function:
conversions;

if(flgUseEnglish)
    % Inputs are in ENGLISH
    Alt_ft          = Alt;                              % [ft]
    DeltaTemp_degR  = DeltaTemp;                        % [deg R]
else
    % Inputs are in METRIC
    Alt_ft          = Alt * C.M2FT;                     % [ft]
    DeltaTemp_degR  = DeltaTemp * C.K2R;                % [deg R]
end

% Get atmospheric values at altitude using ENGLISH units
Atmos_at_Alt    = Coesa1976( Alt_ft, 1, DeltaTemp_degR );

% Standard COESA @ Sea Level
P0_psf          = 101325 * C.PA2PSF;                    % [lb/ft^2]
Sound0_fps      = 340.294107786935 * C.M2FT;            % [ft/sec]

%%
Vcas_fps        = Vcas_kts * C.KTS_2_FPS;                       % [ft/sec]
ratSound        = Vcas_fps / Sound0_fps;                        % [unitless]
ratQc           = ((1 + 0.2*(ratSound*ratSound))^(7/2)) - 1;    % [unitless]
Qc              = ratQc * P0_psf;                               % [lb/ft^2]
p0              = Qc + Atmos_at_Alt.Pressure;                   % [lb/ft^2]
p0p1            = p0 / Atmos_at_Alt.Pressure;                   % [unitless]
Mach            = sqrt(5*((p0p1^(2/7))-1));                     % [unitless]

end % << End of function vcal2mach >>

%% AUTHOR IDENTIFICATION
% INI: FullName     :  Email                : NGGN Username
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
