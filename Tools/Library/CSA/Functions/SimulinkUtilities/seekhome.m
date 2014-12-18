% SEEKHOME Ensures that only the SimSetup.RootFolder has an slprj folder
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% seekhome.m
%   Go to the SimSetup.RootFolder after copying all model reference
%   artifacts there. SimSetup.RootFolder must exist as a string.
%
%   Simulink will regenerate a slprj folder in the current directory if you
%   are trying to execute the simulation outside of the root folder. This
%   will leave a mess of multiple slprj folders in the directory structure.
%   This script cannot help the fact that the slprj folder and code will be
%   regenerated if you go to a new folder- but it will ensure that the
%   files created are moved to the root folder and the cwd is changed. In
%   other words, this script ensures that only the SimSetup.RootFolder
%   contains an slprj folder.
%
% This script works best when used as an InitFcn model callback.
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/693
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/seekhome.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

%% Main Code
if( strcmp(pwd, SimSetup.RootFolder) == 0)

    clear mex

    if(ispc)
        rmdir([SimSetup.RootFolder '\slprj'], 's')
        eval(['!move .\slprj "' SimSetup.RootFolder '"'])
        eval(['!move .\*.mexw32 "' SimSetup.RootFolder '"'])
    else
        rmdir([SimSetup.RootFolder '/slprj'], 's')
        eval(['!mv -Rf ./slprj "' SimSetup.RootFolder '"'])
        eval(['!mv ./*.mexglx "' SimSetup.RootFolder '"'])
    end

    cd(SimSetup.RootFolder)

end

%% << End of Script seekhome.m >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 <INI>: Created script created using CreateNewScript
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720 

%% FOOTER
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
