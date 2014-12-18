% VTAS2VIAS Converts true airspeed to indicated airspeed
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% vtas2vias:
%     Converts true airspeed to indicated airspeed based on altitude and
%     the COESA 1976 atmosphere model.
%
% SYNTAX:
%	[vias] = vtas2vias(vtas, Alt, flgUnits, DeltaTemp)
%	[vias] = vtas2vias(vtas, Alt, flgUnits)
%	[vias] = vtas2vias(vtas, Alt)
%   [vias] = vtas2vias(vtas)
%
% INPUTS:
%	Name		Size		Units           Description
%	vtas		[variable]  [variable]		True airspeed
%   Alt 		[variable]  [ft] or [m]		Altitude
%                                             Default: 0 (Sea level)
%   flgUnits    [1]         [ND]            Unit selection 1 = English 
%                                                          0 = Metric
%                                             Default: 1 (English)
%   DeltaTemp   [variable]  [Kelvin] or     Temperature Change
%                              [Rankine]     from Standard
%                                            Default: 0
% OUTPUTS:
%	Name		Size		Units           Description
%	vias        [variable]  [variable]		Indicated Airspeed
%
%NOTES:
%   This function allows the inputted Airspeed, Altitude, and DeltaTemp 
%   to be either singular (e.g. [1]), a vector ([1xN] or [Nx1]), or a 
%   multi-dimentional matrix (M x N x P x ...].  Outputted Velocity will 
%   carry the same dimensions as the inputs.
%
%   For best results, ensure that the inputs all carry the same dimensions.
%   The easiest usage would be to enter 'vtas' and 'Alt' as either a scalar
%   or vector, and 'DeltaTemp' as a single scalar.
%
%   This function ultimately uses the COESA 1976 to compute the ratio
%   between atmospheric density (at altitude) with the density at Sea Level
%   to compute the true airspeed.  The units on the true airspeed are
%   irrelevant, but it should be understood that the outputted indicated
%   airspeed with carry the same velocity units as the input.
%
%   The Coesa1976 function is only valid for input altitudes between 
%   -0.5 km and +1000 km (~ -1,640 ft to +3,280,840 ft), therefore this
%   function is only valid for inputs with altitudes within that range
%
% EQUATION USED:    __________
%                  | Rho      |
%                  |    Alt
%  V    = V    *   | --------
%   IAS    TAS     |  Rho
%                 \|     S.L.
% EXAMPLES:
%	Example 1: Find the indicated airspeed of a plane flying at 9,000 feet alt
%	with a true airspeed of 140 ft/s (default). Single input
%   vtas=140; Alt=9000;
%	[vias] = vtas2vias(140,9000)
%	Returns 122.2140 
%
% SOURCE DOCUMENTATION:
%
%	[1]    Yechout, Thomas R. Introduccion to Aircraft Flight Mechanics.
%          AIAA Educational Series, Reston, VA, Copyright 2003 P.84
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit vtas2vias.m">vtas2vias.m</a>
%	  Driver script: <a href="matlab:edit Driver_vtas2vias.m">Driver_vtas2vias.m</a>
%	  Documentation: <a href="matlab:pptOpen('vtas2vias_Function_Documentation.pptx');">vtas2vias_Function_Documentation.pptx</a>
%
% See also vias2vtas
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/368
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21)
% Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/FlightParameters/vtas2vias.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [vias] = vtas2vias(vtas, Alt, flgUnits, DeltaTemp)

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

%% Input check
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

if length(vtas)~=length(Alt)
     error([mfnam ':InputArgCheck'], ['Inputs must be of same length! See ' mlink ' documentation for help.']);
end
    
if ischar(vtas)||ischar(Alt)||ischar(DeltaTemp)
     error([mfnam ':InputArgCheck'], 'Input of type string or CHAR. Velocity must be expressed in scalar form.')
end

%% Main Function:
Atmos = Coesa1976(Alt, flgUnits, DeltaTemp );
vias  = vtas .* sqrt(Atmos.RhoRho0);

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 101004 JJ: Added example that includes array inputs and diferent units. 
% 100830 JJ:  Filled the documentation source. Added units selection
%             capability. Added input checks.
% 100819 JJ:  Function template created using CreateNewFunc
% 100222 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDI
%             NATE_TRANSFORMATIONS/vtas2vias.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN Username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : g67086
% MWS: Mike Sufana      : mike.sufana@ngc.com               : sufanmi
% PBH: Patrick Healy    : patrick.healy@ngc.com             : healypa

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
