% WRITE_CODECHECK_VERIFY Constructs the executive test script that verifies CCode matches its Simulink source
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Write_CodeCheck_Verify:
%     This function creates the executive MATLAB .m script that is used to
%     verify that that the RTW generated autocode matches Simulink.  The
%     test script assumes that time history data has been recorded in
%     native Simulink and has been saved to .csv files.  The generated
%     script will loop through each test generated and run the CCode
%     executable built using Write_CodeCheck_Harness.
% 
% SYNTAX:
%	[filename] = Write_CodeCheck_Verify(strModel, varargin, 'PropertyName', PropertyValue)
%	[filename] = Write_CodeCheck_Verify(strModel, varargin)
%	[filename] = Write_CodeCheck_Verify(strModel)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	strModel	<size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	filename	<size>		<units>		<Description> 
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
%	[filename] = Write_CodeCheck_Verify(strModel, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Write_CodeCheck_Verify.m">Write_CodeCheck_Verify.m</a>
%	  Driver script: <a href="matlab:edit Driver_Write_CodeCheck_Verify.m">Driver_Write_CodeCheck_Verify.m</a>
%	  Documentation: <a href="matlab:pptOpen('Write_CodeCheck_Verify_Function_Documentation.pptx');">Write_CodeCheck_Verify_Function_Documentation.pptx</a>
%
% See also format_varargin, lst2sampleCSV, GetSignalInfo, Cell2PaddedStr
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/705
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [filename] = Write_CodeCheck_Verify(strModel, varargin)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp
tab2 = [tab tab];
tab3 = [tab tab tab];
tab4 = [tab tab tab tab];

% Examples of Different Display Formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfnam '>> ERROR: <define error here> See ' mlink ' help'];      % <-- Couple with error function
% error([mfnam 'class:file:Identifier'], errstr);    % Call error function with error string

%% Initialize Outputs:
lstFiles= '';

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[MarkingsFile, varargin]            = format_varargin('MarkingsFile', 'CreateNewFile_Defaults',  2, varargin);
[SaveFolder, varargin]              = format_varargin('SaveFolder', pwd,  2, varargin);
[flgVerbose, varargin]              = format_varargin('Verbose', 1, 0, varargin);
[OpenAfterCreated, varargin]        = format_varargin('OpenAfterCreated', true,  2, varargin);
[prompt_to_overwrite, varargin]     = format_varargin('prompt_to_overwrite', 1, 2, varargin);
[prompt_to_overwrite_val, varargin] = format_varargin('prompt_to_overwrite_val', 'Y', 2, varargin);
% OpenAfterCreated = 1;

%% Main Function:
ptrSlash = findstr(strModel, '/');
if(isempty(ptrSlash))
    root_sim = strModel;
else
    root_sim = strModel(1:ptrSlash(1)-1);
end

filename = ['CodeCheck_' root_sim];

buildInfo = RTW.getBuildDir(root_sim);
RootCodeFolder = buildInfo.RelativeBuildDir;

load_system(root_sim);

TestCasesRoot = [SaveFolder filesep 'TestCases'];
if(~isdir(TestCasesRoot))
    mkdir(TestCasesRoot);
end

TestCaseDefault = [TestCasesRoot filesep 'NullDefault'];
if(isdir(TestCaseDefault))
    rmdir(TestCaseDefault, 's');
end
if(~isdir(TestCaseDefault))
    mkdir(TestCaseDefault);
end

%% Compile the Model
TerminateSim(root_sim, flgVerbose);
eval_cmd = ['[sys, X, States, ts] = ' root_sim '([],[],[],''compile'');'];
eval(eval_cmd);

strSampleTime = get_param(root_sim, 'FixedStep');
valSampleTime = evalin('base', strSampleTime);

lstInputSignalsUsed = {};

% Find all Input ports:
hInports = find_system(strModel, 'SearchDepth', 1, 'BlockType', 'Inport');
nin = size(hInports,1);
lstModelInputs = {};

%% Figure out if all the inputs are regular input ports (special case):
%  Regular meaning no associated bus object
flgAllInputsReg = 1;
for iin = 1:nin
    hPort           = hInports{iin};
    strBusObject    = get_param(hPort, 'BusObject');
    if(~strcmp(strBusObject, 'BusObject'))
        flgAllInputsReg = 0;
    end
end

% Loop through each Input port:
numInputSignals = 0;
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
        numSignals = sum(cell2mat(lstBO(:,2)));
        lstFiles = lst2sampleCSV(strInport, strBusObject, ...
            'Extension', '.txt', 'Suffix', '_SL', ...
            'SaveFolder', TestCaseDefault, ...
            'OpenAfterCreated', OpenAfterCreated);
        
    else
        dimPortData = get_param(hPort, 'CompiledPortWidths');
        numSignals = dimPortData.Outport;
         lstBO = '';
        
        dimPortData = get_param(hPort, 'CompiledPortDataTypes');
        strBusObject = dimPortData.Outport{1};
        
        if(~flgAllInputsReg)
            lstSignals = {'Unknown', numSignals, '[unknown]'};
            lstFiles = lst2sampleCSV(strInport, lstSignals, ...
                'Extension', '.txt', 'Suffix', '_SL', ...
                'SaveFolder', TestCaseDefault, ...
                'OpenAfterCreated', OpenAfterCreated);
        end
    end
    
    [lstUsed, lstUnused, SignalTrace] = GetSignalInfo(hPort);
    for i = 1:size(lstUsed, 1)
        curUsed = [strInport '.' lstUsed{i}];
        lstInputSignalsUsed = [lstInputSignalsUsed; curUsed];
    end
    numInputSignals = numInputSignals + numSignals;
    
    lstModelInputs(iin, 1) = { strInport };
    lstModelInputs(iin, 2) = { strEdit };
    lstModelInputs(iin, 3) = { numSignals };
    lstModelInputs(iin, 4) = { strBusObject };
    lstModelInputs(iin, 5) = { lstBO };
    
%     if(flgAllInputsReg)
%         % Build Null Inputs so compiled code can "work" in absense of actual
%         % test data:
%         input_filename = [TestCaseDefault filesep strInport '.txt'];
%         fid = fopen(input_filename, 'wt','native');
%         for i = 1:numSignals
%             if(i < numSignals)
%                 fprintf(fid, '%s,', num2str(0));
%             else
%                 fprintf(fid, '%s\n', num2str(0));
%             end
%         end
%         fclose(fid);
%     end
end

if(flgAllInputsReg)
    lstInputSignalsUsed = lstModelInputs(:,1);
    
    lstInputs(:,1) = lstModelInputs(:,1);
    lstInputs(:,2) = lstModelInputs(:,3);
    lstInputs(:,3) = {'[TBD]'};
    
    lstFiles = lst2sampleCSV([strModel '_Inputs'], lstInputs, ...
        'Extension', '.txt', 'Suffix', '_SL', ...
        'SaveFolder', TestCaseDefault, ...
        'OpenAfterCreated', OpenAfterCreated);
end

%% Figure out Outputs
hOutports = find_system(strModel, 'SearchDepth', 1, 'BlockType', 'Outport');
nout = size(hOutports,1);
lstModelOutputs = {};
lstOutputSignals = {};

%% Figure out if all the outputs are regular output ports (special case):
%  Regular meaning no associated bus object
flgAllOutputsReg = 1;
for iout = 1:nout
    hPort       = hOutports{iout};
    strBusObject= get_param(hPort, 'BusObject');
    if(~strcmp(strBusObject, 'BusObject'))
        flgAllOutputsReg = 0;
    end
end

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
        numSignals = sum(cell2mat(lstBO(:,2)));
        lstFiles = lst2sampleCSV(strOutport, strBusObject, ...
            'Extension', '.txt', 'Suffix', '_CC', ...
            'SaveFolder', TestCaseDefault, ...
            'OpenAfterCreated', OpenAfterCreated);
        lstFiles = lst2sampleCSV(strOutport, strBusObject, ...
            'Extension', '.txt', 'Suffix', '_SL', ...
            'SaveFolder', TestCaseDefault, ...
            'OpenAfterCreated', OpenAfterCreated);
        
        for i = 1:size(lstBO)
            lstOutputSignals = [lstOutputSignals; ['''' strOutport '.' lstBO{i,1} '''']];
        end

    else
        dimPortData = get_param(hPort, 'CompiledPortWidths');
        numSignals = dimPortData.Inport;
        lstBO = '';
        
        dimPortData = get_param(hPort, 'CompiledPortDataTypes');
        strBusObject = dimPortData.Inport{1};
        
        if(~flgAllOutputsReg)
            lstSignals = {'Unknown', numSignals, '[unknown]'};
            lstFiles = lst2sampleCSV(strOutport, lstSignals, ...
                'Extension', '.txt', 'Suffix', '_CC', ...
                'SaveFolder', TestCaseDefault, ...
                'OpenAfterCreated', OpenAfterCreated);
            lstFiles = lst2sampleCSV(strOutport, lstSignals, ...
                'Extension', '.txt', 'Suffix', '_SL', ...
                'SaveFolder', TestCaseDefault, ...
                'OpenAfterCreated', OpenAfterCreated);
        end
        
        lstOutputSignals = [lstOutputSignals; ['''' strOutport '''']];
    end
    
    lstModelOutputs(iout, 1) = { strOutport };
    lstModelOutputs(iout, 2) = { strEdit };
    lstModelOutputs(iout, 3) = { numSignals };
    lstModelOutputs(iout, 4) = { strBusObject };
    lstModelOutputs(iout, 5) = { lstBO };
end

if(flgAllOutputsReg)
    lstOutputs(:,1) = lstModelOutputs(:,1);
    lstOutputs(:,2) = lstModelOutputs(:,3);
    lstOutputs(:,3) = {'[TBD]'};
    
    lstFiles = lst2sampleCSV([strModel '_Outputs'], lstOutputs, ...
        'Extension', '.txt', 'Suffix', '_SL', ...
        'SaveFolder', TestCaseDefault, ...
        'OpenAfterCreated', OpenAfterCreated);
    lstFiles = lst2sampleCSV([strModel '_Outputs'], lstOutputs, ...
        'Extension', '.txt', 'Suffix', '_CC', ...
        'SaveFolder', TestCaseDefault, ...
        'OpenAfterCreated', OpenAfterCreated);
end

TerminateSim(root_sim, flgVerbose);

%% ========================================================================

% Markings:
eval(sprintf('CNF_info = %s(1, mfnam);', MarkingsFile));

%% Header Classified Lines
% write to temp header variable
fstr = ''; %initialize headfootCNF_info.CenterChar
if ~isempty(CNF_info.Classification)
    fstr = [fstr '% ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Header ITAR Lines
if ~isempty(CNF_info.ITAR)
    fstr = [fstr '% ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Header Proprietary Lines
if ~isempty(CNF_info.Proprietary)
    fstr = [fstr '% ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Add Title:
fstr = [fstr '% Verify_' filename endl];
fstr = [fstr '%	< Insert Documentation >' endl];
fstr = [fstr '%' endl];

% Copyright
if(isfield(CNF_info, 'Copyright'))
    if(~isempty(CNF_info.Copyright))
        fstr = [fstr CNF_info.Copyright];
    end
end

fstr = [fstr endl];
fstr = [fstr '% Subversion Revision Information At Last Commit' endl];
fstr = [fstr '% $URL: $' endl];
fstr = [fstr '% $Rev: $' endl];
fstr = [fstr '% $Date: $' endl];
fstr = [fstr '% $Author: $' endl];
fstr = [fstr '' endl];
fstr = [fstr '%% Housekeeping:' endl];
fstr = [fstr 'clc; close all;' endl];
fstr = [fstr 'fldrRoot = fileparts(mfilename(''fullpath''));' endl];
fstr = [fstr 'cd(fldrRoot);' endl];
fstr = [fstr '' endl];
fstr = [fstr '%% User Defined:' endl];
fstr = [fstr endl];
fstr = [fstr '% Name of Simulink Block that was autocoded:' endl];
fstr = [fstr 'strModel        = ''' strModel ''';' endl];
fstr = [fstr endl];
fstr = [fstr '% Name of the CodeCheck exectuable created:' endl];
fstr = [fstr 'strExecutable   = [''CodeCheck_'' strModel ''.exe''];' endl];
fstr = [fstr endl];
fstr = [fstr '% Folder where CodeCheck executable resides (full path):' endl];
fstr = [fstr 'fldrExecutable = [fldrRoot filesep ''Executable''];' endl];
fstr = [fstr endl];
fstr = [fstr '% Top-level folder of Executable test cases (full path):' endl];
fstr = [fstr 'fldrTestCaseRoot = [fldrRoot filesep ''TestCases''];' endl];
fstr = [fstr endl];
fstr = [fstr '% Subfolder name (i.e. TestCaseRoot / <TestCase> / Subfolder /Data.txt)' endl];
fstr = [fstr 'fldrSubTestCaseRoot = '''';' endl];
fstr = [fstr endl];
fstr = [fstr '% List the test case folders that are in the ''fldrTestCaseRoot'' folder:' endl];
fstr = [fstr '% Option #1: Use pathgen to figure out folders in ''fldrTestCaseRoot''' endl];
fstr = [fstr 'lstTestFolders = str2cell(pathgen(fldrTestCaseRoot, {''NullDefault'';''.svn'';''private''}, 1), '';'');' endl];
fstr = [fstr 'if(isempty(lstTestFolders))' endl];
fstr = [fstr tab 'lstTestFolders = {''NullDefault''};' endl];
fstr = [fstr 'end' endl];
fstr = [fstr '% Option #2: User-Specifies Folders' endl];
fstr = [fstr '% lstTestFolders = {''NullDefault''};' endl];
fstr = [fstr endl];
fstr = [fstr '% Suffixes Used in Time History Data:' endl];
fstr = [fstr 'strSL = ''_SL'';  % Simulink Data' endl];
fstr = [fstr 'strCC = ''_CC'';  % Code Check Data' endl];
fstr = [fstr endl];
fstr = [fstr '% Specify which TestCases (rows of ''lstTestFolders'') to run:' endl];
fstr = [fstr '% To run all rows, leave empty:' endl];
fstr = [fstr 'arrTestCasesToRun = [];' endl];
fstr = [fstr endl];

fstr = [fstr '% Specify which Signals in Results structure to plot:' endl];
fstr = [fstr '% To plot all signals, leave blank' endl];
fstr = [fstr '% lstOutputSignalsToPlot = {};' endl];
fstr = [fstr 'lstOutputSignalsToPlot = {' endl];
for i = 1:size(lstOutputSignals, 1)
    fstr = [fstr tab lstOutputSignals{i,1} ';' endl];
end
fstr = [fstr '};' endl];
fstr = [fstr endl];

fstr = [fstr '% Specify which Input Signals in Results to plot:' endl];
fstr = [fstr '% To plot all signals, leave blank' endl];
fstr = [fstr '% Note this auto-generated list shows all signals required' endl];
fstr = [fstr '% to run ' strModel '.  It is possible there are input signals' endl];
fstr = [fstr '% not required to run ' strModel '.' endl];
if(size(lstInputSignalsUsed, 1) > 0)
    fstr = [fstr 'lstInputSignalsToPlot = {' endl];
    for i = 1:size(lstInputSignalsUsed, 1)
        fstr = [fstr tab '''' lstInputSignalsUsed{i,1} ''';' endl];
    end
    fstr = [fstr '};' endl];
else
    fstr = [fstr 'lstInputSignalsToPlot = {};' endl];
end

fstr = [fstr endl];
fstr = [fstr '% Define "Good" Threshhold:' endl];
fstr = [fstr '% Good Match = (Simulink - Autocode) > Threshold' endl];
fstr = [fstr 'Threshold   = 1e-6;' endl];
fstr = [fstr endl];

fstr = [fstr '% Define Timesteps to Compare:' endl];
fstr = [fstr 'xmin = ' num2str(valSampleTime) ';  % [sec]' endl];
fstr = [fstr 'xmax = []; % [sec] (Leave Blank to include all datapoints > xmin)' endl];

fstr = [fstr endl];

fstr = [fstr '% Define Plot Flags:' endl];
fstr = [fstr 'flgPlotInputs  = 1;  % [bool] Plot the Inputs?' endl];
fstr = [fstr 'flgPlotOutputs = 1;  % [bool] Plot the Comparison?' endl];
fstr = [fstr 'flgWipeLog     = 1;  % [bool] Wipe the Master Log on 1st iteration?' endl];
fstr = [fstr endl];

fstr = [fstr '% Define Decimation Table:' endl];
fstr = [fstr '% Plot Decimation (Plot ticks) will be a function of RunTime' endl];
fstr = [fstr '% if(RunTime >= tblDecimation.Time(1), Decimation = tblDecimation.Dec(1)' endl];
fstr = [fstr 'tblDecimation.Time = [ inf 5000 2000 1000 500 200 100 50 20 0];    % [sec]' endl];
fstr = [fstr 'tblDecimation.Dec  = [2000 1000  500  200 100  50  20 10  4 1];    % [sec]' endl];

fstr = [fstr '% PlotOrder {N x 3} where...' endl];
fstr = [fstr '% PlotOrder{:,n}: Name                  Size                Default     Typically...' endl];
fstr = [fstr '% PlotOrder{:,1}: Line/Marker Color     ''string'' or [1x3]   varies      {''b'' ''g'' ''r'' ''c'' ''m''}' endl];
fstr = [fstr '% PlotOrder{:,2}: Marker Type           ''string''            varies      {''x'' ''o'' ''v'' ''*'' ''^'' ''s'' ''d''}' endl];
fstr = [fstr '% PlotOrder{:,3}: Line Style            ''string''            ''-''         {''-'' ''--'' '':'' ''-.''}' endl];
fstr = [fstr 'PlotOrder = {...' endl];
fstr = [fstr '    ''b''     ''x''     ''-'';' endl];
fstr = [fstr '    ''g''     ''s''     ''--'';' endl];
fstr = [fstr '    ''r''     ''o''     ''-.'';' endl];
fstr = [fstr '    ''k''     ''+''     '':'';' endl];
fstr = [fstr '    ''m''     ''d''     ''-'';' endl];
fstr = [fstr '    };' endl];
fstr = [fstr 'FigurePosition = [1000 485 851 1013];' endl];
fstr = [fstr endl];

fstr = [fstr '% Define Plot Saving Flags:' endl];
fstr = [fstr 'flgSave2PPT = 1;  % [bool] Save Figures to PowerPoint?' endl];
fstr = [fstr 'flgDoubleUp = 1;  % [bool] Put 2 figures on each PowerPoint slide?' endl];
fstr = [fstr 'flgClosePPT = 1;  % [bool] Close PowerPoint presentation after created? (use 1 for batch mode!)' endl];
fstr = [fstr 'nMaxFigs    = 10; % [bool] Maximum number of figures to have open' endl];
fstr = [fstr '                  %        Set to [] to allow all to plot' endl];
fstr = [fstr endl];
fstr = [fstr 'flgViewLogTC= 1;  % [bool] Open Verification Log for Each TestCase?' endl];

fstr = [fstr '%% << End of User Defined >>' endl];
fstr = [fstr endl];
fstr = [fstr '%% Main Code:' endl];
fstr = [fstr 'if(isempty(arrTestCasesToRun))' endl];
fstr = [fstr '    arrTestCasesToRun = [1:size(lstTestFolders, 1)];' endl];
fstr = [fstr 'else' endl];
fstr = [fstr '    % Check that the test cases (rows) specified are valid:' endl];
fstr = [fstr '    arrTestCasesToRun = intersect(arrTestCasesToRun, [1:size(lstTestFolders, 1)]);' endl];
fstr = [fstr 'end' endl];
fstr = [fstr endl];
fstr = [fstr 'numTestsToRun = length(arrTestCasesToRun);' endl];
fstr = [fstr '% Loop through each desired test case:' endl];
fstr = [fstr 'for iIdxTC = 1:numTestsToRun' endl];
fstr = [fstr '    idxTC = arrTestCasesToRun(iIdxTC);' endl];
fstr = [fstr endl];
fstr = [fstr '    % Pick off that row from lstTestFolders:' endl];
fstr = [fstr '    fldrTestCase    = lstTestFolders{idxTC, :};' endl];
fstr = [fstr '    fldrTestCaseFull= [fldrTestCaseRoot filesep fldrTestCase];' endl];
fstr = [fstr '    if(~isempty(fldrSubTestCaseRoot))' endl];
fstr = [fstr '        fldrTestCaseFull = [fldrTestCaseFull filesep fldrSubTestCaseRoot];' endl];
fstr = [fstr '    end' endl];
fstr = [fstr endl];
fstr = [fstr '    % Determine Name of Test Case:' endl];
fstr = [fstr '    % TODO: Pull this from TestCase.Title?' endl];
fstr = [fstr '    strTestCase = fldrTestCase;' endl];
fstr = [fstr '    ' endl];
fstr = [fstr '    % Step 0: Housekeeping:' endl];
fstr = [fstr '    if(flgPlotInputs || flgPlotOutputs)' endl];
fstr = [fstr '        close all;' endl];
fstr = [fstr '    end' endl];
fstr = [fstr endl];
fstr = [fstr '    % Tell user where we''re at:' endl];
fstr = [fstr '    disp(sprintf(''%d/%d: Processing #%d: ''''%s''''...'', iIdxTC, ...' endl];
fstr = [fstr '        numTestsToRun, idxTC, fldrTestCase));' endl];
fstr = [fstr '    ' endl];

fstr = [fstr '    %% Step 1: Parse the Simulink/CodeCheck Inputs:' endl];
fstr = [fstr '    hd = pwd;' endl];
fstr = [fstr '    cd(fldrTestCaseFull);' endl];

if(flgAllInputsReg)
    fstr = [fstr '    ResultsIN = ' strModel '_Inputs_Info([''' strModel '_Inputs'' strSL ''.txt'']);' endl];
else
    tblLoadInputs = cell(3,nin);
    for i = 1:nin
        strInport = lstModelInputs{i,1};
        tblLoadInputs{i,1} = '   ';
        tblLoadInputs{i,2} = ['ResultsIN.' strInport];
        tblLoadInputs{i,3} = ['= ' strInport '_Info([''' strInport ''' strSL ''.txt'']);'];
    end
    fstr = [fstr Cell2PaddedStr(tblLoadInputs, 'Padding', ' ')];
end
fstr = [fstr '    cd(hd);' endl];

fstr = [fstr endl];
fstr = [fstr '    %% Step 2: Copy the CodeCheck Inputs into CodeCheck folder:' endl];
fstr = [fstr '    lstCombos = {};' endl];
if(flgAllInputsReg)
    fstr = [fstr '    lstCombos(1,:) = {[''' strModel '_Inputs'' strSL ''*.txt'']};' endl];
else
    for i = 1:nin
        strInport = lstModelInputs{i,1};
        fstr = [fstr '    lstCombos(' num2str(i) ',:) = {[''' strInport ''' strSL ''*.txt'']};' endl];
    end
end
fstr = [fstr '    lstFiles = dir_list(lstCombos, 1, ''Root'', fldrTestCaseFull, ...' endl];
fstr = [fstr tab tab '''FileExclude'', {strCC});' endl];
fstr = [fstr '    copyfiles(lstFiles, fldrExecutable, ...' endl];
fstr = [fstr tab tab '''CollapseFolders'', 1, ''LogFormat'', ''Detailed'');' endl];

fstr = [fstr '    ' endl];
fstr = [fstr '    %% Step 3:  Run the CodeChecker.exe:' endl];
fstr = [fstr '    %           All block outputs will be saved in comma delimited .txt files' endl];
fstr = [fstr '    %  Step 3a: Figure out run time for display diagnostics' endl];
fstr = [fstr '    SimTime = ResultsIN.' lstInputSignalsUsed{1,:} '.Time(end); % [sec]' endl];
fstr = [fstr endl];

fstr = [fstr '    hd = pwd;' endl];
fstr = [fstr '    cd(fldrExecutable);' endl];
fstr = [fstr '    disp(sprintf(''Running ''''%s'''' for %.0f seconds...'', strExecutable, SimTime));' endl];
fstr = [fstr '    tStart = tic;' endl];
fstr = [fstr '    system(strExecutable);' endl];

fstr = [fstr '    RealTime = toc(tStart);' endl];
fstr = [fstr '    xRT = SimTime / RealTime;' endl];
fstr = [fstr '    disp(sprintf(''Running Complete.  Elapsed time is %.4f [sec] (%.4f xRT)'', RealTime, xRT));' endl];
fstr = [fstr '    cd(hd);' endl];

fstr = [fstr endl];
fstr = [fstr '    %% Step 4: Copy the Results back into the TestCase folder:' endl];
fstr = [fstr '    lstFiles = dir_list(''*.txt'', 1, ''Root'', fldrExecutable, ...' endl];
fstr = [fstr tab tab '''FileExclude'', {strSL});' endl];
fstr = [fstr '    copyfiles(lstFiles, fldrTestCaseFull, ...' endl];
fstr = [fstr tab tab '''CollapseFolders'', 1, ''LogFormat'', ''Detailed'');' endl];
fstr = [fstr '    ' endl];
fstr = [fstr '    %% Step 5: Parse the Results:' endl];
fstr = [fstr '    hd = pwd;' endl];
fstr = [fstr '    cd(fldrTestCaseFull);' endl];
fstr = [fstr endl];

fstr = [fstr '    % Parse the Simulink and CodeCheck Outputs:' endl];
if(flgAllOutputsReg)
    fstr = [fstr '    ResultsSL = ' strModel '_Outputs_Info([''' strModel '_Outputs'' strSL ''.txt'']);' endl];
    fstr = [fstr '    ResultsCC = ' strModel '_Outputs_Info([''' strModel '_Outputs'' strCC ''.txt'']);' endl];
else
    for i = 1:nout
        strOutport = lstModelOutputs{i,1};
        fstr = [fstr '    ResultsSL.' strOutport ' = ' strOutport '_Info([''' strOutport ''' strSL ''.txt'']);' endl];
        fstr = [fstr '    ResultsCC.' strOutport ' = ' strOutport '_Info([''' strOutport ''' strCC ''.txt'']);' endl];
        if(i < nout)
            fstr = [fstr endl];
        end
    end
end
fstr = [fstr endl];
fstr = [fstr '    cd(hd);' endl];
fstr = [fstr endl];

fstr = [fstr '    % Initialize Counters for Figure Saving:' endl];
fstr = [fstr '    nFigsOpen = 0; iFig = 0;' endl];

fstr = [fstr '    % Determine the Plot Decimation based on SimTime' endl];
fstr = [fstr '    idxDec = find(tblDecimation.Time >= SimTime, 1, ''last'');' endl];
fstr = [fstr '    Decimation = tblDecimation.Dec(idxDec);' endl];

fstr = [fstr '    % Figure out PowerPoint filename:' endl];
fstr = [fstr '    strPPTTitle = [''RTW Code Check for '' fldrTestCase];' endl];
fstr = [fstr '    if((flgPlotInputs || flgPlotOutputs) && (flgSave2PPT))' endl];
fstr = [fstr '        pptFilename = [fldrTestCaseFull filesep fldrTestCase ''_SL_and_Autocode_Comparison_Plots.pptx''];' endl];
fstr = [fstr '        try' endl];
fstr = [fstr '            delete(pptFilename);' endl];
fstr = [fstr '        catch' endl];
fstr = [fstr '        end' endl];
fstr = [fstr '     end' endl];

fstr = [fstr endl];
fstr = [fstr '    %% Step 6: Plot the Inputs:' endl];
fstr = [fstr '    if(flgPlotInputs)' endl];
fstr = [fstr '        lstSignalsFull = listStruct(ResultsIN);' endl];
fstr = [fstr endl];
fstr = [fstr '        if(~isempty(lstInputSignalsToPlot))' endl];
fstr = [fstr '            lstSignals2Plot = intersect(lstSignalsFull, lstInputSignalsToPlot);' endl];
fstr = [fstr '        else' endl];
fstr = [fstr '            lstSignals2Plot = lstSignalsFull;' endl];
fstr = [fstr '        end' endl];
fstr = [fstr '        numSignals = size(lstSignals2Plot, 1);' endl];
fstr = [fstr endl];
fstr = [fstr '        for iSignals = 1:numSignals' endl];
fstr = [fstr '            curSignal = lstSignals2Plot{iSignals,:};' endl];
fstr = [fstr '            eval([''ts = ResultsIN.'' curSignal '';'']);' endl];
fstr = [fstr '            ' endl];
fstr = [fstr '            figure(''Name'', curSignal, ''Position'', FigurePosition);' endl];
fstr = [fstr '            plotts(ts, ''xmin'', xmin, ''xmax'', xmax, ''Decimation'', Decimation, ''ForceLegend'', 0, ''PlotOrder'', PlotOrder);' endl];
fstr = [fstr '            clear strTitle;' endl];
fstr = [fstr '            strTitle(1,:) = {[''\fontsize{12}RTW Code Check for '' strrep(fldrTestCase, ''_'', ''\_'')]};' endl];
fstr = [fstr '            strTitle(2,:) = {[''\fontsize{10}'' strrep(curSignal, ''_'', ''\_'')]};' endl];
fstr = [fstr '            title(strTitle);' endl];
fstr = [fstr endl];
fstr = [fstr '            iFig = iFig + 1;' endl];
fstr = [fstr '            arrFigHdl(iFig) = gcf;' endl];
fstr = [fstr '            nFigsOpen = nFigsOpen + 1;' endl];
fstr = [fstr endl];
fstr = [fstr '            if( ~isempty(nMaxFigs) )' endl];
fstr = [fstr '                if((nFigsOpen >= nMaxFigs) || (iSignals == numSignals))' endl];
fstr = [fstr '                    if( flgSave2PPT )' endl];
fstr = [fstr '                        % Save off the batch and then close the figures:' endl];
fstr = [fstr '                        strTitle    = fldrTestCase;' endl];
fstr = [fstr '                        SaveOpenFigures2PPT(pptFilename, [strPPTTitle sprintf(''\nInputs'')], flgDoubleUp, ''CloseAfterSave'', flgClosePPT);' endl];
fstr = [fstr '                        close all;' endl];
fstr = [fstr '                        nFigsOpen = 0;   % Reset Counter' endl];
fstr = [fstr '                    else' endl];
fstr = [fstr '                        % Do a rolling close:' endl];
fstr = [fstr '                        fig2close = iFig - nMaxFigs + 1;' endl];
fstr = [fstr '                        if(fig2close > 0)' endl];
fstr = [fstr '                            close(arrFigHdl(fig2close));' endl];
fstr = [fstr '                            nFigsOpen = nMaxFigs;' endl];
fstr = [fstr '                        end' endl];
fstr = [fstr '                    end' endl];
fstr = [fstr '                end' endl];
fstr = [fstr '            end' endl];
fstr = [fstr '        end' endl];
fstr = [fstr '    end' endl];

fstr = [fstr endl];
fstr = [fstr '    %% Step 7: Compare/Plot the Results (OUTPUTS):' endl];
fstr = [fstr '    lstSignalsFull = listStruct(ResultsSL);' endl];
fstr = [fstr endl];
fstr = [fstr '    if(~isempty(lstOutputSignalsToPlot))' endl];
fstr = [fstr '        lstSignals2Plot = intersect(lstSignalsFull, lstOutputSignalsToPlot);' endl];
fstr = [fstr '    else' endl];
fstr = [fstr '        lstSignals2Plot = lstSignalsFull;' endl];
fstr = [fstr '    end' endl];
fstr = [fstr endl];
fstr = [fstr '    numSignals = size(lstSignals2Plot, 1);' endl];
fstr = [fstr  endl];
fstr = [fstr '    lstFailed = {}; iSignalFailed = 0;' endl];
fstr = [fstr '    lstPassed = {}; iSignalPassed = 0;' endl];

fstr = [fstr endl];
fstr = [fstr '    % Loop through each Bus Signal' endl];
fstr = [fstr '    for iSignals = 1:numSignals' endl];
fstr = [fstr '        curSignal = lstSignals2Plot{iSignals,:};' endl];
fstr = [fstr '        ts = getts(ResultsCC, curSignal, 0, ''xmin'', xmin, ''xmax'', xmax);' endl];
fstr = [fstr '        dimSignal = size(ts.Data, 2);' endl];
fstr = [fstr endl];
fstr = [fstr '        % Loop through each Signal''s dimension (e.g. vectorized result)' endl];
fstr = [fstr '        for iDim = 1:dimSignal' endl];
fstr = [fstr '            if(dimSignal == 1)' endl];
fstr = [fstr '                curSignalDim = curSignal;' endl];
fstr = [fstr '            else' endl];
fstr = [fstr '                curSignalDim = [curSignal ''(:,'' num2str(iDim) '')''];' endl];
fstr = [fstr '            end' endl];
fstr = [fstr '             [flgSignalPass, strPassPercent] = Compare_SL_and_Code(ResultsSL, ResultsCC, ...' endl];
fstr = [fstr '                 curSignalDim, ''Plot'', flgPlotOutputs, ...' endl];
fstr = [fstr '                 ''Title'', fldrTestCase, ''Threshold'', Threshold, ...' endl];
fstr = [fstr '                 ''xmin'', xmin, ''xmax'', xmax, ...' endl];
fstr = [fstr '                 ''Decimation'', Decimation, ''PlotOrder'', PlotOrder, ''FigurePosition'', FigurePosition);' endl];
fstr = [fstr endl];
fstr = [fstr '             if(flgPlotOutputs)' endl];
fstr = [fstr '                 iFig = iFig + 1;' endl];
fstr = [fstr '                 arrFigHdl(iFig) = gcf;' endl];
fstr = [fstr '                 nFigsOpen = nFigsOpen + 1;' endl];
fstr = [fstr '             end' endl];
fstr = [fstr endl];

fstr = [fstr '             if( (~isempty(nMaxFigs)) && flgPlotOutputs )' endl];
fstr = [fstr '                 if((nFigsOpen >= nMaxFigs) || (iSignals == numSignals))' endl];
fstr = [fstr '                     if( flgSave2PPT )' endl];
fstr = [fstr '                         % Save off the batch and then close the figures:' endl];
fstr = [fstr '                         SaveOpenFigures2PPT(pptFilename, [strPPTTitle sprintf(''\nOutput Comparisons'')], flgDoubleUp, ''CloseAfterSave'', flgClosePPT);' endl];
fstr = [fstr '                         close all;' endl];
fstr = [fstr '                         nFigsOpen = 0;   % Reset Counter' endl];
fstr = [fstr '                     else' endl];
fstr = [fstr '                         % Do a rolling close:' endl];
fstr = [fstr '                         fig2close = iFig - nMaxFigs + 1;' endl];
fstr = [fstr '                         if(fig2close > 0)' endl];
fstr = [fstr '                             close(arrFigHdl(fig2close));' endl];
fstr = [fstr '                             nFigsOpen = nMaxFigs;' endl];
fstr = [fstr '                         end' endl];
fstr = [fstr '                     end' endl];
fstr = [fstr '                 end' endl];
fstr = [fstr '             end' endl];

fstr = [fstr endl];
fstr = [fstr '            iSignalPassed = iSignalPassed + flgSignalPass;' endl];
fstr = [fstr '            iSignalFailed = iSignalFailed + ~flgSignalPass;' endl];
fstr = [fstr endl];
fstr = [fstr '            if(~flgSignalPass)' endl];
fstr = [fstr '                lstFailed(iSignalFailed,1) = {sprintf('' %3.0f:'', iSignalFailed)};' endl];
fstr = [fstr '                lstFailed(iSignalFailed,2) = {curSignalDim};' endl];
fstr = [fstr '                lstFailed(iSignalFailed,3) = {strPassPercent};' endl];
fstr = [fstr '            else' endl];
fstr = [fstr '                lstPassed(iSignalPassed,1) = {sprintf('' %3.0f:'', iSignalPassed)};' endl];
fstr = [fstr '                lstPassed(iSignalPassed,2) = {curSignalDim};' endl];
fstr = [fstr '                lstPassed(iSignalPassed,3) = {strPassPercent};' endl];
fstr = [fstr '            end' endl];
fstr = [fstr '            arrPass(iSignals) = flgSignalPass;' endl];
fstr = [fstr '        end' endl];
fstr = [fstr '    end' endl];
fstr = [fstr endl];
fstr = [fstr '    flgPass = all(arrPass);' endl];
fstr = [fstr '    endl = sprintf(''\n'');   % Line Return' endl];
fstr = [fstr endl];
fstr = [fstr '    %% Log Complete Results for the TestCase:' endl];
fstr = [fstr '    log_filename_tc = [fldrTestCaseFull filesep strModel ''_'' strTestCase ''_CodeCheckLog.txt''];' endl];
fstr = [fstr '    fid = fopen(log_filename_tc, ''w'');' endl];
fstr = [fstr '    fstr = '''';' endl];
fstr = [fstr '    fstr = [fstr ''Test Case: '' strTestCase endl];' endl];
fstr = [fstr '    fstr = [fstr sprintf(''Time Frame: %.2f to %.2f [sec] (%d Timesteps)'', ...' endl];
fstr = [fstr '        ts.TimeInfo.Start, ts.TimeInfo.End, ts.TimeInfo.Length) endl];' endl];
fstr = [fstr '    fstr = [fstr ''Threshold: '' num2str(Threshold) endl];' endl];
fstr = [fstr '    numTotalSignals = iSignalPassed + iSignalFailed;' endl];
fstr = [fstr '    fstr = [fstr ''Signals Passed: '' num2str(iSignalPassed) ''/'' ...' endl];
fstr = [fstr '        num2str(numTotalSignals) '' ('' num2str(iSignalPassed/numTotalSignals*100) ''%)'' endl];' endl];
fstr = [fstr '    if(iSignalFailed > 0)' endl];
fstr = [fstr '        fstr = [fstr ''All Signals Passed: NO'' endl];' endl];
fstr = [fstr '        fstr = [fstr ''Signals with issues ('' num2str(iSignalFailed) ''):'' endl];' endl];
fstr = [fstr '        fstr = [fstr Cell2PaddedStr(lstFailed, ''Padding'', ''  '') endl];' endl];
fstr = [fstr '    else' endl];
fstr = [fstr '        fstr = [fstr ''All Signals Passed: YES'' endl];' endl];
fstr = [fstr '    end' endl];
fstr = [fstr endl];
fstr = [fstr '    if(iSignalPassed > 0)' endl];
fstr = [fstr '        fstr = [fstr ''Signals that Passed ('' num2str(iSignalPassed) ''):'' endl];' endl];
fstr = [fstr '        fstr = [fstr Cell2PaddedStr(lstPassed, ''Padding'', ''  '') endl];' endl];
fstr = [fstr '    end' endl];
fstr = [fstr '    fprintf(fid, ''%s'', fstr);' endl];
fstr = [fstr '    fclose(fid);' endl];
fstr = [fstr endl];
fstr = [fstr '    %% Update the Running Log (Full):' endl];
fstr = [fstr '    log_filename = [fldrTestCaseRoot filesep strModel ''_CodeCheckLogMaster.txt''];' endl];
fstr = [fstr '    if((flgWipeLog) && (iIdxTC == 1))' endl];
fstr = [fstr '        fid = fopen(log_filename, ''w'');' endl];
fstr = [fstr '    else' endl];
fstr = [fstr '        fid = fopen(log_filename, ''a'');' endl];
fstr = [fstr '    end' endl];
fstr = [fstr '    fstr = '''';' endl];
fstr = [fstr '    fstr = [fstr ''Test Number: #'' num2str(idxTC) endl];' endl];
fstr = [fstr '    fstr = [fstr ''Test Case: '' strTestCase endl];' endl];
fstr = [fstr '    fstr = [fstr sprintf(''Time Frame: %.2f to %.2f [sec] (%d Timesteps)'', ...' endl];
fstr = [fstr '        ts.TimeInfo.Start, ts.TimeInfo.End, ts.TimeInfo.Length) endl];' endl];
fstr = [fstr '    fstr = [fstr ''Threshold: '' num2str(Threshold) endl];' endl];
fstr = [fstr '    numTotalSignals = iSignalPassed + iSignalFailed;' endl];
fstr = [fstr '    fstr = [fstr ''Signals Passed: '' num2str(iSignalPassed) ''/'' ...' endl];
fstr = [fstr '        num2str(numTotalSignals) '' ('' num2str(iSignalPassed/numTotalSignals*100) ''%)'' endl];' endl];
fstr = [fstr '    if(iSignalFailed > 0)' endl];
fstr = [fstr '        fstr = [fstr ''All Signals Passed: NO'' endl];' endl];
fstr = [fstr '        fstr = [fstr ''Signals with issues:'' endl];' endl];
fstr = [fstr '        fstr = [fstr Cell2PaddedStr(lstFailed, ''Padding'', ''  '') endl];' endl];
fstr = [fstr '    else' endl];
fstr = [fstr '        fstr = [fstr ''All Signals Passed: YES'' endl];' endl];
fstr = [fstr '    end' endl];
fstr = [fstr '    fstr = [fstr endl];' endl];
fstr = [fstr '    fprintf(fid, ''%s'', fstr);' endl];
fstr = [fstr '    fclose(fid);' endl];
fstr = [fstr endl];

fstr = [fstr tab '% Open TestCase Log File for Viewing:' endl];
fstr = [fstr tab 'if(flgViewLogTC)' endl];
fstr = [fstr tab tab 'edit(log_filename_tc);' endl];
fstr = [fstr tab 'end' endl];
fstr = [fstr endl];
fstr = [fstr 'end' endl];
fstr = [fstr endl];
fstr = [fstr '% Open Complete Log File for Viewing:' endl];
fstr = [fstr 'edit(log_filename);' endl];
fstr = [fstr endl];
fstr = [fstr '%% Post Housekeeping:' endl];
fstr = [fstr 'clear fstr endl fid iDim iSignalPassed iSignalFailed' endl];
fstr = [fstr 'clear arrPass log_filename ts;' endl];
fstr = [fstr endl];
fstr = [fstr '%% << End of Script Verify_CodeCheck_MPMgr.m >>' endl];
fstr = [fstr endl];

%% Revision section
fstr = [fstr '%% REVISION HISTORY' endl ...
    ... '% ONLY REQUIRED FOR FILES NOT UNDER REVISION CONTROL'... %skip this line
    '% YYMMDD INI: note' endl ...
    '% <YYMMDD> <initials>: <Revision update note>' endl ...
    '% ' datestr(now,'YYmmdd') ' <INI>: Created function using ' mfnam endl ...
    '%**Add New Revision notes to TOP of list**' endl ...
    endl ...
    '% Initials Identification: ' endl ...
    '% INI: FullName            : Email     : NGGN Username ' endl ...
    '% <initials>: <Fullname>   : <email>   : <NGGN username> ' endl ...
    endl];

%% Footer
% Order is reversed from header
% DistributionStatement,ITARparagraph Proprietary ITAR, Classification
fstr = [fstr '%% FOOTER' endl];
% Distribution Statement
if ~isempty(CNF_info.DistibStatement)
    fstr = [fstr CNF_info.DistibStatement endl];
    fstr = [fstr endl];
end

% Itar Paragraph
if ~isempty(CNF_info.ITAR_Paragraph)
    fstr = [fstr '%' endl];
    fstr = [fstr CNF_info.ITAR_Paragraph];
    if(~strcmp(CNF_info.ITAR_Paragraph(end), endl))
        fstr = [fstr endl];
    end
    fstr = [fstr '%' endl];
end

%% Footer Proprietary Lines
if ~isempty(CNF_info.Proprietary)
    fstr = [fstr '% ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Footer ITAR Lines
if ~isempty(CNF_info.ITAR)
    fstr = [fstr '% ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Footer Classified Lines
if ~isempty(CNF_info.Classification)
    fstr = [fstr '% ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

filename = ['Verify_CodeCheck_' strModel];
info.fname_full = [SaveFolder filesep filename '.m'];

info.text = fstr;

if exist(info.fname_full,'file') == 2 % an mfile
    if(prompt_to_overwrite)
        disp([mfnam '>> WARNING: ''' filename '.m'' already exists here: ' SaveFolder]);
        R = input([mfnam '>> Do you want to Overwrite this file? {Y,[N]}'],'s');
        R = upper(R);
        if isempty(R)
            R = 'N';
        end
    else
        R = prompt_to_overwrite_val;
    end
else
    R = 'Y';
end
        
if strcmpi(R(1), 'Y')
    
    if(mislocked(filename))
        munlock(filename);
        clear(filename);
    end
    if(exist(filename) == 2)
        delete(filename);
    end
    [fid, message ] = fopen(info.fname_full, 'wt','native');
    
    if fid == -1
        info.error = [mfnam '>> ERROR: File Not created: ' message];
        disp(info.error)
        return
    else %any answer besides 'Y'
        fprintf(fid,'%s',fstr);
        fclose(fid);
        if(OpenAfterCreated)
            edit(info.fname_full);
        end
        info.OK = 'maybe it worked';

        if(flgVerbose)
            [fldrSave, strFile, strExt] = fileparts(info.fname_full);
            disp(sprintf('%s : Wrote ''%s%s'' in ''%s''...', mfnam, strFile, strExt, fldrSave));
        end
    end
end

end % << End of function Write_CodeCheck_Verify >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 110520 <INI>: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName            : Email     : NGGN Username 
% <initials>: <Fullname>   : <email>   : <NGGN username> 

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
