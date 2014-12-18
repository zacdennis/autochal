% MEX_WRITESTK Compiler utility for WriteSTK.c
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% mex_WriteSTK.m
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
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/SFunctions/WriteSTK/mex_WriteSTK.m $
% $Rev: 1704 $
% $Date: 2011-05-10 18:51:22 -0500 (Tue, 10 May 2011) $
% $Author: healypa $

%% Main Code
hd = pwd; cd(fileparts(mfilename('fullpath')));
clear WriteSTK
% mex -v -g WriteSTK.c
mex WriteSTK.c
cd(hd);


%% << End of Script mex_WriteSTK.m >>

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
