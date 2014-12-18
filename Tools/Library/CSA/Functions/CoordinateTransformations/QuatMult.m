function [quat_a2c] = QuatMult(quat_a2b, quat_b2c)
%#codegen
% QUATMULT Computes the product of two quaternion vectors
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% QuatMult:
%     Computes the product of two quaternion vectors.  Scalar is assumed to
%     be the last element (q(4)).
% 
% SYNTAX:
%	[t] = QuatMult(quat_a2b, quat_b2c)
%
% INPUTS: 
%	Name		Size              Units     Description
%   quat_a2b    [1x4] or [4x1]    [ND]      Quaternion vector 1 from frame
%                                            A into frame B
%   quat_b2c    [1x4] or [4x1]    [ND]      Quaternion vector 2 from frame
%                                            B into frame C
% OUTPUTS: 
%	Name		Size              Units		Description
%	 quat_a2c   [1x4] or [4x1]    [ND]      Product of quat_a2b and
%                                           quat_b2c, or the Quaternion
%                                           from frame A into frame C
%
% NOTES:
% Originally created as a function for VSI_LIB
% https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/QuatMult.m
%
% EXAMPLES:
%	Example 1:
%   Euler_a2b_deg = [0 -90 0]
%   Euler_b2c_deg = [0 -90 0]
% 
%   Quat_a2b = eul2quaternion(Euler_a2b_deg * C.D2R)
%   Quat_b2c = eul2quaternion(Euler_b2c_deg * C.D2R)
% 
%   b_C_a = eul2dcm(Euler_a2b_deg * C.D2R);
%   c_C_b = eul2dcm(Euler_b2c_deg * C.D2R);
% 
%   c_C_a = c_C_b * b_C_a
%   Euler_a2c_deg = dcm2eul(c_C_a)' * C.R2D
%   Quat_a2c_2 = dcm2quaternion(c_C_a)'
% 
%   Quat_a2c = QuatMult(Quat_a2b, Quat_b2c)
%   Delta_Quat = Quat_a2c - Quat_a2c_2
%
% SOURCE DOCUMENTATION:
% 	[1]    Wie, Bong. Space Vehicle Dynamics and Control, 2nd Edition.
% 	AIAA, 2008. Page 337. Eqn 5.46.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit QuatMult.m">QuatMult.m</a>
%	  Driver script: <a href="matlab:edit Driver_QuatMult.m">Driver_QuatMult.m</a>
%	  Documentation: <a href="matlab:winopen(which('QuatMult_Function_Documentation.pptx'));">QuatMult_Function_Documentation.pptx</a>
%
% See also QuatDiv QuatTrans 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/359
%
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21)
% Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/QuatMult.m $
% $Rev: 3172 $
% $Date: 2014-05-14 12:54:29 -0500 (Wed, 14 May 2014) $
% $Author: sufanmi $



%% Main Function:

quat_a2c = quat_a2b*0;  % Initialize Output

% Denoted as q' in Eqn 5.46
q1 = quat_a2b(1);
q2 = quat_a2b(2);
q3 = quat_a2b(3);
q4 = quat_a2b(4);  % Scaler

% Denoted as q'' in Eqn 5.46
r1 = quat_b2c(1);
r2 = quat_b2c(2);
r3 = quat_b2c(3);
r4 = quat_b2c(4);  % Scaler

% Eqn 5.46, page 337.
quat_a2c(1) =  r4*q1 + r3*q2 - r2*q3 + r1*q4;
quat_a2c(2) = -r3*q1 + r4*q2 + r1*q3 + r2*q4;
quat_a2c(3) =  r2*q1 - r1*q2 + r4*q3 + r3*q4;
quat_a2c(4) = -r1*q1 - r2*q2 - r3*q3 + r4*q4;

end 

%% Author Identification:
% INI: FullName         : Email                             : NGGN Username
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
