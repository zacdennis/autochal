% BUILD_MOLECULARMEANFREEPATH Script to generate a molecular mean free path
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Build_MolecularMeanFreePath.m
%	< Insert Documentation >
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/641
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Earth/Build_MolecularMeanFreePath.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

%% Main Code
clear MFP;

rawTable = xlsread('MeanFreePathData.xls', 'DATA', 'H9:I51');

MFP.title       = 'Molecular Mean Free Path, Lamda Infinity';
MFP.source      = 'MeanFreePathData.xls';
MFP.model       = 'U.S. Standard Amosphere, 1962';
MFP.UNITS       = 'ENGLISH';
MFP.AllUnits    = {'Altitude'   'ft';
    'lambda'    'ft'};
MFP.altitude    = rawTable(:,1);
MFP.lambda      = rawTable(:,2);

save MFP MFP

clear FT2M rawTable MFP

%% << End of Script Build_MolecularMeanFreePath.m >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101102 JPG: Copied over the old contents.
% 101102 CNS: Created script created using CreateNewScript
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
