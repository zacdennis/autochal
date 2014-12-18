% COESA1976_PRESSUREALTITUDE Computed Pressure Altitude from Pressure using 1976 Standard Atmosphere Model
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Coesa1976_PressureAltitude:
%     The function computes the standard pressure altitude for a given
%     pressure using hte 1976 U.S. Standard Atmosphere Model.  This
%     function is only valid for the lower altitude region (-5 km to 86 km
%     / -16,404 ft to 282,152 ft).
% 
% SYNTAX:
%	[PressureAlt] = Coesa1976_PressureAltitude(Pressure, flgEnglish)
%	[PressureAlt] = Coesa1976_PressureAltitude(Pressure)
%
% INPUTS: 
%	Name       	Size		Units           Description
%	Pressure	[n]         [Pa] or [psf]   Atmospheric pressure
%	flgEnglish	[1]         [bool]          Input/Output Units 
%                                            0: Assumes METRIC units
%                                            1: Assumes ENGLISH units
%                                            Default: 1 (English)
%
% OUTPUTS: 
%	Name       	Size		Units           Description
%	PressureAlt	[n]         [m] or [ft]     Pressure Altitude (MSL)
%
% NOTES:
%	This function uses 'REF_Coesa1976.mat' which was build with
%	'Build_REF_Coesa1976.m'.  All data is internally calculated in Metric
%	units and then converted into English units if desired.
%
%   Standard Pressure at Sea Level: 101325 Pa (2116.22 lb/ft^2)
%
% EXAMPLES:
%	% Compute the pressure altitude for the full lower altitude region.
%   conversions;
%   arrAlt_ft = [-5 : 5 : 80]*C.KM2FT; % [ft]
%   flgEnglish = 1;     % Assume English Units
% 
%   StdAtmos = Coesa1976(arrAlt_ft, flgEnglish);
%   arrPressure_psf = StdAtmos.Pressure;
%   [arrPressureAlt_ft] = Coesa1976_PressureAltitude(arrPressure_psf, flgEnglish);
%   arrDeltaAlt_ft = arrPressureAlt_ft - arrAlt_ft;
% 
%   close all;
%   fighdl(1) = figure();
%   h(1) = plot(arrPressure_psf, arrAlt_ft*C.ONE_2_MILLI, 'b-', 'LineWidth', 1.5); hold on;
%   h(2) = plot(arrPressure_psf, arrAlt_ft*C.ONE_2_MILLI, 'g--', 'LineWidth', 1.5);
%   set(gca, 'FontWeight', 'bold'); grid on;
%   xlabel('\bfPressure [lb/ft^2]'); ylabel('\bfAltitude [kft]');
% 
%   fighdl(2) = figure();
%   plot(arrPressure_psf, arrDeltaAlt_ft*C.ONE_2_MILLI, 'b-', 'LineWidth', 1.5);
%   set(gca, 'FontWeight', 'bold'); grid on;
%   xlabel('\bfPressure [lb/ft^2]'); ylabel('\bfDelta Altitude [kft]');
%
% SOURCE DOCUMENTATION:
%	[1] COESA (Committee on Extension to the Standard Atmosphere), U.S.
%       Standard Atmosphere 1976, U.S. Government Printing Office,
%       Washington, DC, October 1976.
%       Northrop Grumman Library Reference: REF TL 557 A8U58 1976 c.1
%
%	[2] "U.S. Standard Atmopsphere 1976"
%       Online References found through NASA Goddard Space Flight Center
%       Main Description:
%         http://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19770009539_1977009539.pdf
%       Turbo Pascal Source Code
%         <a href="matlab:web http://www.sworld.com.au/steven/space/atmosphere/ -browser">http://www.sworld.com.au/steven/space/atmosphere/</a>
%         Note: This website contains corrections to Reference 1
%   [3] United States Committee on Extension to the Standard Atmosphere, 
%        "U.S. Standard Atmosphere, 1976", National Oceanic and Atmospheric 
%       Administration, National Aeronautics and Space Administration, 
%       United States Air Force, Washington D.C., 1976.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Coesa1976_PressureAltitude.m">Coesa1976_PressureAltitude.m</a>
%	  Driver script: <a href="matlab:edit Driver_Coesa1976_PressureAltitude.m">Driver_Coesa1976_PressureAltitude.m</a>
%	  Documentation: <a href="matlab:winopen(which('Coesa1976_PressureAltitude_Function_Documentation.pptx'));">Coesa1976_PressureAltitude_Function_Documentation.pptx</a>
%
% See also Coesa1976 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/817
%  
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Earth/Coesa1976_PressureAltitude.m $
% $Rev: 3054 $
% $Date: 2013-11-20 11:18:02 -0600 (Wed, 20 Nov 2013) $
% $Author: sufanmi $

function [PressureAlt] = Coesa1976_PressureAltitude(Pressure, flgEnglish)

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

%% Input Argument Conditioning:
if( (nargin == 1) || isempty(flgEnglish) )
    flgEnglish = 1;
 end

%% Main Function:
% Load Structure
load REF_Coesa1976.mat
P0 = 101325;    % [Pa] Standard Pressure at Sea-Level

% Conversions
C.PSF_2_PA  = 47.880258980335832;   % [lb/ft^2] to [Pa]
C.M2FT      = 1/0.3048;             % [m] to [ft]

if(flgEnglish)
    Pressure_Pa = Pressure * C.PSF_2_PA;
else
    Pressure_Pa = Pressure;
end

PP0 = Pressure_Pa/P0;

% Lookup
PressureAlt_m = Interp1D(REF_Coesa1976.arrPP0(8501:-1:1), REF_Coesa1976.arrZ(8501:-1:1), PP0);

if(flgEnglish)
    PressureAlt = PressureAlt_m * C.M2FT;
else
    PressureAlt = PressureAlt_m;
end

end % << End of function Coesa1976_PressureAltitude >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 131028 <INI>: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName            : Email     : NGGN Username 
% <initials>: <Fullname>   : <email>   : <NGGN username> 

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
