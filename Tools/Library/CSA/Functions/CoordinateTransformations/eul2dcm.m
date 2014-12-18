% EUL2DCM Converts Euler Angles to Direction Cosine Matrix
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% eul2dcm:
%     Converts Euler Angles to Direction Cosine Matrix
%
% SYNTAX:
%	[DCM] = eul2dcm(euler, strOrder)
%	[DCM] = eul2dcm(euler)
%
% INPUTS:
%	Name		Size          Units		Description
%	euler		[3x1]or[1x3]  [rad]     Euler orientation [phi,theta, psi]
%	strOrder	[1xn]		  [ND]      Describes the order of the
%                                        rotations Default: '321'
% OUTPUTS:
%	Name		Size		Units		Description
%	DCM 		[3x3]		[ND]		Direction cosine matrix
%
% NOTES:
%   This function assumes theta is between +/- pi/2, while phi and psi are 
%   between +/- pi. Out of bound inputs will be wrapped to generate a valid
%   dcm, but if trying to recover the input Euler angles from the 
%   reciprocal function, dcm2eul, the retrieved Euler angles will be 
%   limited to +/- pi/2 for theta and +/- pi for phi and psi
%
% EXAMPLES:
%	Example 1: Transforms the euler angles to a direction cosine matrix
%   euler = [-2.5664; 1.0177; 1.4160]   % [rad]
% 	[DCM] = eul2dcm(euler)
%	Returns
%   DCM = [0.0810    0.5190   -0.8509;  
%          0.7576   -0.5868   -0.2858; 
%         -0.6476   -0.6215   -0.4408]
%
%	Example 2: Gets the Direction cosine matrix angles with different order
%	rotation 123 for a angle of 30 -45 and 90 degrees
%   euler =[0.5236   -0.7854    1.5708];    % [rad]
% 	[DCM] =eul2dcm(euler, '123')
%	 Returns DCM = [  0.0000    0.7071    0.7071;
%                    -0.8660   -0.3536    0.3536;
%                     0.5000   -0.6124    0.6124]
% SOURCE DOCUMENTATION:
%	[1] Stevens, Brian L. Lewis, Frank L. Aircraft Control and
%	Simulation 2ed. John Wiley and Sons, New Jersey, 2003 pg. 26
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit eul2dcm.m">eul2dcm.m</a>
%	  Driver script: <a href="matlab:edit Driver_eul2dcm.m">Driver_eul2dcm.m</a>
%	  Documentation: <a href="matlab:pptOpen('eul2dcm_Function_Documentation.pptx');">eul2dcm_Function_Documentation.pptx</a>
%
% See also dcm2eul
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/338
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/eul2dcm.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [DCM] = eul2dcm(euler,strOrder)

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
%% Input check

if nargin < 2
    strOrder = '321';
end
if ischar(euler)
    errstr = [mfnam tab 'ERROR: Input of type CHAR. Please input the angles in scalar form' ];
    error([mfnam 'class:file:Identifier'],errstr);
end

h = size(euler);
if ((h(1)>3) && (h(1) ~= 3))
    errstr = [mfnam tab 'ERROR: Euler angles must be [1x3] or [3x1]' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
if ((h(2)>3) && (h(2) ~= 3))
    errstr = [mfnam tab 'ERROR: Euler angles must be [1x3] or [3x1]' ];
    error([mfnam 'class:file:Identifier'],errstr);
end

%% Main Function:
C = zeros(3,3);
DCM = zeros(3,3);
%%
numAngles = length(euler);

for i = 1:numAngles
    curOrder = strOrder(i);
    ang = euler(numAngles+1-i);
    switch curOrder
        case '1'
            C = [...
                1   0           0;
                0   cos(ang)    sin(ang);
                0   -sin(ang)   cos(ang)];
            
        case '2'
            C = [...
                cos(ang)    0   -sin(ang);
                0           1   0;
                sin(ang)    0   cos(ang)];
            
        case '3'
            C = [...
                cos(ang)    sin(ang)    0;
                -sin(ang)   cos(ang)    0;
                0           0           1];
    end
    
    if(i == 1)
        DCM = C;
    else
        DCM = C * DCM;
    end
end



end

%% REVISION HISTORY
% YYMMDD INI: note
% 100824 JJ:  Filled the description and units of the I/O added input check
% 100819 JJ:  Function template created using CreateNewFunc
% 080114 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDI
%             NATE_TRANSFORMATIONS/eul2dcm.m
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
