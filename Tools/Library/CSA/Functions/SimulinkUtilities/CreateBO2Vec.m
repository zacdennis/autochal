% CREATEBO2VEC Creates a block that translates a bus object into a vector
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateBO2Vec:
% Creates a block that translates a bus object into a vector and applies a
% user-defined block in the process.  The block created has one master bus
% selection which gets passed directly into a mux.  In the process the user
% can insert their own intermediate block (like a gain or data type
% conversion block).  The default intermediate block is a data type
% conversion block to 'double'.
%
% This function is intended to create a block that can be used to convert a
% bus of mixed data types (double, single, boolean, etc) into a vector of
% type 'double'.  This way, the vector can be passed into a data recorder
% or UDP send block.
% 
% SYNTAX:
%	CreateBO2Vec(BusObject, System, varargin, 'PropertyName', PropertyValue)
%	CreateBO2Vec(BusObject, varargin, 'PropertyName', PropertyValue)
%	CreateBO2Vec(BusObject, varargin)
%	CreateBO2Vec(BusObject)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	BusObject	[varies]    N/A         Reference Simulink bus object.  Can
%                                       be of name of the bus object (e.g.
%                                       a string) or the bus object itself
%   System      'string'    [char]      Name of Simulink model to create
%                                       containing the BO2Vec block
%                                        Default: [<BusObject> '_BO2Vec']
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
% OUTPUTS: 
%	Name    	Size		Units		Description
%	<BusObject>_BO2Vec.mdl              Simulink unit test model containing
%                                       the bus object to vector block
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'BlockToUse'        'string'        See DF1 	Full path of
%                                                   intermediate block to 
%                                                   use
%   'ValueToUse'        {N x 2 cell}    See DF2     Combination of block
%                                                   mask parameters (:,1)
%                                                   to set on the
%                                                   intermediate block.
%                                                   The value to set block
%                                                   to is (:,2)
%   DF1: 'Signal Attributes/Data Type Conversion'
%   DF2: {'OutDataTypeStr', 'double'}
%
% EXAMPLES:
%   % Example #1: Build a Block that creates a vector for a nested Bus
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
%   % Now Create the Bus Object to Vector Block
%	CreateBO2Vec('BOBus3')
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CreateBO2Vec.m">CreateBO2Vec.m</a>
%	  Driver script: <a href="matlab:edit Driver_CreateBO2Vec.m">Driver_CreateBO2Vec.m</a>
%	  Documentation: <a href="matlab:pptOpen('CreateBO2Vec_Function_Documentation.pptx');">CreateBO2Vec_Function_Documentation.pptx</a>
%
% See also CreateVec2BO, CreateTestHarness, BusObject2List, cell2str
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/721
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CreateBO2Vec.m $
% $Rev: 2617 $
% $Date: 2012-11-06 17:21:05 -0600 (Tue, 06 Nov 2012) $
% $Author: sufanmi $

function [Out1] = CreateBO2Vec(BusObject, System, varargin)

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
% Pick out Properties Entered via varargin
[BlockToUseFull, varargin]  = format_varargin('BlockToUse','Signal Attributes/Data Type Conversion', 2, varargin);
[lstParamsToSet, varargin]  = format_varargin('ValueToUse',{'OutDataTypeStr', 'double'}, 2, varargin);

if(ischar(BusObject))
    strBO = BusObject;
else
    strBO = inputname(1);
end

if (nargin < 2)
    System = [strBO '_BO2Vec'];
end

%% Main Function:
load_system('Simulink');

lstBO = BusObject2List(strBO);
str_Signals_to_Select = cell2str(lstBO(:,1));

numSignals = size(lstBO, 1);

%% Spacing Control:
BlockSize       = [100 16];   % [width height]
LeftMargin      = 20+100;
TopMargin       = 15;
VerticalSpacing = 25;           % Make sure this > BlockSize(2)

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

%% Add a Mux:
hdlMux = add_block('Simulink/Signal Routing/Mux', [System '/Mux']);
MuxSize = GetBlockSize(hdlMux);
set_param(hdlMux, 'Inputs', num2str(numSignals));

MuxPos(1) = (LeftMargin + BlockSize(2) + BlockSize(1) + 500);   % left edge
MuxPos(2) = TopMargin;                                          % top edge
MuxPos(3) = MuxPos(1) + MuxSize(1);                             % right edge
MuxPos(4) = MuxPos(2) + (VerticalSpacing * numSignals);         % bottom edge
set_param(hdlMux, 'Position', MuxPos);

hdlMuxPorts = get_param(hdlMux, 'PortHandles');
MuxOutPos = get_param(hdlMuxPorts.Outport(1), 'Position');

%% Add an Output Port:
hdlOut = add_block('Simulink/Sinks/Out1', [System '/vec']);
OutPortSize = GetBlockSize(hdlOut);

OutputPortPos(1) =  MuxOutPos(1) + 100;                 % left edge
OutputPortPos(2) =  MuxOutPos(2) - (OutPortSize(2)/2);  % top edge
OutputPortPos(3) =  OutputPortPos(1) + OutPortSize(1);  % right edge
OutputPortPos(4) =  OutputPortPos(2) + OutPortSize(2);  % bottom edge
set_param(hdlOut, 'Position', OutputPortPos);

add_line(System, ['Mux/1'], ['vec/1'] );

%% Add an Input Port:
hdlIn = add_block('Simulink/Sources/In1', [System '/' strBO]);
InPortSize = GetBlockSize(hdlIn);

InputPortPos(1) =  LeftMargin - 20;                      % left edge
InputPortPos(2) =  OutputPortPos(2);                % top edge
InputPortPos(3) =  InputPortPos(1) + InPortSize(1); % right edge
InputPortPos(4) =  InputPortPos(2) + InPortSize(2); % bottom edge
set_param(hdlIn, 'Position', InputPortPos);
set_param(hdlIn, 'BusObject', strBO)
set_param(hdlIn, 'UseBusObject', 'on');

%% Add the Bus Selector:
hdlBS = add_block('Simulink/Signal Routing/Bus Selector', [System '/BusSelector']);
BSSize = GetBlockSize(hdlBS);
BSPos(1) =  LeftMargin + 100;           % left edge
BSPos(2) =  MuxPos(2);                  % top edge
BSPos(3) =  BSPos(1) + BSSize(1);       % right edge
BSPos(4) =  MuxPos(4);                  % bottom edge
set_param(hdlBS, 'Position', BSPos);
set_param(hdlBS, 'OutputSignals', str_Signals_to_Select);

add_line(System, [strBO '/1'], ['BusSelector/1'] );

hdlBSPorts = get_param(hdlBS, 'PortHandles');

%%
for iElement = 1:numSignals
    curElement = lstBO(iElement,:);
    curDim = curElement{2};
    
    %% Add an Intermediate Block (IB)
    ptrSlash = findstr(BlockToUseFull, '/');
    if(~isempty(ptrSlash))
        BlockToUse = BlockToUseFull(ptrSlash(end)+1:end);
    else
        BlockToUse = BlockToUseFull;
    end
    
    hdlIB = add_block(['Simulink/' BlockToUseFull], [System '/' BlockToUse num2str(iElement)]);
    hdlIBPorts = get_param(hdlIB, 'PortHandles');
    set_param(hdlIB, 'ShowName', 'off');
    
    for iParam2Set = 1:size(lstParamsToSet, 1);
        curParamStr     = lstParamsToSet{iParam2Set, 1};
        curParamValue   = lstParamsToSet{iParam2Set, 2};
        set_param(hdlIB, curParamStr, curParamValue);
    end

    IBSize = GetBlockSize(hdlIB);
    
    BSOutSignalPos = get_param(hdlBSPorts.Outport(iElement), 'Position');
    
    IBPos(1) =  BSOutSignalPos(1) + 220;            % left edge
    IBPos(2) =  BSOutSignalPos(2) - BlockSize(2)/2;    % top edge
    IBPos(3) =  IBPos(1) + BlockSize(1);            % right edge
    IBPos(4) =  IBPos(2) + BlockSize(2);            % bottom edge
    set_param(hdlIB, 'Position', IBPos);
    
    % Connect Bus Selector to Intermediate Block:
    add_line(System, hdlBSPorts.Outport(iElement), hdlIBPorts.Inport(1));
    
    
    if(numel(curDim) > 1)

        IBOutSignalPos = get_param(hdlIBPorts.Outport(1), 'Position');
        
        % Add a Reshape
        hdlRS = add_block(['Simulink/Math Operations/Reshape'], [System '/Reshape' num2str(iElement)]);
        hdlRSPorts = get_param(hdlRS, 'PortHandles');
        RSSize = GetBlockSize(hdlRS);

        set_param(hdlRS, 'ShowName', 'off');
        
        RSPos(1) =  IBOutSignalPos(1) + 50;             % left edge
        RSPos(2) =  IBOutSignalPos(2) - RSSize(2)/2;     % top edge
        RSPos(3) =  RSPos(1) + BlockSize(1);    % right edge
        RSPos(4) =  RSPos(2) + BlockSize(2);    % bottom edge
        set_param(hdlRS, 'Position', RSPos);
        
        % Connect Intermediate Block to Reshape
        add_line(System, hdlIBPorts.Outport(1), hdlRSPorts.Inport(1));
        
        % Connect Reshape Block to Mux:
        add_line(System, hdlRSPorts.Outport(1), hdlMuxPorts.Inport(iElement));
        
    else
        
        % Connect Intermediate Block to Mux:
        add_line(System, hdlIBPorts.Outport(1), hdlMuxPorts.Inport(iElement));
    end
end

set_param(System, 'ZoomFactor', 'FitSystem');
CleanBlockPorts(System);

%% Add Hyperlink

% Place hyperlink below output port
hypPos(1) = OutputPortPos(1);       % x-location
hypPos(2) = OutputPortPos(4) + 30;  % y-location
TextToAdd = sprintf('%s(''%s'')', mfnam, strBO);
Hyperlink = [strBO '_BO2Vec/' TextToAdd];
hyp = add_block('built-in/Note', Hyperlink, 'HorizontalAlignment', 'left');
% set_param(hyp, 
set_param(hyp, 'Position', hypPos);
set_param(hyp, 'ClickFcn', TextToAdd);
set_param(hyp, 'DropShadow', 'on');
set_param(hyp, 'FontSize', '12', 'FontWeight', 'bold');

% Save It
save_system(System);

%% Copy the System to a new model and subsystem:
add_block('built-in/Subsystem', [System '_sub/' strBO '_BO2Vec']);
Simulink.BlockDiagram.copyContentsToSubSystem(System, [System '_sub/' strBO '_BO2Vec']);
FinalBlkXYLoc = [20 20];
FinalBlkSize  = [200 30];
FinalBlkPos   = FinalBlkXYLoc;
FinalBlkPos(3)= FinalBlkPos(1) + FinalBlkSize(1);
FinalBlkPos(4)= FinalBlkPos(2) + FinalBlkSize(2);
set_param([System '_sub/' strBO '_BO2Vec'], 'Position', FinalBlkPos);

close_system(System);
save_system([System '_sub'], System);
evalin('base', ['!del ' System '_sub.mdl']);
close_system('Simulink', 0)


%% Compile Outputs:
%	Out1= -1;

end % << End of function CreateBO2Vec >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 110812 <INI>: Created function using CreateNewFunc
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
