% SVNINFO Retrieves TortoiseSVN Info
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% svninfo:
%     Retireves Tortoise SVN souce control information
%
% SYNTAX:
%	info = svninfo(strItem, strField)
%	info = svninfo(strItem)
%	info = svninfo()
%
% INPUTS:
%	Name    	Size		Units		Description
%   strItem     'string'    [char]      Folder or file on which to perform
%                                        the 'svn info' command
%                                        Optional: Default is 'pwd'
%	strField	'string'    [char]      SVN Information to retrieve
%                                       (optional)
%
% OUTPUTS:
%	Name    	Size		Units		Description
%	info	    {struct}    {[char]}    All SVN Information
%                -or-                   -or-
%               'string'    [char]      Desired SVN Information
%
% NOTES:
%
% EXAMPLES:
%	% Example #1a: Get all available SVN Information for current directory
%	info = svninfo()
%
%   % Example #1b: Get just the 'Revision' number for the current directory
%   Revision = svninfo('', 'Revision')
%
%   % Example #2: Get SVN information for this function
%   info = svninfo('svninfo.m')
%
%   % Example #3: Get SVN information for a non version controlled file
%   %            (Error checking)
%   mkdir('junk')
%   info = svninfo('junk')
%   % Remember to remove directory: rmdir('junk')
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit svninfo.m">svninfo.m</a>
%	  Driver script: <a href="matlab:edit Driver_svninfo.m">Driver_svninfo.m</a>
%	  Documentation: <a href="matlab:winopen(which('svninfo_Function_Documentation.pptx'));">svninfo_Function_Documentation.pptx</a>
%
% See also <add relevant functions>
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/846
%
% Copyright Northrop Grumman Corp 2014
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SourceControlUtilities/svninfo.m $
% $Rev: 3153 $
% $Date: 2014-04-21 19:27:22 -0500 (Mon, 21 Apr 2014) $
% $Author: sufanmi $

function [info] = svninfo(strItem, strField)

if(nargin < 2)
    strField = '';
end

if((nargin < 1) || isempty(strItem))
    strItem = pwd;
end

info = {};

%%
flgRun = 1;
HD = pwd;
if(isdir(strItem))
    % It's a directory
    cd(strItem);
    ec = ['!svn info > svn_info.tmp'];
    eval(ec);
else
    % It's a file
    flgRun = (exist(which(strItem)) ~= 0);
    
    if(flgRun)
        [strDir, strName, strExt] = fileparts(which(strItem));
        cd(strDir);
        ec = ['!svn info ' strName strExt ' > svn_info.tmp'];
        eval(ec);
    end
end

if(flgRun)
    
    fid = fopen('svn_info.tmp', 'r');
    
    tline = fgetl(fid);
    if(~ischar(tline))
        if(isdir(strItem))
            disp(sprintf('%s : WARNING : Directory ''%s'' is not under SVN Version control', ...
                mfilename, strItem));
        else
            disp(sprintf('%s : WARNING : File ''%s'' is not under SVN Version control', ...
                mfilename, strItem));
        end
    else
        while ischar(tline)
            ptrColon = findstr(tline, ':');
            if(~isempty(ptrColon))
                svnParam = tline(1:ptrColon(1)-1);
                svnParamML = strrep(svnParam, ' ', '_');
                svnValue = tline(ptrColon(1)+2:end);    % Go '+2' to avoid space as well
            end
            info.(svnParamML) = svnValue;
            
            tline = fgetl(fid);
        end
    end
    fclose(fid);
    
    delete('svn_info.tmp');
    
    if(~isempty(strField))
        strFieldML = strrep(strField, ' ', '_');
        info = info.(strFieldML);
    end
    
    cd(HD);
    
end

end % << End of function svninfo >>

%% AUTHORS
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
