% DELTAIRIGTIME Computes the time difference between two Symvionic Irig times
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% DeltaIrigTime:
%   Computes the difference between two Symvionic's Irig times 
% 
% SYNTAX:
%	[timediff] = DeltaIrigTime(irigtime1, irigtime2, timetype)
%	[timediff] = DeltaIrigTime(irigtime1, irigtime2)
%
% INPUTS: 
%	Name            Size		Units	Description
%	irigtime1       'string'    [time]  Time string representing time
%                                        since New Year's in the format
%                                        DDD:HH:MM:SS.MS, where...
%                                        DDD - 3 digit day (0-364)
%                                        HH  - 2 digit hour (0-23)
%                                        MM  - 2 digit minute (0-59)
%                                        SS  - 2 digit second (0-59)
%                                        MS  - up to 9 digit for
%                                               partial seconds
%	irigtime2       'string'    [time]  Same as 'irigtime1' above
%	timetype        'string'    [char]  Desired units of ouputted delta
%                                        time. Can be either:
%                                        'sec' (default),
%                                        'min', 'hr', 'day', or 'irig'
%
% OUTPUTS: 
%	Name            Size        Units   Description
%	timediff        [1]         [varies] Delta between two Irig times
%
% NOTES:
%
% EXAMPLES:
%	% Example 1: Show the delta between 2 Irig times
%   %  Step 1: Create the 2nd Irig time based on the 1st one
%   irigtime1 = '001:00:00:00.0'
%   irigtime2 = AddToIrigTime(irigtime1, 86400)
%
%   %  Step 2: Now compute the delta to recover 86400 seconds, but show the
%   %           delta in the various output 'timetype' formats
%	[timediff_sec]  = DeltaIrigTime(irigtime1, irigtime2)
%
%   % Note that these output doubles:
%   [timediff_sec]  = DeltaIrigTime(irigtime1, irigtime2, 'sec')
%   [timediff_min]  = DeltaIrigTime(irigtime1, irigtime2, 'min')
%   [timediff_hr]   = DeltaIrigTime(irigtime1, irigtime2, 'hr')
%   [timediff_day]  = DeltaIrigTime(irigtime1, irigtime2, 'day')
%
%   % Note that this outputs a string:
%   [timediff_irig] = DeltaIrigTime(irigtime1, irigtime2, 'irig')
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit DeltaIrigTime.m">DeltaIrigTime.m</a>
%	  Driver script: <a href="matlab:edit Driver_DeltaIrigTime.m">Driver_DeltaIrigTime.m</a>
%	  Documentation: <a href="matlab:winopen(which('DeltaIrigTime_Function_Documentation.pptx'));">DeltaIrigTime_Function_Documentation.pptx</a>
%
% See also IrigTime2DecTime, DecTime2IrigTime, AddToIrigTime
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/743
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/IADSUtilities/DeltaIrigTime.m $
% $Rev: 2316 $
% $Date: 2012-03-08 13:31:48 -0600 (Thu, 08 Mar 2012) $
% $Author: sufanmi $

function [timediff] = DeltaIrigTime(irigtime1, irigtime2, timetype)

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

t1 = IrigTime2DecTime(irigtime1);
t2 = IrigTime2DecTime(irigtime2);

timediff_sec = t2 - t1;

if(nargin == 2)
    timetype = 'sec';
end

switch lower(timetype)
    case 'sec'
        timediff = timediff_sec;
    case 'min'
        SEC2MIN = 1/60;     % second to min
        timediff = timediff_sec * SEC2MIN;
    case 'hr'
        SEC2HR  = 1/3600;   % second to hour
        timediff = timediff_sec * SEC2HR;
    case 'day'
        SEC2DAY = 1/86400;  % second to day
        timediff = timediff_sec * SEC2DAY;
    case 'irig'
        timediff = DecTime2IrigTime(timediff_sec);
    otherwise
        disp(sprintf('%s : ERROR : Unknown time type ''%s''. Returning default [sec]', mfilename, timetype));
        timediff = timediff_sec;
end


end % << End of function DeltaIrigTime >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 120307 <INI>: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName            : Email     : NGGN Username 
% <initials>: <Fullname>   : <email>   : <NGGN username> 

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
