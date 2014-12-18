% ANG2VEC Converts Euler Angles into its pointing vector equivalent.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ang2vec:
%     Converts Euler Angles into its pointing vector equivalent.
% 
% SYNTAX:
%	[vec] = ang2vec(eul)
%	
% INPUTS: 
%	Name		Size                Units		Description
%	eul         [1x3]or [3x1]       [rad]       Euler Angles [Phi, Theta, Psi]
%                                               with respect to a body frame where:
%                                                   x - positive out nose
%                                                   y - positive out right wing
%                                                   z - positive down
% OUTPUTS: 
%	Name		Size                Units		Description
%	vec         [1x3]oe[3x1]        [ND]        Vector pointing in same direction
%                                               as the euler angle coordinates
%
% NOTES:
%	Euler angles must be in radians. Euler angles can be [1x3] or [3x1].
%   This function assumes both coordinate systems have the same origin. 
%
% EXAMPLES:
%	Example 1: Given the euler angles phi= pi/4, theta=pi/4, and  psi=pi/2.
%	Find a vector pointing in the equivalent coordinates. 
%   eul=[pi/4; pi/4; pi/2];
% 	[vec] = ang2vec(eul)
%	Returns vec= [ 0  0.7071  -0.7071 ]
%
%	Example 2: Given the euler angles phi= -pi/2, theta=pi/4, and  psi=-pi/4.
%	Find a vector pointing in the equivalent coordinates. 
%   eul=[-pi/4; pi/4; -pi/4];
% 	[vec] = ang2vec(eul)
%	Returns vec= [ 0.5  -0.5  -0.7071 ]
%
% SOURCE DOCUMENTATION:
%	[1]    http://www...
%	[2]    Author. Book Title. Publisher, City, Copyright year
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ang2vec.m">ang2vec.m</a>
%	  Driver script: <a href="matlab:edit Driver_ang2vec.m">Driver_ang2vec.m</a>
%	  Documentation: <a href="matlab:pptOpen('ang2vec_Function_Documentation.pptx');">ang2vec_Function_Documentation.pptx</a>
%
% See also vec2ang 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/315
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/ang2vec.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [vec] = ang2vec(eul)

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
if ischar(eul)
    errstr = [mfnam tab 'ERROR: Input of type CHAR. Please input the angles in scalar form' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
h = size(eul);
if ((h(1)>3) && (h(1) ~= 3))
    errstr = [mfnam tab 'ERROR: Euler angles must be [1x3] or [3x1]' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
if ((h(2)>3) && (h(2) ~= 3))
    errstr = [mfnam tab 'ERROR: Euler angles must be [1x3] or [3x1]' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
%% Main Function:
vec(1) =  cos( eul(2) ) * cos( eul(3) ); 
vec(2) =  cos( eul(2) ) * sin( eul(3) ); 
vec(3) = -sin( eul(2) );      

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100915 JJ:  Added input checks 
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/ang2vec.m
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
