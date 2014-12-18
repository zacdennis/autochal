% MFILELINE File name and current line number of a running .m file
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% mfileline:
%     File name and current line number of a running .m file. Place in a 
%     script to help with debugging.
% 
% SYNTAX:
%	[strLine] = mfileline(strOption)
%	[strLine] = mfileline()
%
% INPUTS: 
%	Name    	Size		Units		Description
%   strOption   'string'    [char]      If 'fullpath', will return full
%                                       path of mfile
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	strLine     'string'    [char]      m-file name and line number
%
% NOTES:
%   Place in a script to help with debugging.
%
% EXAMPLES:
%
%	% Drop this into an m-file
%	disp([mfileline ' : <Describe what''s happening here...>'])
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit mfileline.m">mfileline.m</a>
%
% See also dbstack
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/847
%  
% Copyright Northrop Grumman Corp 2014
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/mfileline.m $
% $Rev: 3156 $
% $Date: 2014-04-22 15:43:30 -0500 (Tue, 22 Apr 2014) $
% $Author: sufanmi $

function [strLine] = mfileline(strOption)

if(nargin == 0)
    strOption = '';
end

    Stack  = dbstack;
    numLevels = size(Stack, 1);
    
    if(numLevels == 1)
        strLine = 'Command Prompt (1)';
    else
        if(strcmp(lower(strOption), 'fullpath'))
            strLine = sprintf('%s (%d)', which(Stack(2).name), Stack(2).line);
        else
            strLine = sprintf('%s (%d)', Stack(2).name, Stack(2).line);
        end
    end

end % << End of function mfileline >>

%% AUTHOR
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
