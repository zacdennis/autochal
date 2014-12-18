% COESA1976 1976 Standard Atmosphere Model (Valid -5 km to 1000 km)
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Coesa1976:
%    This function computes the atmospheric values of a given geometric
%    altitude based on the 1976 U.S. Standard Atmosphere Model.  This model
%    is valid between -5 km and 1000 km (-16,404 ft and 3,280,840 ft).  For 
%    the lower altitude region (-5 km to 86 km / -16,404 ft to 282,152 ft),
%    simple equations can be utilized to compute the desired output values.
%    Here the gases are considered homogeneous. For the upper atmospheric 
%    regions (86 km to 1000 km / 282,152 ft to 3,280,840 ft), these gases
%    undergo dissociation and diffusion.  Since the gases are no longer
%    homogeneous, more sophisticated equations are utilized to correctly
%    model values like the gases' number densities.  Since integrations are
%    used in these equations, lookups on pretabulated tables are normally
%    employed.  For implementation reasons, standard atmospheric data for
%    the entire low and high altitude regions is pulled from table lookups.
%    Note that METRIC table data is stored in the associated .mat file
%    'REF_Coesa1976.mat'.
% 
% SYNTAX:
%	[Atmos] = Coesa1976(Z, units, DeltaTemp)
%	[Atmos] = Coesa1976(Z, units)
%	[Atmos] = Coesa1976(Z)
%
% INPUTS: 
%	Name		Size		Units                      Description
%	Z   		[variable]  [m] or [ft]                Geometric altitude
%	units		[1]         [int]                      Input/Output Units to Use where:
%                                                       0: Assumes METRIC units
%                                                       1: Assumes ENGLISH units
%                                                       Default: 1 (English)
%   DeltaTemp   [variable]  [Kelvin] or [Rankine]      Temperature Change
%                                                       from Standard
%                                                       Default: 0
% OUTPUTS: 
%	Name            Size        Units                      Description
%	Atmos           {struct}                               Standard Atmosphere Structure            
%   .UNITS          [13xM]      Metric      English
%   .Z              [variable]  [m]         [ft]           Geometric Altitude
%   .H              [variable]  [m]         [ft]           Geopotential Altitude
%   .T_Std          [variable]  [Kelvin]    [Rankine]      Kinetic Temperature (Standard)
%   .T              [variable]  [Kelvin]    [Rankine]      Kinetic Temperature
%   .Tm_Std         [variable]  [Kelvin]    [Rankine]      Molecular Temperature (Standard)
%   .Tm             [variable]  [Kelvin]    [Rankine]      Molecular Temperature
%   .Pressure       [variable]  [Pa]        [lbf/ft^2]     Atmospheric Pressure
%   .PPo            [variable]  [unitless]  [unitless]     Pressure / (Pressure @ Sea Level)
%   .Density_Std    [variable]  [kg/m^3]    [slug/ft^3]    Atmospheric Density (Standard)
%   .Density        [variable]  [kg/m^3]    [slug/ft^3]    Atmospheric Density
%   .RhoRho0_Std    [variable]  [unitless]  [unitless]     Density / (Density @ Sea Level) (Standard)
%   .RhoRho0        [variable]  [unitless]  [unitless]     Density / (Density @ Sea Level)
%   .MeanFreePath   [variable]  [m]         [ft]           Mean Free Path
%   .Sound_Std      [variable]  [m/s]       [ft/s]         Speed of Sound (Standard)
%   .Sound          [variable]  [m/s]       [ft/s]         Speed of Sound
%   .Mu             [variable]  [N-s/m^2]   [lbf-s/ft^2]   Dynamic Viscosity
%   .v              [variable]  [m^2/s]     [ft^2/s]       Kinematic Viscosity
%   .kt             [variable]  [W/(m*K)]   [BTU/(ft*R*s)] Thermal Conductivity
%
% NOTES:
%	This function uses 'REF_Coesa1976.mat' which was build with
%	'Build_REF_Coesa1976.m'.  All data is internally calculated in Metric
%	units and then converted into English units if desired using the 'C'
%	structure generated via the 'conversions.m' script.
%
%   This function allows the inputted Geometric altitude, Z, to be either
%   singular (e.g. [1]), a vector ([1xN] or [Nx1]), or a multi-dimentional 
%   matrix (M x N x P x ...].  All outputs (.Pressure, .Density, etc) will
%   carry the same dimensions as the input.
%
% EXAMPLES:
%	% Example 1: Compute the Atmosphere at Sea Level assuming metric units
%   %            with a DeltaTemp of 0 (Standard), +10 and -10 deg Kelvin
%	SeaLevel = Coesa1976(0, 0, [0 10 -10])
%   returns SeaLevel = 
%            UNITS: 'METRIC'
%         AllUnits: {20x3 cell}
%            Valid: [1              1               1]              % [bool]
%        DeltaTemp: [0              10              -10]            % [Kelvin]
%                Z: [0              0               0]              % [m]
%                H: [0              0               0]              % [m]
%            T_Std: [288.1500       288.1500        288.1500]       % [Kelvin]
%               T*: [288.1500       298.1500        278.1500]       % [Kelvin]
%           Tm_Std: [288.1500       288.1500        288.1500]       % [Kelvin]
%              Tm*: [288.1500       298.1500        278.1500]       % [Kelvin]
%              PPo: [1              1               1]
%         Pressure: [101325         101325          101325]         % [Pa]
%      RhoRho0_Std: [1              1               1]
%         RhoRho0*: [1              0.9665          1.0360]
%      Density_Std: [1.2250         1.2250          1.2250]         % [kg/m^3]
%         Density*: [1.2250         1.1839          1.2690]         % [kg/m^3]
%     MeanFreePath: [6.6332e-008    6.6332e-008     6.6332e-008]    % [m]
%        Sound_Std: [340.2941       340.2941        340.2941]       % [m/s]
%           Sound*: [340.2941       346.1486        334.3372]       % [m/s]
%               Mu: [1.7894e-005    1.7894e-005     1.7894e-005]    % [N-s/m^2]
%                v: [1.4607e-005    1.4607e-005     1.4607e-005]    % [m^2/s]
%               kt: [0.0253         0.0253          0.0253]         % [W/(m*K)]
%   * Affected by DeltaTemp
%
%	% Example 2: Compute the Atmosphere at Sea Level assuming English units
%   %            with a DeltaTemp of 0 (Standard), +10 and -10 deg Rankine
%	SeaLevel = Coesa1976(0, 1, [0 10 -10])
%	returns StdSeaLevel =
%          UNITS: 'ENGLISH'
%         AllUnits: {20x3 cell}
%            Valid: [1              1               1]              % [ft]
%        DeltaTemp: [0              10              -10]            % [Rankine]
%                Z: [0              0               0]              % [ft]
%                H: [0              0               0]              % [ft]
%            T_Std: [518.67         518.67          518.67]         % [Rankine]
%               T*: [518.67         528.67          508.67]         % [Rankine]
%           Tm_Std: [518.67         518.67          518.67]         % [Rankine]
%              Tm*: [518.67         528.67          508.67]         % [Rankine]
%              PPo: [1              1               1]
%         Pressure: [2116.2         2116.2          2116.2]         % [lbf/ft^2]
%      RhoRho0_Std: [1              1               1]
%         RhoRho0*: [1              0.98108         1.0197]
%      Density_Std: [0.0023769      0.0023769       0.0023769]      % [slug/ft^3]
%         Density*: [0.0023769      0.0023319       0.0024236]      % [slug/ft^3]
%     MeanFreePath: [2.1762e-007    2.1762e-007     2.1762e-007]    % [ft]
%        Sound_Std: [1116.5         1116.5          1116.5]         % [ft/s]
%           Sound*: [1116.5         1127.2          1105.6]         % [ft/s]
%               Mu: [3.7372e-007    3.7372e-007     3.7372e-007]    % [lbf-s/ft^2]
%                v: [0.00015723     0.00015723      0.00015723]     % [ft^2/s]
%               kt: [4.0647e-006    4.0647e-006     4.0647e-006]    % [BTU/(ft*R*s)]
%   * Affected by DeltaTemp
%
% SOURCE DOCUMENTATION:
%	[1] COESA (Committee on Extension to the Standard Atmosphere), U.S.
%       Standard Atmosphere 1976, U.S. Government Printing Office,
%       Washington, DC, October 1976.
%       Northrop Grumman Library Reference: REF TL 557 A8U58 1976 c.1
%
%	[2] "U.S. Standard Atmopsphere 1976"
%       Online References found through NASA Goddard Space Flight Center
%       Main Description:
%         http://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19770009539_1977009539.pdf
%       Turbo Pascal Source Code
%         <a href="matlab:web http://www.sworld.com.au/steven/space/atmosphere/ -browser">http://www.sworld.com.au/steven/space/atmosphere/</a>
%         Note: This website contains corrections to Reference 1
%   [3] United States Committee on Extension to the Standard Atmosphere, 
%        "U.S. Standard Atmosphere, 1976", National Oceanic and Atmospheric 
%       Administration, National Aeronautics and Space Administration, 
%       United States Air Force, Washington D.C., 1976.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Coesa1976.m">Coesa1976.m</a>
%	  Driver script: <a href="matlab:edit Driver_Coesa1976.m">Driver_Coesa1976.m</a>
%	  Documentation: <a href="matlab:pptOpen('Coesa1976_Function_Documentation.pptx');">Coesa1976_Function_Documentation.pptx</a>
%
% See also Build_REF_Coesa1976, Interp1D, conversions
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/375
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Earth/Coesa1976.m $
% $Rev: 3034 $
% $Date: 2013-10-16 17:24:04 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [Atmos] = Coesa1976(Z, units, DeltaTemp)

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

%% Input Argument Conditioning:
 switch(nargin)
     case 1
         DeltaTemp = 0; units = '';
     case 2
         DeltaTemp = 0;
     case 3
         % Nominal
 end
 
 if(isempty(units))
		units = 1;
 end

 if ischar(units)
     error([mfnam ':InputArgCheck'], 'Desired Units Must be Numeric.  0 for Metric, 1 for English units.');
 end

 if ischar(Z)
     error([mfnam ':InputArgCheck'], 'Z Must be Numeric!');
 end
 
 if(any(size(Z) ~= size(DeltaTemp)))
     if(sum(size(Z) == [1 1]) == 2)
         Z = zeros(size(DeltaTemp)) + Z;
     end
 end
 
%% Main Function:
conversions;    % Load Unit Conversions

if(units)
    % Input/Output Units are in ENGLISH
    Z = Z * C.FT2M;                 % Convert Altitude from [ft] to [m]
    DeltaTemp = DeltaTemp * C.R2K;  % Convert DeltaTemp from [Rankine] to [Kelvin] 
end

%% Validate Altitude
%  1976 Atmosphere Data is only valid between -5 km and 1000 km

%% General Constants
r0   =   6.356766e3 * C.KM2M;   % [m]           Radius of Earth
P0   =   1.01325e5;             % [N/m^2 or Pa] Standard Pressure @ sea level
rho0 =   1.2250;                % [kg/m^3]      Standard Density @ sea level
M0   =  28.9644;                % [kg/kmol]     Molecular-weight @ sea level
gamma=   1.4;                   % [unitless]    Ratio of Specif heat of air
                                %               constant pressure to that
                                %               at constant volume
Rstar=   8.31432e3;             % [N-m/(kmol-K)] Gas Constant

Atmos.UNITS    = 'METRIC';
Atmos.AllUnits = {...
    'Valid'         '[bool]'            'Altitude is Valid';
    'DeltaTemp'     '[Kelvin]'          'Delta Kinetic Temperature';
    'Z'             '[meters]'          'Geometric Alt';
    'H'             '[meters]'          'Geopotential Alt';
    'T_Std'         '[Kelvin]'          'Kinetic Temperature (Standard)';
    'T'             '[Kelvin]'          'Kinetic Temperature';
    'Tm_Std'        '[Kelvin]'          'Molecular Temp (Standard)';
    'Tm'            '[Kelvin]'          'Molecular Temp';
    'PPo'           '[unitless]'        'Pressure/Pressure0';
    'Pressure'      '[Pa]'              'Atmos. Pressure';
    'RhoRho0_Std'   '[unitless]'        'Rho/Rho0 (Standard)';
    'RhoRho0'       '[unitless]'        'Rho/Rho0';
    'Density_Std'   '[kg/m^3]'          'Atmospheric Density (Standard)';
    'Density'       '[kg/m^3]'          'Atmospheric Density';
    'MeanFreePath'  '[m]'               'Mean Free Path';
    'Sound_Std'     '[m/s]'             'Speed of Sound (Standard)';
    'Sound'         '[m/s]'             'Speed of Sound';
    'Mu'            '[N-s/m^2]'         'Dynamic Viscosity';
    'v'             '[m^2/s]'           'Kinematic Viscosity';
    'kt'            '[W/(m*K)]'         'Thermal Conductivty'};

% Load Structure
load REF_Coesa1976.mat

% Valid Range, [bool]:
Atmos.Valid = ((Z >= -5.0*C.KM2M) & (Z <= 1000.0*C.KM2M));

% Delta Standard Temp, [Kelvin]
Atmos.DeltaTemp = DeltaTemp;

% Geometric Altitude, [m]:
Atmos.Z = Z;

% Geopotential Altitude, [m]:
Atmos.H = (r0 .* Z)./(r0 + Z);

% Kinetic Temperature, [deg Kelvin]:
Atmos.T_Std = Interp1D( REF_Coesa1976.arrZ, REF_Coesa1976.arrT_K, Z );

% Non-Standard Atmosphere Insert
Atmos.T = Atmos.T_Std + DeltaTemp;
multDensity = (Atmos.T_Std ./ Atmos.T);

% Molecular Temperature, [deg Kelvin]:
Atmos.Tm_Std = Interp1D( REF_Coesa1976.arrZ, REF_Coesa1976.arrTm_K, Z );
Atmos.Tm = Atmos.Tm_Std ./ multDensity;

% Pressure Ratio, [Pressure / Pressure @ Sea Level], [unitless]:
Atmos.PPo = Interp1D( REF_Coesa1976.arrZ, REF_Coesa1976.arrPP0, Z );

% Atmospheric Pressure, [Pa]:
Atmos.Pressure = Atmos.PPo .* P0;

% Atmospheric Density Ratio, [unitless]:
Atmos.RhoRho0_Std = Interp1D( REF_Coesa1976.arrZ, REF_Coesa1976.arrRhoRho0, Z );
Atmos.RhoRho0 = Atmos.RhoRho0_Std .* multDensity;

% Atmospheric Density, [kg/m^3]:
Atmos.Density_Std   = Atmos.RhoRho0_Std .* rho0;
Atmos.Density       = Atmos.RhoRho0 .* rho0;

% Mean Free Path, [m]:
Atmos.MeanFreePath = Interp1D( REF_Coesa1976.arrZ, REF_Coesa1976.arrL, Z );

% Speed of Sound, [m/s]:
Atmos.Sound_Std = sqrt( gamma .* Rstar .* Atmos.Tm_Std ./ M0 );
Atmos.Sound     = sqrt( gamma .* Rstar .* Atmos.Tm ./ M0 );

% Dynamic Viscosity, [N-s/m^2]:
Atmos.Mu = Interp1D( REF_Coesa1976.arrZ, REF_Coesa1976.arrmu, Z );

% Kinematic Viscosity, [m^2/s]:
Atmos.v = Interp1D( REF_Coesa1976.arrZ, REF_Coesa1976.arreta, Z );

% Coefficient of Thermal Conductivity, [W/(m-K)]:
Atmos.kt = Interp1D( REF_Coesa1976.arrZ, REF_Coesa1976.arrkt, Z );

%% ========================================================================
%   CONVERT TO ENGLISH UNITS (if DESIRED)
if(units)
    Atmos.UNITS = 'ENGLISH';
    Atmos.AllUnits = {...
        'Valid'         '[bool]'            'Altitude is Valid';
        'DeltaTemp'     '[Rankine]'         'Delta Kinetic Temperature';
        'Z'             '[feet]'            'Geometric Alt';
        'H'             '[feet]'            'Geopotential Alt';
        'T_Std'         '[Rankine]'         'Kinetic Temperature (Standard)';
        'T'             '[Rankine]'         'Kinetic Temperature';
        'Tm_Std'        '[Rankine]'         'Molecular Temp (Standard)';
        'Tm'            '[Rankine]'         'Molecular Temp';
        'PPo'           '[unitless]'        'Pressure/Pressure0';      
        'Pressure'      '[lbf/ft^2]'        'Atmos. Pressure';
        'RhoRho0_Std'   '[unitless]'        'Rho/Rho0 (Standard)';
        'RhoRho0'       '[unitless]'        'Rho/Rho0';
        'Density_Std'   '[slug/ft^3]'       'Atmospheric Density (Standard)';
        'Density'       '[slug/ft^3]'       'Atmospheric Density';        
        'MeanFreePath'  '[ft]'              'Mean Free Path';
        'Sound_Std'     '[ft/s]'            'Speed of Sound (Standard)';
        'Sound'         '[ft/s]'            'Speed of Sound';
        'Mu'            '[lbf-s/ft^2]'      'Dynamic Viscosity';
        'v'             '[ft^2/s]'          'Kinematic Viscosity';
        'kt'            '[BTU/(ft*R*s)]'    'Thermal Conductivty'};

    Atmos.DeltaTemp     = Atmos.DeltaTemp .* C.K2R;                  % [Rankine]
    Atmos.Z             = Atmos.Z .* C.M2FT;                         % [ft]
    Atmos.H             = Atmos.H .* C.M2FT;                         % [ft]
    Atmos.T_Std         = Atmos.T_Std .* C.K2R;                      % [Rankine]
    Atmos.T             = Atmos.T .* C.K2R;                          % [Rankine]
    Atmos.Tm_Std        = Atmos.Tm_Std .* C.K2R;                     % [Rankine]
    Atmos.Tm            = Atmos.Tm .* C.K2R;                         % [Rankine]
    Atmos.Pressure      = Atmos.Pressure .* C.PA2PSF;                % [lbf/ft^2]
    Atmos.Density_Std   = Atmos.Density_Std .* C.KGM3_2_SLUGFT3;     % [slug/ft^3]
    Atmos.Density       = Atmos.Density .* C.KGM3_2_SLUGFT3;         % [slug/ft^3]
    Atmos.MeanFreePath = Atmos.MeanFreePath .* C.M2FT;               % [ft]
    Atmos.Sound_Std     = Atmos.Sound_Std .* C.M2FT;                 % [ft/s]
    Atmos.Sound         = Atmos.Sound .* C.M2FT;                     % [ft/s]
    Atmos.Mu            = Atmos.Mu .* C.N2LB .* (C.FT2M)^2;          % [lbf-s/ft^2]
    Atmos.v             = Atmos.v .* (C.M2FT)^2;                     % [ft^2/s]
    Atmos.kt            = Atmos.kt .* C.WATT2BTUS .* C.FT2M .* C.R2K;% [BTU/(ft*R*s)]
end

end % << End of function Coesa1976 >>

%% REVISION HISTORY
% YYMMDD INI: note
% 100904 MWS: Added Non-Standard Atmosphere Component
%              DeltaTemp changes Kinetic Temp, Density, and RhoRho0 
% 100825 MWS: Restructured function using CreateNewFunc
% 051103 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/ENVIRONMENT/Coesa1976.m

%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         : Email                 : NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi 

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
