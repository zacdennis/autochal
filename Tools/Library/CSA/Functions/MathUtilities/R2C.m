% R2C Temperature Conversion - Rankine to Celsius
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% R2C:
%     Tempearture Conversion - Rankine to Celsius
% 
% SYNTAX:
%	[celsius] = R2C(rankine)
%
% INPUTS: 
%	Name            Size		Units               Description
%	 rankine        [variable]  [deg Rankine]       Temperature in Rankine
%
% OUTPUTS: 
%	Name            Size		Units                Description
%	celsius         [variable]  [deg Celsius]        Temperature in Celsius 
%
% NOTES:
%   The size of the input determines the size of the output.  This function
%   will work on a singular input (e.g. [1]), a vector (row or column), or 
%   a multi-dimential matrix (M x N x P x ...).
%
% EXAMPLES:
%	Example 1: Convert absolute zero (Rankine) to Celsius
%   rankine=0;
% 	[celsius] = R2C(rankine)
%	Returns celsius = -273.15
%
%	Example 2: Convert a matrix of Rankine temperatures to Celsius
%   rankine=[560 670 543; 98 45 67; 491.67 671.641 563.67];
% 	[celsius] = R2C(rankine)
%	Returns celsius = [   37.9611   99.0722   28.5167;
%                       -218.7056 -248.1500 -235.9278;
%                          0.0000   99.9839   40.0000  ]
%
% SOURCE DOCUMENTATION:
%	[1]  Guyer, Eric C. Applied Thermal Design. Taylor & Francis,
%        Philadelphia, PA Copyright 1999. P.1-14
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit R2C.m">R2C.m</a>
%	  Driver script: <a href="matlab:edit Driver_R2C.m">Driver_R2C.m</a>
%	  Documentation: <a href="matlab:pptOpen('R2C_Function_Documentation.pptx');">R2C_Function_Documentation.pptx</a>
%
% See also C2R, C2F, F2C, F2R, R2F
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/421
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/R2C.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [celsius] = R2C(rankine)

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
if ischar(rankine)
     error([mfnam ':InputArgCheck'], 'Input of type string or CHAR. Must be expressed in scalar form.')
end

%% Main Function:
celsius = (rankine .* (5/9)) - 273.15;

end 
%% REVISION HISTORY
% YYMMDD INI: note
% 100909 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/MATH_UTILITIES/R2C.m
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
