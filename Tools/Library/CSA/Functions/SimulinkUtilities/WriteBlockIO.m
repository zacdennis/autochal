% WRITEBLOCKIO Builds an Excel ICD Spreadsheet for a Simulink block
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% WriteBlockIO:
%   This function auto-generates an Excel spreadsheet containing all the
%   inputs and outputs of a given Simulink block.  The Excel file will
%   contain the same ICD information presented in two different ways
%       1. Each input and output port will have it's own tab
%       2. One 'Full' tab will contain all the ICD information
%
%   Note that if a given port has an associated bus object, this function
%   will use the CSA Function's BO2ResultsList and BO2ResultsList to list
%   all the submembers.
%
% SYNTAX:
%	[lstFiles] = WriteBlockIO(lstBlocks, varargin, 'PropertyName', PropertyValue)
%	[lstFiles] = WriteBlockIO(lstBlocks, varargin)
%	[lstFiles] = WriteBlockIO(lstBlocks)
%	[lstFiles] = WriteBlockIO()
%
% INPUTS:
%	Name     	Size		Units		Description
%	lstBlocks {'string'}    [char]      String or cell array of strings
%                                        listing full path to block in
%                                        question
%                                       Default: gcb
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
% OUTPUTS:
%	Name     	Size		Units		Description
%	lstFiles	{'string'}  [char]      Cell array of strings containing
%                                        full path to file(s) created.  One
%                                        file per each 'lstBlocks' member.
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'SaveFolder'        'string'        pwd         Folder in which to save
%                                                    each ICD.xls file
%   'Verbose'           [bool]          1 (true)    Show details of
%                                                   function as it
%                                                   processes the I/O?
%   'OpenAfterCreated'  [bool]          1 (true)    Open each .xls after it
%                                                   has been created?
%   'Coversheet'        {'strings'}     ''          Any additional (like an
%                                                   ITAR warning) that is
%                                                   to be placed on a
%                                                   coverpage.
%   'IncludeRTCFName'   [bool]          false       Include column with
%                                                    auto-generated RTCF
%                                                    connection point name?
%   'InputStructName'   'string'        'IN'        Name to use for top
%                                                    -level RTCF input
%                                                    structure
%   'OutputStructName'  'string'        'OUT'       Name to use for top
%                                                    -level RTCF output
%                                                    structure
%
%   If 'IncludeRTCFName' is true, RTCF connection point name will assume
%   format of: <TopLevelModel>.<IOStructName>.<PortName>.<SignalName>
%
% EXAMPLES:
%   % Example #1: Write the Block IO for a block whose inputs and outputs
%   %             have bus objects.  In order to do this, we've got to
%   %             create the block.  One way to do that is to create the
%   %             bus objects first and then build test harnesses for them.
%
%   % Create Bus1:
%       lstBO = {
%           'Alpha_deg'     1   ''  '[deg]';
%           'Beta_deg'      1   ''  '[deg]';
%           };
%   BuildBusObject('BOBus1', lstBO);
%   BOInfo.BOBus1 = lstBO; clear lstBO;
%
%   % Create Bus2:
%   lstBO = {
%       'WOW_flg'       1   'boolean'   '[bool]';
%       'Pned_ft'       3   'single'    '[ft]';
%       };
%   BuildBusObject('BOBus2', lstBO);
%   BOInfo.BOBus2 = lstBO; clear lstBO;
%
%   % Create Bus3 which is a combo of Bus1 and Bus2
%   lstBO = {
%       'Bus1'      1,  'BOBus1';
%       'Bus2'      1,  'BOBus2';
%       };
%   BuildBusObject('BOBus3', lstBO);
%   BOInfo.BOBus3 = lstBO; clear lstBO;
%
%   % Now Create the Test Harness
%	CreateTestHarness('BOBus3')
%
%	% Using the Simulink Model that was just created, write the I/O to
%	% file:
%	[lstFiles] = WriteBlockIO('BOBus3_harness/BOBus3_harness')
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit WriteBlockIO.m">WriteBlockIO.m</a>
%	  Driver script: <a href="matlab:edit Driver_WriteBlockIO.m">Driver_WriteBlockIO.m</a>
%	  Documentation: <a href="matlab:pptOpen('WriteBlockIO_Function_Documentation.pptx');">WriteBlockIO_Function_Documentation.pptx</a>
%
% See also BO2ResultsList, BO2ResultsList, GetSignalInfo
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/710
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/WriteBlockIO.m $
% $Rev: 2756 $
% $Date: 2012-12-06 19:55:16 -0600 (Thu, 06 Dec 2012) $
% $Author: sufanmi $

function [lstFiles] = WriteBlockIO(lstBlocks, varargin)

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

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[SaveFolder, varargin]      = format_varargin('SaveFolder', pwd,  2, varargin);
[flgVerbose, varargin]      = format_varargin('Verbose', 1, 0, varargin);
[OpenAfterCreated, varargin]= format_varargin('OpenAfterCreated', true,  2, varargin);
[strCoversheet, varargin]   = format_varargin('Coversheet', '',  2, varargin);
[IncludeRTCFName, varargin] = format_varargin('IncludeRTCFName', false,  2, varargin);
[InputStructName, varargin] = format_varargin('InputStructName', 'IN',  3, varargin);
[OutputStructName, varargin]= format_varargin('OutputStructName', 'OUT',  3, varargin);
[SingleFile, varargin]= format_varargin('SingleFile', true,  3, varargin);
[SingleFilename, varargin]= format_varargin('Filename', 'AllIO.xls',  3, varargin);

flgIncludeIndividualIO = ~SingleFile;

if(~isdir(SaveFolder))
    mkdir(SaveFolder);
end

if(nargin == 0)
    lstBlocks = gcb;
end

if(ischar(lstBlocks))
    lstBlocks = { lstBlocks };
end

%% Main Function:
xls_warn = 'MATLAB:xlswrite:AddSheet';
warning('off', xls_warn);

numBlocks = size(lstBlocks, 1);
for iBlock = 1:numBlocks
    curBlock = lstBlocks{iBlock, 1};
    
    ptrSlash = findstr(curBlock, '/');
    if(isempty(ptrSlash))
        root_sim = curBlock;
        strBlock = curBlock;
    else
        root_sim = curBlock(1:ptrSlash(1)-1);
        strBlock = curBlock(ptrSlash(end)+1:end);
    end
    load_system(root_sim);
    
    strBlock = strrep(strBlock, char(10), '_');
    strBlock = strrep(strBlock, ' ', '_');
    
    if(size(lstBlocks, 2) > 1)
        strBlockXLS = lstBlocks{iBlock, 2};
        if(isempty(strBlockXLS))
            strBlockXLS = strBlock;
        end
    else
        strBlockXLS = strBlock;
    end
    
    strFilename = [SaveFolder filesep strBlockXLS '_IO.xls'];
    
    if(exist(strFilename) == 2)
        try
            delete(strFilename);
        catch
        end
    end
    lstFiles(iBlock,:) = { strFilename };
    
    flgCompile = 0;
    
    % Find all Input ports:
    hInports = find_system(curBlock, 'SearchDepth', 1, 'BlockType', 'Inport');
    nin = size(hInports,1);
    
    % Prep
    tblFull = {};
    
    % Loop through each Input port:
    curPortType = 'Inport';
    for iin = 1:nin
        hPort           = hInports{iin};
        strInport       = get_param(hPort, 'Name');
        strInport       = strrep(strInport, char(10), ' ');
        hPortParent     = get_param(hPort, 'Parent');
        strBusObject    = get_param(hPort, 'BusObject');
        idxPort         = get_param(hPort, 'Port');
        strEdit         = sprintf('%s/%s (Inport #%s)', hPortParent, strInport, idxPort);
        
        if(~strcmp(strBusObject, 'BusObject'))
            % Port has a bus object associated with it
            lstSignals          = BO2ResultsList(strBusObject);
            lstSignalsWithType  = BusObject2List(strBusObject);
            lstSignals          = [lstSignals lstSignalsWithType(:,3)];
        else
            strBusObject = '<None>';
            
            if(flgCompile == 0)
                TerminateSim(root_sim, 0);
                eval_cmd = ['[sys, X, States, ts] = ' root_sim '([],[],[],''compile'');'];
                eval(eval_cmd);
                flgCompile = 1;
            end
            
            dimPortData = get_param(hPort, 'CompiledPortWidths');
            numSignals = dimPortData.Outport;
            lstSignals = {strInport numSignals '[Unknown]' 'double'};
        end
        
        strPort = ['Inport #' num2str(iin)];
        
        if(flgVerbose)
            disp(sprintf('%s :  Tracing %s - %s; %s...', mfnam, ...
                strBlock, strPort, strInport));
        end
        
        [lstUsed, lstUnused, SignalTrace] = GetSignalInfo(hPort);
        
        if(isempty(InputStructName))
            strRTCFRoot = curBlock;
        else
            strRTCFRoot = [curBlock '.' InputStructName];
        end
        tblTab = PortInfo2tbl( strPort, strInport, strBusObject, lstSignals, lstUsed, IncludeRTCFName, strRTCFRoot );
        
        if(flgIncludeIndividualIO)
            xlswrite(strFilename, tblTab, strPort);
            
            if(flgVerbose)
                disp(sprintf('%s : Writing ICD for %s - %s: %s', mfnam, ...
                    strBlock, strPort, strInport));
            end
        end
        
        tblFull = [tblFull; tblTab]; % ok<AGROW>
        tblWidth = size(tblTab, 2);
        blankLines = cell(2,tblWidth);
        tblFull = [tblFull; blankLines]; % ok<AGROW>
        
    end
    
    %% Figure out Outputs
    hOutports = find_system(curBlock, 'SearchDepth', 1, 'BlockType', 'Outport');
    nout = size(hOutports,1);
    lstModelOutputs = {};
    
    % Loop through each output port:
    for iout = 1:nout
        hPort           = hOutports{iout};
        strOutport      = get_param(hPort, 'Name');
        strOutport      = strrep(strOutport, char(10), ' ');
        hPortParent     = get_param(hPort, 'Parent');
        strBusObject    = get_param(hPort, 'BusObject');
        idxPort         = get_param(hPort,'Port');
        strEdit         = sprintf('%s/%s (Outport #%s)', hPortParent, strOutport, idxPort);
        
        if(~strcmp(strBusObject, 'BusObject'))
            % Port has a bus object associated with it
            lstSignals          = BO2ResultsList(strBusObject);
            lstSignalsWithType  = BusObject2List(strBusObject);
            lstSignals          = [lstSignals lstSignalsWithType(:,3)];
        else
            if(flgCompile == 0)
                TerminateSim(root_sim, 0);
                eval_cmd = ['[sys, X, States, ts] = ' root_sim '([],[],[],''compile'');'];
                eval(eval_cmd);
                flgCompile = 1;
            end
            
            [lstUsed, lstUnused, SignalTrace] = GetSignalInfo(hPort);
            
            strBusObject = '<None>';
            dimPortData = get_param(hPort, 'CompiledPortWidths');
            numSignals = dimPortData.Outport;
            lstSignals = {strOutport numSignals '[Unknown]' 'double'};
        end
        
        strPort = ['Outport #' num2str(iout)];
        
        if(isempty(OutputStructName))
            strRTCFRoot = curBlock;
        else
            strRTCFRoot = [curBlock '.' OutputStructName];
        end
        
        tblTab = PortInfo2tbl( strPort, strOutport, strBusObject, lstSignals, lstSignals, IncludeRTCFName, strRTCFRoot);
        
        if(flgIncludeIndividualIO)
            xlswrite(strFilename, tblTab, strPort);

            if(flgVerbose)
                disp(sprintf('%s : Writing ICD for %s - %s: %s', mfnam, ...
                    strBlock, strPort, strOutport));
            end
        end
        
        tblFull = [tblFull; tblTab]; % ok<AGROW>
        tblWidth = size(tblTab, 2);
        blankLines = cell(2,tblWidth);
        tblFull = [tblFull; blankLines]; % ok<AGROW>
    end
    
    if(flgCompile)
        TerminateSim(root_sim, 0);
    end
    
    if( (SingleFile) && (numBlocks > 1) )
        strFilename = [SaveFolder filesep SingleFilename];
        xlswrite(strFilename, tblFull, strBlock);
    else
        xlswrite(strFilename, tblFull, 'Full');
    end
    
    if(~isempty(strCoversheet))
        xlswrite(strFilename, strCoversheet, 'Coversheet');
    end
    
    if(SingleFile) 
        if( (iBlock == numBlocks) && OpenAfterCreated )
            winopen(strFilename);
        end
    else
        if( OpenAfterCreated )
            winopen(strFilename);
        end
    end
end
warning('on', xls_warn);

end % << End of function WriteBlockIO >>


%% FUNCTION PortInfo2tbl
function tbl = PortInfo2tbl( strPortType, strPort, strBus, lstSignals, lstSignalsUsed, IncludeRTCFName, strRTCFRoot )

numMembers = size(lstSignals, 1);
numSignals = sum(cell2mat(lstSignals(:,2)));
flgFlattenVectors = IncludeRTCFName;

iTbl = 0; tbl = {};
iTbl = iTbl + 1; tbl(iTbl,1:2) = {'Port #:'         strPortType};
iTbl = iTbl + 1; tbl(iTbl,1:2) = {'Port Name:'      strPort};

iTbl = iTbl + 1; tbl(iTbl,1:2) = {'Bus Object Name:'    strBus};
iTbl = iTbl + 1; tbl(iTbl,1:2) = {'Bus Members:'        num2str(numMembers)};
iTbl = iTbl + 1; tbl(iTbl,1:2) = {'Total Signals:'      num2str(numSignals)};

iTbl = iTbl + 1; tbl(iTbl,1:2) = {'Description:'      '<Enter Description>'};

iTbl = iTbl + 1;
iTbl = iTbl + 1; tbl(iTbl,1:8) = {'Member #'    'Index Start'   'Index End'   'Signal Name'   'Dimensions'    'Units'     'DataType'  'Notes'};

if(IncludeRTCFName)
    tbl(iTbl,9) = {'RTCF Name'};
end

iStart = 1;
for iMember = 1:numMembers
    
    curSignal   = lstSignals{iMember, 1};
    curDim      = lstSignals{iMember, 2};
    curUnits    = lstSignals{iMember, 3};
    curType     = lstSignals{iMember, 4};
    flgNotUsed = (sum(strcmp(lstSignalsUsed, curSignal)) == 0);

    if(flgFlattenVectors)
        for iDim = 1:curDim
            iTbl = iTbl + 1;
            iEnd = iStart;

            tbl(iTbl, 1) = { num2str(iMember) };
            tbl(iTbl, 2) = { num2str(iStart) };
            tbl(iTbl, 3) = { num2str(iEnd) };
            if(curDim ~= 1)
                tbl(iTbl, 4) = { [curSignal '(' num2str(iDim) ')'] };
            else
                tbl(iTbl, 4) = { curSignal };
            end
            
            tbl(iTbl, 5) = { 1 };
            tbl(iTbl, 6) = { curUnits };
            tbl(iTbl, 7) = { curType };
            
            if(flgNotUsed)
                tbl(iTbl, 8) = { 'Signal NOT required by Block' };
            end
            
            if(IncludeRTCFName)
                strRTCF = curSignal;
                if(curDim > 1)
                    ptrSpacer = strfind(curSignal, '_');
                
                    if(isempty(ptrSpacer))
                        strRTCF = [curSignal num2str(iDim)];
                    else             
                        strMemRoot = curSignal(1:ptrSpacer(end)-1);
                        strMemUnits = curSignal(ptrSpacer(end)+1:end);
                        strRTCF = sprintf('%s%d_%s', strMemRoot, iDim, strMemUnits);
                        strRTCF = MangleName(strRTCF);
                    end
                end
                
                if(isempty(strRTCFRoot))
                    strRTCFName = curSignal;
                else
                    strRTCFName = [strRTCFRoot '.' strPort '.' strRTCF];
                end
                tbl(iTbl, 9) = { strRTCFName };
            end
            
            iStart = iEnd + 1;
        end
        
    else
        iTbl = iTbl + 1;
        iEnd = iStart + curDim - 1;
        tbl(iTbl, 1) = { num2str(iMember) };
        tbl(iTbl, 2) = { num2str(iStart) };
        tbl(iTbl, 3) = { num2str(iEnd) };
        tbl(iTbl, 4) = { curSignal };
        tbl(iTbl, 5) = { curDim };
        tbl(iTbl, 6) = { curUnits };
        tbl(iTbl, 7) = { curType };
        
        if(flgNotUsed)
            tbl(iTbl, 8) = { 'Signal NOT required by Block' };
        end
        
        if(IncludeRTCFName)
            if(isempty(strRTCFRoot))
                strRTCFName = curSignal;
            else
                strRTCFName = [strRTCFRoot '.' strPort '.' curSignal];
            end
            tbl(iTbl, 9) = { strRTCFName };
        end
        
        iStart = iEnd + 1;
    end
end

end

%% REVISION HISTORY
% YYMMDD INI: note
% 110526 MWS: Created function using CreateNewFunc
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
