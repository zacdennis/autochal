function [quat] = dcm2quaternion(dcm)
%#codegen
% DCM2QUATERNION Computes quaternion vector from a direction cosine matrix
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% dcm2quaternion:
%     Converts Direction Cosine Matrix to Quaterion vector 
% 
% SYNTAX:
%	[quat] = dcm2quaternion(dcm)
%
% INPUTS: 
%	Name		Size		Units		Description
%	 dcm        [3x3]       [ND]        Direction Cosine Matrix
%
% OUTPUTS: 
%	Name		Size		Units		Description
%	 quat       [1x4]       [ND]        [q1, q2, q3, q0]  Quaternion vector
%                                        in which last element quat(4) is
%                                        the scalar
%
% NOTES:
%
% EXAMPLES:
%	Example 1:
%	[quat] = dcm2quaternion(dcm)
%	Returns
%
% SOURCE DOCUMENTATION:
%   [1]     Stevens, Brian L. & Lewis, Frank L.  Aircraft Control and
%   Simulation, 2nd Edition. John Wiley & Sons, Inc. Hoboken, New Jersey.
%   2003.  Page 32.  Eqn. 1.3-34a & 1.3-34b.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit dcm2quaternion.m">dcm2quaternion.m</a>
%	  Driver script: <a href="matlab:edit Driver_dcm2quaternion.m">Driver_dcm2quaternion.m</a>
%	  Documentation: <a href="matlab:winopen(which('dcm2quaternion_Function_Documentation.pptx'));">dcm2quaternion_Function_Documentation.pptx</a>
%
% See also quaternion2dcm, eul2quaterion, eul2dcm, dcm2eul
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/320
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/dcm2quaternion.m $
% $Rev: 3172 $
% $Date: 2014-05-14 12:54:29 -0500 (Wed, 14 May 2014) $
% $Author: sufanmi $

%% Main Function:
% Ref 1: Page 32, Eqn 1.3-34a
q = zeros(4,1);
q(1) = sqrt( abs(1 + dcm(1,1) + dcm(2,2) + dcm(3,3) ))/2;
q(2) = sqrt( abs(1 + dcm(1,1) - dcm(2,2) - dcm(3,3) ))/2;
q(3) = sqrt( abs(1 - dcm(1,1) + dcm(2,2) - dcm(3,3) ))/2;
q(4) = sqrt( abs(1 - dcm(1,1) - dcm(2,2) + dcm(3,3) ))/2;

% Ref 1: Page 32, Eqn 1.3-34b
q0q1 = (dcm(2,3) - dcm(3,2))/4;
q0q2 = (dcm(3,1) - dcm(1,3))/4;
q0q3 = (dcm(1,2) - dcm(2,1))/4;
q1q2 = (dcm(1,2) + dcm(2,1))/4;
q2q3 = (dcm(2,3) + dcm(3,2))/4;
q1q3 = (dcm(1,3) + dcm(3,1))/4;

% From the first set of equations, (1.3-34a), the quaternion element with
% the largest magnitude (at least one of the four must be nonzero) can be
% selected.  The sign associated with the square root can be chosen
% arbitrarily , and then this variable can be used as a divisor with
% (1.3-34b) to find the remaining quaternio elements.
[~, iMax] = max(abs(q));
q1 = 0; q2 = 0; q3 = 0; q0 = 1;     % Initialize

switch iMax
    case 1
        % q0 is largest
        q0 = q(1);
        q1 = q0q1 / q0;
        q2 = q0q2 / q0;
        q3 = q0q3 / q0;
                
    case 2
        % q1 is largest
        q1 = q(2);
        q0 = q0q1 / q1;
        q2 = q1q2 / q1;
        q3 = q1q3 / q1;
        
    case 3
        % q2 is largest
        q2 = q(3);
        q0 = q0q2 / q2;
        q1 = q1q2 / q2;
        q3 = q2q3 / q2;
        
    case 4
          % q3 is largest
          q3 = q(4);
          q1 = q1q3 / q3;
          q2 = q2q3 / q3;
          q0 = q0q3 / q3;
          
end

% Compile Output
quat = [q1; q2; q3; q0];    % quat(4) is scalar

end 

%% REVISION HISTORY
% YYMMDD INI: note

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
