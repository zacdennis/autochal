% FUELPROPERTIES creates fuel types structure with JP8 and JP5 fuel.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% FuelProperties.m
%   http://www.atsdr.cdc.gov/toxprofiles/tp121-c3.pdf
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/660
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MassProperties/FuelProperties.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

%% Main Code
% [0.775 0.840 kg/L]
FuelTypes.JP8.Title = 'JP-8 Fuel Properties';
FuelTypes.JP8.Density_KG_per_L = (.775 + 0.840)/2;                                      % [kg/L]
FuelTypes.JP8.Density_KG_per_M3 = FuelTypes.JP8.Density_KG_per_L * C.M3_2_L;            % [kg/m^3]
FuelTypes.JP8.Density_LB_per_FT3 = FuelTypes.JP8.Density_KG_per_M3 * C.KGM3_2_LBFT3;    % [lb/ft^3]
FuelTypes.JP8.Density_LB_per_Gal = FuelTypes.JP8.Density_LB_per_FT3 * C.Gal_2_FT3;      % [lb/gal]

% [0.775 0.840 kg/L]
FuelTypes.JP5.Title = 'JP-5 Fuel Properties';
FuelTypes.JP5.Density_KG_per_L = (.788 + 0.845)/2;                                  % [kg/L]
FuelTypes.JP5.Density_KG_per_M3 = FuelTypes.JP5.Density_KG_per_L * C.M3_2_L;        % [kg/m^3]
FuelTypes.JP5.Density_LB_per_FT3 = FuelTypes.JP5.Density_KG_per_M3 * C.KGM3_2_LBFT3;% [lb/ft^3]
FuelTypes.JP5.Density.LB_per_Gal = FuelTypes.JP5.Density_LB_per_FT3* C.Gal_2_FT3;   % [lb/gal]

%% << End of Script FuelProperties.m >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
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
