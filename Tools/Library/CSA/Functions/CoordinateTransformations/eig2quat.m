% EIG2QUAT Converts Eigen Vector to Quaternion Vector
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% eig2quat:
%     Converts Eigen Vector to Quaternion Vector
% 
% SYNTAX:
%	[quat] = eig2quat(eigen)
%
% INPUTS: 
%	Name		Size            Units		Description
%	eigen       [1x3] or [3x1]  [ND]        Eigen Vector
%
% OUTPUTS: 
%	Name		Size        	Units		Description
%	quat        [1x4] or [4x1]  [ND]        Quaternions [q1, q2, q3, q4]
%                                           q4 is the scalar
% NOTES:
%	The unit vector normalized is the rotation axis and q4 is the rotation angle
%
% EXAMPLES:
%	Example 1: Given the following eigen vector, find the quaternion
%	equivalent
%   eigen=[10 20 5];
% 	[quat] = eig2quat(eigen)
%	Returns quat = [-0.3909   -0.7818   -0.1955    0.4447]
%
%	Example 2: Given the following eigen vector, find the quaternion
%	equivalent
%   eigen=[2 -2 4];
% 	[quat] = eig2quat(eigen)
%	Returns quat = [ 0.2605   -0.2605    0.5211   -0.7699]
%
% SOURCE DOCUMENTATION:
%	[1]    Kuipers, Jack B. Quaternions and Rotaion Sequences. Princeton
%	University press, Princeton, NJ, Copyright 1999 P.157
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit eig2quat.m">eig2quat.m</a>
%	  Driver script: <a href="matlab:edit Driver_eig2quat.m">Driver_eig2quat.m</a>
%	  Documentation: <a href="matlab:pptOpen('eig2quat_Function_Documentation.pptx');">eig2quat_Function_Documentation.pptx</a>
%
% See also quat2eig 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/329
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/eig2quat.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [quat] = eig2quat(eigen)

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
%% Input check
if ischar(eigen)
    errstr = [mfnam tab 'ERROR: Input of type CHAR. Please input the angles in scalar form' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
h = size(eigen);
if ((h(1)>3) && (h(1) ~= 3))||((h(2)>3) && (h(2) ~= 3))
    errstr = [mfnam tab 'ERROR: Eigen vector must be [1x3] or [3x1]' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
%% Main Function:
quat=zeros(4,1);

theta=norm(eigen);
if abs(theta)>eps
    ahat=eigen/theta;
else
    ahat = eigen * 0;
end

quat(1:3)=ahat*sin(theta/2);
quat(4)=cos(theta/2);

quat=quat/norm(quat);

%% Check Size:
sizeeig = size(eigen);
if (sizeeig(2) > sizeeig(1))
    quat = quat';
end

end 
%% REVISION HISTORY
% YYMMDD INI: note
% 100913 JJ:  Generated 2 examples.Added input checks
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/eig2quat.m
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
