% DCM2EUL Converts Direction Cosine Matrix to Euler Angles
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% dcm2eul:
%     Converts Direction Cosine Matrix to Euler Angles 
%
% SYNTAX:
%	[euler] = dcm2eul(dcm)
%
% INPUTS: 
%	Name		Size		Units		Description
%	dcm 		[3x3]		[ND]		Direction cosine matrix
%
% OUTPUTS: 
%	Name		Size		Units		Description
%	euler		[3x1]       [rad]       Euler orientation [phi, theta, psi] 
%
% NOTES:
%   Outputs are restricted to +/- pi/2 for Theta  and +/- pi for Phi
%   and Psi
%
% EXAMPLES:
%	Example 1: Transforms the Direction cosine matrix to the euler angles
%   dcm =[  0.0810    0.5190   -0.8509;  
%           0.7576   -0.5868   -0.2858; 
%          -0.6476   -0.6215   -0.4408];
% 	[euler] = dcm2eul(dcm)
%	Returns euler =[ -2.5664; 1.0177; 1.4160]   
%
%	Example 2: Gets the euler angles from the identity cosine matrix
%   dcm=eye(3,3);
% 	[euler] = dcm2eul(dcm)
%	 Returns euler =[ 0 0 0]
%
% SOURCE DOCUMENTATION:
%	[1] Stevens, Brian L. Lewis, Frank L. Aircraft Control and
%	Simulation 2ed. John Wiley and Sons, New Jersey, 2003 pg. 40
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit dcm2eul.m">dcm2eul.m</a>
%	  Driver script: <a href="matlab:edit Driver_dcm2eul.m">Driver_dcm2eul.m</a>
%	  Documentation: <a href="matlab:pptOpen('dcm2eul_Function_Documentation.pptx');">dcm2eul_Function_Documentation.pptx</a>
%
% See also eul2dcm 
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/319
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/dcm2eul.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [euler] = dcm2eul(dcm)
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
h = size(dcm);
if (h(1)~=3) || (h(2) ~= 3) 
    errstr = [mfnam tab 'ERROR: Direction Cosine Matrix Must be 3x3' ]; 
    error([mfnam 'class:file:Identifier'],errstr);
end

%% Main Function:
phi   =  atan2( dcm(2,3) , dcm(3,3) ); 
theta =  asin ( -dcm(1,3) );           
psi   =  atan2( dcm(1,2) , dcm(1,1) );  
euler = [phi; theta; psi];             

end 
%% REVISION HISTORY
% YYMMDD INI: note
% 100824 JJ:  Filled the description and units of the I/O added input check
% 100819 JJ:  Function template created using CreateNewFunc
% 080114 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDI
%             NATE_TRANSFORMATIONS/dcm2eul.m
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
