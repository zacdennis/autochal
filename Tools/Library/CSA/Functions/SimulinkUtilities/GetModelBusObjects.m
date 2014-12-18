% GETMODELBUSOBJECTS Finds all bus objects used in a Simulink model
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GetModelBusObjects:
%     Finds all bus objects used in a Simulink model
%
% SYNTAX:
%	[structBO, lstBO] = GetModelBusObjects(lstMRs, flgVerbose)
%	[structBO, lstBO] = GetModelBusObjects(lstMRs)
%
% INPUTS:
%	Name        Size        Units		Description
%	lstMRs      {m x 1}     {'string'}  List of Simulink models in which to
%                                        search for bus object usage
%   flgVerbose  [1]         boolean     Give updates on function progress?
%                                        Optional input; default is false
%
% OUTPUTS:
%	Name        Size		Units		Description
%	structBO	{nested struct}         List of bus objects found in each
%                                        Simulink model; arranged by
%                                        Simulink model
%   lstBO       {n x 1}     {'string'}  List of all bus objects found in
%                                        all Simulink models
%
% NOTES:
%
% EXAMPLES:
%	% Example 1: Find Bus Objects in MATLAB's 'sldemo_mdlref_counter_bus' 
%   %   (from the 'sldemo_mdlref_bus' example)
%   lstMRs = 'sldemo_mdlref_counter_bus'
%	[structBO, lstBO] = GetModelBusObjects(lstMRs)
%	% Returns 'structBO' of:
%   %    'COUNTERBUS'
%   %    'LIMITBUS'
%   %    'INCREMENTBUS'
%
%   % Example 2: Same as Example 1, but show multiple
%   copyfile(which('sldemo_mdlref_counter_bus'), [pwd filesep 'sldemo_mdlref_counter_bus2.slx'])
%   lstMRs = {'sldemo_mdlref_counter_bus'; 'sldemo_mdlref_counter_bus2'}
%	[structBO, lstBO] = GetModelBusObjects(lstMRs)
%	% Returns 'structBO' of:
%   %    sldemo_mdlref_counter_bus: {3x1 cell}
%   %   sldemo_mdlref_counter_bus2: {3x1 cell}
%   %
%   % where 'structBO.sldemo_mdlref_counter_bus' is:
%   %    'COUNTERBUS'
%   %    'LIMITBUS'
%   %    'INCREMENTBUS'
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit GetModelBusObjects.m">GetModelBusObjects.m</a>
%	  Driver script: <a href="matlab:edit Driver_GetModelBusObjects.m">Driver_GetModelBusObjects.m</a>
%	  Documentation: <a href="matlab:winopen(which('GetModelBusObjects_Function_Documentation.pptx'));">GetModelBusObjects_Function_Documentation.pptx</a>
%
% See also spaces
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/856
%
% Copyright Northrop Grumman Corp 2014
% Maintained by: Aerospace Systems
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/GetModelBusObjects.m $
% $Rev: 3250 $
% $Date: 2014-09-09 16:04:44 -0500 (Tue, 09 Sep 2014) $
% $Author: sufanmi $

function [structBO, lstBO] = GetModelBusObjects(lstMRs, flgVerbose)

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

%% Main Function:
if((nargin < 2) || isempty(flgVerbose))
    flgVerbose = 0;
end

if(nargin == 0)
    lstMRs = bdroot;
end

if(~iscell(lstMRs))
    lstMRs = { lstMRs };
end

numMRs = size(lstMRs, 1);

lstBO_Master = {};

for iMR = 1:numMRs
    curMR = lstMRs{iMR,1};
    load_system(curMR);
    if(flgVerbose)
        strIntro = sprintf('%s : [%d/%d] :', mfilename, iMR, numMRs);
        
        disp(sprintf('%s Searching ''%s'' for bus object usage...', ...
            strIntro, curMR));
    end
    
    lstBO = {}; iBO = 0;
    
    for iLoop = 1:3
        switch iLoop
            case 1
                % Find all Input ports:
                strBlockType = 'Inport';
            case 2
                % Find all Output ports:
                strBlockType = 'Outport';
            case 3
                % Find all BusCreators
                strBlockType = 'BusCreator';
            otherwise
        end
        
        if(flgVerbose)
            disp(sprintf('%s Searching ''%s'' for all %ss...', ...
                spaces(length(strIntro)), curMR, strBlockType));
        end
        hBlocks = find_system(curMR, 'FollowLinks', 'on', ...
            'LookUnderMasks', 'all', 'BlockType', strBlockType);
        nBlocks = size(hBlocks,1);
        
        if(flgVerbose)
            disp(sprintf('%s Found %d %ss.  Looking for associated bus objects...', ...
                spaces(length(strIntro)), nBlocks, strBlockType));
        end
        
        for iBlock = 1:nBlocks
            hBlock           = hBlocks{iBlock};
            
            lstBusesToAdd = {};
            switch iLoop
                case {1, 2}
                    strBusObject    = get_param(hBlock, 'BusObject');
                    
                    if(~strcmp(strBusObject, 'BusObject'))
                        lstSignals = BusObject2List(strBusObject);
                        lstBusesToAdd = unique([strBusObject; lstSignals(:,4)]);

                        strPort     = get_param(hBlock, 'Port');
                        strParent   = get_param(hBlock, 'Parent');
                        strName     = get_param(hBlock, 'Name');
                        strNote     = sprintf(' (%s #%s)', strBlockType, strPort);
                    end
                    
                case 3
                    % TBD
                    OutDataTypeStr = get_param(hBlock, 'OutDataTypeStr');
                    OutDataTypeStr = strrep(OutDataTypeStr, 'Inherit: auto', '');
                    OutDataTypeStr = strrep(OutDataTypeStr, 'Bus: ', '');
                    if(~isempty(OutDataTypeStr))
                        strBusObject = OutDataTypeStr;
                        lstSignals = BusObject2List(strBusObject);
                        lstBusesToAdd = unique([strBusObject; lstSignals(:,4)]);

                        strParent   = get_param(hBlock, 'Parent');
                        strName     = get_param(hBlock, 'Name');
                        strNote     = '';
                    end
                    
                otherwise
            end
            
            numBusesToAdd = size(lstBusesToAdd, 1);
            for iBusToAdd = 1:numBusesToAdd
                curBusToAdd = lstBusesToAdd{iBusToAdd, :};

                if(~any(strcmp(lstBO, curBusToAdd)))
                    iBO = iBO + 1;
                    lstBO(iBO,1) = { curBusToAdd };
                    
                    str2add = sprintf('%s/%s%s', strParent, strName, strNote);
                    str2add = strrep(str2add, char(10), '_');
                    
                    lstBO(iBO,2) = { str2add };
                end
            end
        end
    end
    
    lstBO_Master = [lstBO_Master; lstBO(:,1)];
    structBO.(curMR) = lstBO;
end

if(numMRs == 1)
    structBO = lstBO;
end
lstBO = unique(lstBO_Master);

if(nargout == 0)
    assignin('base', 'lstBO', lstBO);
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
