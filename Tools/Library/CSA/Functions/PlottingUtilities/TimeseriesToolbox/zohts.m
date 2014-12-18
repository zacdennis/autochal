% ZOHTS Computes the zero-order-hold equivalent of a timeseries
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% zohts:
%     Computes the zero-order-hold equivalenet of a timeseries.  Useful for
%     plotting the discrete-time version of a signal.
% 
% SYNTAX:
%	[ts_zoh] = zohts(ts, small_val)
%	[ts_zoh] = zohts(ts)
%
% INPUTS: 
%	Name    	Size            Units		Description
%	ts  	    timeseries      [varies]    Timeseries object on which to
%                                           zero order hold
%   small_val   [1]             [time]      Value to use in determining new
%                                           timesteps (Default 1e-10).
% OUTPUTS: 
%	Name    	Size            Units		Description
%	ts_zoh	  	{timeseries}    [varies]    Zero-order-held timeseries
%
% NOTES:
%	'ts_zoh' and 'ts' will carry same units.
%
% EXAMPLES:
%   % Example #1: Perform a zero-order-hold on sample data
%   t = [0:0.01:.2];
%   y = rand(size(t));
%   ts = timeseries(y', t');
%   ts.Name = 'RandomNumber';
%   ts.DataInfo.Units = '[uint32]';
%   ts_zoh = zohts(ts);
%  
%   figure()
%   plotts({ts;ts_zoh})
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit zohts.m">zohts.m</a>
%	  Driver script: <a href="matlab:edit Driver_zohts.m">Driver_zohts.m</a>
%	  Documentation: <a href="matlab:winopen(which('zohts_Function_Documentation.pptx'));">zohts_Function_Documentation.pptx</a>
%
% See also timeseries, plotts
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/813
%  
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/zohts.m $
% $Rev: 3011 $
% $Date: 2013-09-12 19:38:15 -0500 (Thu, 12 Sep 2013) $
% $Author: sufanmi $

function [ts_zoh] = zohts(ts, small_val)

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

%% Input Argument Conditioning:
if((nargin < 2) || isempty(small_val))
    small_val = 1e-10;
end

%% Main Function:
arrTime = ts.Time;
matData = ts.Data;
[numPts, numCol]= size(matData);

t = zeros(numPts+numPts-1, 1);
y = zeros(numPts+numPts-1, numCol);

% Faster index method
i = 1:2:(numPts*2);
i2 = 2:2:(numPts*2)-1;

t(i) = arrTime;
t(i2) = arrTime(2:end) - small_val;

y(i,:) = matData;
y(i2,:) = matData(1:end-1,:);

ts_zoh = timeseries(y, t);
ts_zoh.Name = sprintf('zoh(%s)', ts.Name);
ts_zoh.DataInfo.Units = ts.DataInfo.Units;

end % << End of function zohts >>

%% REVISION HISTORY
% YYMMDD INI: note
% 130912 MWS: Created function using CreateNewFunc
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
