% CHANGELOGICALBLOCKICONS Change Logic Block Icon Shapes
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ChangeLogicalBlockIcons:
%     Changes all logic block icon shapes to be either 'rectangular'
%     (Simulink default), 'distinctive', or the 'flip' of what they're
%     currently set to.
%
% SYNTAX:
%	ChangeLogicalBlockIcons(lstModels, strIconShape)
%	ChangeLogicalBlockIcons(lstModels)
%	ChangeLogicalBlockIcons()
%
% INPUTS:
%	Name        	Size		Units		Description
%	lstModels       {n x 1}     {'string'}  List of Simulink models to
%                                            alter.
%                                            Optional input; default is
%                                            'bdroot'
%	strIconShape	'string'    [char]      Desired Icon Shape. Either:
%                                            0 or 'rectangular',
%                                            1 or 'distinctive', or
%                                            'flip'
%                                            Optional input; default is 0
%                                            ('rectangular')
%
% OUTPUTS:
%	Name        	Size		Units		Description
%	None
%
% NOTES:
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[] = ChangeLogicalBlockIcons(lstModels, strIconShape, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ChangeLogicalBlockIcons.m">ChangeLogicalBlockIcons.m</a>
%	  Driver script: <a href="matlab:edit Driver_ChangeLogicalBlockIcons.m">Driver_ChangeLogicalBlockIcons.m</a>
%	  Documentation: <a href="matlab:winopen(which('ChangeLogicalBlockIcons_Function_Documentation.pptx'));">ChangeLogicalBlockIcons_Function_Documentation.pptx</a>
%
% See also <add relevant functions>
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/858
%
% Copyright Northrop Grumman Corp 2014
% Maintained by: Aerospace Systems
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/ChangeLogicalBlockIcons.m $
% $Rev: 3280 $
% $Date: 2014-10-21 19:24:35 -0500 (Tue, 21 Oct 2014) $
% $Author: sufanmi $

function [] = ChangeLogicalBlockIcons(lstModels, strIconShape)

%% Input Argument Conditioning:
if( (nargin < 1) || isempty(strIconShape) )
    strIconShape = 'rectangular';
end
if(strIconShape == 0)
    strIconShape = 'rectangular';
elseif(strIconShape == 1)
    strIconShape = 'distinctive';
end
strIconShape = lower(strIconShape);

if(nargin == 0)
    lstModels = bdroot;
end

if(~iscell(lstModels))
    lstModels = { lstModels };
end

% Turn Warning Messages Off
msgID = 'Simulink:Commands:SetParamLinkChangeWarn';
warning('off', msgID);

flgOk = any(strcmp(strIconShape, {'rectangular'; 'distinctive';'flip'}));
flgFlip = strcmp(strIconShape, 'flip');

%% Main Function:
if(~flgOk)
   disp(sprintf('%s : Icon Shape ''%s'' is NOT recognized.  Ignoring call.', ...
                mfilename, strIconShape));
else
    numModels = size(lstModels, 1);
    for iModel = 1:numModels
        curModel = lstModels{iModel, 1};
        
        if(flgFlip)
             disp(sprintf('%s : [%d/%d] : Flipping ALL logical blocks in %s...', ...
                mfilename, iModel, numModels, curModel));
        else
            disp(sprintf('%s : [%d/%d] : Changing ALL logical blocks in %s to be %s...', ...
                mfilename, iModel, numModels, curModel, strIconShape));
        end
        
        lstBlocks = find_system(curModel, 'FollowLinks', 'on', ...
            'LookUnderMasks', 'all', 'BlockType', 'Logic');
        nBlocks = size(lstBlocks,1);

        for iBlock = 1:nBlocks
            curBlock = lstBlocks{iBlock};
                        
            if(flgFlip)
                curIconShape = get_param(curBlock, 'IconShape');
                if(strcmp(curIconShape, 'rectangular'))
                    flippedIconShape = 'distinctive';
                else
                    flippedIconShape = 'rectangular';
                end
                set_param(curBlock, 'IconShape', flippedIconShape);
            else
                set_param(curBlock, 'IconShape', strIconShape);
            end
        end
    end
end

disp(sprintf('%s : Finished!', mfilename));

% Turn Warning Messages Back On
warning('on', msgID);

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
