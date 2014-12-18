% LISTLIB Lists all blocks in a Library
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ListLib:
%   Lists all the blocks in a given Simulink Library.  This is achieved by
%   finding all 'subsystems' in the given library using 'find_system' and
%   then looping through all those and weeding out only the ones that have
%   their PortConnectivity set to -1.  Users can further narrow down the
%   search results by providing additional Block paramters in sets of two.
%
% SYNTAX:
%	[lstLib, numLib] = ListLib(nameLib, 'BlockParameter', BlockValue, varargin)
%	[lstLib, numLib] = ListLib(nameLib, 'BlockParameter', BlockValue)
%	[lstLib, numLib] = ListLib(nameLib)
%	[lstLib, numLib] = ListLib()
%
% INPUTS:
%	Name        Size        Units	Description
%	nameLib     'string'    N/A     Desired Simulink Library
%                                    Default: bdroot
%   varargin
%
% OUTPUTS:
%	Name        Size        Units	Description
%	lstLib      {nx1}       N/A     Cell array of strings with full paths
%                                    to all library blocks
%   numLib      [1]         [int]   Number of library blocks found
%
% NOTES:
%
% EXAMPLE:
%   % List all the blocks in the 'CSA_Library'
%   [lstLib, numLib] = ListLib('CSA_Library')
%   % lstLib =
%   %     'CSA_Library/Actuators/FirstOrderActuator_ExternalIC'
%   %     'CSA_Library/Actuators/Gear_Rate_Integration'
%   %      ...
%   %     'CSA_Library/Utilities/unwrap'
%   % numLib =
%   %    204
%
%   % List all blocks in the 'CSA_Library' who are not set to be atomic
%   % Two call options:
%   [lstLib, numLib] = ListLib('CSA_Library','TreatAsAtomicUnit','off')
%   [lstLib, numLib] = ListLib('CSA_Library','TreatAsAtomicUnit','~on')
%
%   % List all blocks in the 'CSA_Library' whose backgrounds are not cyan
%   [lstLib, numLib] = ListLib('CSA_Library','TreatAsAtomicUnit','~cyan')
%
%   % List all blocks in the 'CSA_Library' and write results to Excel
%   [lstLib, numLib] = ListLib('CSA_Library','WriteToFile',1)
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ListLib.m">ListLib.m</a>
%	  Driver script: <a href="matlab:edit Driver_ListLib.m">Driver_ListLib.m</a>
%	  Documentation: <a href="matlab:winopen(('ListLib Documentation.pptx'));">ListLib Documentation.pptx</a>
%
% See also find_system, get_param, isblock, format_varargin
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/691
%
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/ListLib.m $
% $Rev: 3028 $
% $Date: 2013-10-16 13:18:40 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [lstLib, numLib] = ListLib(nameLib, varargin)

%% Debugging & Display Utilities
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats ...
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

[flgIncludeDescription, varargin]   = format_varargin('IncludeDescription', false, 2, varargin);
[WriteToFile, varargin]             = format_varargin('WriteToFile', false, 2, varargin);
[OpenAfterWrite, varargin]          = format_varargin('OpenAfterWrite', true, 2, varargin);
[CatalogFolder, varargin]           = format_varargin('CatalogFolder', pwd, 2, varargin);
[CatalogFilename, varargin]         = format_varargin('CatalogFilename', '', 2, varargin);
[block_fullname, varargin]          = format_varargin('BlockName', '', 2, varargin);
[IncludeVerification, varargin]     = format_varargin('IncludeVerification', true, 2, varargin);

%% Initialize Outputs
lstLib = {};
numLib = 0;

%% Input Argument Conditioning
%  Example:
if(nargin < 1)
    nameLib = bdroot;
end

if(isempty(CatalogFilename))
    CatalogFilename = [nameLib '_Catalog.xlsx'];
end
[~, ~, ext] = fileparts(CatalogFilename);
if(isempty(ext))
    CatalogFilename = [CatalogFilename '.xlsx'];
end

fullfile = [CatalogFolder filesep CatalogFilename];
if(exist(fullfile))
    delete(fullfile);
end

%% Main Function
i = 0;
i = i + 1; iCtr = i;
i = i + 1; iFullPath = i;
i = i + 1; iBlockName = i;
i = i + 1; iBlockType = i;
i = i + 1; iDescription = i;
i = i + 1; iVerifiedBool = i;
i = i + 1; iVerifiedStr = i;

lstOpenDiagrams = find_system('type', 'block_diagram');
flgIsOpen = any(strcmp(lstOpenDiagrams, nameLib));

load_system(nameLib);
lstSubs     = find_system(nameLib, 'BlockType', 'SubSystem');
lstSFcns    = find_system(nameLib, 'BlockType', 'S-Function');
lstBlocks   = [lstSubs; lstSFcns];

numBlocks = size(lstBlocks,1);
iCtr = 0;   % Initialize Counter

for iBlock = 1:numBlocks
    curBlock = lstBlocks{iBlock};
    
    try
        portData = get_param(curBlock, 'PortConnectivity');
        
        if(~isempty(portData))
            % The Blocks got Ports
            % Check to see if they're connected
            
            nPorts = size(portData, 1);
            flgAdd = 1;
            for iPort = 1:nPorts
                curPort = portData(iPort);
                
                if(~isempty(curPort.SrcBlock))
                    if(curPort.SrcBlock ~= -1)
                        flgAdd = 0;
                    end
                else
                    if(~isempty(curPort.DstBlock))
                        flgAdd = 0;
                    end
                end
            end
            
            if(flgAdd)
                num_varargin = length(varargin);
                if(num_varargin > 0)
                    
                    for i = 1:ceil(num_varargin/2)
                        cur_param = varargin{2*i-1};
                        cur_param_val_token = varargin{2*i};
                        
                        cur_param_val = get_param(curBlock, cur_param);
                        
                        if(strcmp(cur_param_val_token(1), '~'))
                            cur_param_val_token = cur_param_val_token(2:end);
                            
                            if(strcmp(cur_param_val, cur_param_val_token))
                                flgAdd = 0;
                            end
                        else
                            if(~strcmp(cur_param_val, cur_param_val_token))
                                flgAdd = 0;
                            end
                        end
                    end
                end
                
                if(flgAdd)
                    iCtr = iCtr + 1;
                    lstLib(iCtr,:) = { curBlock };
                end
            end
        end
    catch
        % Must not have been what we were looking for
    end
    numLib = iCtr;
end

if(flgIncludeDescription)
    numBlocks = size(lstLib, 1);
    for iBlock = 1:numBlocks
        curBlock = lstLib{iBlock, :};
        cur_block_full = lstLib{iBlock,:};
        
        idxSlashes = findstr(cur_block_full, '/');
        if(isempty(idxSlashes))
            cur_block_short = cur_block_full;
        else
            cur_block_short = cur_block_full(idxSlashes(end)+1:end);
        end
        
        blockType = get_param(cur_block_full, 'BlockType');
        strOneLine = '';
        
        if(~strcmp(blockType, 'S-Function'))
            
            %% Get DocBlock Text:
            [DocBlockFound, DocBlockHdl] = isblock('DocBlock', cur_block_full);
            if(~DocBlockFound)
                strOneLine = 'Block needs DocBlock!';
                
            else
                DocBlockUserData = get_param(DocBlockHdl, 'UserData');
                
                flgStruct = isstruct(DocBlockUserData);
                if(flgStruct)
                    DocBlockText = DocBlockUserData.content;
                else
                    DocBlockText = DocBlockUserData;
                end
            end
        else
            DocBlockText = get_param(cur_block_full, 'MaskDescription');
        end
        
        if(isempty(DocBlockText))
            strOneLine = 'S-function block needs Description filled out...';
        else
            cellHelp = str2cell(DocBlockText, endl);
            strOneLine = cellHelp{1,:};
            flgGood = ~isempty(strfind(strOneLine, cur_block_short)) ...
                || ~isempty(strfind(strOneLine, upper(cur_block_short)));
            
            if(flgGood)
                % Remove the Block name
                strOneLine = strOneLine(length(cur_block_short)+1:end);
            end
        end
        lstLib(iBlock, 2) = {strOneLine};
    end
end

if(WriteToFile)
    iV_Yes = 0;
    iV_No = 0;
    iV_InQueue = 0;
    numBlocks = size(lstLib, 1);
    lstBlocks = lstLib;
    numTitleLines = 1;
    lstCatalog = cell(numBlocks+numTitleLines, 4);
    iLog = 0;
    
    for iBlock = 1:numBlocks
        curBlock =  lstBlocks{iBlock, 1};
        blockType = get_param(curBlock, 'BlockType');
        ptrSlash = findstr(curBlock, '/');
        curBlockShort = curBlock(ptrSlash(end)+1:end);
        
        if(iBlock == 1)
            % Add title line
            iLog = iLog + 1;
            lstCatalog(iLog, iCtr) = {'Ctr'};
            lstCatalog(iLog, iFullPath) = {'Full Path'};
            lstCatalog(iLog, iBlockName) = {'Block Name'};
            lstCatalog(iLog, iBlockType) = {'Block Type'};
            lstCatalog(iLog, iDescription) = {'Description'};
            if(IncludeVerification)
                lstCatalog(iLog, iVerifiedBool) = {'V&V'};
                lstCatalog(iLog, iVerifiedStr) = {'Verification Details'};
            end
        end
        
        curBlockClean = curBlock;
        curBlockClean = strrep(curBlockClean, endl, ' ');
        curBlockClean = strrep(curBlockClean, char(10), ' ');
        curBlockClean = strtrim(curBlockClean);
        
        curBlockShortClean = curBlockShort;
        curBlockShortClean = strrep(curBlockShortClean, endl, ' ');
        curBlockShortClean = strrep(curBlockShortClean, char(10), ' ');
        curBlockShortClean = strtrim(curBlockShortClean);
        
        iLog = iLog + 1;
        lstCatalog(iLog, iCtr) = {iBlock};
        lstCatalog(iLog, iFullPath) = {curBlockClean};
        lstCatalog(iLog, iBlockName) = {curBlockShortClean};
        lstCatalog(iLog, iBlockType) = {blockType};
        lstCatalog(iLog, iDescription) = {''};
        if(IncludeVerification)
            lstCatalog(iLog, iVerifiedBool) = {0};
            lstCatalog(iLog, iVerifiedStr) = {'Verified: No'};
        end
        str1stLine = '';
        lstContents = {};
        
        switch(blockType)
            case 'SubSystem'
                [flgDocBlock, hdlDocBlock] = isblock('DocBlock', curBlock);
                if(flgDocBlock)
                    UserData = get_param(hdlDocBlock, 'UserData');
                    
                    if(isstr(UserData))
                        lstContents = str2cell(UserData, char(10));
                    else
                        lstContents = str2cell(UserData.content, char(10));
                    end
                    str1stLine = lstContents{1,:};
                else
                    str1stLine = 'DocBlock does NOT exist.  NEED TO ADD.';
                end
                
            case 'S-Function'
                MaskDescription = get_param(curBlock, 'MaskDescription');
                if(isempty(MaskDescription))
                    str1stLine = 'MaskDescription field needs to be fill in.';
                else
                    lstContents = str2cell(MaskDescription);
                    str1stLine = lstContents{1,:};
                end
                
            otherwise
                disp(sprintf('%s got flagged as a %s, INVESTIGATE THIS', curBlock, blockType));
        end
        
        % Remove the Block Name, leaving just the 1-line description
        str1stLine = strrep(str1stLine, [upper(curBlockShort) ' '], '');
        str1stLine = strrep(str1stLine, [curBlockShort ' '], '');
        
        lstCatalog(iLog, 5) = {str1stLine};
        
        if(IncludeVerification)
            % Column for verification count
            k = strfind(lstContents, 'Verified: Yes');
            for iv = 1:length(k)
                if k{iv}
                    lstCatalog(iLog, iVerifiedBool) = {1};
                    break
                end
                lstCatalog(iLog, iVerifiedBool) = {0};
            end
            % Column for verification notes
            k = strfind(lstContents, 'Verified:');
            lstCatalog(iLog, iVerifiedStr) = {'Verified: No'};
            for iv = 1:length(k)
                if k{iv}
                    strVerified = strtrim(lstContents{iv,:});
                    lstCatalog(iLog, iVerifiedStr) = {strVerified};
                    
                    if(strfind(lower(strVerified), 'yes'))
                        iV_Yes = iV_Yes + 1;
                    else
                        iV_No = iV_No + 1;
                        % Note: No plugs yet to support 'In Queue' (ie almost
                        % ready to say Yes)
                    end
                    break
                end
            end
        end
    end
    % Write to Excel
    xlswrite(fullfile, lstCatalog, nameLib);
    
    %% Write Summary
    if(IncludeVerification)
        lstSummary = {};
        lstSummary(1,:) = {'In Library', 'Documented', 'Verified', '% Verified', 'Remaining'};
        lstSummary(2,1) = { sprintf('%d', numBlocks) };
        lstSummary(2,2) = { sprintf('%d', iV_Yes) };
        lstSummary(2,3) = { sprintf('%d', iV_Yes) };
        lstSummary(2,4) = { sprintf('%s', num2str(iV_Yes/numBlocks*100)) };
        lstSummary(2,5) = { sprintf('%d', iV_No) };
        xlswrite(fullfile, lstSummary, [nameLib '_Summary']);
    end
    
    %% Write to Excel
    disp(sprintf('%s : Finished!  Catalog of ''%s'' written to: ''%s''', mfnam, ...
        nameLib, fullfile));
    if(OpenAfterWrite)
        winopen(fullfile);
    end
    
end

% if(~isempty(block_fullname))
%     block_fullname = strrep(block_fullname, '\', '/');
%     ptrSlash = findstr(block_fullname, '/');
%     if(isempty(ptrSlash))
%         lstRefLib = lstLib;
%         cur_block_full = '';
%         block_name = block_fullname;
%
%         flgMatch = 0; iRefLib = 0;
%         while((flgMatch == 0) && (iRefLib < size(lstRefLib, 1)))
%             iRefLib = iRefLib + 1;
%             curRefLib = lstRefLib{iRefLib, :};
%             ptrSlashes = findstr(curRefLib, '/');
%             lastBit = curRefLib(ptrSlashes(end)+1:end);
%             if(strcmp(lastBit, block_name))
%                 flgMatch = 1;
%                 cur_block_full = curRefLib(1:ptrSlashes(end)-1);
%                 lstLib = curRefLib;
%             end
%         end
%
%     else
%         cur_block_full = block_fullname(1:ptrSlash(end)-1);
%         block_name = block_fullname(ptrSlash(end)+1:end);
%         lstLib = block_fullname;
%     end
%     numLib = 1;
%
% end

if(flgIsOpen == 0)
    bdclose(nameLib);
end

end % << End of function ListLib >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101220 MWS: Added ability to return 1st line of DocBlock with list
% 100816 MWS: Created and added to CSA Library using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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