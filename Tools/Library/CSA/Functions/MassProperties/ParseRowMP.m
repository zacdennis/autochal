% PARSEROWMP Utility script for parsing Excel tables with Mass Property Information
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ParseRowMP:
%     Utility script for parsing Excel tables with Mass Property
%     Information
% 
% SYNTAX:
%	[MPs] = ParseRowMP(rowMP, strTitle, lstIndices)
%	[MPs] = ParseRowMP(rowMP, strTitle)
%	[MPs] = ParseRowMP(rowMP)
%
% INPUTS: 
%	Name      	Size		Units		Description
%   rowMP       {1xN}                   Raw cell data from Excel
%   strTitle    [string]                Description of Data
%   lstIndices  {Mx2}                   List of Indices to Read where...
%                                       {:,1}: index in 'rowMP' to read
%                                       {:,2}: fieldname to assign data to
%                       
%                                       Default: lstIndices = {...
%                                               1   'Mass';
%                                               2   'CG(1)';
%                                               3   'CG(2)';
%                                               4   'CG(3)';
%                                               5   'Ixx';
%                                               6   'Iyy';
%                                               7   'Izz';
%                                               8   'Ixy';
%                                               9   'Iyz';
%                                               10  'Ixz' };
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%   MPs         {struct}                Mass Property Structure where...
%                                       (assuming default used)
%                                       .Mass   [1]
%                                       .CG     [3]
%                                       .Ixx, .Iyy, .Izz, etc...
%
% NOTES:
%  This function uses the VSI_LIB function: BuildupInertia
%  See also BuildupInertia
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[MPs] = ParseRowMP(rowMP, strTitle, lstIndices, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[MPs] = ParseRowMP(rowMP, strTitle, lstIndices)
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
%	Source function: <a href="matlab:edit ParseRowMP.m">ParseRowMP.m</a>
%	  Driver script: <a href="matlab:edit Driver_ParseRowMP.m">Driver_ParseRowMP.m</a>
%	  Documentation: <a href="matlab:pptOpen('ParseRowMP_Function_Documentation.pptx');">ParseRowMP_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/404
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MassProperties/ParseRowMP.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [MPs] = ParseRowMP(rowMP, strTitle, lstIndices)

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
MPs= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        lstIndices= ''; strTitle= ''; rowMP= ''; 
%       case 1
%        lstIndices= ''; strTitle= ''; 
%       case 2
%        lstIndices= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(lstIndices))
%		lstIndices = -1;
%  end
%% Main Function:
if(nargin < 2)
    strTitle = '';
end
 
if(nargin < 3)
    lstIndices = {...
        1   'Mass';
        2   'CG(1)';
        3   'CG(2)';
        4   'CG(3)';
        5   'Ixx';
        6   'Iyy';
        7   'Izz';
        8   'Ixy';
        9   'Iyz';
        10  'Ixz';
        };
end
    
MPs.Title = strTitle;

numIndices = size(lstIndices, 1);
lengthRowMP = length(rowMP);

for iIndex = 1:numIndices
    curIndex = lstIndices{iIndex, 1};
    curField = lstIndices{iIndex, 2};
    curValue = 0;

    if(curIndex <= lengthRowMP)
        curValue = rowMP(curIndex);
        if( (~isnumeric(curValue)) || isnan(curValue) )
            curValue = 0;
        end
    end
    ec = ['MPs.' curField ' = curValue;'];
    eval(ec);
end
MPs.Inertia = BuildupInertia(MPs);

%% Compile Outputs:
%	MPs= -1;

end % << End of function ParseRowMP >>

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
