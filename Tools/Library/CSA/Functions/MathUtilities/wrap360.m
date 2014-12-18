% WRAP360 Wraps the input value to be between 0 and 360
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% wrap360:
%     This functions wraps the angle given between 0 and 360 and returns
%     the result
% 
% SYNTAX:
%	[OUT] = wrap360(IN)
%
% INPUTS: 
%	Name	Size	Units           Description
%	 IN     [1x1]	[deg][scalar]	Angle or number to be wrapped
%
% OUTPUTS: 
%	Name	Size	Units           Description
%	 OUT	[1x1]	[deg][Scalar]	Angle or number between 0 and 360 
%
% NOTES:
%	This functions only outputs positive values between 0 and 360. Input 
% angle must be less than 10^16 in magnitude.
%
% EXAMPLE:
%	[OUT_angle] = wrap360(360)
%   [OUT_angle] = 360
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit wrap360.m">wrap360.m</a>
%	  Driver script: <a href="matlab:edit Driver_wrap360.m">Driver_wrap360.m</a>
%	  Documentation: <a href="matlab:pptOpen('wrap360_Function_Documentation.pptx');">wrap360_Function_Documentation.pptx</a>
%
% See also wrap180 wrap2pi 
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/432
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/wrap360.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [OUT] = wrap360(IN)

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

%% Input Check
if isempty(IN)
    errstr = [mfnam tab 'ERROR: No input in wrap180, please input a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end
if ischar(IN)
    errstr = [mfnam tab 'ERROR: Input  of type string or CHAR, Please insert a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

if abs(IN)> 10^16
    errstr = [mfnam tab 'ERROR: Input too large, Please do not exceed 10^16' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

%% Main Function
OUT = mod(IN, 360.0);

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100817  JJ: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI : FullName        :  Email                            : NGGN Username 
%  JJ : jovany jimenez  : jovany.jimenez-deparias@ngc.com   : g67086 

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
