% VARIABLETIMEDELAY Variable Time Delay using a circular buffer
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% VariableTimeDelay:
%     Variable Time Delay function that utilizes a circular buffer. 
% 
% SYNTAX:
%	[y] = VariableTimeDelay(u, TimeDelay_sec, MaxTimeDelay_sec, SampleTime_sec, BufferTime_sec)
%
% INPUTS: 
%	Name            	Size		Units		Description
%	u   	            [n]         [N/A]       Signal to time delay
%	TimeDelay_sec       [1]         [sec]       Time to delay signal
%	MaxTimeDelay_sec	[1]         [sec]       Maximum time signal can be
%                                                delayed
%	SampleTime_sec      [1]         [sec]       Simulation base rate
%	BufferTime_sec      [1]         [sec]       Rate at which to populate
%                                                the time delay buffer
%
% OUTPUTS: 
%	Name            	Size		Units		Description
%	y   	            [n]         [N/A]       Signal 'u' delayed by
%                                                'TimeDelay_sec' seconds
% NOTES:
%	This function uses MATLAB persistent variables.
%
% EXAMPLES:
%	% Example #1: Show Variable Time Delay with differing base/buffer rates
%   strTestCase = 'Test Case #1: Variable Time Delay: Differing Base/Buffer Rates';
%   MaxTimeDelay_sec= 1;            % Maximum Length of Time Delay
%   SampleTime_sec  = 0.02;         % Base rate sample time
%   BufferTime_sec  = 0.1;          % Rate at which to fill buffer
% 
%   RunTime_sec = 3;
%   THD.Time_sec = [0 : SampleTime_sec : RunTime_sec];
%   THD.u = THD.Time_sec;
% 
%   THD.TimeDelay_sec = ones(size(THD.Time_sec)) * 0.25;
%   i = find(THD.Time_sec >= 0 & THD.Time_sec <= 0.8); THD.TimeDelay_sec(i) = 0.25;
%   i = find(THD.Time_sec >= 0.8 & THD.Time_sec <= 1.4); THD.TimeDelay_sec(i) = 0.15;
%   i = find(THD.Time_sec >= 1.4 & THD.Time_sec <= 2); THD.TimeDelay_sec(i) = -0.1;
%   i = find(THD.Time_sec >= 2 & THD.Time_sec <= 2.5); THD.TimeDelay_sec(i) = MaxTimeDelay_sec + .1;
%            
%   nPts = length(THD.Time_sec);
%   for i = 1:nPts
%       u = THD.u(i);
%       TimeDelay_sec = THD.TimeDelay_sec(i);
%       THD.y(i) = CircularBuffer(u, TimeDelay_sec, MaxTimeDelay_sec, SampleTime_sec, BufferTime_sec);
%     
%   end
%   THD.Delta =  THD.u - THD.y;
% 
%   FigPos = [150 250 1000 850];
%   ms = 10;
%   lw = 1.5;
%   fighdl = figure('Position', FigPos, 'Name', strTestCase);
%   subplot(211);
%   lstTitle(1,:) = {sprintf('\\bf\\fontsize{12}%s', strTestCase)};
%   lstTitle(2,:) = {sprintf('\\fontsize{10}Base Sample Rate: %.2f [sec], Buffer Fill Rate: %.2f [sec], Max Delay Time: %.2f [sec]', ...
%       SampleTime_sec, BufferTime_sec, MaxTimeDelay_sec)};
% 
%   h(1) = plot(THD.Time_sec, THD.u, 'bo-', 'MarkerSize', ms, 'LineWidth', lw); hold on;
%   h(2) = plot(THD.Time_sec, THD.y, 'rx-', 'MarkerSize', ms, 'LineWidth', lw);
%   title(lstTitle);
%   grid on; set(gca, 'FontWeight', 'bold');
%   xlabel('\bfTime [sec]');
%   ylabel('\bfTimestamp [sec]');
% 
%   subplot(212);
%   h(1) = plot(THD.Time_sec, THD.TimeDelay_sec, 'bo-', 'MarkerSize', ms, 'LineWidth', lw); hold on;
%   h(2) = plot(THD.Time_sec, THD.Delta, 'rx-', 'MarkerSize', ms, 'LineWidth', lw);
%   lstLegend = {'Commanded Delay'; 'Computed Delay'};
%   legend(h, lstLegend, 'Location', 'SouthEast');
%   ylimits = ylim;
%   ylimits(1) = min(ylimits(1), -0.01);    % Add a little buffer
%   ylimits(2) = max(ylimits(2), 0.01);
%   ylim(ylimits);
%   grid on; set(gca, 'FontWeight', 'bold');
%   xlabel('\bfTime [sec]');
%   ylabel('\bf[sec]');
%
% SOURCE DOCUMENTATION:
% [1]   http://en.wikipedia.org/wiki/Circular_buffer
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit VariableTimeDelay.m">VariableTimeDelay.m</a>
%	  Driver script: <a href="matlab:edit Driver_VariableTimeDelay.m">Driver_VariableTimeDelay.m</a>
%	  Documentation: <a href="matlab:winopen(which('VariableTimeDelay_Function_Documentation.pptx'));">VariableTimeDelay_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/824
%  
% Copyright Northrop Grumman Corp 2014
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/VariableTimeDelay.m $
% $Rev: 3068 $
% $Date: 2014-01-30 11:58:03 -0600 (Thu, 30 Jan 2014) $
% $Author: sufanmi $

function [y] = VariableTimeDelay(u, TimeDelay_sec, MaxTimeDelay_sec, SampleTime_sec, BufferTime_sec)

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

persistent tblData nSamples nCol iCtr Time_sec iEnd numValidBuf;
flgRecordTime = 0;
iBufferUpdate = floor(BufferTime_sec / SampleTime_sec) + 1;

if isempty(tblData)
    nSamples= floor(MaxTimeDelay_sec / BufferTime_sec) + 1;
    nCol    = length(u);
    
    if(flgRecordTime)
        tblData = zeros(nSamples, nCol+1);  % Time Included
    else
        tblData = zeros(nSamples, nCol);
    end
    Time_sec = 0;
    iEnd = 0;
    iCtr = 1;
    numValidBuf = 0;
else
    Time_sec = Time_sec + SampleTime_sec;
    iCtr = iCtr + 1;    % Internal Counter
    
end

%% Buffer Update
if( (iCtr == 1) || (iCtr >= iBufferUpdate) )
    iEnd = iEnd + 1;
    
    % Initial Fill Counter
    numValidBuf = numValidBuf + 1;
    numValidBuf = min(numValidBuf, nSamples);
    
    % Check for wrapping:
    if(iEnd > nSamples)
        iEnd = 1;
    end
    
    % Old Call with time
    if(flgRecordTime)
        tblData(iEnd,1) = Time_sec;
        tblData(iEnd,2:(nCol+1)) = u;
    else
        tblData(iEnd,:) = u;
    end

    % Reset the Counter:
    iCtr = 1;
end

%% Compute the Output:
%  Enforce Max/Min Delay Limits
TimeDelay_sec = max(TimeDelay_sec, 0);                  % Lower Bounds
TimeDelay_sec = min(TimeDelay_sec, MaxTimeDelay_sec);   % Upper Bounds

% Max Index of time value for desired 'TimeDelay_sec'
iY           = (TimeDelay_sec / BufferTime_sec);
numNeededBuf = ceil(iY) + 1;
numNeededBuf = min(numNeededBuf, nSamples);

if(numValidBuf >= numNeededBuf)
    % There's enough data (time-wise) in buffer to satisfy requested
    % 'TimeDelay_sec'
    
    % Adjust indices for the circular buffer
    iLow = mod(iEnd - numNeededBuf, nSamples) + 1;
    iY1     = floor(iY);
%     iY2     = iY1 + 1;
%     m       = (iY - iY1)/(iY2 - iY1);
    m = iY - iY1;
    iHigh   = iLow + 1;
    if(iHigh > nSamples)
        iHigh = iHigh - nSamples;
    end
    
    disp(sprintf('t = %.2f, iY = %.2f, iY1 = %d, iEnd = %d,  iLow = %d, iHigh = %d', ...
        Time_sec, iY, iY1, iEnd, iLow, iHigh));
    
    if(flgRecordTime)
        yLow    = tblData(iLow,2:(nCol+1));
        yHigh   = tblData(iHigh,2:(nCol+1));
    else
        yLow    = tblData(iLow,:);
        yHigh   = tblData(iHigh,:);
    end
    
    % Linear Interpolation:
    y = yLow + m*(yHigh - yLow);
    
else
    % Buffer does not go back far enough.  Just return zero.
    y = u * 0;
end


end % << End of function VariableTimeDelay >>

%% REVISION HISTORY
% YYMMDD INI: note
% 140127 MWS: Created function
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         : Email                 : NGGN Username 
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi

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
