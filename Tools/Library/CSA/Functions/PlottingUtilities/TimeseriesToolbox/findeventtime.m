% FINDEVENTTIME Finds the first time that a value expression is achieved
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% findeventtime:
%     Finds the first time that a value expression is achieved in a
%     timeseries data history
%
% SYNTAX:
%	[eventTime] = findeventtime(ts, strExpression, strFirstLast)
%	[eventTime] = findeventtime(ts, strExpression)
%
% INPUTS: 
%	Name            Size		Units		Description
%  ts               timeseries  [N/A]       Timeseries
%   .Time           [n]         [time]
%   .Data           [n]         [N/A]
%  strExpression    'string'    [char]      Expression to use in searching
%                                            timseries
%  strFirstLast     'string'    [char]      Either 'first' or 'last' to
%                                            indicate either the first or
%                                            last time expression is
%                                            achieved. Default is 'first'.
%
% OUTPUTS: 
%	Name            Size		Units		Description
%  eventTime        [1]         [time]      Time at either the first or
%                                            last encounter
% NOTES:
%
% EXAMPLES:
%	% Example 1: Show the time at which a step is inserted
%   %   Step 1: Create the step timeseries
%   t = [0:10]'; y = t*0; y(5:end) = 1;
%   ts = timeseries(y, t);
%   ts.Name = 'Simple Step';
%   plotts(ts, 'Decimation', 1);
%
%   % Figure out the first time a value of '1' is achieved:
%   % Note that all of these work...
%	eventTime = findeventtime(ts, '==1', 'first')
%	eventTime = findeventtime(ts, '==1')
%	eventTime = findeventtime(ts, '1')
%	eventTime = findeventtime(ts, 1)
%   % returns '4'
%
%	% Example 2: Show the time at which -0.6 is exceeded in a simple sine
%   %       wave timeseries
%   t = [0:10]'; y = sin(t);
%   ts = timeseries(y, t);
%   ts.Name = 'Sine Wave';
%   plotts(ts, 'Decimation', 1);
%
%   % 2a. Figure out the first time a value of '-0.6' is exceeded:
%	eventTime = findeventtime(ts, '<-0.6', 'first')
%	eventTime = findeventtime(ts, '<-0.6')
%   % both return '4'
%
%   % 2b. Figure out the last time a value of '-0.6' is exceeded:
%	eventTime = findeventtime(ts, '<-0.6', 'last')
%   % returns '5'
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit findeventtime.m">findeventtime.m</a>
%	  Driver script: <a href="matlab:edit Driver_findeventtime.m">Driver_findeventtime.m</a>
%	  Documentation: <a href="matlab:pptOpen('findeventtime_Function_Documentation.pptx');">findeventtime_Function_Documentation.pptx</a>
%
% See also find 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/516
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/findeventtime.m $
% $Rev: 2302 $
% $Date: 2012-02-09 18:03:30 -0600 (Thu, 09 Feb 2012) $
% $Author: sufanmi $

function [eventTime] = findeventtime(ts, strExpression, strFirstLast)

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

%% Initialize Outputs:
eventTime = [];

%% Input Argument Conditioning:
if((nargin < 3) || isempty(strFirstLast))
    strFirstLast = 'first';
end

if(~ischar(strExpression))
    strExpression = ['==' num2str(strExpression)];
else
    lstPossible = {'==';'~=';'>';'>=';'<';'<='};
    logicFound = isempty(strmatch(strExpression,lstPossible));
    if(~logicFound)
        strExpression = ['==' strExpression];
    end
end

%% Main Function:
eval_str = ['iptr = find(ts.Data' strExpression ', 1,''' lower(strFirstLast) ''');'];
eval(eval_str);
eventTime = ts.Time(iptr);

end % << End of function findeventtime >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi

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
