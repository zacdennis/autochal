% WRITE_RTCF_MODEL_WRAP_CPP Writes RTCF Wrapper .cpp file for a Simulink Model
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Write_RTCF_BusObject_header:
%   This function writes the RTCF wrapper (.cpp) for a code-generated
%   Simulink block.  It is a supporting function of Write_RTCF_Wrapper.m
%   and is not intended for independent usage.
% 
% SYNTAX:
%	strFilename = Write_RTCF_Model_wrap_cpp(strModel, lstModelInputs, lstModelOutputs, lstInitVars, lstStepVars, blockRate, varargin, 'PropertyName', PropertyValue)
%	strFilename = Write_RTCF_Model_wrap_cpp(strModel, lstModelInputs, lstModelOutputs, lstInitVars, lstStepVars, blockRate, varargin)
%	strFilename = Write_RTCF_Model_wrap_cpp(strModel, lstModelInputs, lstModelOutputs, lstInitVars, lstStepVars, blockRate)
%
% INPUTS: 
%	Name        	Size		Units		Description
%	strModel        'string'    [char]      Name of Simulink model or block
%                                           being code generated
%   lstModelInputs {Mx3}        N/A
%    lstModelInputs{:,1}        'string'    Root name of model input
%    lstModelInputs{:,2}        'string'    Variable type
%    lstModelInputs{:,3}        [int]       Variable dimensions (only
%                                           needed if type is NOT a bus 
%                                           object
%   lstModelOutputs {Mx3}       N/A
%    lstModelOutputs{:,1}       'string'    Root name of model output
%    lstModelOutputs{:,2}       'string'    Variable type
%    lstModelOutputs{:,3}       [int]       Variable dimensions (only
%                                           needed if type is NOT a bus 
%                                           object
%   lstInitVars     {'string'}  N/A         Cell array of strings with the
%                                           root names of the generated
%                                           functions 'initialize' function
%                                           inputs
%   lstStepVars     {'string'}  N/A         Cell array of strings with the
%                                           root names of the generated
%                                           functions 'step' function
%                                           inputs
%   blockRate       [1]         [Hz]        Sample rate (or 1/Sample Time)
%                                           to use for generated model.
%	varargin        [N/A]		[varies]	Optional function inputs that
%                                           should be entered in pairs.
%                                           See the 'VARARGIN' section
%                                           below for more details
%
% OUTPUTS: 
%	Name        	Size		Units		Description
%	strFilename     'string'    [char]      Name of Generated File
%
% NOTES:
%	This function is supported by a number of CSA_Library utility functions
%	like: format_varargin, CenterChars, & Cell2PaddedStr
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'MarkingsFile'      'string'        'CreateNewFile_Defaults'
%                                                   MATLAB .m file
%                                                   containing requisite
%                                                   program markings
%   'SaveFolder'        'string'        pwd         Folder in which to save
%                                                   generated file
%   'OpenAfterCreated'  [bool]          true        Open the generated
%                                                   files in MATLAB's
%                                                   editor after creation?
%   'ClassName'         'string'        strModel    Name to use for wrapper
%                                                   class
%   'InputStructName'   'string'        'IN'        Name to use for top
%                                                    -level RTCF input
%                                                    structure
%   'OutputStructName'  'string'        'OUT'       Name to use for top
%                                                    -level RTCF output
%                                                    structure
%
% EXAMPLES:
%   % See 'SampleSim_MPMgr.mdl' and 'CodeGen_SampleSim.m' for full example
%   % Sample: Create wrapper source file for Sample Sim's Mass Property Manager
%   strModel = 'SampleSim_MPMgr';
%   lstModelInputs  = {'SampleSim_MPInputs'   'CSampleSim_MPInputs'   []};
%   lstModelOutputs = {'SampleSim_MPStates'   'CSampleSim_MPStates'   []};
%   lstInitVars     = { 'SampleSim_MPMgr_M';
%                       'SampleSim_MPMgr_DWork';
%                       'SampleSim_MPMgr_U';
%                       'SampleSim_MPMgr_Y' };
%   lstStepVars     = { 'SampleSim_MPMgr_M';
%                       'SampleSim_MPMgr_DWork';
%                       'SampleSim_MPMgr_U';
%                       'SampleSim_MPMgr_Y' };
%   BlockRate       = 100;  % [Hz]
%   MarkingsFile    = 'CreateNewFile_Defaults';
%   Write_RTCF_Model_wrap_cpp(strModel, lstModelInputs, lstModelOutputs, ...
%       lstInitVars, lstStepVars, BlockRate, 'MarkingsFile', MarkingsFile);
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Write_RTCF_Model_wrap_cpp.m">Write_RTCF_Model_wrap_cpp.m</a>
%	  Driver script: <a href="matlab:edit Driver_Write_RTCF_Model_wrap_cpp.m">Driver_Write_RTCF_Model_wrap_cpp.m</a>
%	  Documentation: <a href="matlab:pptOpen('Write_RTCF_Model_wrap_cpp_Function_Documentation.pptx');">Write_RTCF_Model_wrap_cpp_Function_Documentation.pptx</a>
%
% See also Write_RTCF_Wrapper, format_varargin, CenterChars, Cell2PaddedStr
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/628
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function strFilename = Write_RTCF_Model_wrap_cpp(strModel, lstModelInputs, lstModelOutputs, lstInitVars, lstStepVars, blockRate, varargin)

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
%	No Outputs Specified
strFilename = '';

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);
[MarkingsFile, varargin]    = format_varargin('MarkingsFile', 'CreateNewFile_Defaults',  2, varargin);
[SaveFolder, varargin]      = format_varargin('SaveFolder', pwd,  2, varargin);
[OpenAfterCreated, varargin]= format_varargin('OpenAfterCreated', true,  2, varargin);
[strClassName, varargin]    = format_varargin('ClassName', strModel,  2, varargin);
[UsePointers, varargin]     = format_varargin('UsePointers', false,  2, varargin);
[strVersionTag, varargin]   = format_varargin('VersionTag', '', 0, varargin);
[InputStructName, varargin] = format_varargin('InputStructName', 'IN',  3, varargin);
[OutputStructName, varargin]= format_varargin('OutputStructName', 'OUT',  3, varargin);

%% Load in Default Markings:
if(exist(MarkingsFile) == 2)
    eval_str = ['CNF_info = ' MarkingsFile '(''// '', mfnam);'];
    eval(eval_str);
end

%% ========================================================================
%  Generate File 1 of 2: _wrap.h
fstr = ['// Simulink header file: ' strModel '_wrap.cpp' endl];

%% Header Classified Lines
if ~isempty(CNF_info.Classification)
    fstr = [fstr '// ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Header ITAR Lines
if ~isempty(CNF_info.ITAR)
    fstr = [fstr '// ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Header Proprietary Lines
if ~isempty(CNF_info.Proprietary)
    fstr = [fstr '// ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Copyright
if(isfield(CNF_info, 'Copyright'))
    if(~isempty(CNF_info.Copyright))
        fstr = [fstr '//' endl];
        fstr = [fstr CNF_info.Copyright];
    end
end

if(~isempty(strVersionTag))
    fstr = [fstr '//' endl];
    fstr = [fstr '// Version: ' strVersionTag endl];
end

fstr = [fstr '//' endl];
fstr = [fstr '// Purpose: Declarations contained in this file define functionality' endl];
fstr = [fstr '//          required to interface C/C++ code generated from the Simulink' endl];
fstr = [fstr '//          model/block ''' strModel '''' endl];
fstr = [fstr '//          to the RTCF infastructure.' endl];
fstr = [fstr '//' endl];
fstr = [fstr '// This header file was auto-generated using ''' mfnam '.m''' endl];
fstr = [fstr endl];

% includes
fstr = [fstr '#include "CLSAPI.h"' endl];
fstr = [fstr '#include <string.h>' endl];
fstr = [fstr '#include <stdlib.h>' endl];
fstr = [fstr '#include "rtwtypes.h"' endl];
fstr = [fstr '#include "' strModel '_wrap.h"' endl];

fstr = [fstr endl];
flg_datafile_exists = (exist([SaveFolder filesep strModel '_data.cpp']) == 2);
if(flg_datafile_exists)
    fstr = [fstr 'extern Parameters_' strModel ' ' strModel '_P_dflt;' endl];
    fstr = [fstr endl];
end

%% Build wrap.cpp lists
%  These cell array lists will be converted to nicely formatted strings
%  further down below prior to being written to the new file
lstDeclare = {}; iDec = 0;
iDec = iDec + 1;
lstDeclare(iDec,1) = {['C' strClassName '_wrap::C' strClassName '_wrap( void ) :']};
iDec = iDec - 1;

tblConn = {}; iConn = 1;
tblConn(iConn, 1) = {tab}; tblConn(iConn, 2) = {'// Inputs'};
lstGet = {}; iGet = 0;
lstSet = {}; iSet = 0;

%%
nin     = size(lstModelInputs, 1);
nout    = size(lstModelOutputs, 1);

iConnIn = 0; iConnOut = 0;

%% Loop through the input buses
for iin = 1:nin
    curRoot     = lstModelInputs{iin, 1};
    curType     = lstModelInputs{iin, 2};
    curDim      = lstModelInputs{iin, 3};
    curCodeName = lstModelInputs{iin, 4};
    curConnName = lstModelInputs{iin, 6};
    flgBus      = isempty(curDim);

    % Update lstDeclare
    flgAddDec = 0;
    if(flgBus)
        flgAddDec = 1;    
        strDec = ['m_' curRoot '  ( m_' strModel '_U.' curRoot ' )'];
    else
        if(curDim > 1)
            flgAddDec = 1;
            strDec = ['m_' curRoot '(' num2str(curDim) ')'];
        else
            % Don't have to declare it
%             strDec = ['m_' curRoot];
        end
    end
    
    if(flgAddDec)
        iDec = iDec + 1;
        strDec = [strDec ','];
        lstDeclare(iDec,2) = {strDec};
    end
    
    % Update tblConn
    iConn = iConn + 1;
    tblConn(iConn, 1) = {tab};
    if(UsePointers)
        tblConn(iConn, 2) = { ['add_conn( m_' curRoot ' = new ' curType ','] };
    else
        tblConn(iConn, 2) = { ['add_conn( &m_' curRoot ','] };
    end
    
    tblConn(iConn, 3) = { ['"' curConnName '" );'] };
    
    %% Update lstSet
    if(0)   % Old method that doesn't quite work right
        lstSet(iin, 1) = {tab};
        lstSet(iin, 2) = {['m_' curRoot]};
        
        if( (flgBus) || (~flgBus && (curDim > 1)) )
            lstSet(iin, 3) = {['.Get(  m_' strModel '_U.' curCodeName ' );']};
        else
            
            if(UsePointers)
                lstSet(iin, 3) = {['->Get( &m_' strModel '_U.' curCodeName ' );']};
            else
                lstSet(iin, 3) = {['.Get( &m_' strModel '_U.' curCodeName ' );']};
            end
        end
    end
    
    %% Update lstSet
    lstSet(iin, 1) = {tab};
    lstSet(iin, 2) = {['m_' strModel '_U.' curCodeName]};
    lstSet(iin, 3) = {['= m_' curRoot '->Get();']};
    
    
    
end

% Add in the DataInValid Connection
iConn = iConn + 1;
tblConn(iConn, 1) = {tab};
tblConn(iConn, 2) = { ['add_conn( m_' strModel '_DataInValid_flg = new CCLSBool,'] };

if(isempty(InputStructName))
    tblConn(iConn, 3) = { ['"' strModel '_DataInValid_flg" );'] };
else
    tblConn(iConn, 3) = { ['"' InputStructName '.' strModel '_DataInValid_flg" );'] };
end

iConn = iConn + 1;
iConn = iConn + 1;
tblConn(iConn, 1) = {tab}; tblConn(iConn, 2) = {'// Outputs'};

%% Loop through the output buses
for iout = 1:nout
    curRoot     = lstModelOutputs{iout, 1};
    curType     = lstModelOutputs{iout, 2};
    curDim      = lstModelOutputs{iout, 3};
    curCodeName = lstModelOutputs{iout, 4};
    curConnName = lstModelOutputs{iout, 6};
    flgBus      = isempty(curDim);
    
    % Update lstDeclare
    flgAddDec = 0;
    if(flgBus)
        flgAddDec = 1;
        strDec = ['m_' curRoot '  ( m_' strModel '_Y.' curRoot ' )'];
    else
        if(curDim > 1)
            flgAddDec = 1;
            strDec = ['m_' curRoot '(' num2str(curDim) ')'];
        else
            % Don't worry about declaring it
%             strDec = ['m_' curRoot];
        end
    end
        
    if(flgAddDec)
        iDec = iDec + 1;
        strDec = [strDec ','];      
        lstDeclare(iDec,2) = {strDec};
    end
    
    % Update tblConn
    iConn = iConn + 1;
    tblConn(iConn, 1) = {tab};
    if(UsePointers)
        tblConn(iConn, 2) = { ['add_conn( m_' curRoot ' = new ' curType ','] };
    else
        tblConn(iConn, 2) = { ['add_conn( &m_' curRoot ','] };
    end

    tblConn(iConn, 3) = { ['"' curConnName '" );'] };
   
    % Update lstPut
    lstPut(iout, 1) = {tab};
    lstPut(iout, 2) = {['m_' curRoot]};
    
    if(UsePointers)
        lstPut(iout, 3) = {['->Put( m_' strModel '_Y.' curCodeName ' );']};
    else
        lstPut(iout, 3) = {['.Put( m_' strModel '_Y.' curCodeName ' );']};
    end
end

% Declaration fix, strip off the comma after the last declaration
if exist('strDec')
    strDec = strDec(1:end-1);
    lstDeclare(iDec,2) = {strDec};
else
    lstDeclare{1,1} = lstDeclare{1,1}(1:end-1);
end

% Add in the DataOutValid Connection
iConn = iConn + 1;
tblConn(iConn, 1) = {tab};
tblConn(iConn, 2) = { ['add_conn( m_' strModel '_DataOutValid_flg = new CCLSBool,'] };

if(isempty(InputStructName))
    tblConn(iConn, 3) = { ['"' strModel '_DataOutValid_flg" );'] };
else
    tblConn(iConn, 3) = { ['"' OutputStructName '.' strModel '_DataOutValid_flg" );'] };
end

fstr = [fstr Cell2PaddedStr(lstDeclare)];
fstr = [fstr '{' endl];
fstr = [fstr tab '// Define Component Rate, [Hz]:' endl];
fstr = [fstr tab 'set_rate( ' num2str(blockRate) ' );' endl];
fstr = [fstr endl];

% Addin Connect Data
fstr = [fstr Cell2PaddedStr(tblConn)];
fstr = [fstr endl];

if(flg_datafile_exists)
    fstr = [fstr tab '// Set Default Parameters Values' endl];
    fstr = [fstr tab 'm_' strModel '_P = ' strModel '_P_dflt;' endl];
    fstr = [fstr endl];
end

fstr = [fstr tab '// Do First-Time Initialization of Autocode' endl];

lstInit = {}; iInit = 1;
lstInit(iInit, 1) = {tab};
lstInit(iInit, 2) = {[strModel '_initialize(']};

numInputs = size(lstInitVars, 1);
for iInput = 1:numInputs
    curVarName = lstInitVars{iInput,1};
    strInput = ['&m_' curVarName];
    if(iInput < numInputs)
        strInput = [strInput ','];
    else
        strInput = [strInput ');'];
    end
    if(iInput ~= 1)
        iInit = iInit + 1;
    end
    lstInit(iInit, 3) = { strInput };
end
fstr = [fstr Cell2PaddedStr(lstInit)];

%% Default characteristics
fstr = [fstr endl];
fstr = [fstr tab '// Default Characteristics' endl];
fstr = [fstr tab 'initDefaultParams();' endl];
fstr = [fstr '}' endl];
fstr = [fstr endl];

%% set_inputs
fstr = [fstr 'void C' strModel '_wrap::set_inputs( void )' endl];
fstr = [fstr '{' endl];
fstr = [fstr Cell2PaddedStr(lstSet)];
fstr = [fstr '}' endl];
fstr = [fstr endl];

%% set_outputs
fstr = [fstr 'void C' strModel '_wrap::set_outputs( void )' endl];
fstr = [fstr '{' endl];
fstr = [fstr Cell2PaddedStr(lstPut)];
fstr = [fstr '}' endl];
fstr = [fstr endl];

%% initDefaultParams
fstr = [fstr 'void C' strModel '_wrap::initDefaultParams( void )' endl];
fstr = [fstr '{' endl];
fstr = [fstr '}' endl];
fstr = [fstr endl];

%% Trim
fstr = [fstr 'HRESULT C' strModel '_wrap::Trim( void )' endl];
fstr = [fstr '{' endl];
fstr = [fstr tab '// Always return S_OK' endl];
fstr = [fstr tab 'return S_OK;' endl];
fstr = [fstr '}' endl];
fstr = [fstr endl];

%% Initialize
fstr = [fstr 'HRESULT C' strModel '_wrap::Initialize( VARIANT arg )' endl];
fstr = [fstr '{' endl];
fstr = [fstr tab '// Always return S_OK' endl];
fstr = [fstr tab 'return S_OK;' endl];
fstr = [fstr '}' endl];
fstr = [fstr endl];

%% Model_Run
fstr = [fstr 'HRESULT C' strModel '_wrap::' strModel '_Run( void )' endl];
fstr = [fstr '{' endl];
fstr = [fstr tab 'set_inputs();' endl];
fstr = [fstr endl];
fstr = [fstr tab 'if ( m_' strModel '_DataInValid_flg->Get() == VARIANT_TRUE )' endl];
fstr = [fstr tab '{' endl];

lstRun = {}; iRun = 1;
lstRun(iRun, 1) = {tab};
lstRun(iRun, 2) = {tab};
lstRun(iRun, 3) = {[strModel '_step(']};

numInputs = size(lstStepVars, 1);
for iInput = 1:numInputs
    curVarName = lstStepVars{iInput,1};
    if(strcmp(curVarName, 'tid'))
        strInput = ['m_' curVarName];
    else
        strInput = ['&m_' curVarName];
    end
    if(iInput < numInputs)
        strInput = [strInput ','];
    else
        strInput = [strInput ');'];
    end
    if(iInput ~= 1)
        iRun = iRun + 1;
    end
    lstRun(iRun, 4) = { strInput };
end

fstr = [fstr Cell2PaddedStr(lstRun)];
fstr = [fstr tab '}' endl];
fstr = [fstr tab 'set_outputs();' endl];
fstr = [fstr endl];
fstr = [fstr tab '// Always return S_OK' endl];
fstr = [fstr tab 'return S_OK;' endl];
fstr = [fstr '}' endl];
fstr = [fstr endl];

%% Run
fstr = [fstr 'HRESULT C' strModel '_wrap::Run( void )' endl];
fstr = [fstr '{' endl];
fstr = [fstr tab strModel '_Run();' endl];
fstr = [fstr endl];
fstr = [fstr tab '// Always return S_OK' endl];
fstr = [fstr tab 'return S_OK;' endl];
fstr = [fstr '}' endl];
fstr = [fstr endl];

%% C_EXPORT
fstr = [fstr 'C_EXPORT ICLSComponent* New_' strModel '_wrap ( ICLSMainProgram* main )' endl];
fstr = [fstr '{' endl];
fstr = [fstr tab '::CLSMain = main;' endl];
fstr = [fstr tab 'return new C' strModel '_wrap;' endl];
fstr = [fstr '}' endl];
fstr = [fstr endl];

%% Footer
% Order is reversed from header
% DistributionStatement,ITARparagraph Proprietary ITAR, Classification

% Distribution Statement
if ~isempty(CNF_info.DistibStatement)
    fstr = [fstr CNF_info.DistibStatement endl];
    fstr = [fstr endl];
end

% Itar Paragraph
if ~isempty(CNF_info.ITAR_Paragraph)
    fstr = [fstr CNF_info.ITAR_Paragraph];
end
fstr = [fstr '//' endl];

% Footer Proprietary Lines
if ~isempty(CNF_info.Proprietary)
    fstr = [fstr '// ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

% Footer ITAR Lines
if ~isempty(CNF_info.ITAR)
    fstr = [fstr '// ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

% Footer Classified Lines
if ~isempty(CNF_info.Classification)
    fstr = [fstr '// ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Write the file
info.fname = [strModel '_wrap.cpp'];
info.fname_full = [SaveFolder filesep info.fname];
info.text = fstr;

if(~isdir(SaveFolder))
    mkdir(SaveFolder);
end

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

    strFilename = info.fname_full;
end

end % << End of function Write_RTCF_Model_wrap_cpp >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101124 MWS: Created function using CreateNewFunc
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
