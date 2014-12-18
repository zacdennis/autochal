% MACH2VCAL Computes Calibrated Airspeed from Mach Number
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% mach2vcal:
%     Computes Calibrated Airspeed from Mach Number.  Only value when Mach
%     is < 1.
% 
% SYNTAX:
%	[Vcas_kts] = mach2vcal(Mach, Alt, flgUseEnglish, DeltaTemp)
%	[Vcas_kts] = mach2vcal(Mach, Alt, flgUseEnglish)
%	[Vcas_kts] = mach2vcal(Mach, Alt)
%	[Vcas_kts] = mach2vcal(Mach)
%
% INPUTS: 
%	Name            Size		Units           Description
%   Mach            [1]         [ND]            Mach Number
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
%	Vcas_kts        [1]         [knots]         Calibrated airspeed
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
%	Source function: <a href="matlab:edit mach2vcal.m">mach2vcal.m</a>
%	  Driver script: <a href="matlab:edit Driver_mach2vcal.m">Driver_mach2vcal.m</a>
%	  Documentation: <a href="matlab:winopen(which('mach2vcal_Function_Documentation.pptx'));">mach2vcal_Function_Documentation.pptx</a>
%
% See also vcal2mach, Coesa1976 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/416
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/FlightParameters/mach2vcal.m $
% $Rev: 3216 $
% $Date: 2014-07-23 12:51:58 -0500 (Wed, 23 Jul 2014) $
% $Author: sufanmi $

function [Vcas_kts] = mach2vcal(Mach, Alt, flgUseEnglish, DeltaTemp)

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
p0p1            = (1 + 0.2*(Mach*Mach))^(7/2);          % [unitless]
p0              = p0p1 * Atmos_at_Alt.Pressure;         % [lb/ft^2]
Qc              = p0 - Atmos_at_Alt.Pressure;           % [lb/ft^2]
ratQc           = Qc / P0_psf;                          % [unitless]
ratSound        = sqrt(5*(((1 + ratQc)^(2/7)) - 1));    % [unitless]
Vcas_fps        = ratSound * Sound0_fps;                % [ft/sec]
Vcas_kts        = Vcas_fps * C.FPS_2_KTS;               % [kts]

end % << End of function mach2vcal >>

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
