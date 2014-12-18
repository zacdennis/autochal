% QUATERNION2DCM Converts quaternion vector to direction cosine matrix
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% quaternion2dcm:
%     Converts Quaterion vector to Direction Cosine Matrix
% 
% SYNTAX:
%		[dcm] = quaternion2dcm(quat)
%
% INPUTS: 
%	Name		Size            Units		Description
%   quat        [1x4]or[4x1]    [ND]        Quaternion [q1, q2, q3, q0]
%                                           Scalar term is quat(4)
%
% OUTPUTS:  
%	Name		Size            Units		Description
%	dcm         [3x3]           [ND]        Direction Cosine Matrix 
%
% NOTES:
%	
% EXAMPLES:
%	% Example 1:
%   D2R = acos(-1)/180.0;
%   Euler_deg = [10 -40 90];
%   dcm_1 = eul2dcm(Euler_deg * D2R)
%
%   quat = eul2quaternion(Euler_deg * D2R)
%	dcm_2 = quaternion2dcm(quat)
%
%   delta_dcm = dcm_2 - dcm_1
%
%   quat2 = dcm2quaternion(dcm_2)'
%   delta_quat = quat2 - quat
%
% SOURCE DOCUMENTATION:
%   [1]     Stevens, Brian L. & Lewis, Frank L.  Aircraft Control and
%   Simulation, 2nd Edition. John Wiley & Sons, Inc. Hoboken, New Jersey.
%   2003.  Page 31.  Eqn. 1.3-32.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit quaternion2dcm.m">quaternion2dcm.m</a>
%	  Driver script: <a href="matlab:edit Driver_quaternion2dcm.m">Driver_quaternion2dcm.m</a>
%	  Documentation: <a href="matlab:winopen(which('quaternion2dcm_Function_Documentation.pptx'));">quaternion2dcm_Function_Documentation.pptx</a>
%
% See also eul2dcm, eul2quaterion, dcm2eul, dcm2quaternion
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/357
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/quaternion2dcm.m $
% $Rev: 3169 $
% $Date: 2014-05-13 20:32:56 -0500 (Tue, 13 May 2014) $
% $Author: sufanmi $

function [dcm] = quaternion2dcm(quat)

%% Main Function:
q1 = quat(1); 
q2 = quat(2); 
q3 = quat(3); 
q0 = quat(4);   % Scalar

dcm = zeros(3,3);
dcm(1,1) = q0^2 + q1^2 - q2^2 - q3^2;
dcm(1,2) = 2 * (q1*q2 + q0*q3);
dcm(1,3) = 2 * (q1*q3 - q0*q2);
dcm(2,1) = 2 * (q1*q2 - q0*q3);
dcm(2,2) = q0^2 - q1^2 + q2^2 - q3^2;
dcm(2,3) = 2 * (q2*q3 + q0*q1);
dcm(3,1) = 2 * (q1*q3 + q0*q2);
dcm(3,2) = 2 * (q2*q3 - q0*q1);
dcm(3,3) = q0^2 - q1^2 - q2^2 + q3^2;

end 

%% Author Identification:
% INI: FullName     : Email                 : NGGN Username 
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
