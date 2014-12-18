% EUL_ONF_2_EUL_I Converts orientation w.r.t satellite coordinate system to orientation w.r.t inertial frame 
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% eul_onf_2_eul_i:
%     Converts orientation w.r.t satellite coordinate system to 
%     orientation w.r.t inertial frame 
% 
% SYNTAX:
%	[Euler_i] = eul_onf_2_eul_i(P_i, V_i , Euler_onf)
%
% INPUTS: 
%	Name		Size                Units           Description
%   P_i         [3xN]or[Nx3]        [length]        Position in Central Body Inertial Frame
%   V_i         [3xN]or[Nx3]        [length/time]   Velocity in Central Body Inertial Frame
%	Euler_onf   [3xN]or[Nx3]        [rad]           Body orientation w.r.t.
%                                                   onf Frame
% OUTPUTS: 
%	Name		Size                Units           Description
%    Euler_i    [3xN]or[Nx3]        [rad]           Body orientation w.r.t
%                                                   Inertial Frame
% NOTES:
%   Satellite Coordinate System (onf)
%   Right handed system moves with the satellite and is sometimes called
%   the Gaussian Coordinate System
% 
%   R Axis -    Always points from center of central body to vehicle;
%               Positive out (-NADIR)
%   S Axis -    In Orbital plane, points towards velocity vector (if orbit
%               is circular, S Axis is parallel to velocity vector)
%   W Axis -    Cross-track axis; Completes coordiante system (R x S)
%
%  This function is NOT unit specific.  However, input position and 
%  velocity vectors must carry same distance unit.
%  This functions also uses the eul2dcm and dcm2eul functions.
%
% EXAMPLES:
%	Example 1:A satellite position is [100 100 100] in the central body
%	inertial frame. The velocity is [100 0 100]. The body orientation is
%	[pi/4 pi/4 pi/2] radians in the satellite coordinate frame.
%   Find the body orientation in the inertial coordinate
%	system (Row Vector).
%   P_i=[100 100 100]; V_i=[100 0 100]; Euler_onf=[pi/4 pi/4 pi/2]; 
% 	[Euler_i] = eul_onf_2_eul_i(P_i, V_i , Euler_onf)
%	Returns Euler_i =[  0.1535   -0.2129    2.5097 ]
%
%	Example 2:A satellite position is [-300; 200; 100] in the central body
%	inertial frame. The velocity is [100; 50; 500]. The body orientation is
%	[pi/6 pi/8 pi/2] in ONF coordinates radians. Find the body orientation
%   in the inertial coordinate system (Column Vector).
%   P_i=[-300; 200; 100]; V_i=[100; 50; 500]; Euler_onf=[pi/6 pi/8 pi/2]; 
% 	[Euler_i] = eul_onf_2_eul_i(P_i, V_i , Euler_onf)
%	Returns Euler_i = [ 0.4628    0.5681   -2.3368 ]
%
% SOURCE DOCUMENTATION:
%	[1] Vallado, David A.  Fundamentals of Astrodynamics and Applications.  New
%   York: McGraw-Hill Companies, Inc., 1997.  Pages 43-51.  Equation 1-26.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit eul_onf_2_eul_i.m">eul_onf_2_eul_i.m</a>
%	  Driver script: <a href="matlab:edit Driver_eul_onf_2_eul_i.m">Driver_eul_onf_2_eul_i.m</a>
%	  Documentation: <a href="matlab:pptOpen('eul_onf_2_eul_i_Function_Documentation.pptx');">eul_onf_2_eul_i_Function_Documentation.pptx</a>
%
% See also eul_i_2_eul_onf 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/567
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/eul_onf_2_eul_i.m $
% $Rev: 3031 $
% $Date: 2013-10-16 17:12:13 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [Euler_i] = eul_onf_2_eul_i(P_i, V_i , Euler_onf)

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

%% Input Check
if ischar(V_i)||ischar(P_i)
    error([mfnam ':InputArgCheck'], ['Inputs must be numeric!  See ' mlink ' documentation for help.']);
end

if (size(P_i, 1) ~= 3)&&(size(P_i, 2) ~= 3)
    error([mfnam ':InputArgCheck'], ['Inputs must be of same length! See ' mlink ' documentation for help.']);
end
if (size(V_i, 1) ~= 3)&&(size(V_i, 2) ~= 3)
    error([mfnam ':InputArgCheck'], ['Inputs must be of same length! See ' mlink ' documentation for help.']);
end

%% Main Function:
%% Compute Satellite Coordiante System Parameters:
Rhat = unitv( P_i );                % [ND]  Normalized Position Vector
Hvec = cross( P_i, V_i );
What = unitv(Hvec);                 % [ND]  Cross-track Position Vector
Shat = unitv(cross( What, Rhat ));         % [ND]  In Orbit Velocity Vector

%% DCM from Satellite Coordinate System (onf) to Inertial Frame (i):
i_C_onf = zeros(3,3);
i_C_onf(:,1) = Rhat;
i_C_onf(:,2) = -What;
i_C_onf(:,3) = Shat;

%% DCM from Inertial Frame to ONF satellite coordinates
onf_C_i=i_C_onf';

%% DCM from onf Horizontal Frame to Body:
b_C_onf = eul2dcm( Euler_onf );

%% DCM from Inertial to Body Frame:
b_C_i = b_C_onf * onf_C_i;

%% Compute Inertial Euler Orientation:
Euler_i = dcm2eul( b_C_i );

% If input is a row vector, return a row vector:
if(size(Euler_onf, 2) == 3)
    Euler_i = Euler_i';
end

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100920 JJ:  Generated 2 examples.Added input checks
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/eul_onf_2_eul_i.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN Username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : G67086
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
