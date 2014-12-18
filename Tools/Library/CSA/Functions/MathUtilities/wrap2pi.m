% WRAP2PI wraps the input value from 0 to 2*pi and returns the result.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% wrap2pi:
%     Wraps the angle given in radians and wraps it between 0 and 2*pi.
%     Then it returns the reult in radians.
% 
% SYNTAX:
%	[OUT] = wrap2pi(IN)
%
% INPUTS: 
%	Name	Size	Units           Description
%	 IN     [1x1]	[rad][scalar]	Input angle given in radians
%
% OUTPUTS: 
%	Name	Size	Units           Description
%	 OUT	[1x1]	[rad][scalar]	Output angle given in radians
%
% NOTES:
%	The angles must be in radians. Input angle must be less than 10^16 in
%	magnitude.
%
% EXAMPLE:
%	[OUT] = wrap2pi(IN)
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit wrap2pi.m">wrap2pi.m</a>
%	  Driver script: <a href="matlab:edit Driver_wrap2pi.m">Driver_wrap2pi.m</a>
%	  Documentation: <a href="matlab:pptOpen('wrap2pi_Function_Documentation.pptx');">wrap2pi_Function_Documentation.pptx</a>
%
% See also wrap360 wrap180 
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/431
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/wrap2pi.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [OUT] = wrap2pi(IN)

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
OUT = mod(IN, (2*acos(-1)));

end % << End of function wrap2pi >>

%% REVISION HISTORY
% YYMMDD INI: note
% 100817  JJ: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         :  Email                            : NGGN Username 
%  JJ: jovany jimenez   : jovany.jimenez-deparias@ngc.com   : g67086

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
