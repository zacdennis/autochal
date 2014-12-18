% SETCONFIGURATIONPARAMETERS Sets configuration parameters
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% SetConfigurationParameters:
%     Sets a model's configuration parameters and Real-Time Workshop
%     options in preparation of generating auto-code
%
% SYNTAX:
%	SetConfigurationParameters(strModel, lstConfigParams)
%	SetConfigurationParameters(strModel)
%	SetConfigurationParameters()
%
% INPUTS:
%	Name                Size		Units		Description
%   strModel            'string'    [char]      Model to set configuration
%                                               parameters.  Optional.
%                                               Uses 'bdroot' if empty
%   lstConfigParams     {nx4}
%       (:,1)           'string'    [char]      Simulink Object Parameter
%                                                Property
%       (:,2)           [varies]    [varies]    Simulink Object Parameter
%                                                Value
%       (:,3)           'string'    [char]      Configuration Parameter
%                                                Left Side Menu (Optional)
%       (:,4)           'string'    [char]      Configuration Parameter
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
%	[Out1] = SetConfigurationParameters(strModel, lstConfigParams, flgCheckOnly)
%	% <Copy expected outputs from Command Window>
%
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit SetConfigurationParameters.m">SetConfigurationParameters.m</a>
%	  Driver script: <a href="matlab:edit Driver_SetConfigurationParameters.m">Driver_SetConfigurationParameters.m</a>
%	  Documentation: <a href="matlab:winopen(which('SetConfigurationParameters_Function_Documentation.pptx'));">SetConfigurationParameters_Function_Documentation.pptx</a>
%
% See also GetConfigurationParameters
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/861
%
% Copyright Northrop Grumman Corp 2014
% Maintained by: Aerospace Systems
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/SetConfigurationParameters.m $
% $Rev: 3303 $
% $Date: 2014-11-04 16:50:51 -0600 (Tue, 04 Nov 2014) $
% $Author: sufanmi $

function SetConfigurationParameters(lstModels, varargin)

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
% lstConfigParamDefaults(:,1): Simulink Object Parameter Property, 'string'
% lstConfigParamDefaults(:,2): Simulink Object Parameter Value, varies
% lstConfigParamDefaults(:,3): Configuration Parameter Left Side Menu
% lstConfigParamDefaults(:,4): Configuration Parameter Right Side Menu / Text
lstConfigParamDefaults = {...
    'BlockReduction',               'on',               'Optimization',                 'Simulation and code generation : Block reduction';
    'ConditionallyExecuteInputs',   'on',               'Optimization',                 'Simulation and code generation : Conditional input branch execution';
    'BooleanDataType',              'on',               'Optimization',                 'Simulation and code generation : Implement logic signals as Bololean data (vs. double)';
    'InlineParams',                 'on',               'Optimization',                 'Simulation and code generation : Inline parameters';
    'OptimizeBlockIOStorage',       'on',               'Optimization',                 'Simulation and code generation : Signal storage reuse';
    'LifeSpan',                     'inf',              'Optimization',                 'Simulation and code generation : Application lifespan (days)';
    'InlinedParameterPlacement',    'NonHierarchical',  'Optimization',                 'Code generation : Parameter structure';
    'LocalBlockOutputs',            'on',               'Optimization',                 'Code generation : Signals : Enable local block outputs';
    'BufferReuse',                  'off',              'Optimization',                 'Code generation : Signals : Reuse block outputs';
    'EnforceIntegerDowncast',       'on',               'Optimization',                 'Code generation : Signals : Ignore integer downcasts in folde expressions';
    'InlineInvariantSignals',       'off',              'Optimization',                 'Code generation : Signals : Inline invariant signals';
    'ExpressionFolding',            'on',               'Optimization',                 'Code generation : Signals : Eliminate superfluous temporary variables (Expression folding)';
    'RollThreshold',                5,                  'Optimization',                 'Code generation : Signals : Loop unrolling threshold';
    'ZeroExternalMemoryAtStartup',  'on',               'Optimization',                 'Code generation : Data initialization : Remove root level I/0 zero initilization';
    'InitFltsAndDblsToZero',        'off',              'Optimization',                 'Code generation : Data initialization : Use memset to initialize floats and doubles to 0.0';
    'ZeroInternalMemoryAtStartup',  'on',               'Optimization',                 'Code generation : Data initialization : Remove internal state zero initialization';
    'OptimizeModelRefInitCode',     'on',               'Optimization',                 'Code generation : Data initialization : Optimize initialization code for model reference';
    'EfficientFloat2IntCast',       'off',              'Optimization',                 'Code generation : Integer and fixed-point : Remove code from floating-point to integer conversions that wraps out-of-range values';
    'NoFixptDivByZeroProtection',   'off',              'Optimization',                 'Code generation : Integer and fixed-point : Remove code that protects against division arithmetic exceptions';
    'StateBitsets',                 'off',              'Optimization',                 'Code generation : Stateflow : Use bitsets for storing state configuration';
    'UseTempVars',                  'off',              'Optimization',                 'Code generation : Stateflow : Minimize array reads using temporary variables';
    'DataBitsets',                  'off',              'Optimization',                 'Code generation : Stateflow : Use bitsets for storing boolean data';
    
    'SystemTargetFile',             'ert.tlc',          'Real-Time Workshop',           'Target selection : System target file';
    'TargetLang',                   'C',                'Real-Time Workshop',           'Target selection : Language';
    'GenerateReport',               'off',              'Real-Time Workshop',           'Documentation : Generate HTML report';
    'TLCOptions',                   '',                 'Real-Time Workshop',           'Build process : Generate makefile';
    'MakeCommand',                  'make_rtw',         'Real-Time Workshop',           'Build process : Make command';
    'TemplateMakefile',             'ert_vc.tmf',       'Real-Time Workshop',           'Build process : Template makefile';
    'TemplateMakefile',             'off',              'Real-Time Workshop',           'Custom storage class : Ignore custom storage classes';
    'GenCodeOnly',                  'on',               'Real-Time Workshop',           'Generate code only';
    
    'EnableCustomComments',         'on',               'Real-Time Workshop/Comments',  'Overall control : Include comments';
    'SimulinkBlockComments',        'on',               'Real-Time Workshop/Comments',  'Auto generated comments : Simulink block comments';
    'ShowEliminatedStatement',      'on',               'Real-Time Workshop/Comments',  'Auto generated comments : Show eliminated blocks';
    'ForceParamTrailComments',      'on',               'Real-Time Workshop/Comments',  'Auto generated comments : Verbose comments for SimulinkGlobal storage class';
    'InsertBlockDesc',              'on',               'Real-Time Workshop/Comments',  'Custom comments : Simulink block descriptions';
    'SFDataObjDesc',                'on',               'Real-Time Workshop/Comments',  'Custom comments : Stateflow object descriptions';
    'SimulinkDataObjDesc',          'on',               'Real-Time Workshop/Comments',  'Custom comments : Simulink data object descriptions';
    'ReqsInCode',                   'on',               'Real-Time Workshop/Comments',  'Custom comments : Requirements in block comments';
    'EnableCustomComments',         'on',               'Real-Time Workshop/Comments',  'Custom comments : Custom comments (MPT objects only)';
    
    'CustomSymbolStrGlobalVar',     '$R$N$M',           'Real-Time Workshop/Symbols',   'Identifier format control : Global variables';
    'CustomSymbolStrType',          '$N$R$M',           'Real-Time Workshop/Symbols',   'Identifier format control : Global types';
    'CustomSymbolStrField',         '$N$M',             'Real-Time Workshop/Symbols',   'Identifier format control : Field name of global types';
    'CustomSymbolStrFcn',           '$R$N$M$F',         'Real-Time Workshop/Symbols',   'Identifier format control : Subsystem methods';
    'CustomSymbolStrTmpVar',        '$N$M',             'Real-Time Workshop/Symbols',   'Identifier format control : Local temporary variables';
    'CustomSymbolStrBlkIO',         'rtb_$N$M',         'Real-Time Workshop/Symbols',   'Identifier format control : Local block output variables';
    'CustomSymbolStrMacro',         '$R$N$M',           'Real-Time Workshop/Symbols',   'Identifier format control : Constant macros';
    'MangleLength',                 1,                  'Real-Time Workshop/Symbols',   'Auto-generated identifier naming rules : Minimum mangle length';
    'MaxIdLength',                  99,                 'Real-Time Workshop/Symbols',   'Auto-generated identifier naming rules : Maximum identifier length';
    'InlinedPrmAccess',             'Macros',           'Real-Time Workshop/Symbols',   'Auto-generated identifier naming rules : Generate scalar inlined parameters as';
    'SignalNamingRule',             'None',             'Real-Time Workshop/Symbols',   'Simulink data object naming rules : Signal naming';
    'ParamNamingRule',              'None',             'Real-Time Workshop/Symbols',   'Simulink data object naming rules : Parameter naming';
    'DefineNamingRule',             'UpperCase',        'Real-Time Workshop/Symbols',   'Simulink data object naming rules : #define naming';
    
    'RTWVerbose',                   'on',               'Real-Time Workshop/Debug',     'Build process : Verbose build';
    'RetainRTWFile',                'on',               'Real-Time Workshop/Debug',     'Build process : Retain .rtw file';
    
    'ProfileTLC',                   'off',              'Real-Time Workshop/Debug',     'TLC process : Profile TLC';
    'TLCDebug',                     'off',              'Real-Time Workshop/Debug',     'TLC process : Start TLC debugger when generating code';
    'TLCCoverage',                  'off',              'Real-Time Workshop/Debug',     'TLC process : Start TLC coverage when generating code';
    'TLCAssertion',                 'off',              'Real-Time Workshop/Debug',     'TLC process : Enable TLC assertion';
    
    'CustomSourceCode',            '',                  'Real-Time Workshop/Custom Code',           'Include custom c-code in generated : Source file';
    'CustomHeaderCode',            '',                  'Real-Time Workshop/Custom Code',           'Include custom c-code in generated : Header file';
    'CustomInitializer',           '',                  'Real-Time Workshop/Custom Code',           'Include custom c-code in generated : Initialize function';
    'CustomTerminator',            '',                  'Real-Time Workshop/Custom Code',           'Include custom c-code in generated : Terminate function';
    'CustomInclude',               '',                  'Real-Time Workshop/Custom Code',           'Include list of additional : Include directories';
    'CustomSource',                '',                  'Real-Time Workshop/Custom Code',           'Include list of additional : Source files';
    'CustomLibrary',               '',                  'Real-Time Workshop/Custom Code',           'Include list of additional : Libraries';
    
    
    'GenFloatMathFcnCalls',         'ANSI_C',           'Real-Time Workshop/Interface', 'Software environment : Target floating-point math environment';
    'UtilityFuncGeneration',        'Shared location',  'Real-Time Workshop/Interface', 'Software environment : Utility function generation';
    'PurelyIntegerCode',            'on',               'Real-Time Workshop/Interface', 'Software environment : Support floating-point numbers';
    'SupportNonFinite',             'on',               'Real-Time Workshop/Interface', 'Software environment : Support non-finite numbers';
    'SupportComplex',               'on',               'Real-Time Workshop/Interface', 'Software environment : Support complex numbers';
    'SupportAbsoluteTime',          'on',               'Real-Time Workshop/Interface', 'Software environment : Support absolute time';
    'SupportContinuousTime',        'on',               'Real-Time Workshop/Interface', 'Software environment : Support continuous time';
    'SupportNonInlinedSFcns',       'off',              'Real-Time Workshop/Interface', 'Software environment : Support non-inlined S-functions';
    'GRTInterface',                 'off',              'Real-Time Workshop/Interface', 'Code interface : GRT compatible call interface';
    'CombineOutputUpdateFcns',      'on',               'Real-Time Workshop/Interface', 'Code interface : Single output/update function';
    'IncludeMdlTerminateFcn',       'off',              'Real-Time Workshop/Interface', 'Code interface : Terminate function required';
    'MultiInstanceERTCode',         'off',              'Real-Time Workshop/Interface', 'Code interface : Generate reusable code';
    'SuppressErrorStatus',          'off',              'Real-Time Workshop/Interface', 'Code interface : Suppress error status in real-time model data structure';
    'GenerateErtSFunction',         'off',              'Real-Time Workshop/Interface', 'Verification : Create Simulink (S-Function) block';
    'PortableWordSizes',            'off',              'Real-Time Workshop/Interface', 'Verification : Enable portable word sizes';
    'MatFileLogging',               'off',              'Real-Time Workshop/Interface',             'MAT-file logging';
    'RTWCAPISignals',               'off',              'Real-Time Workshop/Interface',             'Data exchange : C-API Interface Option : Signals in C API';
    'RTWCAPIParams',                'off',              'Real-Time Workshop/Interface',             'Data exchange : C-API Interface Option : Parameters in C API';
    'ExtMode',                      'off',              'Real-Time Workshop/Interface',             'Data exchange : External mode Option';
    'GenerateASAP2',                'off',              'Real-Time Workshop/Interface',             'Data exchange : ASAP2 Interface Option';
    
    
    'ParenthesesLevel',             'Nominal',          'Real-Time Workshop/Code Style','Code Style : Parentheses level';
    'PreserveExpressionOrder',      'off',              'Real-Time Workshop/Code Style','Code Style : Preserve operand order in expression';
    'PreserveIfCondition',          'off',              'Real-Time Workshop/Code Style','Code Style : Preserve condition expression in if statement';
    
    'ERTSrcFileBannerTemplate',     'jucas_ert_code_template.cgt',      'Real-Time Workshop/Templates',                 'Code Templates : Source file (*.c) template';
    'ERTHdrFileBannerTemplate',     'jucas_ert_header_template.cgt',    'Real-Time Workshop/Templates',                 'Code Templates : Header file (*.h) template';
    'ERTDataSrcFileTemplate',       'jucas_ert_code_template.cgt',      'Real-Time Workshop/Templates',                 'Data Templates : Source file (*.c) template';
    'ERTDataHdrFileTemplate',       'jucas_ert_header_template.cgt',    'Real-Time Workshop/Templates',                 'Data Templates : Header file (*.h) template';
    'ERTCustomFileTemplate',        'example_file_process.tlc',         'Real-Time Workshop/Templates',                 'Custom templates : File customization template';
    'GenerateSampleERTMain',        'off',                              'Real-Time Workshop/Templates',                 'Custom templates : Generate an example main program';
    
    'GlobalDataDefinition',         'Auto',                             'Real-Time Workshop/Data Placement',            'Global data placement (custom storage classes only) : Data definition';
    'GlobalDataReference',          'Auto',                             'Real-Time Workshop/Data Placement',            'Global data placement (custom storage classes only) : Data declaration';
    'IncludeFileDelimiter',         'Auto',                             'Real-Time Workshop/Data Placement',            'Global data placement (custom storage classes only) : #include file delimter';
    'ModuleNamingRule',             'Unspecified',                      'Real-Time Workshop/Data Placement',            'Global data placement (MPT data objects only) : Module naming';
    'SignalDisplayLevel',           10,                                 'Real-Time Workshop/Data Placement',            'Global data placement (MPT data objects only) : Signal display level';
    'ParamTuneLevel',               10,                                 'Real-Time Workshop/Data Placement',            'Global data placement (MPT data objects only) : Parameter tune level';
    
    'EnableUserReplacementTypes',   'off',                              'Real-Time Workshop/Data Type Replacement',     'Replace datatype names in the generated code';
    'MemSecPackage',                '--- None ---',                     'Real-Time Workshop/Memory Sections',           'Package containing memory sections for model data and functions : Package';
    };

[lstConfigParams, varargin]         = format_varargin('ConfigParams', lstConfigParamDefaults, 2, varargin);
[LoadFromXLSFile, varargin]         = format_varargin('LoadFromXLSFile', 0, 2, varargin);
[XLSFilename, varargin]             = format_varargin('XLSFilename', '', 2, varargin);
[XLSTab, varargin]                  = format_varargin('XLSTab', 'Sheet1', 2, varargin);
[idx_XLS_LeftSideMenu, varargin]    = format_varargin('idx_XLS_LeftSideMenu', 1, 2, varargin);
[idx_XLS_RightSideMenu, varargin]   = format_varargin('idx_XLS_RightSideMenu', 2, 2, varargin);
[idx_XLS_Parameter, varargin]       = format_varargin('idx_XLS_Parameter', 3, 2, varargin);
[idx_XLS_Value_Raw, varargin]       = format_varargin('idx_XLS_Value', [], 2, varargin);
[flgCheckOnly, varargin]            = format_varargin('CheckOnly', 0, 2, varargin);
[flgVerbose, varargin]              = format_varargin('Verbose', 1, 2, varargin);

if(nargin < 1) || isempty(lstModels)
    lstModels = bdroot;
end

if( ~iscell(lstModels) )
    lstModels = { lstModels };
end

%% Main Code
numModels = size(lstModels, 1);
for iModel = 1:numModels
    strModel = lstModels{iModel, 1};
    
    if(size(lstModels, 2) > 1)
        idx_XLS_Value_Raw = lstModels{iModel, 2};
    end
    
    if(LoadFromXLSFile)
        lstConfigParams = {};
        if(~exist(XLSFilename))
            disp(sprintf('%s : ERROR : ''%s'' does not exist.', ...
                mfilename, XLSFilename));
        else
            [~, XLSFilenameShort, XLSExt] = fileparts(XLSFilename);          
            [~, ~, tblRaw] = xlsread(XLSFilename, XLSTab);
            [nRow, nCol] = size(tblRaw);
            
            lstConfigParams(:,1) = tblRaw(2:end,idx_XLS_Parameter);
            lstConfigParams(:,3) = tblRaw(2:end,idx_XLS_LeftSideMenu);
            lstConfigParams(:,4) = tblRaw(2:end,idx_XLS_RightSideMenu);
            
            if(isempty(idx_XLS_Value_Raw))
                lstHeader = tblRaw(1,:)';
                idx_XLS_Value = max(strcmp(lstHeader, strModel).*[1:nCol]');
            else
                idx_XLS_Value = idx_XLS_Value_Raw;
            end
            
            disp(sprintf('%s : Using ''%s%s'' (Sheet ''%s'', Column %d - ''%s'') to set the ''%s'' Simulink Object Parameters...', ...
                mfilename, XLSFilenameShort, XLSExt, XLSTab, ...
                idx_XLS_Value, lstHeader{idx_XLS_Value}, strModel));
            
            for iRow = 2:nRow
                cur_XLS_Value = tblRaw{iRow, idx_XLS_Value};
                if(isnan(cur_XLS_Value))
                    cur_XLS_Value = '';
                end
                lstConfigParams{iRow-1, 2} = cur_XLS_Value;
            end
        end
    end
    
    %% Now Update or Analyze the Parameters:
    load_system(strModel);
    
    objParams = get_param(strModel, 'ObjectParameters');
    iMatch = 0;
    iDiffer = 0;
    iIgnore = 0;
    
    % lst(:,1): Simulink Object Parameter Property, 'string'
    % lst(:,2): Simulink Object Parameter Value, varies
    % lst(:,3): Configuration Parameter Left Side Menu
    % lst(:,4): Configuration Parameter Right Side Menu / Text
    [numConfigParams, numCol] = size(lstConfigParams);
    for iConfigParam = 1:numConfigParams
        strIntro = sprintf('%s : [%2.0f/%2.0f]', mfilename, iConfigParam, numConfigParams);
        
        curProp         = lstConfigParams{iConfigParam, 1};
        curValue        = lstConfigParams{iConfigParam, 2};
        
        if(isnumeric(curValue))
            strValue = num2str(curValue);
        else
            strValue = curValue;
        end
        
        if(numCol > 2)
            curLeftMenu = lstConfigParams{iConfigParam, 3};
        else
            curLeftMenu = '';
        end
        
        if(numCol > 3)
            curRightMenu = lstConfigParams{iConfigParam, 4};
        else
            curRightMenu = '';
        end
        
        if(isfield(objParams, curProp))
            curValueRef = get_param(strModel, curProp);
            if(isnumeric(curValueRef))
                flgMatch = (curValueRef == curValue);
                strValueRef = num2str(curValueRef);
            else
                if(isnumeric(curValue))
                    flgMatch = strcmp(curValueRef, num2str(curValue));
                else
                    flgMatch = strcmp(curValueRef, curValue);
                end
                strValueRef = curValueRef;
            end
            
            if(flgMatch)
                iMatch = iMatch + 1;
            else
                iDiffer = iDiffer + 1;
            end
            
            if(flgCheckOnly)
                if(flgMatch)
                    if(flgVerbose)
                        disp(sprintf('%s: Settings MATCH for %s : %s...', strIntro, curLeftMenu, curRightMenu));
                    end
                else
                    if(flgVerbose)
                        disp(sprintf('%s: Settings DIFFER for %s : %s...', strIntro, curLeftMenu, curRightMenu));
                    end
                    
                    ptrChar10 = strfind(strValue, char(10));
                    ptrChar10Ref = strfind(strValueRef, char(10));
                    
                    if( isempty(ptrChar10) && isempty(ptrChar10Ref) )
                        if(flgVerbose)
                            disp(sprintf('%s  Current is ''%s'' while proposed is ''%s''...', ...
                                spaces(length(strIntro)), strValueRef, strValue));
                        end
                    else
                        
                        cellValueRef    = str2cell(strValueRef, char(10));
                        if(isempty(cellValueRef))
                            if(flgVerbose)
                                disp(sprintf('%s  Current is ''''', spaces(length(strIntro))));
                            end
                        else
                            numRows = size(cellValueRef, 1);
                            for iRow = 1:numRows
                                if(flgVerbose)
                                    if(iRow == 1)
                                        disp(sprintf('%s  Current is ''%s''', spaces(length(strIntro)), cellValueRef{iRow,:}));
                                    else
                                        disp(sprintf('%s             ''%s''', spaces(length(strIntro)), cellValueRef{iRow,:}));
                                    end
                                end
                            end
                        end
                        
                        cellValue = str2cell(strValue, char(10));
                        if(isempty(cellValue))
                            if(flgVerbose)
                                disp(sprintf('%s  Proposed is ''''', spaces(length(strIntro))));
                            end
                        else
                            numRows = size(cellValue, 1);
                            for iRow = 1:numRows
                                if(flgVerbose)
                                    if(iRow == 1)
                                        disp(sprintf('%s  Proposed is ''%s''', spaces(length(strIntro)), cellValue{iRow,:}));
                                    else
                                        disp(sprintf('%s              ''%s''', spaces(length(strIntro)), cellValue{iRow,:}));
                                    end
                                end
                            end
                        end
                    end
                end
                
            else
                if(flgVerbose)
                    disp(sprintf('%s: Setting %s : %s to %s...', strIntro, curLeftMenu, curRightMenu, strValue));
                end
                set_param(strModel, curProp, strValue);
                if(~flgMatch)
                    ptrChar10Ref = strfind(strValueRef, char(10));
                    if( isempty(ptrChar10Ref) )
                        if(flgVerbose)
                            disp(sprintf('%s: Note that previous value was set to %s...', ...
                                spaces(length(strIntro)), strValueRef));
                        end
                        
                    else
                        if(flgVerbose)
                            cellValueRef    = str2cell(strValueRef, char(10));
                            numRows = size(cellValueRef, 1);
                            for iRow = 1:numRows
                                if(iRow == 1)
                                    disp(sprintf('%s: Note that previous value was set to %s', spaces(length(strIntro)), cellValueRef{iRow,:}));
                                else
                                    disp(sprintf('%s                                      %s', spaces(length(strIntro)), cellValueRef{iRow,:}));
                                end
                            end
                        end
                    end
                end
            end
            
        else
            if(flgVerbose)
                disp(sprintf('%s: Error setting %s : %s.  Property does NOT exist in this version of MATLAB.  Ignoring.', ...
                    strIntro, curLeftMenu, curRightMenu));
            end
            iIgnore = iIgnore + 1;
        end
    end
    
    if(flgCheckOnly)
        if(flgVerbose)
            disp(sprintf('%s: ''%s'' Check complete!  %d/%d MATCH, %d/%d DIFFER, %d IGNORED\n', ...
                mfilename, strModel, iMatch, (iMatch+iDiffer), ...
                iDiffer, (iMatch+iDiffer), iIgnore));
        end
    else
        if(flgVerbose)
            disp(sprintf('%s: Finished setting Configuration Parameters for %s\n', mfilename, strModel));
        end
    end
end

%% Finished

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
