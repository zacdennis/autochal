% QUATTRANS Computes the conjugate transpose of a Quaternion vector
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% QuatTrans:
%     Computes the Conjugate (Transpose) of a Quaternion Vector, q, where
%     q(4) is assumed to be the scalar
% 
% SYNTAX:
%	[qC] = QuatTrans(q)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	q   	    [4]         [ND]   		Quaternion, q(4) is the scalar
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	qC  	    [4]         [ND]   		Conjugate (transpose) of the
%                                       quaternion vector
% NOTES:
%
% EXAMPLES:
%	% Example 1
%   D2R         = acos(-1)/180.0;
%   Euler_deg   = [10 -40 90];
%   quat        = eul2quaternion(Euler_deg * D2R)
%   quatT       = QuatTrans(quat)
%
% SOURCE DOCUMENTATION:
%   [1]     Stevens, Brian L. & Lewis, Frank L.  Aircraft Control and
%   Simulation, 2nd Edition. John Wiley & Sons, Inc. Hoboken, New Jersey.
%   2003.  Page 17.  Eqn. 1.2-17.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit QuatTrans.m">QuatTrans.m</a>
%	  Driver script: <a href="matlab:edit Driver_QuatTrans.m">Driver_QuatTrans.m</a>
%	  Documentation: <a href="matlab:winopen(which('QuatTrans_Function_Documentation.pptx'));">QuatTrans_Function_Documentation.pptx</a>
%
% See also eul2quaternion
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/361
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/QuatTrans.m $
% $Rev: 3172 $
% $Date: 2014-05-14 12:54:29 -0500 (Wed, 14 May 2014) $
% $Author: sufanmi $

function [qC] = QuatTrans(q)
%#codegen

qC = q;
qC(1:3) = qC(1:3) * -1;

end % << End of function QuatTrans >>

%% Author Identification: 
% INI: FullName     : Email                 : NGGN Username 
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
