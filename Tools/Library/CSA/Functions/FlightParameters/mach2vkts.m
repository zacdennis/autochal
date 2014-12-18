% MACH2VKTS Converts Mach Number to True Airspeed
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% mach2vkts:
%   Converts Mach Number to True Airspeed based on Altitude.  
%   Atmosphere can be Stanard or Non-Standard.
%
% SYNTAX:
%	[Vkts] = mach2vkts(Mach, Alt, flgUnits, DeltaTemp)
%	[Vkts] = mach2vkts(Mach, Alt, flgUnits)
%	[Vkts] = mach2vkts(Mach, Alt)
%	[Vkts] = mach2vkts(Mach)
%
% INPUTS:
%	Name		Size		Units           Description
%	Mach		[variable]  [ND]            Mach number
%	Alt 		[variable]	[m] or [ft]     Altitude
%                                            Default: 0 (Sea level)
%   flgUnits    [1]         [ND]            Unit selection where
%                                            0 = Metric, 1 = English 
%                                            Default: 1 (English)
%   DeltaTemp   [variable]  [Kelvin] or     Temperature Change from Standard
%                               [Rankine]    Default: 0
%
% OUTPUTS:
%	Name		Size		Units           Description
%	Vkts		[variable]	[knots]         True velocity in knots (vtas)
%
% NOTES:
%   This function allows the inputted Mach, Altitude, and DeltaTemp to be 
%   either singular (e.g. [1]), a vector ([1xN] or [Nx1]), or a multi-
%   dimentional matrix (M x N x P x ...].  Velocity will carry the same
%   dimensions as the inputs.
%
%   This function works on either English or Metric units.  Underlying
%   atmosphere model is the Standard 1976 COESA Atmopshere model with plugs
%   inserted for Non-Standard Temperature conditions.
%
%   The Coesa1976 function is only valid for input altitudes between 
%   -0.5 km and +1000 km (~ -1,640 ft to +3,280,840 ft), therefore this
%   function is only valid for inputs with altitudes within that range
%
% EXAMPLES:
%	Example 1: Find the velocity in knots from an airplane going mach 0.85
%	and flying 30,000 ft, using Standard Atmosphere conditions
%   [vkts]=mach2vkts(0.85, 30000)
%   Returns [vkts]= 501.0172
%
% SOURCE DOCUMENTATION:
%	[1]    Yechout, Thomas R. Introduction to Aircraft Flight Mechanics.
%          AIAA Educational Series, Reston, VA, Copyright 2003 P.82
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit mach2vkts.m">mach2vkts.m</a>
%	  Driver script: <a href="matlab:edit Driver_mach2vkts.m">Driver_mach2vkts.m</a>
%	  Documentation: <a href="matlab:pptOpen('mach2vkts_Function_Documentation.pptx');">mach2vkts_function_Documentation.pptx</a>
%
% See also vkts2mach, Coesa1976
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/348
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) 
% Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/FlightParameters/mach2vkts.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Vkts] = mach2vkts(Mach, Alt, flgUnits, DeltaTemp)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

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

if length(Mach)~=length(Alt)
     error([mfnam ':InputArgCheck'], ['Inputs must be of same length! See ' mlink ' documentation for help.']);
end
    
if ischar(Mach)||ischar(Alt)||ischar(DeltaTemp)
     error([mfnam ':InputArgCheck'], 'Input of type string or CHAR. Velocity must be expressed in scalar form.')
end
%% Main Function:
conversions;

if(flgUnits)
    % English Units
    structCoesa = Coesa1976( Alt, 1, DeltaTemp );
    Vkts = Mach .* (structCoesa.Sound) .* C.FPS_2_KTS;    % [knots]
else
    structCoesa = Coesa1976( Alt, 0, DeltaTemp );
    Vkts = Mach .* (structCoesa.Sound) .* C.MPS_2_KTS;
end

end

%% REVISION HISTORY
% YYMMDD INI: note
% 101004 JJ:  Added example using non-standard. Added input checks.
% 100904 MWS: Added in Non-Standard Atmosphere Component (DeltaT)
% 100831 JJ:  Filled the documentation source. Added units selection
%             capability. Added input checks.
% 100819 JJ:  Function template created using CreateNewFunc
% 080114 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDI
%             NATE_TRANSFORMATIONS/mach2vkts.m
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
