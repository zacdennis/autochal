% UPDATEBUSSELECTORSIGNALS Performs a find/replace on bus selector signals
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% UpdateBusSelectorSignals:
%     Performs a find/replace on bus selector signals.  Useful when making
%     large changes to bus object signals.
% 
% SYNTAX:
%	lstBS_Updated = UpdateBusSelectorSignals(lstBS, lstFindReplace)
%
% INPUTS: 
%	Name          	Size		Units		Description
%	lstBS	        {n x 1}     {'string'}  Cell array list of bus
%                                           selectors or subsystems
%                                           containing bus selectors to
%                                           modify
%	lstFindReplace	{m x 2}		<units>		Cell array list of signals to
%                                           find {:,1} and replace {:,2}.
%
% OUTPUTS: 
%	Name          	Size		Units		Description
%	lstBS_Updated   {o x 1}     {'string'}  Cell array list of bus
%                                           selectors actually modified
%
% NOTES:
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[] = UpdateBusSelectorSignals(lstBS, lstFindReplace, varargin)
%	% <Copy expected outputs from Command Window>
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit UpdateBusSelectorSignals.m">UpdateBusSelectorSignals.m</a>
%	  Driver script: <a href="matlab:edit Driver_UpdateBusSelectorSignals.m">Driver_UpdateBusSelectorSignals.m</a>
%	  Documentation: <a href="matlab:winopen(which('UpdateBusSelectorSignals_Function_Documentation.pptx'));">UpdateBusSelectorSignals_Function_Documentation.pptx</a>
%
% See also UpdateBusCreatorSignals 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/865
%  
% Copyright Northrop Grumman Corp 2014
% Maintained by: Aerospace Systems
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/UpdateBusSelectorSignals.m $
% $Rev: 3320 $
% $Date: 2014-12-03 17:34:07 -0600 (Wed, 03 Dec 2014) $
% $Author: sufanmi $

function lstBS_Updated = UpdateBusSelectorSignals(lstBS, lstFindReplace)

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
lstBS_Updated = {}; iUpdated = 0;

%% Main Code:
nFR = size(lstFindReplace, 1);
if(~iscell(lstBS))
    lstBS = { lstBS };
end
lstBS_master = lstBS;
numBS_master = size(lstBS_master, 1);

for iBS_master = 1:numBS_master
    curBS_master = lstBS_master{iBS_master, 1};
    
    % Load the reference model
    ptrSlash = findstr(curBS_master, '/');
    if(isempty(ptrSlash))
        rootSim = curBS_master;
    else
        rootSim = curBS_master(1:ptrSlash(1)-1);
    end
    load_system(rootSim);
    
    BlockType = get_param(curBS_master, 'BlockType');
    if(strcmp(BlockType, 'SubSystem'))
            lstBS = find_system(curBS_master, 'BlockType', 'BusSelector');
    else
        lstBS = { curBS_master };
    end
    
    nBS = size(lstBS, 1);
    for iBS = 1:nBS
        curBS = lstBS{iBS};
        strOS = get_param(curBS, 'OutputSignals');
        for iFR = 1:nFR
            curFind = lstFindReplace{iFR, 1};
            curReplace = lstFindReplace{iFR, 2};
            
            if(~isempty(strfind(strOS, curFind)))
                iUpdated = iUpdated + 1;
                lstBS_Updated{iUpdated,1} = curBS;
                strOS = strrep(strOS, curFind, curReplace);
            end
        end
        set_param(curBS, 'OutputSignals', strOS);
    end
end

lstBS_Updated = unique(lstBS_Updated);
if(size(lstBS_Updated, 1) == 1)
    lstBS_Updated = lstBS_Updated{1};
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
