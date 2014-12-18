% CREATEDR2BO Creates a block that bus selects a bus object into individual 'To File' blocks
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateDR2BO:
% Creates a block that bus selects all members of a bus object and passes
% each individual signal to its own 'To File' block for data recording
% purposes.  Signals are saved with filenames corresponding to the bus
% member name and with 'ts' as the workspace variable name.
% 
% SYNTAX:
%	CreateDR2BO(BusObject, System, varargin, 'PropertyName', PropertyValue)
%	CreateDR2BO(BusObject, varargin, 'PropertyName', PropertyValue)
%	CreateDR2BO(BusObject, varargin)
%	CreateDR2BO(BusObject)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	BusObject	[varies]    N/A         Reference Simulink bus object.  Can
%                                       be of name of the bus object (e.g.
%                                       a string) or the bus object itself
%   System      'string'    [char]      Name of Simulink model to create
%                                       containing the BO2DR block
%                                        Default: [<BusObject> '_DR2BO']
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
% OUTPUTS: 
%	Name    	Size		Units		Description
%	<BusObject>_DR2BO.mdl               Simulink unit test model containing
%                                       the bus object to 'To File' blocks
% NOTES:
%   Function is supported by 'DR2BO_InitFcn_Callback'.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default             Description
%   'System'            'string'        [<BusObject>_DR2BO] Desired name for
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
%	CreateDR2BO(strBO)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CreateDR2BO.m">CreateDR2BO.m</a>
%	  Driver script: <a href="matlab:edit Driver_CreateDR2BO.m">Driver_CreateDR2BO.m</a>
%	  Documentation: <a href="matlab:winopen(which('CreateDR2BO_Function_Documentation.pptx'));">CreateDR2BO_Function_Documentation.pptx</a>
%
% See also CreateVec2BO, CreateTestHarness, BusObject2List, cell2str
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/811
%  
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CreateDR2BO.m $
% $Rev: 3002 $
% $Date: 2013-08-26 13:36:10 -0500 (Mon, 26 Aug 2013) $
% $Author: sufanmi $

function CreateDR2BO(BusObject, varargin)

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
% [strBOInfoStruct, varargin] = format_varargin('BOInfoStruct', 'BOInfo.', 2, varargin);
[FlattenVectors, varargin]  = format_varargin('FlattenVectors', false, 2, varargin);
[lstMangleFindReplace, varargin]= format_varargin('MangleListFindReplace', {},  2, varargin);


% Pick out Properties Entered via varargin
% BlockToUseFull = 'Sinks/To File';
BlockToUseFull = 'Sources/From File';

if(ischar(BusObject))
    strBO = BusObject;
else
    strBO = inputname(1);
end

[strBORoot, varargin]  = format_varargin('BORoot', ['' strrep(strBO, 'BO_', '') ''], 3, varargin);

if (nargin < 2)
    System = '';
end

if(isempty(System))
    System = [strBO '_DR2BO'];
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
% BlockSize       = [150 15];   % [width height]
LeftMargin      = 20;
TopMargin       = 15;
VerticalSpacing = 25+10;           % Make sure this > BlockSize(2)
MuxPad          = 20;
ReshapePad      = 20;
DTCPad          = 200;
BCPad           = 200;
OPPad           = 50;

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

%% Add the From File:
ptrSlash = strfind(BlockToUseFull, '/');
if(~isempty(ptrSlash))
    BlockToUse = BlockToUseFull(ptrSlash(end)+1:end);
else
    BlockToUse = BlockToUseFull;
end

%% Add a BusCreator:
hBC = add_block('Simulink/Signal Routing/Bus Creator', [System '/BusCreator']);
set_param(hBC, 'ShowName', 'On');
BCSize = GetBlockSize(hBC);
BCPos(1) = LeftMargin + BlockSize(1) + MuxPad + ReshapePad + DTCPad + BCPad; % left edge
BCPos(2) = TopMargin;                               % top edge
BCPos(3) = BCPos(1) + BCSize(1);                    % right edge
BCPos(4) = BCPos(2) + VerticalSpacing * numBlocks;  % bottom edge
set_param(hBC, 'Position', BCPos);

set_param(hBC, 'Inputs', num2str(numSignals));
hdlBCPorts = get_param(hBC, 'PortHandles');
set_param(hBC, 'UseBusObject', 'on');
set_param(hBC, 'BusObject', strBO);
BCOutputPortPos = get_param(hdlBCPorts.Outport(1), 'Position');

%% Add an Output Port:
hdlOut = add_block('Simulink/Sinks/Out1', [System '/' strBO]);
OutPortSize = GetBlockSize(hdlOut);

OutPortPos(1) = BCOutputPortPos(1) + OPPad;
OutPortPos(2) = BCOutputPortPos(2) - OutPortSize(2)/2;
OutPortPos(3) = OutPortPos(1) + OutPortSize(1);
OutPortPos(4) = OutPortPos(2) + OutPortSize(2);

set_param(hdlOut, 'Position', OutPortPos);
set_param(hdlOut, 'BusObject', strBO)
set_param(hdlOut, 'UseBusObject', 'on');

hdlOutPorts = get_param(hdlOut, 'PortHandles');
hdlLine = add_line(System, hdlBCPorts.Outport(1), hdlOutPorts.Inport(1));
set_param(hdlLine, 'Name', strBO);

strTranslator = ['lst_BlockName_Filename = {...' endl];

%%
iCtr = 0;
for iElement = 1:numSignals
    curElement = lstBO(iElement,:);
    
    curName = curElement{1};
    curDim  = curElement{2};
    curDataType = curElement{3};
    numLoops = 1;
    
    curFilename = curElement{1};
    ptrPeriod = strfind(curFilename, '.');
    if(~isempty(ptrPeriod))
        curFilename = curFilename(ptrPeriod(end)+1:end);
    end
    
    if(FlattenVectors && (curDim > 1))
        numLoops = curDim;
    end
    
    BCSignalPos = get_param(hdlBCPorts.Inport(iElement), 'Position');
    
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
            
            curFilename = MangleName(curFilename, false, lstMangleFindReplace);
        else
            curFilename = curElement{1};
            curBlockName = curElement{1};
        end
        
        iCtr = iCtr + 1;
        strTranslator = [strTranslator tab '''' [strBO '.' curBlockName] ''', ''' curFilename ''';' endl];
        
        %% Add From File
         hdlFF = add_block(['Simulink/' BlockToUseFull], [System '/' BlockToUse num2str(iElement)]);
        hdlFFPorts = get_param(hdlFF, 'PortHandles');
        
        FFSize = GetBlockSize(hdlFF);
        BCInSignalPos = get_param(hdlBCPorts.Inport(iElement), 'Position');
        
        FFPos(1) =  LeftMargin;            % left edge
        if(FlattenVectors)
            FFPos(2) = TopMargin + (iCtr)*VerticalSpacing - BlockSize(2)/2;
        else
            FFPos(2) =  BCInSignalPos(2) - BlockSize(2)/2;    % top edge
        end
        FFPos(3) =  FFPos(1) + BlockSize(1);            % right edge
        FFPos(4) =  FFPos(2) + BlockSize(2);            % bottom edge
        set_param(hdlFF, 'Position', FFPos);
        
          % Set mask parameters on the 'From File' block:
        set_param(hdlFF, 'Name', [strBO '.' curBlockName]);
        set_param(hdlFF, 'ShowName', 'on');
        set_param(hdlFF, 'FileName', curFilename);
        
        set_param(hdlFF, 'ExtrapolationBeforeFirstDataPoint', 'Hold first value');
%         set_param(hdlFF, 'OutDataTypeStr', curDataType);
        if(strcmp(curDataType, 'boolean'))
            set_param(hdlFF, 'InterpolationWithinTimeRange', 'Zero order hold');
        else
            set_param(hdlFF, 'InterpolationWithinTimeRange', 'Linear interpolation');
        end
        set_param(hdlFF, 'ExtrapolationAfterLastDataPoint', 'Hold last value');
        
        flgDTCneeded = ~strcmp(curDataType, 'double');

        
        if(FlattenVectors && (curDim > 1))
            if(iDim == 1)
                %% Add Mux
                hdlMux = add_block('Simulink/Signal Routing/Mux', [System '/Mux_' curName]);
                set_param(hdlMux, 'Inputs', num2str(curDim));
                
                MuxSize = GetBlockSize(hdlMux);
                MuxPos(1) =  FFPos(3) + MuxPad;            % left edge
                MuxPos(2) =  FFPos(2) - BlockSize(2)/2;    % top edge
                MuxPos(3) =  MuxPos(1) + MuxSize(1);            % right edge
                MuxPos(4) =  MuxPos(2) + (numLoops*VerticalSpacing);            % bottom edge
                set_param(hdlMux, 'Position', MuxPos);
                hdlMuxPorts = get_param(hdlMux, 'PortHandles');
                MuxPortPos = get_param(hdlMuxPorts.Outport(1), 'Position');
                
                % Add Reshape
                hdlReshape = add_block('Simulink/Math Operations/Reshape', [System '/Reshape_' curName]);
                ReshapeSize = GetBlockSize(hdlReshape);
                ReshapePos(1) =  MuxPortPos(1) + ReshapePad;            % left edge
                ReshapePos(2) =  MuxPortPos(2) - ReshapeSize(2)/2;    % top edge
                ReshapePos(3) =  ReshapePos(1) + ReshapeSize(1);            % right edge
                ReshapePos(4) =  ReshapePos(2) + ReshapeSize(2);            % bottom edge
                set_param(hdlReshape, 'Position', ReshapePos);
                set_param(hdlReshape, 'ShowName', 'off');
                hdlReshapePorts = get_param(hdlReshape, 'PortHandles');
                
                if(~flgDTCneeded)
                    add_line(System, hdlMuxPorts.Outport(1), hdlReshapePorts.Inport(1));
                   
                else
                    % Add Data Type Conversion
                    hdlDTC = add_block('Simulink/Signal Attributes/Data Type Conversion', [System '/DTC_' curName]);
                    DTCSize = GetBlockSize(hdlDTC);
                    DTCPos(1) =  ReshapePos(3) + DTCPad;        % left edge
                    DTCPos(2) =  ReshapePos(2);                 % top edge
                    DTCPos(3) =  ReshapePos(1) + DTCSize(1);    % right edge
                    DTCPos(4) =  ReshapePos(4);                 % bottom edge
                    set_param(hdlDTC, 'Position', DTCPos);
                    set_param(hdlDTC, 'ShowName', 'off');
                    set_param(hdlDTC, 'OutDataTypeStr', curDataType);
                    hdlDTCPorts = get_param(hdlDTC, 'PortHandles');
                    
                    add_line(System, hdlMuxPorts.Outport(1), hdlDTCPorts.Inport(1));
                    hdlLine = add_line(System, hdlDTCPorts.Outport(1), hdlReshapePorts.Inport(1));
                    
                end
                hdlLine = add_line(System, hdlReshapePorts.Outport(1), hdlBCPorts.Inport(iElement), 'autorouting','on');
                set(hdlLine, 'Name', curElement{1});
            end

            % Connect the From File Block to the Mux:
            hdlLine = add_line(System, hdlFFPorts.Outport(1), hdlMuxPorts.Inport(iDim), 'autorouting','on');
        else
            
            if(~flgDTCneeded)
                    hdlLine = add_line(System, hdlFFPorts.Outport(1), hdlBCPorts.Inport(iElement), 'autorouting','on');
                   
                else
                    % Add Data Type Conversion
                    hdlDTC = add_block('Simulink/Signal Attributes/Data Type Conversion', [System '/DTC_' curName]);
                    DTCSize = GetBlockSize(hdlDTC);
                    DTCPos(1) =  FFPos(3) + DTCPad;        % left edge
                    DTCPos(2) =  FFPos(2);                 % top edge
                    DTCPos(3) =  DTCPos(1) + DTCSize(1);    % right edge
                    DTCPos(4) =  FFPos(4);                 % bottom edge
                    set_param(hdlDTC, 'Position', DTCPos);
                    set_param(hdlDTC, 'ShowName', 'off');
                    set_param(hdlDTC, 'OutDataTypeStr', curDataType);
                    hdlDTCPorts = get_param(hdlDTC, 'PortHandles');
                    
                    add_line(System, hdlFFPorts.Outport(1), hdlDTCPorts.Inport(1));
                    hdlLine = add_line(System, hdlDTCPorts.Outport(1), hdlBCPorts.Inport(iElement), 'autorouting','on');
                    
                end
            % Connect the From File Block to the BusCreator:
            
            set(hdlLine, 'Name', curFilename);
        end
    end
end
strTranslator = [strTranslator '};'];

set_param(System, 'ZoomFactor', 'FitSystem');
CleanBlockPorts(System);

%% Add Hyperlink

% Place hyperlink below output port
hypPos(1) = OutPortPos(1);       % x-location
hypPos(2) = OutPortPos(4) + 30;  % y-location (Below the bus creator)

TextToAdd = sprintf('%s(''%s'', ''SaveDir'', ''%s'', ''BORoot'', ''%s'', ''FlattenVectors'', %d)', ...
    mfnam, strBO, strrep(strSaveDir, '''', ''''''), strrep(strBORoot, '''', ''''''), FlattenVectors);
Hyperlink = [strBO '_DR2BO/' TextToAdd];
hyp = add_block('built-in/Note', Hyperlink, 'HorizontalAlignment', 'left');
set_param(hyp, 'Position', hypPos);
set_param(hyp, 'UseDisplayTextAsClickCallback', 'on')
% set_param(hyp, 'ClickFcn', TextToAdd);
set_param(hyp, 'DropShadow', 'on');
set_param(hyp, 'FontSize', '12', 'FontWeight', 'bold');

% Save It
save_system(System);

%% Copy the System to a new model and subsystem:
add_block('built-in/Subsystem', [System '_sub/' strBO '_DR2BO']);
Simulink.BlockDiagram.copyContentsToSubSystem(System, [System '_sub/' strBO '_DR2BO']);
SubsysSize = [230 40];
SubsysXY  = [20 20];

SubsysPos(1) = SubsysXY(1);
SubsysPos(2) = SubsysXY(2);
SubsysPos(3) = SubsysPos(1) + SubsysSize(1);
SubsysPos(4) = SubsysPos(2) + SubsysSize(2);

newSys = [System '_sub'];
set_param([newSys '/' strBO '_DR2BO'], 'Position', SubsysPos);

% Place hyperlink below output port
hypPos(1) = SubsysPos(1);       % x-location
hypPos(2) = SubsysPos(4) + 30;  % y-location (Below the bus selector)
Hyperlink = [newSys '/' TextToAdd];
hyp = add_block('built-in/Note', Hyperlink, 'HorizontalAlignment', 'left');
set_param(hyp, 'Position', hypPos);
set_param(hyp, 'UseDisplayTextAsClickCallback', 'on')
% set_param(hyp, 'ClickFcn', TextToAdd);
set_param(hyp, 'DropShadow', 'on');
set_param(hyp, 'FontSize', '12', 'FontWeight', 'bold');

%%
hdl_blk = [System '_sub/' strBO '_DR2BO'];
set_param(hdl_blk, 'Mask', 'on');

% lstMaskVariables = 'msk_dir=@1;msk_bo=@2;msk_root=@3;';
lstMaskVariables = 'msk_dir=@1;msk_root=@2;';
set_param(hdl_blk, 'MaskVariables', lstMaskVariables);

lstMaskPrompts = {...
    'Save Directory (e.g. pwd)';
%     'Bus Object Info (BOInfo.<Bus Object>)';
    'Root Name (if different from bus object name)'};
set_param(hdl_blk, 'MaskPrompts', lstMaskPrompts);

if(isempty(strBORoot))
    strBORoot = '''''';
end

lstMaskValues = {...
  strSaveDir;
%   [strBOInfoStruct strBO];
  [strBORoot]};
set_param(hdl_blk, 'MaskValues', lstMaskValues);
% set_param(hdl_blk, 'MaskEnablestring', 'on,on,on');
set_param(hdl_blk, 'MaskEnablestring', 'on,on');

% strInitFcn = getStrInitFcn();
strInitFcn = [strTranslator endl 'DR2BO_InitFcn_Callback(gcb, lst_BlockName_Filename);' endl];

% set_param(hdl_blk, 'InitFcn', 'UpdateDR(gcb, ''init'')');
set_param(hdl_blk, 'InitFcn', strInitFcn);

% strStopFcn = getStrStopFcn();
% set_param(hdl_blk, 'StopFcn', 'UpdateDR(gcb, ''stop'')');
% set_param(hdl_blk, 'StopFcn', strStopFcn);
set_param(hdl_blk, 'MaskIconUnits', 'normalized');
set_param(hdl_blk, 'MaskIconOpaque', 'off');
% 
% strMaskInit = [...
%     'lstMaskValues = get_param(gcb, ''MaskValues'');' endl ...
%     'str_dir = lstMaskValues{1,:};' endl ...
%     'str_bo  = lstMaskValues{2,:};' endl ...
%     'str_root= lstMaskValues{2,:};'];

strMaskInit = [...
    'lstMaskValues = get_param(gcb, ''MaskValues'');' endl ...
    'str_dir = lstMaskValues{1,:};' endl ...
    'str_root= lstMaskValues{2,:};'];

set_param(hdl_blk, 'MaskInitialization', strMaskInit);

strMaskDisplay = [...
    'text(0.05, 0.8, [''Save Dir: '' str_dir]);' endl ...
    'text(0.05, 0.3, [''BO Root: '' str_root]);'];
set_param(hdl_blk, 'MaskDisplay', strMaskDisplay);

%%

close_system(System);
save_system([System '_sub'], System);
evalin('base', ['!del ' System '_sub.mdl']);
close_system('Simulink', 0)

end % << End of function CreateDR2BO >>

%%

%% REVISION HISTORY
% YYMMDD INI: note
% 130820 MWS: Created function based on CreateBO2DR
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
