% SINGLESTEP Generates a signal with a single step
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% SingleStep:
%     Generates a step input that holds till the end of the time frame.
% 
% SYNTAX:
%	[y, t] = SingleStep(t, startTime, Amp, y, flgResizeTime)
%	[y, t] = SingleStep(t, startTime, Amp, y)
%	[y, t] = SingleStep(t, startTime, Amp)
%
% INPUTS: 
%	Name		Size            Units	Description
%	t   		[1xN] or [Nx1]	[sec]  	Time Array           
%	startTime	[1]             [sec]  	Start time of the step
%	Amp 		[1]             [N/A]  	Amplitude of step
%	y   		[1xN] or [Nx1]  [N/A]   Current Signal, can be used to
%                                       apply multiple steps or doublets to
%                                       the same signal)
%                                       Default: y is 1xN filled by zeroes
%   flgResizeTime [1]       [bool]      Allow time array to be resized?
%                                       Default: false (0)
%
% OUTPUTS: 
%	Name		Size            Units	Description
%	y   		[1xN] or [Nx1]	[N/A] 	Signal with SingleStep applied
%	t   		[1xN] or [Nx1]	[sec]	Time Array           
%
% NOTES:
%	Operates on only a [1xN] or [Nx1] signal.  t and y must be of the same
%   dimension for everything to work properly.
%
%   If the time array, t, is empty, it will be prepopulated based on
%   startTime.  Function will assume an endtime of (2 * startTime).
%
% EXAMPLES:
%   Example 1: Single Use
%   A simple case, running SingleStep over a ten second interval.  
%   The step starts at t = 3 and Amp = 5.
%
%   t = (0:10);         % [sec] Time vector
%   y = SingleStep(t, 3, 5);
%   disp([t;y])
%   figure(); plot(t,y, 'b*-', 'LineWidth', 1.5); ylim([0 10]); grid on;
%
%   Returns:
%    (t)  0     1     2     3     4     5     6     7     8     9    10
%    (y)  0     0     0     5     5     5     5     5     5     5     5
%   
%   Example 2: Use on an Existing Signal
%   Add a new step to the step created in Example #1.  New step will start
%   at t = 6 and have an Amp = -3
%
%   t = (0:10);                     % [sec] Time vector
%   y = SingleStep(t, 3, 5);        %       Create Existing Signal  
%   y = SingleStep(t, 6, -3, y);    %       Add Step to Existing Signal
%   disp([t;y])
%   figure(); plot(t,y, 'b*-', 'LineWidth', 1.5); ylim([0 10]); grid on;
%
%   Returns:
%    (t)  0     1     2     3     4     5     6     7     8     9    10
%    (y)  0     0     0     5     5     5     2     2     2     2     2
%
%   Example 3: Single Use without specifying time
%   The step starts at t = 3 and Amp = 5.
%
%   [y, t] = SingleStep([], 3, 5);
%   disp([t;y])
%   figure(); plot(t,y, 'b*-', 'LineWidth', 1.5); ylim([0 10]); grid on;
%
%   Returns:
%    (t)  0   2.999999999900000   3.000000000000000   6.000000000000000
%    (y)  0   0                   5                   5
%   
% HYPERLINKS:
%	Source function: <a href="matlab:edit SingleStep.m">SingleStep.m</a>
%	  Driver script: <a href="matlab:edit Driver_SingleStep.m">Driver_SingleStep.m</a>
%	  Documentation: <a href="matlab:winopen(which('SingleStep_Function_Documentation.pptx'));">SingleStep_Function_Documentation.pptx</a>
%
% See also StepUpDown Doublet Interp1D
%
% VERIFICATION DETAILS:
% Verified: In Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/313
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SignalGenerators/SingleStep.m $
% $Rev: 3072 $
% $Date: 2014-02-05 16:11:42 -0600 (Wed, 05 Feb 2014) $
% $Author: sufanmi $

function [y, t] = SingleStep(t, startTime, Amp, y, flgResizeTime)

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

if (nargin < 3)
   disp([mfnam ' :: Incorrect Number of Inputs.  See ' mlink ' for usage help.' endl]);
   return;
end;

if((nargin < 5) | isempty(flgResizeTime))
    flgResizeTime = 0;
end

if(isempty(t))
    flgResizeTime = 1;
end

if(flgResizeTime)
    % Figure out times to add:
    tinyDT = 1e-10; it = 0;     % Note: eps doesn't work with unique
    it = it + 1; t2add(it) = 0;
    it = it + 1; t2add(it) = startTime - tinyDT;
    it = it + 1; t2add(it) = startTime;
    it = it + 1; t2add(it) = 2 * startTime;
    
    % Add those times to the provide time vector:
    tNew = unique([t t2add]);
else
    tNew = t;
end

if(nargin < 4)
    y = [];
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

%%
sizet = size(t);
sizey = size(y);

if ( (~any(sizet == 1)) || (~any(sizey == 1)) )
    errstr = [mfnam ' ERROR: t and y must be [1 x N] or [N x 1].'...
        endl tab tab tab tab '  t=[%d x %d] is y=[%d x %d]'];
    error([mfnam 'CSA:SignalGenerators:DimensionError'],errstr, ...
          sizet(1), sizet(2), sizey(1), sizey(2));
end

if (sizet(2) ~= sizey(2))
    errstr = [mfnam ' ERROR: t and y must be of same dimension.'...
        endl tab tab tab tab '  t=[%d x %d] is y=[%d x %d]'];
    error([mfnam 'CSA:SignalGenerators:DimensionError'],errstr, ...
          sizet(1), sizet(2), sizey(1), sizey(2));
end

% Warnings for out of bounds:
if(startTime > max(t))
    disp(['Warning : Start Time of Step (' num2str(startTime) ' [sec])' ...
         ' exceeds the' endl '          maximum inputted time value (' num2str(max(t)) ' [sec])!']);
    disp('          Step will NOT be created and/or added');
    return;
end

if(startTime < min(t))
    disp(['Warning : Start Time of Step (' num2str(startTime) ' [sec])' ...
        ' preceeds the' endl '          minimum inputted time value (' num2str(min(t)) ' [sec])!']);
    disp('          Step will NOT be created and/or added');
    return;
end

%% Main Function:

% Get Indices of timesteps where the step occurs:
ii = find(t>=startTime);
y(ii) = y(ii) + Amp;

end % << End of function SingleStep >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110426 MWS: Added ability of function to auto create time vector if it is
%              not provided.  Added example #3.
% 100909 JPG: Added input checking, and did some error formatting.
% 100909 CNF: Function template created using CreateNewFunc
% 090122 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/ANALYS
%             IS/SIGNAL_GENERATORS/SingleStep.m
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% JPG: James Patrick Gray   : James.Gray2@ngc.com   : g61720 
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
