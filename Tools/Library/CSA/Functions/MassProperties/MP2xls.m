% MP2XLS Builds Excel spreadsheet line out of a Mass Property Structure
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% MP2xls:
%     Builds Excel spreadsheet line out of a Mass Property Structure
% 
% SYNTAX:
%	[xlsLine] = MP2xls(MP, strMP, flgTitle, flgMetric)
%	[xlsLine] = MP2xls(MP, strMP, flgTitle)
%	[xlsLine] = MP2xls(MP, strMP)
%	[xlsLine] = MP2xls(MP)
%
% INPUTS: 
%	Name     Size		Units		Description
%   MP       {structure}             Mass Property Structure
%   .Mass               [kg] or [slug]
%   .CG                 [m]  or [ft]
%   .Ixx                [kg-m^2] or [slug-ft^2]
%   .Iyy                [kg-m^2] or [slug-ft^2]
%   .Izz                [kg-m^2] or [slug-ft^2]
%   .Ixy                [kg-m^2] or [slug-ft^2]
%   .Iyz                [kg-m^2] or [slug-ft^2]
%   .Ixz                [kg-m^2] or [slug-ft^2]
%
%   strMP     [string]        Description of MP table
%   flgTitle  [bool]          Provide Column Information Table (default is 0)
%   flgMetric [bool]          MP data is Metric?
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	xlsLine	  <size>		<units>		<Description> 
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
% MP = 
% 
%     Mass: 1
%       CG: [2 3 4]
%      Ixx: 5
%      Iyy: 6
%      Izz: 7
%      Ixy: 8
%      Iyz: 9
%      Ixz: 10
%
% MP2xls(MP, 'Vehicle', 1)
% ans = 
%   Columns 1 through 8
%     'Component'    'Mass [kg]'    'XCG [m]'    'YCG [m]'    'ZCG [m]'    'Ixx [kg-m^2]'    'Iyy [kg-m^2]'    'Izz [kg-m^2]'
%     'Vehicle'      '1.0000'       '2.0000'     '3.0000'     '4.0000'     '5.0000'          '6.0000'          '7.0000'      
% 
%   Columns 9 through 11
%     'Ixy [kg-m^2]'    'Iyz [kg-m^2]'    'Ixz [kg-m^2]'
%     '8.0000'          '9.0000'          '10.0000'      
%
% MP2xls(MP, 'Vehicle', 1,0)
% ans =
% Columns 1 through 7
% 'Component'    'Mass [slug]'    'XCG [ft]'    'YCG [ft]'    'ZCG [ft]'    'Ixx [slug-ft^2]'    'Iyy [slug-ft^2]'
% 'Vehicle'      '1.0000'         '2.0000'      '3.0000'      '4.0000'      '5.0000'             '6.0000'
% 
% Columns 8 through 11
% 'Izz [slug-ft^2]'    'Ixy [slug-ft^2]'    'Iyz [slug-ft^2]'    'Ixz [slug-ft^2]'
% '7.0000'             '8.0000'             '9.0000'             '10.0000'
%
%	% <Enter Description of Example #1>
%	[xlsLine] = MP2xls(MP, strMP, flgTitle, flgMetric, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[xlsLine] = MP2xls(MP, strMP, flgTitle, flgMetric)
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
%	Source function: <a href="matlab:edit MP2xls.m">MP2xls.m</a>
%	  Driver script: <a href="matlab:edit Driver_MP2xls.m">Driver_MP2xls.m</a>
%	  Documentation: <a href="matlab:pptOpen('MP2xls_Function_Documentation.pptx');">MP2xls_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/402
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MassProperties/MP2xls.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [xlsLine] = MP2xls(MP, strMP, flgTitle, flgMetric, varargin)

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
xlsLine= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        flgMetric= ''; flgTitle= ''; strMP= ''; MP= ''; 
%       case 1
%        flgMetric= ''; flgTitle= ''; strMP= ''; 
%       case 2
%        flgMetric= ''; flgTitle= ''; 
%       case 3
%        flgMetric= ''; 
%       case 4
%        
%       case 5
%        
%  end
%
%  if(isempty(flgMetric))
%		flgMetric = -1;
%  end
%% Main Function:
if(nargin < 4)
    flgMetric = 1;
end

if(nargin < 3)
    flgTitle = 0;
end

if(nargin < 2)
    strMP = '';
end

j = 0;
if(flgTitle)
    j = j + 1;
    i = 1;
    if(flgMetric)
        xlsLine(j,i) = {'Component'};       i = i + 1;
        xlsLine(j,i) = {'Mass [kg]'};       i = i + 1;
        xlsLine(j,i) = {'XCG [m]'};         i = i + 1;
        xlsLine(j,i) = {'YCG [m]'};         i = i + 1;
        xlsLine(j,i) = {'ZCG [m]'};         i = i + 1;
        xlsLine(j,i) = {'Ixx [kg-m^2]'};    i = i + 1;
        xlsLine(j,i) = {'Iyy [kg-m^2]'};    i = i + 1;
        xlsLine(j,i) = {'Izz [kg-m^2]'};    i = i + 1;
        xlsLine(j,i) = {'Ixy [kg-m^2]'};    i = i + 1;
        xlsLine(j,i) = {'Iyz [kg-m^2]'};    i = i + 1;
        xlsLine(j,i) = {'Ixz [kg-m^2]'};    i = i + 1;
    else
        xlsLine(j,i) = {'Component'};           i = i + 1;
        xlsLine(j,i) = {'Mass [slug]'};         i = i + 1;
        xlsLine(j,i) = {'XCG [ft]'};            i = i + 1;
        xlsLine(j,i) = {'YCG [ft]'};            i = i + 1;
        xlsLine(j,i) = {'ZCG [ft]'};            i = i + 1;
        xlsLine(j,i) = {'Ixx [slug-ft^2]'};     i = i + 1;
        xlsLine(j,i) = {'Iyy [slug-ft^2]'};     i = i + 1;
        xlsLine(j,i) = {'Izz [slug-ft^2]'};     i = i + 1;
        xlsLine(j,i) = {'Ixy [slug-ft^2]'};     i = i + 1;
        xlsLine(j,i) = {'Iyz [slug-ft^2]'};     i = i + 1;
        xlsLine(j,i) = {'Ixz [slug-ft^2]'};     i = i + 1;
    end
end

j = j + 1;
i = 1;
xlsLine(j,i) = { strMP };   i = i + 1;
xlsLine(j,i) = { sprintf('%0.4f', MP.Mass) };   i = i + 1;
xlsLine(j,i) = { sprintf('%0.4f', MP.CG(1)) };  i = i + 1;
xlsLine(j,i) = { sprintf('%0.4f', MP.CG(2)) };  i = i + 1;
xlsLine(j,i) = { sprintf('%0.4f', MP.CG(3)) };  i = i + 1;
xlsLine(j,i) = { sprintf('%0.4f', MP.Ixx) };    i = i + 1;
xlsLine(j,i) = { sprintf('%0.4f', MP.Iyy) };    i = i + 1;
xlsLine(j,i) = { sprintf('%0.4f', MP.Izz) };    i = i + 1;
xlsLine(j,i) = { sprintf('%0.4f', MP.Ixy) };    i = i + 1;
xlsLine(j,i) = { sprintf('%0.4f', MP.Iyz) };    i = i + 1;
xlsLine(j,i) = { sprintf('%0.4f', MP.Ixz) };    i = i + 1;

%% Compile Outputs:
%	xlsLine= -1;

end % << End of function MP2xls >>

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
