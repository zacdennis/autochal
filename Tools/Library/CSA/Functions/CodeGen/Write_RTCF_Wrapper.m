% WRITE_RTCF_WRAPPER Writes RTCF header and souce file for Simulink model
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Write_RTCF_Wrapper:
%   This function constructs the requisite header and source file needed to
%   wrap a code generated Simulink block or model for integration with the
%   RTCF framework.
%
% SYNTAX:
%	[lstFiles] = Write_RTCF_Wrapper(strModel, varargin, 'PropertyName', PropertyValue)
%	[lstFiles] = Write_RTCF_Wrapper(strModel, varargin)
%	[lstFiles] = Write_RTCF_Wrapper(strModel)
%
% INPUTS:
%	Name    	Size		Units		Description
%	strModel	'string'    [char]      Name of Simulink block or model
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
% OUTPUTS:
%	Name    	Size		Units		Description
%	lstFiles	{'string'}  [char]      Cell array of strings listing full
%                                       path of all files genearted
%
% NOTES:
%	This function is supported by a number of CSA_Library utility functions
%	like:   Write_RTCF_BusObject_header.m,
%           Write_RTCF_RTDR.m,
%           Write_RTCF_Model_wrap_h.m
%           Write_RTCF_Model_wrap_cpp.m
%           Flatten_RTCF_IO.m
%           Write_RTCF_SimScript.m
%           Write_RTCF_vcproj.m
%           Write_MS_Studio_bat.m
%           format_varargin
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default     Description
%   'MarkingsFile'      'string'        'CreateNewFile_Defaults'
%                                                   MATLAB .m file
%                                                    containing requisite
%                                                    program markings
%   'RootCodeFolder'    'string'        pwd         Reference top-level
%                                                    folder from which all
%                                                    RTCF folders are
%                                                    determined
%   'CCodeFolder'       'string'        strModel    Name of folder under
%                                                    'RootCodeFolder'in
%                                                    which to place wrapper
%                                                    .h/.cpp files
%   'SharedUtilsFolder' 'string'        'Shared\MATLAB'
%                                                   Name of folder
%                                                    under 'RootCodeFolder'
%                                                    in which to copy all
%                                                    the MATLAB RTW created
%                                                    files in the
%                                                    'slprj\ert\_sharedutils'
%                                                    folder
%   'SimulinkIncludesFolder' 'string'   'Shared\MATLAB'
%                                                   Name of folder
%                                                    under 'RootCodeFolder'
%                                                    in which to copy
%                                                    reference Simulink
%                                                    include .h/.cpp files
%   'BinFolder'         'string'        'bin'       Name of folder under
%                                                    'RootCodeFolder' in
%                                                    which to place
%                                                    compiled RTCF .dll
%   'ScriptsFolder'     'string'        'scripts'   Name of folder under
%                                                    'BinFolder' in which
%                                                    to place RTCF test
%                                                    scripts
%   'RTDRFolder'        'string'        'scripts/RTDR'
%                                                   Name of folder under
%                                                    'BinFolder' in which to
%                                                    place RTCF real time
%                                                    data recorder (RTDR)
%                                                    scripts
%   'TestCaseFolder'    'string'        'scripts/TestCases'
%                                                   Name of folder under
%                                                    'BinFolder' in which to
%                                                    place RTCF test cases
%   'DataFolder'        'string'        'data'      Name of folder under
%                                                   'BinFolder' in which
%                                                    RTDR files will save
%                                                    RTCF simulation data
%   'BatFolder'         'string'        ''          Name of folder under
%                                                    'BinFolder' in which
%                                                    to save RTCF .bat
%                                                    sim shortcuts
%   'ClassName'         'string'        strModel    Name to use for wrapper
%                                                    class
%   'BlockRate'         [Hz]            []          Execution rate for
%                                                    wrapper. If not
%                                                    defined, 'strModel'
%                                                    is interogated for
%                                                    simulation sample time
%   'BuildRTCFSoln'     [bool]          true        Open Studio to build or
%                                                    build the .bat and
%                                                    compile the RTCF
%                                                    solution?
%   'Verbose'           [bool]          true        Show progress in
%                                                    Command Window?
%   'InputStructName'   'string'        'IN'        Name to use for top
%                                                    -level RTCF input
%                                                    structure
%   'OutputStructName'  'string'        'OUT'       Name to use for top
%                                                    -level RTCF output
%                                                    structure
%   'RTDRPrefix'        'string'        'RTDR_'     Prefix to use for
%                                                    naming RTDR files
%
% EXAMPLES:
%   See 'LinearActuator.mdl' and 'CodeGen_LinearActuator.m' for full example
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Write_RTCF_Wrapper.m">Write_RTCF_Wrapper.m</a>
%	  Driver script: <a href="matlab:edit Driver_Write_RTCF_Wrapper.m">Driver_Write_RTCF_Wrapper.m</a>
%	  Documentation: <a href="matlab:pptOpen('Write_RTCF_Wrapper_Function_Documentation.pptx');">Write_RTCF_Wrapper_Function_Documentation.pptx</a>
%
% See also Write_RTCF_BusObject_header, Write_RTCF_Model_wrap_h,
% Write_RTCF_Model_wrap_cpp, Write_RTCF_RTDR, Write_RTCF_SimScript,
% Write_RTCF_vcproj, Write_MS_Studio_bat, format_varargin
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/632
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CodeGen/Write_RTCF_Wrapper.m $
% $Rev: 3223 $
% $Date: 2014-07-31 15:47:07 -0500 (Thu, 31 Jul 2014) $
% $Author: sufanmi $

function [lstFiles] = Write_RTCF_Wrapper(strModel, varargin)

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
lstFiles= {}; iLog = 0;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[MarkingsFile, varargin]        = format_varargin('MarkingsFile', 'CreateNewFile_Defaults',  0, varargin);
[RootCodeFolder, varargin]      = format_varargin('RootCodeFolder', pwd,  2, varargin);
[CCodeFolder, varargin]        = format_varargin('CCodeFolder', strModel,  2, varargin);
[SharedUtilsFolder, varargin]  = format_varargin('SharedUtilsFolder',  ['Shared' filesep 'MATLAB'],  2, varargin);
[SimulinkIncludesFolder, varargin]= format_varargin('SimulinkIncludesFolder', SharedUtilsFolder, 2, varargin);
[BinFolder, varargin]           = format_varargin('BinFolder', 'bin', 0, varargin);
[ScriptsFolder, varargin]       = format_varargin('ScriptsFolder', 'scripts', 0, varargin);
[RTDRFolder, varargin]          = format_varargin('RTDRFolder', [ScriptsFolder filesep 'RTDR'], 0, varargin);
[TestCaseFolder, varargin]      = format_varargin('TestCaseFolder', [ScriptsFolder filesep 'TestCases'], 0, varargin);
[DataFolder, varargin]          = format_varargin('DataFolder', 'data', 0, varargin);
[BatFolder, varargin]           = format_varargin('BatFolder', '', 0, varargin);
[strClassName, varargin]        = format_varargin('ClassName', strModel,  2, varargin);
[BlockRate, varargin]           = format_varargin('BlockRate', [],  2, varargin);
[flgBuildRTCFSoln, varargin]    = format_varargin('BuildRTCFSoln', 1, 0, varargin);
[flgVerbose, varargin]          = format_varargin('Verbose', 1, 0, varargin);
[RTCFSourceFolder, varargin]    = format_varargin('RTCFSourceFolder', 'Source/',  3, varargin);
[InputStructName, varargin]     = format_varargin('InputStructName', 'IN',  3, varargin);
[OutputStructName, varargin]    = format_varargin('OutputStructName', 'OUT',  3, varargin);
[flgOnlyUpdateRTDRs, varargin]  = format_varargin('OnlyUpdateRTDRs', false,  3, varargin);
[flgWriteBORTDRs, varargin]     = format_varargin('WriteBORTDRs', false,  3, varargin);
[flgWriteInputRTDRs, varargin]  = format_varargin('WriteInputRTDRs', false,  3, varargin);
[flgWriteOutputRTDRs, varargin] = format_varargin('WriteOutputRTDRs', false,  3, varargin);
[flgWriteIORTDRs, varargin]     = format_varargin('WriteIORTDRs', true,  3, varargin);
[strVersionTag, varargin]       = format_varargin('VersionTag', '', 0, varargin);
[RTDRPrefix, varargin]          = format_varargin('RTDRPrefix', 'RTDR_',  3, varargin);
[RTDRFileFormat, varargin]      = format_varargin('RTDRFileFormat', {'rtdr';'py'},  3, varargin);
[SimScriptFileFormat, varargin] = format_varargin('SimScriptFileFormat', 'py',  3, varargin);
[lstMangleFindReplace, varargin]= format_varargin('MangleListFindReplace', {},  2, varargin);

% [OpenAfterCreated, varargin]    = format_varargin('OpenAfterCreated', true,  2, varargin);
UsePointers = true;     % Removing from global view

%% Main Function:
ptrSlash = findstr(strModel, '/');
if(isempty(ptrSlash))
    root_sim = strModel;
else
    root_sim = strModel(1:ptrSlash(1)-1);
end

buildInfo = RTW.getBuildDir(root_sim);

if(strcmp(RootCodeFolder, '-1'))
    RootCodeFolder = buildInfo.RelativeBuildDir;
end

if(~flgOnlyUpdateRTDRs)
    %% Figure out Folder for CCode
    if(~isempty(CCodeFolder))
        CCodeFolderFull = [RootCodeFolder filesep CCodeFolder];
    else
        CCodeFolderFull = RootCodeFolder;
    end
    
    if(~isdir(CCodeFolderFull))
        mkdir(CCodeFolderFull);
    end
    
    %% Move all the generated files into the appropriate RTCF directories:
    if(~strcmp(buildInfo.BuildDirectory, CCodeFolderFull))
        %% Move the .c/.cpp/.h files:
        lstFiles2Exclude = {'ert_main.cpp'; 'defines.txt'; 'modelsources.txt'};
        lstFiles2Move = dir_list({'*.c';'*.cpp';'*.h';'*.txt'}, 1, ...
            'FileExclude', lstFiles2Exclude, 'Root', buildInfo.BuildDirectory);
        copyfiles(lstFiles2Move, CCodeFolderFull, 'CollapseFolders', 1, 'Verbose', 0);
    end
    
    %% Move all the MATLAB (non-block-specific) Shared Utility Code:
    fldrAutocode = [buildInfo.BuildDirectory];
    
    AutoSharedUtils = strrep(buildInfo.ModelRefRelativeBuildDir, strModel, '_sharedutils');
    buildInfo.RootBuildDirectory = fileparts(buildInfo.BuildDirectory);
    fldrAutoShareUtils = [buildInfo.RootBuildDirectory filesep AutoSharedUtils];
    
    if(~isempty(SharedUtilsFolder))
        SharedUtilsFolderFull = [RootCodeFolder filesep SharedUtilsFolder];
    else
        SharedUtilsFolderFull = RootCodeFolder;
    end
    
    % Step 2d: Figure out what Include Utility files are needed:
    
    % This list does not include the full path to the file:
    lstSharedUtils      = dir_list({'*.cpp';'*.h';'*.c'}, 0, 'Root', fldrAutoShareUtils);
    
    % This list includes the full path to the file:
    lstSharedUtilsFull  = dir_list({'*.cpp';'*.h';'*.c'}, 1, 'Root', fldrAutoShareUtils);
    lstIncludes = GetIncludes([[fldrAutocode filesep strModel '.h']; lstSharedUtilsFull], ...
        {[matlabroot filesep 'simulink' filesep 'include']}, 1);
    
    % Part 1a: Move all used shared utility code into the main shared
    % utility folder.  Files in this folder will be used to actually
    % build/compile the RTCF component.
    fldrCodeShareUtils = strrep(fldrAutoShareUtils, ...
        buildInfo.RootBuildDirectory, SharedUtilsFolderFull);
    
    lstFiles2Move = dir_list({'*.h';'*.c';'*.cpp'}, 1, ...
        'Root', fldrAutoShareUtils, 'FileExclude', 'rtw_shared_utils.h');
    copyfiles(lstFiles2Move, fldrCodeShareUtils, 'CollapseFolders', 1, 'Verbose', 0);
    
    % Part 1a-2: Rewrite rtw_shared_utils.h
    lstNewModelIncludes = dir_list({'*.h'}, 1, 'Root', fldrAutoShareUtils);
    Write_rtw_shared_utils(fldrCodeShareUtils, 'NewModel', strModel, 'NewModelIncludes', lstNewModelIncludes );
    
    % Part 1b
    if(~isempty(SimulinkIncludesFolder))
        SimulinkIncludesFolderFull = [RootCodeFolder filesep SimulinkIncludesFolder];
    else
        SimulinkIncludesFolderFull = RootCodeFolder;
    end
    
    copyfiles(lstIncludes, SimulinkIncludesFolderFull, 'CollapseFolders', 1, 'Verbose', 0);
    
    % Part 2: Move all used shared utilty code into a model specific
    % folder within the shared utility folder.  This is for
    % informational purposes.  When working with large simulations
    % having multiple blocks that need coding, this is a backup system
    % that gives users a little more insight into which files were just
    % copied over.  It is NOT used for building the RTCF component.
    fldrCodeShareUtilsBackup = [SimulinkIncludesFolderFull filesep strModel];
    copyfiles(lstFiles2Move, fldrCodeShareUtilsBackup, 'CollapseFolders', 1, 'Verbose', 0);
    
end
%%
load_system(root_sim);

if(isempty(BlockRate))
    root_sim = bdroot(strModel);
    SampleTime = evalin('base', get_param(root_sim, 'FixedStep'));
    BlockRate = 1/SampleTime;
end

if(~isdir(RootCodeFolder))
    mkdir(RootCodeFolder);
end

% New Addition
BinFolderFull = [RootCodeFolder filesep BinFolder];
if(~isdir(BinFolderFull))
    mkdir(BinFolderFull);
end

DataFolderFull = [BinFolderFull filesep DataFolder];
if(~isdir(DataFolderFull))
    mkdir(DataFolderFull);
end

RTDRFolderFull = [BinFolderFull filesep RTDRFolder];
if(~isdir(RTDRFolderFull))
    mkdir(RTDRFolderFull);
end

%% Compile the Model
TerminateSim(root_sim, flgVerbose);
eval_cmd = ['[sys, X, States, ts] = ' root_sim '([],[],[],''compile'');'];
eval(eval_cmd);

% Find all Input ports:
hInports = find_system(strModel, 'SearchDepth', 1, 'BlockType', 'Inport');
nin = size(hInports,1);
lstModelInputs = {};
lstInputRTDR = {};

% Loop through each Input port:
for iin = 1:nin
    hPort           = hInports{iin};
    strInport       = get_param(hPort, 'Name');
    hPortParent     = get_param(hPort, 'Parent');
    strBusObject    = get_param(hPort, 'BusObject');
    idxPort         = get_param(hPort, 'Port');
    strEdit         = sprintf('%s/%s (Inport #%s)', hPortParent, strInport, idxPort);
    
    if(~strcmp(strBusObject, 'BusObject'))
        % Port has a bus object associated with it
        lstBO = BusObject2List(strBusObject);
        
        % Flatten just this bus so it can have its own Data Recorder
        lstMIR = lstBO;
        lstMIR(:,4) = { strInport };
        lstBusFlattened = Flatten_RTCF_IO(lstMIR, ...
            'Prefix', InputStructName, ...
            'ListFindReplace', lstMangleFindReplace);
        
        if(flgWriteBORTDRs)
            % Build a Data Recorder script for the Bus:
            strFilename = Write_RTCF_RTDR(lstBusFlattened(:,6), strModel, ...
                'Filename', [RTDRPrefix strModel '_' strInport], ...
                'SaveFolder', RTDRFolderFull,  ...
                'RecordRate', BlockRate, ...
                'FileFormat', RTDRFileFormat, varargin{:});
            lstFiles = [lstFiles; strFilename];
            lstInputRTDR = [lstInputRTDR; strFilename];
        end
        
        lstModelInputs = cat(1, lstModelInputs, lstBusFlattened);
        
    else
        dimPortData = get_param(hPort, 'CompiledPortWidths');
        dimPort = dimPortData.Outport;
        
        typePortData = get_param(hPort, 'CompiledPortDataTypes');
        typePort = typePortData.Outport{:};
        
        arrSignalFlattened = Flatten_RTCF_IO({ strInport, dimPort, typePort, '' }, ...
            'Prefix', InputStructName, ...
            'ListFindReplace', lstMangleFindReplace);
        
        lstModelInputs = cat(1, lstModelInputs, arrSignalFlattened);
    end
end

if(flgWriteInputRTDRs)
    % Build a Data Recorder script for all the inputs:
    strFilename = Write_RTCF_RTDR(lstModelInputs(:,6), strModel, ...
        'Filename', [RTDRPrefix strModel '_IN'], ...
        'SaveFolder', RTDRFolderFull, 'RecordRate', BlockRate, ...
        'FileFormat', RTDRFileFormat, varargin{:});
    lstInputRTDR = [lstInputRTDR; strFilename];
    lstFiles = [lstFiles; strFilename];
end

%% Figure out Outputs
hOutports = find_system(strModel, 'SearchDepth', 1, 'BlockType', 'Outport');
nout = size(hOutports,1);
lstModelOutputs = {};

lstOutputRTDR = {};
% Loop through each output port:
for iout = 1:nout
    hPort           = hOutports{iout};
    strOutport      = get_param(hPort, 'Name');
    hPortParent     = get_param(hPort, 'Parent');
    strBusObject    = get_param(hPort, 'BusObject');
    idxPort         = get_param(hPort,'Port');
    strEdit         = sprintf('%s/%s (Outport #%s)', hPortParent, strOutport, idxPort);
    
    if(~strcmp(strBusObject, 'BusObject'))
        % Port has a bus object associated with it
        lstBO = BusObject2List(strBusObject);
        
        % Flatten just this bus so it can have its own Data Recorder
        lstMIR = lstBO;
        lstMIR(:,4) = { strOutport };
        lstBusFlattened = Flatten_RTCF_IO(lstMIR, ...
            'Prefix', OutputStructName, ...
            'ListFindReplace', lstMangleFindReplace);
        
        if(flgWriteBORTDRs)
            % Build a Data Recorder script for the Bus:
            strFilename = Write_RTCF_RTDR(lstBusFlattened(:,6), strModel, ...
                'Filename', [RTDRPrefix strModel '_' strOutport], ...
                'SaveFolder', RTDRFolderFull, ...
                'RecordRate', BlockRate, ...
                'FileFormat', RTDRFileFormat, varargin{:});
            lstOutputRTDR = [lstOutputRTDR; strFilename];
            lstFiles = [lstFiles; strFilename];
        end
        
        lstModelOutputs = cat(1, lstModelOutputs, lstBusFlattened);
        
    else
        dimPortData = get_param(hPort, 'CompiledPortWidths');
        dimPort = dimPortData.Inport;
        
        typePortData = get_param(hPort, 'CompiledPortDataTypes');
        typePort = typePortData.Inport{:};
        
        arrSignalFlattened = Flatten_RTCF_IO({ strOutport, dimPort, typePort, '' }, ...
            'Prefix', OutputStructName, ...
            'ListFindReplace', lstMangleFindReplace);
        
        lstModelOutputs = cat(1, lstModelOutputs, arrSignalFlattened);
    end
end

if(flgWriteOutputRTDRs)
    % Build a Data Recorder script for all the outputs:
    strFilename = Write_RTCF_RTDR(lstModelOutputs(:,6), strModel, ...
        'Filename', [RTDRPrefix strModel '_OUT'], ...
        'SaveFolder', RTDRFolderFull, 'RecordRate', BlockRate, ...
        'FileFormat', RTDRFileFormat, varargin{:});
    lstOutputRTDR = [lstOutputRTDR; strFilename];
    lstFiles = [lstFiles; strFilename];
end

%
lstIORTDR = {};
if(flgWriteIORTDRs)
    % Build a Data Recorder script for all the inputs & outputs:
    lstModelIO = [lstModelInputs(:,6); lstModelOutputs(:,6)];
    strFilename = Write_RTCF_RTDR(lstModelIO, strModel, ...
        'Filename', [RTDRPrefix strModel '_IO'], ...
        'SaveFolder', RTDRFolderFull, 'RecordRate', BlockRate, ...
        'FileFormat', RTDRFileFormat, varargin{:});
    lstIORTDR = [lstIORTDR; strFilename];
    lstFiles = [lstFiles; strFilename];
end

if(~flgOnlyUpdateRTDRs)
    %% Figure out Function Inputs and Input Order from ert_main
    filename = [buildInfo.BuildDirectory filesep strModel '.h'];
    % filedata = editorservices.open(filename);
    filedata = LoadFile(filename);
    
    % lstSect(:,1):
    % lstSect(:,2): After/Before
    lstSect = {...
        'step'              1;
        'initialize'        1;
        'ExternalInputs'    0;
        'ExternalOutputs'   0;
        'update'            1;
        'output'            1;
        };
    numSect = size(lstSect, 1);
    
    lstVarTypeName = {}; iVar = 0;
    for iSect = 1:numSect
        curSect = lstSect{iSect, 1};
        flgAfter = lstSect{iSect, 2};
        clear lstVar;
        if(flgAfter)
            curMark = [strModel '_' curSect];
        else
            curMark = [curSect '_' strModel];
        end
        
        curText = filedata.Text;                % Reset curText
        ptrMark = findstr(curText, curMark);    % Find the current marker
        
        if(~isempty(ptrMark))
            curText = curText(ptrMark:end);
            strEnd = ';';
            
            ptrEnd = findstr(curText, strEnd);
            ptrEnd = ptrEnd(1)-1;
            
            strInputs = curText(1:ptrEnd);
            
            % Strip out various characters to get to the root
            strInputs = strrep(strInputs, curMark, '');
            strInputs = strrep(strInputs, endl, '');
            strInputs = strrep(strInputs, '(', '');
            strInputs = strrep(strInputs, ')', '');
            strInputs = strrep(strInputs, '*const', '');
            strInputs = strrep(strInputs, '&', '');
            strInputs = strrep(strInputs, '*', '');
            
            curFuncInputs = str2cell(strInputs, ',');
            curFuncInputs = strtrim(curFuncInputs);
            
            if(~isempty(curFuncInputs))
                for iFuncInput = 1:size(curFuncInputs, 1);
                    curInput = curFuncInputs{iFuncInput,:};
                    ptrSpace = findstr(curInput, ' ');
                    curVariableType = strtrim(curInput(1:ptrSpace(1)-1));
                    curVariableName = strtrim(curInput(ptrSpace(end)+1:end));
                    lstVar.VariableType(iFuncInput,:) = {curVariableType};
                    lstVar.VariableName(iFuncInput,:) = {curVariableName};
                    
                    if(iVar == 0)
                        flgAddToMaster = 1;
                    else
                        flgAddToMaster = ~max(strcmp(lstFuncInputs(:,2), curVariableType));
                    end
                    
                    if(flgAddToMaster)
                        iVar = iVar + 1;
                        lstFuncInputs(iVar,1) = {curVariableName };
                        lstFuncInputs(iVar,2) = {curVariableType };
                        lstFuncInputs(iVar,3) = {[]};   % Used for future concatenation
                    end
                end
                funcInputs.(curSect) = lstVar;
            end
        end
    end
    
    %% Filter Input List and make it unique
    numInputs = size(lstModelInputs(:,1), 1);
    numInputsUnique = size(unique(lstModelInputs(:,1)), 1);
    flgInputsUnique = (numInputs == numInputsUnique);
    if(~flgInputsUnique)
        lstRaw = lstModelInputs(:,1);
        lstNew = lstRaw;
        numRaw = size(lstRaw, 1);
        [lstUnique, iUnique] = unique(lstRaw);
        iNotUnique = setdiff([1:numRaw]', iUnique);
        lstNotUnique = lstRaw(iNotUnique, 1);
        
        for i = 1:length(iNotUnique)
            cur_iNotUnique = iNotUnique(i);
            cur_NotUnique = lstNotUnique{i};
            itmp = 1;
            flgOK = false;
            while(~flgOK)
                itmp = itmp + 1;
                curUniqueNew = [cur_NotUnique '_' num2str(itmp)];
                flgOK = ~any(strcmp(lstRaw, curUniqueNew));
            end
            lstRaw(cur_iNotUnique) = { curUniqueNew };
        end
        lstModelInputs(:,1) = lstRaw;
    end
    
    %% Filter Output List and make it unique
    numOutputs = size(lstModelOutputs(:,1), 1);
    numOutputsUnique = size(unique(lstModelOutputs(:,1)), 1);
    flgOutputsUnique = (numOutputs == numOutputsUnique);
    if(~flgOutputsUnique)
        lstRaw = lstModelOutputs(:,1);
        lstNew = lstRaw;
        numRaw = size(lstRaw, 1);
        [lstUnique, iUnique] = unique(lstRaw);
        iNotUnique = setdiff([1:numRaw]', iUnique);
        lstNotUnique = lstRaw(iNotUnique, 1);
        
        for i = 1:length(iNotUnique)
            cur_iNotUnique = iNotUnique(i);
            cur_NotUnique = lstNotUnique{i};
            itmp = 1;
            flgOK = false;
            while(~flgOK)
                itmp = itmp + 1;
                curUniqueNew = [cur_NotUnique '_' num2str(itmp)];
                flgOK = ~any(strcmp(lstRaw, curUniqueNew));
            end
            lstRaw(cur_iNotUnique) = { curUniqueNew };
        end
        lstModelOutputs(:,1) = lstRaw;
    end
    
    %% Filter Inputs and Outputs to make sure they're unique
    numInputs = size(lstModelInputs, 1);
    numOutputs = size(lstModelOutputs, 1);
    
    for iOut = 1:numOutputs
        curOutput = lstModelOutputs{iOut, 1};
        
        for iIn = 1:numInputs
            curInput = lstModelInputs{iIn, 1};
            
            if(strmatch(curOutput, curInput))
                curInput = [curInput '_In'];
                curOutput = [curOutput '_Out'];
                lstModelInputs{iIn, 1} = curInput;
                lstModelOutputs{iOut, 1} = curOutput;
            end
        end
    end
    
    %% Write Wrapper .h
    strFilename = Write_RTCF_Model_wrap_h(strModel, lstFuncInputs, ...
        lstModelInputs, lstModelOutputs, ...
        'MarkingsFile', MarkingsFile, 'SaveFolder', CCodeFolderFull, ...
        'UsePointers', UsePointers, varargin{:});
    iLog = iLog + 1;
    lstFiles(iLog, :) = {strFilename};
    
    %% Write Wrapper .cpp
    strFilename = Write_RTCF_Model_wrap_cpp(strModel, lstModelInputs, ...
        lstModelOutputs, funcInputs.initialize.VariableName, ...
        funcInputs.step.VariableName, BlockRate, ...
        'MarkingsFile', MarkingsFile, 'SaveFolder', CCodeFolderFull, ...
        'ClassName', strClassName, ...
        'InputStructName', InputStructName, ...
        'OutputStructName', OutputStructName, ...
        'UsePointers', UsePointers, varargin{:});
    lstFiles = [lstFiles; strFilename];
end

%% Terminate Sim
TerminateSim(root_sim, flgVerbose);

if(~flgOnlyUpdateRTDRs)
    %% Write RTCF Test Harness
    %  Test Script SaveFolder: [RootCodeFolder / BinFolder / ScriptsFolder]
    %  .bat Script SaveFolder: [RootCodeFolder / BinFolder / BatFolder]
    strFilename = Write_RTCF_SimScript(strModel, ...
        'BinFolderFull', BinFolderFull, ...
        'ScriptsFolder', ScriptsFolder, ...
        'RTDRFolder', RTDRFolder, ...
        'TestCaseFolder', TestCaseFolder, ...
        'BatFolder', BatFolder, ...
        'InputRTDR', lstInputRTDR, ...
        'OutputRTDR', lstOutputRTDR, ...
        'IORTDR', lstIORTDR, ...
        'InputStructName', InputStructName, ...
        'MarkingsFile', MarkingsFile, ...
        'FileFormat', SimScriptFileFormat, varargin{:});
    lstFiles = [lstFiles; strFilename];
    
    % Step 4: Write the .vcproj/.sln file for the Code Check executable:
    lstIncludeFolders(1,:) = { [SharedUtilsFolder filesep AutoSharedUtils] };
    lstIncludeFolders(2,:) = { SimulinkIncludesFolder };
    
    % Construct list of SharedUtilities that have been copied to the Code
    % Shared Utils folder (full paths only with no sub-directories included)
    lstSharedUtilities  = strrep(lstSharedUtilsFull, ...
        fldrAutoShareUtils, fldrCodeShareUtils);
%     lstSharedUtils
    [filename] = Write_RTCF_vcproj(strModel, lstSharedUtilities, ...
        'RootCodeFolder', RootCodeFolder, ...
        'CCodeFolder', CCodeFolder, ...
        'BinFolder', BinFolder, ...
        'IncludeFolders', lstIncludeFolders, ...
        'RTCFSourceFolder', RTCFSourceFolder, ...
        varargin{:});
    
    if(flgBuildRTCFSoln)
        if(1)
            % Workaround
%             system(filename);
            [fldr, strRoot, strExt] = fileparts(filename);
            winopen(fldr);
            disp('');
            ok_lets_go = input(['Double Click on ' strRoot strExt ' to Launch Visual Studio with the correct environment variables.'],'s');
            
%             disp(sprintf('%s : %s should now be open in %s', mfnam, strRoot, mexParams.Name));
%             ok_lets_go = input([mfspc 'Please right-click and rebuild solution.  Then close Studio. Press enter to continue.'],'s');            
%             model_BLD = [fldr filesep strModel '_BLD.bat'];
%             system(model_BLD);

        else
            % Step 5: Write the .bat file that can be used to build the .sln and
            % then run it to build the solution:
            % sufanmi Note: This is preferred.  Autonomously build solution or
            % vcproj in Studio.  However, something weird is going on.  Next
            % best thing is to open Studio and have the user manually rebuild.
            [filename] = Write_MS_Studio_bat(filename, varargin{:});
        end
    end
end

end % << End of function Write_RTCF_Wrapper >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101124 MWS: Created function using CreateNewFunc
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
