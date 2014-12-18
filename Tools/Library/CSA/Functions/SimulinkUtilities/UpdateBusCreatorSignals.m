% UPDATEBUSCREATORSIGNALS Performs a find/replace on bus creator signals
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% UpdateBusCreatorSignals:
%     Performs a find/replace on bus creator signals 
% 
% SYNTAX:
%	UpdateBusCreatorSignals(lstBC, lstFindReplace)
%
% INPUTS: 
%	Name          	Size		Units		Description
%	lstBC	        {n x 1}     {'string'}  Cell array list of bus
%                                           creators or subsystems
%                                           containing bus cerators to
%                                           modify
%	lstFindReplace	{m x 2}		<units>		Cell array list of signals to
%                                           find {:,1} and replace {:,2}.
%
% OUTPUTS: 
%	Name          	Size		Units		Description
%	lstBC_Updated   {o x 1}     {'string'}  Cell array list of bus
%                                           creators actually modified
%
% NOTES:
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[] = UpdateBusCreatorSignals(lstBC, lstFindReplace, varargin)
%	% <Copy expected outputs from Command Window>
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit UpdateBusCreatorSignals.m">UpdateBusCreatorSignals.m</a>
%	  Driver script: <a href="matlab:edit Driver_UpdateBusCreatorSignals.m">Driver_UpdateBusCreatorSignals.m</a>
%	  Documentation: <a href="matlab:winopen(which('UpdateBusCreatorSignals_Function_Documentation.pptx'));">UpdateBusCreatorSignals_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/864
%  
% Copyright Northrop Grumman Corp 2014
% Maintained by: Aerospace Systems
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/UpdateBusCreatorSignals.m $
% $Rev: 3318 $
% $Date: 2014-11-26 17:22:43 -0600 (Wed, 26 Nov 2014) $
% $Author: sufanmi $

function lstBC_Updated = UpdateBusCreatorSignals(lstBC, lstFindReplace)

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
lstBC_Updated = {}; iUpdated = 0;

%% Main Code:
nFR = size(lstFindReplace, 1);
if(~iscell(lstBC))
    lstBC = { lstBC };
end
lstBC_master = lstBC;
numBC_master = size(lstBC_master, 1);

for iBC_master = 1:numBC_master
    curBC_master = lstBC_master{iBC_master, 1};
    
    % Load the reference model
    ptrSlash = findstr(curBC_master, '/');
    if(isempty(ptrSlash))
        rootSim = curBC_master;
    else
        rootSim = curBC_master(1:ptrSlash(1)-1);
    end
    load_system(rootSim);
    
    BlockType = get_param(curBC_master, 'BlockType');
    if(strcmp(BlockType, 'SubSystem'))
            lstBC = find_system(curBC_master, 'BlockType', 'BusCreator');
    else
        lstBC = { curBC_master };
    end
    
    nBC = size(lstBC, 1);
    for iBC = 1:nBC
        curBC   = lstBC{iBC};
        lstISN  = get_param(curBC, 'InputSignalNames');
        lstPorts= get_param(curBC, 'PortHandles');
        nISN = size(lstISN, 2);
        for iISN = 1:nISN
            curISN = lstISN{iISN};
            for iFR = 1:nFR
                curFind = lstFindReplace{iFR, 1};
                curReplace = lstFindReplace{iFR, 2};
                if(strcmp(curISN, curFind))
                    iUpdated = iUpdated + 1;
                    lstBC_Updated{iUpdated,1} = curBC;
                    hdlLine = get_param(lstPorts.Inport(iISN), 'Line');
                    set_param(hdlLine, 'Name', curReplace);
                    break;
                end
            end
        end
    end
end

lstBC_Updated = unique(lstBC_Updated);
if(size(lstBC_Updated, 1) == 1)
    lstBC_Updated = lstBC_Updated{1};
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
