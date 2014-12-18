% VIEWVALUES Simulink Diagram utility for viewing workspace variables
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ViewValues:
%   This is a utility function for displaying the values contained in
%   a list of Simulink blocks like Constants or Gains when they use a
%   workspace variable as their value.  This way, when viewing a Simulink
%   diagram that uses workspace variables, the values of those variables is
%   shown underneath each block.
%
%   Current supported blocks:
%    1. Gain block's 'Gain' value and 'SampleTime' value; ('Inf' ignored)
%    2. Constant block's 'Constant' value and 'SampleTime' value;
%       ('Inf' ignored)
%    3. UnitDelay block's 'X0' (initial condition) value
%    4. Memory block's 'X0' (initial condition) value
%    5. RateTransition block's 'OutPortSampleTime' (DT) value and 'X0'
%    (initial condition)
%    6. Switch block's switch 'Criteria' and 'Threshold'
%    7. Saturate block's 'UpperLimit' and 'LowerLimit'
%    8. RateLimiter's 'RisingSlewLimit', 'FallingSlewLimit', and
%       'InitialCondition'
%    9. DiscreteIntegrator and Integrator (continuous) 'InitialCondition',
%    if it's set on the mask
%    10. 1-D table 'Lookup' block's vector of 'InputValues' and 'Table'
%    data
%    11. Simulink's 'Compare To Constant' block's 'Operator' and 'Constant
%    value'
%    12. DeadZone's 'UpperValue' and 'LowerValue'
%    13. From Workspace's 'SampleTime'
%    14. Simulink's Edge Detection blocks' Initial Condition:
%         'Detect Increase', 'Dected Decrease', 'Detect Change',
%         'Detect Rise Positive', 'Detect Rise Nonnegative',
%         'Detect Fall Negative', & 'Detect Fall Nonpositive'
%    15. Direct Lookup Table (n-D) 'Table' data if the number of table
%           elements is either 1 or 2-D
%    16. Signal 'Selector' blocks will have at least 2 lines
%           1st line: Index-Mode
%           2+: 'Index Option Type (e.g. 'Index vector (dialog)') and the
%           selected indices (if applicable)
%    17. DataStoreMemory's 'InitialValue' & 'RTWStateStorageClass'
%    18. Discrete Filter's 'Numerator' and 'Denominator'
%    19. Simulink's 'Counter Limited' upper limit ('Uplimit')
%    20. Simulink's 'Random Number' block's Mean, Variance, & Seed
%    21. Simulink's 'Variable Transport Delay' (a.k.a. 'Variable Time
%           Delay') block's 'MaximumDelay'
%
% SYNTAX:
%	Report = ViewValues(flgOnOff, strSim, visLimits, varargin, 'PropertyName', PropertyValue)
%	Report = ViewValues(flgOnOff, strSim, visLimits, varargin)
%	Report = ViewValues(flgOnOff, strSim, visLimits)
%	Report = ViewValues(flgOnOff, strSim)
%	Report = ViewValues(flgOnOff)
%	Report = ViewValues()
%
% INPUTS:
%	Name     	Size		Units		Description
%	flgOnOff	[1]         [bool]      Tag Viewing State
%                                        0: Turn tags off
%                                        1: Turn tags on
%                                        Default: 1 (on)
%	strSim	   'string'     [char]      Name of Simulink Model
%	visLimits  [1 x 2]      [int]       Maximum array or matrix sizes to
%                                        show.  If size of matrix exceeds
%                                        the limits, it will be cropped for
%                                        display purposes.
%                                        Default: [10 10]
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
% OUTPUTS:
%	Name     	Size		Units		Description
%   Report      {struct}                Report struct showing (for each
%                                        model)...
%    .BlocksAnalyzed                    What blocks/properties were analyzed
%    .FullLog                           Full list of all found blocks
%    .Harcoded                          Blocks with hard coded values
%    .Show                              Blocks that would have values shown
%                                        (ie there's a workspace variable
%                                        for it)
%
% NOTES:
%   This is a great utility to drop into the 'InitFcn' callback on Simulink
%   models.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'Verbose'           [bool]          false       Show function working?
%   'ReportOnly'        [bool]          false       Only run report of what
%                                                    blocks have hard-coded
%                                                    values and what blocks
%                                                    have data to show?
%   'MakeXLSHardcodedReport' [bool]     false       Create an Excel report
%                                                    of all hard-coded
%                                                    values?
%   'XLSHardcodedReportFilename'  'string'  ''      Filename for Excel
%                                                    hard-coded report
%   'XLSOpenHardcodedReport' [bool]     true        Open hard-coded report
%                                                    after it has been
%                                                    created?
%
% EXAMPLES:
%	% Example #1: Turn on Values
%   ViewValues(1)
%
%   % Example #2: Report Generation Mode
%   xlsFilename = [fileparts(mfilename('fullpath')) filesep 'HardCodedValues.xlsx'];
%   lstModels = {...
%       'f14';
%       'aeroblk_HL20';
%       };
%   lstReport = ViewValues(1, lstModels, 'ReportOnly', 1, 'Verbose', 0, ...
%       'MakeXLSHardcodedReport', 1, 'XLSHardcodedReportFilename', xlsFilename);
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ViewValues.m">ViewValues.m</a>
%   Unit test Model: <a href="matlab:Test_ViewValues">Test_ViewValues.mdl</a>
%	  Driver script: <a href="matlab:edit Driver_ViewValues.m">Driver_ViewValues.m</a>
%	  Documentation: <a href="matlab:winopen(which('ViewValues_Function_Documentation.pptx'));">ViewValues_Function_Documentation.pptx</a>
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/541
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/ViewValues.m $
% $Rev: 3321 $
% $Date: 2014-12-04 17:16:39 -0600 (Thu, 04 Dec 2014) $
% $Author: sufanmi $

function Report = ViewValues(varargin)

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

%% Input Argument Conditioning:
[flgVerbose, varargin]                  = format_varargin('Verbose', 0, 2, varargin);
[flgReportOnly, varargin]               = format_varargin('ReportOnly', 0, 2, varargin);
[MakeXLSHardcodedReport, varargin]      = format_varargin('MakeXLSHardcodedReport', 0, 2, varargin);
[XLSHardcodedReportFilename, varargin]  = format_varargin('XLSHardcodedReportFilename', '', 2, varargin);
[XLSOpenHardcodedReport, varargin]      = format_varargin('XLSOpenHardcodedReport', 1, 2, varargin);

visLimits= []; lstSim= ''; flgOnOff= [];
if(numel(varargin) > 0)
    flgOnOff = varargin{1};
end
if(numel(varargin) > 1)
    lstSim = varargin{2};
end
if(numel(varargin) > 2)
    visLimits = varargin{3};
end

if(isempty(visLimits))
    visLimits = [10 10];
end

if(length(visLimits) == 1)
    visLimits = [1 1]*visLimits;
end

if(isempty(lstSim))
    lstSim = bdroot;
end

if(ischar(lstSim))
    lstSim = { lstSim };
end

if(isempty(flgOnOff))
    flgOnOff = 1;
end

%% Main Function:
if(flgOnOff)
    ViewValues(0, lstSim, visLimits, 'Verbose', 0, 'Report', flgReportOnly);
end

Report = {};

if(verLessThan('matlab', '7.14'))
    % 2011b & older
    msgid = 'Simulink:SL_SetParamLinkChangeWarn';           % 2010a call
else
    % 2012a & newer
    msgid = 'Simulink:Commands:SetParamLinkChangeWarn';     % 2012b call
end
warning('off', msgid);

numSim = size(lstSim, 1);
for iSim = 1:numSim
    strSim = lstSim{iSim, 1};
    if(numSim > 1)
        disp(sprintf('%s : [%d/%d] : Processing ''%s'' with ''flgOnOff'' of %s...', ...
            mfilename, iSim, numSim, strSim, num2str(flgOnOff)));
    end
    lstLog = {};
    if(exist(strSim) == 0)
        if(flgVerbose || MakeXLSHardcodedReport)
            disp(sprintf('%s : WARNING : ''%s'' does not exist.  Ignoring...', ...
                mfilename, strSim));
        end
    else
        load_system(strSim);
        
        % ViewValues:
        % lstBlockTypes(:,1): Type of Simulink Block (e.g. Gain, Constant)
        % lstBlockTypes(:,2): Switch
        lstBlockTypes = {...
            'Gain'                      '';
            'Constant'                  '';
            'UnitDelay'                 '';
            'Memory'                    '';
            'RateTransition'            '';
            'Switch'                    '';
            'Saturate'                  '';
            'RateLimiter'               '';
            'DiscreteIntegrator'        '';
            'Integrator'                '';
            'Lookup'                    '';
            'SubSystem'                 'CompareToConstant';
            'SubSystem'                 'EdgeDetection';
            'DeadZone'                  '';
            'FromWorkspace'             '';
            'LookupNDDirect'            '';
            'Selector'                  '';
            'Product'                   '';
            'DataStoreMemory'           '';
            'DiscreteFilter'            '';
            'SubSystem'                 'CounterLimited';
            'RandomNumber'              '';
            'VariableTransportDelay'    '';
            };
        
        numBlockTypes = size(lstBlockTypes, 1);
        
        for iBlockType = 1:numBlockTypes;
            curBlockType        = lstBlockTypes{iBlockType, 1};
            curSwitchParam      = lstBlockTypes{iBlockType, 2};
            if(isempty(curSwitchParam))
                curSwitchParam = curBlockType;
            end
            
            if(flgVerbose)
                disp(sprintf('%s : [%2.0f/%2.0f] : Looking for all ''%s'' blocks in %s...', ...
                    mfilename, iBlockType, numBlockTypes, curBlockType, strSim));
            end
            
            lstBlocks = find_system(strSim, 'FollowLinks', 'on', ...
                'BlockType', curBlockType);
            numBlocks = length(lstBlocks);
            if(flgVerbose)
                disp(sprintf('%s           : Found %d instances of ''%s''...', ...
                    mfspc, numBlocks, curBlockType));
            end
            
            for iBlock = 1:numBlocks
                curBlock = lstBlocks{iBlock};
                
                if(flgVerbose)
                    disp(sprintf('%s : %s : [%d/%d] : %s...', mfilename, curSwitchParam, iBlock, numBlocks, curBlock));
                end
                
                if(flgOnOff)
                    % May Need to Add Logic Here for Variables Read from Masks...
                    
                    switch curSwitchParam
                        case 'Switch'
                            strCriteria = get_param(curBlock, 'Criteria');
                            strCriteria = strrep(strCriteria, 'u2 ', '');
                            
                            if(strcmp(strCriteria, '~= 0'))
                                strTag2Add = ['Criteria: ' strCriteria];
                            else
                                strCriteria = strrep(strCriteria, ' Threshold', '');
                                [strVal, lstLog] = MaskValue2Str(curBlock, 'Threshold', '', visLimits, 'ForceShow', 1, 'Log', lstLog);
                                strTag2Add = ['Criteria: ' strCriteria ' ' strVal];
                            end
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case 'Gain'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'Gain', 'value:', visLimits, 'IgnoreList', {'1';'-1'}, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'SampleTime', 'dt:', visLimits, 'IgnoreList', {'Inf'; '-1'}, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case 'Constant'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'Value', 'value:', visLimits, 'IgnoreList', {'eye';'ones';'0'}, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'SampleTime', 'dt:', visLimits, 'IgnoreList', {'Inf'; '-1'}, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case 'UnitDelay'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'X0', 'IC:', visLimits, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case 'Memory'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'X0', 'IC:', visLimits, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case 'RateTransition'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'OutPortSampleTime', 'DT:', visLimits, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'X0', 'IC:', visLimits, 'IgnoreList', '0', 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case 'Saturate'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'UpperLimit', 'UL:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'LowerLimit', 'LL:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case 'DeadZone'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'UpperValue', 'UV:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'LowerValue', 'LV:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case 'RateLimiter'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'RisingSlewLimit', 'RSL:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'FallingSlewLimit', 'FSL:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'InitialCondition', 'IC:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case {'DiscreteIntegrator'; 'Integrator'}
                            ICSource = get_param(curBlock, 'InitialConditionSource');
                            if(strcmp(ICSource, 'internal'))
                                [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'InitialCondition', 'IC:', visLimits, 'Log', lstLog);
                                AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            end
                            LimitOutput = get_param(curBlock, 'LimitOutput');
                            if(strcmp(LimitOutput, 'on'))
                                [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'UpperSaturationLimit', 'UL:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                                AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                                
                                [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'LowerSaturationLimit', 'LL:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                                AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            end
                            
                        case 'Lookup'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'InputValues', 'IV:', [5 5], 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'Table', 'DV:', [5 5], 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case 'CompareToConstant'
                            strRef = get_param(curBlock, 'ReferenceBlock');
                            strLib = ['simulink/Logic and Bit' endl ...
                                'Operations/Compare' endl ...
                                'To Constant'];
                            if(strcmp(strRef, strLib))
                                %                             lstMaskValues = get_param(curBlock, 'MaskValues');
                                %                             strLogic = lstMaskValues{1};
                                %                             strValue = lstMaskValues{2};
                                
                                [strLogic, lstLog] = MaskValue2Str(curBlock, 'relop', '', visLimits, 'ForceShow', 1, 'Log', lstLog);
                                [strValue, lstLog] = MaskValue2Str(curBlock, 'const', '', visLimits, 'ForceShow', 1, 'Log', lstLog);
                                %                             if(~strcmp(strtrim(strVal), strValue))
                                strTag2Add = ['Criteria: ' strLogic ' ' strVal];
                                AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                                %                             end
                            end
                            
                        case 'FromWorkspace'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'SampleTime', 'dt:', visLimits);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case 'EdgeDetection'
                            % This should cover the following:
                            %   'Detect Incease'
                            %   'Dected Decrease'
                            %   'Detect Change'
                            %   'Detect Rise Positive'
                            %   'Detect Rise Nonnegative'
                            %   'Detect Fall Negative'
                            %   'Detect Fall Nonpositive'
                            
                            strRef = get_param(curBlock, 'ReferenceBlock');
                            strRef = strrep(strRef, char(10), '');
                            strRef = strrep(strRef, ' ', '');
                            
                            strLib = ['simulink/LogicandBitOperations/Detect'];
                            if(~isempty(strfind(strRef, strLib)))
                                lstMaskValues = get_param(curBlock, 'MaskValues');
                                strValue = lstMaskValues{1};
                                lstMaskNames = get_param(curBlock, 'MaskNames');
                                [strTag2Add, lstLog] = MaskValue2Str({strValue curBlock}, lstMaskNames{1}, 'IC:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                                AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            end
                            
                        case 'LookupNDDirect'
                            strTableData = get_param(curBlock, 'Table');
                            strTag2Add = ['Table: ' strTableData];
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                            numElements = str2double(get_param(curBlock, 'NumberOfTableDimensions'));
                            if((numElements == 1) || (numElements == 2))
                                [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'Table', 'Table:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                                AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            end
                            
                        case 'Selector'
                            strIndexMode = get_param(curBlock, 'IndexMode');
                            strTag2Add = ['Index Mode: ' strIndexMode];
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                            strIndexOptions = get_param(curBlock, 'IndexOptions');
                            lstIndexOptions = str2cell(strIndexOptions, ',');
                            
                            lstIndexParamArray = get_param(curBlock, 'IndexParamArray');
                            
                            numDim = str2double(get_param(curBlock, 'NumberOfDimensions'));
                            for iDim = 1:numDim
                                curIndexOption = lstIndexOptions{iDim,:};
                                if(strcmp(strIndexMode, 'Zero-based'))
                                    strDim = sprintf('%d', iDim-1);
                                else
                                    strDim = sprintf('%d', iDim);
                                end
                                switch curIndexOption
                                    case 'Index vector (dialog)'
                                        strTag2Add = ['#' strDim '-' curIndexOption ': ' lstIndexParamArray{iDim}];
                                        AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                                    otherwise
                                        strTag2Add = ['#' strDim '-' curIndexOption];
                                        AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                                end
                            end
                            
                        case 'Product'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'SampleTime', 'dt:', visLimits, 'IgnoreList', {'Inf'; '-1'}, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case 'DataStoreMemory'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'InitialValue', 'IV:', visLimits, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                            strRTWClass = get_param(curBlock, 'RTWStateStorageClass');
                            strTag2Add = ['RTWClass: ' strRTWClass];
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case 'DiscreteFilter'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'Numerator', 'Num:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'Denominator', 'Den:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case 'CounterLimited'
                            strRef = get_param(curBlock, 'ReferenceBlock');
                            strLib = ['simulink/Sources/Counter' endl ...
                                'Limited'];
                            
                            if(strcmp(strRef, strLib))
                                [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'Uplimit', 'Uplimit:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                                AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            end
                            
                        case 'RandomNumber'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'Mean', 'Mean:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'Variance', 'Var:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'Seed', 'Seed:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                            
                        case 'VariableTransportDelay'
                            [strTag2Add, lstLog] = MaskValue2Str(curBlock, 'MaximumDelay', 'Max Delay:', visLimits, 'ForceShow', 1, 'Log', lstLog);
                            strTag2Add = [strTag2Add ' sec'];
                            AddStr2Attributes(curBlock, strTag2Add, flgReportOnly);
                    end
                    
                else
                    %% Wipe out the tag
                    set_param(curBlock,'AttributesFormatString', '');
                end
            end
        end
        
        if(flgOnOff)
            arrHardcoded = []; iHardcoded = 0;
            arrShow = []; iShow = 0;
            
            % Sort the log
            numBlocks = size(lstLog, 1);
            for iBlock = 1:numBlocks
                curBlock = lstLog(iBlock);
                if(curBlock.Hardcoded)
                    iHardcoded = iHardcoded + 1;
                    arrHardcoded(iHardcoded) = iBlock;
                end
                if(curBlock.Show)
                    iShow = iShow + 1;
                    arrShow(iShow) = iBlock;
                end
            end
            
            lstHardcoded     = lstLog(arrHardcoded);
            lstShow          = lstLog(arrShow);
            
            clear lstReport;
            lstReport.BlocksAnalyzed    = setxor(unique(lstBlockTypes), {'';'SubSystem'});
            lstReport.FullLog           = lstLog;
            lstReport.Hardcoded         = lstHardcoded;
            lstReport.Show              = lstShow;
            Report.(strSim) = lstReport;
            
            if(MakeXLSHardcodedReport)
                tbl = {}; irow = 0;
                irow = irow + 1; tbl(irow,1:6) = {'#';'Block Name'; 'Block Type'; 'Variable'; 'Expression'; 'Value'};
                
                lstHardcoded = lstReport.Hardcoded;
                numHardcoded = size(lstHardcoded, 1);
                if(numHardcoded == 0)
                    irow = irow + 1;
                    tbl(irow,1) = {'No Hardcoded Values Detected'};
                else
                    strPlural = '';
                    if(numHardcoded > 1)
                        strPlural = 's';
                    end
                    disp(sprintf('%s : %d Hardcoded Value%s found in ''%s''.', ...
                        mfilename, numHardcoded, strPlural, strSim));
                    
                    for iHardcoded = 1:numHardcoded
                        curBlock = lstHardcoded(iHardcoded);
                        irow = irow + 1;
                        tbl(irow,1) = {iHardcoded};
                        
                        tbl(irow,2) = {curBlock.Block};
                        % (irow,2) = {strrep(curBlock.Block, char(10), ' ')};
                        
                        if(strcmp(curBlock.BlockType, 'SubSystem'))
                            tbl(irow,3) = {curBlock.BlockType};
                        else
                            tbl(irow,3) = {curBlock.BlockType};
                        end
                        tbl(irow,4) = {curBlock.Variable};
                        tbl(irow,5) = {['''''' curBlock.Expression '''']};     % Needed to fool Excel
                        tbl(irow,6) = {curBlock.Value};
                    end
                end
                
                xls_msgID = 'MATLAB:xlswrite:AddSheet';
                warning('off', xls_msgID);
                
                xlswrite(XLSHardcodedReportFilename, tbl, strSim);
                
                warning('on', xls_msgID);
                if((iSim == numSim) && XLSOpenHardcodedReport)
                    winopen(XLSHardcodedReportFilename);
                end
            end
        end
    end
end

warning('on', msgid);

end % << End of function ViewValues >>

%% Function MaskValue2Str
function [strTag2Add, lstLog] = MaskValue2Str(curBlock, MaskVariable, strTag2Use, visLimits, varargin)
[flgForce, varargin]        = format_varargin('ForceShow', 0, 2, varargin);
[flgIncludeName, varargin]  = format_varargin('IncludeName', 0, 2, varargin);
[lstIgnore, varargin]       = format_varargin('IgnoreList', {}, 2, varargin);
[lstLog, varargin]          = format_varargin('Log', {}, 2, varargin);
numLog = size(lstLog, 1); iLog = numLog + 1;

curBlockFull = curBlock;
if(iscell(curBlock))
    curBlockFull    = curBlock{2};
    curBlock        = curBlock{1};
end

if(ischar(lstIgnore))
    lstIgnore = { lstIgnore };
end

if(isempty(MaskVariable))
    strCurrBlock = curBlock;
else
    try
        % It's a block parameter
        strCurrBlock = get_param(curBlock, MaskVariable);
    catch
        % It's a mask parameter
        lstMaskNames = get_param(curBlockFull, 'MaskNames');
        iMaskName = max(strcmp(lstMaskNames, MaskVariable) .* [1:size(lstMaskNames, 1)]');
        lstMaskValues = get_param(curBlockFull, 'MaskValues');
        strCurrBlock = lstMaskValues{iMaskName};
    end
end
flgLogical = any(strcmp(strCurrBlock, {'>'; '>='; '<'; '<='; '=='; '~='}));
if(flgLogical)
    val = strCurrBlock;
    flgShow = 1;
    flgHardcoded = 0;
    flgMatch = 0;
else
    try
        val = evalin('base', strCurrBlock);
    catch
        disp(sprintf('%s : Error Evaluating ''%s''.  Check workspace.', mfilename, strCurrBlock));
        val = 0;
    end
    
    flgMatch = 0;
    
    for i = 1:size(lstIgnore, 1)
        curIgnore = lstIgnore{i,:};
        if(any(strcmp(curIgnore, {'-1';'0';'1'})))
            if(strcmp(strCurrBlock, curIgnore))
                flgMatch = 1;
                break;
            end
        else
            if(~isempty(strfind(lower(strCurrBlock), lower(curIgnore))))
                flgMatch = 1;
                break;
            end
        end
    end
    
    flgHardcoded = 0;
    if(isa(val, 'Simulink.Parameter'))
        flgShow = 0;
    else
        try
            % Check #1: Look for basic math and array notation
            ptr_Math = regexp(strCurrBlock, {'+';'-';'*';'/';':'});
            for i_ptr_Math = 1:length(ptr_Math)
                if(~isempty(ptr_Math{i_ptr_Math}))
                    flgHardcoded = 1;
                    break;
                end
            end
            
            if(~flgHardcoded)
                % Check #2: Look for '.' notation indicating a structure
                ptrDot = strfind(strCurrBlock, '.');
                if(~isempty(ptrDot))
                    % It might be a structure
                    strCurrBlockRoot = strCurrBlock(1:ptrDot(1)-1);
                    flgStruct = evalin('base', ['exist(''' strCurrBlockRoot ''')']);
                    flgHardcoded = ~flgStruct;
                    
                else
                    %
                    flgStruct = evalin('base', ['exist(''' strCurrBlock ''')']);
                    flgHardcoded = ~flgStruct;
                end
            end
            
            %         flgHardcode_Check1 = strcmp(strCurrBlock, num2str(val));
            
            %         flgHardcoded = strcmp(strCurrBlock, num2str(val));
            %         flgHardcoded = flgHardcode_Check1 || flgHardcode_Check2;
            
            flgShow = (~flgMatch && (~flgHardcoded)) || flgForce;
        catch
            disp(sprintf('%s : Error Evaluating Value in ''%s''.', ...
                mfilename, strCurrBlock));
        end
    end
end
try
    lstLog(iLog,1).Block        = curBlockFull;
    
    curBlockType = get_param(curBlockFull, 'BlockType');
    if(strcmp(curBlockType, 'SubSystem'))
        curReferenceBlock = get_param(curBlockFull, 'ReferenceBlock');
        curReferenceBlock = strrep(curReferenceBlock, char(10), '');
        curReferenceBlock = strrep(curReferenceBlock, ' ', '');
        ptrSlash = findstr(curReferenceBlock, '/');
        if(~isempty(ptrSlash))
            curReferenceBlock = curReferenceBlock(ptrSlash(end)+1:end);
        end
        lstLog(iLog,1).BlockType    = curReferenceBlock;
        
    else
        lstLog(iLog,1).BlockType    = curBlockType;
    end
    
    lstLog(iLog,1).ShowName     = get_param(curBlockFull, 'ShowName');
    lstLog(iLog,1).Variable     = MaskVariable;
    lstLog(iLog,1).Expression   = strCurrBlock;
    lstLog(iLog,1).Value        = val;
    lstLog(iLog,1).Hardcoded    = flgHardcoded && ~flgMatch;
    lstLog(iLog,1).Show         = flgShow;
catch
    disp('Debug');
end

if(~flgShow)
    strTag2Add = [];
else
    numRows = size(val,1);
    numCols = size(val,2);
    if(flgLogical)
        str2show = val;
    elseif((numRows > 3) && (numCols > 3))
        str2show = sprintf('[%d x %d]', numRows, numCols);
        
    elseif((numRows == 1) && (numCols > visLimits(2)))
        str2show = sprintf('[%d x %d] [%s %s ... %s]', ...
            numRows, numCols, num2str(val(1)), ...
            num2str(val(2)), num2str(val(numCols)));
    elseif((numCols == 1) && (numRows > visLimits(1)))
        str2show = sprintf('[%d x %d] [%s %s ... %s]''', ...
            numRows, numCols, num2str(val(1)), ...
            num2str(val(2)), num2str(val(numRows)));
    else
        str2show = num2str(val);
    end
    
    if(flgLogical)
        strTag2Add = str2show;
    else
        strTag2Add = [strTag2Use ' '];
        
        numRow = size(str2show, 1);
        for iRow = 1:numRow
            strTag2Add = [strTag2Add str2show(iRow, :)];
            if(iRow < numRow)
                strTag2Add = [strTag2Add '\n'];
            end
        end
    end
    
    if(flgIncludeName)
        strTag2Add = [strTag2Add ' (' strCurrBlock ')'];
    end
    
end
end

%% Function AddStr2Attributes
function AddStr2Attributes(curBlock, strTag2Add,flgReportOnly)
if(~flgReportOnly)
    if(~isempty(strTag2Add))
        strAttributes = get_param(curBlock, 'AttributesFormatString');
        if(~isempty(strAttributes))
            flgInTagsAlready = strfind(strAttributes, strTag2Add);
            if(isempty(flgInTagsAlready))
                strAttributes = [strAttributes '\n' strTag2Add];
            end
        else
            strAttributes = strTag2Add;
        end
        set_param(curBlock,'AttributesFormatString', strAttributes);
    end
end
end

% FORMAT_VARARGIN Function utility for variable input arguments
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% format_varargin:
%  Looks at all the additional inputted arguments and returns the value if
%  the property is found.  If not, returns the default.
%
% SYNTAX:
%	[y, argin2] = format_varargin(strDefault, valDefault, SortMode, argin)
%
% INPUTS:
%	Name      	Size		Units		Description
%  strDefault  'string'     [char]      Input argument to look for
%  valDefault  [varies]     [varies]    Default value
%  SortMode     [1]         [int]       Sorting Mode where
%                                       0: Overwrites Default Value If Empty or
%                                          Adds Property/Value if nonexistant
%                                       1: Overwrites Default Value
%                                       2: Removes property and value
%  argin        {cell}                  Input arguments to sort through
%
% OUTPUTS:
%	Name      	Size		Units		Description
%   y          [varies]    [varies]     Property value
%	argin2	   {cell}                   argin with Property Name and Value
%                                        removed
%
% NOTES:
%
% EXAMPLES:
%   argin = {'LineWidth', 10, 'FontWeight', 'bold'};
%
% EX #1: With Sort Mode = 0...
%
%  [y, argin2] = format_varargin('NewProp', 1, 0, argin)
% y =
%      1
% argin2 =
%     'LineWidth'    [10]    'FontWeight'    'bold'    'NewProp'    [1]
%
% EX #2: With Sort Mode = 1...
%
% [y, argin2] = format_varargin('FontWeight', 1, 1, argin)
% y =
%      1
% argin2 =
%     'LineWidth'    [10]    'FontWeight'    [1]
%
% EX #3: With Sort Mode = 2, returns property value...
%
%[y, argin2] = format_varargin('FontWeight', 1, 2, argin)
% y =
% bold
% argin2 =
%     'LineWidth'    [10]
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit format_varargin.m">format_varargin.m</a>
%	  Driver script: <a href="matlab:edit Driver_format_varargin.m">Driver_format_varargin.m</a>
%	  Documentation: <a href="matlab:pptOpen('format_varargin_Function_Documentation.pptx');">format_varargin_Function_Documentation.pptx</a>
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/445
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% URL: https://vodka.ccc.northgrum.com/svn/CSA/trunk/CSA/Functions/MatlabUtilities/format_varargin.m $
% Rev: 1718 $
% Date: 2011-05-11 16:07:49 -0700 (Wed, 11 May 2011) $
% Author: healypa $

function [y, argin2] = format_varargin(strDefault, valDefault, SortMode, argin, varargin)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

y = valDefault;

if(isempty(argin))
    if((SortMode == 0) || (SortMode == 1))
        argin2{1} = strDefault;
        argin2{2} = valDefault;
    else
        argin2 = argin;
    end
else
    
    argin2 = {};
    numArgin = size(argin, 2);
    
    ptrOld = 0;
    ptrNew = 0;
    
    flgMatchFound = 0;
    
    while (ptrOld < numArgin)
        ptrOld = ptrOld + 1;
        curArg = argin{ptrOld};
        
        if(strcmp(lower(curArg), lower(strDefault)))
            
            switch SortMode
                case 0
                    % Overwrite Default:
                    ptrNew = ptrNew + 1;
                    argin2{ptrNew} = curArg;
                    
                    ptrOld = ptrOld + 1;
                    curArg = argin{ptrOld};
                    ptrNew = ptrNew + 1;
                    curArg = argin{ptrOld};
                    if(isempty(curArg))
                        argin2{ptrNew} = valDefault;
                    else
                        argin2{ptrNew} = curArg;
                        y = curArg;
                    end
                    flgMatchFound = 1;
                    
                case 1
                    % Overwrite Default:
                    ptrNew = ptrNew + 1;
                    argin2{ptrNew} = curArg;
                    
                    ptrOld = ptrOld + 1;
                    curArg = argin{ptrOld};
                    ptrNew = ptrNew + 1;
                    argin2{ptrNew} = valDefault;
                    flgMatchFound = 1;
                    
                case 2
                    % Strip out Variable:
                    
                    ptrOld = ptrOld + 1;
                    y = argin{ptrOld};
                    
                    if(isempty(y))
                        y = valDefault;
                    end
            end
        else
            ptrNew = ptrNew + 1;
            argin2{ptrNew} = curArg;
        end
    end
    
    if((flgMatchFound == 0) && ((SortMode == 0) || (SortMode == 1)))
        ptrNew = ptrNew + 1;
        argin2{ptrNew} = strDefault;
        ptrNew = ptrNew + 1;
        argin2{ptrNew} = valDefault;
    end
    
end

end % << End of function format_varargin >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110603 MWS: Added support of Simulink Selector block
% 110518 MWS: Added support of Simulink Edge Detection blocks and Direct
%              Lookup Table (n-D) when only a 1 or 2-D table is specified
%             Modified MaskValue2Str to use varargin and format_varargin
%             Copied in format_varagin function so that ViewValues can
%             still be used as a standalone function.
% 110418 MWS: Adding in Simulink 'Compare To Constant' and 'DeadZone'
%             Updated internal logic to be able to declare the Simulink
%             block type and display type separately (case in point is the
%             'Compare To Constant' block really be of type 'Subsystem')
% 101014 MWS: Cleaned up function using CreateNewFunc
% 090122 MWS: Originally created function for the VSI_LIB
%               https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/SIMULINK_UTILITIES/ViewValues.m
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
