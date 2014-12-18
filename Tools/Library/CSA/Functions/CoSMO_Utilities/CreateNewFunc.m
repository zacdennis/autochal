% CREATENEWFUNC Creates a new, properly formatted function
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateNewFunc:
%   Creates a new formated function and all relevent headers/footers
%   using the argument names from the cell array of strings OutArgList
%   and InArgList.  If just number is used then 'In<#>|Out<#>'
%   is used as a placeholder.
%
% SYNTAX:
%	[fl, info] = CreateNewFunc(fname, OutArgList, InArgList, varargin, 'PropertyName', PropertyValue)
%	[fl, info] = CreateNewFunc(fname, OutArgList, InArgList, varargin)
%	[fl, info] = CreateNewFunc(fname, OutArgList, InArgList)
%	[fl, info] = CreateNewFunc(fname, OutArgList)
%
% INPUTS:
%	Name      	Size            Units		Description
%   fname       [string]        [N/A]       Name of function to create
%   OutArgList  [cell array of char OR #]   Defined names of output
%                                            arguments OR number of outputs
%   InArgList   [cell array of char OR #]   Defined names of input
%                                            arguments OR number of inputs
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS:
%	Name      	Size		Units		Description
%	fl  	        <size>		<units>		<Description>
%	info	      <size>		<units>		<Description>
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName            PropertyValue	Default		Description
%	prompt_to_overwrite     [bool]          true        If function already
%                                                       exists, prompt user to
%                                                       overwrite if desired?
%   prompt_to_overwrite_val 'string'        'Y'         If prompt not allowed,
%                                                       should file be overwritten?
%   prompt_to_use_io        [bool]          true        If function already exists
%                                                       and is being overwritten,
%                                                       should the current function's
%                                                       inputs and outputs be used
%                                                       in the new function?
%   prompt_to_use_val       'string'        'Y'         If not prompted, should function
%                                                       use the I/O?
%   prompt_to_save_old      [bool]          true        If the file is being overwritten,
%                                                       should the user be prompted
%                                                       to save off a copy of the
%                                                       old file?
%   prompt_to_save_old_val  'string'        'N'         If not prompted, save off
%                                                       a copy of the old file?
%   open_file_after_build   [bool]          true        Open the function and the old
%                                                       function (if craeted) after
%                                                       the build?
%   IncludeVarargin         [bool]          true        If the function will have
%                                                       inputs, add 'varargin'
%                                                       to the end?
%   Markings                'string'        'Default'   Defines format to use for the
%                                                       function's Header/Footer
%   Location                'string'        pwd         Folder in which to
%                                                       create new function
%   SVN                     [bool]          true        Include SVN keytags
%
% EXAMPLES:
%   % Create fuction 'foo' with 1 input argument and 3 output arguments
%	[status,info] = CreateNewFunc('foo',3,1)
%
%   % Create function 'foo2' with 2 input arguments, 'argin1' and 'argin2'
%   %  and 1 output argument 'OutArg'
%   [status,info] = CreateNewFunc('foo2','OutArg',{'argin1','argin2'});
%
%	% <Enter Description of Example #1>
%	[fl, info] = CreateNewFunc(fname, OutArgList, InArgList, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[fl, info] = CreateNewFunc(fname, OutArgList, InArgList)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CreateNewFunc.m">CreateNewFunc.m</a>
%	  Driver script: <a href="matlab:edit Driver_CreateNewFunc.m">Driver_CreateNewFunc.m</a>
%	  Documentation: <a href="matlab:winopen(which('CreateNewFunc_Function_Documentation.pptx'));">CreateNewFunc_Function_Documentation.pptx</a>
%
% See also format_varargin
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/637
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoSMO_Utilities/CreateNewFunc.m $
% $Rev: 3244 $
% $Date: 2014-09-04 12:03:37 -0500 (Thu, 04 Sep 2014) $
% $Author: sufanmi $

function [fl, info] = CreateNewFunc(fname, OutArgList, InArgList, varargin)

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
fl= -1;
info= [];

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[prompt_to_overwrite, varargin]         = format_varargin('prompt_to_overwrite',        true,       2, varargin);
[prompt_to_overwrite_val, varargin]     = format_varargin('prompt_to_overwrite_val',    'Y',        2, varargin);
[prompt_to_use_io, varargin]            = format_varargin('prompt_to_use_io',           true,       2, varargin);
[prompt_to_use_io_val, varargin]        = format_varargin('prompt_to_use_val',          'Y',        2, varargin);
[prompt_to_save_old, varargin]          = format_varargin('prompt_to_save_old',         true,       2, varargin);
[prompt_to_save_old_val, varargin]      = format_varargin('prompt_to_save_old_val',     'N',        2, varargin);
[prompt_to_include_old, varargin]       = format_varargin('prompt_to_include_old',      true,       2, varargin);
[prompt_to_include_old_val, varargin]   = format_varargin('prompt_to_include_old_val',  'Y',        2, varargin);
[open_file_after_build, varargin]       = format_varargin('open_file_after_build',      true,       2, varargin);
[IncludeVarargin, varargin]             = format_varargin('IncludeVarargin',            true,       2, varargin);
[IncludeITAR, varargin]                 = format_varargin('IncludeITAR',                true,       2, varargin);
[location, varargin]                    = format_varargin('Location',                   '',         2, varargin);
[CNF_info, varargin]                    = format_varargin('Markings',                   'Default',  2, varargin);
[SVN, varargin]                         = format_varargin('SVN',                        true,       2, varargin);
[Hyperlinks, varargin]                  = format_varargin('Hyperlinks',                 true,       2, varargin);
[SourceDoc, varargin]                   = format_varargin('SourceDoc',                  true,       2, varargin);
[IncludeRevHistory, varargin]           = format_varargin('IncludeRevHistory',          false,      2, varargin);
[IncludeID, varargin]                   = format_varargin('IncludeID',                  false,      2, varargin);
[IncludeVerification, varargin]         = format_varargin('IncludeVerification',        true,      2, varargin);
[IncludeCopyright, varargin]            = format_varargin('IncludeCopyright',           true,      2, varargin);
[IncludeMaintenance, varargin]          = format_varargin('IncludeMaintenance',         true,      2, varargin);

switch nargin
    case 0
        InArgList = ''; OutArgList = ''; fname = 'newfunc';
    case 1
        InArgList = ''; OutArgList = '';
    case 2
        InArgList = '';
end

% Test Input 1 fname;  arg type
if ~ischar(fname);
    errorstr = 'fname (input 1) must be of type "char" ! ';
    disp([mfnam '>>ERROR: ' errorstr]);
    error(errorstr);
end
%% Main Function:
%% write output file
if(~isempty(strfind(fname, filesep)))
    [curDir, curFile, curExt] = fileparts(fname);
    fname = curFile;
    location = curDir;
end

if(isempty(location))
    fullfname = fname;
    cur_folder = pwd;
else
    fullfname = [location filesep fname];
    cur_folder = location;
end
flgCopyMade = 0;
include_old = false;

if exist(fullfname,'file') == 2 % an mfile
    cur_filename = which(fullfname);
    cur_folder = fileparts(cur_filename);
    
    if(prompt_to_overwrite)
        
        disp([mfnam '>> WARNING: ''' fname '.m'' already exists here: ' cur_folder]);
        R = input([mfnam '>> Do you want to Overwrite this file? {Y,[N]}'],'s');
        R = upper(R);
        if isempty(R)
            R = 'N';
        end
    else
        R = prompt_to_overwrite_val;
    end
    
    if((isempty(InArgList)) && (isempty(OutArgList)))
        
        if(prompt_to_use_io)
            R3 = input([mfnam '>> Do you want to Use the Inputs and Outputs from this function? {[Y],N}'],'s');
            R3 = upper(R3);
            if isempty(R3)
                R3 = 'Y';
            end
        else
            R3 = prompt_to_use_io_val;
        end
        
        if strcmpi(R3(1), 'Y')
            [InArgList, OutArgList, refLines] = findArgs(fname);
            IncludeVarargin = any(strcmp(InArgList, 'varargin'));
        end
        
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
            old_filename = [cur_folder filesep fname '_old.m'];
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

if(isempty(OutArgList))
    OutArgList = 1;
end

if(isempty(InArgList))
%     InArgList = {'In1'; 'varargin'};    % Debug
end

if strcmpi(R(1),'Y');

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
    % Input 3 InArgList check for existence and format
    if isempty(InArgList)
        nin = 0;
        InArgList = {};
    elseif iscell(InArgList)
        %are all element character strings
        if any(~cellfun('isclass',InArgList,'char'));
            errorstr = 'OutArgList (input 2) All elements must be of type "char" ! ';
            disp([mfnam '>>ERROR: ' errorstr]);
            error(errorstr);
        end
        nin = length(InArgList);
    elseif isnumeric(InArgList) % OutputArgument Names Not given, Generat list
        nin = InArgList;
        InArgList = cell(nout,1); % allocate empty cell
        for i = 1:nin
            InArgList{i} = ['In' num2str(i)];
        end
    elseif ischar(InArgList) % Very special case of one named argument
        nin = 1; InArgList = {InArgList};
    end
    
    if(IncludeVarargin)
        % Only add varargin if it's not already explicitly stated
        if( ~any(strcmp(InArgList, 'varargin')) )
            nin = nin + 1;
            if(size(InArgList, 1) >= size(InArgList, 2))
                InArgList(nin,:) = { 'varargin' }; %#ok<AGROW>
            else
                InArgList(:,nin) = { 'varargin' }; %#ok<AGROW>
            end
        end
    end
    
    %% Load in Markings for New Script
    CNF_info_Def = CreateNewFile_Defaults(1, mfnam, 'IncludeITAR', IncludeITAR);
    if ischar(CNF_info)
        switch CNF_info
            case 'Default'
                CNF_info = CNF_info_Def; %local call to get default values
            case 'Search'
                CNF_info = 'CreateNewFunc_info';
            otherwise
                % assume it is a mat file name and with one variable in it.
                % so tha fieldnames returns one value.
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
    
    %% H1 Help Line
    fstr = ['% ' upper(fname) ' <one line description>' endl];
    
    %% Header Classified Lines
    if(isfield(CNF_info, 'Classification'))
        if ~isempty(CNF_info.Classification)
            fstr = [fstr '% ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
        end
    end
    
    %% Header ITAR Lines
    if(isfield(CNF_info, 'ITAR'))
        if ~isempty(CNF_info.ITAR)
            fstr = [fstr '% ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
        end
    end
    
    %% Header Proprietary Lines
    if(isfield(CNF_info, 'Proprietary'))
        if ~isempty(CNF_info.Proprietary)
            fstr = [fstr '% ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
        end
    end
    
    %% HELP Filename line and help
    fstr = [fstr '% ' fname ':' endl...
        '%     <Function Description> ' endl ...
        '% ' endl];
    
    maxLength = 0;
    for i = 1:nin
        maxLength = max(maxLength, length(InArgList{i}));
    end
    for i = 1:nout
        maxLength = max(maxLength, length(OutArgList{i}));
    end
    
    %%  Help - Argument Explanations - Example - See Also - Function
    % input help section
    arginstr = ['% INPUTS: ' endl];
    arginstr = [arginstr '%' tab 'Name' spaces(maxLength - length('Size')) tab 'Size' tab tab 'Units' tab tab 'Description' endl];
    FuncInstr = '';
    flgVararginSection = 0;
    if nin == 0;
        arginstr = [arginstr '%' tab 'None' endl];
    else
        for i = 1:nin
            if iskeyword(InArgList{i}) %Check for Keyword Use in arg list
                errorstr=['Selected Input argument name: "' InArgList{i} '" is a MATLAB Keyword!'];
                error(errorstr);
            elseif ~isempty(which(InArgList{i})) %warn if name is a function
                if(~strcmp(InArgList{i}, 'varargin'))
                    warnstr = ['Selected Input argument name: "' InArgList{i} '" is a function name!'];
                    disp([mfnam '>>WARNING: ' warnstr]);
                end
            end
            
            arginstr = [arginstr '%' tab InArgList{i}]; %#ok<AGROW>
            if(length(InArgList{i})<4)
                numSpaces = 4 - length(InArgList{i});
                for iSpace = 1:numSpaces
                    arginstr = [arginstr spc]; %#ok<AGROW>
                end
            end
            
            if(strcmp(InArgList{i}, 'varargin'))
                arginstr = [arginstr tab '[N/A]' tab tab '[varies]' tab 'Optional function inputs that' endl]; %#ok<AGROW>
                arginstr = [arginstr '%' tab '     ' tab tab '        ' tab tab tab tab ' should be entered in pairs.' endl]; %#ok<AGROW>
                arginstr = [arginstr '%' tab '     ' tab tab '        ' tab tab tab tab ' See the ''VARARGIN'' section' endl]; %#ok<AGROW>
                arginstr = [arginstr '%' tab '     ' tab tab '        ' tab tab tab tab ' below for more details' endl]; %#ok<AGROW>
                flgVararginSection = 1;
            else
                arginstr = [arginstr tab spaces(maxLength - length(InArgList{i})) '<size>' tab tab '<units>' tab tab '<Description>' endl]; %#ok<AGROW>
            end
            
            
            if(i == 1)
                FuncInstr = InArgList{i};
            else
                FuncInstr = [FuncInstr ', ' InArgList{i}]; %#ok<AGROW>
            end
        end
        
        if( (nin > 1) && (~strcmp(InArgList{i}, 'varargin')) )
            arginstr = [arginstr '%' tab tab tab tab tab tab tab tab tab tab spc  'Default: <Enter Default Value>' endl];
        end
    end
    arginstr = [arginstr '%' endl];
    
    % Ouput side
    argoutstr = ['% OUTPUTS: ' endl];
    argoutstr = [argoutstr '%' tab 'Name' spaces(maxLength - length('Size')) tab 'Size' tab tab 'Units' tab tab 'Description' endl];
    FuncOutstr = '';
    if nout == 0;
        argoutstr = [argoutstr '%' tab 'None' endl];
    else
        for i = 1:nout
            if iskeyword(OutArgList{i}) %Check for Keyword Use in arg list
                errorstr=['Selected Output argument name: "' OutArgList{i} '" is a MATLAB Keyword!'];
                error(errorstr);
            elseif ~isempty(which(OutArgList{i})) %warn if name is a function
                warnstr = ['Selected Ouput argument name: "' OutArgList{i} '" is a function name!'];
                disp([mfnam '>>WARNING: ' warnstr]);
            end
            
            argoutstr = [argoutstr '%' tab OutArgList{i}];  %#ok<AGROW>
            if(length(OutArgList{i})<4)
                numSpaces = 4 - length(OutArgList{i});
                for iSpace = 1:numSpaces
                    argoutstr = [argoutstr spc]; %#ok<AGROW>
                end
            end
            argoutstr = [argoutstr tab spaces(maxLength - length(OutArgList{i})) '<size>' tab tab '<units>' tab tab '<Description> ' endl]; %#ok<AGROW>
            
            if(i == 1)
                FuncOutstr = OutArgList{i};
            else
                FuncOutstr = [FuncOutstr ', ' OutArgList{i}]; %#ok<AGROW>
            end
        end
    end
    argoutstr = [argoutstr '%' endl];
    
    %% Syntax
    %%Write Syntax Section
    fstr=[ fstr '% SYNTAX:' endl];
    
    if(flgVararginSection)
        fstr = [fstr '%' tab '[' FuncOutstr '] = ' fname '(' FuncInstr ', ''PropertyName'', PropertyValue)' endl];
    end
    
    syntax1 = [ '%' tab '[' FuncOutstr '] = ' fname ...
        '(' FuncInstr ')'];
    fstr = [fstr syntax1 endl];
    
    if(nin > 1)
        ptrComma = strfind(syntax1, ',');
        syntax2 = [syntax1(1:ptrComma(end)-1) ')'];
        fstr = [fstr syntax2 endl];
    end
    
    if(nin > 2)
        syntax2 = [syntax1(1:ptrComma(end-1)-1) ')'];
        fstr = [fstr syntax2 endl];
    end
    
    fstr = [fstr '%' endl];
    
    
    % Write Input and output help lists
    fstr = [fstr arginstr argoutstr];
    
    %% Notes Section
    fstr=[ fstr '% NOTES:' endl '%' tab];
    fstr = [fstr '<Any Additional Information>'  endl ...  % get spacing for NOTES Correctly
        '%' endl ];
    
    if(flgVararginSection)
        fstr = [fstr '%' tab 'VARARGIN PROPERTIES:' endl];
        fstr = [fstr '%' tab 'PropertyName' tab tab 'PropertyValue' tab 'Default' tab tab 'Description' endl];
        fstr = [fstr '%' tab '<PropertyName>' tab tab '<units>' tab tab tab '<Default>' tab '<Description>' endl];
        fstr = [fstr '%' endl];
    end
    
    % Example Section and Function Line
    if(CNF_info.NumExamples > 0)
        if(CNF_info.NumExamples == 1)
            fstr = [fstr '% EXAMPLE:' endl];
        else
            fstr = [fstr '% EXAMPLES:' endl];
        end
        for i = 1:CNF_info.NumExamples
            fstr = [fstr '%' tab '% <Enter Description of Example #' num2str(i) '>' endl]; %#ok<AGROW>
            % get example call also used for Function line
            funcstr = ['[' FuncOutstr '] = ' fname ...
                '(' FuncInstr ')']; % write function example to sep var.
            
            if(i == 2)
                if(nin > 1)
                    funcstr2 = ['[' FuncOutstr '] = ' fname ...
                        '(' FuncInstr(1:end-length(InArgList{end})-2) ')']; % write function example to sep var.
                else
                    funcstr2 = ['[' FuncOutstr '] = ' fname '()'];
                end
                
                fstr = [fstr '%' tab funcstr2 endl];  %#ok<AGROW> get spacing for Example Correctly
            else
                funcstr = ['[' FuncOutstr '] = ' fname ...
                    '(' FuncInstr ')']; % write function example to sep var.
                fstr = [fstr '%' tab funcstr endl];  %#ok<AGROW> get spacing for Example Correctly
            end
            
            fstr = [fstr '%' tab '% <Copy expected outputs from Command Window>' endl];  %#ok<AGROW>
            fstr = [fstr '%' endl];  %#ok<AGROW>
        end
    end
    
    %% SOURCE DOCUMENTATION
    if(SourceDoc)
        fstr=[ fstr '% SOURCE DOCUMENTATION:' endl];
        fstr=[ fstr '% <Enter as many sources as needed.  Some popular ones are listed here.>' endl];
        fstr=[ fstr '% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >' endl];
        fstr=[ fstr '% Website Citation:' endl];
        fstr=[ fstr '% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number. Date of Access <URL>' endl];
        fstr=[ fstr '% Book with One Author:' endl];
        fstr=[ fstr '% [2]   Author Last Name, Author First Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #' endl];
        fstr=[ fstr '% Book with Two Author:' endl];
        fstr=[ fstr '% [3]   Author #1 Last Name, Author #1 First Name, and Author #2 Full Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #' endl];
        fstr=[ fstr '%' endl];
    end
    
    % Test Driver Hyperlink
    if(CNF_info.IncludeHyperlinks)
        fstr = [fstr '%' endl];
        fstr = [fstr '% HYPERLINKS:' endl];
        fstr = [fstr '%' tab 'Source function: ' '<a href="matlab:edit ' fname '.m">' fname '.m</a>' endl];
        fstr = [fstr '%' tab '  Driver script: ' '<a href="matlab:edit Driver_' fname '.m">Driver_' fname '.m</a>' endl];
        fstr = [fstr '%' tab '  Documentation: ' '<a href="matlab:winopen(which(''' fname '_Function_Documentation.pptx''));">' fname '_Function_Documentation.pptx</a>' endl];
    end
    
    if(CNF_info.IncludeRelevantFunctions)
        fstr = [fstr '%' endl];
        % See also
        fstr = [fstr '% See also <add relevant functions> ' endl '%' endl];
    end
    
    % Verification
    if(IncludeVerification)
        if(isfield(CNF_info, 'Verification'))
            if(~isempty(CNF_info.Verification))
                fstr = [fstr CNF_info.Verification];
            end
        end
    end
    
    % Copyright
    if(IncludeCopyright)
        if(isfield(CNF_info, 'Copyright'))
            if(~isempty(CNF_info.Copyright))
                fstr = [fstr CNF_info.Copyright];
                if(~strcmp(CNF_info.Copyright(end), endl))
                    fstr = [fstr endl];
                end
            end
        end
    end
    
    % Maintenance
    if(IncludeMaintenance)
        if(isfield(CNF_info, 'Maintenance'))
            if(~isempty(CNF_info.Maintenance))
                fstr = [fstr CNF_info.Maintenance];
                if(~strcmp(CNF_info.Maintenance(end), endl))
                    fstr = [fstr endl];
                end
            end
        end
    end
    
    %% Classification Section:
    if CNF_info.Classificaiton_inclBlock ~= 0 % it it is not desired to surpress block
        if ~isempty(CNF_info.Classification)
            fstr = [fstr '% ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
        end
        if ~isempty(CNF_info.Classification_Block)
            % Blank line to end help
            fstr = [fstr endl];
            fstr = [fstr CNF_info.Classification_Block endl];
        end
    end
    
    %% Reversion infoRev/Author
    % blank line to end Help
    fstr = [fstr endl];
    
    if(SVN)
        % NOTE: spaces added to prevent keyword substitution on this line
        fstr = [fstr '% Subversion Revision Information At Last Commit' endl ...
            '% $URL: ' '$' endl ...
            '% $Rev: ' '$' endl ...
            '% $Date: ' '$' endl ...
            '% $Author: ' '$' endl ...
            endl]; %Blank Line
    end
    
    %% Function line:
    fstr = [fstr 'function ' funcstr endl ...
        endl];
    
    %% Debugging & Display Utilities:
    if(isfield(CNF_info, 'IncludeDebugging'))
        if(CNF_info.IncludeDebugging)
            
            fstr = [fstr '%% Debugging & Display Utilities:' endl ...
                'spc  = sprintf('' '');                                % One Single Space' endl ...
                'tab  = sprintf(''\t'');                               % One Tab' endl ...
                'endl = sprintf(''\n'');                               % Line Return' endl ...
                '[mfpath,mfnam] = fileparts(mfilename(''fullpath''));  % Full Path to Function, Name of Function' endl ...
                'mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name' endl ...
                'mlink = [''<a href = "matlab:help '' mfnam ''">'' mfnam ''</a>'']; % Hyperlink to mask help that can be added to a error disp' endl endl];
            
            %% Examples Section:
            %section to show example of display options
            ExampleStr = ['% Examples of Different Display Formats:' endl ...
                '% disp([mfnam ''>> Output with filename included...'' ]);' endl ...
                '% disp([mfspc ''>> further outputs will be justified the same'']);' endl ...
                '% disp([mfspc ''>> CAUTION: or mfnam: note lack of space after">>"'']);' endl ...
                '% disp([mfnam ''>> WARNING: <- Very important warning (does not terminate)'']);' endl ...
                '% disp([mfnam ''>> ERROR: <-if followed by "return" used if continued exit desired'']);' endl ...
                '% errstr = [mfnam ''>> ERROR: <define error here> See '' mlink '' help''];      % <-- Couple with error function' endl ...
                '% error([mfnam ''class:file:Identifier''], errstr);    % Call error function with error string' endl ...
                endl];
            fstr = [fstr ExampleStr];
        end
    end
        
    %% Output Argument Declaration:
    if(~include_old)
    fstr = [fstr '%% Initialize Outputs:' endl];
    outputstr = '';
    if(nout > 0)
        for i = 1:nout % this adds initial output for the arguments to make the function 'work'
            outputstr = [outputstr OutArgList{i} '= -1;' endl]; %#ok<AGROW>
        end
    else
        outputstr = ['%' tab 'No Outputs Specified' endl];
    end
    fstr = [fstr outputstr endl];
    
    
    %% Input Argument Conditioning:
    if(nin > 0)
        fstr = [fstr '%% Input Argument Conditioning:' endl];
        
        if(flgVararginSection)
            fstr = [fstr '% Pick out Properties Entered via varargin' endl];
            fstr = [fstr '% [<PropertyValue>, varargin]  = format_varargin(''PropertyValue'', <Default>, 2, varargin);' endl];
            fstr = [fstr endl];
        end
        
        fstr = [fstr '%  switch(nargin)' endl];
        
        nInputs = nin;
        if(IncludeVarargin)
            nInputs = nInputs - 1;
        end
        
        for i = 0:nInputs
            fstr = [fstr '%       case ' num2str(i) endl];
            inargstr = '';
            for j = nInputs:-1:(1+i)
                if(~strcmp(InArgList{j}, 'varargin'))
                    inargstr = [inargstr InArgList{j} '= ''''; '];
                end
            end
            fstr = [fstr '%        ' inargstr endl];
        end
        fstr = [fstr '%  end' endl];
        fstr = [fstr '%' endl];
        
        if(nin > 1)
            if(~strcmp(InArgList{nin}, 'varargin'))
                fstr = [fstr '%  if(isempty(' InArgList{nin} '))' endl];
                fstr = [fstr '%' tab tab InArgList{nin} ' = -1;' endl];
                fstr = [fstr '%  end' endl];
            else
                if(nin > 2)
                    fstr = [fstr '%  if(isempty(' InArgList{nin-1} '))' endl];
                    fstr = [fstr '%' tab tab InArgList{nin-1} ' = -1;' endl];
                    fstr = [fstr '%  end' endl];
                end
            end
        end
    end
    end
    
    %% Main Function:
    fstr = [fstr '%% Main Function:' endl];
    
    if(include_old)
        filedata = matlab.desktop.editor.openDocument(which(fullfname));
        
        cellText = str2cell(filedata.Text, endl);
        numLines = size(cellText, 1);
        iLinesToAdd = setxor([1:numLines], refLines);
        cellTextToAdd = cellText(iLinesToAdd);       
        strTextToAdd = cell2str(cellTextToAdd, endl);
        clear cellText cellTextToAdd;
        fstr = [fstr strTextToAdd endl];
    else
        
        fstr = [fstr '%  <Insert Main Function>' endl endl];
    end
    %% Output Section
    if(~include_old)
    if(nout > 0)
        fstr = [fstr '%% Compile Outputs:' endl];
        %Create initial outputs so functions will not have errors
        outputstr = '';
        
        for i = 1:nout % this adds initial output for the arguments to make the function 'work'
            outputstr = [outputstr '%' tab OutArgList{i} '= -1;' endl]; %#ok<AGROW>
        end
    end
    fstr = [fstr outputstr endl];
    end
    
    %% Return section
    fstr = [fstr 'end % << End of function >>' endl endl];
    
    %% Revision section
    if(isfield(CNF_info, 'RevisionHistory'))
        if ~isempty(CNF_info.RevisionHistory)
            if ~isempty(CNF_info.RevisionHistory)
                fstr = [fstr CNF_info.RevisionHistory];
                if(~strcmp(CNF_info.RevisionHistory(end), endl))
                    fstr = [fstr endl];
                end
                fstr = [fstr '%' endl];
            end
        end
    end
    
    %% Author Identification
    if(isfield(CNF_info, 'AuthorIdentification'))
        if ~isempty(CNF_info.AuthorIdentification)
            fstr = [fstr CNF_info.AuthorIdentification];
            if(~strcmp(CNF_info.AuthorIdentification(end), endl))
                fstr = [fstr endl];
            end
            fstr = [fstr '%' endl];
        end
    end
    
    %% Footer
    % Order is reversed from header
    % DistributionStatement,ITARparagraph Proprietary ITAR, Classification
    fstr = [fstr '%% DISTRIBUTION:' endl];
    % Distribution Statement
    if(isfield(CNF_info, 'Distribution'))
        if ~isempty(CNF_info.Distribution)
            fstr = [fstr CNF_info.Distribution endl];
            fstr = [fstr '%' endl];
        end
    end
    
    % Itar Paragraph
    if(isfield(CNF_info, 'ITAR_Paragraph'))
        if ~isempty(CNF_info.ITAR_Paragraph)
            fstr = [fstr CNF_info.ITAR_Paragraph];
            if(~strcmp(CNF_info.ITAR_Paragraph(end), endl))
                fstr = [fstr endl];
            end
            fstr = [fstr '%' endl];
        end
    end
    
    % Footer Proprietary Lines
    if(isfield(CNF_info, 'Proprietary'))
        if ~isempty(CNF_info.Proprietary)
            fstr = [fstr '% ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
        end
    end
    
    % Footer ITAR Lines
    if(isfield(CNF_info, 'ITAR'))
        if ~isempty(CNF_info.ITAR)
            fstr = [fstr '% ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
        end
    end
    
    % Footer Classified Lines
    if(isfield(CNF_info, 'Classification'))
        if ~isempty(CNF_info.Classification)
            fstr = [fstr '% ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
        end
    end
    
    [fid, message ] = fopen([cur_folder filesep fname '.m'],'wt','native');
    info.fname = [fname '.m'];
    info.fname_full = [cur_folder filesep fname '.m'];
    if fid == -1
        info.text = fstr;
        info.error = [mfnam '>> ERROR: File Not created: ' message];
        disp(info.error)
        fl = -1;
        return
    else %any answer besides 'Y'
        fprintf(fid,'%s',fstr);
        fclose(fid);
        matlab.desktop.editor.openDocument(info.fname_full);
        fl = 0;
        info.text = fstr;
        info.OK = 'maybe it worked';
        
        if(flgCopyMade)
            matlab.desktop.editor.openDocument([cur_folder filesep fname '_old.m']);
        end
    end
    
    lstFound = which(fname, '-all');
    if(size(lstFound,1) > 1)
        disp([mfnam '>> WARNING: Multiple functions of the same name now exist.  ' ...
            'Double check that you are not being shadowed']);
        which(fname, '-all');
    end
    
else
    disp([mfnam '>> CAUTION: Function Not Created']);
    disp([mfspc '>> File exists and User selected "Do Not Overwrite"']);
end

%% Compile Outputs
info.CNF_info = CNF_info;

%% Compile Outputs:
%	fl= -1;
%	info= -1;

end % << End of function CreateNewFunc >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101102 JPG: Copied over information from the old function.
% 101102 CNF: Function template created using CreateNewFunc
% 100812 MWS: Fixed header section when zero inputs and/or outputs provided
%             Cleaned up body (input argument checking, tag at end of
%             function.
%             Added hyperlinks to function documentation.
% 100811 MWS: Added option to save copy of function if overwrite is
%               selected.  Added hyperlink to DRIVER file and self.
% 100809 MWS: Updated internal documentation fields.  Fixed bugs in svn
%               keywords.
% 100316 HCP: Corrected some spelling mistakes
% 091130 TKV: Overwrite file updated and note added.
% 091127 TKV: UPdated to include Declassify date features, changed end of
% function to "end" instead of Return...  Small cleanups
% 090916 TKV: Updated [mfpath,mfnam] to include current file path (very
% usefull!)
% 090802 TKV: Added Declassificaiton Block and updated some spacing.
% 090122 TKV: Reversed footer so that Class guide on bottom
%           Added new input features and corrected some latent input format
%           bugs
%           -Updated help text
% 080917 TKV: added space to prevent spurious local keyword substition
%  which was getting written into the new function! and other spelling
% 080915 REB: Corrected Spelling errors in generated header.
% 080609 TKV: Added Keyword Check and corrected bug in Revison section and
% adde linebreaks in ITAR_Paragraph default value. Tickt number #8
% 080608 TKV: Updated Help to include Copyright in printed help
%           Updated to remove "only for Non-Version controlled files...
%           Updated Ouputs to remove additoinal default "info"
% 070907 TKV: Updated Help file
% 070907 TKV: Added Example displays
% 070907 TKV: Updated input/outputs for zero args.
% 070718 TKV: Small change to add URL Keyword to this file...
% 070715 TKV: major rev: Allowed for input of CNF_info struct or *.mat!
% 070715 TKV: Added initial ouput of -1 to each output so that the new
% function can be run with no change...
% 070705 TKV: Corrected datestr format.
% 070705 TKV: Trac 2: Changed input to Cell array of strings (numbers still
% work)
% 070705 TKV: Trac 1: Fixed extra space in input and updated example call
% 070629 TKV: File Created
% *Add New Revision notes to TOP of list*
%
% Initials Identification:
% INI: FullName         : Email                     : NGGN Username
% HCP: Hien Pham        : hien.pham2@ngc.com        : phamhi2
% JPG: James Gray       : james.gray2@ngc.com       : g61720
% MWS: Mike Sufana      : mike.sufana@ngc.com       : sufanmi
% REB: Roshawn Bowers   : roshawn.bowers@ngc.com    : bowerro
% TKV: Travis Vetter    : travis.vetter@ngc.com     : vettetr

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
