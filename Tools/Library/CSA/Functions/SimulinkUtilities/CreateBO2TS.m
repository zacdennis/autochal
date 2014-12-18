% CREATEBO2TS Creates a block that bus selects a bus object into individual 'To File' blocks
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateBO2TS:
% Creates a block that bus selects all members of a bus object and passes
% each individual signal to its own 'To File' block for data recording
% purposes.  Signals are saved with filenames corresponding to the bus
% member name and with 'ts' as the workspace variable name.
% 
% SYNTAX:
%	CreateBO2TS(BusObject, varargin, 'PropertyName', PropertyValue)
%	CreateBO2TS(BusObject, varargin)
%	CreateBO2TS(BusObject)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	BusObject	[varies]    N/A         Reference Simulink bus object.  Can
%                                       be of name of the bus object (e.g.
%                                       a string) or the bus object itself
%   System      'string'    [char]      Name of Simulink model to create
%                                       containing the BO2TS block
%                                        Default: [<BusObject> '_BO2TS']
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
% OUTPUTS: 
%	Name    	Size		Units		Description
%	<BusObject>_BO2TS.mdl               Simulink unit test model containing
%                                       the bus object to 'To File' blocks
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default             Description
%   'System'            'string'        [<BusObject>_BO2TS] Desired name for
%                                                           Simulink BO2TS
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
%   'IncludeStopFcn'    'boolean'       true                Include
%   callback code 
%
% EXAMPLES:
%   % Example #1: Build a Bus Object and the BO2TS block
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
%	CreateBO2TS(strBO)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CreateBO2TS.m">CreateBO2TS.m</a>
%	  Driver script: <a href="matlab:edit Driver_CreateBO2TS.m">Driver_CreateBO2TS.m</a>
%	  Documentation: <a href="matlab:winopen(which('CreateBO2TS_Function_Documentation.pptx'));">CreateBO2TS_Function_Documentation.pptx</a>
%
% See also CreateVec2BO, CreateTestHarness, BusObject2List, cell2str
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/773
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CreateBO2TS.m $
% $Rev: 2585 $
% $Date: 2012-10-30 20:45:34 -0500 (Tue, 30 Oct 2012) $
% $Author: sufanmi $

function CreateBO2TS(BusObject, varargin)

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
[IncludeStopFcn, varargin]  = format_varargin('IncludeStopFcn', 1, 2, varargin);

% Pick out Properties Entered via varargin
BlockToUseFull = 'CSA_Library/Tools/SaveToTS';

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
    System = [strBO '_BO2TS'];
end

%% Main Function:
load_system('Simulink');

load_system(bdroot(BlockToUseFull));

lstBO = BusObject2List(strBO);
lstBOInfo = evalin('base', [strBOInfoStruct strBO]);
lstBO(:,5) = lstBOInfo(:,4);

str_Signals_to_Select = cell2str(lstBO(:,1));

[numSignals, numCols] = size(lstBO);

%% Spacing Control:
BlockSize       = [500 40];   % [width height]
LeftMargin      = 20+100;
TopMargin       = 15;
VerticalSpacing = BlockSize(2)+20;           % Make sure this > BlockSize(2)

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
InputPortPos(2) =  TopMargin + (VerticalSpacing * numSignals)/2;                % top edge
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
BSPos(1) =  InputPortSigPos(1) + 100;           % left edge
BSPos(2) =  InputPortSigPos(2) -(VerticalSpacing * numSignals)/2;                  % top edge
BSPos(3) =  BSPos(1) + BSSize(1);       % right edge
BSPos(4) =  BSPos(2) +(VerticalSpacing * numSignals);                  % bottom edge
set_param(hdlBS, 'Position', BSPos);
set_param(hdlBS, 'OutputSignals', str_Signals_to_Select);

% Connect the input port to the bus selector
add_line(System, [strBO '/1'], ['BusSelector/1'] );

hdlBSPorts = get_param(hdlBS, 'PortHandles');

%%
for iElement = 1:numSignals
    curElement = lstBO(iElement,:);
    curSignal  = curElement{1};
    curUnits   = curElement{5};
    
    %% Add the Intermediate Block (Data Recorder):
    ptrSlash = strfind(BlockToUseFull, '/');
    if(~isempty(ptrSlash))
        BlockToUse = BlockToUseFull(ptrSlash(end)+1:end);
    else
        BlockToUse = BlockToUseFull;
    end
    
    hdlIB = add_block(BlockToUseFull, [System '/' BlockToUse num2str(iElement)]);
    hdlIBPorts = get_param(hdlIB, 'PortHandles');

    IBSize = GetBlockSize(hdlIB);
    BSOutSignalPos = get_param(hdlBSPorts.Outport(iElement), 'Position');
    
    IBPos(1) =  BSOutSignalPos(1) + 220;            % left edge
    IBPos(2) =  BSOutSignalPos(2) - BlockSize(2)/2;    % top edge
    IBPos(3) =  IBPos(1) + BlockSize(1);            % right edge
    IBPos(4) =  IBPos(2) + BlockSize(2);            % bottom edge
    set_param(hdlIB, 'Position', IBPos);
    
    % Connect Bus Selector to Intermediate Block:
    add_line(System, hdlBSPorts.Outport(iElement), hdlIBPorts.Inport(1));
    
    % Set mask parameters on the 'To File' block:
    
    curFilename = [strBORoot '.' curSignal];
    
    set_param(hdlIB, 'Name', curFilename);
%     set_param(hdlIB, 'ShowName', 'on');
    %     set_param(hdlIB, 'MatrixName', 'ts');
    %     set_param(hdlIB, 'Filename', [curFilename '.mat']);
    %     set_param(hdlIB, 'SaveFormat', 'Timeseries');
    %     set_param(hdlIB, 'SampleTime', '-1');
    
    if(isempty(curUnits))
        curUnits = '[<TBD>]';
    end
%     
    lstMaskValues = get_param(hdlIB, 'MaskValues');
%     lstMaskValues(1,:) = {'mskSaveToBin.SaveDir'};
%     
    lstMaskValues ={...
        [strSaveDir];
        ['''' curFilename ''''];
        ['''' curUnits ''''];
        'SimSetup.baserate';
        [num2str(IncludeStopFcn)]};
    
    set_param(hdlIB, 'MaskValues', lstMaskValues);

end

set_param(System, 'ZoomFactor', 'FitSystem');
CleanBlockPorts(System);

%% Add Hyperlink

% Place hyperlink below output port
hypPos(1) = InputPortPos(1);       % x-location
hypPos(2) = BSPos(4) + 30;  % y-location (Below the bus selector)

TextToAdd = sprintf('%s(''%s'', ''SaveDir'', ''%s'', ''BORoot'', ''%s'', ''IncludeStopFcn'', %s)', ...
    mfnam, strBO, strrep(strSaveDir, '''', ''''''), strBORoot, num2str(IncludeStopFcn));
Hyperlink = [strBO '_BO2TS/' TextToAdd];
hyp = add_block('built-in/Note', Hyperlink, 'HorizontalAlignment', 'left');
set_param(hyp, 'Position', hypPos);
set_param(hyp, 'UseDisplayTextAsClickCallback', 'on')
% set_param(hyp, 'ClickFcn', TextToAdd);
set_param(hyp, 'DropShadow', 'on');
set_param(hyp, 'FontSize', '12', 'FontWeight', 'bold');

% Save It
save_system(System);

%% Copy the System to a new model and subsystem:
add_block('built-in/Subsystem', [System '_sub/' strBO '_BO2TS']);
Simulink.BlockDiagram.copyContentsToSubSystem(System, [System '_sub/' strBO '_BO2TS']);
SubsysSize = [230 40];
SubsysXY  = [20 20];

SubsysPos(1) = SubsysXY(1);
SubsysPos(2) = SubsysXY(2);
SubsysPos(3) = SubsysPos(1) + SubsysSize(1);
SubsysPos(4) = SubsysPos(2) + SubsysSize(2);

newSys = [System '_sub'];
set_param([newSys '/' strBO '_BO2TS'], 'Position', SubsysPos);

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
close_system(System);
save_system([System '_sub'], System);
evalin('base', ['!del ' System '_sub.mdl']);
close_system('Simulink', 0)

end % << End of function CreateBO2TS >>


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
