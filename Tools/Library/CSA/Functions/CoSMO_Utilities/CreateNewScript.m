% CREATENEWSCRIPT Creates a new, formatted driver script to test a function
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateNewScript:
%   Creates a new formated script
% 
% ************************************************************************
% * #NOTE: To Future CoSMO'r. The following warning occured using CNF
% * CreateNewFunc>>WARNING: Selected Ouput argument name: "info" is a
% * function name!
% * -JPG
% ************************************************************************
% SYNTAX:
%	[fl, info] = CreateNewScript(varargin, 'PropertyName', PropertyValue)
%	[fl, info] = CreateNewScript(varargin)
%
% INPUTS: 
%	Name    	Size		Units		Description
%   fname                   [string]    N/A     Name of reference function
%                                                Default: 'foo'
%   function_description    [string]    N/A     Short explanation of what
%                                                reference function does
%                                                Default: ''
%    varargin               N/A         N/A     Coupled Inputs with additional
%                                               text properties that can be
%                                               specified in any order
%   location                [string]    N/A     Full path to where file
%                                                should be created
%                                                Default: pwd
%       Property Name           Property Values
%       'prompt_to_overwrite'       [bool]      When creating driver file,
%                                                if file of same name
%                                                exists, ask user if
%                                                overwrite is desired?
%                                                Default: true
%       'prompt_to_overwrite_val'   [string]    If 'prompt_to_overwrite' is
%                                                false, should file be
%                                                overwritted? ('Y', 'N')
%                                                Default: 'Y'
%       'prompt_to_save_old'       [bool]      When overwritting file,
%                                                ask user if saving off
%                                                copy of original file si
%                                                desired?
%                                                Default: true
%       'prompt_to_save_old_val'   [string]    If 'prompt_to_save_old' is
%                                                false, should copy by made
%                                                first? ('Y', 'N')
%                                                Default: 'N'
%       'open_file_after_build'    [bool]      Once file has been created,
%                                               should it be loaded into
%                                               the editor?
%                                               Default: true
%       'Markings'         [char OR Struct]    Defines format to use for the
%                                                function's Header/Footer
%                                                Default: 'Default'
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%   fl          [1]         ["bool"]    Driver Function built successfully?
%   info        {struct}    [N/A]       Information on how function ran%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%   % Create a fuction 'foo' with 2 input argument and 2 output arguments
%   % Then create a test driver script for the function
%	CreateNewFunc('foo',2,2);
%   [status,info] = CreateNewScript('foo')
%
%   % Create a driver for the function 'foo', fully overwritting file if it
%   % exists, and not saving off a copy first
%   CreateNewScript('foo','prompt_to_overwrite',0,'prompt_to_save_old',0,'prompt_to_save_old_val','N')
%
%	% <Enter Description of Example #1>
%	[fl, info] = CreateNewScript(varargin)
%	% <Copy expected outputs from Command Window>
%
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CreateNewScript.m">CreateNewScript.m</a>
%	  Driver script: <a href="matlab:edit Driver_CreateNewScript.m">Driver_CreateNewScript.m</a>
%	  Documentation: <a href="matlab:pptOpen('CreateNewScript_Function_Documentation.pptx');">CreateNewScript_Function_Documentation.pptx</a>
%
% See also format_varargin 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/638
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoSMO_Utilities/CreateNewScript.m $
% $Rev: 3244 $
% $Date: 2014-09-04 12:03:37 -0500 (Thu, 04 Sep 2014) $
% $Author: sufanmi $

function [fl, info] = CreateNewScript(fname, varargin)

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
fl= '';
info= [];

%% Input Argument Conditioning
[prompt_to_overwrite, varargin]         = format_varargin('prompt_to_overwrite',        true,       2, varargin);
[prompt_to_overwrite_val, varargin]     = format_varargin('prompt_to_overwrite_val',    'Y',        2, varargin);
[prompt_to_save_old, varargin]          = format_varargin('prompt_to_save_old',         true,       2, varargin);
[prompt_to_save_old_val, varargin]      = format_varargin('prompt_to_save_old_val',     'N',        2, varargin);
[prompt_to_include_old, varargin]       = format_varargin('prompt_to_include_old',      true,       2, varargin);
[prompt_to_include_old_val, varargin]   = format_varargin('prompt_to_include_old_val',  'Y',        2, varargin);
[open_file_after_build, varargin]       = format_varargin('open_file_after_build',      true,       2, varargin);
[CNF_info, varargin]                    = format_varargin('Markings',                   'Default',  2, varargin);
[IncludeITAR, varargin]                 = format_varargin('IncludeITAR',                true,       2, varargin);
[SVN, varargin]                         = format_varargin('SVN',                        true,       2, varargin);
[Hyperlinks, varargin]                  = format_varargin('Hyperlinks',                 true,       2, varargin);
[location, varargin]                    = format_varargin('SaveFolder',                 '',         2, varargin);
[function_description, varargin]        = format_varargin('Description',                '',         2, varargin);
[IncludeRevHistory, varargin]           = format_varargin('IncludeRevHistory',          false,      2, varargin);
[IncludeID, varargin]                   = format_varargin('IncludeID',                  false,      2, varargin);

if(isempty(function_description))
    function_description= '<Enter function description here>';
end

if(isempty(CNF_info))
    CNF_info = 'Default';
end

%% Pre-processing:
% Test Input 1 fname;  arg type
if ~ischar(fname);
    errorstr = 'fname (input 1) must be of type "char" ! ';
    disp([mfnam '>>ERROR: ' errorstr]);
    error(errorstr);
end

flgDriver = isfunction(fname);
if(~isempty(strfind(fname, filesep)))
    [curDir, curFile, curExt] = fileparts(fname);
    fname = curFile;
    location = curDir;
end

if(flgDriver)
    fnamedriver=['Driver_' fname];
else
    fnamedriver = fname;
end
    
if(isempty(location))
    fullfname = fnamedriver;
    cur_folder = pwd;
else
    fullfname = [location filesep fnamedriver '.m'];
    cur_folder = location;
end
flgCopyMade = 0;

include_old = false;

if exist(fullfname,'file') == 2 % an mfile
    cur_filename = which(fullfname);
    if(~isempty(cur_filename))
        cur_folder = fileparts(cur_filename);
    else
        [cur_folder, cur_filename] = fileparts(fullfname);
    end

    %%
    if(prompt_to_overwrite)
        disp([mfnam '>> WARNING: ''' fnamedriver '.m'' already exists here:' cur_folder]);
        R = input([mfspc '           Do you want to Overwrite this file? {Y,[N]}'],'s');
        R = upper(R);
        if isempty(R)
            R = 'N';
        end
    else
        R = prompt_to_overwrite_val;
    end
    overwrite_file = strcmpi(R(1), 'Y');
    
    %%
    if(overwrite_file)
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
            old_filename = [cur_folder filesep fnamedriver '_old.m'];
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
    
    
    %%
    if(prompt_to_include_old)
        R3 = input([mfspc '           Do you want to copy the contents of the current file into the new one? {[Y],N}'],'s');
        R3 = upper(R3);
        if isempty(R3)
            R3 = 'Y';
        end
    else
        R3 = prompt_to_include_old_val;
    end
    include_old = strcmpi(upper(R3(1)),'Y');
    
else
    R = 'Y';
end
write_file = strcmpi(upper(R(1)),'Y');

%% Main Function:
% CNF_info Testing andworkout
CNF_info_Def = CreateNewFile_Defaults(1, mfnam, 'IncludeITAR', IncludeITAR);
if ischar(CNF_info)
    switch CNF_info
        case 'Default'
            CNF_info = CNF_info_Def; %local call to get default values
        case 'Search'
            CNF_info = 'CreateNewFunc_info';
        otherwise
            % assume it is a mat file name and with one variable in it.
            % so that the fieldnames returns one value.
%             Temp  = load(CNF_info); %only option for now
%             CNF_info = Temp.(char(fieldnames(Temp)));
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

warnstate = warning('QUERY','catstruct:DupFieldnames');
warning('OFF','catstruct:DupFieldnames');
CNF_info = catstruct(CNF_info_Def,CNF_info); %use default values -> over right with values from input
warning(warnstate.state,'catstruct:DupFieldnames');
%% Header Classified Lines
% write to temp header variable
head = ''; %initialize headfootCNF_info.CenterChar
if ~isempty(CNF_info.Classification)
    head = [head '% ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Header ITAR Lines
if ~isempty(CNF_info.ITAR)
    head = [head '% ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Header Proprietary Lines
if ~isempty(CNF_info.Proprietary)
    head = [head '% ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

fstr = head;

%% Interogate Function to Get Input and Output names
if(flgDriver)
    [InArgList, OutArgList] = findArgs(fname);
    nin = size(InArgList, 1);
    nout = size(OutArgList, 1);
    
    if(nin == 1)
        if(isempty(InArgList{1}))
            nin = 0;
        end
    end
    
    if(nout == 1)
        if(isempty(OutArgList{1}))
            nout = 0;
        end
    end
    
    % Title Section:
    fstr = [fstr '% ' fnamedriver '.m' tab endl];
    fstr = [fstr '%' tab 'This is the main test driver script for the ' fname ' function.' endl];
    fstr = [fstr '%' endl];
    fstr = [fstr '%' spc fname ':' tab function_description endl];
    fstr = [fstr '%' endl];
    
    if(Hyperlinks)
        % Test Driver Hyperlink
        fstr = [fstr '% Hyperlinks:' endl];
        fstr = [fstr '%' tab 'Source function: ' '<a href="matlab:edit ' fname '.m">' fname '.m</a>' endl];
        fstr = [fstr '%' tab '  Driver script: ' '<a href="matlab:edit ' fnamedriver '.m">' fnamedriver '.m</a>' endl];
        fstr = [fstr '%' tab 'Documentation: ' '<a href="matlab:winopen(which(''' fname '_Block_Documentation.pptx''));">' fname '_Block_Documentation.pptx</a>' endl];
    end
% elseif( (exist(fname) == 3) )
%     % This part not completely filled out
%     InArgList = {'In1'; 'In2'};
%     OutArgList = {'Out1'};
%     nin = size(InArgList, 1);
%     nout = size(OutArgList, 1);
%     
%     flgDriver = 1;
%     
%     % Title Section:
%     fnamedriver=['Driver_' fname];
%     
%     fstr = [fstr '% ' fnamedriver '.m' tab endl];
%     fstr = [fstr '%' tab 'This is the main test driver script for the ' fname ' function.' endl];
%     fstr = [fstr '%' endl];
%     fstr = [fstr '%' spc fname ':' tab function_description endl];
%     fstr = [fstr '%' endl];
%     
%     if(Hyperlinks)
%         % Test Driver Hyperlink
%         fstr = [fstr '% Hyperlinks:' endl];
%         ccode_fname = fname(3:end); % strip off the 'c_' prefix
%         fstr = [fstr '%' tab 'Source code: ' '<a href="matlab:edit ' ccode_fname '.m">' ccode_fname '.c</a>' endl];
%         fstr = [fstr '%' tab '  Driver script: ' '<a href="matlab:edit ' fnamedriver '.m">' fnamedriver '.m</a>' endl];
%         fstr = [fstr '%' tab 'Documentation: ' '<a href="matlab:winopen(which(''' fname '_Block_Documentation.pptx''));">' fname '_Block_Documentation.pptx</a>' endl];
%     end
else
    fstr = [fstr '% ' fnamedriver '.m' endl];
    fstr = [fstr '%' tab '< Insert Documentation >' endl];
    
end

% Copyright
if(isfield(CNF_info, 'Copyright'))
    if(~isempty(CNF_info.Copyright))
        fstr = [fstr '%' endl];
        fstr = [fstr CNF_info.Copyright endl];
    end
end

fstr = [fstr endl];

%% SVN Keywords
if(SVN)
fstr = [fstr '% Subversion Revision Information At Last Commit' endl ...
    '% $URL: ' '$' endl ...
    '% $Rev: ' '$' endl ...
    '% $Date: ' '$' endl ...
    '% $Author: ' '$' endl ...
    endl]; %Blank Line
end

%% Create Example Section
if(~flgDriver)
    fstr = [fstr '%% Main Code' endl];
    
    if(include_old)
        filedata = matlab.desktop.editor.openDocument(fullfname);
        fstr = [fstr filedata.Text endl];
    else
        fstr = [fstr '% <Insert Main Code>' endl endl];
    end
    fstr = [fstr '%% << End of Script >>' endl endl];
else
    
    if(nin > 0)
        if( (exist(fname) == 3) )
            nExamples = 1;
        else
        nExamples = 2;
        end
    else
        nExamples = 1;
    end
    
    for iExample = 0:(nExamples-1);
        fstr = [fstr '%% Example ' num2str(iExample+1) ':' endl];
        fstr = [fstr '%  <Insert Example Description>' endl];
        if(iExample == 0)
            fstr = [fstr '%  <Note that this example uses ALL the inputs>' endl];
        else
            fstr = [fstr '%  <Note that this example shows an overloaded case' endl];
            fstr = [fstr '%   (e.g. Assume that ''' InArgList{nin} '''s'' default values will be used>' endl];
        end
        
        fstr = [fstr '% Declare Inputs:' endl];
        max_inputname_length = size(char(InArgList), 2);
        for i = 1:(nin-iExample)
            curInArg = InArgList{i};
            fstr = [fstr curInArg spaces(max_inputname_length - length(curInArg)) ' = 0;' tab tab tab '% [<units>] <Description>' endl];
        end
        
        if(nout > 0)
            fstr = [fstr '['];
            for i = 1:nout
                fstr = [fstr OutArgList{i} ];
                if(i < nout)
                    fstr = [fstr ', '];
                else
                    fstr = [fstr '] = '];
                end
            end
        end
        
        fstr = [fstr fname '('];
        for i = 1:(nin-iExample)
            fstr = [fstr InArgList{i} ];
            if(i < (nin-iExample))
                fstr = [fstr ', '];
            end
        end
        
        fstr = [fstr ');' endl];
        
        fstr = [fstr endl];
        fstr = [fstr '% Display the Results' endl];
        if(nout > 1)
            for i = 1:nout
                fstr = [fstr 'disp([''' OutArgList{i} ': '' num2str(' OutArgList{i} ') '' [<units>]'']);' endl];
            end
        end
        
        fstr = [fstr endl];
    end
    
    fstr = [fstr '%% << End of Script >>' endl endl];
end

%% Revision section
if(IncludeRevHistory)
    fstr = [fstr '%% REVISION HISTORY' endl ...
        ... '% ONLY REQUIRED FOR FILES NOT UNDER REVISION CONTROL'... %skip this line
        '% YYMMDD INI: note' endl ...
        '% <YYMMDD> <initials>: <Revision update note>' endl ...
        '% ' datestr(now,'YYmmdd') ' <INI>: Created function using ' mfnam endl ...
        '%**Add New Revision notes to TOP of list**' endl ...
        endl];
end

%% Author Identification
if(IncludeID)
    fstr = [fstr '%% AUTHOR IDENTIFICATION ' endl ...
        '% INI: FullName            : Email     : NGGN Username ' endl ...
        '% <initials>: <Fullname>   : <email>   : <NGGN username> ' endl ...
        endl];
end

%% Footer
% Order is reversed from header
% DistributionStatement,ITARparagraph Proprietary ITAR, Classification
    fstr = [fstr '%% DISTRIBUTION:' endl];
    % Distribution Statement
    if ~isempty(CNF_info.Distribution)
        fstr = [fstr endl CNF_info.Distribution endl];
        fstr = [fstr '%' endl];
    end

% Itar Paragraph
if ~isempty(CNF_info.ITAR_Paragraph)
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
if(write_file)
    full_filename = [cur_folder filesep fnamedriver '.m'];
    [fid, message ] = fopen(full_filename, 'wt','native');
    info.fname = [fnamedriver '.m'];
    info.fname_full = full_filename;
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
%             edit(full_filename);
            matlab.desktop.editor.openDocument(full_filename);
        end
        disp([mfnam '>> Successfully created ' fnamedriver '.m']);
        fl = 0;
        info.OK = 'maybe it worked';
        
        if(flgCopyMade)
            if(open_file_after_build)
                cmdstr = ['edit ' fnamedriver '_old.m']; evalin('base',cmdstr);
            end
        end
    end
else
    disp([mfnam '>> CAUTION: Function Not Created']);
    disp([mfspc '>> File exists and User selected "Do Not Overwrite"']);
end

end % << End of function CreateNewScript >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101102 JPG: Copied over information from the old function.
% 101102 CNF: Function template created using CreateNewFunc
% 101013 MWS: Created function based on the CreateNewFunc script.
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName             : Email                 : NGGN Username
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi
% TKV: Travis Vetter        : travis.vetter@ngc.com : vettetr

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
