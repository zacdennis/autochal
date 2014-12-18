% CENTRALBODYMOON_INIT Loads Lunar Moon Model Parameters LP165P
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CentralBodyMoon_init:
%     Loads Lunar Moon Model Parameters LP165P
% 
% SYNTAX:
%	[moon] = CentralBodyMoon_init(flgUseMetric)
%   [moon] = CentralBodyMoon_init( )
%
% INPUTS: 
%	Name        	Size	Units		Description
%   flgUseMetric    [1x1]   [ND]        Flag Used to Set Units of Output
%                                       Structure where:
%                                       0: Returns English Units
%                                       1: Returns Metric Units
%
% OUTPUTS: 
%	Name        	Size	Units		Description
%	moon	        {Struct}            Structure containing lunar info
%                                       Elements described only in fcn for
%                                       brevity.
%
% NOTES:
%	If flgUseMetric is not defined, assumes METRIC output.
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[moon] = CentralBodyMoon_init(flgUseMetric, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[moon] = CentralBodyMoon_init(flgUseMetric)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%   [1] Bulk Parameters: a, gm, harmonic coefficients
%       LP165P Spherical Harmonic model of the Moon's Gravity Field
%       Input data from radio tracking of the Lunar Orbiter 1 to 5, Apollo
%       15 and 16 subsatellites, Clementine, and all the data (Jan 11, 1998
%       to July 30, 1999) of the Lunar Prospector spacecraft.  Released
%       from NASA Jet Propulsion Laboratory 27 November 2000 under the
%       direction of Alex S. Konopliv.
%   [2] Bulk / Orbital Parameters
%       http://nssdc.gsfc.nasa.gov/planetary/factsheet/moonfact.html
%   [3] Lunar Parameter: rate
%       http://solarsystem.nasa.gov/planets/profile.cfm?Object=Moon&Display
%       =Facts
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
% Book with One Author:
% [2]   Author Last Name, Author First Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
% Book with Two Author:
% [3]   Author #1 Last Name, Author #1 First Name, and Author #2 Full Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CentralBodyMoon_init.m">CentralBodyMoon_init.m</a>
%	  Driver script: <a href="matlab:edit Driver_CentralBodyMoon_init.m">Driver_CentralBodyMoon_init.m</a>
%	  Documentation: <a href="matlab:winopen(which('CentralBodyMoon_init_Function_Documentation.pptx'));">CentralBodyMoon_init_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/645
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Lunar/CentralBodyMoon_init.m $
% $Rev: 2641 $
% $Date: 2012-11-08 16:31:17 -0600 (Thu, 08 Nov 2012) $
% $Author: sufanmi $

function [moon] = CentralBodyMoon_init(flgUseMetric)

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

%% Initialize Outputs:
% moon= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        flgUseMetric= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:
%% Build Moon Structure:
moon.title      = 'Lunar Moon Model';
moon.units      = 'METRIC';
moon.a          = 1738000.0;            % [m]       Semi-major Axis 
                                        %            (Equatorial Radius)
moon.b          = 1736000.0;            % [m]       Semi-minor Axis 
                                        %            (Polar Radius)
moon.e          = sqrt(1 - (moon.b*moon.b)/(moon.a*moon.a));
                                        % [ND]      First Eccentricity
moon.gm         = 4.902801056e12;       % [m^3/s^2] Gravitational Constant
moon.rate       = 0;    % [placeholder]
moon.period     = 27.321661 *86400;     % [sec]     Revolution Period
moon.rate       = (2*pi)/moon.period;   % [rad/s]   Angular Velocity
moon.OmegaE     = [0 -moon.rate 0; moon.rate 0 0; 0 0 0];
moon.OmegaE2    = moon.OmegaE * moon.OmegaE;
moon.flatten    = 1 - moon.b/moon.a;    % [ND]      Flattening Parameter
moon.e2         = moon.e * moon.e;      % [ND]      First Eccentricity Squared
moon.ep         = sqrt( (moon.a^2)/(moon.b^2) - 1 );
                                        % [ND]      Second Eccentricity
                                        %           (e-prime, e')
moon.ep2        = moon.ep^2;            % [ND]      Second Eccentricity
                                        %           (e-prime) Squared
moon.El         = moon.e * moon.a;      % [m]       Linear Eccentricity
moon.E2l        = moon.El^2;            % [m^2]     Linear Eccentricity
                                        %            Squared
moon.eta        = (moon.a^2 - moon.b^2)/moon.a^2;  % [ND]
moon.j2         = 202.7e-6;             % [ND]      J2 Perturbation
                                        %            Coefficient
moon.gamma_e    = 1.62;                 % [m/s^2]   Theoretical (Normal)
                                        %            Gravity at the Equator
                                        %             (on the Ellipsoid)
moon.gamma_p    = 1.62;                 % [m/s^2]   Theoretical (Normal)
                                        %            Gravity at Pole
                                        %            (on the Ellipsoid)                                       
moon.g0         =  moon.gm / (moon.a^2 * (1 + 1.5*moon.j2));  
                                        % [m/s^2]   OLD Gravity Computation
                                        %            (Unknown Origin)
moon.m          = (moon.rate^2) * (moon.a^2) * moon.b / moon.gm;
                                        % [ND]      Gravity Ratio  
moon.k          = (moon.b*moon.gamma_p)/(moon.a*moon.gamma_e) - 1;
                                        % [ND]      Theoretical (Normal)
                                        %            Gravity Formula
                                        %            Constant (Somigliana's
                                        %            Constant)
moon.MR    = 1737100.0;                 % [m]       Volumetric (Lunar) Mean Radius

moon.harmonic = load('LP165P.txt'); % [ND] Spherical Harmonic Coefficients
                                        % complete to order and degree of
                                        % 165.
moon.g          = moon.gamma_e;     % [m/s^2]   Gravity at "sea level"
                                    %   This only exists to keep structure
                                    %   consistent with Earth Structure
                                    

%% Convert to English
if (nargin == 1) && (flgUseMetric == 0)
    %% Conversions:
    conversions;
    
    moon.units      = 'ENGLISH';
    moon.a          = moon.a * C.M2FT;       % [ft]
    moon.b          = moon.b * C.M2FT;       % [ft]
    moon.gm         = moon.gm * (C.M2FT)^3;  % [ft^3/s^2]
    moon.gamma_e    = moon.gamma_e * C.M2FT; % [ft/s^2]
    moon.gamma_p    = moon.gamma_p * C.M2FT; % [ft/s^2]
    moon.g0         = moon.g0 * C.M2FT;      % [ft/s^2]
    moon.MR         = moon.MR * C.M2FT;      % [ft]
    moon.g          = moon.g * C.M2FT;       % [ft/s^2]
    
    clear C;

%% Compile Outputs:
%	moon= -1;

end % << End of function CentralBodyMoon_init >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101022 JPG: Copied over information from the old function.
% 101022 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720

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
