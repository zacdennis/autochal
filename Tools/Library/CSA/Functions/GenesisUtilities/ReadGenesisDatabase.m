% READGENESISDATABASE Loads tables stored in a GENESIS Database file
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ReadGenesisDatabase:
%   Loads in n-D (1 to 4) tables stored in a GENESIS database file.
%
%   GENESIS (General Environment for the Simulation of Integrated Systems)
%   is a bread-and-butter six-degree-of-freedom (6-DOF) simulation tool
%   used to model and analyze integrated systems. GENESIS was developed
%   primarily for airplanes, but has also been used to model missiles,
%   bombs, automobiles, and underwater vehicles. GENESIS is command-line
%   driven and has been hosted on VMS, UNIX, and DOS-based systems.  It was
%   written entirely in Fortrann 77.
%
%   Data for multi-dimensional tables are stored in script format.
%   Multiple tables can be stored in a single file.  This function loads in
%   data from a list of files.  Any comments contained in the header and/or
%   body are included in the extracted tables.
%
% SYNTAX:
%	[tblData] = ReadGenesisDatabase(lstFiles, flgVerbose)
%	[tblData] = ReadGenesisDatabase(lstFiles)
%
% INPUTS:
%	Name    	Size		Units		Description
%	lstFiles	{'string'}  {[char]}    List of database files to open
%   flgVerbose  [1]         [bool]      Show progress as it happens?
%                                        Default is 1 (true)
%
% OUTPUTS:
%	Name    	Size		Units		Description
%	tblData     {struct}    [N/A]       Genesis table data
%
% NOTES:
%   tblData.(<TableName>_<TableID>) =
%              Title: '<TableName>  <TableID>   <DateCreated>'
%     HeaderComments: ''
%           Comments: ''
%        DateCreated: '<DateCreated>'
%              Usage: '<TableName>= fcn(<IDV 1>, <IDV 2>, ...)'
%            <IDV 1>: Breakpoints for independent variable #1
%            <IDV 2>: Breakpoints for independent variable #2 (if applicable)
%            <IDV 3>: Breakpoints for independent variable #3 (if applicable)
%            <IDV 4>: Breakpoints for independent variable #4 (if applicable)
%        <TableName>: nD Table (IDV 1 x IDV 2 x IDV 3 x IDV 4)
%
% EXAMPLES:
%	% Example 1: Load in the sample F-18 data from the unit test folder
%   filename = [fileparts(which('Driver_ReadGenesisDatabase.m')) filesep 'f18_db_aero.dat'];
%	[tblData] = ReadGenesisDatabase(filename)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ReadGenesisDatabase.m">ReadGenesisDatabase.m</a>
%	  Driver script: <a href="matlab:edit Driver_ReadGenesisDatabase.m">Driver_ReadGenesisDatabase.m</a>
%	  Documentation: <a href="matlab:winopen(which('ReadGenesisDatabase_Function_Documentation.pptx'));">ReadGenesisDatabase_Function_Documentation.pptx</a>
%
% See also editorservices str2cell
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/764
%
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/GenesisUtilities/ReadGenesisDatabase.m $
% $Rev: 2565 $
% $Date: 2012-10-22 18:48:18 -0500 (Mon, 22 Oct 2012) $
% $Author: sufanmi $

function [tblData] = ReadGenesisDatabase(lstFiles, flgVerbose)

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
tblData= {};

%% Input Argument Formatting:
% Ensure it's a cell array
if(ischar(lstFiles))
    lstFiles = {lstFiles};
end

if(nargin < 2)
    flgVerbose = [];
end

if(isempty(flgVerbose))
    flgVerbose = 1;
end

%% Main Function:
numFiles = size(lstFiles, 1);
for iFile = 1:numFiles
    % Loop through each file:
    filename = lstFiles{iFile,:};
    
        % Open the file and retrieve its text
    try
        % 2011a & later
        filedata = matlab.desktop.editor.openDocument(which(filename));
    catch
        % 2010b & earlier
        filedata = editorservices.open(which(filename));
    end
    
    cellText = str2cell(filedata.Text, endl);
    numRows = size(cellText, 1);
    
    iRow = 0;
    iTbl = 0;
    [curRow, iRow, HeaderComments] = GetLine(cellText, iRow);
    
    while iRow <= numRows
        tbl = {};
        tbl.Title = '';
        tbl.HeaderComments = '';
        tbl.Comments = '';
        tbl.DateCreated = '';
        tbl.Usage = '';
        tbl.InterpCall = '';
        tbl.lstIDVs = '';

        %  Table #, # of IDV, len(IDV 1), len(IDV 2), len(IDV 3), len(IDV 4)
        
        % It's a new table
        flgInProgress = 1;
        arrTblInfo = str2num(curRow);
        idTable = arrTblInfo(1);
        numIDV  = arrTblInfo(2);
        lenIDV1 = arrTblInfo(3);
        lenIDV2 = arrTblInfo(4);
        lenIDV3 = arrTblInfo(5);
        lenIDV4 = arrTblInfo(6);
                
        % Get IDV1
        [strIDV1, iRow] = GetLine(cellText, iRow);
        [arrIDV1, iRow] = GetArrayData(cellText, lenIDV1, iRow);
        numPts = lenIDV1;
        tbl.(strIDV1) = arrIDV1;
        strUsageIDV = sprintf('= fcn(%s', strIDV1);
        lstIDVs = { strIDV1 };
        
        if(numIDV > 1)
            % Get IDV2
            [strIDV2, iRow] = GetLine(cellText, iRow);
            [arrIDV2, iRow] = GetArrayData(cellText, lenIDV2, iRow);
            numPts = numPts * lenIDV2;
            tbl.(strIDV2) = arrIDV2;
            strUsageIDV = sprintf('%s, %s', strUsageIDV, strIDV2);
            lstIDVs = [lstIDVs; strIDV2];
        end
        
        if(numIDV > 2)
            % Get IDV3
            [strIDV3, iRow] = GetLine(cellText, iRow);
            [arrIDV3, iRow] = GetArrayData(cellText, lenIDV3, iRow);
            numPts = numPts * lenIDV3;
            tbl.(strIDV3) = arrIDV3;
            strUsageIDV = sprintf('%s, %s', strUsageIDV, strIDV3);
            lstIDVs = [lstIDVs; strIDV3];
        end
        
        if(numIDV > 3)
            % Get IDV4
            [strIDV4, iRow] = GetLine(cellText, iRow);
            [arrIDV4, iRow] = GetArrayData(cellText, lenIDV4, iRow);
            numPts = numPts * lenIDV4;
            tbl.(strIDV4) = arrIDV4;
            strUsageIDV = sprintf('%s, %s', strUsageIDV, strIDV3);
            lstIDVs = [lstIDVs; strIDV4];
        end
        
        strUsageIDV = sprintf('%s)', strUsageIDV);
        
        flgGettingDPV = 1;
        [curRow, iRow] = GetLine(cellText, iRow);
        
        while(flgGettingDPV)
            
            % Get DPV
            strDVInfo = curRow;
            tbl.Title = strDVInfo;
            [strDV, leftover] = strtok(strDVInfo, ' ');
            [strTblID, leftover] = strtok(leftover, ' ');
            if(~isempty(leftover))
                DateCreated = strtok(leftover);
            else
                DateCreated = 'UNK';
            end
            
            [arrData, iRow, tblComments] = GetArrayData(cellText, numPts, iRow);
            
            switch numIDV
                case 1
                    tblND = arrData;
                case 2
                    tblND = reshape(arrData, [lenIDV1 lenIDV2]);
                case 3
                    tblND = reshape(arrData, [lenIDV1 lenIDV2 lenIDV3]);
                case 4
                    tblND = reshape(arrData, [lenIDV1 lenIDV2 lenIDV3 lenIDV4]);
            end

            tbl.Usage = sprintf('%s %s', strDV, strUsageIDV);
            
            tbl.DateCreated = DateCreated;
            if(~isempty(HeaderComments))
                tbl.HeaderComments = HeaderComments;
            end
            
            if(~isempty(tblComments))
                tbl.Comments = tblComments;
            end
            
            strDVfull = [strDV '_' strTblID];
            
            % Build InterpND call
            strTbl = ['tbl.' strDVfull '.'];
            switch numIDV
                case 1
                    strInterp = sprintf('%s = Interp1D(%s%s, %s%s, cur_%s)', ...
                        strDV, strTbl, strIDV1, strTbl, strDV, strIDV1);
                case 2
                    strInterp = sprintf('%s = Interp2D(%s%s, %s%s, %s%s, cur_%s, cur_%s)', ...
                        strDV, strTbl, strIDV1, strTbl, strIDV2, strTbl, strDV, strIDV1, strIDV2);
                case 3
                    strInterp = sprintf('%s = Interp3D(%s%s, %s%s, %s%s, %s%s, cur_%s, cur_%s, cur_%s)', ...
                        strDV, strTbl, strIDV1, strTbl, strIDV2, strTbl, strIDV3, strTbl, strDV, strIDV1, strIDV2, strIDV3);
                case 4
                    strInterp = sprintf('%s = Interp4D(%s%s, %s%s, %s%s, %s%s, %s%s, cur_%s, cur_%s, cur_%s, cur_%s)', ...
                        strDV, strTbl, strIDV1, strTbl, strIDV2, strTbl, strIDV3, strTbl, strIDV4, strTbl, strDV, strIDV1, strIDV2, strIDV3, strIDV4);
            end
            tbl.InterpCall = strInterp;
            tbl.lstIDVs = lstIDVs;
            
            tblData.(strDVfull) = tbl;
            tblData.(strDVfull).(strDV) = tblND;

            %
            iTbl = iTbl + 1;
            if(flgVerbose)
                disp(sprintf('%3d: %s', iTbl, tbl.Usage));
            end
            
            [curRow, iRow, HeaderComments] = GetLine(cellText, iRow);
            
            if(isempty(curRow))
                flgGettingDPV = 0;
            else
                try
                    arrTblInfo = str2num(curRow);
                    if(length(arrTblInfo) == 6)
                        % It's a brand new table
                        flgGettingDPV = 0;
                    end
                catch
                    flgGettingDPV = 1;
                    % It's a new dependent variable
                    % Keep information on independent variables
                end
            end
        end
    end
end

if(flgVerbose)
    disp(sprintf('%s : Finished! %d tables created.', mfnam, iTbl));
end

if(nargout == 0)
    assignin('base', 'tblData', tblData);
end

end % << End of function ReadGenesisDatabase >>

%%
function [curline, iRow, curComment] = GetLine(cellText, iRowLast, prevComment)

if(nargin < 3)
    prevComment = '';
end
curComment = prevComment;

strComment = '*';
lenComment = length(strComment);

numRows = size(cellText, 1);
iRow = iRowLast + 1;
curline = '';
if(iRow <= numRows)
    curline = cellText{iRow,:};
    if(strcmp(strComment, curline(1:lenComment)))
        % It's a comment, ignore it and keep going until you get to a
        % non-commented out line (ie Recurse)
        if(length(curline) > lenComment)
            if(isempty(prevComment))
                curComment = curline;
            else
                endl = sprintf('\n');
                curComment = [prevComment endl curline];
            end
        end
        [curline, iRow, curComment] = GetLine(cellText, iRow, curComment);
    end
    curline = strtrim(curline);
end

end

%%
function [arrData, iRow, tblComments] = GetArrayData(cellText, numPts, iRow)

arrData = zeros(1, numPts);
iStart = 1;
iEnd = 0;
tblComments = [];
endl = sprintf('\n');

while iEnd < numPts
    [strData, iRow, curComments] = GetLine(cellText, iRow);
    arrData2Add = str2num(strData);
    lenData2Add = length(arrData2Add);
    iEnd = iStart + lenData2Add - 1;
    arrData(iStart:iEnd) = arrData2Add;
    iStart = iEnd + 1;
    
    if(~isempty(curComments))
        if(isempty(tblComments))
            tblComments = curComments;
        else
            tblComments = [tblComments endl curComments];
        end
    end
    
end

end

%% REVISION HISTORY
% YYMMDD INI: note
% 120924 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName         : Email                 : NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi

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
