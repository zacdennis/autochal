% TBL_2_ND_DATA Converts an n-D table from tabular to structure format
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% tbl_2_nD_Data:
%     Converts an n-D table from tabular to structure format.  Practical
%     example would be for reading in aerodynamic data delivered from aero
%     department.
% 
% SYNTAX:
%	[nD_Data] = tbl_2_nD_Data(tbl, idxIDV, idxDV, varargin, 'PropertyName', PropertyValue)
%	[nD_Data] = tbl_2_nD_Data(tbl, idxIDV, idxDV, varargin)
%	[nD_Data] = tbl_2_nD_Data(tbl, idxIDV, idxDV)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	tbl 	    {2-D cell}  N/A         1 to 6-D table data in tabular format
%	idxIDV      [# of IDV]  [int]       Indices of columns pertaining to
%                                        the n-D table's independent
%                                        variables
%	idxDV       [# of DV]   [int]       Indices of columns pertaining to
%                                        the n-D table's dependent
%                                        variables
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	nD_Data     {struct}    [N/A]       Structure with 1 to 6-D Table Data
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   idxHeader           [int]           3           Table row with
%                                                    description of column
%                                                    data
%   rowDataStart        [int]           4           Table row at which data
%                                                    begins
%
% EXAMPLES:
%   % See 'Driver_tbl_2_nD_Data' for full example.
%
%   % Example #1: Convert simple 2-D table to structure format.  Note that
%   %             there are 2 independent variables (IDV1 & IDV2) and 3
%   %             dependent variables (DV1, DV2, & DV3)
%   % Define 'tbl'
%   clear tbl;
%   tbl(1,1) = {'(DV1 <units>,  DV2 <units>,  DV3 <units>) = fcn(IDV1 [int], IDV2 [int])';
%   tbl(3,1:5) = {'IDV1 [int]', 'IDV2 [int]', 'DV1 <units>', 'DV2 <units>', 'DV3 <units>'};
%   tbl(4,1:5) = {1             1               1               2               3};
%   tbl(5,1:5) = {1             2               2               4               6};
%   tbl(6,1:5) = {1             3               3               6               9};
%   tbl(7,1:5) = {2             1               4               8               12};
%   tbl(8,1:5) = {2             2               5               10              15};
%   tbl(9,1:5) = {2             3               6               12              18};
%   % Define column indices of independent variables
%   idxIDV = [1 2];
%   % Define column indices of dependent variables
%   idxDV = [3 4 5];
%   % Convert the table data into nD structure format:
%	[nD_Data] = tbl_2_nD_Data(tbl, idxIDV, idxDV)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit tbl_2_nD_Data.m">tbl_2_nD_Data.m</a>
%	  Driver script: <a href="matlab:edit Driver_tbl_2_nD_Data.m">Driver_tbl_2_nD_Data.m</a>
%	  Documentation: <a href="matlab:winopen(which('tbl_2_nD_Data_Function_Documentation.pptx'));">tbl_2_nD_Data_Function_Documentation.pptx</a>
%
% See also nD_Data_2_tbl
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/786
%  
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/tbl_2_nD_Data.m $
% $Rev: 3035 $
% $Date: 2013-10-16 17:26:00 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [nD_Data] = tbl_2_nD_Data(tbl, idxIDV, idxDV, varargin)

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
% nD_Data= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[idxHeader, varargin]       = format_varargin('idxHeader', 3, 2, varargin);
idxHeader = floor(idxHeader);
idxHeader = max(idxHeader, 1);

[idxHeaderUnits, varargin]  = format_varargin('idxHeaderUnits', idxHeader, 2, varargin);
idxHeaderUnits = floor(idxHeaderUnits);
idxHeaderUnits = max(idxHeaderUnits, 1);
flgUnitsOnDifferentRow = (idxHeaderUnits ~= idxHeader);

rowDataStart = idxHeaderUnits + 1;
[rowDataStart, varargin]    = format_varargin('rowDataStart', rowDataStart, 2, varargin);
rowDataStart = floor(rowDataStart);

%% Main Function:
[numRows, numCols] = size(tbl);

nD_Data.Description = '';
idxTitle = idxHeader - 2;
if(idxTitle > 0)
    nD_Data.Description = tbl{idxTitle,1};
end

%%

numIDV = length(idxIDV);
arr_lengthIDV = zeros(1, numIDV);
lstIDV = cell(numIDV, 3);

for iIDV = 1:numIDV
    cur_idxIDV = idxIDV(iIDV);
    str_IDV = tbl{idxHeader, cur_idxIDV};
    [str_IDV, str_IDV_units] = strtok(str_IDV);
    if(flgUnitsOnDifferentRow)
        str_IDV_units = tbl{idxHeaderUnits, cur_idxIDV};
        if(isnan(str_IDV_units))
            str_IDV_units = '';
        end
    end
    str_IDV_units = strtrim(str_IDV_units);
    str_IDV_units = [ '[' str_IDV_units ']' ];
    str_IDV_units = strrep(str_IDV_units, '[[', '[');
    str_IDV_units = strrep(str_IDV_units, ']]', ']');
    cur_IDV = cell2mat( tbl(rowDataStart:numRows, cur_idxIDV) );
    
    arr_IDV = unique(cur_IDV)';
    nD_Data.(str_IDV) = arr_IDV;
    arr_lengthIDV(iIDV) = length(arr_IDV);
    lstIDV{iIDV, 1} = str_IDV;
    lstIDV{iIDV, 2} = str_IDV;
    lstIDV{iIDV, 3} = str_IDV_units;
end

%%
numDV = length(idxDV);
lstDV = cell(numDV, 3);

for iDV = 1:numDV
    cur_idxDV = idxDV(iDV);
    str_DV = tbl{idxHeader, cur_idxDV};
    [str_DV, str_DV_units] = strtok(str_DV);
    if(flgUnitsOnDifferentRow)
        str_DV_units = tbl{idxHeaderUnits, cur_idxDV};
           if(isnan(str_DV_units))
            str_DV_units = '';
        end
    end
    str_DV_units = strtrim(str_DV_units);
    str_DV_units = [ '[' str_DV_units ']' ];
    str_DV_units = strrep(str_DV_units, '[[', '[');
    str_DV_units = strrep(str_DV_units, ']]', ']');
    
    nD_Data.(str_DV) = zeros(arr_lengthIDV);
    lstDV{iDV, 1} = str_DV;
    lstDV{iDV, 2} = str_DV;
    lstDV{iDV, 3} = str_DV_units;
end

%%
index_ref_IDV = zeros(1,numIDV);
for iRow = rowDataStart:numRows
    
    % Process IDV
    for iIDV = 1:numIDV
        str_IDV = lstIDV{iIDV, 1};
        cur_idxIDV = idxIDV(iIDV);
        cur_IDV = tbl{iRow, cur_idxIDV};
        index_ref_IDV(iIDV) = find(nD_Data.(str_IDV) == cur_IDV);
    end
    
    for iDV = 1:numDV
        str_DV = lstDV{iDV, 1};
        cur_idxDV = idxDV(iDV);
        cur_DV = tbl{iRow, cur_idxDV};
        
         ec = sprintf('nD_Data.%s(', str_DV);
        for iIDV = 1:numIDV
            if(iIDV < numIDV)
                ec = sprintf('%s%d,', ec, index_ref_IDV(iIDV));
            else
                ec = sprintf('%s%d) = cur_DV;', ec, index_ref_IDV(iIDV));
            end
        end
        eval(ec);
    end
end

end % << End of function tbl_2_nD_Data >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 130108 <INI>: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username 
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
