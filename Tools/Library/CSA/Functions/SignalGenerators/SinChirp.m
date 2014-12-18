% SINCHIRP Generates a sinusoidal chirp signal
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% SinChirp:
%     This function generates a linear chirp with the instantaneous 
%   frequency that varies linearly with time.  The user can set various
%   parameters such as start time, duration, starting frequency, ending
%   frequency, starting amplitude, and ending amplitude.
% 
% SYNTAX:
%	[y] = SinChirp(t, startTime, durationTime, startFreq, endFreq, ...
%           startAmp, endAmp)
%	[y] = SinChirp(t, startTime, durationTime, startFreq, endFreq, ...
%           startAmp)
%	[y] = SinChirp(t, startTime, durationTime, startFreq, endFreq)
%	[y] = SinChirp(t, startTime, durationTime, startFreq)
%	[y] = SinChirp(t, startTime, durationTime)
%
% INPUTS: 
%	Name        	Size	Units		Description
%   t               [1xN]   [sec]       Time Array
%   startTime       [1]     [sec]       Chirp Signal Start Time
%   durationTime    [1]     [sec]       Total Duration Time of Chirp
%                                       If empty, duration will last till
%                                       end of the signal.
%   startFreq       [1]     [Hz]        Initial Frequency of Signal
%   endFreq         [1]     [Hz]        Final Frequency of Signal
%   startAmp        [1]     [varies]    Initial Amplitude of Chirp
%   endAmp          [1]     [varies]    Final Amplitude of Chirp
%                                       Default: startFreq = 1;
%                                                endFreq = startFreq + 50;
%                                                startAmp = 1;
%                                                endAmp = startAmp + 10;                                               
%
% OUTPUTS: 
%	Name        	Size	Units		Description
%   y               [1xN]   [varies]    Chirp Signal Time History
%
% NOTES:
%	If durationTime is empty, the function will generate a chirp till the
%	end of the signal.  For choice of time vector t, generate a sampling
%	frequency that is at least twice the frequency of the end frequency. 
%	Improper sampling creates aliasing.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   None
%
% EXAMPLES:
%   Example 1:
%   % Generate a signal that lasts 10 seconds, with a SinChirp that starts 
%   % 2 seconds in, lasting for 6 seconds of the signal.  It starts at a
%   % frequency of 0.01 Hz, ending at a frequency of 10 Hz, and with a
%   % starting amplitude of 1 ending at 5.
%   t = 0:.0001:10;
%	[y] = SinChirp(t, 2, 6, 0.01, 10, 1, 5);
%   plot( t, y);
%
%   Example 2:
%   % Generate a signal that lasts 15 seconds, with a SinChirp that starts 
%   % 5 seconds in, lasting till the end of the signal.  It starts at a
%   % frequency of 0.01 Hz, ending at a frequency of 5 Hz, and with a
%   % starting amplitude of 1 ending at 2.
%   t = 0:.0001:15;
%	[y] = SinChirp(t, 5, [], 0.01, 5, 1, 2);
%   plot( t, y);
%
% SOURCE DOCUMENTATION:
%   None
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit SinChirp.m">SinChirp.m</a>
%	  Driver script: <a href="matlab:edit Driver_SinChirp.m">Driver_SinChirp.m</a>
%	  Documentation: <a href="matlab:pptOpen('SinChirp_Function_Documentation.pptx');">SinChirp_Function_Documentation.pptx</a>
%
% See also Doublet SingleStep StepUpDown
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/312
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21)
%                Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SignalGenerators/SinChirp.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [y] = SinChirp(t, startTime, durationTime, startFreq, endFreq, startAmp, endAmp)

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
y= -1;

%% Input Argument Conditioning:
if (nargin < 3)
   disp([mfnam ' :: Please refer to useage of SinChirp' endl ...
   'Syntax: y = SinChirp(t, startTime, durationTime, startFreq,...' ...
   endl '              endFreq, startAmp, endAmp)' endl ...
   '        y = SinChirp(t, startTime, durationTime, startFreq,...' ...
   endl '              endFreq, startAmp)' endl ...
   '        y = SinChirp(t, startTime, durationTime, startFreq,...' ...
   endl '              endFreq)'  endl ...
   '        y = SinChirp(t, startTime, durationTime, startFreq)'  endl ...
   '        y = SinChirp(t, startTime, durationTime)']);
    return;
end

if isempty(durationTime)
    durationTime = max(t) - startTime;
end

switch nargin
    case 3
    startFreq = 1;
    endFreq = startFreq + 50;
	startAmp = 1;
	endAmp = startAmp + 10;
    case 4
    endFreq = startFreq + 50;
	startAmp = 1;
	endAmp = startAmp + 10;
    case 5
    startAmp = 1;
	endAmp = startAmp + 10; 
    case 6
    endAmp = startAmp + 10;
end

y = t * 0;

if ((1/(t(2)-t(1)))/2 < endFreq)
    disp([mfnam ' >> WARNING: Sampling frequency may not be high enough'...
            endl '                     Aliasing could occur.']);
end

%% Main Function:

kFreq       =   (endFreq - startFreq)/durationTime;
kAmp        =   (endAmp - startAmp)/durationTime;

% Get Indices of timesteps where the chirp occurs:
ii          =   find((t>=startTime) & (t<(startTime + durationTime)));
Amp         =   kAmp*(t(ii)-startTime) + startAmp;
y(ii)       =   Amp.*sin(2.*pi.*(startFreq + (kFreq./2).* ...
                 (t(ii)-startTime)).*(t(ii)-startTime));

end % << End of function SinChirp >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101109 JPG: Added some error checking, default use cases, and examples.
% 101022 JPG: Copied over information from the old function.
% 101022 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720

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
