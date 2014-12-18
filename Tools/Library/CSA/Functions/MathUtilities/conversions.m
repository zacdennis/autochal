% CONVERSIONS Generates structure, C, with standard unit conversions
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% conversions:
%   Generates structure, C, with standard unit conversions 
% 
% SYNTAX:
%	C = conversions()
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	C           stuct       [varies]    Unit conversions structure
%
% NOTES:
% EXAMPLES:
%	Load Unit Conversions into workspace
%	conversions()
%
% SOURCE DOCUMENTATION:
% [1]   http://en.wikipedia.org/wiki/Conversion_of_units
% [2]   http://www.wolframalpha.com/
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit conversions.m">conversions.m</a>
%	  Driver script: <a href="matlab:edit Driver_conversions.m">Driver_conversions.m</a>
%	  Documentation: <a href="matlab:winopen(which('conversions_Function_Documentation.pptx'));">conversions_Function_Documentation.pptx</a>
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/565
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/conversions.m $
% $Rev: 3292 $
% $Date: 2014-10-28 15:56:07 -0500 (Tue, 28 Oct 2014) $
% $Author: sufanmi $

%% Main Function:
clear C;
C.Title             = 'Basic Unit Conversions';
C.Source            = 'http://en.wikipedia.org/wiki/Conversion_of_units';

%% TIME
C.Time              = 'Time Conversions';

%% METRIC PREFIXES
C.YOTTA_2_ONE       = 1e24;                     % yotta to one  (septillion)
C.ZETTA_2_ONE       = 1e21;                     % zetta to one  (sextillion)
C.EXA_2_ONE         = 1e18;                     % exa to one    (quintillion)
C.PETA_2_ONE        = 1e15;                     % peta to one   (quadrillion)
C.TERA_2_ONE        = 1e12;                     % tera to one   (trillion)
C.GIGA_2_ONE        = 1e9;                      % giga to one   (billion)
C.MEGA_2_ONE        = 1e6;                      % mega to one   (million)
C.KILO_2_ONE        = 1e3;                      % kilo to one   (thousand)
C.HECTO_2_ONE       = 1e2;                      % hecto to one  (hundred)
C.DECA_2_ONE        = 1e1;                      % deca to one   (ten)
C.DECI_2_ONE        = 1e-1;                     % deci to one   (tenth)
C.CENTI_2_ONE       = 1e-2;                     % centi to one  (hundredth)
C.MILLI_2_ONE       = 1e-3;                     % milli to one  (thousndth)
C.MICRO_2_ONE       = 1e-6;                     % micro to one  (millionth)
C.NANO_2_ONE        = 1e-9;                     % nano to one   (billionth)
C.PICO_2_ONE        = 1e-12;                    % pico to one   (trillionth)
C.FEMTO_2_ONE       = 1e-15;                    % femto to one  (quadrillionth)
C.ATTO_2_ONE        = 1e-18;                    % atto to one   (quintillionth)
C.ZEPTO_2_ONE       = 1e-21;                    % zepto to one  (sextillionth)
C.YOCTO_2_ONE       = 1e-24;                    % yocto to one  (septillionth)

C.ONE_2_YOTTA       = C.YOCTO_2_ONE;            % one to yotta
C.ONE_2_ZETTA       = C.ZEPTO_2_ONE;            % one to zetta
C.ONE_2_EXA         = C.ATTO_2_ONE;             % one to exa
C.ONE_2_PETA        = C.FEMTO_2_ONE;            % one to peta
C.ONE_2_TERA        = C.PICO_2_ONE;             % one to tera            
C.ONE_2_GIGA        = C.NANO_2_ONE;             % one to giga
C.ONE_2_MEGA        = C.MICRO_2_ONE;            % one to mega
C.ONE_2_KILO        = C.MILLI_2_ONE;            % one to kilo
C.ONE_2_HECTO       = C.CENTI_2_ONE;            % one to hecto
C.ONE_2_DECA        = C.DECI_2_ONE;             % one to deca
C.ONE_2_DECI        = C.DECA_2_ONE;             % one to deci
C.ONE_2_CENTI       = C.HECTO_2_ONE;            % one to centi
C.ONE_2_MILLI       = C.KILO_2_ONE;             % one to milli
C.ONE_2_MICRO       = C.MEGA_2_ONE;             % one to micro
C.ONE_2_NANO        = C.GIGA_2_ONE;             % one to nano
C.ONE_2_PICO        = C.TERA_2_ONE;             % one to pico
C.ONE_2_FEMTO       = C.PETA_2_ONE;             % one to femto
C.ONE_2_ATTO        = C.EXA_2_ONE;              % one to atto
C.ONE_2_ZEPTO       = C.ZETTA_2_ONE;            % one to zepto
C.ONE_2_YOCTO       = C.YOTTA_2_ONE;            % one to yocto

% Large Timesteps to Small Timesteps:
C.YR2DAY            = 365.25;                   % years to days
C.DAY2HR            = 24.0;                     % day to hours
C.HR2MIN            = 60.0;                     % hours to minutes
C.MIN2SEC           = 60.0;                     % minutes to seconds

% Large Timesteps to Small Timesteps - Reciprocals:
C.DAY2YR            = 1.0/C.YR2DAY;             % days to years
C.HR2DAY            = 1.0/C.DAY2HR;             % hours to days
C.MIN2HR            = 1.0/C.HR2MIN;             % minutes to hours
C.SEC2MIN           = 1.0/C.MIN2SEC;            % seconds to minute

% Other Timestep Conversions:
C.SEC2MS            = C.ONE_2_MILLI;            % seconds to milli-seconds
C.MS2SEC            = 1.0/C.SEC2MS;             % milli-seconds to seconds
C.YR2HR             = C.YR2DAY * C.DAY2HR;      % years to hours
C.HR2YR             = 1.0/C.YR2HR;              % hours to days
C.YR2MIN            = C.YR2HR * C.HR2MIN;       % years to minutes
C.MIN2YR            = 1.0/C.YR2MIN;             % minutes to years
C.YR2SEC            = C.YR2MIN * C.MIN2SEC;     % years to seconds
C.SEC2YR            = 1.0/C.YR2SEC;             % seconds to years
C.DAY2MIN           = C.DAY2HR * C.HR2MIN;      % days to minutes
C.MIN2DAY           = 1.0/C.DAY2MIN;            % minutes to days
C.DAY2SEC           = C.DAY2MIN * C.MIN2SEC;    % days to seconds
C.SEC2DAY           = 1.0/C.DAY2SEC;            % seconds to days
C.HR2SEC            = C.HR2MIN * C.MIN2SEC;     % hours to seconds
C.SEC2HR            = 1.0/C.HR2SEC;             % seconds to hours

%% DISTANCE
C.Distance          = 'Distance Conversions';

% Exact Distance Conversions:
C.FT2IN             = 12.0;                     % feet to inches
C.YARD2FT           = 3.0;                      % yard to feet
C.MILE2FT           = 5280.0;                   % miles to feet
C.FT2M              = 0.3048;                   % feet to meters
C.NMILE2M           = 1852.0;                   % nautical mile to meters
C.IN2CM             = 2.54;                     % inches to centimeters

% Reciprocal of Exact:
C.IN2FT             = 1.0/C.FT2IN;              % inches to feet
C.FT2YARD           = 1.0/C.YARD2FT;            % feet to yard
C.FT2MILE           = 1.0/C.MILE2FT;            % feet to miles
C.M2FT              = 1.0/C.FT2M;               % meters to feet
C.M2NMILE           = 1.0/C.NMILE2M;            % meters to nautical mile
C.CM2IN             = 1.0/C.IN2CM;              % centimeters to inches

% English to English Conversions:
C.NMILE2FT          = C.NMILE2M * C.M2FT;       % nautical miles to feet
C.FT2NMILE          = 1.0/C.NMILE2FT;           % feet to nautical miles
C.NMILE2MILE        = C.NMILE2FT * C.FT2MILE;   % nautical miles to miles
C.MILE2NMILE        = 1.0/C.NMILE2MILE;         % miles to nautical miles
C.NMILE2IN          = C.NMILE2FT * C.FT2IN;     % nautical miles to inches
C.IN2NMILE          = 1.0/C.NMILE2IN;           % inches to nautical miles
C.MILE2IN           = C.MILE2FT * C.FT2IN;      % miles to inches
C.IN2MILE           = 1.0/C.MILE2IN;            % inches to miles
C.YARD2IN           = C.YARD2FT * C.FT2IN;      % yard to inch
C.IN2YARD           = 1.0/C.YARD2IN;            % inch to yard
C.YARD2MILE         = C.YARD2FT * C.FT2MILE;    % yard to mile
C.MILE2YARD         = 1.0/C.YARD2MILE;          % mile to yard
C.YARD2NMILE        = C.YARD2FT * C.FT2NMILE;   % yard to nautical mile
C.NMILE2YARD        = 1.0/C.YARD2NMILE;         % nautical mile to yard

% Metric to Metric Conversions:
C.KM2M              = 1000.0;                   % kilometers to meters
C.M2KM              = 1.0/C.KM2M;               % meters to kilometers
C.M2CM              = 100.0;                    % meters to centimeters
C.CM2M              = 1.0/C.M2CM;               % centimeters to meters
C.M2MM              = 1000.0;                   % meters to millimeters
C.MM2M              = 1.0/C.M2MM;               % millimeters to meters
C.CM2MM             = 10.0;                     % centimeters to millimeters
C.MM2CM             = 1.0/C.CM2MM;              % millimeters to centimeters
C.KM2MM             = C.KM2M * C.M2MM;          % kilometers to millimeters
C.MM2KM             = 1.0/C.KM2MM;              % millimeters to kilometers

% English / Metric Conversions:
C.FT2KM             = C.FT2M * C.M2KM;          % feet to kilometers
C.KM2FT             = 1.0/C.FT2KM;              % kilometers to feet
C.FT2MM             = C.FT2M * C.M2MM;          % feet to millimeters
C.MM2FT             = 1.0/C.FT2MM;              % millimeters to feet
C.IN2M              = C.IN2FT * C.FT2M;         % inches to meters
C.M2IN              = 1.0/C.IN2M;               % meters to inches
C.IN2MM             = C.IN2CM * C.CM2MM;        % inches to millimeters
C.MM2IN             = 1.0/C.IN2MM;              % millimeters to inches
C.MILE2M            = C.MILE2NMILE * C.NMILE2M; % miles to meters
C.M2MILE            = 1.0/C.MILE2M;             % meters to miles
C.FT2CM             = C.FT2M * C.M2CM;          % feet to centimeters
C.CM2FT             = 1.0/C.FT2CM;              % centimeters to feet
C.FT2MM             = C.FT2M * C.M2MM;          % feet to millimeters
C.MM2FT             = 1.0/C.FT2MM;              % millimeters to feet
C.MILE2KM           = C.MILE2M * C.M2KM;        % miles to kilometers
C.KM2MILE           = 1.0/C.MILE2KM;            % kilometers to miles
C.NMILE2KM          = C.NMILE2M * C.M2KM;       % nautical miles to kilometers
C.KM2NMILE          = 1.0/C.NMILE2KM;           % kilometers to nautical miles

%% SPEED / VELOCITY
C.Velocity          = 'Velocity Conversions';
C.FPS_2_MPH         = C.FT2MILE/C.SEC2HR;       % ft/sec to miles/hour
C.MPH_2_FPS         = 1.0/C.FPS_2_MPH;          % mile/hour to ft/sec
C.MPH_2_MPS         = C.MPH_2_FPS * C.FT2M;     % mile/hour to meter/sec
C.MPS_2_MPH         = 1.0/C.MPH_2_MPS;          % meter/sec to mile/hour
C.KTS_2_KMPH        = C.NMILE2KM;               % knots to kilometer/hour
C.KMPH_2_KTS        = 1.0/C.KTS_2_KMPH;         % kilometer/hr to knots
C.KTS_2_MPS         = C.NMILE2M/C.HR2SEC;       % knots to meter/sec
C.MPS_2_KTS         = 1.0/C.KTS_2_MPS;          % meter/sec to knots
C.KTS_2_FPS         = C.KTS_2_MPS * C.M2FT;     % knots to ft/sec
C.FPS_2_KTS         = 1.0/C.KTS_2_FPS;          % ft/sec to knots
C.KMPH_2_MPS        = C.KM2M/C.HR2SEC;          % kilometer/hr to meter/sec
C.MPS_2_KMPH        = 1.0/C.KMPH_2_MPS;         % meter/sec to kilometer/hr
C.MPS_2_FPS         = C.M2FT;                   % meter/sec to ft/sec
C.FPS_2_MPS         = 1.0/C.MPS_2_FPS;          % ft/sec to meter/sec

%% WEIGHT
C.Weight            = 'Weight Conversions';
C.KG2G              = 1000.0;                   % kg to gm
C.G2KG              = 1.0/C.KG2G;               % gm to kg
C.KG2LB             = 2.20462262;               % kg to lbs
C.LB2KG             = 1.0/C.KG2LB;              % lbs to kg
C.SLUG2KG           = 14.5939029372;            % slugs to kg
C.KG2SLUG           = 1.0/C.SLUG2KG;            % kg to slugs
C.SLUG2LB           = 32.1740486;               % slugs to pounds
C.LB2SLUG           = 1.0/C.SLUG2LB;            % pounds to slugs

%% VOLUME
C.Volume            = 'Volume Conversions';
C.L_2_M3            = 0.001;                        % liter to m^3
C.M3_2_L            = 1.0/C.L_2_M3;                 % m^3 to liter
C.M3_2_FT3          = (C.M2FT)^3;                   % m^3 to ft^3
C.L_2_FT3           = C.L_2_M3 * C.M3_2_FT3;        % liter to ft^3
C.FT3_2_L           = 1.0/C.L_2_FT3;                % ft^3 to liter
C.Gal_2_IN3         = 231.0;                        % US gallon to in^3
C.IN3_2_Gal         = 1.0/C.Gal_2_IN3;              % in^3 to US gallon
C.Gal_2_FT3         = C.Gal_2_IN3 * (C.IN2FT)^3;    % US gallon to ft^3
C.FT3_2_Gal         = 1.0/C.Gal_2_FT3;              % ft^3 to US gallon
C.Gal_2_L           = C.Gal_2_FT3 * C.FT3_2_L;      % US gallon to liter
C.L_2_Gal           = 1.0/C.Gal_2_L;                % liter to US gallon
C.Gal_2_M3          = C.Gal_2_L * C.L_2_M3;         % US gallon to m^3

%% FLOW RATE
C.FlowRate          = 'Flow Rate Conversions';
C.FT3PS_2_GPH       = C.FT3_2_Gal * C.HR2SEC;       % ft^3/sec to US gallon/hr
C.GPH_2_FT3PS       = 1.0/C.FT3PS_2_GPH;            % US gallon/hr to ft^3/sec
C.FT3PS_2_GPM       = C.FT3_2_Gal * C.MIN2SEC;      % ft^3/sec to US gallon/min
C.GPM_2_FT3PS       = 1.0/C.FT3PS_2_GPM;            % US gallon/min to ft^3/sec

%% DENSITY
C.Density           = 'Density Conversions';
C.SLUGFT3_2_KGM3    = C.SLUG2KG * (C.M2FT)^3;   % slug/ft^3 to kg/m^3
C.KGM3_2_SLUGFT3    = C.KG2SLUG * (C.FT2M)^3;   % kg/m^3 to slug/ft^3
C.GCC_2_KGM3        = C.G2KG * (C.M2CM)^3;      % gm/cm^3 to kg/m^3
C.KGM3_2_GCC        = C.KG2G * (C.CM2M)^3;      % kg/m^3 to gm/cm^3
C.KGM3_2_LBFT3      = C.KG2LB * (C.FT2M)^3;     % kg/m^3 to lb/ft^3
C.LBFT3_2_KGM3      = C.LB2KG * (C.M2FT)^3;     % lb/ft^3 to kg/m^3
C.KGL_2_LBGAL       = C.KG2LB * C.Gal_2_L;      % kg/liter to lb/gal
C.GL_2_KGM3         = C.G2KG * (C.M3_2_L);      % gm/L to kg/m^3
C.GL_2_LBFT3        = C.GL_2_KGM3 * C.KGM3_2_SLUGFT3; % gm/L to slug/ft^3

%% FORCE
C.Force             = 'Force Conversions';
C.LB2N              = 4.4482216152605;          % lbf to newtons
C.N2LB              = 1.0/C.LB2N;               % newtons to lbf
C.UG_2_FPSS         = 1e-3 * C.SLUG2LB;         % milli-g to ft/sec^2
C.FPSS_2_UG         = 1/C.UG_2_FPSS;            % ft/sec^2 to milli-g

%% PRESSURE
C.Pressure          = 'Pressure Conversions';
C.PSF2PA            = C.LB2N * (C.M2FT^2);      % lb/ft^2 to Pascal
C.PA2PSF            = C.N2LB * (C.FT2M^2);      % Pascal to lb/ft^2
C.ATM2PA            = 101325.0;                 % atm to Pascal
C.PA2ATM            = 1.0/101325.0;             % Pascal to atm
C.PA2BAR            = 1.0e-5;                   % Pascal to bar
C.PSI2PA            = C.LB2N*(12/C.FT2M)^2;     % (psi) lb/in^2 to N/m^2
C.PSI2PSF           = 144.0;                    % (psi) lb/in^2 to (psf) lb/ft^2
C.PSF2PSI           = 1/144.0;                  % (psf) lb/ft^2 to (psi) lb/in^2
C.ATM_2_MMHG        = 760.001;                  % atm to mm Hg (0 deg C)
C.MMHG_2_ATM        = 1.0/C.ATM_2_MMHG;         % mm Hg to atm
C.PSF_2_ATM         = C.PSF2PA * C.PA2ATM;      % (psf) lb/ft^2 to atm
C.ATM_2_PSF         = 1.0/C.PSF_2_ATM;          % atm to (psf) lb/ft^2

C.ATM_2_INHG        = C.ATM_2_MMHG * C.MM2IN;   % atm to in Hg (0 deg C)
C.INHG_2_ATM        = 1.0/C.ATM_2_INHG;         % in Hg to atm

C.INHG_2_PA         = C.INHG_2_ATM * C.ATM2PA;  % in Hg to Pascal
C.PA_2_INHG         = 1.0/C.INHG_2_PA;          % Pascal to in Hg
C.MMHG_2_PA         = C.MMHG_2_ATM * C.ATM2PA;  % mm Hg to Pascal
C.PA_2_MMHG         = 1.0/C.MMHG_2_PA;          % Pascal to mm Hg
C.MMHG_2_PSF        = C.MMHG_2_PA * C.PA2PSF;   % mm Hg to lb/ft^2
C.PSF_2_MMHG        = 1.0/C.MMHG_2_PSF;         % lb/ft^2 to mm Hg
C.INHG_2_PSF        = C.INHG_2_PA * C.PA2PSF;   % in Hg to lb/ft^2
C.PSF_2_INHG        = 1.0/C.INHG_2_PSF;         % lb/ft^2 to in Hg

C.ATM_2_MMH2O       = (10132.5 / 0.980665 );    % atm to mm-H2O
C.MMH2O_2_ATM       = 1.0/C.ATM_2_MMH2O;        % mm-H2O to atm
C.ATM_2_INH2O       = C.ATM_2_MMH2O * C.MM2IN;  % atm to in-H2O
C.INH2O_2_ATM       = 1.0/C.ATM_2_INH2O;        % in-H2O to atm
C.PSF_2_INH2O       = C.PSF_2_ATM * C.ATM_2_INH2O;  % lb/ft^2 to atm
C.INH2O_2_PSF       = 1.0/C.PSF_2_INH2O;        % atm to lb/ft^2
C.PSI_2_INH2O       = C.PSI2PSF * C.PSF_2_INH2O; % lb/in^2 to in-H2O
C.INH2O_2_PSI       = 1.0/C.PSI_2_INH2O;        % in-H2O to lb/in^2

%% MOMENTS OF INERTIA
C.Inertia           = 'Inertia Conversions';
C.KGM2_2_SLUGFT2    = C.KG2SLUG * (C.M2FT^2);   % kg-m^2 to slug-ft^2
C.SLUGFT2_2_KGM2    = 1.0/C.KGM2_2_SLUGFT2;     % slug-ft^2 to kg-m^2
C.LBIN2_2_SLUGFT2   = C.LB2SLUG * (C.IN2FT^2);  % lb-in^2 to slug-ft^2
C.SLUGFT2_2_LBIN2   = 1.0/C.LBIN2_2_SLUGFT2;    % slug-ft^2 to lb-in^2

%% ANGLES
C.Angles            = 'Angle Conversions';
C.R2D               = 180.0/acos(-1);           % radians to degrees
C.D2R               = acos(-1)/180.0;           % degrees to radians

C.URAD_2_RAD        = 1e-6;                     % micro-radian to radian
C.RAD_2_URAD        = 1/C.URAD_2_RAD;           % radian to micro-radian
C.MRAD_2_RAD        = 1e-3;                     % milli-radian to radian
C.RAD_2_MRAD        = 1/C.MRAD_2_RAD;           % radian to milli-radian

C.ARCMIN_2_DEG      = 1/60;                     % arc-minute to degree
C.DEG_2_ARCMIN      = 1/C.ARCMIN_2_DEG;         % degree to arc-minute
C.ARCMIN_2_RAD      = C.ARCMIN_2_DEG * C.D2R;   % arc-minute to radian
C.RAD_2_ARCMIN      = 1/C.ARCMIN_2_RAD;         % radian to arc-minute

C.ARCSEC_2_ARCMIN   = 1/60;                     % arc-second to arc-minute
C.ARCMIN_2_ARCSEC   = 1/C.ARCSEC_2_ARCMIN;      % arc-minute to arc-second

C.ARCSEC_2_DEG      = C.ARCSEC_2_ARCMIN * C.ARCMIN_2_DEG;    % arc-sec to degree
C.DEG_2_ARCSEC      = 1/C.ARCSEC_2_DEG;         % degree to arc-second

C.ARCSEC_2_RAD      = C.ARCSEC_2_DEG * C.D2R;   % arc-sec to radian
C.RAD_2_ARCSEC      = 1/C.ARCSEC_2_RAD;         % radian to arc-sec


C.DPH_2_RPS         = C.D2R / C.HR2SEC;         % deg/hr to rad/sec
C.RPS_2_DPH         = 1/C.DPH_2_RPS;            % rad/sec to deg/hr

%% ENERGY OR WORK
C.Energy            = 'Energy Conversions';
C.BTU2J             = 1.05505585262 * 1e3;      % BTUs to Joules
C.J2BTU             = 1.0 / C.BTU2J;            % Joules to BTUs

%% POWER
C.Power             = 'Power Conversions';
C.BTUS2WATT         = 1.05505585262 * 1e3;      % BTU/sec to Watts
C.WATT2BTUS         = 1.0 / C.BTUS2WATT;        % Watts to BTU/sec
C.HP_2_LBFTperSEC   = 550.0;                    % Mechanical horsepower to (lb-ft/sec)
C.LBFTperSEC_2_HP   = 1.0 / C.HP_2_LBFTperSEC;  % (lb-ft/sec) to horsepower

%% TEMPERATURE
C.Temperature       = 'Temperature Conversions';
C.K2R               = 1.8;                      % Kelvin to Rankine
C.R2K               = 1.0 / C.K2R;              % Rankine to Kelvin

%% HEATING
C.Heating           = 'Heating Conversions';
C.WCM2_2_BTUSIN2    = C.WATT2BTUS * C.IN2CM^2;  % W/cm^2 to BTU/(s-in^2)
C.BTUSIN2_2_WCM2    = 1.0/C.WCM2_2_BTUSIN2;     % BTU/(s-in^2) to W/cm^2

%% << End of script conversions >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 060110 MWS: Originally developed file as a script under VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/MATH_UTILITIES
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         : Email                 : NGGN Username
% MWS:  Mike Sufana     : mike.sufana@ngc.com   : sufanmi

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
