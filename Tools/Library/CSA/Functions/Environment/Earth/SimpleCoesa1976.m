% SIMPLECOESA1976 Simple 1976 Standard Atmosphere Model (Valid -5 km to 11 km)
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% SimpleCoesa1976:
%     Simplified 1976 COESA Standard Atmosphere Model.  This function
%     computes the standard atmospheric values of a given geometric
%     altitude based on the 1976 U.S. Standard Atmosphere Model.  The full
%     U.S. Standard Atmopshere is an idealized, steady-state representation
%     of the Earth's atmosphere from the surface to 1000 km.  The lower
%     atmospheric region (below 86 km) is broken down into 7 geopotential
%     height-segmented regions.  Here, temperatures follow constant
%     gradient profiles and the air is assumed to be in hydrostatic
%     equilibrium, in which the air is treatd as a homogenous mixture of
%     several constituent gases.  This simplified model focuses on the
%     lowest region, from -5 km to 11 km (-16,404 ft to 36,084.24 ft).
% 
% SYNTAX:
%	[Atmos] = SimpleCoesa1976(Alt, flgEnglish, DeltaTemp)
%	[Atmos] = SimpleCoesa1976(Alt, flgEnglish)
%	[Atmos] = SimpleCoesa1976(Alt)
%
% INPUTS: 
%	Name      	Size		Units                   Description
%	Alt 	    [variable]  [m] or [ft]             Geometric Altitude
%	flgEnglish	[1]         [int]                   Input/Output Units to Use
%                                                    0: Assume METRIC units
%                                                    1: Assume ENGLISH
%                                                    units (default)
%   DeltaTemp   [variable]  [Kelvin] or [Rankine]      Temperature Change
%                                                       from Standard
%                                                       Default: 0
% OUTPUTS: 
%	Name            Size        Units                   Description
%	Atmos           {struct}                            Standard Atmosphere Structure            
%   .UNITS          'string'
%   .AllUnits       {11x3 cell} Metric      English
%	.Valid          [variable]  [bool]                  Altitude Valid?
%	.DeltaTemp      [variable]  [Kelvin] or [Rankine]	Delta Standard Temp
%   .Z              [variable]  [m]         [ft]           Geometric Altitude
%   .H              [variable]  [m]         [ft]           Geopotential Altitude
%   .T_Std          [variable]  [Kelvin] or [Rankine]   Kinetic Temp (Std)
%	.T              [variable]  [Kelvin] or [Rankine]	Kinetic Temperature
%	.Press          [variable]  [Pa]     or [lbf/ft^2]  Atmospheric Pressure
%	.Density_Std    [variable]  [kg/m^3] or [slug/ft^3] Std Density
%	.Density        [variable]  [kg/m^3] or [slug/ft^3] Atmospheric Density
%	.Sound          [variable]  [m/s]    or [ft/s]      Speed of Sound
%
% NOTES:
%   This function allows the inputted Geometric altitude, Alt, to be either
%   singular (e.g. [1]), a vector ([1xN] or [Nx1]), or a multi-dimentional 
%   matrix (M x N x P x ...].  All outputs (Pressure, Density, etc) will
%   carry the same dimensions as the input.
%
% EXAMPLES:
%	Example 1: Compute the Atmosphere at Sea Level assuming metric units
%              with a DeltaTemp of 0 (Standard), +10 and -10 deg Kelvin
%	SeaLevel = SimpleCoesa1976(0, 0, [0 10 -10])
%   returns SeaLevel = 
%            UNITS: 'METRIC'
%         AllUnits: {11x3 cell}
%            Valid: [1              1               1]              % [bool]
%        DeltaTemp: [0              10              -10]            % [Kelvin]
%                Z: [0              0               0]              % [m]
%                H: [0              0               0]              % [m]
%            T_Std: [288.1500       288.1500        288.1500]       % [Kelvin]
%               T*: [288.1500       298.1500        278.1500]       % [Kelvin]
%           Tm_Std: [288.1500       288.1500        288.1500]       % [Kelvin]
%              Tm*: [288.1500       298.1500        278.1500]       % [Kelvin]
%         Pressure: [101325         101325          101325]         % [Pa]
%      Density_Std: [1.2250         1.2250          1.2250]         % [kg/m^3]
%         Density*: [1.2250         1.1839          1.2690]         % [kg/m^3]
%        Sound_Std: [340.2941       340.2941        340.2941]       % [m/s]
%           Sound*: [340.2941       346.1486        334.3372]       % [m/s]
%   * Affected by DeltaTemp
%
%	Example 2: Compute the Atmosphere at Sea Level assuming English units
%              with a DeltaTemp of 0 (Standard), +10 and -10 deg Rankine
%	SeaLevel = SimpleCoesa1976(0, 1, [0 10 -10])
%	returns SeaLevel =
%          UNITS: 'ENGLISH'
%         AllUnits: {20x3 cell}
%            Valid: [1              1               1]              % [ft]
%        DeltaTemp: [0              10              -10]            % [Rankine]
%                Z: [0              0               0]              % [ft]
%                H: [0              0               0]              % [ft]
%            T_Std: [518.67         518.67          518.67]         % [Rankine]
%               T*: [518.67         528.67          508.67]         % [Rankine]
%         Pressure: [2116.2         2116.2          2116.2]         % [lbf/ft^2]
%      Density_Std: [0.0023769      0.0023769       0.0023769]      % [slug/ft^3]
%         Density*: [0.0023769      0.0023319       0.0024236]      % [slug/ft^3]
%        Sound_Std: [1116.5         1116.5          1116.5]         % [ft/s]
%           Sound*: [1116.5         1127.2          1105.6]         % [ft/s]
%   * Affected by DeltaTemp
%
% SOURCE DOCUMENTATION:
%	[1] COESA (Committee on Extension to the Standard Atmosphere), U.S.
%       Standard Atmosphere 1976, U.S. Government Printing Office,
%       Washington, DC, October 1976.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit SimpleCoesa1976.m">SimpleCoesa1976.m</a>
%	  Driver script: <a href="matlab:edit Driver_SimpleCoesa1976.m">Driver_SimpleCoesa1976.m</a>
%	  Documentation: <a href="matlab:pptOpen('SimpleCoesa1976_Function_Documentation.pptx');">SimpleCoesa1976_Function_Documentation.pptx</a>
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/643
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Earth/SimpleCoesa1976.m $
% $Rev: 3034 $
% $Date: 2013-10-16 17:24:04 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [Atmos] = SimpleCoesa1976(Alt, flgEnglish, DeltaTemp)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

% Examples of Different Display Formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfnam '>> ERROR: <define error here> See ' mlink ' help'];      % <-- Couple with error function
% error([mfnam 'class:file:Identifier'], errstr);    % Call error function with error string

%% Internal Variables
r0 = 6.356766e6;                        % [m]               Mean Radius of Earth
Rstar = 8.31432e3;                      % [N-m/(kmol-K)]    Universal Gas Constant
T0 = 288.15;                            % [deg K]           Standard Sea-level Temperature
L0 = -0.0065;                           % [deg K/m]         Temperature Lapse Rate at lowest 
P0 = 101325;                            % [N/m^2]           Sea-level standard pressure
H0 = 0;                                 % [m]               Sea-level altitude
g0 = 9.80665;                           % [m/sec^2]         Gravity
M0 = 28.9644;                           % [kg/kmol]         Molecular weight
gamma = 1.4;                            % [dimensionless]   Specific heat ratio
FT2M = 0.3048;                          % [ft] to [m]
PA2PSF = 0.020885434233150;             % [Pa] to [lbf/ft^2]
KGM3_2_SLUGFT3 = 0.001940320331981;     % [kg/m^3] to [slug/ft^3]
K2R = 1.8;                              % [deg Kelvin] to [deg Rankine]

%% Input Argument Conditioning:
switch(nargin)
    case 1
        DeltaTemp = 0; flgEnglish = '';
    case 2
        DeltaTemp = 0;
    case 3
        % Nominal
end

if(isempty(flgEnglish))
    flgEnglish = 1;
end
 
 if(any(size(Alt) ~= size(DeltaTemp)))
     if(sum(size(Alt) == [1 1]) == 2)
         Alt = zeros(size(DeltaTemp)) + Alt;
     end
 end

%% Main Function:
Atmos.UNITS    = 'METRIC';
Atmos.AllUnits = {...
    'Valid'         '[bool]'            'Altitude is Valid';
    'DeltaTemp'     '[Kelvin]'          'Delta Kinetic Temperature';
    'Z'             '[meters]'          'Geometric Alt';
    'H'             '[meters]'          'Geopotential Alt';
    'T_Std'         '[Kelvin]'          'Kinetic Temperature (Standard)';
    'T'             '[Kelvin]'          'Kinetic Temperature';
    'Pressure'      '[Pa]'              'Atmos. Pressure';
    'Density_Std'   '[kg/m^3]'          'Atmospheric Density (Standard)';
    'Density'       '[kg/m^3]'          'Atmospheric Density';
    'Sound_Std'     '[m/s]'             'Speed of Sound (Standard)';
    'Sound'         '[m/s]'             'Speed of Sound';};

if(flgEnglish)
    Z_m = Alt .* FT2M;                  % Convert to [m]
    DeltaTemp_K = DeltaTemp ./ K2R;     % Convert to [deg Kelvin]
else
    Z_m = Alt;                          % [m]
    DeltaTemp_K = DeltaTemp;            % [Kelvin]
end

% Geopotential Altitude - Equation 9:
Atmos.Valid = (Z_m >= -5000) & (Z_m <= 11000);          % [bool]
H_m = (r0 .* Z_m)./(r0 + Z_m);                          % [m] 

% Standard Molecular Temperature - Equation 23, pg 10:
T_Std = T0 + L0 .* (H_m - H0);                          % [Kelvin]
T = T_Std + DeltaTemp_K;                                % [Kelvin]
% multDensity = T_Std ./ T;                             % [non-dimensional]

% Standard Pressure - Equation 33a:
PressExp = (g0 * M0)/(Rstar * L0);                      % [non-dimensional]
Press = P0 .* (T0./T_Std).^PressExp;                    % [Pa]

% Standard Density - Equation 42:
Density_Std = (Press .* M0)./(Rstar .* T_Std);          % [kg/m^3]
Density     = (Press .* M0)./(Rstar * T);               % [kg/m^3]

% Speed of Sound - Equation 50:
Sound_Std   = sqrt( gamma .* Rstar .* T_Std ./ M0 );    % [m/sec]
Sound       = sqrt( gamma .* Rstar .* T ./ M0 );        % [m/sec]

% Compile Outputs
Atmos.DeltaTemp     = DeltaTemp;
Atmos.Z             = Alt;
Atmos.H             = H_m;
Atmos.T_Std         = T_Std;
Atmos.T             = T;
Atmos.Pressure      = Press;
Atmos.Density_Std   = Density_Std;
Atmos.Density       = Density;
Atmos.Sound_Std     = Sound_Std;
Atmos.Sound         = Sound;

if(flgEnglish)
       Atmos.UNITS = 'ENGLISH';
    Atmos.AllUnits = {...
        'Valid'         '[bool]'            'Altitude is Valid';
        'DeltaTemp'     '[Rankine]'         'Delta Kinetic Temperature';
        'Z'             '[feet]'            'Geometric Alt';
        'H'             '[feet]'            'Geopotential Alt';
        'T_Std'         '[Rankine]'         'Kinetic Temperature (Standard)';
        'T'             '[Rankine]'         'Kinetic Temperature';    
        'Pressure'      '[lbf/ft^2]'        'Atmos. Pressure';
        'Density_Std'   '[slug/ft^3]'       'Atmospheric Density (Standard)';
        'Density'       '[slug/ft^3]'       'Atmospheric Density';    
        'Sound_Std'     '[ft/s]'            'Speed of Sound (Standard)';
        'Sound'         '[ft/s]'            'Speed of Sound'};

    Atmos.H             = H_m ./ FT2M;                          % [ft]
    Atmos.T_Std         = Atmos.T_Std .* K2R;                   % [deg Rankine]
    Atmos.T             = Atmos.T .* K2R;                       % [deg Rankine]
    Atmos.Pressure      = Atmos.Pressure .* PA2PSF;             % [lbf/ft^2]
    Atmos.Density_Std   = Atmos.Density_Std .* KGM3_2_SLUGFT3;  % [slug/ft^3]
    Atmos.Density       = Atmos.Density .* KGM3_2_SLUGFT3;      % [slug/ft^3]
    Atmos.Sound_Std     = Atmos.Sound_Std ./ FT2M;              % [ft/sec]
    Atmos.Sound         = Atmos.Sound ./ FT2M;                  % [ft/sec]
end

end % << End of function SimpleCoesa1976 >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101013 MWS: Created Function
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username 
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
