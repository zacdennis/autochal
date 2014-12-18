% GETSAMPLEATTIME Retrieves the value at a particular time in a timeseries
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% getsampleattime:
%     Retrieves the value at a particular time in a timeseries
% 
% SYNTAX:
%	[val] = getsampleattime(ts, timeval, idxMember, varargin, 'PropertyName', PropertyValue)
%	[val] = getsampleattime(ts, timeval, idxMember, varargin)
%	[val] = getsampleattime(ts, timeval, idxMember)
%	[val] = getsampleattime(ts, timeval)
%
% INPUTS: 
%	Name     	Size		Units		Description
%   ts                      Timeseries
%   timeval     [time]      Time value to retrieve
%   idxMember   [1xm]       Indices of timeseries columns to retrieve (only
%                           used if the timeseries is a vector) Default is
%                           all columns
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%   val         [1xn]       Data at timeval
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
%	[val] = getsampleattime(ts, timeval, idxMember, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[val] = getsampleattime(ts, timeval, idxMember)
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
%	Source function: <a href="matlab:edit getsampleattime.m">getsampleattime.m</a>
%	  Driver script: <a href="matlab:edit Driver_getsampleattime.m">Driver_getsampleattime.m</a>
%	  Documentation: <a href="matlab:pptOpen('getsampleattime_Function_Documentation.pptx');">getsampleattime_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/517
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/getsampleattime.m $
% $Rev: 2953 $
% $Date: 2013-05-13 19:56:21 -0500 (Mon, 13 May 2013) $
% $Author: sufanmi $

function [val] = getsampleattime(ts, timeval, varargin)

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
% val= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[HoldEndpoint, varargin]  = format_varargin('HoldEndpoint', false, 2, varargin);
idxMember = varargin;

%% Main Function:
arrTime = ts.Time;
arrVal = ts.Data;

iptr1 = find(arrTime >= timeval(1), 1);

if(HoldEndpoint)
    if(timeval(1) > arrTime(end))
        iptr1 = length(arrTime);
    end
end

if(length(timeval) == 2)
    iptr2 = find(arrTime >= timeval(2), 1);
else
    iptr2 = iptr1;
end

if(nargin == 3)
    val = arrVal(iptr1:iptr2, idxMember);
else
    val = arrVal(iptr1:iptr2,:);
end

%% Compile Outputs:
%	val= -1;

end % << End of function getsampleattime >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
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
