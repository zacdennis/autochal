% CreateNewDocBlock Create template for internal block documentation
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% FUNCTION CreateNewDocBlock
%   This functions creates a template for the internal documentation of
%   Simulink blocks in DocBlock form. The template includes information
%   for the block's inputs, outputs, and source documentation.
%
%  SYNTAX:
%   [TextToAdd, block_pos] = CreateNewDocBlock(block_fullpath, CNF_info, block_description)
%   [TextToAdd, block_pos] = CreateNewDocBlock(block_fullpath, CNF_info)
%   [TextToAdd, block_pos] = CreateNewDocBlock(block_fullpath)
%
%  INPUTS:
%   Name                Size    Units           Description
%   block_fullpath      [1xn]   String          Location of the block in
%                                               the Simulink diagram
%   CNF_info            [Char OR Struct]        Defines format to use for
%                                                the header/footer sections
%                                                Default: 'Default'
%   block_description   [1xm]   String          Text to add to block
%                                                documentation field
%                                                Default: '' (none)
%  OUTPUTS:
%   Name            Size        Units           Description
%   TextToAdd       [1xn]       String          DocBlock text in string
%                                                form
%   block_pos       [1x4]       [int]           Position of DocBlock in
%                                                Simulink diagram where
%                                                block_pos is defined as
%                                               [left bottom width height]
%
%  NOTES:
%   This function can be used in a loop to generate several documentations
%   to be added for different blocks.
%
%  EXAMPLE:
%   % Adds a DocBlock template to the top level of the 'f14' model
%   CreateNewDocBlock('f14')
%
%   % Adds a DocBlock template to the 'Controller' block in the 'f14' model
%   CreateNewDocBlock('f14/Controller')
%
%   % Same as before, but populates the block description field
%   txt = 'This is the documentation to add';
%   CreateNewDocBlock('f14/Controller','', txt)
%
% See also Driver_CreateUnitTestModel
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/683
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CreateNewDocBlock.m $
% $Rev: 3305 $
% $Date: 2014-11-18 13:49:05 -0600 (Tue, 18 Nov 2014) $
% $Author: sufanmi $

function [TextToAdd, block_pos] = CreateNewDocBlock(block_fullpath, varargin)
[OutArgList, varargin]          = format_varargin('OutArgList', {}, 2, varargin);
[InArgList, varargin]           = format_varargin('InArgList', {}, 2, varargin);
[CNF_info, varargin]            = format_varargin('Markings', 'CreateNewFile_Defaults', 2, varargin);
[block_description, varargin]   = format_varargin('Description', '', 2, varargin);
[ForceAdd, varargin]            = format_varargin('ForceAdd', true, 2, varargin);

%% General Header
spc  = sprintf(' ');
tab  = sprintf('\t');
endl = sprintf('\n');
mfnam = mfilename;
mfspc = char(ones(1,length(mfnam))*spc);

%% Arg conditioning
switch nargin
    case 0
        block_fullpath = gcb;
end

% Test Input 1 block_name;  arg type
if ~ischar(block_fullpath);
    errorstr = 'block_name (input 1) must be of type "char" ! ';
    disp([mfnam '>>ERROR: ' errorstr]);
    error(errorstr);
end

%% Figure out strings for blocks
idx_slashes=findstr(block_fullpath,'/');
if(isempty(idx_slashes))
    root_sys = block_fullpath;
    block_path = block_fullpath;
    block_name = block_fullpath;
    
else
    root_sys = block_fullpath(1:idx_slashes(1)-1);
    block_path = block_fullpath(1:idx_slashes(end)-1);
    block_name = block_fullpath(idx_slashes(end)+1:end);
end

strBlockType = get_param(block_fullpath, 'BlockType');

flgAdd = true;

if(strcmp(strBlockType, 'S-Function'))
    disp([mfnam '>>WARNING: ' block_fullpath ' is an S-Function.  Cannot add DocBlock inside subsystem.  Skipping DocBlock addition.']);
    flgAdd = false;
else
    open_system(root_sys);
    open_system(block_fullpath, 'force');
    
    if(strcmp(get_param(root_sys, 'Lock'), 'on'))
        if(ForceAdd)
            disp([mfnam '>>WARNING: ' root_sys ' is currently locked.  Unlocking for DocBlock addition...']);
            set_param(root_sys, 'Lock', 'off');
        else
            disp([mfnam '>>WARNING: ' root_sys ' is currently locked.  Ignoring call to add DocBlock...']);
            flgAdd = false;
        end
    end
end

if(~flgAdd)
    TextToAdd = '';
    block_pos = [0 0 0 0];
else
    
%     try
%         h= get_param(block_fullpath, 'Ports');
%         nin= h(1);
%         
%         if(isempty(nin))
%             nin = 0;
%         end
%         nout=h(2);
%         if(isempty(nout))
%             nout = 0;
%         end
%     catch
%         nin = 0;
%         nout = 0;
%     end
    
    %% Figure out InArgList:
    if(isempty(InArgList))
        %Gets the full path of the input ports with name included
        lstPorts=find_system(block_fullpath, 'LookUnderMasks', 'all', 'SearchDepth', 1, 'BlockType', 'Inport');
        
        %Gets the full path previously found and gets the name of the input
        for iPort= 1:size(lstPorts)
            curPortStr = lstPorts{iPort};
            curPortStr = strrep(curPortStr, [block_fullpath '/'], '');
            curPortStr = strrep(curPortStr, char(10), ' ');
            curPortStr = strrep(curPortStr, '//', '/');
            InArgList{iPort}=curPortStr;
        end   
    end
    if(isempty(InArgList))
        nin = 0;
    else
        if(size(InArgList, 1) >= size(InArgList, 2))
            % InArgList is a Column Cell Array
            nin = size(InArgList, 1);
        else
            % InArgList is a Row Cell Array
            nin = size(InArgList, 2);
        end
    end
    
    %% Figure out OutArgList:
    if(isempty(OutArgList))
        %Interregotes the block to get the fullpath and name of the Outputs
        lstPorts=find_system(block_fullpath, 'LookUnderMasks', 'all', 'SearchDepth', 1, 'BlockType', 'Outport');
        
        %Gets the name of the outputs using the full path prevously interrogated
        for iPort= 1:size(lstPorts)
            curPortStr = lstPorts{iPort};
            curPortStr = strrep(curPortStr, [block_fullpath '/'], '');
            curPortStr = strrep(curPortStr, char(10), ' ');
            curPortStr = strrep(curPortStr, '//', '/');
            OutArgList{iPort}=curPortStr;
        end
    end
    if(isempty(OutArgList))
        nout = 0;
    else
        if(size(OutArgList, 1) >= size(OutArgList, 2))
            % OutArgList is a Column Cell Array
            nout = size(OutArgList, 1);
        else
            % InArgList is a Row Cell Array
            nout = size(OutArgList, 2);
        end
    end
    
    % CNF_info Testing andworkout
    
    CNF_info_Def = CreateNewFile_Defaults(0, mfnam, varargin);
    if ischar(CNF_info)
        switch CNF_info
            case 'Default'
                CNF_info = CNF_info_Def; %local call to get default values
            case 'Search'
                CNF_info = 'CreateNewDocBlock_info';
            otherwise
                % assume it is a mat file name and with one variable in it.
                % so tha fieldnames returns one value.
                eval(sprintf('CNF_info = %s(0, mfnam, varargin);', CNF_info));
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
    
    %%
    fstr = [upper(block_name) ' <Enter One Line Description>' endl];
    
    %% Header Classified Lines
    % write to temp header variable

    if ~isempty(CNF_info.Classification)
        fstr = [fstr ' ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    %% Header ITAR Lines
    if ~isempty(CNF_info.ITAR)
        fstr = [fstr ' ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    %% Header Proprietary Lines
    if ~isempty(CNF_info.Proprietary)
        fstr = [fstr ' ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    %% HELP Filename line and help
    fstr = [fstr block_name ':' endl ];
    
    if(isempty(block_description))
        fstr = [fstr tab '<Enter Full Block Description>' endl];
    else
        fstr = [fstr str2paragraph(block_description) endl];
    end
    fstr = [fstr endl];
    
    %%  Help - Argument Explanations - Example - See Also - Function
    % This should use nargin and nargout
   
    maxLength = 0;
    for i = 1:nin
        maxLength = max(maxLength, length(InArgList{i}));
    end
    for i = 1:nout
        maxLength = max(maxLength, length(OutArgList{i}));
    end
       
    inputhead=[' ' tab 'Name' spaces(maxLength - length('Size')) tab 'Size' tab tab 'Units' tab tab 'Description'];
        
    % input help section
    arginstr = ['INPORTS: ' endl inputhead];
    FuncInstr = '';
    if nin == 0;
        arginstr = [arginstr endl ' ' tab ' None'];
    else
        for i = 1:nin
            arginstr = [arginstr endl ' ' tab InArgList{i} spaces(maxLength - length(InArgList{i})) tab '<size>' tab tab '<units>' tab tab '<Description>' ]; %#ok<AGROW>
            
            if(i == 1)
                FuncInstr = InArgList{i};
            else
                FuncInstr = [FuncInstr ', ' InArgList{i}]; %#ok<AGROW>
            end
        end
    end
    
    % Ouput side
    inputhead=[' ' tab 'Name' spaces(maxLength - length('Size')) tab 'Size' tab tab 'Units' tab tab 'Description'];
    argoutstr = ['OUTPORTS: ' endl  inputhead];
    FuncOutstr = '';
    if nout == 0;
        argoutstr = [endl ' ' argoutstr ' None' endl '%'];
    else
        for i = 1:nout
            argoutstr = [argoutstr endl ' ' tab OutArgList{i} spaces(maxLength - length(OutArgList{i})) tab '<size>' tab tab '<units>' tab tab '<Description>' ]; %#ok<AGROW>
            
            if(i == 1)
                FuncOutstr = OutArgList{i};
            else
                FuncOutstr = [FuncOutstr ', ' OutArgList{i}]; %#ok<AGROW>
            end
        end
    end
    
    %% Syntax
    %%Write Syntax Section
    fstr=[ fstr 'SYNTAX:' endl];
    syntax1 = [ ' ' tab '[' FuncOutstr '] = ' block_name ...
        '(' FuncInstr ')'];
    fstr = [fstr syntax1 endl endl];
    
    % Write Input and output help lists
    fstr = [fstr arginstr endl ' ' endl argoutstr endl ''];
    fstr = [fstr endl ];
    
    %% Mask Parameters:
    fstr = [fstr 'MASK PARAMETERS:' endl ];
    fstr = [fstr ' ** Remove Section if block is NOT masked **' endl];
    fstr = [fstr tab 'Name' spaces(maxLength - length('Size')) tab 'Size' tab tab 'Units' tab tab 'Description' endl];
    fstr = [fstr tab '<Name>' spaces(maxLength - length('<Name>')) tab '<Size>' tab tab '<Units>' tab tab '<Description>' endl];
    fstr = [fstr endl ];
    
    %% Internal Variables:
    fstr = [fstr 'INTERNAL VARIABLES:' endl ];
    fstr = [fstr ' ** Remove Section if block is NOT masked **' endl];
    fstr = [fstr tab 'Name' spaces(maxLength - length('Size')) tab 'Size' tab tab 'Units' tab tab 'Description' endl];
    fstr = [fstr tab '<Name>' spaces(maxLength - length('<Name>')) tab '<Size>' tab tab '<Units>' tab tab '<Description>' endl];
    fstr = [fstr endl ];
        
    %% Notes Section
    fstr = [fstr 'NOTES:' endl ' ' tab];
    fstr = [fstr '<Any Additional Information>'  endl];
    fstr = [fstr endl];  % get spacing for NOTES Correctly
    
    % Example Section and Block Line
    fstr = [fstr ' VERIFICATION:' endl ' ' tab];
    % get example call also used for Function line
    fstr = [fstr '  Test_' block_name '.mdl' endl endl];
    
    %% SOURCE DOCUMENTATION
    fstr=[ fstr 'SOURCE DOCUMENTATION:' endl ' ' tab];
    sources=['[1]    http://www...' endl ' ' tab '[2]    Author. Book Title. Publisher, City, Copyright year'];
    fstr = [fstr sources endl ...  % get spacing for Source documentation Correctly
        '' endl ];
    
    % See also
    fstr = [fstr ' See also <add relevant Blocks> ' endl endl];
    
    % Copyright
    if(~isempty(CNF_info.Copyright))
        fstr = [fstr CNF_info.Copyright];
    end
        
    %% Classification Section:
    if CNF_info.Classificaiton_inclBlock ~= 0 % it it is not desired to surpress block
        if ~isempty(CNF_info.Classification)
            fstr = [fstr ' ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
        end
        if ~isempty(CNF_info.Classification_Block)
            % Blank line to end help
            fstr = [fstr endl];
            fstr = [fstr CNF_info.Classification_Block endl];
        end
    end
    
    %% Revision section
    fstr = [fstr endl];
    fstr = [fstr 'REVISION HISTORY:' endl];
    fstr = [fstr ' YYMMDD INI: note' endl];
    fstr = [fstr ' ' datestr(now,'YYmmdd') ' CNF: File Created by CreateNewDocBlock' endl];
    fstr = [fstr '**Add New Revision notes to TOP of list**' endl];
    fstr = [fstr endl];
    fstr = [fstr ' Initials Identification: ' endl];
    fstr = [fstr ' INI: FullName  :  Email  :  NGGN username ' endl];
    fstr = [fstr ' <ini>: <Fullname> : <email> : <NGGN username> ' endl];
    fstr = [fstr endl];
        
    %% Footer
    % Order is reversed from header
    % DistributionStatement,ITARparagraph Proprietary ITAR, Classification
    
    % Distribution Statement
    %     if ~isempty(CNF_info.DistibStatement)
    %         fstr = [fstr CNF_info.DistibStatement endl];
    %         fstr = [fstr endl]; %trailing space..
    %     end
    
    % Itar Paragraph
    if ~isempty(CNF_info.ITAR_Paragraph)
        fstr = [fstr CNF_info.ITAR_Paragraph endl];
    end

    
    % write to temp header variable
    
    % Footer Proprietary Lines
    if ~isempty(CNF_info.Proprietary)
        fstr = [fstr ' ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    % Footer ITAR Lines
    if ~isempty(CNF_info.ITAR)
        fstr = [fstr ' ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end

    % Footer Classified Lines
    if ~isempty(CNF_info.Classification)
        fstr = [fstr ' ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    %% write output file
    % Output to file.
    TextToAdd=fstr;
    
    block_pos = AddDocBlock(block_fullpath, fstr);
    
%     close_system(block_fullpath);
    
    %% Outputs
    info.CNF_info = CNF_info;
end
%% MAIN Return
end % for new format of functions.

%% SubRoutine: MakeCaps
function [ostr] = MakeCaps(instr)
% converts a string to all caps
instr = double(instr); % convert to ascii integers
lc= find((instr >= 97) & (instr <=122));
instr(lc)=instr(lc)-32; %converts to Uppercase
ostr = char(instr);
end %new function structure

%% SubRoutine: CenterChars
function [str] = CenterChars(str,width,centchar)
%1st arg = String to center with characters
%2nd arg = Width to center to
%3rd arg = Character to center with
lstr = length(str); % get length of input string
cc = sprintf(centchar(1));  % get character to use as centering char
leadcc = floor((width-lstr)/2) - 1; %calc how many leadnig chars (' ' and ' 'str)
tailcc = width - lstr - leadcc - 1 -1; %trailng chars
str = [char(ones(1,leadcc))*cc ' ' str ' ' char(ones(1,tailcc))*cc ];
end %new format

%% SubRoutine: CNF_info_Default
function CNF_info = CNF_info_Default()
% Check CNF_info
endl = sprintf('\n');
CNF_info.Notes = ['Default Values for ' mfilename];
CNF_info.CentChar = '-';
CNF_info.HelpWidth = 67;
CNF_info.Classification = 'UNCLASSIFIED';
CNF_info.Classificaiton_inclBlock = 0; % 1 includes block below
CNF_info.Classification_DeclassYrs = 10; %-1 puts "<enter date>"
CNF_info.Classification_ReviewYrs = 9.6; %uses Y.M not Y.fractions
DeclassDateStr = GetDeclassDate(CNF_info.Classification_DeclassYrs);
ReviewDateStr = GetDeclassDate(CNF_info.Classification_ReviewYrs);
CNF_info.Classification_Block = [' Classified by: ' endl ...
    ' Authority: ' endl ...
    ' Declassify On: ' DeclassDateStr endl ...
    ' Review on: ' ReviewDateStr ];
CNF_info.Proprietary = 'Northrop Grumman Proprietary Level 1';
CNF_info.ITAR = 'ITAR Controlled Work Product';
CNF_info.ITAR_Paragraph =[' WARNING - This document contains technical data whose export is' endl ...
    '   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et ' endl ...
    '   seq.) or the Export Administration Act of 1979, as amended, Title 50,' endl ...
    '   U.S.C., App.2401et seq. Violation of these export-control laws is ' endl ...
    '   subject to severe civil and/or criminal penalties.'];
%CNF_info.DistibStatement = ' Distribution ';
CNF_info.ContractStr = 'Contract Name: <Enter Contract>'; %TODO: Not implemented
CNF_info.ContractNum = ' <Enter Contract Number>'; %TODO: Not iplemented.

    function [DeclassDateStr] = GetDeclassDate(Yrs,StartDate)
        if nargin == 1;
            StartDate = now();
        end
        if Yrs < 0;
            DeclassDateStr = '<Enter Date>';
            return % Don't want a real calc...
        end
        yrs = floor(Yrs);
        mo = round((Yrs-yrs)*10); % the decimal is months,not fraction
        declass = addtodate(datenum(StartDate),yrs,'year');
        declass = addtodate(declass,mo,'month');
        DeclassDateStr = datestr(declass,'mmmm dd yyyy');
    end

end
