% PROPAGATETIMESTEP output a new epoch vector given a start and time passed
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% PropagateTimestep:
%    For a given epoch start time and the amount of time that has passed, the
%    function will output a new epoch vector
% 
% SYNTAX:
%	[NewEpoch] = PropagateTimestep(EpochStart, simtime)
%
% INPUTS: 
%	Name        Size          Units             Description
%  EpochStart   [1x6]or[1x3] [year,month,day    Desired Epoch start time 
%                            ,hour,min,sec]or   for model        
%                            [year,month,day]   [yyyy mm dd hr mn s] or 
%                                               [yyyy mm dd]
%  simtime      [1x1]         [sec]             Elapsed time span (deltaT) 
%                                               in seconds 
%
% OUTPUTS: 
%	Name      	Size		Units               Description
%	NewEpoch	[1x6]		[year,month,day     New epoch date
%                            ,hour,min,sec]or   incorporating the time   
%                            [year,month,day]	elpased.
%                                               [yyyy mm dd hr mn s]
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[NewEpoch] = PropagateTimestep(EpochStart, simtime, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[NewEpoch] = PropagateTimestep(EpochStart, simtime)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
% Book with One Author:
% [2]   Author Last Name, Author First Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
% Book with Two Author:
% [3]   Author #1 Last Name, Author #1 First Name, and Author #2 Full Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit PropagateTimestep.m">PropagateTimestep.m</a>
%	  Driver script: <a href="matlab:edit Driver_PropagateTimestep.m">Driver_PropagateTimestep.m</a>
%	  Documentation: <a href="matlab:pptOpen('PropagateTimestep_Function_Documentation.pptx');">PropagateTimestep_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/394
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/PropagateTimestep.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [NewEpoch] = PropagateTimestep(EpochStart, simtime)

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
NewEpoch= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        simtime= ''; EpochStart= ''; 
%       case 1
%        simtime= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(simtime))
%		simtime = -1;
%  end
%% Main Function:
%% Get New Epoch
timepast = simtime;

%% Add time to initial epoch seconds and cut out minutes
Time.Sec = timepast + EpochStart(6);
 if Time.Sec > 60
     T.min = floor(Time.Sec/60);
     T.srem = Time.Sec - T.min*60;
 else
     T.min = 0;
     T.srem = Time.Sec;
 end

%% Add to epoch minute and cut hours
Time.Min = T.min + EpochStart(5);
 if Time.Min > 60
     T.hr = floor(Time.Min/60);
     T.mrem = Time.Min - T.hr*60;
 else
     T.hr = 0;
     T.mrem = Time.Min;
 end

%% Add to epoch hours and cut days
Time.Hour = T.hr + EpochStart(4);
 if Time.Hour > 24
     T.day = floor(Time.Hour/24);
     T.hrem = Time.Hour - T.day*24;
 else
     T.day = 0;
     T.hrem = Time.Hour;
 end
 
%% Compute new calendar date with carry-over days & leap days
 OldDate = datenum(EpochStart(1),EpochStart(2),EpochStart(3));
 
 NewDate = OldDate + T.day;
 
 NewEpoch = datevec(NewDate);
 NewEpoch(4:6) = [T.hrem, T.mrem, T.srem];

%% Compile Outputs:
%	NewEpoch= -1;

end % << End of function PropagateTimestep >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
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
