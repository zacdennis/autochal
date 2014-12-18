% RTW_CONFIG Sets Real-Time Workshop configuration parameters for VSim
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% RTW_config:
%     Sets a model's configuration parameters and Real-Time Workshop
%     options in preparation of generating 'ert.tlc' C++ auto-code that can
%     be integrated into the Real Time Component Framework (RTCF).
%
% SYNTAX:
%	RTW_config(strModel, varargin, 'PropertyName', PropertyValue)
%	RTW_config(strModel, varargin)
%	RTW_config(strModel)
%
% INPUTS: 
%	Name    	Size		Units		Description
%   strModel    'string'    [char]      Name of current simulation 
%                                       (e.g. output of gcs)
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%   None
%
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName    PropertyValue   Default		Description
%   'CodeTemplate'  'string'        'ert_code_template.cgt'
%                                               Template to use for
%                                               generating code
%   'Report'        'string'        'on'        Build & Launch HTML report?
% EXAMPLES:
%	% <Enter Description of Example #1>
%	RTW_config(strModel, varargin)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit RTW_config.m">RTW_config.m</a>
%	  Driver script: <a href="matlab:edit Driver_RTW_config.m">Driver_RTW_config.m</a>
%	  Documentation: <a href="matlab:pptOpen('RTW_config_Function_Documentation.pptx');">RTW_config_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/112
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CodeGen/RTW_config.m $
% $Rev: 2342 $
% $Date: 2012-07-09 19:44:14 -0500 (Mon, 09 Jul 2012) $
% $Author: sufanmi $

function [] = RTW_config(strModel, varargin)

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
[CodeTemplate, varargin]  = format_varargin('CodeTemplate', 'ert_code_template.cgt', 2, varargin);
[strReport, varargin]  = format_varargin('Report', 'on', 2, varargin);
strReport = 'off';

%% Main Function:

%% Solver
set_param(strModel, 'StartTime', '0.0');    % Start time

%% Data Import/Export
%  Save to workspace
set_param(strModel, 'SaveTime',         'off'); % Time
set_param(strModel, 'SaveState',        'off'); % States   
set_param(strModel, 'SaveOutput',       'off'); % Output
set_param(strModel, 'SignalLogging',    'on'); % Signal logging
set_param(strModel, 'DSMLogging',       'off'); % Data stores
%  Save options
set_param(strModel, 'LimitDataPoints',  'off'); % Limid data points to last

%% Optimization
%  Simulation and code generation
set_param(strModel, 'BlockReduction', 'off');               % Block reduction
set_param(strModel, 'ConditionallyExecuteInputs', 'off');   % Conditional input branch execution
set_param(strModel, 'BooleanDataType', 'on');               % Implment logic signals as Bololean data (vs. double)
% set_param(strModel, 'InlineParams', 'on');                 % Inline parameters
set_param(strModel, 'InlineParams', 'off');                 % Inline parameters

set_param(strModel, 'LifeSpan', 'inf');                       % Application lifespan (days)
%  Code Generation
%  Signals

if(strcmp(get_param(strModel, 'InlineParams'), 'on'))
    set_param(strModel, 'PassReuseOutputArgsAs', 'Individual arguments');   % Pass reusable subsystem outputs as
end

% set_param(strModel, 'PassReuseOutputArgsAs', 'Structure reference');  % Pass reusable subsystem outputs as
% set_param(strModel, 'RollThreshold', '2');            % This setting is to prevent a code generation bug (#534529)

%  Integer and Fixed Point
%   Remove code from floating-point to integer conversion with saturation
%   that maps NaN to zero
set_param(strModel, 'NoFixptDivByZeroProtection', 'off');

%% Diagnostic
%  Diagnostics / Connectivity
set_param(strModel, 'BusObjectLabelMismatch', 'error');

%  Diagnostics / Model Referencing
set_param(strModel, 'ModelReferenceVersionMismatchMessage', 'warning');
set_param(strModel, 'ModelReferenceIOMismatchMessage', 'error');
set_param(strModel, 'ModelReferenceCSMismatchMessage', 'warning');
set_param(strModel, 'ModelReferenceIOMsg', 'error');
set_param(strModel, 'ModelReferenceDataLoggingMessage', 'error');

% Diagnostics / Data Validity / Detec overflow
set_param(strModel, 'IntegerOverflowMsg', 'none');


%% Model Referencing
%  <TBD>

%% Simulation Target
%  Simulation Target / General
set_param(strModel, 'SimBuildMode', 'sf_nonincremental_build');

%% Real-Time Workshop

%%  Real-Time Workshop / General
%   Target selection
set_param(strModel, 'SystemTargetFile', 'ert.tlc');     % System target file
set_param(strModel, 'TargetLang', 'C++');               % Language

%   Code Generation Advisor
set_param(strModel, 'GenCodeOnly', 'on');               % Generate code only

%%  Real-Time Workshop / Report
%   Report/General
set_param(strModel, 'GenerateReport', strReport);
set_param(strModel, 'LaunchReport', strReport);
%   Report/Navigation
set_param(strModel, 'IncludeHyperlinkInReport', strReport);
set_param(strModel, 'GenerateTraceInfo', strReport);
%   Report/Traceability Report Contents
set_param(strModel, 'GenerateTraceReport', strReport);
set_param(strModel, 'GenerateTraceReportSl', strReport);
set_param(strModel, 'GenerateTraceReportSf', strReport);
set_param(strModel, 'GenerateTraceReportEml', strReport);

%%  Real-Time Workshop / Comments
%   Comments/Custom comments
set_param(strModel, 'InsertBlockDesc',      'on'); % Simulink block dscriptions
set_param(strModel, 'SimulinkDataObjDesc',  'on'); % Simulink data object descriptions

%% Real-Time Workshop / Symbols
%  Auto-generated identifier naming rules / Indentifier format control
set_param(strModel, 'CustomSymbolStrGlobalVar', '$R$N$M');  % Global variables
set_param(strModel, 'CustomSymbolStrType',      '$N$R$M');  % Global types
set_param(strModel, 'CustomSymbolStrField',     '$N$M');    % Field name of global types
set_param(strModel, 'CustomSymbolStrFcn',       '$N$M');    % Subsystem methods
set_param(strModel, 'CustomSymbolStrFcnArg',    '$N$M');    % Subsystem method arguments
set_param(strModel, 'CustomSymbolStrTmpVar',    '$N$M');    % Local temporary variables
set_param(strModel, 'CustomSymbolStrBlkIO',     '$N$M');    % Local block output variables
set_param(strModel, 'CustomSymbolStrMacro',     '$N$M');    % Constant macros
set_param(strModel, 'MangleLength',             '5');       % Minimum mangle length
set_param(strModel, 'MaxIdLength',              '99');      % Maximum identifier length

%% Real-Time Workshop / Interface
%   Interface / Software environment
set_param(strModel, 'GenFloatMathFcnCalls',   'ANSI_C');       % Target function library
% set_param(strModel, 'GenFloatMathFcnCalls',   'C++ (ISO)');       % Target function library
set_param(strModel, 'UtilityFuncGeneration',  'Shared location'); % Utility function generation

%   Interface / Support
set_param(strModel, 'PurelyIntegerCode',      'off');  % floating-point numbers
% set_param(strModel, 'SupportNonFinite',       'off');  % non-finite numbers
set_param(strModel, 'SupportComplex',         'off');  % complex numbers

% set_param(strModel, 'SupportAbsoluteTime',    'off');  % absolute time
% Note: may want to enable this for 6-DOF, decision TBD
% set_param(strModel, 'SupportContinuousTime',  'off'); % continuous time
set_param(strModel, 'SupportNonInlinedSFcns', 'off'); % non-inlined S-functions

set_param(strModel, 'SupportVariableSizeSignals', 'off'); % variable-size signals

%   Interface / Code interface
set_param(strModel, 'IncludeMdlTerminateFcn', 'off');           % Terminate function required
set_param(strModel, 'MultiInstanceERTCode',   'on');            % Generate reusable code
set_param(strModel, 'RootIOFormat',   'Structure reference');   % Pass root-level I/O as

%% Real-Time Workshop / Code Style
%   Code Style  
set_param(strModel, 'ParenthesesLevel',    'Maximum');    % Parentheses level
set_param(strModel, 'PreserveExpressionOrder',    'on');  % Preserve operand order in expression
set_param(strModel, 'PreserveIfCondition',        'on');  % Preserve condition expression in if statement
set_param(strModel, 'ConvertIfToSwitch',          'off'); % Convert if-elseif-else patterns to switch-case statements
set_param(strModel, 'PreserveExternInFcnDecls',   'on');  % Preserve extern keyword in function declarations

%% Real-Time Workshop / Templates
%   Templates / Code templates
set_param(strModel, 'ERTSrcFileBannerTemplate',   CodeTemplate);  % Source file (*.c) template
set_param(strModel, 'ERTHdrFileBannerTemplate',   CodeTemplate);  % Header file (*.h) template
%   Templates / Data templates
set_param(strModel, 'ERTDataSrcFileTemplate',     CodeTemplate);  % Source file (*.c) template
set_param(strModel, 'ERTDataHdrFileTemplate',     CodeTemplate);  % Header file (*.h) template

%   Custom templates
set_param(strModel, 'GenerateSampleERTMain', 'on');   % Generate an example main program
set_param(strModel, 'TargetOS', 'VxWorksExample');    % Target operating system

%% Real-Time Workshop / Code Placement
%   Global data placement (custom storage classes only)
set_param(strModel, 'GlobalDataReference', 'InSeparateHeaderFile');   % Data declaration
set_param(strModel, 'DataReferenceFile', [strModel '.h']);   % Data declaration filename

%% Finished
fprintf(1, '%s: Set RTW configuration for model %s\n', mfilename, strModel);

end % << End of function RTW_config >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
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
