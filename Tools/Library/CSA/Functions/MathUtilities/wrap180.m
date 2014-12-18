% WRAP180 Wraps the input value from -180 to 180 and returns the result.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% wrap180:
%     Wraps the input value from -180 to 180 and returns the result.
% 
% SYNTAX:
%	[OUT] = wrap180(IN1)
%
% INPUTS: 
%	Name	Size	Units       Description
%	 IN     [1x1]   [degrees]   Input Scalar. This is the angle that needs to be wrapped
%                               between -180 and 180
% OUTPUTS: 
%	Name	Size	Units       Description
%	 OUT	[1x1] 	[degrees]   Scalar. This is the angle returned between -180 and 180 
%
% NOTES:
%	This functions returns 0 for large angles over 10^16
%
% EXAMPLE:
%	[OutAngle] = wrap180(385)
%
% HYPERLINKS:
%     Source function: <a href="matlab:edit wrap180.m">wrap180.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_wrap180.m">Driver_wrap180.m</a>
%	  Documentation: <a href="matlab:pptOpen('wrap180_Function_Documentation.pptx');">wrap180_Function_Documentation.pptx</a>
%
% See also wrap360 wrap2pi
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/430
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/wrap180.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [OUT] = wrap180(IN1)

%% Debugging & Display Utilities 
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats ...
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% input check
if isempty(IN1)
    errstr = [mfnam tab 'ERROR: No input in wrap180, please input a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end
if ischar(IN1)
    errstr = [mfnam tab 'ERROR: Input  of type string or CHAR, Please insert a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

if abs(IN1)> 10^16 
    errstr = [mfnam tab 'ERROR: Input too large, Please do not exceed 10^16' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

%% Main Function
 OUT = mod(IN1, 360.0);

if OUT > 180.0
    OUT = OUT - 360.0;
end

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100816  JJ: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         : Email                             : NGGN Username 
% JJ: jovany jimenez    : jovany.jimenez-deparias@ngc.com   : g67086 

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
