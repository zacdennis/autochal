% ECEF2ECI   Converts Central Body Fixed coordinates into Central Body Inertial 
%  Coordinates (ie ecef to eci, lclf to lci)
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ecef2eci:
%       Converts Central Body Fixed Coordiantes into Central Body Inertial 
%       Coordinates (ie ecef to eci, lclf to lci)
%
% SYNTAX:
%	[P_i,i_C_f] = ecef2eci(P_f,mst)
%
% INPUTS: 
%	Name		Size		      Units          Description
%	P_f 		[3x1] or [1x3]    [Variable]     Position in Central Body Fixed
%                                                Frame
%	mst 		[1x1]             [degrees]	     Mean Sidereal Time
%										            Default: mst=0
%
% OUTPUTS: 
%	Name		Size		      Units          Description
%	P_i 		[3x1] or [1x3]	  [Variable]     Position in Central Body Inertial
%                                                Frame
%	i_C_f		[3x3]		      [ND]           Inertial Central Frame
%
% NOTES:
%	This function works on positions, velocity, and accelerations (length,
%   length/time, or length/time^2).  It does NOT work for Euler angles.  
%   Direction cosine matrices must be multiplied together for such 
%   orientations to be computed. The central body fixed frame origin is the 
%   center of gravity.
%
%   mst can be input as any real value, but it will be wrapped to represent
%   a number between 0 and 360 deg by Matlab's cosd and sind functions
%
% EXAMPLES:
%	Example 1: Transform the position of an aircraft given in central body
%	fixed coordinates to central body inertial coordinates
%	[P_i,i_C_f] = ecef2eci([0 60000 0],90)
%	Returns P_i = [ -60000 0  0]; i_C_f= [0 -1 0; 1 0 0; 0 0 1]
%
%	Example 2: Transform the position of an aircraft given in central body
%   fixed coordinates to central body inertial coordinates
%	[P_i,i_C_f] = ecef2eci([10000 0 0], 270)
%	Returns P_i = [ 0 -10000  0]; i_C_f= [0 1 0; -1 0 0; 0 0 1]
%
% SOURCE DOCUMENTATION:
% 	[1]    Yechout, Thomas R. Introduction to Aircraft Flight Mechanics.
%          AIAA Educational Series, Reston, VA, Copyright 2003 P.39
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ecef2eci.m">ecef2eci.m</a>
%	  Driver script: <a href="matlab:edit Driver_ecef2eci.m">Driver_ecef2eci.m</a>
%	  Documentation: <a href="matlab:pptOpen('ecef2eci_Function_Documentation.pptx');">ecef2eci_Function_Documentation.pptx</a>
%
% See also eci2ecef
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/323
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/ecef2eci.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [P_i,i_C_f] = ecef2eci(P_f,mst)

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
%% Input Check

if ischar(mst)||ischar(P_f)
    error([mfnam ':InputArgCheck'], ['Inputs must be numeric!  See ' mlink ' documentation for help.']);
end

if (length(P_f)~=3)||(length(mst)>1)
    error([mfnam ':InputArgCheck'], ['P_f must be of lenght 3, mst must be of length 1!  See ' mlink ' documentation for help.']);
end

%% Main Function:
mst = mst * pi/180;
    
f_C_i = [   cos(mst) sin(mst) 0;
           -sin(mst) cos(mst) 0;
            0        0        1];

i_C_f = f_C_i';

if(size(P_f, 1) == size(mst,1))
    P_i = (i_C_f * P_f')';
else
    P_i = i_C_f * P_f;
end

%% REVISION HISTORY
% YYMMDD INI: note
% 100915 PBH: Updated header (units, Driver script link). Added use of mlink in error message.
% 100907 JJ:  Filled the documentation source.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDI
%             NATE_TRANSFORMATIONS/ecef2eci.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN Username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : g67086
% MWS: Mike Sufana      : mike.sufana@ngc.com               : sufanmi
% PBH: patrick Healy    : patrick.healy@ngc.com             : healypa

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
