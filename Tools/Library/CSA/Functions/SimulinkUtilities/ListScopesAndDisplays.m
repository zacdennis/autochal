% LISTSCOPESANDDISPLAYS Lists all the scopes and displays in a given model
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ListScopesAndDisplays:
%     Lists the full path to all scopes and displays in a given model. This
%     function is useful when you need to ensure that a given model is
%     completely clean of scopes and displays (e.g. for distribution or
%     auto-coding purposes).
% 
% SYNTAX:
%	[lstModelPaths] = ListScopesAndDisplays(lstModels)
%	[lstModelPaths] = ListScopesAndDisplays()
%
% INPUTS: 
%	Name         	Size		Units		Description
%	lstModels	    'string'    [char]      List of simulation models to
%                    or {'string'}          search for displays and scopes
%                                           Default: bdroot
% OUTPUTS: 
%	Name         	Size		Units		Description
%	lstModelPaths	{'string'}  {[char]}    List of full paths to any
%                                           displays or scopes in the
%                                           specified models.
% NOTES:
%
% EXAMPLES:
%	% Find all displays and scopes in the MATLAB van der Pol example, vdp:
%	[lstModelPaths] = ListScopesAndDisplays('vdp')
%   % returns:
%   %    'vdp/Scope'
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ListScopesAndDisplays.m">ListScopesAndDisplays.m</a>
%	  Driver script: <a href="matlab:edit Driver_ListScopesAndDisplays.m">Driver_ListScopesAndDisplays.m</a>
%	  Documentation: <a href="matlab:pptOpen('ListScopesAndDisplays_Function_Documentation.pptx');">ListScopesAndDisplays_Function_Documentation.pptx</a>
%
% See also find_system 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/723
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/ListScopesAndDisplays.m $
% $Rev: 2113 $
% $Date: 2011-08-17 18:32:46 -0500 (Wed, 17 Aug 2011) $
% $Author: sufanmi $

function [lstModelPaths] = ListScopesAndDisplays(lstModels)

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
lstModelPaths= {};

%% Input Argument Conditioning:
if( (nargin == 0) || isempty(lstModels) )
    lstModels = bdroot;
end

if(ischar(lstModels))
    lstModels = { lstModels };
end

%% Main Function:
numModels = size(lstModels, 1);
for iModel = 1:numModels
    curModel = lstModels{iModel, :};
    load_system(curModel);
    
    for iLoop = 1:2
        switch iLoop
            case 1
                strBlock = 'Display';
            case 2
                strBlock = 'Scope';
        end
        
        hdlBlocks = find_system(curModel, ...
            'FollowLinks', 'on', 'LookUnderMasks', 'all', ...
            'FindAll', 'on', 'BlockType', strBlock);

        numBlocks = length(hdlBlocks);
        
        for iBlock = 1:numBlocks
            hdl = hdlBlocks(iBlock);
            curParent   = get_param(hdl, 'Parent');
            curName     = get_param(hdl, 'Name');
            curFullPath = [curParent '/' curName];
            
            lstModelPaths = [lstModelPaths; curFullPath];
        end
    end
end

%% Compile Outputs:

end % << End of function ListScopesAndDisplays >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110817 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         : Email                 : NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi

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
