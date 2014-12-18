% VKTS2MACH Converts True Airspeed to Mach Number
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% vkts2mach:
%   Converts True Airspeed to Mach Number based on Altitude.
%   Atmosphere can be Stanard or Non-Standard.
% 
% SYNTAX:
%	[Mach] = mach2vkts(Vkts, Alt, flgUnits, DeltaTemp)
%	[Mach] = vkts2mach(Vkts, Alt, flgUnits)
%	[Mach] = vkts2mach(Vkts, Alt)
%   [Mach] = vkts2mach(Vkts)
%
% INPUTS: 
%	Name		Size		Units           Description
%	Vkts		[variable]	[knots]         True velocity in knots (vtas)
%	Alt 		[variable]  [ft] or [m]     Altitude
%                                            Default: 0 (Sea level)
%   flgUnits    [1]         [ND]            Unit selection 1 = English 
%                                                          0 = Metric
%                                            Default: 1 (English)
%   DeltaTemp   [variable]  [Kelvin] or     Temperature Change from Standard
%                               [Rankine]    Default: 0
% OUTPUTS: 
%	Name		Size		Units           Description
%   Mach		[variable]       [ND]            Mach number 
%
% NOTES:
%   This function allows the inputted Velocity, Altitude, and DeltaTemp to 
%   be either singular (e.g. [1]), a vector ([1xN] or [Nx1]), or a multi-
%   dimentional matrix (M x N x P x ...].  Mach will carry the same
%   dimensions as the inputs.
%
%   This function works on either English or Metric units.  Underlying
%   atmosphere model is the Standard 1976 COESA Atmopshere model with plugs
%   inserted for Non-Standard Temperature conditions.
%
% EXAMPLES:
%	Example 1: Calculate the Mach number from an airplane going going 700 knots at
%   30,000 ft (default units)
%   [Mach]=vkts2mach(700,30000)
%   Returns Mach = 1.1876
%
%   Example 2: Calculate the mach number of a spacecraft going 1800 knots
%   and flying in the stratosphere (50 km altitude)
%   [Mach]=vkts2mach(1800,50000,0) 
%   Returns Mach= 2.8078
%
% SOURCE DOCUMENTATION:
%	[1]    Yechout, Thomas R. Introduction to Aircraft Flight Mechanics.
%          AIAA Educational Series, Reston, VA, Copyright 2003 P.82
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit vkts2mach.m">vkts2mach.m</a>
%	  Driver script: <a href="matlab:edit Driver_vkts2mach.m">Driver_vkts2mach.m</a>
%	  Documentation: <a href="matlab:pptOpen('vkts2mach_Function_Documentation.pptx');">vkts2mach_Function_Documentation.pptx</a>
%
% See also mach2vkts 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/366
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/FlightParameters/vkts2mach.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Mach] = vkts2mach(Vkts, Alt, flgUnits, DeltaTemp)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Input checks
switch(nargin)
    case 1
        DeltaTemp = 0; flgUnits = ''; Alt = [];
    case 2
        DeltaTemp = 0; flgUnits = '';
    case 3
        DeltaTemp = 0;
    case 4
        % Nominal
end

if(isempty(flgUnits))
    flgUnits = 1;
end

if isempty(Alt)
    disp([mfnam '>> Alt Not Specified.  Assuming 0 (Sea-Level)']);
    Alt = 0; %Sea level
end

if ischar(Vkts)
    error([mfnam ':InputArgCheck'], 'Input of type string or CHAR. Velocity must be expressed in scalar form.')
end

%% Main Function:
conversions;
if(flgUnits)
    % English Units
    structCoesa = Coesa1976( Alt, 1, DeltaTemp );
    iZero = find(structCoesa.Sound == 0);
    Mach = (Vkts * C.KTS_2_FPS) ./ (structCoesa.Sound);
    Mach(iZero) = 0;
else
    structCoesa = Coesa1976( Alt, 0, DeltaTemp );
    iZero = find(structCoesa.Sound == 0);
    Mach = (Vkts * C.KTS_2_MPS) ./ (structCoesa.Sound);
    Mach(iZero) = 0;
end

end

%% REVISION HISTORY
% YYMMDD INI: note
% 100904 MWS: Added in Non-Standard Atmosphere Component (DeltaT)
% 100831 JJ:  Filled the documentation source. Added units selection
%             capability. Added input checks.
% 100819 JJ:  Function template created using CreateNewFunc
% 080114 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDI
%             NATE_TRANSFORMATIONS/vkts2mach.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN Username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : g67086
% MWS: Mike Sufana      : mike.sufana@ngc.com               : sufanmi

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
