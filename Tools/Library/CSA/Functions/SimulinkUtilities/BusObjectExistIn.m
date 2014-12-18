% BUSOBJECTEXISTIN Determines if a Bus Object is used in a Simulink Model
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BusObjectExistIn:
%     Determines if a Bus Object is used in a Simulink Model.  Function
%     supports searching multiple Simulink models for multiple bus objects.
% 
% SYNTAX:
%   lstFoundMRs = BusObjectExistIn(lstBOs, lstMRs)
%
% INPUTS: 
%	Name        Size		Units		Description
%	lstBOs      {m x 1}     {'string'}  List of bus objects to look for
%	lstMRs      {n x 1}     {'string'}  List of Simulink models in which to
%                                        look for said bus objects
%
% OUTPUTS: 
%	Name       	Size		Units		Description
%	lstFoundMRs	{nested struct}         List of Simulink models using said
%                                        bus object
%
% NOTES:
%	
% EXAMPLES:
%   % Example: Show 'BusObjectExistIn' working for a standard MATLAB model
%   %   Backgroud: Find Bus Objects in MATLAB's 'sldemo_mdlref_counter_bus' 
%   %   (from the 'sldemo_mdlref_bus' example)
%   lstMRs = 'sldemo_mdlref_counter_bus'
%	[structBO, lstBO] = GetModelBusObjects(lstMRs)
%	% Returns 'structBO' of:
%   %    'COUNTERBUS'
%   %    'LIMITBUS'
%   %    'INCREMENTBUS'
%   %
%   % Determine if the 'LIMITBUS' (a known bus) and 'SOMETHING_ELSE' (an
%   %  unknown bus) exists in 'sldemo_mdlref_counter_bus'
%   lstBOs = {'LIMITBUS'; 'SOMETHING_ELSE'}
%   lstMRs = 'sldemo_mdlref_counter_bus'
%	[lstFoundMRs] = BusObjectExistIn(lstBOs, lstMRs)
%   % Returns a 'lstFoundMRs' of:
%   %   LIMITBUS: {'sldemo_mdlref_counter_bus'}
%   %   SOMETHING_ELSE: {}  <-- IE, it is not used by this model
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit BusObjectExistIn.m">BusObjectExistIn.m</a>
%	  Driver script: <a href="matlab:edit Driver_BusObjectExistIn.m">Driver_BusObjectExistIn.m</a>
%	  Documentation: <a href="matlab:winopen(which('BusObjectExistIn_Function_Documentation.pptx'));">BusObjectExistIn_Function_Documentation.pptx</a>
%
% See also GetModelBusObjects
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/857
%  
% Copyright Northrop Grumman Corp 2014
% Maintained by: Aerospace Systems
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/BusObjectExistIn.m $
% $Rev: 3250 $
% $Date: 2014-09-09 16:04:44 -0500 (Tue, 09 Sep 2014) $
% $Author: sufanmi $

function [lstFoundMRs] = BusObjectExistIn(lstBOs, lstMRs)

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
lstFoundMRs = {};

%% Input Argument Conditioning:
%  Ensure 'lstBOs' is a cell
if(~iscell(lstBOs))
    lstBOs = { lstBOs };
end
numBO = size(lstBOs, 1);

% Check to see if 'GetModelBusObjects' has already been externally called
if(isstruct(lstMRs))
    lstMR_BO = lstMRs;
else
    if(~iscell(lstMRs))
        lstMRs = { lstMRs };
    end
    numMRs = size(lstMRs, 1);
    lstMR_BO = GetModelBusObjects(lstMRs, 0);
    if(numMRs == 1)
        lstMR_BO.(lstMRs{1}) = lstMR_BO;
    end
end

lstMRs = fieldnames(lstMR_BO);
numMRs = size(lstMRs, 1);

for iBO = 1:numBO
    curBO = lstBOs{iBO, 1};
    iExistIn = 0; lstExistIn = {};
    for iMR = 1:numMRs
        curMR = lstMRs{iMR, 1};
        lst_MR_BOs = lstMR_BO.(curMR);
        if(any(strcmp(lst_MR_BOs(:,1), curBO)))
            num_MR_BOs = size(lst_MR_BOs, 1);
            iMatch = max(strcmp(lst_MR_BOs(:,1), curBO) .* [1:num_MR_BOs]');
            iExistIn = iExistIn + 1;
            lstExistIn(iExistIn,1) = { curMR };
            lstExistIn(iExistIn,2) = { lst_MR_BOs{iMatch, 2} };
        end
    end
    lstFoundMRs.(curBO) = lstExistIn;
end

if(numBO == 1)
    lstFoundMRs = lstExistIn;
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
