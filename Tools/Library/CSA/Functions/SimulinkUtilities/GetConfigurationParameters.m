% GETCONFIGURATIONPARAMETERS Gets configuration parameters from a Simulink model
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GetConfigurationParameters:
%   Gets a model's configuration parameters and Real-Time Workshop
%   options and writes them to file
% 
% SYNTAX:
%	GetConfigurationParameters(strModel, lstConfigParams)
%	GetConfigurationParameters(strModel)
%	GetConfigurationParameters()
%
% INPUTS:
%	Name                Size		Units		Description
%   strModel            'string'    [char]      Model to set configuration
%                                               parameters.  Optional.
%                                               Uses 'bdroot' if empty
%   lstConfigParamFields {nx3}
%       (:,1)           'string'    [char]      Simulink Object Parameter
%                                                Property
%       (:,2)           'string'    [char]      Configuration Parameter 
%                                                Left Side Menu (Optional)
%       (:,3)           'string'    [char]      Configuration Parameter 
%                                                Right Side Menu / Text
%                                                (Optional)
%
% OUTPUTS:
%	Name    	Size		Units		Description
%   None
%
% NOTES:
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[Out1] = GetConfigurationParameters(strModel, lstConfigParamFields)
%	% <Copy expected outputs from Command Window>
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit GetConfigurationParameters.m">GetConfigurationParameters.m</a>
%	  Driver script: <a href="matlab:edit Driver_GetConfigurationParameters.m">Driver_GetConfigurationParameters.m</a>
%	  Documentation: <a href="matlab:winopen(which('GetConfigurationParameters_Function_Documentation.pptx'));">GetConfigurationParameters_Function_Documentation.pptx</a>
%
% See also SetConfigurationParameters 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/860
%  
% Copyright Northrop Grumman Corp 2014
% Maintained by: Aerospace Systems
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/GetConfigurationParameters.m $
% $Rev: 3301 $
% $Date: 2014-11-03 16:58:16 -0600 (Mon, 03 Nov 2014) $
% $Author: sufanmi $

function GetConfigurationParameters(lstModel, varargin)

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

%% Input Argument Checking:

% lstConfigParamFields(:,1): Simulink Object Parameter Property, 'string'
% lstConfigParamFields(:,2): Configuration Parameter Left Side Menu
% lstConfigParamFields(:,3): Configuration Parameter Right Side Menu / Text
lstConfigParamFieldDefaults = {...
    'BlockReduction',               'Optimization',                                 'Simulation and code generation : Block reduction';
    'ConditionallyExecuteInputs',   'Optimization',                                 'Simulation and code generation : Conditional input branch execution';
    'BooleanDataType',              'Optimization',                                 'Simulation and code generation : Implement logic signals as Bololean data (vs. double)';
    'InlineParams',                 'Optimization',                                 'Simulation and code generation : Inline parameters';
    'OptimizeBlockIOStorage',       'Optimization',                                 'Simulation and code generation : Signal storage reuse';
    'LifeSpan',                     'Optimization',                                 'Simulation and code generation : Application lifespan (days)';
    'InlinedParameterPlacement',    'Optimization',                                 'Code generation : Parameter structure';
    'LocalBlockOutputs',            'Optimization',                                 'Code generation : Signals : Enable local block outputs';
    'BufferReuse',                  'Optimization',                                 'Code generation : Signals : Reuse block outputs';
    'EnforceIntegerDowncast',       'Optimization',                                 'Code generation : Signals : Ignore integer downcasts in folde expressions';
    'InlineInvariantSignals',       'Optimization',                                 'Code generation : Signals : Inline invariant signals';
    'ExpressionFolding',            'Optimization',                                 'Code generation : Signals : Eliminate superfluous temporary variables (Expression folding)';
    'RollThreshold',                'Optimization',                                 'Code generation : Signals : Loop unrolling threshold';
    'ZeroExternalMemoryAtStartup',  'Optimization',                                 'Code generation : Data initialization : Remove root level I/0 zero initilization';
    'InitFltsAndDblsToZero',        'Optimization',                                 'Code generation : Data initialization : Use memset to initialize floats and doubles to 0.0';
    'ZeroInternalMemoryAtStartup',  'Optimization',                                 'Code generation : Data initialization : Remove internal state zero initialization';
    'OptimizeModelRefInitCode',     'Optimization',                                 'Code generation : Data initialization : Optimize initialization code for model reference';
    'EfficientFloat2IntCast',       'Optimization',                                 'Code generation : Integer and fixed-point : Remove code from floating-point to integer conversions that wraps out-of-range values';
    'NoFixptDivByZeroProtection',   'Optimization',                                 'Code generation : Integer and fixed-point : Remove code that protects against division arithmetic exceptions';
    'StateBitsets',                 'Optimization',                                 'Code generation : Stateflow : Use bitsets for storing state configuration';
    'UseTempVars',                  'Optimization',                                 'Code generation : Stateflow : Minimize array reads using temporary variables';
    'DataBitsets',                  'Optimization',                                 'Code generation : Stateflow : Use bitsets for storing boolean data';
    
    'SystemTargetFile',             'Real-Time Workshop',                           'Target selection : System target file';
    'TargetLang',                   'Real-Time Workshop',                           'Target selection : Language';
    'GenerateReport',               'Real-Time Workshop',                           'Documentation : Generate HTML report';
    'TLCOptions',                   'Real-Time Workshop',                           'Build process : Generate makefile';
    'MakeCommand',                  'Real-Time Workshop',                           'Build process : Make command';
    'TemplateMakefile',             'Real-Time Workshop',                           'Build process : Template makefile';
    'IgnoreCustomStorageClasses',   'Real-Time Workshop',                           'Custom storage class : Ignore custom storage classes';
    'GenCodeOnly',                  'Real-Time Workshop',                           'Generate code only';
    
    'EnableCustomComments',         'Real-Time Workshop/Comments',                  'Overall control : Include comments';
    'SimulinkBlockComments',        'Real-Time Workshop/Comments',                  'Auto generated comments : Simulink block comments';
    'ShowEliminatedStatement',      'Real-Time Workshop/Comments',                  'Auto generated comments : Show eliminated blocks';
    'ForceParamTrailComments',      'Real-Time Workshop/Comments',                  'Auto generated comments : Verbose comments for SimulinkGlobal storage class';
    'InsertBlockDesc',              'Real-Time Workshop/Comments',                  'Custom comments : Simulink block descriptions';
    'SFDataObjDesc',                'Real-Time Workshop/Comments',                  'Custom comments : Stateflow object descriptions';
    'SimulinkDataObjDesc',          'Real-Time Workshop/Comments',                  'Custom comments : Simulink data object descriptions';
    'ReqsInCode',                   'Real-Time Workshop/Comments',                  'Custom comments : Requirements in block comments';
    'EnableCustomComments',         'Real-Time Workshop/Comments',                  'Custom comments : Custom comments (MPT objects only)';
    
    'CustomSymbolStrGlobalVar',     'Real-Time Workshop/Symbols',                   'Identifier format control : Global variables';
    'CustomSymbolStrType',          'Real-Time Workshop/Symbols',                   'Identifier format control : Global types';
    'CustomSymbolStrField',         'Real-Time Workshop/Symbols',                   'Identifier format control : Field name of global types';
    'CustomSymbolStrFcn',           'Real-Time Workshop/Symbols',                   'Identifier format control : Subsystem methods';
    'CustomSymbolStrTmpVar',        'Real-Time Workshop/Symbols',                   'Identifier format control : Local temporary variables';
    'CustomSymbolStrBlkIO',         'Real-Time Workshop/Symbols',                   'Identifier format control : Local block output variables';
    'CustomSymbolStrMacro',         'Real-Time Workshop/Symbols',                   'Identifier format control : Constant macros';
    'MangleLength',                 'Real-Time Workshop/Symbols',                   'Auto-generated identifier naming rules : Minimum mangle length';
    'MaxIdLength',                  'Real-Time Workshop/Symbols',                   'Auto-generated identifier naming rules : Maximum identifier length';
    'InlinedPrmAccess',             'Real-Time Workshop/Symbols',                   'Auto-generated identifier naming rules : Generate scalar inlined parameters as';
    'SignalNamingRule',             'Real-Time Workshop/Symbols',                   'Simulink data object naming rules : Signal naming';
    'ParamNamingRule',              'Real-Time Workshop/Symbols',                   'Simulink data object naming rules : Parameter naming';
    'DefineNamingRule',             'Real-Time Workshop/Symbols',                   'Simulink data object naming rules : #define naming';
    
    'CustomSourceCode',             'Real-Time Workshop/Custom Code',               'Include custom c-code in generated : Source file';
    'CustomHeaderCode',             'Real-Time Workshop/Custom Code',               'Include custom c-code in generated : Header file';
    'CustomInitializer',            'Real-Time Workshop/Custom Code',               'Include custom c-code in generated : Initialize function';
    'CustomTerminator',             'Real-Time Workshop/Custom Code',               'Include custom c-code in generated : Terminate function';
    'CustomInclude',                'Real-Time Workshop/Custom Code',               'Include list of additional : Include directories';
    'CustomSource',                 'Real-Time Workshop/Custom Code',               'Include list of additional : Source files';
    'CustomLibrary',                'Real-Time Workshop/Custom Code',               'Include list of additional : Libraries';
    
    'RTWVerbose',                   'Real-Time Workshop/Debug',                     'Build process : Verbose build';
    'RetainRTWFile',                'Real-Time Workshop/Debug',                     'Build process : Retain .rtw file';
    
    'ProfileTLC',                   'Real-Time Workshop/Debug',                     'TLC process : Profile TLC';
    'TLCDebug',                     'Real-Time Workshop/Debug',                     'TLC process : Start TLC debugger when generating code';
    'TLCCoverage',                  'Real-Time Workshop/Debug',                     'TLC process : Start TLC coverage when generating code';
    'TLCAssertion',                 'Real-Time Workshop/Debug',                     'TLC process : Enable TLC assertion';
    
    'GenFloatMathFcnCalls',         'Real-Time Workshop/Interface',                 'Software environment : Target floating-point math environment';
    'UtilityFuncGeneration',        'Real-Time Workshop/Interface',                 'Software environment : Utility function generation';
    'PurelyIntegerCode',            'Real-Time Workshop/Interface',                 'Software environment : Support floating-point numbers';
    'SupportNonFinite',             'Real-Time Workshop/Interface',                 'Software environment : Support non-finite numbers';
    'SupportComplex',               'Real-Time Workshop/Interface',                 'Software environment : Support complex numbers';
    'SupportAbsoluteTime',          'Real-Time Workshop/Interface',                 'Software environment : Support absolute time';
    'SupportContinuousTime',        'Real-Time Workshop/Interface',                 'Software environment : Support continuous time';
    'SupportNonInlinedSFcns',       'Real-Time Workshop/Interface',                 'Software environment : Support non-inlined S-functions';
    'GRTInterface',                 'Real-Time Workshop/Interface',                 'Code interface : GRT compatible call interface';
    'CombineOutputUpdateFcns',      'Real-Time Workshop/Interface',                 'Code interface : Single output/update function';
    'IncludeMdlTerminateFcn',       'Real-Time Workshop/Interface',                 'Code interface : Terminate function required';
    'MultiInstanceERTCode',         'Real-Time Workshop/Interface',                 'Code interface : Generate reusable code';
    'SuppressErrorStatus',          'Real-Time Workshop/Interface',                 'Code interface : Suppress error status in real-time model data structure';
    'GenerateErtSFunction',         'Real-Time Workshop/Interface',                 'Verification : Create Simulink (S-Function) block';
    'PortableWordSizes',            'Real-Time Workshop/Interface',                 'Verification : Enable portable word sizes';
    'MatFileLogging',               'Real-Time Workshop/Interface',                 'MAT-file logging';
    'RTWCAPISignals',               'Real-Time Workshop/Interface',                 'Data exchange : C-API Interface Option : Signals in C API';
    'RTWCAPIParams',                'Real-Time Workshop/Interface',                 'Data exchange : C-API Interface Option : Parameters in C API';
    'ExtMode',                      'Real-Time Workshop/Interface',                 'Data exchange : External mode Option';
    'GenerateASAP2',                'Real-Time Workshop/Interface',                 'Data exchange : ASAP2 Interface Option';
    
    'ParenthesesLevel',             'Real-Time Workshop/Code Style',                'Code Style : Parentheses level';
    'PreserveExpressionOrder',      'Real-Time Workshop/Code Style',                'Code Style : Preserve operand order in expression';
    'PreserveIfCondition',          'Real-Time Workshop/Code Style',                'Code Style : Preserve condition expression in if statement';
    
    'ERTSrcFileBannerTemplate',     'Real-Time Workshop/Templates',                 'Code Templates : Source file (*.c) template';
    'ERTHdrFileBannerTemplate',     'Real-Time Workshop/Templates',                 'Code Templates : Header file (*.h) template';
    'ERTDataSrcFileTemplate',       'Real-Time Workshop/Templates',                 'Data Templates : Source file (*.c) template';
    'ERTDataHdrFileTemplate',       'Real-Time Workshop/Templates',                 'Data Templates : Header file (*.h) template';
    'ERTCustomFileTemplate',        'Real-Time Workshop/Templates',                 'Custom templates : File customization template';
    'GenerateSampleERTMain',        'Real-Time Workshop/Templates',                 'Custom templates : Generate an example main program';
    
    'GlobalDataDefinition',         'Real-Time Workshop/Data Placement',            'Global data placement (custom storage classes only) : Data definition';
    'GlobalDataReference',          'Real-Time Workshop/Data Placement',            'Global data placement (custom storage classes only) : Data declaration';
    'IncludeFileDelimiter',         'Real-Time Workshop/Data Placement',            'Global data placement (custom storage classes only) : #include file delimter';
    'ModuleNamingRule',             'Real-Time Workshop/Data Placement',            'Global data placement (MPT data objects only) : Module naming';
    'SignalDisplayLevel',           'Real-Time Workshop/Data Placement',            'Global data placement (MPT data objects only) : Signal display level';
    'ParamTuneLevel',               'Real-Time Workshop/Data Placement',            'Global data placement (MPT data objects only) : Parameter tune level';
    
    'EnableUserReplacementTypes',   'Real-Time Workshop/Data Type Replacement',     'Replace datatype names in the generated code';
    'MemSecPackage',                'Real-Time Workshop/Memory Sections',           'Package containing memory sections for model data and functions : Package';
    };

[SaveFolder, varargin]              = format_varargin('SaveFolder', '', 2, varargin);
[WriteMFile, varargin]              = format_varargin('WriteMFile', true, 2, varargin);
[WriteXLSFile, varargin]            = format_varargin('WriteXLSFile', true, 2, varargin);
[XLSFilename, varargin]             = format_varargin('XLSFilename', 'ConfigParams.xlsx', 2, varargin);
[OpenAfterWrite, varargin]          = format_varargin('OpenAfterWrite', true, 2, varargin);
[lstConfigParamFields, varargin]    = format_varargin('ConfigParamFields', lstConfigParamFieldDefaults, 2, varargin);

if(~iscell(lstConfigParamFields))
    lstConfigParamFields = { lstConfigParamFields };
end

if(nargin < 1) || isempty(lstModel)
    lstModel = bdroot;
end

%% Main Code
if( ~iscell(lstModel) )
    lstModel = { lstModel };
end

tab  = sprintf('    ');% One Tab (set to 4 spaces)
verML = version('-release');

numModels = size(lstModel, 1);
for iModel = 1:numModels
    strModel = lstModel{iModel, 1};
    
    strNum = sprintf('[%d/%d]: ', iModel, numModels);
    disp(sprintf('%s : %sGetting Configuration Parameters for ''%s''...', ...
        mfilename, strNum, strModel));
    
    load_system(strModel);
    lstConfigParams = {};
    objParams = get_param(strModel, 'ObjectParameters');

    % lstConfigParams(:,1): Simulink Object Parameter Property, 'string'
    % lstConfigParams(:,2): Simulink Object Parameter Value, varies
    % lstConfigParams(:,3): Configuration Parameter Left Side Menu
    % lstConfigParams(:,4): Configuration Parameter Right Side Menu / Text
    [numConfigParams, numCol] = size(lstConfigParamFields);
    i = 0;

    if(iModel == 1)
        % Add the header information
        tbl = {}; itbl = 0;
        itbl = itbl + 1; 
        tbl(itbl, 1) = { 'Configuration Parameter Left Side Menu' };
        tbl(itbl, 2) = { 'Configuration Parameter Right Side Menu / Text' };
        tbl(itbl, 3) = { 'Simulink Object Parameter Property, ''string''' };
%         tbl(itbl, 4) = { 'Simulink Object Parameter Value, varies' };
    end
    
    tbl(itbl, 3+iModel) = { strModel };

    for iConfigParam = 1:numConfigParams
        curProp         = lstConfigParamFields{iConfigParam, 1};
        curLeftMenu     = lstConfigParamFields{iConfigParam, 2};
        curRightMenu    = lstConfigParamFields{iConfigParam, 3};

        if(iModel == 1)
            tbl(itbl + iConfigParam, 1) = { curLeftMenu };
            tbl(itbl + iConfigParam, 2) = { curRightMenu };
            tbl(itbl + iConfigParam, 3) = { curProp };
        end
        
        if(isfield(objParams, curProp))
            curValue = get_param(strModel, curProp);
            
            i = i + 1;
            lstConfigParams(i,1) = {tab};
            lstConfigParams(i,2) = {['''' curProp ''',']};
            if(isnumeric(curValue))
                lstConfigParams(i,3) = {[num2str(curValue) ',']};
                tbl(itbl + iConfigParam, 3+iModel) = { num2str(curValue) };
            else
                lstConfigParams(i,3) = {['''' curValue ''',']};
                tbl(itbl + iConfigParam, 3+iModel) = { curValue };
            end
            lstConfigParams(i,4) = {['''' curLeftMenu ''',']};
            lstConfigParams(i,5) = {['''' curRightMenu ''';']};
            
            
            %         disp(sprintf('%s : [%d/%d]: Setting %s : %s to %s...', ...
            %             mfilename, iConfigParam, numConfigParams, curLeftMenu, curRightMenu, strValue));
        else
            strSpaces = char(ones(1,length(strNum))*spc);     
            disp(sprintf('%s  %s [%d/%d]: Error getting %s : %s.  Property ''%s'' does NOT exist in this version of MATLAB (R%s).  Ignoring.', ...
                mfspc, strSpaces, iConfigParam, numConfigParams, curLeftMenu, curRightMenu, curProp, verML));
            
            i = i + 1;
            lstConfigParams(i,1) = {tab};
            lstConfigParams(i,2) = {['% ''' curProp ''',']};
            lstConfigParams(i,3) = {['''<< N/A >>'',']};
            lstConfigParams(i,4) = {['''' curLeftMenu ''',']};
            lstConfigParams(i,5) = {['''' curRightMenu ''' <-- Not in MATLAB R' verML]};
            
            tbl(itbl + iConfigParam, 3+iModel) = { ['Not in R' verML] };
            
        end
    end
    
    strFilenameModel = which(strModel);

    if(WriteMFile)
        if(isempty(SaveFolder))
            MFileSaveFolder = fileparts(strFilenameModel);
        end
        
        if(~isdir(MFileSaveFolder))
            mkdir(MFileSaveFolder);
        end
        
        strMFileFilename = [MFileSaveFolder filesep strModel '_ConfigParams.m'];
        
        fid = fopen(strMFileFilename, 'w');
        if(fid == -1)
            disp(sprintf('%s : ERROR : File ''%s'' could not be opened for writing.  Ignoring...', ...
                mfilename, strMFileFilename));
        else
            
            fprintf(fid, 'strModel = ''%s'';\n', strModel);
            fprintf(fid, 'verMATLAB = ''R%s''; %% Note: MATLAB version not required to use SetConfigurationParameters (Info Only)\n', verML);
            fprintf(fid, 'flgCheckOnly = 1;     %% 1/true: Do not overwrite, 0/false: Allow overwrite\n');
            fprintf(fid, '%% lstConfigParams(:,1): Simulink Object Parameter Property, ''string''\n');
            fprintf(fid, '%% lstConfigParams(:,2): Simulink Object Parameter Value, varies\n');
            fprintf(fid, '%% lstConfigParams(:,3): Configuration Parameter Left Side Menu\n');
            fprintf(fid, '%% lstConfigParams(:,4): Configuration Parameter Right Side Menu / Text\n');
            
            fprintf(fid, 'lstConfigParams = {...\n');
            strTxt = Cell2PaddedStr(lstConfigParams, 'Padding', ' ', 'SpaceAfterPad', 1);
            fprintf(fid, '%s', strTxt);
            fprintf(fid, '};\n');
            
            fprintf(fid, 'SetConfigurationParameters(strModel, lstConfigParams, flgCheckOnly);\n');
            fclose(fid);
            if(OpenAfterWrite)
                edit(strMFileFilename);
            end
        end
    end   
end

if(WriteXLSFile)
    if(isempty(SaveFolder))
        SaveFolder = pwd;
    end
    
    if(~isdir(SaveFolder))
        mkdir(SaveFolder);
    end

    strXLSFilename = [SaveFolder filesep XLSFilename];
    if(exist(strXLSFilename))
        delete(strXLSFilename);
    end
    
    xlswrite(strXLSFilename, tbl);
            
    if(OpenAfterWrite)
        winopen(strXLSFilename);
    end
end

end % << End of function >>

%% DISTRIBUTION:
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C., Sec 2751,
%   et seq.) or the Export Administration Act of 1979 (Title 50, U.S.C.,
%   App. 2401 et set.), as amended. Violations of these export laws are
%   subject to severe criminal penalties.  Disseminate in accordance with
%   provisions of DoD Direction 5230.25.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
