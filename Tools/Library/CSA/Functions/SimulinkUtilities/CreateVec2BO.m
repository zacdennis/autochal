% CREATEVEC2BO Creates a block that translates a vector to a bus object.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateVec2BO:
% Creates a block that translates a vector to a bus object.
%   Block is intended to be used to connect UDP or mat file outputs with a
%   sim.
%
% This function is intended to create a test_harness from a Simulink
% bus_object to make it easier to UNIT_TEST subsystems which have bus
% objects on the interface planes.
% 
% SYNTAX:
%	[] = CreateVec2BO(BusObject, System, numTotalSignals, iptr1, varargin, 'PropertyName', PropertyValue)
%	[] = CreateVec2BO(BusObject, System, numTotalSignals, iptr1, varargin)
%	[] = CreateVec2BO(BusObject, System, numTotalSignals, iptr1)
%	[] = CreateVec2BO(BusObject, System)

%
% INPUTS: 
%	Name         Size   Units		Description
%   BusObject    [1xN]  [ND]        Bus Object on the input interface plane
%   System       [1xN]  [ND]        String of Name of the Simulink Diagram to create
%                                    containing the test harness (optional)
%   numTotalSignals [m]             Number of total signals as calculated by
%                                    'BusObject2List'; recursive variable
%   iptr1           [1]             Signal index; recursive variable
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name           	Size		Units		Description
%	    	               <size>		<units>		<Description> 
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
%	[] = CreateVec2BO(BusObject, System, numTotalSignals, iptr1, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[] = CreateVec2BO(BusObject, System, numTotalSignals, iptr1)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
% Book with One Author:
% [2]   Author Last Name, Author First Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
% Book with Two Author:
% [3]   Author #1 Last Name, Author #1 First Name, and Author #2 Full Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CreateVec2BO.m">CreateVec2BO.m</a>
%	  Driver script: <a href="matlab:edit Driver_CreateVec2BO.m">Driver_CreateVec2BO.m</a>
%	  Documentation: <a href="matlab:pptOpen('CreateVec2BO_Function_Documentation.pptx');">CreateVec2BO_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/537
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CreateVec2BO.m $
% $Rev: 2289 $
% $Date: 2012-01-27 11:08:05 -0600 (Fri, 27 Jan 2012) $
% $Author: sufanmi $

function [] = CreateVec2BO(BusObject, System, numTotalSignals, iptr1, varargin)

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
[InitScript, varargin]  = format_varargin('InitScript','', 2, varargin);

%  switch(nargin)
%       case 0
%        iptr1= ''; numTotalSignals= ''; System= ''; BusObject= ''; 
%       case 1
%        iptr1= ''; numTotalSignals= ''; System= ''; 
%       case 2
%        iptr1= ''; numTotalSignals= ''; 
%       case 3
%        iptr1= ''; 
%       case 4
%        
%       case 5
%        
%  end
%
%  if(isempty(iptr1))
%		iptr1 = -1;
%  end
if(isstr(BusObject))
    strBO = BusObject;
    BusObject = evalin('base', BusObject);
else
    strBO = inputname(1);
end

%% Main Function:
clc;
load_system('Simulink');

if (nargin < 2)
    System = [strBO '_Vec2BO'];
end

%% Spacing Control:
BlockSize       = [100 15];   % [width height]
LeftMargin      = 15+100;
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
    (LeftMargin + BlockSize(2) + BlockSize(1) + 300) ...            left edge
    TopMargin ...                                                   top edge
    (LeftMargin + BlockSize(2) + BlockSize(1) + 310) ...            right edge
    (TopMargin + VerticalSpacing * length(BusObject.Elements))] ); %bottom edge

set_param([System '/Create' strBO], 'Inputs', num2str(length(BusObject.Elements)));
set_param([System '/Create' strBO], 'UseBusObject', 'on');
set_param([System '/Create' strBO], 'BusObject', strBO);

%% Add an Output Port:
add_block('Simulink/Sinks/Out1', [System '/' strBO]);

OutputPortPos(1) =  (LeftMargin + BlockSize(2) + BlockSize(1) + 500);               % left edge
OutputPortPos(2) =  (TopMargin + VerticalSpacing * length(BusObject.Elements))/2;   % top edge
OutputPortPos(3) =  (LeftMargin + BlockSize(2) + BlockSize(1) + 530);               % right edge
OutputPortPos(4) =  (TopMargin + VerticalSpacing * length(BusObject.Elements))/2 + 15; % bottom edge
set_param([System '/' strBO], 'Position', OutputPortPos);

set_param([System '/' strBO], 'BusObject', strBO)
set_param([System '/' strBO], 'UseBusObject', 'on');

add_line(System, ['Create' strBO '/1'], [strBO '/1'] );

p = get_param([System '/' strBO], 'PortHandles');
l = get_param(p.Inport, 'Line');
set_param(l, 'Name', strBO);

%% Add an Input Port:
add_block('Simulink/Sources/In1', [System '/vec']);
InputPortPos = get_param([System '/vec'], 'Position');
InputPortPos(2) = OutputPortPos(2);
InputPortPos(4) = OutputPortPos(4);
set_param([System '/vec'], 'Position', InputPortPos);

%% Add the constant blocks:
if(nargin < 3)
    lstBO = BusObject2List(BusObject);
    numTotalSignals = sum(cell2mat(lstBO(:,2)));
end

if(nargin < 4)
    iptr1 = 0;
end

iptr2 = iptr1;

lengthBO = length(BusObject.Elements);
for iElement = 1 : lengthBO
    Blocks{iElement} = [System '/' BusObject.Elements(iElement).Name];
    
    % Check to see if the DataType is a built-in or if it is a Bus Object:
    % note: boolean.m is a builtin type and file so it needs extra care:
    if(exist(BusObject.Elements(iElement).DataType, 'builtin') || strcmp(BusObject.Elements(iElement).DataType, 'boolean'))
        % The Element is a built in type and contents can be used
        
        % Create the selector block:
        blkSelector = ['Select_' BusObject.Elements(iElement).Name];
        blkSelectorFull = [System '/' blkSelector];
        add_block('built-in/Selector', blkSelectorFull);
        
        % Connect the demux to the selector:
        add_line(System, ['vec/1'], [blkSelector '/1'], ...
            'autorouting', 'off');
       
%         add_line(System, ['vec/1'], [BusObject.Elements(iElement).Name '/1'], ...
%             'autorouting', 'off');
        
        set_param(blkSelectorFull, 'InputPortWidth', num2str(numTotalSignals));
                
        % Position the block:
        set_param(blkSelectorFull, 'Position', ...
            [LeftMargin ...                                                       left edge
            (TopMargin + VerticalSpacing * (iElement-1) + 10) ...                 top edge
            LeftMargin+BlockSize(1) ...                                           right edge
            (TopMargin + VerticalSpacing * (iElement-1) + BlockSize(2)) + 10]); % bottom edge
        
        % Set the value of the block to zeros of size dimensions in that element
        numDim = BusObject.Elements(iElement).Dimensions;
        
        iptr1 = iptr1 + 1;
        if(length(numDim) == 1)
            if(numDim == 1)
                str2set = sprintf('%d', iptr1);
            else
                iptr2 = iptr1 + numDim - 1;
                str2set = sprintf('[%s]', num2str([iptr1:iptr2]));
                iptr1 = iptr2;
            end
            
            set_param(blkSelectorFull, 'Indices', str2set);  
        end
       
        % Create the data type conversion block:
        add_block('simulink/Signal Attributes/Data Type Conversion',  Blocks{iElement});
        
        % Handle builtin DataType:
        set_param(Blocks{iElement}, 'OutDataTypeStr', BusObject.Elements(iElement).DataType);
        
        % Connect the selector to a data type conversion
        add_line(System, [blkSelector '/1'], [BusObject.Elements(iElement).Name '/1'], ...
            'autorouting', 'off');
        
        % Position the block:
        set_param(Blocks{iElement}, 'Position', ...
            [(LeftMargin +150) ...                                                       left edge
            (TopMargin + VerticalSpacing * (iElement-1) + 10) ...                 top edge
            (LeftMargin+150+BlockSize(1)) ...                                           right edge
            (TopMargin + VerticalSpacing * (iElement-1) + BlockSize(2)) + 10]); % bottom edge
        
        
    else
        % The Element is not built-in and therefore another BO definition
        % so another test harness must be created to generate those signals
        
        % Invoke this function to create a subsystem harness for this BO
        % assuming it exists in the base workspace:
        ec = ['CreateVec2BO(' BusObject.Elements(iElement).DataType ', ''' BusObject.Elements(iElement).DataType '_auto'', ' ...
            num2str(numTotalSignals) ', ' num2str(iptr1) ')'];
        evalin('base', ec);
        
        lstBOSub = BusObject2List(BusObject.Elements(iElement).DataType);
        numBOSub = sum(cell2mat(lstBOSub(:,2)));
        iptr1 = iptr1 + numBOSub;
        
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
        
        
        add_line(System, ['vec/1'], [BusObject.Elements(iElement).Name '/1'], ...
            'autorouting', 'off');
        
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
OutputPort = [strBO '_Vec2BO/' strBO];
opPos = get_param(OutputPort, 'Position');
opW = opPos(3) - opPos(1);
hypPos(1) = round(opPos(1) + opW/2);    % x-location
hypPos(2) = opPos(4) + 30;              % y-location
TextToAdd = sprintf('%s(''%s'')', mfnam, strBO);
Hyperlink = [strBO '_Vec2BO/' TextToAdd];
hyp = add_block('built-in/Note', Hyperlink, 'HorizontalAlignment', 'center');
% set_param(hyp, 
set_param(hyp, 'Position', hypPos);
set_param(hyp, 'ClickFcn', TextToAdd);
set_param(hyp, 'DropShadow', 'on');
set_param(hyp, 'FontSize', '12', 'FontWeight', 'bold');




% Final Save
save_system(System);


%% Copy the System to a new model and subsystem:
add_block('built-in/Subsystem', [System '_sub/' strBO '_Vec2BO']);
Simulink.BlockDiagram.copyContentsToSubSystem(System, [System '_sub/' strBO '_Vec2BO']);
set_param([System '_sub/' strBO '_Vec2BO'], 'Position', [20 20 225 125]);

close_system(System);
save_system([System '_sub'], System);
evalin('base', ['!del ' System '_sub.mdl']);
close_system('Simulink', 0)

end % << End of function CreateVec2BO >>

%% REVISION HISTORY
% YYMMDD INI: note
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
