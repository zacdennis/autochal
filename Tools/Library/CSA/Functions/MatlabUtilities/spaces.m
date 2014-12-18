% SPACES Returns a blank string with a user specified number of spaces
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% spaces:
%     Returns a blank string with a user specified number of spaces
% 
% SYNTAX:
%	[str] = spaces(numSpaces)
%
% INPUTS: 
%	Name		Size            Units		Description
%	numSpaces	[1x1]           [int]		Number of spaces desired
%
% OUTPUTS: 
%	Name		Size            Units		Description
%	str 		[1 x numSpaces]	N/A         Blank String
%
% NOTES:
%	Very useful for formatting purposes
%
% EXAMPLES:
%	 Example 1: generate 10 spaces between 2 words
% 	[str]  = spaces(10);
%   result = ['Hello' str 'world']
%   returns: result = Hello          world
%
% 	Example 2: Generate spaces for a table's heading
% 	[str] = spaces(10);
%   table_heading = ['Name' str 'Number' str 'Age']
%   returns: table_heading = Name          Number          Age
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit spaces.m">spaces.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_spaces.m">DRIVER_spaces.m</a>
%	  Documentation: <a href="matlab:pptOpen('spaces_Function_Documentation.pptx');">spaces_Function_Documentation.pptx</a>
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/467
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/spaces.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [str] = spaces(numSpaces)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Input Argument Conditioning:
if(nargin > 1)
    disp([mfnam '>> ERROR: Too many input arguments.  See <a href="matlab:help spaces.m">help spaces.m</a>']);
    disp([mfspc '          ' num2str(nargin) ' only 1 required']);
    error([mfnam ':InputArgCheck'], 'Too many Input Arguments');
end

if(ischar(numSpaces))
    disp([mfnam '>> ERROR: Input of type string or CHAR.Please provide a scalar  See <a href="matlab:help spaces.m">help spaces</a>']);
  
    error([mfnam ':InputArgCheck'], 'Input of type string or char');
end

if isempty(numSpaces)
     error([mfnam ':InputArgCheck'], 'Input empty. Please provide the number of spaces')
end
%% Main Function:
str = '';
for i = 1:numSpaces
    str = [str ' '];    %#ok<AGROW>
end

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100824  JJ: Filled the description and units of the I/O added input check
% 100819 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         :  Email                            : NGGN Username 
% JJ: Jovany Jimenez    : Jovany.Jimenez-Deparias@ngc.com   : g67086 

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
