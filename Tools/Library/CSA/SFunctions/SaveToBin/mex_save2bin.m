% MEX_SAVE2BIN Compiler utility for save2bin.c
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% mex_save2bin.m
%	< Insert Documentation >
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/<TicketNumber>
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/SFunctions/SaveToBin/mex_save2bin.m $
% $Rev: 2564 $
% $Date: 2012-10-22 16:54:02 -0500 (Mon, 22 Oct 2012) $
% $Author: sufanmi $

%% Main Code
%% Ensure that Script Executes in Correct Folder
hd = pwd;
cd(fileparts(mfilename('fullpath')));
clear mex;
mex -g save2bin.c

%% Post Housekeeping:
cd(hd);
clear hd;

disp(sprintf('%s : mex complete!', mfilename));
%% << End of Script mex_save2bin.m >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old Script.
% 101026 CNF: Function template created using CreateNewScript
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
