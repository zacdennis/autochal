% WRITE_RTCF_MODEL_WRAP_H Writes RTCF Wrapper .h file for a Simulink Model
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Write_RTCF_Model_warp_h:
%   This function writes the RTCF wrapper's header file (.h) for a
%   code-generated Simulink model or block.  It is a supporting function of
%   Write_RTCF_Wrapper.m and is not intended for independent usage.
% 
% SYNTAX:
%	strFilename = Write_RTCF_Model_wrap_h(strModel, lstFuncInputs, lstModelInputs, lstModelOutputs, varargin, 'PropertyName', PropertyValue)
%	strFilename = Write_RTCF_Model_wrap_h(strModel, lstFuncInputs, lstModelInputs, lstModelOutputs, varargin)
%
% INPUTS: 
%	Name        	Size		Units		Description
%	strModel        'string'    [char]      Name of Simulink model or block
%                                           being code generated
%   lstFuncInputs  {Nx2}       N/A          Cell array list of Function's
%                                           input variable types and names
%    lstFuncInputs{:,1}        'string'     Variable name
%    lstFuncInputs{:,2}        'string'     Variable type
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
%	varargin	[N/A]		[varies]        Optional function inputs that
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
%
% EXAMPLES:
%   % See 'SampleSim_MPMgr.mdl' and 'CodeGen_SampleSim.m' for full example
%   % Sample: Create wrapper header file for Sample Sim's Mass Property Manager
%   strModel = 'SampleSim_MPMgr';
%   lstFuncInputs = {
%     'SampleSim_MPMgr_P'       'Parameters_SampleSim_MPMgr'
%     'SampleSim_MPMgr_DWork'   'D_Work_SampleSim_MPMgr'  
%     'SampleSim_MPMgr_U'       'ExternalInputs_SampleSim_MPMgr'
%     'SampleSim_MPMgr_Y'       'ExternalOutputs_SampleSim_MPMgr'
%     'SampleSim_MPMgr_M'       'RT_MODEL_SampleSim_MPMgr' };
%   lstModelInputs  = {'SampleSim_MPInputs'   'CSampleSim_MPInputs'   []};
%   lstModelOutputs = {'SampleSim_MPStates'   'CSampleSim_MPStates'   []};
%   MarkingsFile = 'CreateNewFile_Defaults';
%	Write_RTCF_Model_wrap_h(strModel, lstFuncInputs, lstModelInputs, lstModelOutputs, 'MarkingsFile', MarkingsFile);
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Write_RTCF_Model_wrap_h.m">Write_RTCF_Model_wrap_h.m</a>
%	  Driver script: <a href="matlab:edit Driver_Write_RTCF_Model_wrap_h.m">Driver_Write_RTCF_Model_wrap_h.m</a>
%	  Documentation: <a href="matlab:pptOpen('Write_RTCF_Model_wrap_h_Function_Documentation.pptx');">Write_RTCF_Model_wrap_h_Function_Documentation.pptx</a>
%
% See also format_varargin, CenterChars, Cell2PaddedStr 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/629
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function strFilename = Write_RTCF_Model_wrap_h(strModel, ...
    lstFuncInputs, lstModelInputs, lstModelOutputs, varargin)

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
[UsePointers, varargin]     = format_varargin('UsePointers', false,  2, varargin);
[strVersionTag, varargin]   = format_varargin('VersionTag', '', 0, varargin);


%% Load in Default Markings:
if(exist(MarkingsFile) == 2)
    eval_str = ['CNF_info = ' MarkingsFile '(''// '', mfnam);'];
    eval(eval_str);
end

%% ========================================================================
%  Generate File 1 of 2: _wrap.h
fstr = ['// Simulink header file: ' strModel '_wrap.h' endl];

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

% ifndef/define
fstr = [fstr '#ifndef _' upper(strModel) 'WRAP_H_' endl];
fstr = [fstr '#define _' upper(strModel) 'WRAP_H_' endl];
fstr = [fstr endl];

% includes
for i = 1:size(lstModelInputs, 1);
    curBus = lstModelInputs{i, 1};
    curDim = lstModelInputs{i, 3};
    if( (~isempty(curBus)) && (isempty(curDim)) )
        fstr = [fstr '#include "' curBus '.h"' endl];
    end
end
for i = 1:size(lstModelOutputs, 1);
    curBus = lstModelOutputs{i, 1};
    curDim = lstModelOutputs{i, 3};
    if( (~isempty(curBus)) && (isempty(curDim)) )
        fstr = [fstr '#include "' curBus '.h"' endl];
    end
end

fstr = [fstr '#include "' strModel '_types.h"' endl];
fstr = [fstr '#include "' strModel '.h"' endl];
fstr = [fstr endl];

% class
fstr = [fstr 'class C' strModel '_wrap : public CCLSComponent' endl];
fstr = [fstr '{' endl];
fstr = [fstr 'public:' endl];
fstr = [fstr tab 'C' strModel '_wrap( void );' endl];
fstr = [fstr tab 'virtual HRESULT STDMETHODCALLTYPE Initialize( VARIANT arg );' endl];
fstr = [fstr tab 'virtual HRESULT STDMETHODCALLTYPE Trim( void );' endl];
fstr = [fstr tab 'virtual HRESULT STDMETHODCALLTYPE Run( void );' endl];
fstr = [fstr tab 'virtual HRESULT STDMETHODCALLTYPE ' strModel '_Run( void );' endl];
fstr = [fstr endl];
fstr = [fstr 'protected:' endl];
fstr = [fstr tab 'void set_inputs( void );' endl];
fstr = [fstr tab 'void set_outputs( void );' endl];
fstr = [fstr tab 'void initDefaultParams( void );' endl];
fstr = [fstr endl];

lstData = {}; iData = 0;

iData = iData + 1;
lstData(iData, 1) = {tab};
lstData(iData, 2) = {'// Function Inputs'};

for iVar = 1:size(lstFuncInputs, 1)
    curVarName = lstFuncInputs{iVar,1};
    curVarType = lstFuncInputs{iVar,2};
    
    
    iData = iData + 1;
    lstData(iData, 1) = {tab};
    lstData(iData, 2) = {curVarType};
    
    if(~isempty(curVarName))
        lstData(iData, 3) = {['m_' curVarName ';']};
    end
end

% Model Inputs
iData = iData + 1;
iData = iData + 1;
lstData(iData, 1) = {tab};
lstData(iData, 2) = {['// ' strModel ' Inputs']};
for i = 1:size(lstModelInputs, 1);
    curInputRoot = lstModelInputs{i, 1};
    curInputType = lstModelInputs{i, 2};
    if(UsePointers)
       curInputType = [curInputType ' *']; 
    end
    
    iData = iData + 1;
    lstData(iData, 1) = {tab};
    lstData(iData, 2) = {curInputType};
    lstData(iData, 3) = {['m_' curInputRoot ';']};
end

% Model Outputs
iData = iData + 1;
iData = iData + 1;
lstData(iData, 1) = {tab};
lstData(iData, 2) = {['// ' strModel ' Outputs']};
for i = 1:size(lstModelOutputs, 1);
    curOutputRoot = lstModelOutputs{i, 1};
    curOutputType = lstModelOutputs{i, 2};
     
    if(UsePointers)
       curOutputType = [curOutputType ' *']; 
    end
        
    iData = iData + 1;
    lstData(iData, 1) = {tab};
    lstData(iData, 2) = {curOutputType};
    lstData(iData, 3) = {['m_' curOutputRoot ';']};
end

iData = iData + 1;
iData = iData + 1;
lstData(iData, 1) = {tab};
lstData(iData, 2) = {'// Data Validity Flags'};
iData = iData + 1;
lstData(iData, 1) = {tab};
lstData(iData, 2) = {'CCLSBool'};
lstData(iData, 3) = {['*m_' strModel '_DataInValid_flg;']};
iData = iData + 1;
lstData(iData, 1) = {tab};
lstData(iData, 2) = {'CCLSBool'};
lstData(iData, 3) = {['*m_' strModel '_DataOutValid_flg;']};

fstr = [fstr Cell2PaddedStr(lstData, 'Padding', ' ') endl];

fstr = [fstr '};' endl];
fstr = [fstr '#endif' endl];
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
info.fname = [strModel '_wrap.h'];
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

end % << End of function Write_RTCF_Model_wrap_h >>

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
