% WRITE_CODECHECK_CPP Builds C Wrapper for Autocode Verification
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Write_CodeCheck_cpp:
%     This function builds the C++ solution with the test harness for
%     testing a newly autocoded Simulink block or model.
%
% SYNTAX:
%	[lstFiles] = Write_CodeCheck_cpp(strModel, varargin, 'PropertyName', PropertyValue)
%	[lstFiles] = Write_CodeCheck_cpp(strModel, varargin)
%	[lstFiles] = Write_CodeCheck_cpp(strModel)
%
% INPUTS:
%	Name    	Size		Units		Description
%	strModel	'string'    [char]      Name of Autocoded Simulink block or
%                                        model
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS:
%	Name    	Size		Units		Description
%	lstFiles	{'string'}  [char]      List of files created by function
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
%	[lstFiles] = Write_CodeCheck_cpp(strModel, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Write_CodeCheck_cpp.m">Write_CodeCheck_cpp.m</a>
%	  Driver script: <a href="matlab:edit Driver_Write_CodeCheck_cpp.m">Driver_Write_CodeCheck_cpp.m</a>
%	  Documentation: <a href="matlab:pptOpen('Write_CodeCheck_cpp_Function_Documentation.pptx');">Write_CodeCheck_cpp_Function_Documentation.pptx</a>
%
% See also <add relevant functions>
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/704
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [lstFiles] = Write_CodeCheck_cpp(strModel, varargin)

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
lstFiles= '';

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[MarkingsFile, varargin]    = format_varargin('MarkingsFile', 'CreateNewFile_Defaults',  2, varargin);
[RootCodeFolder, varargin]  = format_varargin('RootCodeFolder', '-1',  2, varargin);
[SaveFolder, varargin]      = format_varargin('SaveFolder', pwd,  2, varargin);
[flgVerbose, varargin]      = format_varargin('Verbose', 1, 0, varargin);
[strExt, varargin]          = format_varargin('FileFormat', '.cpp',  2, varargin);
[OpenAfterCreated, varargin]= format_varargin('OpenAfterCreated', true,  2, varargin);
[lstSharedUtils, varargin]  = format_varargin('SharedUtils', {},  2, varargin);
[IncludeTime, varargin]     = format_varargin('IncludeTime', 1,  2, varargin);
[str_CC_Suffix, varargin]   = format_varargin('CC_Suffix', '_CC',  2, varargin);
[str_SL_Suffix, varargin]   = format_varargin('SL_Suffix', '_SL',  2, varargin);
[strVersionTag, varargin]   = format_varargin('VersionTag', '', 0, varargin);
% OpenAfterCreated = 1;

%% Main Function:
ptrSlash = findstr(strModel, '/');
if(isempty(ptrSlash))
    root_sim = strModel;
else
    root_sim = strModel(1:ptrSlash(1)-1);
end

filename = ['CodeCheck_' root_sim];

buildInfo = RTW.getBuildDir(root_sim);

if(strcmp(RootCodeFolder, '-1'))
    RootCodeFolder = buildInfo.RelativeBuildDir;
end

load_system(root_sim);

if(~isdir(SaveFolder))
    mkdir(SaveFolder);
end

%% Compile the Model
TerminateSim(root_sim, flgVerbose);
eval_cmd = ['[sys, X, States, ts] = ' root_sim '([],[],[],''compile'');'];
eval(eval_cmd);

% Find all Input ports:
hInports = find_system(strModel, 'SearchDepth', 1, 'BlockType', 'Inport');
nin = size(hInports,1);
lstModelInputs = {};


%% Figure out if all the inputs are regular input ports (special case):
%  Regular meaning no associated bus object
flgAllInputsReg = 1;
for iin = 1:nin
    hPort           = hInports{iin};
    strBusObject    = get_param(hPort, 'BusObject');
    if(~strcmp(strBusObject, 'BusObject'))
        flgAllInputsReg = 0;
    end
end

% Loop through each Input port:
numInputSignals = 0;
for iin = 1:nin
    hPort           = hInports{iin};
    strInport       = get_param(hPort, 'Name');
    hPortParent     = get_param(hPort, 'Parent');
    strBusObject    = get_param(hPort, 'BusObject');
    idxPort         = get_param(hPort, 'Port');
    strEdit         = sprintf('%s/%s (Inport #%s)', hPortParent, strInport, idxPort);
    
    if(~strcmp(strBusObject, 'BusObject'))
        % Port has a bus object associated with it
        lstBO = BusObject2List(strBusObject);
        numSignals = sum(cell2mat(lstBO(:,2)));
        
        
        % Build Null Inputs so compiled code can "work" in absense of actual
        % test data:
        lstFiles = lst2sampleCSV(strInport, strBusObject, ...
            'Extension', '.txt', 'Suffix', '_SL', ...
            'SaveFolder', TestCaseDefault, ...
            'OpenAfterCreated', OpenAfterCreated);
        
    else
        dimPortData = get_param(hPort, 'CompiledPortWidths');
        numSignals = dimPortData.Outport;
        lstBO = '';
        
        dimPortData = get_param(hPort, 'CompiledPortDataTypes');
        strBusObject = dimPortData.Outport{1};

        if(~flgAllInputsReg)
            lstInputs = {};
            lstInputs(:,1) = { strInport };
            lstInputs(:,2) = { numSignals };
            lstInputs(:,3) = {'[TBD]'};

            % Build Null Inputs so compiled code can "work" in absense of actual
            % test data:
            lstFiles = lst2sampleCSV(strInport, lstInputs, ...
                'Extension', '.txt', 'Suffix', '_SL', ...
                'SaveFolder', SaveFolder, ...
                'OpenAfterCreated', OpenAfterCreated);
        end
    end
    numInputSignals = numInputSignals + numSignals;
    
    lstModelInputs(iin, 1) = { strInport };
    lstModelInputs(iin, 2) = { strEdit };
    lstModelInputs(iin, 3) = { numSignals };
    lstModelInputs(iin, 4) = { strBusObject };
    lstModelInputs(iin, 5) = { lstBO };
    
end

if(flgAllInputsReg)
    input_filename = [SaveFolder filesep strModel '_Inputs' str_SL_Suffix '.txt'];
    
    lstInputs(:,1) = lstModelInputs(:,1);
    lstInputs(:,2) = lstModelInputs(:,3);
    lstInputs(:,3) = {'[TBD]'};
    
    lstFiles = lst2sampleCSV([strModel '_Inputs'], lstInputs, ...
        'Extension', '.txt', 'Suffix', '_SL', ...
        'SaveFolder', SaveFolder, ...
        'OpenAfterCreated', OpenAfterCreated);
end

%% Figure out Outputs
hOutports = find_system(strModel, 'SearchDepth', 1, 'BlockType', 'Outport');
nout = size(hOutports,1);
lstModelOutputs = {};

%% Figure out if all the outputs are regular output ports (special case):
%  Regular meaning no associated bus object
flgAllOutputsReg = 1;
for iout = 1:nout
    hPort       = hOutports{iout};
    strBusObject= get_param(hPort, 'BusObject');
    if(~strcmp(strBusObject, 'BusObject'))
        flgAllOutputsReg = 0;
    end
end

% Loop through each output port:
numOutputSignals = 0;
for iout = 1:nout
    hPort           = hOutports{iout};
    strOutport      = get_param(hPort, 'Name');
    hPortParent     = get_param(hPort, 'Parent');
    strBusObject    = get_param(hPort, 'BusObject');
    idxPort         = get_param(hPort,'Port');
    strEdit         = sprintf('%s/%s (Outport #%s)', hPortParent, strOutport, idxPort);
    
    if(~strcmp(strBusObject, 'BusObject'))
        % Port has a bus object associated with it
        lstBO = BusObject2List(strBusObject);
        numSignals = sum(cell2mat(lstBO(:,2)));
    else
        dimPortData = get_param(hPort, 'CompiledPortWidths');
        numSignals = dimPortData.Inport;
        lstBO = '';
        
        dimPortData = get_param(hPort, 'CompiledPortDataTypes');
        strBusObject = dimPortData.Inport{1};
    end
    numOutputSignals = numOutputSignals + numSignals;
    
    lstModelOutputs(iout, 1) = { strOutport };
    lstModelOutputs(iout, 2) = { strEdit };
    lstModelOutputs(iout, 3) = { numSignals };
    lstModelOutputs(iout, 4) = { strBusObject };
    lstModelOutputs(iout, 5) = { lstBO };
end

TerminateSim(root_sim, flgVerbose);

%% Figure out parts to copy from ert_main.cpp
file2parse = [buildInfo.BuildDirectory filesep 'ert_main.cpp'];
fileinfo = LoadFile(file2parse);
str_file2parse = fileinfo.Text;

%  Part 1 of 3: Retrieve the includes and definitions:
strStart = ['#include "' strModel '.h"'];
ptrs = findstr(str_file2parse, strStart);
ptrStart = ptrs(1);

if(nout > 0)
    strEnd = '/* External outputs */';
else
    strEnd = '/* External inputs */';
end

ptrs = findstr(str_file2parse, strEnd);
ptrEnd = ptrs(1) + length(strEnd);  % Make sure to include the line too
str_ert = str_file2parse(ptrStart:ptrEnd);

%  Part 2 of 3: Get the Initialize Call
str2lookfor = ['/* Initialize model */' endl];
ptrStart = findstr(str_file2parse, str2lookfor);
strLeftover = str_file2parse((ptrStart+length(str2lookfor)):end);
str_init = strtok(strLeftover, ';');
str_init = [str_init ';'];   % Add semi-colon back in
lst_init = str2cell(str_init, endl);

%  Part 3 of 3: Get the Step Call
str2lookfor = ['/* Step the model */' endl];
ptrStart = findstr(str_file2parse, str2lookfor);
strLeftover = str_file2parse((ptrStart+length(str2lookfor)):end);
str_step = strtok(strLeftover, ';');
str_step = [str_step ';'];   % Add semi-colon back in
lst_step = str2cell(str_step, endl);

%% Start writing the file:
strComment = '//';

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

if(~isempty(strVersionTag))
    fstr = [fstr strComment endl];
    fstr = [fstr strComment ' Version: ' strVersionTag endl];
end

%% Main Chunk
fstr = [fstr endl];

fstr = [fstr '#include <stdio.h>' endl];
fstr = [fstr '#include <stdlib.h>' endl];
fstr = [fstr '#include "string.h"' endl];
fstr = [fstr endl];

fstr = [fstr '/* Define Input & Output Port Sizes */' endl];
fstr = [fstr '#define MAXSTRINGSIZE 5000' endl];

lstIO = {}; iIO = 0;
if(flgAllInputsReg)
    iIO = iIO + 1;
    lstIO(iIO,1) = { ['#define width_input1 ' num2str(numInputSignals)] };
    lstIO(iIO,2) = { [' /* All Non-BusObject Inputs Rolled into 1 file */'] };
else
    for i = 1:nin
        iIO = iIO + 1;
        lstIO(iIO,1) = { ['#define width_input' num2str(i) ' ' num2str(lstModelInputs{i,3})] };
        lstIO(iIO,2) = { [' /* ' lstModelInputs{i,1} ' */'] };
    end
end

if(flgAllOutputsReg)
    iIO = iIO + 1;
    lstIO(iIO,1) = { ['#define width_output1 ' num2str(numOutputSignals)] };
    lstIO(iIO,2) = { [' /* All Non-BusObject Outputs Rolled into 1 file */'] };
else
    for i = 1:nout
        iIO = iIO + 1;
        lstIO(iIO,1) = { ['#define width_output' num2str(i) ' ' num2str(lstModelOutputs{i,3})] };
        lstIO(iIO,2) = { [' /* ' lstModelOutputs{i,1} ' */'] };
    end
end

fstr = [fstr Cell2PaddedStr(lstIO, 'Padding', '   ') endl];
 
fstr = [fstr endl];
fstr = [fstr '/* Copied from ert_main.cpp */' endl];
fstr = [fstr str_ert endl];

fstr = [fstr 'int getline(char *line, int max, FILE *fp, int SkipOverComments)' endl];
fstr = [fstr '{' endl];
fstr = [fstr '	int flgCommentsFound = 0;' endl];
fstr = [fstr '	if (fgets(line, max, fp) == NULL) {' endl];
fstr = [fstr '		return -1;' endl];
fstr = [fstr '	}' endl];
fstr = [fstr '	else {' endl];
fstr = [fstr '		/* Comments can be either: "%", "#", or "''" */' endl];
fstr = [fstr '		flgCommentsFound = strncmp(line, "%", 1) + strncmp(line, "#", 1) + strncmp(line, "''", 1);' endl];
fstr = [fstr '		' endl];
fstr = [fstr '		if( (flgCommentsFound > 0) && (SkipOverComments == 0) )  {' endl];
fstr = [fstr '			/* Use to Recursion to keep looking for the next good line or EOF */' endl];
fstr = [fstr '			getline(line, max, fp, SkipOverComments);' endl];
fstr = [fstr '		}' endl];
fstr = [fstr '		else {' endl];
fstr = [fstr '			return strlen(line);' endl];
fstr = [fstr '		}' endl];
fstr = [fstr '      return strlen(line);' endl];
fstr = [fstr '	}' endl];
fstr = [fstr '}' endl];

if(flgAllInputsReg)
      fstr = [fstr 'void getlinevalues(char* str2parse, ExternalInputs_' strModel '* ' strModel '_U, int flgTimeIsFirst, double &curTime) {' endl];
        fstr = [fstr '	char* str;' endl];
        fstr = [fstr '	int cnt = 0;' endl];
        fstr = [fstr '	double tmp;' endl];
        fstr = [fstr '	str = strtok(str2parse, ",");	//initialize string tokenizer' endl];
        fstr = [fstr '	if(str != NULL) {' endl];
        fstr = [fstr '		if(flgTimeIsFirst == 1) {' endl];
        fstr = [fstr '			sscanf(str, "%lf", &curTime);' endl];
        fstr = [fstr '			str = strtok(NULL, ",");' endl];
        fstr = [fstr '		}' endl];
        fstr = [fstr '		else {' endl];
        fstr = [fstr '			curTime = 0.0;' endl];
        fstr = [fstr '		}' endl];
        fstr = [fstr '	}' endl];
        fstr = [fstr '	if(str != NULL) {' endl];
        
        for i = 1:nin             
            curBO_signal = lstModelInputs{i, 1};
            curBO_dim    = lstModelInputs{i, 3};
            curBO_type   = lstModelInputs{i, 4};
            
             switch curBO_type
                case {'int8'}
                    curBO_Ctype = 'signed char';
                case {'uint8'; 'boolean'}
                    curBO_Ctype = 'unsigned char';
                case {'int16'}
                    curBO_Ctype = 'int16';
                case {'uint16'}
                    curBO_Ctype = 'unsigned short';
                case {'int32'}
                    curBO_Ctype = 'int';
                case {'uint32'}
                    curBO_Ctype = 'unsigned int';
                case {'real32'}
                    curBO_Ctype = 'float';
                case {'real64'; 'double'}
                    curBO_Ctype = 'double';
                case {'uint'}
                    curBO_Ctype = 'unsigned int';
                case {'long'}
                    curBO_Ctype = 'unsigned log';
                otherwise
             end
            
             if(i == 1)
                 if(curBO_dim > 1)
                     fstr = [fstr '      sscanf(str, "%lf", &tmp); ' strModel '_U->' curBO_signal '[0] = (' curBO_Ctype ') tmp;' endl];
                 else
                     fstr = [fstr '      sscanf(str, "%lf", &tmp); ' strModel '_U->' curBO_signal ' = (' curBO_Ctype ') tmp;' endl];
                 end
             else
                 for idim = 1:curBO_dim
                     if(curBO_dim > 1)
                         fstr = [fstr '      str = strtok(NULL, ","); sscanf(str, "%lf", &tmp); ' strModel '_U->' curBO_signal '[' num2str(idim-1) '] = (' curBO_Ctype ') tmp;' endl];
                     else
                         fstr = [fstr '      str = strtok(NULL, ","); sscanf(str, "%lf", &tmp); ' strModel '_U->' curBO_signal ' = (' curBO_Ctype ') tmp;' endl];
                     end
                 end
             end
        end
        fstr = [fstr '		}' endl];
        fstr = [fstr '	}' endl];
        fstr = [fstr endl];
        
else
    
    for i = 1:nin
        strInput    = lstModelInputs{i, 1};
        strBusObject= lstModelInputs{i, 4};
        lstBO       = lstModelInputs{i, 5};
        
        fstr = [fstr 'void getlinevalues_' strInput '(char* str2parse, ' strBusObject '* ' strInput ', int flgTimeIsFirst, double &curTime) {' endl];
        fstr = [fstr '	char* str;' endl];
        fstr = [fstr '	int cnt = 0;' endl];
        fstr = [fstr '	double tmp;' endl];
        fstr = [fstr '	str = strtok(str2parse, ",");	//initialize string tokenizer' endl];
        fstr = [fstr '	if(str != NULL) {' endl];
        fstr = [fstr '		if(flgTimeIsFirst == 1) {' endl];
        fstr = [fstr '			sscanf(str, "%lf", &curTime);' endl];
        fstr = [fstr '			str = strtok(NULL, ",");' endl];
        fstr = [fstr '		}' endl];
        fstr = [fstr '		else {' endl];
        fstr = [fstr '			curTime = 0.0;' endl];
        fstr = [fstr '		}' endl];
        fstr = [fstr '	}' endl];
        fstr = [fstr '	if(str != NULL) {' endl];
        
        for iBO = 1:size(lstBO, 1)
            curBO_signal = lstBO{iBO, 1};
            curBO_dim    = lstBO{iBO, 2};
            curBO_type   = lstBO{iBO, 3};
            switch curBO_type
                case {'int8'}
                    curBO_Ctype = 'signed char';
                case {'uint8'; 'boolean'}
                    curBO_Ctype = 'unsigned char';
                case {'int16'}
                    curBO_Ctype = 'int16';
                case {'uint16'}
                    curBO_Ctype = 'unsigned short';
                case {'int32'}
                    curBO_Ctype = 'int';
                case {'uint32'}
                    curBO_Ctype = 'unsigned int';
                case {'real32'}
                    curBO_Ctype = 'float';
                case {'real64'; 'double'}
                    curBO_Ctype = 'double';
                case {'uint'}
                    curBO_Ctype = 'unsigned int';
                case {'long'}
                    curBO_Ctype = 'unsigned log';
                otherwise
            end
            
            if(iBO == 1)
                if(curBO_dim > 1)
                    fstr = [fstr '      sscanf(str, "%lf", &tmp); ' strInput '->' curBO_signal '[0] = (' curBO_Ctype ') tmp;' endl];
                else
                    fstr = [fstr '      sscanf(str, "%lf", &tmp); ' strInput '->' curBO_signal ' = (' curBO_Ctype ') tmp;' endl];
                end
            else
                for idim = 1:curBO_dim
                    if(curBO_dim > 1)
                        fstr = [fstr '      str = strtok(NULL, ","); sscanf(str, "%lf", &tmp); ' strInput '->' curBO_signal '[' num2str(idim-1) '] = (' curBO_Ctype ') tmp;' endl];
                    else
                        fstr = [fstr '      str = strtok(NULL, ","); sscanf(str, "%lf", &tmp); ' strInput '->' curBO_signal ' = (' curBO_Ctype ') tmp;' endl];
                    end
                end
            end
        end
        fstr = [fstr '		}' endl];
        fstr = [fstr '	}' endl];
        fstr = [fstr endl];
    end
end

fstr = [fstr 'int main(int argc, char* argv[])' endl];
fstr = [fstr '{' endl];

fstr = [fstr tab '/* Declare Flags for internal function ''getline'' */' endl];
fstr = [fstr tab 'int flgSkipOverComments = 1;' endl];
fstr = [fstr endl];
fstr = [fstr tab '/* Declare Parameters for internal function ''getlinevalues'' */' endl];
fstr = [fstr tab 'int flgTimeIsFirst = 1;' endl];
fstr = [fstr tab 'double curTime_sec = 0.0;' endl];
fstr = [fstr  endl];


fstr = [fstr tab '/* Declare input file pointers: */' endl];
if(flgAllInputsReg)
    fstr = [fstr tab 'FILE *fp_input;' endl];
else
    for i = 1:nin
        fstr = [fstr tab 'FILE *fp_input' num2str(i) ';' endl];
    end
end
fstr = [fstr endl];

%%
fstr = [fstr tab '/* Declare output file pointers: */' endl];
if(flgAllOutputsReg)
    fstr = [fstr tab 'FILE *fp_output;' endl];
else
    for i = 1:nout
        fstr = [fstr tab 'FILE *fp_output' num2str(i) ';' endl];
    end
end
fstr = [fstr endl];

%%
fstr = [fstr tab '/* Declare character array to hold each input string: */' endl];
if(flgAllInputsReg)
    fstr = [fstr tab 'char str_input[MAXSTRINGSIZE];' endl];
else
    for i = 1:nin
        fstr = [fstr tab 'char str_input' num2str(i) '[MAXSTRINGSIZE];' endl];
    end
end
fstr = [fstr endl];

%%
fstr = [fstr tab '/* Declare input filenames: */' endl];
if(flgAllInputsReg)
    fstr = [fstr tab 'char* filename_input = "' strModel '_Inputs' str_SL_Suffix '.txt";' endl];
else
    for i = 1:nin
        fstr = [fstr tab 'char* filename_input' num2str(i) ' = "' lstModelInputs{i,1} str_SL_Suffix '.txt";' endl];
    end
end
fstr = [fstr endl];

%%
fstr = [fstr tab '/* Declare output filenames: */' endl];
if(flgAllOutputsReg)
    fstr = [fstr tab 'char* filename_output = "' strModel '_Outputs' str_CC_Suffix '.txt";' endl];
else
    for i = 1:nout
        fstr = [fstr tab 'char* filename_output' num2str(i) ' = "' lstModelOutputs{i,1} str_CC_Suffix '.txt";' endl];
    end
end
fstr = [fstr endl];

%%
if(flgAllInputsReg)
    fstr = [fstr tab '/* Open the input file: */' endl];
else
    if(nin > 1)
        fstr = [fstr tab '/* Open the input files: */' endl];
    else
        fstr = [fstr tab '/* Open the input file: */' endl];
    end
end

%%
if(flgAllInputsReg)
    fstr = [fstr tab 'if ((fp_input = fopen(filename_input, "r")) == NULL) {' endl];
    fstr = [fstr tab tab 'printf("Error: Could not open file: %s\n", filename_input);' endl];
    fstr = [fstr tab tab 'return 0;' endl];
    fstr = [fstr tab '}' endl];
else
    for i = 1:nin
        fstr = [fstr tab 'if ((fp_input' num2str(i) ...
            ' = fopen(filename_input' num2str(i) ', "r")) == NULL) {' endl];
        fstr = [fstr tab tab 'printf("Error: Could not open file: %s\n", filename_input' num2str(i) ');' endl];
        fstr = [fstr tab tab 'return 0;' endl];
        fstr = [fstr tab '}' endl];
    end
end
fstr = [fstr endl];

%%
if(flgAllOutputsReg)
    fstr = [fstr tab '/* Open the output file: */' endl];
else
    if(nout > 1)
        fstr = [fstr tab '/* Open the output files: */' endl];
    else
        fstr = [fstr tab '/* Open the output file: */' endl];
    end
end

%%
if(flgAllOutputsReg)
    fstr = [fstr tab 'fp_output = fopen(filename_output, "w");' endl];
else
    for i = 1:nout
        fstr = [fstr tab 'fp_output' num2str(i) ' = fopen(filename_output' ...
            num2str(i) ', "w");' endl];
    end
end
fstr = [fstr endl];

%% Add Initilaize model line:
fstr = [fstr tab '/* Initialize the model: */' endl];
for i = 1:size(lst_init, 1)
    cur_line = strtrim(lst_init{i,:});
    if(i > 1)
        fstr = [fstr tab tab cur_line endl];
    else
        fstr = [fstr tab cur_line endl];
    end
end
fstr = [fstr endl];

%% Start the test loop
fstr = [fstr tab '/* Loop through each line of the CSV input file */' endl];
fstr = [fstr tab '/* Note: If the component has multiple inputs, assume that the data file for */' endl];
fstr = [fstr tab '/*       input #1 determines the total number of test points (e.g. timesteps) */' endl];
fstr = [fstr tab '/*       to test the component. */' endl];

if(flgAllInputsReg)
    fstr = [fstr tab 'while( getline(str_input, MAXSTRINGSIZE-1, fp_input, flgSkipOverComments) != -1) {' endl];
else
    fstr = [fstr tab 'while( getline(str_input1, MAXSTRINGSIZE-1, fp_input1, flgSkipOverComments) != -1) {' endl];
end
fstr = [fstr endl];

if( (~flgAllInputsReg) && (nin > 1) )
    fstr = [fstr tab tab '/* Read in input data for the component''s other inputs: */' endl];
    for i = 2:nin
        fstr = [fstr tab tab 'getline(str_input' num2str(i) ', MAXSTRINGSIZE-1, fp_input' num2str(i) ', flgSkipOverComments);' endl];
    end
    fstr = [fstr endl];
end

if( (~flgAllInputsReg) && (nin > 1) )
    fstr = [fstr tab tab '/* Parse the strings into numeric arrays: */' endl];
else
    fstr = [fstr tab tab '/* Parse the string into a numeric array: */' endl];
end

if(flgAllInputsReg)
    fstr = [fstr tab tab 'getlinevalues' ...
        '(str_input, &' strModel '_U, flgTimeIsFirst, curTime_sec);' endl];
else
    for i = 1:nin
        fstr = [fstr tab tab 'getlinevalues_' lstModelInputs{i,1} ...
            '(str_input' num2str(i) ', &' strModel '_U.' lstModelInputs{i,1} ...
            ', flgTimeIsFirst, curTime_sec);' endl];
    end
end
fstr = [fstr endl];

fstr = [fstr tab tab '/* Step the model: */' endl];
for i = 1:size(lst_step, 1)
    cur_line = strtrim(lst_step{i,:});
    if(i > 1)
        fstr = [fstr tab tab tab cur_line endl];
    else
        fstr = [fstr tab tab cur_line endl];
    end
end
fstr = [fstr endl];

fstr = [fstr tab tab '/* Record the output to CSV files: */' endl];
if(flgAllOutputsReg)
    fstr = [fstr tab tab '/* Output #: ' lstModelOutputs{i,2} ': */' endl];
    fstr = [fstr tab tab '/* Record Time First */' endl];
    
    fstr = [fstr tab tab 'if(flgTimeIsFirst == 1) {' endl];
    fstr = [fstr tab tab tab 'fprintf(fp_output, "%0.15e,", curTime_sec);' endl];
    fstr = [fstr tab tab '}' endl];
    fstr = [fstr endl];
    
    fstr = [fstr tab tab '/* Record the Output Signals */' endl];
    for i = 1:nout
        strOutput   = lstModelOutputs{i, 1};
        curDim      = lstModelOutputs{i, 3};
        curDatatype = lstModelOutputs{i, 4};
        
        switch curDatatype
            case {'double'; 'real64'; 'real32'};
                strSave = '%0.15e';
                strCast = '(double)';
            case 'boolean'
                strSave = '%d';
                strCast = '(int)';
            case {'int8'; 'int16'; 'int32'}
                strSave = '%d';
                strCast = ['(' curDatatype ')'];
            case {'uint8'; 'uint16'; 'uint32'}
                strSave = '%u';
                strCast = ['(' curDatatype ')'];
            otherwise
                strSave = '%0.15e';
                strCast = '(double)';
        end
        
        for iDim = 1:curDim
            if((i == nout) && (iDim == curDim))
                % Use the '\n'
                if(curDim > 1)
                    fstr = [fstr tab tab 'fprintf(fp_output, "' strSave '\n", ' strCast ' ' strModel '_Y.' strOutput '[' num2str(iDim-1) ']);' endl];
                else
                    fstr = [fstr tab tab 'fprintf(fp_output, "' strSave '\n", ' strCast ' ' strModel '_Y.' strOutput ');' endl];
                end
            else
                % Use a comma
                if(curDim > 1)
                    fstr = [fstr tab tab 'fprintf(fp_output, "' strSave ',", ' strCast ' ' strModel '_Y.' strOutput '[' num2str(iDim-1) ']);' endl];
                else
                    fstr = [fstr tab tab 'fprintf(fp_output, "' strSave ',", ' strCast ' ' strModel '_Y.' strOutput ');' endl];
                end
            end
        end
    end
        
else

    for i = 1:nout
        strOutput   = lstModelOutputs{i, 1};
        strBusObject= lstModelOutputs{i, 4};
        lstBO       = lstModelOutputs{i, 5};
        
        fstr = [fstr tab tab '/* Output #' num2str(i) ': ' lstModelOutputs{i,2} ': */' endl];
        fstr = [fstr tab tab '/* Record Time First */' endl];
        
        fstr = [fstr tab tab 'if(flgTimeIsFirst == 1) {' endl];
        fstr = [fstr tab tab tab 'fprintf(fp_output' num2str(i) ', "%0.15e,", curTime_sec);' endl];
        fstr = [fstr tab tab '}' endl];
        fstr = [fstr endl];
        
        fstr = [fstr tab tab '/* Record the Output Signals */' endl];

        lengthBO = size(lstBO, 1);
        numtotal = sum(cell2mat(lstBO(:,2)));
        ictr = 0;
        for iBO = 1:lengthBO
            curBO_signal = lstBO{iBO, 1};
            curBO_dim    = lstBO{iBO, 2};
            curBO_type   = lstBO{iBO, 3};
            
            for idim = 1:curBO_dim;
                ictr = ictr + 1;
                if(curBO_dim == 1)
                    if(ictr < numtotal)
                        fstr = [fstr tab tab 'fprintf(fp_output' num2str(i) ', "%0.15e,", (double) ' strModel '_Y.' strOutput '.' curBO_signal ');' endl];
                    else
                        fstr = [fstr tab tab 'fprintf(fp_output' num2str(i) ', "%0.15e\n", (double) ' strModel '_Y.' strOutput '.' curBO_signal ');' endl];
                    end
                else
                    if(ictr < numtotal)
                        fstr = [fstr tab tab 'fprintf(fp_output' num2str(i) ', "%0.15e,", (double) ' strModel '_Y.' strOutput '.' curBO_signal '[' num2str(idim-1) ']);' endl];
                    else
                        fstr = [fstr tab tab 'fprintf(fp_output' num2str(i) ', "%0.15e\n", (double) ' strModel '_Y.' strOutput '.' curBO_signal '[' num2str(idim-1) ']);' endl];
                    end
                end
            end
        end
        fstr = [fstr endl];
    end
end

fstr = [fstr tab '}' endl];
fstr = [fstr endl];

%%
if(flgAllInputsReg)
    fstr = [fstr tab '/* Close the input file: */' endl];
    fstr = [fstr tab 'fclose(fp_input);' endl];
else
    if(nin > 1)
        fstr = [fstr tab '/* Close the input files: */' endl];
    else
        fstr = [fstr tab '/* Close the input file: */' endl];
    end  
    for i = 1:nin
        fstr = [fstr tab 'fclose(fp_input' num2str(i) ');' endl];
    end
end
fstr = [fstr endl];

if(flgAllOutputsReg)
    fstr = [fstr tab '/* Close the output file: */' endl];
    fstr = [fstr tab 'fclose(fp_output);' endl];
else
    if(nout > 1)
        fstr = [fstr tab '/* Close the output files: */' endl];
    else
        fstr = [fstr tab '/* Close the output file: */' endl];
    end
    for i = 1:nout
        fstr = [fstr tab 'fclose(fp_output' num2str(i) ');' endl];
    end
end
fstr = [fstr endl];

fstr = [fstr tab 'return 0;' endl];
fstr = [fstr '}' endl];

fstr = [fstr endl];

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
info.fname = [filename strExt];

info.fname_full = [SaveFolder filesep info.fname];
info.text = fstr;

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
    disp(sprintf('%s : ''%s%s'' has been created in %s', mfnam, filename, strExt, SaveFolder));
end

TerminateSim(root_sim, flgVerbose);
%% Compile Outputs:
%	lstFiles= -1;

end % << End of function Write_CodeCheck_cpp >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110512 MWS: Created function using CreateNewFunc
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
