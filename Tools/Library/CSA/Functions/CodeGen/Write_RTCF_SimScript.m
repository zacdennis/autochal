% WRITE_RTCF_SIMSCRIPT Builds a sample RTCF simscript and .bat file
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Write_RTCF_SimScript:
%     This function develops a sample RTCF test script (.ebs) and .bat file
%     that can be used to help test a component in RTCF.  On the RTCF side,
%     users should be able to look to the .ebs script to "cherry pick" code
%     for their full test script.
%
% SYNTAX:
%	[lstFiles] = Write_RTCF_SimScript(strModel, varargin, 'PropertyName', PropertyValue)
%	[lstFiles] = Write_RTCF_SimScript(strModel, varargin)
%	[lstFiles] = Write_RTCF_SimScript(strModel)
%
% INPUTS:
%	Name    	Size		Units		Description
%	strModel	'string'    [char]      Name of block or model being coded
%                                       into an RTCF component
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS:
%	Name    	Size		Units		Description
%	lstFiles	<size>		<units>		<Description>
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   MarkingsFile        'string'        CreateNewFile_Defaults  Defines
%                                                   the format to use
%                                                   for the script's Header
%                                                   & Footer section
%   OpenAfterCreated    [bool]          true        Open the newly created
%                                                   file for viewing?
%   FileFormat          'string'        '.ebs'      Extension to use for
%                                                    script
%   InputRTDR           {'string'}      {}          Cell array list of all
%                                                    input RTCF data
%                                                    recorders created
%   OutputRTDR          {'string'}      {}          Cell array list of all
%                                                    output RTCF data
%                                                    recorders created
%   ScriptSaveFolder    'string'        pwd         Folder in which to save
%                                                    the RTCF script
%   BatFolderFull       'string'        pwd         Folder in which to save
%                                                    the .bat file that
%                                                    runs the RTCF script
%   Verbose             [bool]          true        Show function progress
%                                                    in Command Window?
%   Comment             'string'        ''''        Character to use for
%                                                    comments in the
%                                                    created script
%   'InputStructName'   'string'        'IN'        Name to use for top
%                                                    -level RTCF input
%                                                    structure
%   'RTCF_HOME'         'string' 'C:\RTCF\5_9_4\RTCF_5_9_4'
%                                                   Main home of RTCF
%   'binEnvVar'         'string'        'BIN_DIR'   Environment variable
%                                                    used to define the 
%                                                    local 'bin' directory
% EXAMPLES:
%	% Build a sample RTCF run script and .bat file for the 'SampleSim_MPMgr'
%   strModel = 'SampleSim_MPMgr';
%   InputRTDR  = {'SampleSim_MPInputs.ebs'};
%   OutputRTDR = {'SampleSim_MPStates.ebs'};
%	[lstFiles] = Write_RTCF_SimScript(strModel, 'InputRTDR', InputRTDR, ...
%                   'OutputRTDR', OutputRTDR);
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Write_RTCF_SimScript.m">Write_RTCF_SimScript.m</a>
%	  Driver script: <a href="matlab:edit Driver_Write_RTCF_SimScript.m">Driver_Write_RTCF_SimScript.m</a>
%	  Documentation: <a href="matlab:pptOpen('Write_RTCF_SimScript_Function_Documentation.pptx');">Write_RTCF_SimScript_Function_Documentation.pptx</a>
%
% See also Write_RTCF_Wrapper, Write_RTCF_vcproj, format_varargin
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/714
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CodeGen/Write_RTCF_SimScript.m $
% $Rev: 3228 $
% $Date: 2014-08-05 14:28:27 -0500 (Tue, 05 Aug 2014) $
% $Author: sufanmi $

function [lstFiles] = Write_RTCF_SimScript(strModel, varargin)

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
[BinFolderFull, varargin]       = format_varargin('BinFolderFull', pwd, 0, varargin);
[ScriptsFolder, varargin]       = format_varargin('ScriptsFolder', 'scripts', 0, varargin);
[RTDRFolder, varargin]          = format_varargin('RTDRFolder', [ScriptsFolder filesep 'RTDR'], 0, varargin);
[TestCaseFolder, varargin]      = format_varargin('TestCaseFolder', [ScriptsFolder filesep 'TestCases'], 0, varargin);
[BatFolder, varargin]           = format_varargin('BatFolder', '', 0, varargin);
[lstInputRTDR, varargin]        = format_varargin('InputRTDR', {},  2, varargin);
[lstOutputRTDR, varargin]       = format_varargin('OutputRTDR', {},  2, varargin);
[lstIORTDR, varargin]           = format_varargin('IORTDR', {},  2, varargin);
[MarkingsFile, varargin]        = format_varargin('MarkingsFile', 'CreateNewFile_Defaults',  2, varargin);
[lstExt, varargin]              = format_varargin('FileFormat', 'ebs',  2, varargin);
[strComment, varargin]          = format_varargin('Comment', '''', 0, varargin);
[flgVerbose, varargin]          = format_varargin('Verbose', 1, 0, varargin);
[OpenAfterCreated, varargin]    = format_varargin('OpenAfterCreated', true,  0, varargin);
[InputStructName, varargin]     = format_varargin('InputStructName', 'IN',  3, varargin);
[flgOpenBatFolder, varargin]    = format_varargin('OpenBatFolder', 1,  0, varargin);
[RTCF_HOME, varargin]           = format_varargin('RTCF_HOME', 'C:\RTCF\5_9_4\RTCF_5_9_4', 2, varargin);
[binEnvVar, varargin]           = format_varargin('binEnvVar', 'BIN_DIR', 2, varargin);

%% Main Function:
%  Construct full path to scripts folder:
if(~isempty(ScriptsFolder))
    ScriptsFolderFull = [BinFolderFull filesep ScriptsFolder];
else
    ScriptsFolderFull = BinFolderFull;
end
if(~isdir(ScriptsFolderFull))
    mkdir(ScriptsFolderFull);
end

% Construct full path to bat folder:
if(~isempty(BatFolder))
    BatFolderFull = [BinFolderFull filesep BatFolder];
else
    BatFolderFull = BinFolderFull;
end
if(~isdir(BatFolderFull))
    mkdir(BatFolderFull);
end

if(ischar(lstExt))
    lstExt = { lstExt };
end
numExt = size(lstExt, 1);

for iExt = 1:numExt
    strExt = lower(lstExt{iExt, 1});
    
    switch strExt
        case 'ebs'
            strComment =  ''' ';
        case 'py'
            strComment = '# ';
    end
    
    %% Start writing the file:
    % Load in Default Markings:
    if(exist(MarkingsFile) == 2)
        eval(sprintf('CNF_info = %s(strComment, mfnam);', MarkingsFile));
    end
    
    %% ========================================================================
    fstr = [strComment 'Code Check Harness for: ' strModel endl];
    
    %% Header Classified Lines
    if ~isempty(CNF_info.Classification)
        fstr = [fstr strComment ' ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    %% Header ITAR Lines
    if ~isempty(CNF_info.ITAR)
        fstr = [fstr strComment ' ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    %% Header Proprietary Lines
    if ~isempty(CNF_info.Proprietary)
        fstr = [fstr strComment ' ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    %% Copyright
    if(isfield(CNF_info, 'Copyright'))
        if(~isempty(CNF_info.Copyright))
            fstr = [fstr strComment endl];
            fstr = [fstr CNF_info.Copyright];
        end
    end
    
    switch strExt
        case 'ebs'
            
            fstr = [fstr '''' endl];
            fstr = [fstr ''' NAME:     Test_' strModel endl];
            fstr = [fstr '''' endl];
            fstr = [fstr ''' PURPOSE:  Function called by WinServer to create, initialize, and run' endl];
            fstr = [fstr '''           the ' strModel ' RTCF component.' endl];
            fstr = [fstr '''' endl];
            fstr = [fstr ''' REQUIREMENTS:  N/A' endl];
            fstr = [fstr '''' endl];
            fstr = [fstr ''' RESTRICTIONS:  None' endl];
            fstr = [fstr '''' endl];
            fstr = [fstr ''' ARGUMENTS:     args - string input to identify test station configuration' endl];
            fstr = [fstr '''                Append command argument with:' endl];
            fstr = [fstr '''' endl];
            fstr = [fstr ''' RETURN:        None' endl];
            fstr = [fstr '''' endl];
            fstr = [fstr '''*****************************************************************************' endl];
            fstr = [fstr '' endl];
            fstr = [fstr 'public RTCF          as object' endl];
            fstr = [fstr '' endl];
            fstr = [fstr 'Sub init( args as String )' endl];
            fstr = [fstr '   ' endl];
            fstr = [fstr '    ''Set the proxy object RTCF to local CLS server' endl];
            fstr = [fstr '	if args = "" then' endl];
            fstr = [fstr '		set RTCF = cls' endl];
            fstr = [fstr '	end if' endl];
            fstr = [fstr '' endl];
            fstr = [fstr '    ''******************************************************************************' endl];
            fstr = [fstr '    '' Desktop Configuration' endl];
            fstr = [fstr '    ''******************************************************************************' endl];
            fstr = [fstr endl];
            fstr = [fstr '    '' Retrieves the RTCF_PATH environment variable' endl];
            fstr = [fstr '    Dim ' binEnvVar '$' endl];
            fstr = [fstr '    ' binEnvVar ' = Environ$("' binEnvVar '")' endl];
            fstr = [fstr endl];
            fstr = [fstr '    '' Create RTCF Objects' endl];
            fstr = [fstr '    RTCF.CreateObject "' strModel '", ' binEnvVar ' +"\' strModel '", "' strModel '_wrap"' endl];
            fstr = [fstr '    ' endl];
            fstr = [fstr '    '' Connect RTCF Objects' endl];
            fstr = [fstr '    '' RunScript ' binEnvVar ' + "\' ScriptsFolder '\Connect_<ComponentA>_to_<ComponentB>.ebs!" & args' endl];
            fstr = [fstr '    ' endl];
            fstr = [fstr '    '' Load in Test Case' endl];
            fstr = [fstr '    '' ' TestCaseFolder '\<TestCase>.ebs!" & args' endl];
            
            for i = 1:size(lstInputRTDR, 1)
                if(i == 1)
                    fstr = [fstr endl];
                    fstr = [fstr '    '' Turn on Data Recorders for the Component''s Inputs' endl];
                end
                curRTDR = lstInputRTDR{i,1};
                [~, curRTDR_root, curExt] = fileparts(curRTDR);
                fstr = [fstr '    '' RunScript ' binEnvVar ' + "\' RTDRFolder '\' curRTDR_root curExt '!" & args' endl];
            end
            
            for i = 1:size(lstOutputRTDR, 1)
                if(i == 1)
                    fstr = [fstr endl];
                    fstr = [fstr '    '' Turn on Data Recorders for the Component''s Outputs' endl];
                end
                curRTDR = lstOutputRTDR{i,1};
                [~, curRTDR_root, curExt] = fileparts(curRTDR);
                fstr = [fstr '    '' RunScript ' binEnvVar ' + "\' RTDRFolder '\' curRTDR_root curExt '!" & args' endl];
            end
            
            for i = 1:size(lstIORTDR, 1)
                if(i == 1)
                    fstr = [fstr endl];
                    fstr = [fstr '    '' Turn on Data Recorders for the Component''s Inputs/Outputs' endl];
                end
                curRTDR = lstIORTDR{i,1};
                [~, curRTDR_root, curExt] = fileparts(curRTDR);
                fstr = [fstr '    '' RunScript ' binEnvVar ' + "\' RTDRFolder '\' curRTDR_root curExt '!" & args' endl];
            end
            
            fstr = [fstr endl];
            fstr = [fstr '    '' Set "' strModel '" off and running' endl];
            fstr = [fstr '    '' Note: This may already be set in a TestCase script' endl];
            
            if(isempty(InputStructName))
                fstr = [fstr '    RTCF.' strModel '.' strModel '_DataInValid_flg = TRUE' endl];
            else
                fstr = [fstr '    RTCF.' strModel '.' InputStructName '.' strModel '_DataInValid_flg = TRUE' endl];
            end
            
            fstr = [fstr endl];
            fstr = [fstr '    '' Run it' endl];
            fstr = [fstr '    RTCF.activate' endl];
            fstr = [fstr endl];
            fstr = [fstr 'End Sub' endl];
            fstr = [fstr endl];
            
        case 'py'
            
    end
    
    %% End <Main Chunk>
    % Itar Paragraph
    if ~isempty(CNF_info.ITAR_Paragraph)
        fstr = [fstr endl];
        fstr = [fstr CNF_info.ITAR_Paragraph];
        if(~strcmp(CNF_info.ITAR_Paragraph(end), endl))
            fstr = [fstr endl];
        end
        fstr = [fstr strComment endl];
    end
    
    % Footer Proprietary Lines
    if ~isempty(CNF_info.Proprietary)
        fstr = [fstr strComment ' ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    % Footer ITAR Lines
    if ~isempty(CNF_info.ITAR)
        fstr = [fstr strComment ' ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    % Footer Classified Lines
    if ~isempty(CNF_info.Classification)
        fstr = [fstr strComment ' ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    % Write header
    filename = ['Test_RTCF_' strModel];
    info.fname = [filename '.' strExt];
    info.fname_full = [ScriptsFolderFull filesep info.fname];
    info.text = fstr;
    
    if(strcmp(strExt, 'ebs'))
        % Only .ebs is supported right now
        
        [fid, message ] = fopen(info.fname_full, 'wt','native');
        
        if fid == -1
            info.error = [mfnam '>> ERROR: File Not created: ' message];
            disp(info.error)
            return
        else %any answer besides 'Y'
            fprintf(fid,'%s',fstr);
            fclose(fid);
            if(OpenAfterCreated)
                edit(info.fname_full);
            end
            info.OK = 'maybe it worked';
        end
        
        if(flgVerbose == 1)
            disp(sprintf('%s : ''%s.%s'' has been created in %s', mfnam, filename, strExt, ScriptsFolderFull));
        end
        
        lstFiles(1,:) = {info.fname_full};
    end
end

%% Write .bat file
filename = ['Test_RTCF_' strModel];
info.fname = [filename '.ebs'];

fstr = '';
fstr = [fstr '@echo off' endl];
fstr = [fstr 'set RTCF_HOME=' RTCF_HOME endl];
fstr = [fstr 'set ' binEnvVar '=%cd%' endl];
fstr = [fstr 'set RUN_SCRIPT=%' binEnvVar '%\'];
if(isempty(BatFolder))
    fstr = [fstr ScriptsFolder '\' info.fname endl]; 
else
    numUp = length(findstr(BatFolder, filesep)) + 1;
    for i = 1:numUp
        fstr = [fstr '..\'];
    end
    fstr = [fstr ScriptsFolder '\' info.fname];
end

fstr = [fstr endl endl];
fstr = [fstr 'echo RTCF_HOME = %RTCF_HOME%' endl];
fstr = [fstr 'echo ' binEnvVar '= %' binEnvVar '%' endl];
fstr = [fstr 'echo RUN_SCRIPT = %RUN_SCRIPT%' endl];
fstr = [fstr endl];
fstr = [fstr 'cd %RTCF_HOME%' endl];
fstr = [fstr '"%RTCF_HOME%\bin\WinSrvr.exe" -W "%RUN_SCRIPT%"' endl];

info.fname_full = [BatFolderFull filesep filename '.bat'];
[fid, message ] = fopen(info.fname_full, 'wt','native');
if fid == -1
    info.error = [mfnam '>> ERROR: File Not created: ' message];
    disp(info.error)
    return
else %any answer besides 'Y'
    fprintf(fid,'%s',fstr);
    fclose(fid);
    info.OK = 'maybe it worked';
end

if(flgOpenBatFolder)
    winopen(BatFolderFull);
end

if(flgVerbose == 1)
    disp(sprintf('%s : ''%s.%s'' has been created in %s', mfnam, filename, strExt, BatFolderFull));
end

lstFiles(2,:) = {info.fname_full};

end % << End of function Write_RTCF_SimScript >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 110602 <INI>: Created function using CreateNewFunc
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
