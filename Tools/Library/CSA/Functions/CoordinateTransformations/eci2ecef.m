% ECI2ECEF   Converts Central Body Inertial Coordinates into Central Body Fixed
%  Coordinates (ie eci to ecef, lci to lclf)
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% eci2ecef:
%   Converts Central Body Inertial Coordinates into Central Body Fixed
%   Coordinates (ie eci to ecef, lci to lclf)
%
% SYNTAX:
%	[P_f,f_C_i] = eci2ecef(P_i,mst)
%
% INPUTS: 
%	Name		Size                Units            Description
%	P_i 		[3x1] or [1x3]      [Variable]       Vector in Central Body Inertial
%                                                    Frame
%	mst 		[1x1]               [deg]            Mean Sidereal Time
%                                                        Default: mst = 0
%
% OUTPUTS: 
%	Name         Size               Units            Description
%   P_f          [3xN] or [Nx3]     [Variable]       Vector in Central Body Fixed Frame
%   f_C_i        [3x3]              [ND]             DCM from Central Body Inertial Frame 
%                                                    to Central Body Inertial Frame
%
% NOTES:
% 	This function works on positions, velocity, and accelerations (length,
%   length/time, or length/time^2).  It does NOT work for Euler angles.  
%   Direction cosine matrices must be multiplied together for such 
%   orientations to be computed. The central body fixed frame origin is the 
%   center of gravity
% 
%   mst can be input as any real value, but it will be wrapped to represent
%   a number between 0 and 360 deg by Matlab's cosd and sind functions
%
% EXAMPLES:
%	Example 1 : convert central body inertial where P_i is a 3x1, into body fixed coordinates 
%   P_i=[1000000 0 0]'; mst=90;
% 	[P_f,f_C_i] = eci2ecef(P_i,mst)
%	Returns P_f=[ 0 -1000000 0] f_C_i=[ 0 1 0; -1 0 0; 0 0 1];
%
%	Example 2:convert central body inertial where P_i is a 1x3, into body
%	fixed coordinates
%   P_i=[2000000 0 0]; mst=45;
% 	[P_f,f_C_i] = eci2ecef(P_i,mst)
%	Returns P_f=1.0e+006*[ 1.4142 -1.4142 0] f_C_i=[ 0.7071 0.7071 0; -0.7071 0.7071 0; 0 0 1 ];
%
% SOURCE DOCUMENTATION:
%	[1]    Yechout, Thomas R. Introduction to Aircraft Flight Mechanics.
%          AIAA Educational Series, Reston, VA, Copyright 2003 P.39
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit eci2ecef.m">eci2ecef.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_eci2ecef.m">DRIVER_eci2ecef.m</a>
%	  Documentation: <a href="matlab:pptOpen('eci2ecef_Function_Documentation.pptx');">eci2ecef_Function_Documentation.pptx</a>
%
% See also ecef2eci
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/325
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/eci2ecef.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [P_f,f_C_i] = eci2ecef(P_i,mst)

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

if ischar(mst)||ischar(P_i)
     error([mfnam ':InputArgCheck'], 'Input of type string or CHAR. Must be expressed in scalar form.')
end

if (length(P_i)~=3)||(length(mst)>1)
    error([mfnam ':InputArgCheck'], ['P_f must be of lenght 3, mst must be of length 1!  See ' mlink ' documentation for help.']);
end

%% Main Function:

for i=1:length(mst);
    % DCM from Inertial Frame to Fixed Frame:
    f_C_i  = [   cosd(mst)   sind(mst)   0;
                -sind(mst)   cosd(mst)   0;
                 0           0           1];
    
    % Compute Component in Fixed Frame:
    if size(P_i, 1) == size(mst,1)
        P_f = (f_C_i * P_i')';
    else
        P_f = f_C_i * P_i;
    end
    
end

%% REVISION HISTORY
% YYMMDD INI: note
% 100907 JJ:  Filled the documentation source.
% 100819 JJ:  Function template created using CreateNewFunc
% 080114 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDI
%             NATE_TRANSFORMATIONS/eci2ecef.m
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
