% CREATEUNITTESTMODEL creates a fast unit test model in simulink
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateUnitTestModel:
%     This functions creates a fast unit test model in simulink of a
%     library block. The function will gather the information from the
%     block and generated constants for the inputs and scopes for the
%     number of outputs. Then, the function will save the model created in
%     the current folder.
% 
% SYNTAX:
%	[System] = CreateUnitTestModel(block_fullname, OutArgList, InArgList, varargin, 'PropertyName', PropertyValue)
%	[System] = CreateUnitTestModel(block_fullname, OutArgList, InArgList, varargin)
%	[System] = CreateUnitTestModel(block_fullname, OutArgList, InArgList)
%
% INPUTS: 
%	Name          	Size		Units		Description
%	block_fullname	[1xn]		String		Name of the block in the
%                                           library
%	OutArgList	    <size>		<units>		<Description>
%	InArgList	    <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name          	Size		Units		Description
%	System	        [1xn]		String      Location of the block in
%                                           the folder 
%
% NOTES:
%   This will generate Simulink models with the block selected in the
%   input. Also, it will generate constants for the inputs and scopes for
%   the outputs.
%
%   This function can be used in a loop to generate several unit test for
%   different blocks.
%
%       System = CreateUnitTestModel('Generic_4D_LookUp',
%       'c:/commonsim/VSI_Library/Utilities')
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%   % Example #1: Create a standalone unit test model for a new block
%	% CreateUnitTestModel('foo', 2, 2, 'UseRefLib', false, 'SaveFolder', 'foo')
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CreateUnitTestModel.m">CreateUnitTestModel.m</a>
%	  Driver script: <a href="matlab:edit Driver_CreateUnitTestModel.m">Driver_CreateUnitTestModel.m</a>
%	  Documentation: <a href="matlab:winopen(which('CreateUnitTestModel_Function_Documentation.pptx'));">CreateUnitTestModel_Function_Documentation.pptx</a>
%
% See also Driver_CreateUnitTestModel
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/639
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoSMO_Utilities/CreateUnitTestModel.m $
% $Rev: 3287 $
% $Date: 2014-10-23 19:36:24 -0500 (Thu, 23 Oct 2014) $
% $Author: sufanmi $

function [System] = CreateUnitTestModel(block_fullname, varargin)

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
System= '';

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin

%% Main Function:
[prompt_to_overwrite, varargin]     = format_varargin('prompt_to_overwrite',        true,   2, varargin);
[prompt_to_overwrite_val, varargin] = format_varargin('prompt_to_overwrite_val',    'Y',    2, varargin);
[prompt_to_save_old, varargin]      = format_varargin('prompt_to_save_old',         true,   2, varargin);
[prompt_to_save_old_val, varargin]  = format_varargin('prompt_to_save_old_val',     'N',    2, varargin);
[flgClose, varargin]                = format_varargin('close_file_after_build',     false,  2, varargin);
[UseRefLib, varargin]               = format_varargin('UseRefLib',                  true,   2, varargin);
[RefLib, varargin]                  = format_varargin('RefLib', 'CSA_Library',   2, varargin);
[saveFolder, varargin]              = format_varargin('SaveFolder', '',  2, varargin);
[Markings, varargin]                = format_varargin('Markings', 'Default',  2, varargin);
[ForceAdd, varargin]                = format_varargin('ForceAdd', false, 2, varargin);

OutArgList = [];
nvarargin = size(varargin, 2);
if(nvarargin > 0)
    OutArgList = varargin{1};
end
InArgList = [];
if(nvarargin > 1)
    InArgList = varargin{2};
end

block_fullname = strrep(block_fullname, '\', '/');
ptrSlash = findstr(block_fullname, '/');

if(isempty(ptrSlash))
    if(UseRefLib)
        disp(sprintf('%s : Looking in ''%s'' for ''%s''.  This will take a few...', ...
            mfilename, RefLib, block_fullname));
        lstRefLib = ListLib(RefLib);
        
        cur_block_full = '';
        block_name = block_fullname;
        
        flgMatch = 0; iRefLib = 0;
        while((flgMatch == 0) && (iRefLib < size(lstRefLib, 1)))
            iRefLib = iRefLib + 1;
            curRefLib = lstRefLib{iRefLib, :};
            ptrSlashes = findstr(curRefLib, '/');
            lastBit = curRefLib(ptrSlashes(end)+1:end);
            if(strcmp(lastBit, block_name))
                flgMatch = 1;
                cur_block_full = curRefLib(1:ptrSlashes(end)-1);
            end
        end
    else
        % Assume brand new
        cur_block_full = '';
        block_name = block_fullname;
    end
    
else
    cur_block_full = block_fullname(1:ptrSlash(end)-1);
    block_name = block_fullname(ptrSlash(end)+1:end);
end

load_system('Simulink');

System = ['Test_' block_name];
System = strrep(System, '-', '');
disp(sprintf('%s : Building ''%s''...', mfilename, System));
%% Step 1: Figure out if file exists
if(isempty(saveFolder))
    full_sys_name = [System '.mdl'];
    cur_folder = pwd;
else
    full_sys_name = [saveFolder filesep System '.mdl'];
    cur_folder = saveFolder;
end
flgCopyMade = 0;

if(exist(full_sys_name, 'file') > 0)
    cur_filename = which(full_sys_name);
    if(~isempty(cur_filename))
        cur_folder = fileparts(cur_filename);
    else
        [cur_folder, cur_filename] = fileparts(full_sys_name);
    end
    
    if(prompt_to_overwrite)
        
        disp([mfnam '>> WARNING: ''' System '.mdl'' already exists here: ' cur_folder]);
        R = input([mfnam '>> Do you want to Overwrite this file? {Y,[N]}'],'s');
        R = upper(R);
        if isempty(R)
            R = 'N';
        end
    else
        R = prompt_to_overwrite_val;
    end
    
    if strcmpi(R(1), 'Y')
        if(prompt_to_save_old)
            R2 = input([mfnam '>> Do you want to save an old copy of the current file? {[Y],N}'],'s');
            R2 = upper(R2);
            if isempty(R2)
                R2 = 'Y';
            end
        else
            R2 = prompt_to_save_old_val;
        end
        
        if strcmpi(R2(1),'Y')
            old_filename = [cur_folder filesep System '_old.mdl'];
            copyfile(cur_filename, old_filename, 'f');
            flgCopyMade = 1;
        end
        
    else
        if(~strcmp(pwd, cur_folder))
            R2 = input([mfnam '>> Do you want to Create the function in the current folder? {Y,[N]}'],'s');
            R2 = upper(R2);
            if isempty(R2)
                R2 = 'N';
            end
            if strcmpi(R2(1),'Y')
                R = 'Y';
                cur_folder = pwd;
            end
        end
    end
    
else
    R = 'Y';
end

%%
if strcmpi(R(1),'Y')
    hd = pwd;
    if(~isdir(cur_folder))
        mkdir(cur_folder);
    end
    cd(cur_folder);
    close_system(System, 0);
    evalin('base', ['!del ' System '.mdl']);
    
    new_system(System);
    open_system(System);
    save_system(System);
    
    %% Spacing Control:
    
    LeftMargin      = 20;
    BlockLeftMargin = LeftMargin + 200;
    TopMargin       = 10;
    InportLeftMargin = LeftMargin + 10;
    ConstLeftMargin = LeftMargin;
    InportTopMargin = TopMargin + 130;
    BlockTopMargin  = TopMargin + 130;
    VerticalSpacing = 50;
    HorizontalSpacing = 50;
    PixelPerRowRatio = (15/10);
    DefaultFontSize = 8;
    NewBlockWidth = 140;
    BusSignalWidth = 150;
    
    %% Set up the Unit Test Model
    set_param(System, 'SolverType', 'Fixed-Step');
    set_param(System, 'Solver', 'FixedStepDiscrete');
    set_param(System, 'SolverMode', 'SingleTasking');
    set_param(System, 'FixedStep', '0.01');
    set_param(System, 'StopTime', '0');
    set_param(System, 'SaveTime', 'off');
    set_param(System, 'SaveOutput', 'off');
    set_param(System, 'SignalLogging', 'off');
    set_param(System, 'DSMLoggingName', 'off');
    set_param(System, 'InitFcn', 'ViewValues(1);');
    set_param(System, 'RootOutportRequireBusObject', 'none');
    
     % Add the SVN Info to the New Unit Test Model
    [text_pos_NW, text_pos_SW] = AddTextBlock(System, 'Location', [LeftMargin TopMargin]);
   
    % Add Hyperlink to Documentation:
    strText = ['Open Documentation: ' block_name '_Block_Documentation.pptx'];
    strClick = ['winopen(which(''' block_name '_Block_Documentation.pptx''));'];
    text_pos_SW(2) = text_pos_SW(2) + 5;
    [text_pos_NW, text_pos_SW] = AddTextBlock(System, strText, 'Location', ...
        text_pos_SW, 'ClickFcn', strClick);
    
    %% Add Hyperlink to Unit Test Model Driver:
    strText = ['Open Unit Test Model Driver: Driver_Test_' block_name '.m'];
    strClick = ['edit(''Driver_Test_' block_name ''');'];
    text_pos_SW(2) = text_pos_SW(2) + 5;
    [text_pos_NW, text_pos_SW] = AddTextBlock(System, strText, 'Location', ...
        text_pos_SW, 'ClickFcn', strClick);
    BlockTopMargin = text_pos_SW(2) + 5;
    
    %% Add a Library block
    strBlock = [System '/' block_name];
    
    if(isempty(cur_block_full))
        % Library Not Specified, Make this a brand new unit test model
        
        %% Output Ports
        % Check OutArgList for format and existence
        if isempty(OutArgList)
            nout = 0; OutArgList = {};
        elseif iscell(OutArgList)
            %are all element character strings
            if any(~cellfun('isclass',OutArgList,'char'));
                errorstr = 'OutArgList (input 2) All elements must be of type "char" ! ';
                disp([mfnam '>>ERROR: ' errorstr]);
                error(errorstr);
            end
            nout = length(OutArgList);
        elseif isnumeric(OutArgList) % OutputArgument Names Not given, Generat list
            nout = OutArgList;
            OutArgList = cell(nout,1); % allocate empty cell
            for i = 1:nout
                OutArgList{i} = ['Out' num2str(i)];
            end
        elseif ischar(OutArgList) % Very special case of one named argument
            nout = 1; OutArgList = {OutArgList};
        end
        
        %% Input Ports
        % Input 3 InArgList check for existence and format
        if isempty(InArgList)
            nin = 0;
            InArgList = {};
        elseif iscell(InArgList)
            %are all element character strings
            if any(~cellfun('isclass',InArgList,'char'));
                errorstr = 'InArgList (input 3) All elements must be of type "char" ! ';
                disp([mfnam '>>ERROR: ' errorstr]);
                error(errorstr);
            end
            nin = length(InArgList);
        elseif isnumeric(InArgList) % OutputArgument Names Not given, Generat list
            nin = InArgList;
            InArgList = cell(nin,1); % allocate empty cell
            for i = 1:nin
                InArgList{i} = ['In' num2str(i)];
            end
        elseif ischar(InArgList) % Very special case of one named argument
            nin = 1; InArgList = {InArgList};
        end
        
        %% Actually Build the New Block:
        cur_block_full = [System '/' block_name];
        cur_block_short = block_name;
        
        add_block('built-in/SubSystem', cur_block_full);
        set_param(cur_block_full, 'TreatAsAtomicUnit', 'on');
        block_pos = get_param(cur_block_full, 'Position');
        block_pos(3) = block_pos(1) + NewBlockWidth;
        set_param(cur_block_full, 'Position', block_pos);

        % Add the DocBlock:
        [TextToAdd, DocBlockPos] = CreateNewDocBlock(cur_block_full, ...
            Markings, 'InArgList', InArgList, 'OutArgList', OutArgList);
        DocBlockWidth = DocBlockPos(3) - DocBlockPos(1);
        
        % Add SVN keywords:
        TextLoc(1) = DocBlockPos(1) + DocBlockWidth + 10;
        TextLoc(2) = DocBlockPos(2);
        [text_pos_NW, text_pos_SW] = AddTextBlock(cur_block_full, 'Location', TextLoc);
    
        % Add Hyperlink to Unit Test Model:
        strText = ['Open Unit Test Model: Test_' cur_block_short '.mdl'];
        strClick = ['Test_' cur_block_short];
        [text_pos_NW, text_pos_SW] = AddTextBlock(cur_block_full, strText, ...
            'Location', text_pos_SW, 'ClickFcn', strClick, 'OpenBlock', false);

        % Add Hyperlink to Documentation:
        strText = ['Open Documentation: ' block_name '_Block_Documentation.pptx'];
        strClick = ['winopen(which(''' block_name '_Block_Documentation.pptx''));'];
        text_pos_SW(2) = text_pos_SW(2) + 5;
        [text_pos_NW, text_pos_SW] = AddTextBlock(cur_block_full, strText, ...
            'Location', text_pos_SW, 'ClickFcn', strClick);

        TopMargin = text_pos_SW(2) + 10;
        
        % Add Input Ports and Terminators
        for i = 1:nin
            port_name = InArgList{i};
            port_name_full =  [cur_block_full '/' port_name];
            add_block('simulink/Sources/In1', port_name_full);
            
            port_pos = get_param(port_name_full, 'Position');
            port_pos_o = port_pos;
            port_w = port_pos(3) - port_pos(1);
            port_h = port_pos(4) - port_pos(2);
            port_pos(1) = LeftMargin;
            port_pos(2) = TopMargin + (i-1)*VerticalSpacing;
            port_pos(3) = port_pos(1) + port_w;
            port_pos(4) = port_pos(2) + port_h;
            
            set_param(port_name_full, 'Position', port_pos);
            set_param(port_name_full, 'BackgroundColor','green');
            
            term_name = ['Terminate_' InArgList{i}];
            term_name_full =  [cur_block_full '/' term_name];
            add_block('simulink/Sinks/Terminator', term_name_full);
            set_param(term_name_full, 'ShowName', 'off');
            
            term_pos = get_param(term_name_full, 'Position');
            term_w = term_pos(3) - term_pos(1);
            term_h = term_pos(4) - term_pos(2);
            term_pos(1) = port_pos(3) + HorizontalSpacing;
            term_pos(2) = port_pos(2) + port_h/2 - term_h/2;
            term_pos(3) = term_pos(1) + term_w;
            term_pos(4) = term_pos(2) + term_h;
            
            set_param(term_name_full, 'Position', term_pos);
            add_line(cur_block_full, [port_name '/1'], [term_name '/1']);
        end
        
        % Add Output Ports and Constant Blocks
        for i = 1:nout
            port_name = OutArgList{i};
            port_name_full =  [cur_block_full '/' port_name];
            add_block('simulink/Sinks/Out1', port_name_full);
            
            port_pos = get_param(port_name_full, 'Position');
            port_pos_o = port_pos;
            port_w = port_pos(3) - port_pos(1);
            port_h = port_pos(4) - port_pos(2);
            port_pos(1) = LeftMargin + 5 * HorizontalSpacing;
            port_pos(2) = TopMargin + (i-1)*VerticalSpacing;
            port_pos(3) = port_pos(1) + port_w;
            port_pos(4) = port_pos(2) + port_h;
            
            set_param(port_name_full, 'Position', port_pos);
            set_param(port_name_full, 'BackgroundColor','gray');
            
            const_name = ['Const_' OutArgList{i}];
            const_name_full =  [cur_block_full '/' const_name];
            add_block('simulink/Sources/Constant', const_name_full);
            set_param(const_name_full, 'ShowName', 'on');
            set_param(const_name_full, 'Value', num2str(i));
            
            if(nin > 0)
                const_pos = get_param(term_name_full, 'Position');
                const_w = term_pos(3) - term_pos(1);
                const_h = term_pos(4) - term_pos(2);
            else
                const_pos = get_param(const_name_full, 'Position');
                const_w = const_pos(3) - const_pos(1);
                const_h = const_pos(4) - const_pos(2);
            end
            
            const_pos(1) = port_pos(3) - 2 * HorizontalSpacing;
            const_pos(2) = port_pos(2) + port_h/2 - const_h/2;
            const_pos(3) = const_pos(1) + const_w;
            const_pos(4) = const_pos(2) + const_h;
            
            set_param(const_name_full, 'Position', const_pos);
            add_line(cur_block_full, [const_name '/1'], [port_name '/1']);
        end
        
        cur_block_full = System;
        block_fullname = [ cur_block_full '/' block_name ];
    else
        
        ptrSlash = findstr(cur_block_full, '/');
        if(isempty(ptrSlash))
            str_lib = cur_block_full;
        else
            str_lib = cur_block_full(1:ptrSlash(1)-1);
        end
        load_system(str_lib);
        
        cur_block_full = strrep(cur_block_full, '\', '/');
        add_block([cur_block_full '/' block_name], [ System '/' block_name ]);
        block_fullname = [ System '/' block_name ];
        close_system(str_lib, 0);
    end
        
    set_param(strBlock, 'ShowName', 'On');
    disp(sprintf('%s : Gathering Input/Output Port Info for ''%s''...', ...
        mfilename, block_fullname));
    [lstInports,lstOutports] = findPorts(block_fullname, 1);
    noutputs = size(lstOutports, 1);
    ninputs = size(lstInports, 1);
    PortHandles = get_param(block_fullname, 'PortHandles');
    
    %Position of the library block
    block_pos = get_param(strBlock, 'Position');
    block_w = block_pos(3) - block_pos(1);
    block_h = block_pos(4) - block_pos(2);
    
    nports = max(noutputs, ninputs);
    if(nports > 1)
        block_h = floor((1 + nports) * VerticalSpacing);
    end
    block_pos(1) = BlockLeftMargin;
    block_pos(2) = BlockTopMargin;
    block_pos(3) = block_pos(1) + block_w;
    block_pos(4) = block_pos(2) + block_h;
    
    set_param(strBlock, 'Position', block_pos ); %bottom edge
    % set_param(strBlock, 'Name', block_name);
    set_param(System,'LibraryLinkDisplay', 'all', 'ShowLineDimensions','on')
    
    system_loc      = get_param(System, 'Location');
    system_width    = system_loc(3) - system_loc(1);
    system_height   = system_loc(4) - system_loc(2);
    
    system_right = block_pos(3) + 100;
    system_bot   = block_pos(2) + block_pos(4);
    
    load_system('Simulink');
    
    %% ====================================================================
        
    %% Add the constant Blocks:
    if ninputs > 0

        %% Construct List of Inputs
        strSelectedSignals = '';
        for iinput=1:ninputs
            strInput = lstInports{iinput};
            strInput = strInput(length(block_fullname)+2:end);
            lstInputSignals(iinput,:) = {strInput};
            if(iinput < ninputs)
                strSelectedSignals = [strSelectedSignals strInput ','];
            else
                strSelectedSignals = [strSelectedSignals strInput];
            end
        end

        %% Add The External Input Ports
        for iinput=1:ninputs
            strInput = lstInports{iinput};
            strInput = strInput(length(block_fullname)+2:end);
            strInput = ['Input_' strInput];
            blkInport = [System '/' strInput];
            lstInport(iinput,:) = {blkInport};
            
            add_block('simulink/Sources/In1', blkInport);
            set_param(blkInport, 'BackgroundColor', 'green');

            inport_pos = get_param(blkInport, 'Position');
            inport_w = (inport_pos(3) - inport_pos(1));
            inport_h = (inport_pos(4) - inport_pos(2));
            inport_pos(1) = InportLeftMargin;
            inport_pos(2) = InportTopMargin + iinput * VerticalSpacing;
            inport_pos(3) = inport_pos(1) + inport_w;
            inport_pos(4) = inport_pos(2) + inport_h;
            set_param( blkInport, 'Position', inport_pos );

            if(iinput == 1)
                blkInportHdl = get_param(blkInport, 'PortHandles');
                InportPos = get_param(blkInportHdl.Outport(1), 'Position');
                bC1_top = InportPos(2);
            end
        end
        
        %% Add Bus Creator #1
        % Add Bus Creator
        bC1 = [System '/BusCreator1'];
        add_block('simulink/Signal Routing/Bus Creator', bC1);
        set_param(bC1, 'Inputs', num2str(ninputs));
        bC1h = get_param(bC1, 'PortHandles');
        bC1_pos = get_param(bC1, 'Position');
        bC1_w = bC1_pos(3) - bC1_pos(1);
        bC1_h = VerticalSpacing * ninputs;
        bC1_pos(1) = InportLeftMargin + inport_w + BusSignalWidth;
        bC1_pos(2) = bC1_top - VerticalSpacing/2;
        bC1_pos(3) = bC1_pos(1) + bC1_w;
        bC1_pos(4) = bC1_pos(2) + bC1_h;
        set_param(bC1, 'Position', bC1_pos);

        %% Connect Input Ports to Bus Creator #1
        for iinput=1:ninputs
            blkInport   = lstInport{iinput};
            strInput    = lstInputSignals{iinput};
            InportPortHandles = get_param(blkInport, 'PortHandles');
            hLine = add_line(System, InportPortHandles.Outport(1), bC1h.Inport(iinput));
            set_param(hLine, 'Name', strInput);
        end
        
        %% Add Inport Port for Switch
        blkInport = [System '/flgUseInput'];
        add_block('simulink/Sources/In1', blkInport);
        set_param(blkInport, 'BackgroundColor', 'green');
        set_param(blkInport, 'Port', '1');
        blkInportHdl = get_param(blkInport, 'PortHandles');
        
        inport_pos = get_param(blkInport, 'Position');
        inport_w = (inport_pos(3) - inport_pos(1));
        inport_h = (inport_pos(4) - inport_pos(2));
        inport_pos(1) = InportLeftMargin;
        inport_pos(2) = InportTopMargin + (ninputs + 1) * VerticalSpacing;
        inport_pos(3) = inport_pos(1) + inport_w;
        inport_pos(4) = inport_pos(2) + inport_h;
        set_param( blkInport, 'Position', inport_pos );
        ConstTopMargin = inport_pos(2) + inport_h + 50;
        
        FlgUseInputCenter = get_param(blkInportHdl.Outport(1), 'Position');

        %% Add Constant Blocks for internal testing
        for iinput=1:ninputs
            strInput = lstInports{iinput};
            strInput = strInput(length(block_fullname)+2:end);
            const_name = [System '/' strInput];
            lstConst(iinput,:) = {const_name};
            add_block('simulink/Sources/Constant', const_name);

            const_pos = get_param(const_name, 'Position');
            const_w = (const_pos(3) - const_pos(1)) * 2;
            const_h = floor((const_pos(4) - const_pos(2)) * .75);
            const_pos(1) = ConstLeftMargin;
            const_pos(2) = ConstTopMargin + VerticalSpacing * (iinput-1);
            const_pos(3) = const_pos(1) + const_w;
            const_pos(4) = const_pos(2) + const_h;
            set_param( const_name, 'Position', const_pos );
            set_param( const_name, 'Value', '0' );
            constPortHdl = get_param(const_name, 'PortHandles');

            if(iinput == 1)
                ConstPos = get_param(constPortHdl.Outport(1), 'Position');
                bC2_top = ConstPos(2);
            end
        end
        
        %% Add Bus Creator #2
        bC2 = [System '/BusCreator2'];
        add_block('simulink/Signal Routing/Bus Creator', bC2);
        set_param(bC2, 'Inputs', num2str(ninputs));
        bC2h = get_param(bC2, 'PortHandles');
        bC_pos = get_param(bC2, 'Position');
        
        bC2_h = bC1_h;
        bC2_w = bC1_w;
        bC2_pos(1) = bC1_pos(1);
        bC2_pos(2) = bC2_top - VerticalSpacing/2;
        bC2_pos(3) = bC2_pos(1) + bC2_w;
        bC2_pos(4) = bC2_pos(2) + bC2_h;
        set_param(bC2, 'Position', bC2_pos);
        
        %% Connect Outputs of Const Block to Bus Creator #2
        for iinput=1:ninputs
            blkConst    = lstConst{iinput,:};
            strInput    = lstInputSignals{iinput,:};
            ConstPortHandles = get_param(blkConst, 'PortHandles');
            
            hLine = add_line(System, ConstPortHandles.Outport(1), bC2h.Inport(iinput));
            set_param(hLine, 'Name', strInput);
        end
        
         %% Add Switch
        blkSwitch = [System '/Switch'];
        add_block('simulink/Signal Routing/Switch', blkSwitch);
        set_param(blkSwitch, 'ShowName', 'off');
        set_param(blkSwitch, 'Criteria', 'u2 > Threshold');
        set_param(blkSwitch, 'Threshold', '0.5');
        SwitchPortHdl = get_param(blkSwitch, 'PortHandles');
        
        bC1_p = get_param(bC1h.Outport(1), 'Position');
        bC2_p = get_param(bC2h.Outport(1), 'Position');
        switch_h = (bC2_p(2) - bC1_p(1))*1.5;
        
        switch_pos = get_param(blkSwitch, 'Position');
        switch_w = switch_pos(3) - switch_pos(1);
        switch_pos(1) = bC1_p(1) + 50;
        switch_pos(2) = FlgUseInputCenter(2) - switch_h/2;
        switch_pos(3) = switch_pos(1) + switch_w;
        switch_pos(4) = switch_pos(2) + switch_h;
        set_param(blkSwitch, 'Position', switch_pos);      
        SwitchCenter = get_param(SwitchPortHdl.Outport(1), 'Position');
        
        %% Connect Output of Bus Creator 1 to Switch
        add_line(System, bC1h.Outport(1), SwitchPortHdl.Inport(1));
        add_line(System, blkInportHdl.Outport(1), SwitchPortHdl.Inport(2));
        add_line(System, bC2h.Outport(1), SwitchPortHdl.Inport(3));
           
        %% Add Bus Selector
        bS1 = [System '/BusSelector1'];
        add_block('simulink/Signal Routing/Bus Selector', bS1);
        set_param(bS1, 'OutputSignals', strSelectedSignals);
        bS1h = get_param(bS1, 'PortHandles');
        bS1_pos = get_param(bS1, 'Position');
        bS1_w = bS1_pos(3) - bS1_pos(1);
        bS1_h = floor(block_h);
        bS1_pos(1) = SwitchCenter(1) + 50;
        bS1_pos(2) = floor(SwitchCenter(2) - bS1_h/2);
        bS1_pos(3) = bS1_pos(1) + bS1_w;
        bS1_pos(4) = bS1_pos(2) + bS1_h;
        set_param(bS1, 'Position', bS1_pos);
        
        % Connect to Switch
        add_line(System, SwitchPortHdl.Outport(1), bS1h.Inport(1));
        set_param(bS1, 'OutputSignals', strSelectedSignals);
%         bS1h = get_param(bS1, 'PortHandles');

        %% Move Block
        block_pos(1) = bS1_pos(1) + BusSignalWidth;
        block_pos(2) = SwitchCenter(2) - block_h/2;
        block_pos(3) = block_pos(1) + block_w;
        block_pos(4) = block_pos(2) + block_h;
        set_param(strBlock, 'Position', block_pos );
        
        for iinput = 1:ninputs
            add_line(System, bS1h.Outport(iinput), PortHandles.Inport(iinput));
        end
        
    end
    
        %% Add an Output Scope:
    if noutputs > 0
        %% Construct List of Outputs
        strSelectedSignals = '';
        lstOutputSignals = {};
        for ioutput=1:noutputs
            strOutput = lstOutports{ioutput};
            strOutput = strOutput(length(block_fullname)+2:end);
            lstOutputSignals(ioutput,:) = {strOutput};
            if(ioutput < noutputs)
                strSelectedSignals = [strSelectedSignals strOutput ','];
            else
                strSelectedSignals = [strSelectedSignals strOutput];
            end
        end
        
        %% Add Bus Creator #3
        bC3 = [System '/BusCreator3'];
        add_block('simulink/Signal Routing/Bus Creator', bC3);
        set_param(bC3, 'Inputs', num2str(noutputs));
        bC3h = get_param(bC3, 'PortHandles');
        bC3_pos = get_param(bC3, 'Position');
        
        bC3_h = block_h;
        bC3_w = bC3_pos(3) - bC3_pos(1);
        bC3_pos(1) = block_pos(1) + block_w + BusSignalWidth;
        bC3_pos(2) = block_pos(2);
        bC3_pos(3) = bC3_pos(1) + bC3_w;
        bC3_pos(4) = bC3_pos(2) + bC3_h;
        set_param(bC3, 'Position', bC3_pos);
        
        %% Connect Lines
        for ioutput=1:noutputs
            hLine = add_line(System, PortHandles.Outport(ioutput), bC3h.Inport(ioutput));
            set_param(hLine, 'Name', lstOutputSignals{ioutput,:});
        end
        
        %% Add output Port
        OutPort =  [System '/Out'];
        add_block('simulink/Sinks/Out1', OutPort);
        set_param(OutPort, 'BackgroundColor', 'gray');
        OutPortPortHdls = get_param(OutPort, 'PortHandles');

        outport_pos = get_param(OutPort, 'Position');
        outport_w = outport_pos(3) - outport_pos(1);
        outport_h = outport_pos(4) - outport_pos(2);
        
        bC3_outCenter = get_param(bC3h.Outport(1), 'Position');
        outport_pos(1) = bC3_outCenter(1) + 50;
        outport_pos(2) = bC3_outCenter(2) - outport_h/2;
        outport_pos(3) = outport_pos(1) + outport_w;
        outport_pos(4) = outport_pos(2) + outport_h;
        set_param(OutPort, 'Position', outport_pos);
        
         %% Connect it to the Bus Creator
        hLine = add_line(System, bC3h.Outport(1), OutPortPortHdls.Inport(1));
        
        %% Create Bus Selector #2
        bS2 = [System '/BusSelector2'];
        add_block('simulink/Signal Routing/Bus Selector', bS2);
        set_param(bS2, 'OutputSignals', strSelectedSignals);
        bS2h = get_param(bS2, 'PortHandles');
        
        bS2_pos = get_param(bS2, 'Position');
        bS2_w = bS2_pos(3) - bS2_pos(1);
        bS2_h = bC3_h;
        bS2_pos(1) = outport_pos(1);
        bS2_pos(2) = outport_pos(2) + 100;
        bS2_pos(3) = bS2_pos(1) + bS2_w;
        bS2_pos(4) = bS2_pos(2) + bS2_h;
        set_param(bS2, 'Position', bS2_pos);
        
        % Connect to Switch
        add_line(System, bC3h.Outport(1), bS2h.Inport(1));
        
        
        %% Create Output Scopes
        for ioutput=1:noutputs
            scope_name = [System '/' lstOutputSignals{ioutput,:}];
            add_block('simulink/Sinks/Display', scope_name);
            
            scope_pos = get_param(scope_name, 'Position');
            scope_w = scope_pos(3) - scope_pos(1);
            scope_h = scope_pos(4) - scope_pos(2);
            scope_hdl = get_param(scope_name, 'PortHandles');
            
            bS2_pos = get_param(bS2h.Outport(ioutput), 'Position');
            
            scope_pos(1) = bS2_pos(1) + BusSignalWidth;
            scope_pos(2) = bS2_pos(2) - scope_h/2;
            scope_pos(3) = scope_pos(1) + scope_w;
            scope_pos(4) = scope_pos(2) + scope_h;
            set_param(scope_name, 'Position', scope_pos);
            hLine = add_line(System, bS2h.Outport(ioutput), scope_hdl.Inport(1));
        end
           
        system_right = scope_pos(3) + 50;
        system_bot = scope_pos(4) + 50;

    end
    
    %% Add the DocBlock and SVN Info
    %  This checks to see if the internal documentation and SVN info exists in
    %  the new library block
    [DocBlockFound, DocBlockPath] = isblock('DocBlock', [System '/' block_name]);
    SVNTextFound = isblock('Text', [System '/' block_name], {'Subversion','URL','Rev'});
    
    if( (~DocBlockFound || ~SVNTextFound) && (ForceAdd) )
        blockStatus = get_param([System '/' block_name], 'LinkStatus');
        
        if( strcmp(blockStatus, 'resolved') )
            disp([mfnam '>>WARNING: DocBlock and/or SVN Tags missing in Libraried Block.  Unlocking link for addition.']);
            set_param([System '/' block_name], 'LinkStatus','inactive');
        end
        
        if(~DocBlockFound)
            [TextToAdd, block_pos] = CreateNewDocBlock([System '/' block_name]);
        else
            block_pos = get_param(DocBlockPath, 'Location');
        end
        
        if(~SVNTextFound)
            TextLocation = [block_pos(3), block_pos(2)-20];
            AddTextBlock([System '/' block_name], 'Location', TextLocation);
        end
        
        %% Add Hyperlink to Unit Test Model
        cur_block_full = [System '/' block_name];
        cur_block_short = block_name;
        [TextFound, TextHdl] = isblock('Text', cur_block_full, {'Open Unit Test Model'});
        if(TextFound)
            FoundText = get_param(TextHdl, 'Text');
            numRows = length(findstr(FoundText, char(10))) + 1;
            FontSizeCheck = get_param(TextHdl, 'FontSize');
            if(FontSizeCheck == -1)
                FontSizeCheck = DefaultFontSize;
            end
            PixelPerRow = PixelPerRowRatio * FontSizeCheck;
            
            text_pos_NW = get_param(TextHdl, 'Position');
            text_pos_SW = text_pos_NW;
            text_pos_SW(2) = text_pos_SW(2) + PixelPerRow * numRows;
        else 
%             disp(['Need to add Hyperlink to Unit Test Model for ' cur_block_short]);
            strText = ['Open Unit Test Model: Test_' cur_block_short '.mdl'];
            strClick = ['Test_' cur_block_short];
            [text_pos_NW, text_pos_SW] = AddTextBlock(cur_block_full, strText, 'Location', text_pos_SW, 'ClickFcn', strClick, 'OpenBlock', false);
%             iCtr = iCtr + 1; lstChange(iCtr, :) = {['Add Hyperlink to Unit Test: ' cur_block_full]};
        end
        
        %% Add Hyperlink to Documentation
        [TextFound, TextHdl] = isblock('Text', cur_block_full, {'Open Documentation'});
        if(TextFound)
            FontSizeCheck = get_param(TextHdl, 'FontSize');
            if(FontSizeCheck == -1)
                FontSizeCheck = DefaultFontSize;
            end
            PixelPerRow = PixelPerRowRatio * FontSizeCheck;
            
            text_pos_NW = get_param(TextHdl, 'Position');
            text_pos_SW = text_pos_NW;
            text_pos_SW(2) = text_pos_SW(2) + PixelPerRow * numRows;
        else
            %             disp(['Need to add Hyperlink to Block Documentation for ' cur_block_short]);
            strText = ['Open Documentation: ' cur_block_short '_Block_Documentation.pptx'];
            strClick = ['winopen(which(''' cur_block_short '_Block_Documentation.pptx''));'];
            [text_pos_NW, text_pos_SW] = AddTextBlock(cur_block_full, strText, 'Location', text_pos_SW, 'ClickFcn', strClick, 'OpenBlock', false);
%             iCtr = iCtr + 1; lstChange(iCtr, :) = {['Add Hyperlink to Documentation: ' cur_block_full]};
        end
    end

    % Resize the Model:
    save_system(System);
    open_system(System);
    system_loc = get_param(System, 'Location');
    system_loc(3) = system_loc(1) + system_right;
    system_loc(4) = system_loc(2) + system_bot;
    set_param(System, 'Location', system_loc);
    
    close_system('Simulink', 0)
    save_system(System);
    
    if(flgClose)
        close_system(System);
    else
        open_system(System);
    
        if(flgCopyMade)
            open_system(old_filename);
        end
        
    end
    
    cd(hd);
    
end

%% Compile Outputs:
%	System= -1;

end % << End of function CreateUnitTestModel >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101022 JPG: Copied over information from the old function.
% 101022 CNF: Function template created using CreateNewFunc
% 100722 JJ & MWS: File created
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName             : Email                             : NGGN Username
% MWS: Mike Sufana          : mike.sufana@ngc.com               : sufanmi
% JJ: Jovany Jimenez        : jovany.jimenez-deparias@ngc.com   : G67086
% JPG: James Patrick Gray   : james.gray2@ngc.com               : G61720

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
