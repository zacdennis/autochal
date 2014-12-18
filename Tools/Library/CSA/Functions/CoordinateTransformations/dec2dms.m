% DEC2DMS Converts Numeric Angle into Degrees / Minutes / Seconds
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% dec2dms:
%     Converts Numeric Angle into Degrees / Minutes / Seconds
% 
% SYNTAX:
%	[deg_min_sec] = dec2dms(ang)
%
% INPUTS: 
%	Name		Size            Units           Description
%	 ang        [1xN]or[Nx1]    [Degrees]       Angle in degrees
%
% OUTPUTS: 
%	Name		Size            Units           Description
%	deg_min_sec [Nx3]or[3xN]    [deg min sec]   Degrees/minutes/seconds
%
% NOTES:
%	No Angle Wrapping is Contained in this Function. 
%
% EXAMPLES:
%	Example 1: Convert the following angles into degrees minutes and
%	seconds (row array)
%   ang = [45.67 23.567 12.987]
% 	[deg_min_sec] = dec2dms(ang)
%	Returns deg_min_sec = [45 23 12 40 34 59 12 1.2 13.2]
%   
%   Example 2: Convert the following angles into degrees minutes and
%	seconds (column array)
%   ang = [2.567; 34.654; 45]
% 	[deg_min_sec] = dec2dms(ang)
%	Returns deg_min_sec = [2 34 1.2 ; 34 39 14.4 ; 45 0 0]
%
% SOURCE DOCUMENTATION:
%	[1]    Duffet-Smith, Peter. Practical Astronomy with you calculator 3ed.
%          Cambridge University press, Cambridge,UK Copyright 1979 p.33
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit dec2dms.m">dec2dms.m</a>
%	  Driver script: <a href="matlab:edit Driver_dec2dms.m">Driver_dec2dms.m</a>
%	  Documentation: <a href="matlab:pptOpen('dec2dms_Function_Documentation.pptx');">dec2dms_Function_Documentation.pptx</a>
%
% See also dms2dec 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/321
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/dec2dms.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [deg_min_sec] = dec2dms(ang)

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
if ischar(ang)
    errstr = [mfnam tab 'ERROR: Input of type CHAR. Please input the angles in scalar form' ];
    error([mfnam 'class:file:Identifier'],errstr);
end

%% Main Function:
for i=1:length(ang)
deg(i) = floor(ang(i));               
min(i) = floor((ang(i) - deg(i)).*60);   
sec(i) = (ang(i)-deg(i)-min(i)./60).*3600;   
deg_min_sec = [deg min sec];
end
end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080114 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/dec2dms.m
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
