% CREATEBLOCK_DRIVERSCRIPT Creates a properly formated driver script to test a block
% ------------------------- UNCLASSIFIED -------------------------
% ------------- NORTHROP GRUMMAN PROPRIETARY LEVEL 1 -------------
% ------------------ITAR Controlled Work Product------------------
% CreateBlock_DriverScript:
%   Creates a new formated driver to test a block
%
% SYNTAX:
%   [fl,info] = CreateBlock_DriverScript(block_name, 'PropertyName', PropertyValue)
%   [fl,info] = CreateBlock_DriverScript(block_name, varargin)
%   [fl,info] = CreateBlock_DriverScript(block_name)
%
% INPUTS:
%	Name                    Size        Units   Description
%   block_name              [string]    N/A     Name of reference block
%                                                Default: 'foo'
%   block_description       [string]    N/A     Short explanation of what
%                                                reference block does
%                                                Default: ''
%    varargin                N/A         N/A     Coupled Inputs with additional
%                                               text properties that can be
%                                               specified in any order
% OUTPUTS:
%	Name                    Size        Units       Description
%   fl                      [1]         ["bool"]    Driver Function built successfully?
%   info                    {struct}    [N/A]       Information on how block ran
%
% NOTES:
%	VARARGIN PROPERTIES:
%	PropertyName            PropertyValue	Default		Description
%   Markings                'string'        'Default'   Defines format to use for the
%                                                       function's Header/Footer
%   BlkLocInTestModel                'string'        ''          Location of block
%                                                       in Unit Test model
%   SVN                     [bool]          true        Include SVN keytags
%
%	prompt_to_overwrite     [bool]          true        If function already
%                                                       exists, prompt user to
%                                                       overwrite if desired?
%   prompt_to_overwrite_val 'string'        'Y'         If prompt not allowed,
%                                                       should file be overwritten?
%   prompt_to_save_old      [bool]          true        If the file is being overwritten,
%                                                       should the user be prompted
%                                                       to save off a copy of the
%                                                       old file?
%   prompt_to_save_old_val  'string'        'N'         If not prompted, save off
%                                                       a copy of the old file?
%   open_file_after_build   [bool]          true        Open the function and the old
%                                                       function (if craeted) after
%                                                       the build?
%   SaveFolder              'string'        pwd
%
% EXAMPLE:
%   % Create a fuction 'foo' with 2 input argument and 2 output arguments
%   % Then create a test driver script for the block
%	CreateNewFunc('foo',2,2);
%   [status,info] = CreateBlock_DriverScript('foo')
%
%   % Create a driver for the block 'foo', fully overwritting file if it
%   % exists, and not saving off a copy first
%   CreateBlock_DriverScript('foo','prompt_to_overwrite',0,'prompt_to_save_old',0,'prompt_to_save_old_val','N')
%
% HYPERLINKS:
%	Source block: <a href="matlab:edit CreateBlock_DriverScript.m">CreateBlock_DriverScript.m</a>
%	  Driver script: <a href="matlab:edit Driver_CreateBlock_DriverScript.m">Driver_CreateBlock_DriverScript.m</a>
%	  Documentation: <a href="matlab:winopen(which('CreateBlock_DriverScript Documentation.pptx'));">CreateBlock_DriverScript Documentation.pptx</a>
%
% See also: CreateNewFunc
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/635
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoSMO_Utilities/CreateBlock_DriverScript.m $
% $Rev: 3034 $
% $Date: 2013-10-16 17:24:04 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

% function [fl,info] = CreateBlock_DriverScript(block_name, varargin)
function [fl,info] = CreateBlock_DriverScript(block_testmodel, varargin)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
tab2 = [tab tab];                                   % Two Tabs
tab3 = [tab tab tab];                               % Three Tabs
tab4 = [tab tab tab tab];                           % Four Tabs
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
% error([mfnam 'class:file:Identifier'], errstr);    % Call error function
% with error string

%% Input Argument Conditioning
[prompt_to_overwrite, varargin]     = format_varargin('prompt_to_overwrite',        true,   2, varargin);
[prompt_to_overwrite_val, varargin] = format_varargin('prompt_to_overwrite_val',    'Y',    2, varargin);
[prompt_to_save_old, varargin]      = format_varargin('prompt_to_save_old',         true,   2, varargin);
[prompt_to_save_old_val, varargin]  = format_varargin('prompt_to_save_old_val',     'N',    2, varargin);
[open_file_after_build, varargin]   = format_varargin('open_file_after_build',      true,   2, varargin);
[blk_loc_in_testmdl, varargin]      = format_varargin('BlkLocInTestModel',          '',     2, varargin);
[CNF_info, varargin]                = format_varargin('Markings',                   'Default',  2, varargin);
[SVN, varargin]                     = format_varargin('SVN',                        true,       2, varargin);
[block_description, varargin]       = format_varargin('Description',                '', 2, varargin);

% [block_testmodel, varargin]         = format_varargin('UnitTestModel', ['Test_' block_name], 2, varargin);
[driver_fname, varargin]            = format_varargin('Drivername', ['Driver_' block_testmodel], 2, varargin);

block_name = strrep(block_testmodel, 'Test_', '');

if(isempty(block_description))
    block_description= '<Enter block description here>';
end

if(isempty(blk_loc_in_testmdl))
    blk_loc_in_testmdl = [block_testmodel '/' block_name];
end

% Test Input 1 block_name;  arg type
if ~ischar(block_name);
    errorstr = 'block_name (input 1) must be of type "char" ! ';
    disp([mfnam '>>ERROR: ' errorstr]);
    error(errorstr);
end

%% Load in Markings for New Script
CNF_info_Def = CreateNewFile_Defaults(1, mfnam);
if ischar(CNF_info)
    switch CNF_info
        case 'Default'
            CNF_info = CNF_info_Def; %local call to get default values
        case 'Search'
            CNF_info = 'CreateNewFunc_info';
        otherwise
            % assume it is a mat file name and with one variable in it.
            % so that fieldnames returns one value.
            %                 Temp  = load(CNF_info); %only option for now
            %                 CNF_info = Temp.(char(fieldnames(Temp)));
            eval(sprintf('CNF_info = %s(1, mfnam);', CNF_info));
    end
elseif isnumeric(CNF_info) && CNF_info==-1
    CNF_info = CNF_info_Def; % local Call to get default values
elseif isstruct(CNF_info)
    %Use the structure input...
else
    errorstr = 'Wrong Type or information on CNF_info';
    disp([mfnam '>>ERROR: ' errorstr]);
    return;
end

% Load CNF_info file if CNF_info is a character
if ischar(CNF_info)
    load(CNF_info); % Must Contain CNF_info struct
    if ~exist('CNF_info','var');
        errstr = 'Does Not Contain a CNF Info variable';
        error([mfnam '>>:ERROR' errstr]);
    end
end

%Check Headers/populate missing fields
% TODO: this section ->Assume correct at this point
warnstate = warning('QUERY','catstruct:DupFieldnames');
warning('OFF','catstruct:DupFieldnames');
CNF_info = catstruct(CNF_info_Def,CNF_info); %use default values -> over right with values from input
warning(warnstate.state,'catstruct:DupFieldnames');

%% Header Classified Lines
up_driver_fname = upper(driver_fname);
fstr = ['% ' up_driver_fname ' Main test driver script for ' block_testmodel '.mdl' endl];

% Header Classification Line
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

fstr = [fstr '% ' driver_fname '.m' tab endl];
fstr = [fstr '%' tab 'This is the main test driver script for the ' block_name ' block.' endl];
fstr = [fstr '%' endl];
fstr = [fstr '%' spc block_name ':' tab block_description endl];
fstr = [fstr '%' endl];

% Test Driver Hyperlink
fstr = [fstr '% Hyperlinks:' endl];
fstr = [fstr '%' tab ' Source block: ' '<a href="matlab:open ' block_testmodel '.mdl">' block_testmodel '.mdl</a>' endl];
fstr = [fstr '%' tab 'Driver script: ' '<a href="matlab:edit ' driver_fname '.m">' driver_fname '.m</a>' endl];
fstr = [fstr '%' tab 'Documentation: ' '<a href="matlab:winopen(which(''' block_name '_Block_Documentation.pptx''));">' block_name '_Block_Documentation.pptx</a>' endl];
fstr = [fstr '%' endl];

%% Copyright
if(isfield(CNF_info, 'Copyright'))
    if(~isempty(CNF_info.Copyright))
        fstr = [fstr CNF_info.Copyright];
        fstr = [fstr endl];
    end
end

%% SVN Keywords
if(SVN)
    % NOTE: spaces added to prevent keyword substitution on this line
    fstr = [fstr '% Subversion Revision Information At Last Commit' endl ...
        '% $URL: ' '$' endl ...
        '% $Rev: ' '$' endl ...
        '% $Date: ' '$' endl ...
        '% $Author: ' '$' endl ...
        endl]; %Blank Line
end

%% Interrogate Block to Get Input and Output names
if exist(block_testmodel, 'file') == 4
    load_system(block_testmodel);
end
[lstInports,lstOutports] = findPorts(block_testmodel, 0);

if (~isempty(lstInports)) 
    if(strcmp(lstInports{1,1}, 'flgUseInput'))
        lstInports = lstInports(2:end);
    end
end

nout = size(lstOutports, 1);
nin = size(lstInports, 1);

for i = 1:nin
    curInName = lstInports{i,1};
    if(strncmpi(curInName, 'Input_', 6))
        curInName = curInName(7:end);
        lstInports{i,1} = curInName;
    end
end

max_inputname_length = size(char(lstInports), 2);
max_outputname_length = size(char(lstOutports), 2);

%% Main Function Creation
nExamples = 1;

fstr = [fstr '%% Housekeeping:' endl];
fstr = [fstr 'close all; clc;' endl];
fstr = [fstr endl];
fstr = [fstr '%% User Defined:' endl];

if(nExamples == 1)
    fstr = [fstr 'arrExampleToRun = [1];' endl];
else
    fstr = [fstr 'arrExampleToRun = [1:' num2str(nExamples) '];' endl];
end

fstr = [fstr endl];
fstr = [fstr 'strUnitTest  = ''' block_testmodel ''';' endl];
fstr = [fstr 'pptFilename  = which(''' block_name '_Block_Documentation.pptx'');' endl];
fstr = [fstr 'flgSaveToPPT = 0;     % Save Figures to PowerPoint?' endl];
fstr = [fstr endl];

if(nin > 0)
    fstr = [fstr '% Define Unit Test Inputs:' endl];
    fstr = [fstr '% lstInputs(:,1):  ''string''   Input Signal Name' endl];
    fstr = [fstr '% lstInputs(:,2):  ''string''   Input Signal Units' endl];
    fstr = [fstr 'lstInputs = { ...' endl];
    for i = 1:nin
        fstr = [fstr tab '''' lstInports{i} ''',' ...
            spaces(max_inputname_length - length(lstInports{i})) '''[<units>]'';' endl];
    end
    fstr = [fstr tab '};' endl];
    fstr = [fstr endl];
end

if(nout > 0)
    fstr = [fstr '% Define Unit Test Outputs:' endl];
    fstr = [fstr '% lstOutputs(:,1):  ''string''   Output Signal Name' endl];
    fstr = [fstr '% lstOutputs(:,2):  ''string''   Output Signal Units' endl];
    fstr = [fstr 'lstOutputs = { ...' endl];
    for i = 1:nout
        fstr = [fstr tab '''' lstOutports{i} ''', ' ...
            spaces(max_outputname_length - length(lstOutports{i})) '''[<units>]'';' endl];
    end
    fstr = [fstr tab '};' endl];
    fstr = [fstr endl];
end

fstr = [fstr '% Plot Options:' endl];
fstr = [fstr 'lw  = 1.5;  % LineWidth' endl];
fstr = [fstr 'ms  = 10;   % MarkerSize' endl];
fstr = [fstr 'pd  = 1;    % Plot Decimation (marker every n-th step)' endl];
fstr = [fstr 'fs1 = 12;   % FontSize for titles' endl];
fstr = [fstr 'fs2 = 10;   % FontSize for labels and legends' endl];
fstr = [fstr 'fl  = 0;    % ForceLegend (plotts option)' endl];
fstr = [fstr endl];
    
fstr = [fstr '%% Main Code' endl];
fstr = [fstr '%  Loop through each test to perform' endl];

% Write the for loop
fstr = [fstr 'for iExampleToRun = 1:length(arrExampleToRun)' endl];
fstr = [fstr tab 'curExampleToRun = arrExampleToRun(iExampleToRun);' endl];
fstr = [fstr endl];
fstr = [fstr tab 'switch(curExampleToRun)' endl];

for iExample = 1:nExamples
    strEx = num2str(iExample);
    fstr = [fstr tab2 'case ' strEx endl];
    fstr = [fstr tab3 '% Example #' strEx ':' endl];
    fstr = [fstr tab3 'Ex = ''Example ' strEx ''';' endl];
    fstr = [fstr tab3 'strFig   = ''<Enter Figure Title>'';' endl];
    fstr = [fstr tab3 'strTitle = ''<Enter Description for Plot Title>'';' endl];
    fstr = [fstr tab3 'strPPT   = ''<Enter Description for PowerPoint>'';' endl];
    fstr = [fstr endl];
    
    fstr = [fstr tab3 '% Declare Inputs:' endl];
    fstr = [fstr tab3 'timestep = 0.01;' tab  '% User specified timestep for the simulation ' endl];
    fstr = [fstr tab3 'numTimeSteps = 1;' tab3 '% Leave at one if you want a one' endl];
    fstr = [fstr tab3 tab tab tab3 '% time use (e.g. for a unit conversion).' endl];
    fstr = [fstr tab3 tab tab tab3 '% Set to (Sim Time total)/timestep' endl];
    fstr = [fstr tab3 tab tab tab3 '% simulations for a discrete, fixed' endl];
    fstr = [fstr tab3 tab tab tab3 '% step simulation.  Set the step size' endl];
    fstr = [fstr tab3 tab tab tab3 '% in configuration to timestep to run.' endl];
    
    for i = 1:(nin)
        curInArg = lstInports{i};
        fstr = [fstr tab3 curInArg spaces(max_inputname_length - length(curInArg)) ' = 0;' tab tab tab '% [<units>] <Description>' endl];
        fstr = [fstr tab3 '% ' curInArg spaces(max_inputname_length - length(curInArg))...
            ' = ones(numTimeSteps)' tab '% For specified ' curInArg ' through the simulation' endl];
    end
    
    %This will run only if an equivalent .m file can be found.
    %     if exist(block_name, 'file') == 2
    %         if(nout > 0)
    %             fstr = [fstr '['];
    %             for i = 1:nout
    %                 fstr = [fstr strOutputs{i} ];
    %                 if(i < nout)
    %                     fstr = [fstr ', '];
    %                 else
    %                     fstr = [fstr '] = '];
    %                 end
    %             end
    %         end
    
    %         fstr = [fstr block_name '('];
    %         for i = 1:(nin-iExample)
    %             fstr = [fstr strInputs{i} ];
    %             if(i < (nin-iExample))
    %                 fstr = [fstr ', '];
    %             end
    %         end
    %         fstr = [fstr ');' endl];
    %     end
    
    %% Setting the Simulation parameters.
    fstr = [fstr endl];
    fstr = [fstr tab3 '% Create the Simulation Inputs' endl];
    
    if(nin > 0)
        fstr = [fstr tab3 'matInputs = zeros(numTimeSteps, ' num2str(nin+2) ');' endl];
    end
    
    fstr = [fstr tab3 'curTime = -timestep;' endl];
    fstr = [fstr tab3 'arrTime = zeros(numTimeSteps, 1);' endl];
    fstr = [fstr tab3 'for i = 1:numTimeSteps' endl];
    fstr = [fstr tab3 tab 'curTime = curTime + timestep;' endl];
    fstr = [fstr tab3 tab 'arrTime(i)      = curTime;' endl];
    
    if(nin > 0)
        fstr = [fstr tab3 tab 'matInputs(i, 1) = curTime;' endl ];
        fstr = [fstr tab3 tab 'matInputs(i, 2) = 1;' tab '% (flgUseInput)' endl];
    end
    
    for i = 1:nin
    	curInArg = lstInports{i};
        fstr = [fstr tab3 tab 'matInputs(i, ' num2str(i+2) ') = ' curInArg ';' endl];
      	fstr = [fstr tab3 tab '% matInputs(i, ' num2str(i+2) ') = ' curInArg '(i);' endl];
  	end
    
    fstr = [fstr tab3 'end' endl];
    fstr = [fstr endl];
    fstr = [fstr tab3 'load_system(strUnitTest);' endl];
    if(nout > 0)
        fstr = [fstr tab3 '[~, ~, matOutputs] = sim(strUnitTest, max(arrTime)'];
    else
        fstr = [fstr tab3 'sim(strUnitTest, max(arrTime)'];
    end
    if(nin > 0)
        fstr = [fstr ', [], matInputs);' endl];
    else
         fstr = [fstr ');' endl];
    end
    fstr = [fstr endl];

    if(nout > 0)
        fstr = [fstr tab3 '% Parse the Data into MATLAB timeseries objects' endl];
        fstr = [fstr tab3 'for i = 1:size(lstOutputs, 1)' endl];
        fstr = [fstr tab4 'strOutName = lstOutputs{i, 1};' endl];
        fstr = [fstr tab4 'strOutUnits = lstOutputs{i, 2};' endl];
        fstr = [fstr tab4 'ts = timeseries(matOutputs(:,i), arrTime);' endl];
        fstr = [fstr tab4 'ts.Name = strOutName;' endl];
        fstr = [fstr tab4 'ts.DataInfo.Units = strOutUnits;' endl];
        fstr = [fstr tab4 'Results.(strOutName) = ts;' endl];
        fstr = [fstr tab3 'end' endl];
        
        fstr = [fstr endl];
        fstr = [fstr tab3 '% Display the Results' endl];
        
        fstr = [fstr tab3 'if(numTimeSteps == 1)' endl];
        fstr = [fstr tab3 tab '% Just one timestep exists, show in MATLAB Command Window' endl];
        
        fstr = [fstr tab4 'disp(Ex)' endl];
        fstr = [fstr tab4 'disp('''')' endl];
        
        if(nin > 0)
            fstr = [fstr tab4 'disp(''Inputs:'')' endl];
            
            for i = 1:nin
                curInArg = lstInports{i};
                fstr = [fstr tab4 'disp([''' curInArg ': '' num2str(' curInArg  ...
                    ') '' '' lstInputs{' num2str(i) ',2}]);' endl];
            end
            fstr = [fstr tab4 'disp('' '')' endl];
        end
        
        if(nout > 0)
            fstr = [fstr tab4 'disp(''Outputs:'')' endl];
            for i = 1:nout
                curOutArg = lstOutports{i};
                fstr = [fstr tab3 tab 'disp([''' curOutArg ': '' num2str(Results.' ...
                    curOutArg '.Data) '' '' Results.' curOutArg '.DataInfo.Units]);' endl];
            end
            fstr = [fstr tab4 'disp('' '')' endl];
        end
        
        fstr = [fstr tab3 'else' endl];
        
        fstr = [fstr endl];
        fstr = [fstr tab3 tab '% Plot the Data' endl];      
        fstr = [fstr tab3 tab 'figure(''Name'', strFig)' endl];      %#ok<AGROW>
        for i = 1:nout
            curOutArg = lstOutports{i};
            if(nout > 1)
                fstr = [fstr tab4 'subplot(' num2str(nout) ', 1, ' num2str(i) ');' endl];
            end
            
            fstr = [fstr tab4 'h = plotts(Results.' curOutArg ', ...' endl];
            fstr = [fstr tab4 tab '''Decimation'', pd, ''LineWidth'', lw, ...' endl];
            fstr = [fstr tab4 tab '''MarkerSize'', ms, ''FontSize'', fs2, ...' endl];
            fstr = [fstr tab4 tab '''ForceLegend'', fl);' endl];
            
            if(i == 1)
                fstr = [fstr tab4 'title(strTitle, ''FontWeight'', ''bold'', ''FontSize'', fs1);' endl];
            end
            fstr = [fstr endl];
        end
                
        fstr = [fstr tab3 'end % << End of if(numTimeSteps == 1) >>' endl endl];
        
        %If the save to PPT flag is up
        fstr = [fstr tab3 'if(flgSaveToPPT)' endl];
        fstr = [fstr tab4 'SaveOpenFigures2PPT(pptFilename, strPPT, 1);' endl];
        fstr = [fstr tab3 'end' endl];
    end
    
        fstr = [fstr endl];
        fstr = [fstr tab 'end  % << End of ''switch(curExampleToRun)'' >>' endl];
        
        fstr = [fstr 'end  % << End of ''for iExample'' >>' endl];
        fstr = [fstr endl];
end

fstr = [fstr '%% << End of ' driver_fname ' >>' endl endl];

%% Revision section
fstr = [fstr '%% REVISION HISTORY' endl ...
    ... '% ONLY REQUIRED FOR FILES NOT UNDER REVISION CONTROL'... %skip this line
    '% YYMMDD INI: note' endl ...
    '% <YYMMDD> <INI>: <Revision update note>' endl ...
    '% ' datestr(now,'YYmmdd') ' CDS: Driver script created using ' mfnam endl ...
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

% Footer Proprietary Lines
if ~isempty(CNF_info.Proprietary)
    fstr = [fstr '% ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

% Footer ITAR Lines
if ~isempty(CNF_info.ITAR)
    fstr = [fstr '% ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

% Footer Classified Lines
if ~isempty(CNF_info.Classification)
    fstr = [fstr '% ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% write output file
cur_folder = fileparts(which(block_testmodel));
driver_full = [cur_folder filesep driver_fname '.m'];

flgCopyMade = 0;

if(exist(driver_full,'file') > 0) % an mfile
    cur_filename = which(driver_fname);
    if(~isempty(cur_filename))
        cur_folder = fileparts(cur_filename);
    else
        [cur_folder, filename] = fileparts(driver_full);
    end
    
    if(prompt_to_overwrite)
        disp([mfnam '>> WARNING: ''' driver_fname '.m'' already exists here:' cur_folder]);
        R = input([mfspc '           Do you want to Overwrite this file? {Y,[N]}'],'s');
        R = upper(R);
        if isempty(R)
            R = 'N';
        end
    else
        R = prompt_to_overwrite_val;
    end
    
    if strcmpi(R(1), 'Y')
        if(prompt_to_save_old)
            R2 = input([mfspc '           Do you want to save an old copy of the current file? {[Y],N}'],'s');
            R2 = upper(R2);
            if isempty(R2)
                R2 = 'Y';
            end
        else
            R2 = prompt_to_save_old_val;
        end
        
        if strcmpi(upper(R2(1)),'Y')
            cur_filename = [cur_folder filesep driver_fname '.m'];
            old_filename = [cur_folder filesep driver_fname '_old.m'];
            copyfile(cur_filename, old_filename, 'f');
            new_folder = cur_folder;
            flgCopyMade = 1;
        end
    else
        if(~strcmp(pwd, cur_folder))
            R2 = input([mfnam '>> Do you want to Create the Driver in the current folder? {Y,[N]}'],'s');
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

if strcmpi(R(1),'Y');
    [fid, message ] = fopen([cur_folder filesep driver_fname '.m'],'wt','native');
    info.fname = [driver_fname '.m'];
    info.fname_full = [cur_folder filesep driver_fname '.m'];
    info.text = fstr;
    
    if fid == -1
        info.error = [mfnam '>> ERROR: File Not created: ' message];
        disp(info.error)
        fl = -1;
        return
    else
        fprintf(fid,'%s',fstr);
        fclose(fid);
        if(open_file_after_build)
            edit(info.fname_full);
        end
        disp([mfnam '>> Successfully created ' driver_fname '.mdl']);
        fl = 0;
        info.OK = 'maybe it worked';
        
        if(flgCopyMade)
            if(open_file_after_build)
                edit(old_filename);
            end
        end
    end
else
    disp([mfnam '>> CAUTION: Function Not Created']);
    disp([mfspc '>> File exists and User selected "Do Not Overwrite"']);
end

end

%% << End of CreateBlock_DriverScript.m >>
%% REVISION HISTORY
% YYMMDD INI: note
% 110524 JPG: Added some fixes per Mikes suggestions.  Fixed the issue
%              caused when trying to generate a driver for a simulink block
%              with no Inports/Outports.
% 101123 JPG: Added a legend to the file, and a load_system in case the
%              Simulink file wasn't open.
% 101116 JPG: Made some modification to the file system to accomodate the
%             newer DriverScript file format.  Ideally, should be able to
%             run this in the verification folder to generate the driver.
% 101102  JJ: Created and ran on the SimulinkBlockVerification.
% 101102 CDS: Driver script created using CreateBlock_DriverScript
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName         : Email                             :   NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com               :   sufanmi
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   :   G67086
% JPG: James Gray       : James.Gray2@ngc.com               :   g61720

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
