% STEPUPDOWN Generates a StepUpDown Signal
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% StepUpDown:
%     Generates a step input that holds for a specified amplitude and 
%     duration.  After the duration time elapses, it will step down the
%     same amplitude.  It can be applied to new or existing signals.
% 
% SYNTAX:
%	[y, t] = StepUpDown(t, startTime, durationTime, Amp, y, flgResizeTime)
%	[y, t] = StepUpDown(t, startTime, durationTime, Amp, y)
%	[y, t] = StepUpDown(t, startTime, durationTime, Amp)
%
% INPUTS: 
%	Name            Size            Units	Description
%	t               [1xN] or [Nx1]	[sec]  	Time frame to run the script
%	startTime       [1]             [sec]  	Start time of StepUpDown
%	durationTime	[1]             [sec]	Total duration time of StepUpDown
%	Amp             [1]             [N/A]  	Amplitude of StepUpDown
%	y               [1xN] or [Nx1]  [N/A]  	Current signal (Can be used to
%                                           apply multiple steps or 
%                                           doublets to the same signal)
%   flgResizeTime   [1]             [bool]  Allow time array to be resized?
%                                           Default: false (0)
%
% OUTPUTS: 
%	Name            Size            Units   Description
%	y               [1xN] or [Nx1] 	[N/A]   Signal with StepUpDown applied
%	t               [1xN] or [Nx1]	[sec]   Time frame to run the script
%
% NOTES:
%	Operates on only a [1xN] or [Nx1] signal.  t and y must be of the same
%   dimension for everything to work properly.
%
%   If the time array, t, is empty, it will be prepoulated based on the
%   startTime and durationTime.  Function will assume an endtime of
%   (startTime + durationTime * 2).
%
% EXAMPLES:
%	% Example 1: Single Use
%   % A simple case, running StepUpDown over a ten second interval.  The step
%   % starts at t=3, has a duration of 4 seconds, and has an amplitude of 5.
%   t = ([0:10]);
%	y1 = StepUpDown(t, 3, 4, 5)
%   
%	% Returns:
%   %  t = [ 0     1     2     3     4     5     6     7     8     9     10]
%   % y1 = [ 0     0     0     5     5     5     5     0     0     0     0 ]
%
%   figure(); plot(t,y1, 'b*-', 'LineWidth', 1.5); ylim([0 10]); grid on;
%
%	% Example 2: Combined Use
%   % StepUpDown is run twice over the same ten second interval.  The first
%   % step starts at t=3, has a duration of 4 seconds, and has an amplitude 
%   % of five.  The second step has the same characteristics, but starts at
%   % t = 2.
%   t = ([0:10]);
%	y1 = StepUpDown(t, 3, 4, 5);
%	y2 = StepUpDown(t, 2, 4, 5, y1)
%
%   % Returns:
%   %  t = [ 0     1     2     3     4     5     6     7     8     9     10]
%   % y2 = [ 0     0     5    10    10    10     5     0     0     0     0 ]
%
%   figure(); plot(t,y2, 'b*-', 'LineWidth', 1.5); ylim([0 10]); grid on;
%
%	% Example 3: Combined Use Without Specifying Time
%   % This is just like Example 2, but the time vector is dynamically
%   % created by the function itself.  For long runs this can keep variable
%   % sizes to a minimum.  The first step starts at t=3, has a duration 
%   % of 4 seconds, and has an amplitude of 5.  The second step has the 
%   % same characteristics, but starts at t = 2.
%
%   format long
%   [y1, t1] = StepUpDown([], 3, 4, 5);
%   [y2, t2] = StepUpDown(t1, 2, 4, 5, y1, 1);
%   [t2' y2'] 
%   % Returns:        (t2)                (y2)
%   %                    0                   0
%   %    1.999999999900000                   0
%   %    2.000000000000000   5.000000000000000
%   %    2.999999999900000   5.000000000000000
%   %    3.000000000000000  10.000000000000000
%   %    5.999999999900000  10.000000000000000
%   %    6.000000000000000   5.000000000000000
%   %    6.999999999900000   5.000000000000000
%   %    7.000000000000000                   0
%   %   10.000000000000000                   0
%   %   11.000000000000000                   0
%
%   figure(); plot(t2, y2, 'b*-', 'LineWidth', 1.5, 'MarkerSize', 10); ylim([0 12]);
%   set(gca, 'FontWeight', 'bold'); grid on;
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit StepUpDown.m">StepUpDown.m</a>
%	  Driver script: <a href="matlab:edit Driver_StepUpDown.m">Driver_StepUpDown.m</a>
%	  Documentation: <a href="matlab:winopen(which('StepUpDown_Function_Documentation.pptx'));">StepUpDown_Function_Documentation.pptx</a>
%
% See also SingleStep Doublet Interp1D
%
% VERIFICATION DETAILS:
% Verified: In Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/314
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SignalGenerators/StepUpDown.m $
% $Rev: 2811 $
% $Date: 2012-12-19 13:24:44 -0600 (Wed, 19 Dec 2012) $
% $Author: sufanmi $

function [y, t] = StepUpDown(t, startTime, durationTime, Amp, y, flgResizeTime)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Input Argument Conditioning:
if((nargin < 6) || isempty(flgResizeTime))
    flgResizeTime = 0;
end

if(nargin < 5)
    y = [];
end

if nargin < 4
   disp([mfnam ' :: Incorrect Number of Inputs.  See ' mlink ' for usage help.' endl]);
   return;
end;

if(isempty(t))
    flgResizeTime = 1;
end

if(flgResizeTime)
    % Figure out times to add:
    tinyDT = 1e-10; it = 0;     % Note: eps doesn't work with unique
    it = it + 1; t2add(it) = 0;
    it = it + 1; t2add(it) = startTime - tinyDT;
    it = it + 1; t2add(it) = startTime;
    it = it + 1; t2add(it) = startTime + durationTime - tinyDT;
    it = it + 1; t2add(it) = startTime + durationTime;
    it = it + 1; t2add(it) = startTime + durationTime * 2;
    
    % Add those times to the provide time vector:
    tNew = unique([t t2add]);
else
    tNew = t;
end

if(isempty(y))
    % No y data exists, just set them to zero for now
    yNew = tNew * 0;
else
    % Linearly interpolate the existing y data for the new, t2add timesteps
    yNew = Interp1D(t, y, tNew, 1);
end

t = tNew;
y = yNew;

numAmp = length(Amp);
numSignals = size(y);
ytemp = zeros(numAmp,numSignals(2));

%% Main Function:
% Get Indices of timesteps where the step occurs:

ii = find((t>=startTime) & (t<(startTime + durationTime)));

% Modified code to include additive property to signals passed through the
% function.  Also added the ability to pass either multiple signals,
% multiple amplitudes, or both at the same time.

if numSignals(1) ~= numAmp
    if ((numSignals(1) > numAmp) && (numAmp == 1))
        for iSignal = 1:numSignals(1)
            y(iSignal,ii) = y(iSignal, ii) + Amp;
        end
    elseif (numSignals(1) == 1)
        for iAmp = 1:numAmp
            ytemp(iAmp,:) = y;
            ytemp(iAmp,ii) = ytemp(iAmp, ii) + Amp(iAmp);
        end
        y = ytemp;
    else
        errstr = [mfnam ' ERROR: Amp must either be 1xM or 1x1. M = %d'];
        error([mfnam 'CSA:SignalGenerators:DimensionError'],errstr, ...
            numSignals(1));
    end
else
    for iAmp = 1:numAmp
        y(iAmp,ii) = y(iAmp, ii) + Amp(iAmp);
    end
end

%% Compile Outputs:

% Warnings for out of bounds:
if(startTime > max(t))
    disp(['Warning : Start Time of StepUpDown (' num2str(startTime) ' [sec])' ...
        endl '          exceeds the maximum inputted time value (' num2str(max(t)) ' [sec])!']);
    disp('          StepUpDown will NOT be created and/or added');
end

if(startTime < min(t))
    disp(['Warning : Start Time of StepUpDown (' num2str(startTime) ' [sec])' ...
        endl '          preceeds the minimum inputted time value (' num2str(min(t)) ' [sec])!']);
    disp('          StepUpDown will NOT be created and/or added');
end

end % << End of function StepUpDown >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110426 MWS: Added ability of function to auto create time vector if it is
%              not provided.  Added example #6.
% 100909 JPG: Made some minor edits to the file.  Added input checking.
% 100908 JPG: Started filling in the template per COSMO format.
% 100908 JPG: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  James.Gray2@ngc.com  :  g61720 
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi

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
