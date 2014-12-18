% CREATEBO2DR Creates a block that bus selects a bus object into individual 'To File' blocks
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateBO2DR:
% Creates a block that bus selects all members of a bus object and passes
% each individual signal to its own 'To File' block for data recording
% purposes.  Signals are saved with filenames corresponding to the bus
% member name and with 'ts' as the workspace variable name.
% 
% SYNTAX:
%	CreateBO2DR(BusObject, System, varargin, 'PropertyName', PropertyValue)
%	CreateBO2DR(BusObject, varargin, 'PropertyName', PropertyValue)
%	CreateBO2DR(BusObject, varargin)
%	CreateBO2DR(BusObject)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	BusObject	[varies]    N/A         Reference Simulink bus object.  Can
%                                       be of name of the bus object (e.g.
%                                       a string) or the bus object itself
%   System      'string'    [char]      Name of Simulink model to create
%                                       containing the BO2DR block
%                                        Default: [<BusObject> '_BO2DR']
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
% OUTPUTS: 
%	Name    	Size		Units		Description
%	<BusObject>_BO2DR.mdl               Simulink unit test model containing
%                                       the bus object to 'To File' blocks
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default             Description
%   'System'            'string'        [<BusObject>_BO2DR] Desired name for
%                                                           Simulink BO2DR
%                                                           block
%   'SaveDir'           'string'        [pwd filesep 'Test'] Save directory
%                                                           for time
%                                                           history data
%   'BOInfoStruct'      'string'        'BOInfo.'           Name of bus
%                                                           object
%                                                           information
%                                                           structure
%   'BORoot'            'string'        <BusObject>         Root name to
%                                                           use for
%                                                           filenames
%                                                           (format
%                                                           <BusObject>.signal
%
% EXAMPLES:
%   % Example #1: Build a Bus Object and the BO2DR block
%   % Create Bus1:
%       strBO = 'BOBus1';
%       lstBO = {
%           'MET_sec'   1   ''          '[sec]';
%           'Alpha_deg' 1   ''          '[deg]';
%           'P_ned_ft'  3   'single'    '[deg]';
%           'WOW_flg'   1   'boolean'   '[flg]';
%           };
%   BuildBusObject(strBO, lstBO);
%   BOInfo.(strBO) = lstBO; clear lstBO;
%	CreateBO2DR(strBO)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CreateBO2DR.m">CreateBO2DR.m</a>
%	  Driver script: <a href="matlab:edit Driver_CreateBO2DR.m">Driver_CreateBO2DR.m</a>
%	  Documentation: <a href="matlab:winopen(which('CreateBO2DR_Function_Documentation.pptx'));">CreateBO2DR_Function_Documentation.pptx</a>
%
% See also CreateVec2BO, CreateTestHarness, BusObject2List, cell2str
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/766
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CreateBO2DR.m $
% $Rev: 2339 $
% $Date: 2012-07-09 17:24:48 -0700 (Mon, 09 Jul 2012) $
% $Author: sufanmi $

function CreateBO2DR(BusObject, varargin)

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

%% Input Argument Conditioning:
[System, varargin]          = format_varargin('System', '', 2, varargin);
[strSaveDir, varargin]      = format_varargin('SaveDir', '[pwd filesep ''Test'']', 2, varargin);
[strBOInfoStruct, varargin] = format_varargin('BOInfoStruct', 'BOInfo.', 2, varargin);
[FlattenVectors, varargin]  = format_varargin('FlattenVectors', false, 2, varargin);


% Pick out Properties Entered via varargin
BlockToUseFull = 'Sinks/To File';

if(ischar(BusObject))
    strBO = BusObject;
else
    strBO = inputname(1);
end

[strBORoot, varargin]  = format_varargin('BORoot', ['' strrep(strBO, 'BO_', '') ''], 2, varargin);

if (nargin < 2)
    System = '';
end

if(isempty(System))
    System = [strBO '_BO2DR'];
end

%% Main Function:
load_system('Simulink');

lstBO = BusObject2List(strBO);
str_Signals_to_Select = cell2str(lstBO(:,1));

numSignals = size(lstBO, 1);
numTotalSignals = sum(cell2mat(lstBO(:,2)));

if(FlattenVectors)
    numBlocks = numTotalSignals;
else
    numBlocks = numSignals;
end

%% Spacing Control:
BlockSize       = [500 16];   % [width height]
LeftMargin      = 20+100;
TopMargin       = 15;
VerticalSpacing = 25+10;           % Make sure this > BlockSize(2)
BSPad           = 100;
DemuxPad        = 120;
DRPad           = 100;

%% Create the model if one doesn't exist:
% Attempt to close the models if they are already open by accident:
close_system([System '_old.mdl'], 0);
close_system([System '_sub.mdl'], 0);
close_system([System '_sub_old.mdl'], 0);
close_system(System, 0);

if (exist(System, 'file'))
    open_system(System);
    save_system(System, [System '_old']);
    close_system([System '_old.mdl'], 0);
    evalin('base', ['!del ' System '.mdl']);
    new_system(System);
    open_system(System);
    save_system(System);
else
    new_system(System);
    open_system(System);
    save_system(System);
end

if (exist([System '_sub'], 'file'))
    evalin('base', ['!del ' [System '_sub'] '.mdl']);
end
new_system([System '_sub']);
open_system([System '_sub']);
save_system([System '_sub']);

%% Add an Input Port:
hdlIn = add_block('Simulink/Sources/In1', [System '/' strBO]);
InPortSize = GetBlockSize(hdlIn);

InputPortPos(1) =  LeftMargin - 20;                      % left edge
InputPortPos(2) =  TopMargin + (VerticalSpacing * numBlocks)/2;                % top edge
InputPortPos(3) =  InputPortPos(1) + InPortSize(1); % right edge
InputPortPos(4) =  InputPortPos(2) + InPortSize(2); % bottom edge
set_param(hdlIn, 'Position', InputPortPos);
set_param(hdlIn, 'BusObject', strBO)
set_param(hdlIn, 'UseBusObject', 'on');

hdlIn_PH = get_param(hdlIn, 'PortHandles');
InputPortSigPos = get_param(hdlIn_PH.Outport(1), 'Position');

%% Add the Bus Selector:
hdlBS = add_block('Simulink/Signal Routing/Bus Selector', [System '/BusSelector']);
BSSize = GetBlockSize(hdlBS);
BSPos(1) =  InputPortSigPos(1) + BSPad;           % left edge
BSPos(2) =  InputPortSigPos(2) -(VerticalSpacing * numBlocks)/2;                  % top edge
BSPos(3) =  BSPos(1) + BSSize(1);       % right edge
BSPos(4) =  BSPos(2) +(VerticalSpacing * numBlocks);                  % bottom edge
set_param(hdlBS, 'Position', BSPos);
set_param(hdlBS, 'OutputSignals', str_Signals_to_Select);

% Connect the input port to the bus selector
add_line(System, [strBO '/1'], ['BusSelector/1'] );

hdlBSPorts = get_param(hdlBS, 'PortHandles');

%%
for iElement = 1:numSignals
    curElement = lstBO(iElement,:);
    
    curName = curElement{1};
    curDim  = curElement{2};
    
    numLoops = 1;
    if(FlattenVectors && (curDim > 1))
        numLoops = curDim;
        
        BSSignalPos = get_param(hdlBSPorts.Outport(iElement), 'Position');
        
        % Add Demux
        hdlDemux = add_block('Simulink/Signal Routing/Demux', [System '/Demux_' curName]);
        set_param(hdlDemux, 'Outputs', num2str(curDim));
        
        hdlDemuxPorts = get_param(hdlDemux, 'PortHandles');
        
        DemuxSize = GetBlockSize(hdlDemux);
        DemuxPos(1) =  BSSignalPos(1) + DemuxPad;            % left edge
        DemuxPos(2) =  BSSignalPos(2) - (numLoops*VerticalSpacing)/2;    % top edge
        DemuxPos(3) =  DemuxPos(1) + DemuxSize(1);            % right edge
        DemuxPos(4) =  DemuxPos(2) + (numLoops*VerticalSpacing);            % bottom edge
        set_param(hdlDemux, 'Position', DemuxPos);
        
        % Connect Bus Selector to Demux
        add_line(System, hdlBSPorts.Outport(iElement), hdlDemuxPorts.Inport(1));
        
    end
    
    for iDim = 1:numLoops
        if(FlattenVectors && (curDim > 1))
            curFilename = curElement{1};
            curBlockName = sprintf('%s(%d)', curElement{1}, iDim);
            
            ptrSpacer = strfind(curFilename, '_');
            
            if(isempty(ptrSpacer))
                curFilename = [curFilename num2str(iDim)];
                
            else
                strMemRoot = curFilename(1:ptrSpacer(end)-1);
                strMemUnits = curFilename(ptrSpacer(end)+1:end);
                curFilename = sprintf('%s%d_%s', strMemRoot, iDim, strMemUnits);
            end
            
            curFilename = MangleName(curFilename, false);
        else
            curFilename = curElement{1};
            curBlockName = curElement{1};
        end
        
        ptrPeriod = strfind(curFilename, '.');
        if(~isempty(ptrPeriod))
            curFilename = curFilename(ptrPeriod(end)+1:end);
        end
        
        %% Add the Intermediate Block (Data Recorder):
        ptrSlash = strfind(BlockToUseFull, '/');
        if(~isempty(ptrSlash))
            BlockToUse = BlockToUseFull(ptrSlash(end)+1:end);
        else
            BlockToUse = BlockToUseFull;
        end
        
        hdlDR = add_block(['Simulink/' BlockToUseFull], [System '/' BlockToUse num2str(iElement)]);
        hdlDRPorts = get_param(hdlDR, 'PortHandles');
        
        DRSize = GetBlockSize(hdlDR);
        
        if(FlattenVectors && (curDim > 1))
            DemuxOutSignalPos = get_param(hdlDemuxPorts.Outport(iDim), 'Position');
            DRPos(1) =  BSOutSignalPos(1) + DemuxPad + DRPad;     % left edge
            DRPos(2) =  DemuxOutSignalPos(2) - BlockSize(2)/2;    % top edge
            DRPos(3) =  DRPos(1) + BlockSize(1);            % right edge
            DRPos(4) =  DRPos(2) + BlockSize(2);            % bottom edge
        else
            
            BSOutSignalPos = get_param(hdlBSPorts.Outport(iElement), 'Position');
            
            DRPos(1) =  BSOutSignalPos(1) + DemuxPad + DRPad;            % left edge
            DRPos(2) =  BSOutSignalPos(2) - BlockSize(2)/2;    % top edge
            DRPos(3) =  DRPos(1) + BlockSize(1);            % right edge
            DRPos(4) =  DRPos(2) + BlockSize(2);            % bottom edge
        end
        set_param(hdlDR, 'Position', DRPos);
        
        if(FlattenVectors && (curDim > 1))
            % Connect Demux to Data Recorder
            add_line(System, hdlDemuxPorts.Outport(iDim), hdlDRPorts.Inport(1));
        else
            % Connect Bus Selector to Data Recorder:
            add_line(System, hdlBSPorts.Outport(iElement), hdlDRPorts.Inport(1));
        end
        
        % Set mask parameters on the 'To File' block:
        set_param(hdlDR, 'Name', [strBO '.' curBlockName]);
        set_param(hdlDR, 'ShowName', 'on');
        set_param(hdlDR, 'MatrixName', 'ts');
        set_param(hdlDR, 'Filename', [curFilename '.mat']);
        set_param(hdlDR, 'SaveFormat', 'Timeseries');
        set_param(hdlDR, 'SampleTime', '-1');
        
    end
end

set_param(System, 'ZoomFactor', 'FitSystem');
CleanBlockPorts(System);

%% Add Hyperlink

% Place hyperlink below output port
hypPos(1) = InputPortPos(1);       % x-location
hypPos(2) = BSPos(4) + 30;  % y-location (Below the bus selector)

TextToAdd = sprintf('%s(''%s'', ''SaveDir'', ''%s'', ''BORoot'', ''%s'')', ...
    mfnam, strBO, strrep(strSaveDir, '''', ''''''), strrep(strBORoot, '''', ''''''));
Hyperlink = [strBO '_BO2DR/' TextToAdd];
hyp = add_block('built-in/Note', Hyperlink, 'HorizontalAlignment', 'left');
set_param(hyp, 'Position', hypPos);
set_param(hyp, 'UseDisplayTextAsClickCallback', 'on')
% set_param(hyp, 'ClickFcn', TextToAdd);
set_param(hyp, 'DropShadow', 'on');
set_param(hyp, 'FontSize', '12', 'FontWeight', 'bold');

% Save It
save_system(System);

%% Copy the System to a new model and subsystem:
add_block('built-in/Subsystem', [System '_sub/' strBO '_BO2DR']);
Simulink.BlockDiagram.copyContentsToSubSystem(System, [System '_sub/' strBO '_BO2DR']);
SubsysSize = [230 40];
SubsysXY  = [20 20];

SubsysPos(1) = SubsysXY(1);
SubsysPos(2) = SubsysXY(2);
SubsysPos(3) = SubsysPos(1) + SubsysSize(1);
SubsysPos(4) = SubsysPos(2) + SubsysSize(2);

newSys = [System '_sub'];
set_param([newSys '/' strBO '_BO2DR'], 'Position', SubsysPos);

% Place hyperlink below output port
hypPos(1) = SubsysPos(1);       % x-location
hypPos(2) = SubsysPos(4) + 30;  % y-location (Below the bus selector)

TextToAdd = sprintf('%s(''%s'', ''SaveDir'', ''%s'', ''BORoot'', ''%s'')', ...
    mfnam, strBO, strrep(strSaveDir, '''', ''''''), strrep(strBORoot, '''', ''''''));
Hyperlink = [newSys '/' TextToAdd];
hyp = add_block('built-in/Note', Hyperlink, 'HorizontalAlignment', 'left');
set_param(hyp, 'Position', hypPos);
set_param(hyp, 'UseDisplayTextAsClickCallback', 'on')
% set_param(hyp, 'ClickFcn', TextToAdd);
set_param(hyp, 'DropShadow', 'on');
set_param(hyp, 'FontSize', '12', 'FontWeight', 'bold');

%%
hdl_blk = [System '_sub/' strBO '_BO2DR'];
set_param(hdl_blk, 'Mask', 'on');

lstMaskVariables = 'msk_dir=@1;msk_bo=@2;msk_root=@3;';
set_param(hdl_blk, 'MaskVariables', lstMaskVariables);

lstMaskPrompts = {...
    'Save Directory (e.g. pwd)';
    'Bus Object Info (BOInfo.<Bus Object>)';
    'Root Name (if different from bus object name)'};
set_param(hdl_blk, 'MaskPrompts', lstMaskPrompts);

lstMaskValues = {...
  strSaveDir;
  [strBOInfoStruct strBO];
  strBORoot};
set_param(hdl_blk, 'MaskValues', lstMaskValues);
set_param(hdl_blk, 'MaskEnablestring', 'on,on,on');

% strInitFcn = getStrInitFcn();
set_param(hdl_blk, 'InitFcn', 'BO2DR_Callbacks(gcb, ''init'')');

% strStopFcn = getStrStopFcn();
strInitFcn = ['BO2DR_InitFcn_Callback(gcb);' endl];
set_param(hdl_blk, 'StopFcn', 'BO2DR_Callbacks(gcb, ''stop'')');
set_param(hdl_blk, 'MaskIconUnits', 'normalized');
set_param(hdl_blk, 'MaskIconOpaque', 'off');

strMaskInit = [...
    'lstMaskValues = get_param(gcb, ''MaskValues'');' endl ...
    'str_dir = lstMaskValues{1,:};' endl ...
    'str_bo  = lstMaskValues{2,:};' endl ...
    'str_root= lstMaskValues{3,:};'];
set_param(hdl_blk, 'MaskInitialization', strMaskInit);

strMaskDisplay = [...
    'text(0.3, 0.8, [''Save Dir: '' str_dir]);' endl ...
    'text(0.3, 0.55, [''BO Info: '' str_bo]);'  endl ...
    'text(0.3, 0.3, [''BO Root: '' str_root]);'];
set_param(hdl_blk, 'MaskDisplay', strMaskDisplay);

%%

close_system(System);
save_system([System '_sub'], System);
evalin('base', ['!del ' System '_sub.mdl']);
close_system('Simulink', 0)

end % << End of function CreateBO2DR >>

% function strInitFcn = getStrInitFcn()
% endl = sprintf('\n');                               % Line Return
% strInitFcn = '';
% strInitFcn = [strInitFcn '% Grab Mask Values' endl];
% strInitFcn = [strInitFcn 'hdl = gcb;' endl];
% strInitFcn = [strInitFcn 'mskValues = get_param(hdl, ''MaskValues'');' endl];
% strInitFcn = [strInitFcn 'saveDir     = mskValues{1,1};' endl];
% strInitFcn = [strInitFcn 'strBOInfo   = mskValues{2,1};' endl];
% strInitFcn = [strInitFcn 'strRoot     = eval(mskValues{3,1});' endl];
% strInitFcn = [strInitFcn '' endl];
% strInitFcn = [strInitFcn '% Process ''saveDir''' endl];
% strInitFcn = [strInitFcn 'if(strcmp(saveDir, ''0''))' endl];
% strInitFcn = [strInitFcn '    saveDir = ''pwd'';' endl];
% strInitFcn = [strInitFcn 'end' endl];
% strInitFcn = [strInitFcn 'saveDir = evalin(''base'',saveDir);' endl];
% strInitFcn = [strInitFcn 'if(~isdir(saveDir))' endl];
% strInitFcn = [strInitFcn '    mkdir(saveDir);' endl];
% strInitFcn = [strInitFcn 'end' endl];
% strInitFcn = [strInitFcn 'if(~strcmp(saveDir(end), filesep))' endl];
% strInitFcn = [strInitFcn '    saveDir = [saveDir filesep];' endl];
% strInitFcn = [strInitFcn 'end' endl];
% strInitFcn = [strInitFcn '' endl];
% strInitFcn = [strInitFcn '% Process ''strBOInfo''' endl];
% strInitFcn = [strInitFcn 'ptrPeriod = strfind(strBOInfo, ''.'');' endl];
% strInitFcn = [strInitFcn 'if(isempty(ptrPeriod))' endl];
% strInitFcn = [strInitFcn '    strBO = strBOInfo;' endl];
% strInitFcn = [strInitFcn 'else' endl];
% strInitFcn = [strInitFcn '    strBO = strBOInfo(ptrPeriod(end)+1:end);' endl];
% strInitFcn = [strInitFcn 'end' endl];
% strInitFcn = [strInitFcn 'lstBOInfo = evalin(''base'', strBOInfo);' endl];
% strInitFcn = [strInitFcn '' endl];
% strInitFcn = [strInitFcn '[numSignals, numCols] = size(lstBOInfo);' endl];
% strInitFcn = [strInitFcn '' endl];
% strInitFcn = [strInitFcn 'hdlBS = [hdl ''/BusSelector''];' endl];
% strInitFcn = [strInitFcn 'numBSSignals = size(get_param(hdlBS, ''OutputSignalNames''),2);' endl];
% strInitFcn = [strInitFcn 'if(numSignals ~= numBSSignals)' endl];
% strInitFcn = [strInitFcn '    strError = sprintf(''Error : Number of signals in bus object ''''%s'''' (%d) does not match the number of signals selected in underlying bus selector (%d). Current BO2DR appears outdated.  Rerun CreateBO2DR to fix.'', ...' endl];
% strInitFcn = [strInitFcn '    strBO, numSignals, numBSSignals);' endl];
% strInitFcn = [strInitFcn '    error(strError);' endl];
% strInitFcn = [strInitFcn 'end' endl];
% strInitFcn = [strInitFcn '' endl];
% strInitFcn = [strInitFcn 'for iSignal = 1:numSignals' endl];
% strInitFcn = [strInitFcn '    curSignal = lstBOInfo{iSignal, 1};' endl];
% strInitFcn = [strInitFcn '    hdlDR = [hdl ''/'' strBO ''.'' curSignal];' endl];
% strInitFcn = [strInitFcn '    strFilename = [saveDir strRoot ''.'' curSignal ''.mat''];' endl];
% strInitFcn = [strInitFcn '    set_param(hdlDR, ''Filename'', strFilename);' endl];
% strInitFcn = [strInitFcn 'end' endl];
% end
%%
% function strStopFcn = getStrStopFcn()
% endl = sprintf('\n');                               % Line Return
% strStopFcn = '';
% strStopFcn = [strStopFcn '% Grab Mask Values' endl];
% strStopFcn = [strStopFcn 'hdl = gcb;' endl];
% strStopFcn = [strStopFcn 'mskValues = get_param(hdl, ''MaskValues'');' endl];
% strStopFcn = [strStopFcn 'saveDir     = mskValues{1,1};' endl];
% strStopFcn = [strStopFcn 'strBOInfo   = mskValues{2,1};' endl];
% strStopFcn = [strStopFcn 'strRoot     = eval(mskValues{3,1});' endl];
% strStopFcn = [strStopFcn '' endl];
% strStopFcn = [strStopFcn '% Process ''saveDir''' endl];
% strStopFcn = [strStopFcn 'if(strcmp(saveDir, ''0''))' endl];
% strStopFcn = [strStopFcn '    saveDir = ''pwd'';' endl];
% strStopFcn = [strStopFcn 'end' endl];
% strStopFcn = [strStopFcn 'saveDir = evalin(''base'',saveDir);' endl];
% strStopFcn = [strStopFcn 'if(~isdir(saveDir))' endl];
% strStopFcn = [strStopFcn '    mkdir(saveDir);' endl];
% strStopFcn = [strStopFcn 'end' endl];
% strStopFcn = [strStopFcn 'if(~strcmp(saveDir(end), filesep))' endl];
% strStopFcn = [strStopFcn '    saveDir = [saveDir filesep];' endl];
% strStopFcn = [strStopFcn 'end' endl];
% strStopFcn = [strStopFcn '' endl];
% strStopFcn = [strStopFcn '% Process ''strBOInfo''' endl];
% strStopFcn = [strStopFcn 'ptrPeriod = strfind(strBOInfo, ''.'');' endl];
% strStopFcn = [strStopFcn 'if(isempty(ptrPeriod))' endl];
% strStopFcn = [strStopFcn '    strBO = strBOInfo;' endl];
% strStopFcn = [strStopFcn 'else' endl];
% strStopFcn = [strStopFcn '    strBO = strBOInfo(ptrPeriod(end)+1:end);' endl];
% strStopFcn = [strStopFcn 'end' endl];
% strStopFcn = [strStopFcn 'lstBOInfo = evalin(''base'', strBOInfo);' endl];
% strStopFcn = [strStopFcn '' endl];
% strStopFcn = [strStopFcn '[numSignals, numCols] = size(lstBOInfo);' endl];
% strStopFcn = [strStopFcn 'flgUnits  = numCols > 3;' endl];
% strStopFcn = [strStopFcn 'for iSignal = 1:numSignals' endl];
% strStopFcn = [strStopFcn '    curSignal = lstBOInfo{iSignal, 1};' endl];
% strStopFcn = [strStopFcn '    hdlDR = [hdl ''/'' strBO ''.'' curSignal];' endl];
% strStopFcn = [strStopFcn '    strFilename = [saveDir strRoot ''.'' curSignal ''.mat''];' endl];
% strStopFcn = [strStopFcn '    if(flgUnits)' endl];
% strStopFcn = [strStopFcn '        curUnits  = lstBOInfo{iSignal, 4};' endl];
% strStopFcn = [strStopFcn '        if(~isempty(curUnits))' endl];
% strStopFcn = [strStopFcn '            disp(sprintf(''%s Stop Callback : %d/%d : %s.%s : Appending ''''%s'''' units...'', ...' endl];
% strStopFcn = [strStopFcn '                gcb, iSignal, numSignals, strRoot, curSignal, curUnits));' endl];
% strStopFcn = [strStopFcn '            load(strFilename);' endl];
% strStopFcn = [strStopFcn '            ts.DataInfo.Units = curUnits;' endl];
% strStopFcn = [strStopFcn '            ts.Name = [strRoot ''.'' curSignal];' endl];
% strStopFcn = [strStopFcn '            save(strFilename, ''ts'');' endl];
% strStopFcn = [strStopFcn '        end' endl];
% strStopFcn = [strStopFcn '    end' endl];
% strStopFcn = [strStopFcn 'end' endl];
% 
% end
%% REVISION HISTORY
% YYMMDD INI: note
% 121005 MWS: Created function based on CreateBO2Vec
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
