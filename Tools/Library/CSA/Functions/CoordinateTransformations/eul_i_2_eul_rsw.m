% EUL_I_2_EUL_RSW  Converts Orientation w.r.t. Inertial Frame to Orientation w.r.t. Satellite Coordinate System, RSW
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% eul_i_2_eul_rsw:
%       Converts Orientation w.r.t. Inertial Frame to Orientation w.r.t.
%       Satellite Coordinate System, RSW
% 
% SYNTAX:
%	[Euler_rsw, i_C_rsw] = eul_i_2_eul_rsw(P_i, V_i, Euler_i)
%	[Euler_rsw, i_C_rsw] = eul_i_2_eul_rsw(P_i, V_i)
%
% INPUTS: 
%	Name		Size                Units           Description
%	P_i         [3x1]or[1x3]        [length]        Position in Central Body Inertial Frame
%   V_i         [3x1]or[1x3]        [length/time]   Velocity in Central Body Inertial Frame
%   Euler_i     [3x1]or[1x3]        [rad]           Body orientation w.r.t. Inertial Frame 
%
% OUTPUTS: 
%	Name		Size                Units       	Description
%	Euler_rsw   [3x1]or[1x3]        [rad]           Body orientation w.r.t. RSW Frame
%   i_C_rsw     [3x3]               [ND]            DCM from RSW to Inertial Frame
%
% NOTES:
%	Satellite Coordinate System (RSW)
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
%
% EXAMPLES:
%	Example 1:
%	[Euler_rsw, i_C_rsw] = eul_i_2_eul_rsw(P_i, V_i, Euler_i)
%	Returns
%
%	Example 2:
%	[Euler_rsw, i_C_rsw] = eul_i_2_eul_rsw(P_i, V_i, Euler_i)
%	Returns 
%
% SOURCE DOCUMENTATION:
%	[1]   Vallado, David A.  Fundamentals of Astrodynamics and Applications.  New
%   York: McGraw-Hill Companies, Inc., 1997.  Pages 43-51.  Equation 1-26.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit eul_i_2_eul_rsw.m">eul_i_2_eul_rsw.m</a>
%	  Driver script: <a href="matlab:edit Driver_eul_i_2_eul_rsw.m">Driver_eul_i_2_eul_rsw.m</a>
%	  Documentation: <a href="matlab:pptOpen('eul_i_2_eul_rsw_Function_Documentation.pptx');">eul_i_2_eul_rsw_Function_Documentation.pptx</a>
%
% See also eul_rsw_2_eul_i
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/335
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/eul_i_2_eul_rsw.m $
% $Rev: 3031 $
% $Date: 2013-10-16 17:12:13 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [Euler_rsw, i_C_rsw] = eul_i_2_eul_rsw(P_i, V_i, Euler_i)

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

%% Main Function:
%% Compute Satellite Coordiante System Parameters:
Rhat = unitv( P_i );                % [ND]  Normalized Position Vector
Hvec = cross( P_i, V_i );
What = unitv(Hvec);                 % [ND]  Cross-track Position Vector
Shat = cross( What, Rhat );         % [ND]  In Orbit Velocity Vector

%% DCM from Satellite Coordinate System (rsw) to Inertial Frame (i):
i_C_rsw = zeros(3,3);
i_C_rsw(:,1) = Rhat;
i_C_rsw(:,2) = Shat;
i_C_rsw(:,3) = What;

%% DCM from Inertial to Body Frame:
b_C_i = eul2dcm( Euler_i );

%% DCM from RSW to Body Frame:
b_C_rsw = b_C_i * i_C_rsw;

%% Compute RSW Euler Orientation:
Euler_rsw = dcm2eul( b_C_rsw );

% If input is a row vector, return a row vector:
if(size(Euler_i, 2) == 3)
    Euler_rsw = Euler_rsw';
end
end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100916 JJ:  Generated 2 examples.Added input checks
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/eul_i_2_eul_rsw.m
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
