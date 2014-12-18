% EUL_F_2_EUL_I Converts Orientation w.r.t. Fixed Frame to Orientation w.r.t. Inertial Frame
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% eul_f_2_eul_i:
%     Converts Orientation w.r.t. Fixed Frame to Orientation w.r.t.
%     Inertial
% 
% SYNTAX:
%	[euler_i, f_C_i] = eul_f_2_eul_i(euler_f, mst)
%	[euler_i, f_C_i] = eul_f_2_eul_i(euler_f)
%
% INPUTS: 
%	Name		Size                Units		Description
%	euler_f     [1x3] or [3x1]      [deg]       Euler orientation in Fixed Frame
%   mst         [1]                 [deg]       Mean Sidereal Time
%                                                Default: mst = 0
% OUTPUTS: 
%	Name		Size                Units		Description
%	euler_i     [1x3] or [3x1]      [deg]       Euler orientation in 
%                                               Central Body Inertial Frame
%   f_C_i       [3x3]               [ND]        Direction Cosine Matrix that
%                                               converts from the inertial frame
%                                               into the fixed frame
%
% NOTES:
%   All Euler vectors assume a 3-2-1 (e.g. roll/pitch/yaw or phi/theta/psi)
%   convention.  Note that this function also uses the CSA functions 
%   'eul2dcm' and 'dcm2eul'.
%
%   This function assumes theta is between +/- pi/2, while phi and psi are 
%    between +/- pi. Out of bound inputs will be wrapped to generate a valid
%    set of Eulers in the inertial frame. If trying to recover the input
%    Euler angles from the reciprocal function, eul_i_2_eul_f, the 
%    retrieved Euler angles will be limited to +/- pi/2 for theta and 
%    +/- pi for phi and psi
%
% EXAMPLES:
%	Example 1: Rotate a fixed Euler row vector into the inertial coordinate
%              frame.  Assume that sidreal time is 85 [deg].
%	
%   euler_f = [30 45 50];                           % [deg]
%   mst = 85;                                       % [deg]
% 	[euler_i, f_C_i] = eul_f_2_eul_i(euler_f, mst)
%	Returns euler_i =[ 30.0  45.0 135.0 ]           % [deg]      
%            f_C_i = [  0.0872    0.9962         0  % [non-dimensional]
%                      -0.9962    0.0872         0
%                           0         0      1.0000 ]
%
%	Example 2: Rotate a fixed Euler column vector into the inertial
%              coordiante frame.  Assume sidreal time is 50 [deg].
%
%   euler_f = [10; 20; 30];                         % [deg]
%   mst = 50;                                       % [deg]
% 	[euler_i, f_C_i] = eul_f_2_eul_i(euler_f, mst)
%	Returns euler_i =[10; 20; 80 ]                  % [deg]
%            f_C_i = [  0.6428    0.7660         0  % [non-dimensional]
%                      -0.7660    0.6428         0
%                           0         0       1.0000 ] 
% SOURCE DOCUMENTATION:
%	[1]     Stevens, Brian L. and Frank L. Lewis. Aircraft Control and 
%           Simulation. 2nd Edition. Hoboken, New Jersey: John Wiley and 
%           Sons, 2003. Eqn 1.4-12, pg 39.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit eul_f_2_eul_i.m">eul_f_2_eul_i.m</a>
%	  Driver script: <a href="matlab:edit Driver_eul_f_2_eul_i.m">Driver_eul_f_2_eul_i.m</a>
%	  Documentation: <a href="matlab:pptOpen('eul_f_2_eul_i_Function_Documentation.pptx');">eul_f_2_eul_i_Function_Documentation.pptx</a>
%
% See also eul_i_2_eul_f, eul2dcm, dcm2eul
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/330
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/eul_f_2_eul_i.m $
% $Rev: 3031 $
% $Date: 2013-10-16 17:12:13 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [euler_i, f_C_i] = eul_f_2_eul_i(euler_f, mst)

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
if((nargin < 2) || isempty(mst))
    mst = 0;    % [deg]
end

if ischar(euler_f)||ischar(mst)
    error([mfnam ':InputArgCheck'], ['Inputs must be numeric!  See ' mlink ' documentation for help.']);
end

if (size(euler_f, 1) ~= 3)&&(size(euler_f, 2) ~= 3)
    error([mfnam ':InputArgCheck'], ['Euler angle must be [3x1] or [1x3] length! See ' mlink ' documentation for help.']);
end
%% Main Function:
% Conversions
d2r = pi/180;
r2d = 180/pi;

f_C_i = [   cosd(mst)   sind(mst)   0;
            -sind(mst)  cosd(mst)   0;
                0        0          1];

%% DCM from Inertial to Body Frame:
b_C_f = eul2dcm( euler_f * d2r );

%% DCM from Fixed to Body Frame:
b_C_i = b_C_f * f_C_i;

%% Compute Local Vertical Local Horizontal Euler Orientation:
euler_i = dcm2eul( b_C_i ) * r2d;

% If input is a row vector, return a row vector:
if(size(euler_f, 2) == 3)
    euler_i = euler_i';
end
end

%% REVISION HISTORY
% YYMMDD INI: note
% 100923 JJ:  Generated 2 examples. added documentation source.
% 100819 JJ:  Function template created using CreateNewFunc
% 100225 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/eul_f_2_eul_i.m
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
