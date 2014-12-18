% CREATETESTHARNESS Create a Test Harness from Bus Object
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateTestHarness:
% Create a Test Harness from Bus Object
% This function is intended to create a test_harness from a Simulink
% bus_object to make it easier to UNIT_TEST subsystems which have bus
% objects on the interface planes.
% 
% SYNTAX:
%	CreateTestHarness(BusObject, varargin, 'PropertyName', PropertyValue)
%	CreateTestHarness(BusObject, varargin)
%   CreateTestHarness(BusObject)
%
% INPUTS: 
%	Name             	Size		Units		Description
%   BusObject           {Bus Object}            Reference Simulink Bus Object
%
%	varargin            [N/A]		[varies]	Optional function inputs that
%                                               should be entered in pairs.
%                                               See the 'VARARGIN' section
%                                               below for more details
%
% OUTPUTS: 
%	Name             	Size		Units		Description
%   <BusObject>_harness.mdl                     Simulink unit test model
%                                               for <BusObject>
%
% NOTES:
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default     Description
%   'System'            'string'        [BusObject  Simulink Diagram into 
%                                        '_harness'] which to create test
%                                                    harness.  
%   'InitScript'        'string'        ''          Initialization script
%                                                   that defines bus object
%   'BlockToUse'        'string'        'Constant'  Type of block to use at
%                                                    head of signal
%   'UseIdxForValue'    [bool]          0           If using Constant, use
%                                                   member index for 
%                                                   constant value?
%   'ValueToUse'        [N/A]           0           If using Constant, what
%                                                   value should be used?
%   'Recurse'           [bool]          0           Flag used for recursion
%                                                Default: 0 (false)
% EXAMPLES:
%   % Example #1: Build a Test Harness for a nested Bus
%   % Create Bus1:
%       lstBO = {
%           'Alpha';
%           'Beta';
%           };
%   BuildBusObject('BOBus1', lstBO); clear lstBO;
% 
%   % Create Bus2:
%   lstBO = {
%       'WOW'       1   'boolean';
%       'Pned'      3   'single';
%       };
%   BuildBusObject('BOBus2', lstBO); clear lstBO;
% 
%   % Create Bus3 which is a combo of Bus1 and Bus2
%   lstBO = {
%       'Bus1'      1,  'BOBus1';
%       'Bus2'      1,  'BOBus2';
%       };
%   BuildBusObject('BOBus3', lstBO); clear lstBO;
%
%   % Now Create the Test Harness
%	CreateTestHarness('BOBus3')
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CreateTestHarness.m">CreateTestHarness.m</a>
%	  Driver script: <a href="matlab:edit Driver_CreateTestHarness.m">Driver_CreateTestHarness.m</a>
%	  Documentation: <a href="matlab:pptOpen('CreateTestHarness_Function_Documentation.pptx');">CreateTestHarness_Function_Documentation.pptx</a>
%
% See also BuildBusObject, CreateVec2BO 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/536
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21)
%                Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CreateTestHarness.m $
% $Rev: 2971 $
% $Date: 2013-07-15 18:55:57 -0500 (Mon, 15 Jul 2013) $
% $Author: sufanmi $

function [] = CreateTestHarness(BusObject, varargin)

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

%%
if(isstr(BusObject))
    strBO = BusObject;
    BusObject = evalin('base', BusObject);
else
    strBO = inputname(1);
end

RefCmd = ['CreateTestHarness(''' strBO ''''];
for i = 1:length(varargin)
    cur_varargin = varargin{i};
    RefCmd = [RefCmd ', ''' cur_varargin ''''];
end
RefCmd = [RefCmd ')'];

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[InitScript, varargin]          = format_varargin('InitScript','', 2, varargin);
[BlockToUse, varargin]          = format_varargin('BlockToUse','Constant', 2, varargin);
[flgUseIdxForValue, varargin]   = format_varargin('UseIdxForValue',0, 2, varargin);
[defaultValue, varargin]        = format_varargin('ValueToUse',0, 2, varargin);
[System, varargin]              = format_varargin('System','', 2, varargin);
[flgRecurse, varargin]          = format_varargin('Recurse',0, 2, varargin);
[SampleTime, varargin]          = format_varargin('SampleTime','inf', 2, varargin);

%% Main Function:
% clc;
load_system('Simulink');


if(~isstr(SampleTime))
    SampleTime = num2str(SampleTime);
end

if(isempty(System))
    System = [strBO '_harness'];
end

%% Spacing Control:
BlockSize       = [150 15];   % [width height]
LeftMargin      = 15;
TopMargin       = 15;
VerticalSpacing = 35;

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

%% Add a BusCreator:
add_block('Simulink/Signal Routing/Bus Creator', [System '/Create' strBO]);
set_param([System '/Create' strBO], 'ShowName', 'On');
set_param([System '/Create' strBO], 'Position', [...
    (LeftMargin + BlockSize(2) + BlockSize(1) + 200) ...            left edge
    TopMargin ...                                                   top edge
    (LeftMargin + BlockSize(2) + BlockSize(1) + 210) ...            right edge
    (TopMargin + VerticalSpacing * length(BusObject.Elements))] ); %bottom edge

set_param([System '/Create' strBO], 'Inputs', num2str(length(BusObject.Elements)));
set_param([System '/Create' strBO], 'UseBusObject', 'on');
set_param([System '/Create' strBO], 'BusObject', strBO);

%% Add an Output Port:
out1 = add_block('Simulink/Sinks/Out1', [System '/' strBO]);
out1_pos = get_param(out1, 'Position');
out1_w = out1_pos(3) - out1_pos(1);
out1_h = out1_pos(4) - out1_pos(2);
out1_pos(1) = LeftMargin + BlockSize(2) + BlockSize(1) + 400;
out1_pos(2) = floor((TopMargin + VerticalSpacing * length(BusObject.Elements))/2 + out1_h/2);
out1_pos(3) = out1_pos(1) + out1_w;
out1_pos(4) = out1_pos(2) + out1_h;

set_param([System '/' strBO], 'Position', out1_pos);
set_param([System '/' strBO], 'BusObject', strBO)
set_param([System '/' strBO], 'UseBusObject', 'on');

add_line(System, ['Create' strBO '/1'], [strBO '/1'] );

p = get_param([System '/' strBO], 'PortHandles');
l = get_param(p.Inport, 'Line');
set_param(l, 'Name', strBO);

%% Add the constant blocks:
for iElement = 1 : length(BusObject.Elements)
    Blocks{iElement} = [System '/' BusObject.Elements(iElement).Name];
    
    % Check to see if the DataType is a built-in or if it is a Bus Object:
    % note: boolean.m is a builtin type and file so it needs extra care:
    if(exist(BusObject.Elements(iElement).DataType, 'builtin') || strcmp(BusObject.Elements(iElement).DataType, 'boolean'))
        % The Element is a built in type and contants can be used
        
        % Create the constant block:
        add_block(['built-in/' BlockToUse], Blocks{iElement});

        % Position the block:
        set_param(Blocks{iElement}, 'Position', ...
            [LeftMargin ...                                                       left edge
            (TopMargin + VerticalSpacing * (iElement-1) + 10) ...                 top edge
            LeftMargin+BlockSize(1) ...                                           right edge
            (TopMargin + VerticalSpacing * (iElement-1) + BlockSize(2)) + 10]); % bottom edge
        
       
        % Handle builtin DataType:
        set_param(Blocks{iElement}, 'OutDataTypeStr', BusObject.Elements(iElement).DataType);
        
        % Set the value of the block to zeros of size dimensions in that element
        numDim = BusObject.Elements(iElement).Dimensions;
        if(strcmp(BlockToUse, 'Constant'))
            
            set_param(Blocks{iElement}, 'SampleTime', SampleTime);
            
            if(length(numDim) == 1)
                if(numDim == 1)
                    if(flgUseIdxForValue)
                        set_param(Blocks{iElement}, 'Value', num2str(iElement));
                    else
                        set_param(Blocks{iElement}, 'Value', num2str(defaultValue));
                    end
                else
                    if(flgUseIdxForValue)
                        strValue = ['[' num2str(ones(1,numDim)*iElement + [1:numDim]/10) ']'];
                    else
                        if(defaultValue == 0)
                            strValue =  ['zeros(1, ' num2str(numDim) ')'];
                        elseif(defaultValue == 1)
                            strValue =  ['ones(1, ' num2str(numDim) ')'];
                        else
                            strValue =  ['ones(1, ' num2str(numDim) ')*' num2str(defaultValue)];
                        end
                    end
                    set_param(Blocks{iElement}, 'Value', strValue);
                end
            else
                set_param(Blocks{iElement}, 'Value', ['ones(' num2str(numDim(1)), ...
                    ', ' num2str(numDim(2)) ')*' num2str(defaultValue)]);
            end
            
        end
    else
        % The Element is not built-in and therefore another BO definition
        % so another test harness must be created to generate those signals
        
        % Invoke this function to create a subsystem harness for this BO
        % assuming it exists in the base workspace:
        ec = sprintf('%s(''%s'', ''System'', ''%s'', ''UseIdxForValue'', %d, ''BlockToUse'', ''%s'', ''Recurse'', 1)', ...
            mfnam, BusObject.Elements(iElement).DataType, ...
            [BusObject.Elements(iElement).DataType '_auto'], ...
            flgUseIdxForValue, BlockToUse);
        evalin('base', ec);
        
        % Take the harness and add it to the system:
        add_block([BusObject.Elements(iElement).DataType '_auto/' BusObject.Elements(iElement).DataType '_harness'], Blocks{iElement});
        
        % Close and delete the _auto harness:
        close_system([BusObject.Elements(iElement).DataType '_auto'], 0);
        evalin('base', ['!del ' [BusObject.Elements(iElement).DataType '_auto'] '.mdl']);
        
        % Position the block:
        set_param(Blocks{iElement}, 'Position', ...
            [LeftMargin ...                                                       left edge
            (TopMargin + VerticalSpacing * (iElement-1) + 10) ...                 top edge
            LeftMargin+BlockSize(1) ...                                           right edge
            (TopMargin + VerticalSpacing * (iElement-1) + BlockSize(2)) + 10]); % bottom edge
    end

    % Connect the block to the BusCreator:
    add_line(System, [BusObject.Elements(iElement).Name '/1'], ['Create' strBO '/' num2str(iElement)]);
    
    p = get_param(Blocks{iElement}, 'PortHandles');
    l = get_param(p.Outport, 'Line');
    set_param(l, 'Name', BusObject.Elements(iElement).Name);
end

set_param(System, 'ZoomFactor', 'FitSystem');
CleanBlockPorts(System);

%% Add Hyperlink
if(~flgRecurse)
OutputPort = [strBO '_harness/' strBO];
opPos = get_param(OutputPort, 'Position');
opW = opPos(3) - opPos(1);
hypPos(1) = round(opPos(1) + opW/2);    % x-location
hypPos(2) = opPos(4) + 30;              % y-location

% if(strcmp(BlockToUse, 'Constant'))
%     if(defaultValue ~= 0)
%         TextToAdd = sprintf('%s(''%s'', ''ValueToUse'', %s)', mfnam, strBO, num2str(defaultValue));
%     else
%         TextToAdd = sprintf('%s(''%s'')', mfnam, strBO);
%     end
% else
%     TextToAdd = sprintf('%s(''%s'', ''BlockToUse'', ''%s'')', mfnam, strBO, BlockToUse);
% end

TextToAdd = RefCmd;
Hyperlink = [strBO '_harness/' TextToAdd];
hyp = add_block('built-in/Note', Hyperlink, 'HorizontalAlignment', 'center');
set_param(hyp, 'Position', hypPos);
set_param(hyp, 'ClickFcn', TextToAdd);
set_param(hyp, 'DropShadow', 'on');
set_param(hyp, 'FontSize', '12', 'FontWeight', 'bold');

if(~isempty(InitScript))
    hypPos(2) = hypPos(2) + 30;
    TextToAdd = sprintf('edit(''%s'')', InitScript);
    Hyperlink = [strBO '_Vec2BO/' TextToAdd];
    hyp = add_block('built-in/Note', Hyperlink, 'HorizontalAlignment', 'center');
    set_param(hyp, 'Position', hypPos);
    set_param(hyp, 'ClickFcn', TextToAdd);
    set_param(hyp, 'DropShadow', 'on');
    set_param(hyp, 'FontSize', '12', 'FontWeight', 'bold');
end
end
% Save It
save_system(System);

%% Copy the System to a new model and subsystem:
add_block('built-in/Subsystem', [System '_sub/' strBO '_harness']);
Simulink.BlockDiagram.copyContentsToSubSystem(System, [System '_sub/' strBO '_harness']);
FinalBlkXYLoc = [20 20];
FinalBlkSize  = [200 30];
FinalBlkPos   = FinalBlkXYLoc;
FinalBlkPos(3)= FinalBlkPos(1) + FinalBlkSize(1);
FinalBlkPos(4)= FinalBlkPos(2) + FinalBlkSize(2);
set_param([System '_sub/' strBO '_harness'], 'Position', FinalBlkPos);

close_system(System);
save_system([System '_sub'], System);
evalin('base', ['!del ' System '_sub.mdl']);
close_system('Simulink', 0)

end % << End of function CreateTestHarness >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110518 MWS: Updated CreateTestHarness hyperlink to include the
%               'ValueToUse' if it's not the default value
%             Updated how constant blocks' values were set when the value
%             is nonzero.  For vectors, specifying value to be ones(1, n)
%             based.
% 101105 MWS: Added hyperlink for building block
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720  
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi

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
