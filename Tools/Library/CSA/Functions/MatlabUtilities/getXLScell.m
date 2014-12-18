% GETXLSCELL returns the value of a single cell in a MS Excel Table
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% getXLScell:
%   Return the value of a SINGLE cell in a Microsoft Excel Table
%   This function is to be used in conjunction with the output of the 
%   MATLAB 'xlsread' function.  While 'xlsread' is excellent at reading or
%   loading large sections of an Excel table, is it not well accustomed to
%   reading individual cells in quick succession.  'xlsread' is a labor
%   intensive function which should be avoided if possible.  The
%   'getXLScell' function was developed to avoid continous running of the
%   'xlsread' function.  Users only need to retrieve the raw data from a
%   one time 'xlsread' call and feed that as the input (along with the 
%   Excel Table Cell location) into this function.
% 
% SYNTAX:
%	[valueCell] = getXLScell(xlsData, xlsCell)
%
% INPUTS: 
%	Name            Size	Units		Description
%   xlsData         [MxN]   [various]   Raw xls data 
%   xlsCell         [1xN]   [ND]        String of xls cell location  
%
% OUTPUTS: 
%	Name            Size	Units		Description
%   valueCell       [MxN]   [N/A]       Value of designated xls cell
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%
%       [num, txt, raw] = xlsread( xlsFilename, xlsTabname)
%
%       cellvalue = getXLScell( raw, xlsCell )
%
%           where xlsCell is the Microsoft Cell Location (ie. 'B4' or
%           'AA7')
%
%	% <Enter Description of Example #1>
%	[valueCell] = getXLScell(xlsData, xlsCell, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[valueCell] = getXLScell(xlsData, xlsCell)
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
%	Source function: <a href="matlab:edit getXLScell.m">getXLScell.m</a>
%	  Driver script: <a href="matlab:edit Driver_getXLScell.m">Driver_getXLScell.m</a>
%	  Documentation: <a href="matlab:pptOpen('getXLScell_Function_Documentation.pptx');">getXLScell_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/449
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/getXLScell.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [valueCell] = getXLScell(xlsData, xlsCell)

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
% valueCell= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        xlsCell= ''; xlsData= ''; 
%       case 1
%        xlsCell= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(xlsCell))
%		xlsCell = -1;
%  end
%% Main Function:
%% Convert Excel Cell Location into a row and column number:
%   (ie A -> 1, B -> 2, AB -> 28)
colptr = 0;     % Initialize column ptr
for i = 1:length(xlsCell)
    if( isempty(str2num( xlsCell(i) )) )
        colptr = colptr + ( double( upper( xlsCell(i) ) ) - 64 );
    else
        % Retrieve row 
        rowptr = str2num( xlsCell(i:end) );
        break;
    end
end
%   Error Checking:
if ~exist('rowptr')
    disp('ERROR in getXLScell.  Inputted Excel Cell Location does not');
    disp(' have a defined row identifier.  Setting row to 1 to avoid');
    disp(' errors.  Recheck input into getXLScell function.');
    rowptr = 1;
end

%% Retrieve data from Excel Table:
valueCell = cell2mat( xlsData(rowptr, colptr) );

%% Compile Outputs:
%	valueCell= -1;

end % << End of function getXLScell >>

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
