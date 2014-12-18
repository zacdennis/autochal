% AC_Path_Init Sets up paths for Autonomy Challenge Tools
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
%
% SYNTAX:
%   [] = AC_Path_Init()
%
% INPUTS: None
% OUTPUTS: None
%
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/AutonomyChallenge/trunk/Tools/AC_Path_Init.m $
% $Rev: 12 $
% $Date: 2014-11-03 11:20:07 -0600 (Mon, 03 Nov 2014) $
% $Author: healypa $

function AC_Path_Init()

%% User Defined
strSim = 'Autonomy Challenge';

% Define Exclusion List
%  Path init will not add any folder found to have any of these strings in
%  it's title
lst2exclude = {}; i = 0;
i = i + 1;  lst2exclude(i,:) = {'ert_rtw'};
i = i + 1;  lst2exclude(i,:) = {'slprj'};
i = i + 1;  lst2exclude(i,:) = {'.svn'};
i = i + 1;  lst2exclude(i,:) = {'SW_'};
i = i + 1;  lst2exclude(i,:) = {'Code'};

%% END USER DEFINED

% Create the path list and add the paths:
HD = pwd;
path(pathdef);
cd(fileparts(mfilename('fullpath')));

path_to_add_raw = genpath(pwd);
ptr_sep = findstr(path_to_add_raw, pathsep);
path_to_add = '';
for iFolder = 1:length(ptr_sep)
    if(iFolder == 1)
        ptrA = 1;
    else
        ptrA = ptr_sep(iFolder-1) + 1;
    end
    ptrB = ptr_sep(iFolder);
    curFolder = path_to_add_raw(ptrA:ptrB);
    flgMatch = ~isempty(cell2mat(regexp(curFolder, lst2exclude)));
    if(~flgMatch)
        path_to_add = [path_to_add curFolder]; %#ok<AGROW>
    end
end
if(~isempty(path_to_add))
    addpath(path_to_add, '-begin');
end

cd(HD); clear HD;
disp(sprintf('%s : Paths for the %s tools have been setup.', mfilename, strSim));

%% << End of Function AC_Path_Init.m >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 101124 <INI>: Created script created using CreateNewScript
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
