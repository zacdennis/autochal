% QUATTRANSVEC Transforms a vector about a quaternion vector
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% QuatTransVec:
%     Transforms a vector about a quaternion vector
% 
% SYNTAX:
%	[vecB] = QuatTransVec(quat_a2b, vecA)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	quat_a2b 	[4]         [ND]   		Quaternion that defines rotation
%                                       from frame 'a' to frame 'b' (e.g.
%                                       quat2dcm(quat_a2b) --> b_C_a)
%                                       Scalar is assumed to be the 4th
%                                       element, quat_a2b(4)
%	vecA	    [3]     	[N/A]  		Vector in frame 'a'
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	vecB	    [3]         [N/A]       Vector in frame 'b'

%
% NOTES:
%
% EXAMPLES:
%	% Example #1
%   D2R = acos(-1)/180.0;
%   Euler_a2b_deg = [0; 180; 0];
%   Vec_a = [1; 0; 0];
% 
%   b_C_a = eul2dcm(Euler_a2b_deg * D2R);
%   Vec_b = b_C_a * Vec_a
% 
%   Quat_a2b = eul2quaternion(Euler_a2b_deg * D2R)
%   Vec_b2 = QuatTransVec(Quat_a2b, Vec_a)'
% 
%   Delta_Vec = Vec_b2 - Vec_b
%
% SOURCE DOCUMENTATION:
%   [1]     Stevens, Brian L. & Lewis, Frank L.  Aircraft Control and
%   Simulation, 2nd Edition. John Wiley & Sons, Inc. Hoboken, New Jersey.
%   2003.  Page 19.  Eqn. 1.2-20b.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit QuatTransVec.m">QuatTransVec.m</a>
%	  Driver script: <a href="matlab:edit Driver_QuatTransVec.m">Driver_QuatTransVec.m</a>
%	  Documentation: <a href="matlab:winopen(which('QuatTransVec_Function_Documentation.pptx'));">QuatTransVec_Function_Documentation.pptx</a>
%
% See also QuatTrans, QuatMult, eul2dcm, eul2quaternion
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/362
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/QuatTransVec.m $
% $Rev: 3175 $
% $Date: 2014-05-14 13:39:49 -0500 (Wed, 14 May 2014) $
% $Author: sufanmi $

function [vecB] = QuatTransVec(quat_a2b, vecA)
%#codegen

quat_a2b_prime = QuatTrans(quat_a2b);

% Set qVecA to be same dimensions (column or row) as quat_a2b
qVecA       = quat_a2b * 0;
qVecA(1:3)  = vecA;

qVecB = QuatMult(QuatMult(quat_a2b_prime, qVecA), quat_a2b);
vecB = qVecB(1:3);

end % << End of function QuatTransVec >>

%% Author Identification: 
% INI: FullName         : Email                 : NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi

%% FOOTER
%
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
