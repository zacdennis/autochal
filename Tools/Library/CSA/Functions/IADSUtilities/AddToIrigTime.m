% ADDTOIRIGTIME Adds time to an Irig time string
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% AddToIrigTime:
%     Adds time to or subtracts time from a Symvionics IADS Irig time.
% 
% SYNTAX:
%	[irigtimenew] = AddToIrigTime(irigtimeorig, timeToAdd, timetype)
%	[irigtimenew] = AddToIrigTime(irigtimeorig, timeToAdd)
%
% INPUTS: 
%	Name        	Size		Units		Description
%	irigtimeorig	'string'    [time]      Time string representing time
%                                            since New Year's in the format
%                                            DDD:HH:MM:SS.MS, where...
%                                            DDD - 3 digit day (0-364)
%                                            HH  - 2 digit hour (0-23)
%                                            MM  - 2 digit minute (0-59)
%                                            SS  - 2 digit second (0-59)
%                                            MS  - up to 9 digit for
%                                                   partial seconds
%	timeToAdd	   [1]          [varies]    Amount of time to add to
%                                            original Irig time.  Units are
%                                            based on 'timetype' input
%	timetype	   'string'     [char]      Units for 'timeToAdd'.  Can be:
%                                            'sec' <-- default
%                                            'min', 'hr', or 'day'
% OUTPUTS: 
%	Name        	Size		Units		Description
%	irigtimenew     'string'    [time]      New Irig time string with time
%                                            added in.  Also in format
%                                            DDD:HH:MM:SS.MS
%
% NOTES:
%
% EXAMPLES:
%	% Example #1: Add 10 minutes to a sample Irig time
%	AddToIrigTime('001:23:52:20.5', 10, 'min')
%	% returns '002:00:02:20.500000000'
%
%	% Example #2: Subtract 10 minutes to a sample Irig time
%	AddToIrigTime('002:00:02:20.500', -10, 'min')
%	% returns '001:23:52:20.500000000'
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit AddToIrigTime.m">AddToIrigTime.m</a>
%	  Driver script: <a href="matlab:edit Driver_AddToIrigTime.m">Driver_AddToIrigTime.m</a>
%	  Documentation: <a href="matlab:winopen(which('AddToIrigTime_Function_Documentation.pptx'));">AddToIrigTime_Function_Documentation.pptx</a>
%
% See also IrigTime2DecTime, DecTime2IrigTime
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/744
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/IADSUtilities/AddToIrigTime.m $
% $Rev: 2316 $
% $Date: 2012-03-08 13:31:48 -0600 (Thu, 08 Mar 2012) $
% $Author: sufanmi $

function [irigtimenew] = AddToIrigTime(irigtimeorig, timeToAdd, timetype)

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

if(nargin == 2)
    timetype = 'sec';
end

%% Main Code
switch lower(timetype)
    case 'sec'
        timeToAdd_sec = timeToAdd;
    case 'min'
        MIN2SEC = 60;       % min to second
        timeToAdd_sec = timeToAdd * MIN2SEC;
    case 'hr'
        HR2SEC  = 3600;     % hour to second
        timeToAdd_sec = timeToAdd * HR2SEC;
    case 'day'
        DAY2SEC = 86400;    % day to second
        timeToAdd_sec = timeToAdd * DAY2SEC;
    otherwise
        disp(sprintf('%s : ERROR : Unknown time type ''%s''', mfilename, timetype));
end

timeSinceNewYears_sec = IrigTime2DecTime(irigtimeorig);
timeSinceNewYears_sec = timeSinceNewYears_sec + timeToAdd_sec;
irigtimenew = DecTime2IrigTime(timeSinceNewYears_sec);

end % << End of function AddToIrigTime >>

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
