% AREACURVE Computes the area under a time-history curve
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% areaCurve:
%     Computes the area under a time-history curve
% 
% SYNTAX:
%	[valArea] = areaCurve(arrTimeRaw, arrYRaw, limitsTime)
%	[valArea] = areaCurve(arrTimeRaw, arrYRaw)
%
% INPUTS: 
%	Name      	Size	Units		Description
%   arrTime     [1xM]   [time]      Time-array
%   arrY        [1xM]   [amp]       Time-history curve
%   limitsTime  [2]     [time]      Upper and lower bounds of Time to take
%                                    area of
%
% OUTPUTS: 
%	Name      	Size	Units		Description
%   valArea     [1]     [amp-time]  Area under time-history curve
%
% NOTES:
%	<Any Additional Information>
%
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[valArea] = areaCurve(arrTimeRaw, arrYRaw, limitsTime, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[valArea] = areaCurve(arrTimeRaw, arrYRaw, limitsTime)
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
%	Source function: <a href="matlab:edit areaCurve.m">areaCurve.m</a>
%	  Driver script: <a href="matlab:edit Driver_areaCurve.m">Driver_areaCurve.m</a>
%	  Documentation: <a href="matlab:pptOpen('areaCurve_Function_Documentation.pptx');">areaCurve_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/406
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/areaCurve.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [valArea] = areaCurve(arrTimeRaw, arrYRaw, limitsTime)

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
valArea= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        limitsTime= ''; arrYRaw= ''; arrTimeRaw= ''; 
%       case 1
%        limitsTime= ''; arrYRaw= ''; 
%       case 2
%        limitsTime= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(limitsTime))
%		limitsTime = -1;
%  end
%% Main Function:
if(nargin == 3)  
    ptrTime1 = find(arrTimeRaw >= limitsTime(1));
    ptrTime2 = find(arrTimeRaw <= limitsTime(2));
    ptrTime = intersect(ptrTime1, ptrTime2);
    
    arrTime = unique([limitsTime arrTimeRaw(ptrTime)]);
    arrY = interp1(arrTimeRaw, arrYRaw, arrTime);
    
else
    arrTime = arrTimeRaw;
    arrY = arrYRaw;
end

numPts = length(arrTime);
y1_plus_y2  = arrY(2:numPts) + arrY(1:numPts-1);
dt          = arrTime(2:numPts) - arrTime(1:numPts-1);

arrArea = (y1_plus_y2).*dt / 2;
valArea = sum(arrArea);

%% Compile Outputs:
%	valArea= -1;

end % << End of function areaCurve >>

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
