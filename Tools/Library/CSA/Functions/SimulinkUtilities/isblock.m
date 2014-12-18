% ISBLOCK Checks whether a block exists in a Simulink model.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% isblock:
%     <Function Description> 
% 
% SYNTAX:
%	[flgExists, hdl] = isblock(blockName, modelName, tokens)
%	[flgExists, hdl] = isblock(blockName, modelName)
%	[flgExists, hdl] = isblock(blockName)
%
% INPUTS: 
%	Name            Size		Units		Description
%	blockName		'string'    N/A         Block Name Supported
%                                            'Text'
%                                            'DocBlock'
%	modelName		'string'    N/A         Name of Simulink Diagram
%                                            Default: bdroot
%   tokens          'string' or {'strings'} String or Cell array of string
%                                            inputs to look for in 'Text'
%
% OUTPUTS: 
%	Name		Size		Units		Description
%	flgExists	[1]         'bool'      Does Block Exist?
%   hdl         [1]         [handle]    Handle to Block
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	flgExists = isblock('Text', 'TEST_Coesa1976/COESA_1976_Atmosphere',	{'Subversion';'URL';'Rev'})
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[flgExists] = isblock(blockName)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%	[1]    http://www...
%	[2]    Author. Book Title. Publisher, City, Copyright year
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit isblock.m">isblock.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_isblock.m">DRIVER_isblock.m</a>
%	  Documentation: <a href="matlab:pptOpen('isblock Documentation.pptx');">isblock Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/563
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/isblock.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [flgExists, hdl] = isblock(blockName, modelName, tokens)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Initialize Outputs:
flgExists = 0;
hdl = [];
pathToBlock = '';

%% Input Argument Conditioning:
%  Example:
switch nargin
    case 1
        tokens = ''; modelName = bdroot;
    case 2
        tokens = ''; 
end

%% Main Function:
switch(blockName)
    case 'DocBlock'
        try
        lstBlocks = find_system(modelName, 'FindAll', 'on', 'LookUnderMasks', 'all', 'FollowLinks', 'on', 'BlockType', 'SubSystem');
        catch
           [strWarn, msgWarn] = lastwarn;
           disp(sprintf('%s : Warning : %s for block %s', mfnam, msgWarn, modelName));
        end
        
        for i = 1:size(lstBlocks, 1)
            curParent = get_param(lstBlocks(i), 'Parent');
            flgParentMatch = strcmp(curParent, modelName);
            
            curName = get_param(lstBlocks(i), 'Name');
            flgNameMatch = ~isempty(strfind(curName, 'DocBlock'));
            
            flgExists = (flgParentMatch && flgNameMatch);
            
            if(flgExists)
                if(isempty(tokens))
                    flgTokensExists = 1;
                else
                    UserData = get_param(lstBlocks(i), 'UserData');
                    curText = UserData.content;
                    expmatch = regexp(curText, tokens);
                    flgTokensExists = ~isempty(expmatch{1});
                end
                
                if(flgTokensExists)
                    pathToBlock = [curParent '/' curName];
                    hdl = lstBlocks(i);
                    break;
                end
            end
        end
        
    case 'Text'
        
        lstBlocks = find_system(modelName, 'FindAll', 'on', 'LookUnderMasks', 'all', 'FollowLinks', 'on', 'type', 'annotation');
        
        for i = 1:size(lstBlocks,1)
            curParent = get_param(lstBlocks(i), 'Parent');
            flgParentMatch = strcmp(curParent, modelName);
            
            curText = get_param(lstBlocks(i), 'Text');
            expmatch = regexp(curText, tokens);
            
            flgTokensExists = ~isempty(expmatch{1});
            flgExists = (flgTokensExists && flgParentMatch);
            if(flgExists)
                pathToBlock = [curParent '/' curText];
                hdl = lstBlocks(i);
                break;
            end
        end
        
    otherwise
        
end

end % << End of function isblock >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 100817 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName  :  Email  :  NGGN Username 
% <initials>: <Fullname> : <email> : <NGGN username> 

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
