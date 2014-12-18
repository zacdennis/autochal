% GETSIGNALINFO Determines what signals in a bus are and are not used
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GetSignalInfo:
%   Determines what signals in a bus are and are not used downstream
%
%   Note: This function is a work in progress.
%   Currently works for:
%       1. BusCreators that do NOT contain any sub buses.  Internal trace
%       routine only works downstream.  It does not back trace to determine
%       sub bus members.
%       2. Inport that had a specified BusObject.
%       3. Outport that has a specified BusObject.
%       4. BusCreator that has a specified BusObject.
%
%   Limitations:
%       1. Will go into libary link blocks
%       2. Will NOT go into model references.  This is currently untested.
%           Also, to trace buses into model references, a bus object will
%           be required.
% 
% SYNTAX:
%	[lstUsed, lstUnused, SignalTrace] = GetSignalInfo(curItem)
%	[lstUsed, lstUnused, SignalTrace] = GetSignalInfo()
%
% INPUTS: 
%	Name       	Size		Units               Description
%	curItem	    [1]         [Simulink handle]   Handle to current Simulink
%                                               item
%                                                Default: Last block or
%                                                line selected
% OUTPUTS: 
%	Name       	Size		Units               Description
%	lstUsed	    {M x 1}     {'string'}          List of used bus signals
%	lstUnused   {N x 1}     {'string'}          List of unused bus signals
%	SignalTrace	{struct}    [varies]            Signal Trace Structure
%                                                   See below
% NOTES:
%   SignalTrace Format:
%       This works on a bus of 'i' number of elements, with...
%   Name                                Units       Description
%   SignalTrace(i).SignalName           'string'    Name of Signal
%   SignalTrace(i).NumUsed              [int]
%
%   If SignalTrace(i).NumUsed > 0 then it it assumed that the signal has
%   been used 'j' number of times, with...
%   SignalTrace(i).UseCase(j).Block     'string'    Block using signal
%   SignalTrace(i).UseCase(j).FinalName 'string'    Signal name as selected
%
%   Note that the Signal name as selected may not be the same as the
%   original name, since it could have been rolled into a larger bus.
%
% EXAMPLES:
%   % Example 1: Using Unit Test Model 'Test_GetSignalInfo', find the used
%   %            and unused signals collected in the 'CreateAirDataBus' bus
%   %            creator.
%   open_system('Test_GetSignalInfo');
%   [lstUsed, lstUnused, SignalTrace] = GetSignalInfo('Test_GetSignalInfo/CreateAirDataBus')
%
%   % Returns:
%   %   lstUsed = 
%   %       'Alpha_deg'
%   %       'Beta_deg'
%   %       'Chi_deg'
%   %       'Mu_deg'
%   %       'Vtrue_fps'
%
%   % lstUnused = 
%   %       'Gamma_deg'
%   %       'Mach_ND'
%   %       'Vcas_kts'
%
%   % SignalTrace = 
%   %   1x8 struct array with fields:
%   %    SignalName
%   %    NumUsed
%   %    UseCase
%   
%   %   SignalTrace(1)
%   %     SignalName: 'Alpha_deg'
%   %        NumUsed: 2
%   %        UseCase: [1x2 struct]
%
%   % SignalTrace(3)
%   %     SignalName: 'Gamma_deg'
%   %        NumUsed: 0
%   %        UseCase: []
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit GetSignalInfo.m">GetSignalInfo.m</a>
%   Unit test Model: <a href="matlab:Test_GetSignalInfo">Test_GetSignalInfo.mdl</a>
%	  Driver script: <a href="matlab:edit Driver_GetSignalInfo.m">Driver_GetSignalInfo.m</a>
%	  Documentation: <a href="matlab:pptOpen('GetSignalInfo_Function_Documentation.pptx');">GetSignalInfo_Function_Documentation.pptx</a>
%
% See also LastClicked, BusObject2List
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/689
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [lstUsed, lstUnused, SignalTrace] = GetSignalInfo(curItem)

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
if(nargin == 0)
    curItem = LastClicked();
end

%% Initialize Outputs:
lstUsed = {};
lstUnused = {};
SignalTrace = [];

%% Main Function:
flgGoodToGo = 0;
curItemType = get_param(curItem, 'Type');
switch curItemType
    case 'line'
        % TODO: Fill this in
        %   Backtracing required
        disp(sprintf('%s : Warning : You clicked on a line.  ''Lines'' are not supported yet.  Please only use ''BusCreators''.', mfnam));       
        
%         line = curItem;
%         strParent = get_param(line, 'Parent');
%         hdlLineSrc = get_param(line, 'SrcPortHandle');
%         numPortSrc = get_param(hdlLineSrc, 'PortNumber');
%         
%         blkLineSrc = get_param(line, 'SrcBlockHandle');
%         strBlockSrc = get_param(blkLineSrc, 'Name');
%         strBlockSrc = strrep(strBlockSrc, endl, ' ');
        
    case 'block'
        curBlockType = get_param(curItem, 'BlockType');
        
        switch curBlockType
            case 'BusCreator'
                strBusObject = get_param(curItem, 'BusObject');
                flgUseBusObject = strcmp(get_param(curItem, 'UseBusObject'), 'on');
                
                if(flgUseBusObject && ~isempty(strBusObject))
                    lstBusObject = BusObject2List(strBusObject);
                    lstBusMembers = lstBusObject(:,1);
                else
                    lstBusMembers = get_param(curItem, 'InputSignalNames')';
                end
                flgGoodToGo = 1;
                
            case {'Inport'; 'Outport'}
                strBusObject = get_param(curItem, 'BusObject');
                flgUseBusObject = strcmp(get_param(curItem, 'UseBusObject'), 'on');
                
                if(flgUseBusObject && ~isempty(strBusObject))
                    lstBusObject = BusObject2List(strBusObject);
                    lstBusMembers = lstBusObject(:,1);
                    flgGoodToGo = 1;
                else
                    disp(sprintf('%s : Warning : You clicked on a ''%s'' with no associated BusObject.  This block is not yet supported.', mfnam, curItem));
                end
               
            otherwise
                % Not sure what to do here.  Backtrace?
                disp(sprintf('%s : Warning : You clicked on a ''%s''.', mfnam, curBlockType));
                disp(sprintf('%s   ''%s'' blocks are not supported yet.  Please only use ''BusCreators''.', ...
                    mfspc, curBlockType));
        end
end

if(flgGoodToGo)
    numMembers = size(lstBusMembers, 1);
    
    % Initialize SignalTrace:
    for i = 1:numMembers
        SignalTrace(i).SignalName = lstBusMembers{i,:};
        SignalTrace(i).NumUsed = 0;
    end
    
    [SignalTrace] = GetSignalTrace(curItem, lstBusMembers, SignalTrace);
    
    iYes = 0; iNo = 0;  % Initialize Counters
    for i = 1:numMembers
        if(SignalTrace(i).NumUsed == 0)
            iNo = iNo + 1;
            lstUnused(iNo,:) = { SignalTrace(i).SignalName };
        else
            iYes = iYes + 1;
            lstUsed(iYes,:) = { SignalTrace(i).SignalName };
        end
    end
    
    if(nargout == 0)
        clc;
        assignin('base', 'lstUsed',     lstUsed);       lstUsed
        assignin('base', 'lstUnused',   lstUnused);     lstUnused
        assignin('base', 'SignalTrace', SignalTrace);   SignalTrace
    end
    
else
    disp(sprintf('%s : Warning : SignalTrace was not run.  Returning empty results.', mfnam));

end

end % << End of function GetSignalInfo >>

%% ========================================================================
function [SignalTrace] = GetSignalTrace(curBC, lstBusMembers, SignalTrace, flgDirection)

if(nargin < 4)
    flgDirection = 1; % Forward Trace
end

% TODO: Add Back Trace
if(flgDirection == 1)

try
    hdlLH = get_param(curBC, 'LineHandles');
    arrDstBlkHdl = get_param(hdlLH.Outport, 'DstBlockHandle');
    arrDstPortHdl = get_param(hdlLH.Outport, 'DstPortHandle');
catch
    arrDstBlkHdl = get_param(curBC, 'DstBlockHandle');
    arrDstPortHdl = get_param(curBC, 'DstPortHandle');
end

numPaths = length(arrDstBlkHdl);
if(numPaths == 0)
    if(strcmp(get_param(curBC, 'BlockType'), 'Outport'))
        numPaths = 1;
        arrDstBlkHdl = curBC;
    end
end

for iPath = 1:numPaths
    curBlk = arrDstBlkHdl(iPath);
    
    curBlkName  = get_param(curBlk, 'Name');
    curBlkType  = get_param(curBlk, 'BlockType');
    curBlkParent= get_param(curBlk, 'Parent');
    
    switch curBlkType
        case 'BusCreator'
            
            curBlkInputPortHdl = get_param(hdlLH.Outport(iPath), 'DstPortHandle');
            numInput = get_param(curBlkInputPortHdl(1), 'PortNumber');
            
            hdlLH2 = get_param(curBlk, 'LineHandles');
            try
            strBus2Add = get_param(hdlLH2.Inport(numInput), 'Name');
            catch exception
                rethrow(exception);
            end
            
            for i = 1:size(lstBusMembers, 1)
                lstBusMembersNew(i,:) = { [strBus2Add '.' lstBusMembers{i,:}] };
            end
            
            [SignalTrace] = GetSignalTrace(curBlk, lstBusMembersNew, SignalTrace);
            
        case {'Memory'; 'UnitDelay'; 'ZeroOrderHold'; 'Switch';
                'MultiPortSwitch'; 'BusAssignment'}
            [SignalTrace] = GetSignalTrace(curBlk, lstBusMembers, SignalTrace);
            
        case {'Goto'}
            strGoto = get_param(curBlk, 'GotoTag');
            curLevel = get_param(curBlk, 'Parent');
            lstFrom = find_system(curLevel, 'SearchDepth', 1, ...
                'BlockType', 'From', 'GotoTag', strGoto);
            for iFrom = 1:size(lstFrom, 1)
                curFrom = lstFrom{iFrom,:};
                [SignalTrace] = GetSignalTrace(curFrom, lstBusMembers, SignalTrace);
            end
            
        case {'SubSystem'}
            % You've got to go into the subsystem           
            curBlkInputPortHdl = arrDstPortHdl(iPath);
            numInput = get_param(curBlkInputPortHdl, 'PortNumber');
            curParent = get_param(curBlk, 'Parent');
            curPathToInternalInputPort = [curParent '/' curBlkName];
            
            lstInports = find_system(curPathToInternalInputPort', ...
                'SearchDepth', 1, 'LookUnderMasks', 'all', ...
                'FollowLinks','on','BlockType','Inport');
            curBlkInputPort = lstInports{numInput,:};
            [SignalTrace] = GetSignalTrace(curBlkInputPort, lstBusMembers, SignalTrace);
            
            lstInportShadows = find_system(curPathToInternalInputPort', ...
                'SearchDepth', 1, 'LookUnderMasks', 'all', ...
                'FollowLinks','on','BlockType','InportShadow');
            
            if(~isempty(lstInportShadows))   
                for iInportShadow = 1:size(lstInportShadows, 1)
                    curInportShadow = lstInportShadows{iInportShadow, :};
                    curInportShadowPortNum = get_param(curInportShadow, 'Port');
                    
                    if( strcmp(curInportShadowPortNum, num2str(numInput)) )
                        [SignalTrace] = GetSignalTrace(curInportShadow, lstBusMembers, SignalTrace);
                    end
                end
            end
            
        case 'Outport'
            numOutport = str2num(get_param(curBlk, 'Port'));
            curParent = get_param(curBlk,'Parent');
            lstPorts = get_param(curParent, 'PortHandles');
            hdlOutport = lstPorts.Outport(numOutport);
            hdlOutportLine = get_param(hdlOutport, 'Line');
            [SignalTrace] = GetSignalTrace(hdlOutportLine, lstBusMembers, SignalTrace);
            
        case 'BusSelector'
            
            lstSelected = get_param(curBlk, 'OutputSignals');
            lstSelected = str2cell(lstSelected, ',');
            lstSelected = unique(lstSelected);
            [lstSignalsUsed, arrUsed] = intersect(lstBusMembers, lstSelected);
            
            for i = 1:length(arrUsed)
                curIndex = arrUsed(i);
                iCtr = SignalTrace(curIndex).NumUsed + 1;
                SignalTrace(curIndex).NumUsed = iCtr;
                SignalTrace(curIndex).UseCase(iCtr).FinalName = lstSignalsUsed{i,:};
                SignalTrace(curIndex).UseCase(iCtr).Block = curBlkName;
            end
            
        case 'Terminator'
            % Do Nothing?
            
        otherwise
            disp(['GetSignalInfo/GetSignalTrace: Unknown Block Type: ' curBlkType ...
                ' for Block: ' strrep(curBlkName, char(10), ' ')]);
            
    end
end

else
    % Backtrace section
    disp(sprintf('%s : ERROR: Backtracing has not yet been filled out', mfilename));

end % << end on (flgDirection) >>

end % << end on GetSignalTrace >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 110408 <INI>: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName            : Email     : NGGN Username 
% <initials>: <Fullname>   : <email>   : <NGGN username> 

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
