% DOUBLET Generates a doublet signal
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Doublet:
%       Generates a doublet that begins at a specified time.  Half of 
%       the duration time will be at the specified amplitude, the 
%       other half will be the negative amplitude.  An existing 
%       signal can be an optional input, so more complex combinations
%       of signals can be created.
% 
% SYNTAX:
%	[y, t] = Doublet(t, startTime, durationTime, Amp, y, flgResizeTime)
%	[y, t] = Doublet(t, startTime, durationTime, Amp, y)
%	[y, t] = Doublet(t, startTime, durationTime, Amp)
%
% INPUTS: 
%	Name            Size            Units	Description
%	t               [1xN] or [Nx1] 	[sec]  	Time Array
%	startTime		[1]             [sec]  	Start time of doublet
%	durationTime	[1]             [sec]  	Total duration time of doublet
%	Amp             [1]             [N/A]  	Amplitude of doublet
%	y               [1xN] or [Nx1]  [N/A]  	Current Signal (Can be used to
%                                           apply multiple steps/doublets
%                                           to the same signal)
%                                           Default: If y is not specified
%                                           it will be initialized at as a 
%                                           vector of zeros.
%
%   flgResizeTime   [1]             [bool]  Allow time array to be resized?
%                                           Default: false (0)
%
% OUTPUTS: 
%	Name            Size            Units	Description
%	y               [1xN] or [Nx1] 	[N/A]	Signal with doublet applied
%	t               [1xN] or [Nx1]	[sec]  	Time Array
%
% NOTES:
%	Operates on only a [1xN] or [Nx1] signal.  t and y must be of the same
%   dimension for everything to work properly.
%
%   If the time array, t, is empty, it will be prepopulated based on
%   startTime and durationTime to return a t and y that satisfies the
%   doublet.
%
% EXAMPLES:
%	%   Example 1: Single Use
%   A simple case, running doublet on a ten second interval.  
%   The doublet starts at t = 3, duration = 6 Amp = 5.
%
%   t = (0:10);
%   y = Doublet(t, 3, 6, 5)
%
%   y =
%       0     0     0     5     5     5    -5    -5    -5     0     0
%   
%   Example 2: Use on an Existing Signal
%   Running doublet over an existing step signal.  The doublet starts at
%   t = 4, duration = 5 Amp = -3
%
%   t = (0:.5:10);			
%   ystep = SingleStep(t, 2, 3);
%   ydoub = Doublet(t, 4, 5, -3, ystep)
%
%   ydoub =
%   Columns 1 through 12
%     0     0     0     0     3     3     3     3     0     0     0     0
%   Columns 13 through 21
%     0     6     6     6     6     6     3     3     3
%
%   Example 3: Build a Doublet without specifying the time array
%   The doublet starts at t = 5, duration = 6, Amp = 2.
%
%   [y, t] = Doublet([], 5, 5, 2)
%
%   y = [ 0     2     2    -2    -2     0     0     0 ]
%   t = [ 0     5     5     8     8    11    11    14 ]
%   Note: 'eps' is used in developing the time array.  Despite y(2) showing
%   up as '2', it is really (2-eps).  y(3) is the start of the step up.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Doublet.m">Doublet.m</a>
%	  Driver script: <a href="matlab:edit Driver_Doublet.m">Driver_Doublet.m</a>
%	  Documentation: <a href="matlab:winopen(which('Doublet_Function_Documentation.pptx'));">Doublet_Function_Documentation.pptx</a>
%
% See also SingleStep StepUpDown Interp1D
%
% VERIFICATION DETAILS:
% Verified: In Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/311
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SignalGenerators/Doublet.m $
% $Rev: 2282 $
% $Date: 2011-12-19 17:36:48 -0600 (Mon, 19 Dec 2011) $
% $Author: sufanmi $

function [y, t] = Doublet(t, startTime, durationTime, Amp, y, flgResizeTime)

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
if (nargin < 4)
   disp([mfnam ' :: Incorrect Number of Inputs.  See ' mlink ' for usage help.' endl]);
   return;
end;

if((nargin < 6) | isempty(flgResizeTime))
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
    it = it + 1; t2add(it) = startTime + durationTime * .5 - tinyDT;
    it = it + 1; t2add(it) = startTime + durationTime * .5;
    it = it + 1; t2add(it) = startTime + durationTime - tinyDT;
    it = it + 1; t2add(it) = startTime + durationTime;
    it = it + 1; t2add(it) = startTime + durationTime * 2;
    
    % Add those times to the provide time vector:
    tNew = unique([t t2add]);
else
    tNew = t;
end

if(nargin < 5)
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

if ((sizet(1) ~= 1) || (sizey(1) ~= 1))
    errstr = [mfnam ' ERROR: t and y must be [1 x N].'...
        endl tab tab tab '   t=[%d x %d] is y=[%d x %d]'];
    error([mfnam 'CSA:SignalGenerators:DimensionError'],errstr, ...
          sizet(1), sizet(2), sizey(1), sizey(2));
end

if (sizet(2) ~= sizey(2))
    errstr = [mfnam ' ERROR: t and y must be of same dimension.'...
        endl tab tab tab '   t=[1 x %d] is y=[1 x %d]'];
    error([mfnam 'CSA:SignalGenerators:DimensionError'],errstr, ...
          sizet(2), sizey(2));
end

% Warnings for out of bounds:
if(startTime > max(t))
    disp(['Warning : Start Time of Doublet (' num2str(startTime) ' [sec])' ...
         ' exceeds the' endl '          maximum inputted time value (' num2str(max(t)) ' [sec])!']);
    disp('          Doublet will NOT be created and/or added');
end

if(startTime < min(t))
    disp(['Warning : Start Time of Doublet (' num2str(startTime) ' [sec])' ...
        ' preceeds the' endl '          minimum inputted time value (' num2str(min(t)) ' [sec])!']);
    disp('          Doublet will NOT be created and/or added');
end

%% Main Function:
% Get Indices of timesteps where the step up occurs:
ii = find((t>=startTime) & (t<(startTime + durationTime/2)));
y(ii) = y(ii) + Amp;

% Get Indices of timesteps where the step down occures:
jj = find((t>=(startTime + durationTime/2)) & (t<(startTime + durationTime)));
y(jj) = y(jj) - Amp;

end % << End of function Doublet >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110426 MWS: Added ability of function to auto create time vector if it is
%              not provided.  Added example #3.
% 100910 JPG: Started Filling in the Function per CoSMO format.
% 100910 CNF: Function template created using CreateNewFunc.
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
