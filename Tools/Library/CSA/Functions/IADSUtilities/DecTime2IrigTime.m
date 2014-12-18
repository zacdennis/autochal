% DECTIME2IRIGTIME Converts time since New Years to an Irig time string
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% DecTime2IrigTime:
%     Converts a decimal representing time since New Years to a Symvionic
%     IADS Irig time string.
% 
% SYNTAX:
%	[irigtime] = DecTime2IrigTime(dectime_sec)
%
% INPUTS: 
%	Name            Size		Units	Description
%	dectime_sec     [1]         [sec]   Time since New Year's in decimal
%
% OUTPUTS: 
%	Name            Size        Units   Description
%	irigtime        'string'    [time]   Time string representing time
%                                        since New Year's in the format
%                                        DDD:HH:MM:SS.MS, where...
%                                        DDD - 3 digit day (0-364)
%                                        HH  - 2 digit hour (0-23)
%                                        MM  - 2 digit minute (0-59)
%                                        SS  - 2 digit second (0-59)
%                                        MS  - up to 9 digit for
%                                               partial seconds
%
% NOTES:
%
% EXAMPLES:
%	% Exampe 1: Convert a single day into Irig time:
%	[irigtime] = DecTime2IrigTime(86400)
%	% Returns '001:00:00:0.000000000'
%
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit DecTime2IrigTime.m">DecTime2IrigTime.m</a>
%	  Driver script: <a href="matlab:edit Driver_DecTime2IrigTime.m">Driver_DecTime2IrigTime.m</a>
%	  Documentation: <a href="matlab:winopen(which('DecTime2IrigTime_Function_Documentation.pptx'));">DecTime2IrigTime_Function_Documentation.pptx</a>
%
% See also IrigTime2DecTime 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/742
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/IADSUtilities/DecTime2IrigTime.m $
% $Rev: 2316 $
% $Date: 2012-03-08 13:31:48 -0600 (Thu, 08 Mar 2012) $
% $Author: sufanmi $

function [irigtime] = DecTime2IrigTime(dectime_sec)

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

DAY2SEC = 86400;    % day to second
HR2SEC  = 3600;     % hour to second
MIN2SEC = 60;       % min to second

leftover_sec = dectime_sec;
day_new = floor(leftover_sec/DAY2SEC);
leftover_sec = mod(leftover_sec, DAY2SEC);

hr_new = floor(leftover_sec/HR2SEC);
leftover_sec = mod(leftover_sec, HR2SEC);

min_new = floor(leftover_sec/MIN2SEC);
leftover_sec = mod(leftover_sec, MIN2SEC);

sec_new = leftover_sec;
irigtime = sprintf('%03d:%02d:%02d:%02.9f', day_new, hr_new, min_new, sec_new);

end % << End of function DecTime2IrigTime >>

%% REVISION HISTORY
% YYMMDD INI: note
% 120305 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
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
