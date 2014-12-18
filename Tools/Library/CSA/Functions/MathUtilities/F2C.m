% F2C  Temperature Conversion - Fahrenheit to Celsius
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% F2C:
%      Temperature Conversion - Fahrenheit to Celsius 
% 
% SYNTAX:
%	[celsius] = F2C(fahrenheit)
%
% INPUTS: 
%	Name            Size		Units               Description
%	fahrenheit      [variable]  [deg Fahrenheit]    Temperature in Fahrenheit
%
% OUTPUTS: 
%	Name            Size		Units               Description
%	celsius         [variable]  [deg Celsius]       Temperature in Celsius 
%
% NOTES:
%	Variable size means that the 'fahrenheit' input can be singular, a row 
%   or column vector, or a multi-dimensional matrix (M x N x P x ...).  The
%   size of 'fahrenheit' will determine the size of the 'celsius' ouput.
%
% EXAMPLES:
%	Example 1: Convert a single temperature from Fahrenheit to Celsius
% 	[celsius] = F2C(104)
%	Returns celsius = 40
%
%	Example 2: Convert a matrix of temperatures from Fahrenheit to Celsius
%   fahrenheit= [75 78 79; 
%               100 96 98; 
%                89 91 93];
% 	[celsius] = F2C(fahrenheit)
%	Returns celsius = [ 23.8889 25.5556 26.1111; 
%                       37.7778 35.5556 36.6667; 
%                       31.6667 32.7778 33.8889] 
%
%   Example 3: Check that you can go from Fahrenheit to Celsius, and then
%   back to Fahrenheit
%   Fahrenheit = 20;
%   FahrenheitCheck = C2F( F2C( Fahrenheit ) );
%   deltaF = FahrenheitCheck - Fahrenheit
%   Returns deltaF = 0
%
% SOURCE DOCUMENTATION:
%	[1]  Guyer, Eric C. Applied Thermal Design. Taylor & Francis,
%        Philadelphia,PA Copyright 1999. Pg. 1-14
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit F2C.m">F2C.m</a>
%	  Driver script: <a href="matlab:edit Driver_F2C.m">Driver_F2C.m</a>
%	  Documentation: <a href="matlab:pptOpen('F2C_Function_Documentation.pptx');">F2C_Function_Documentation.pptx</a>
%
% See also C2F, C2R, R2C, F2R, R2F
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/412
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/F2C.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [celsius] = F2C(fahrenheit)

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
if ischar(fahrenheit)
     error([mfnam ':InputArgCheck'], 'Input of type string or CHAR. Must be expressed in scalar form.')
end
%% Main Function:
celsius = (fahrenheit - 32.0)./1.8;
end

%% REVISION HISTORY
% YYMMDD INI: note
% 100909 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/MATH_UTILITIES/F2C.m
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
