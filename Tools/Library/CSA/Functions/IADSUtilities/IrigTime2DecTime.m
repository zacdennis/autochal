% IrigTime2DecTime Converts an Irig time string to decimal notation
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% IrigTime2DecTime:
%     Converts a Symvionics IADS Irig time from string to decimal.
% 
% SYNTAX:
%	[time_dec] = IrigTime2DecTime(irigtime)
%
% INPUTS: 
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
% OUTPUTS: 
%	Name            Size		Units	Description
%	dectime_sec     [1]         [sec]   Time since New Year's in decimal
%
% NOTES:
%
% EXAMPLES:
%	% Example 1: Convert an example Irig time to decimal format:
%	IrigTime2DecTime('001:00:00:00.0')
%	% returns 86400
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit IrigTime2DecTime.m">IrigTime2DecTime.m</a>
%	  Driver script: <a href="matlab:edit Driver_IrigTime2DecTime.m">Driver_IrigTime2DecTime.m</a>
%	  Documentation: <a href="matlab:winopen(which('IrigTime2DecTime_Function_Documentation.pptx'));">IrigTime2DecTime_Function_Documentation.pptx</a>
%
% See also DecTime2IrigTime 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/741
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/IADSUtilities/IrigTime2DecTime.m $
% $Rev: 2316 $
% $Date: 2012-03-08 13:31:48 -0600 (Thu, 08 Mar 2012) $
% $Author: sufanmi $

function [dectime_sec] = IrigTime2DecTime(irigtime)

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

day_hr_min_sec = regexp(irigtime, ':', 'split');
day = str2double(day_hr_min_sec(1));
hr  = str2double(day_hr_min_sec(2));
min = str2double(day_hr_min_sec(3));
sec = str2double(day_hr_min_sec(4));
dectime_sec = (day*DAY2SEC) + (hr*HR2SEC) + (min*MIN2SEC) + sec;

end % << End of function IrigTime2DecTime >>

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
