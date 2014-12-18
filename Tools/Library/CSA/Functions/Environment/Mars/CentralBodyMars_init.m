% CENTRALBODYMARS_INIT loads Martian Model Parameters
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CentralBodyMars_init:
%     Loads Martian Model Parameters
% 
% SYNTAX:
%	[mars] = CentralBodyMars_init(flgUseMetric)
%   [mars] = CentralBodyMars_init( )
%
% INPUTS: 
%	Name        	Size	Units		Description
%   flgUseMetric    [1x1]   [ND]        Flag Used to Set Units of Output
%                                       Structure where:
%                                       0: Returns English Units
%                                       1: Returns Metric Units
%
% OUTPUTS: 
%	Name        	Size		Units		Description
%	mars	        {Structure}             mars body structure, elements
%                                           are commented in function for
%                                           brevity.
% NOTES:
%	If flgUseMetric is not defined, assumes METRIC output.
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[mars] = CentralBodyMars_init(flgUseMetric, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[mars] = CentralBodyMars_init(flgUseMetric)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
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
%	Source function: <a href="matlab:edit CentralBodyMars_init.m">CentralBodyMars_init.m</a>
%	  Driver script: <a href="matlab:edit Driver_CentralBodyMars_init.m">Driver_CentralBodyMars_init.m</a>
%	  Documentation: <a href="matlab:winopen(which('CentralBodyMars_init_Function_Documentation.pptx'));">CentralBodyMars_init_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/646
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Mars/CentralBodyMars_init.m $
% $Rev: 2641 $
% $Date: 2012-11-08 16:31:17 -0600 (Thu, 08 Nov 2012) $
% $Author: sufanmi $

function [mars] = CentralBodyMars_init(flgUseMetric)

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
% mars= -1;

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
mars.title      = 'Mars Model';
mars.units      = 'METRIC';
mars.a          = 3397000.0;            % [m]       Semi-major Axis 
                                        %            (Equatorial Radius)
mars.b          = 3375000.0;            % [m]       Semi-minor Axis 
                                        %            (Polar Radius)
mars.e          = sqrt(1 - (mars.b*mars.b)/(mars.a*mars.a));
                                        % [ND]      First Eccentricity
mars.gm         = 4.2830e13             % [m^3/s^2] Gravitational Constant
mars.rate       = (2*pi)/(24.6229 * 3600); % [rad/s]   Angular Velocity
mars.OmegaE     = [0 -mars.rate 0; mars.rate 0 0; 0 0 0];
mars.OmegaE2    = mars.OmegaE * mars.OmegaE;
mars.flatten    = 1 - mars.b/mars.a;    % [ND]      Flattening Parameter
mars.e2         = mars.e * mars.e;      % [ND]      First Eccentricity Squared
mars.ep         = sqrt( (mars.a^2)/(mars.b^2) - 1 );
                                        % [ND]      Second Eccentricity
                                        %           (e-prime, e')
mars.ep2        = mars.ep^2;            % [ND]      Second Eccentricity
                                        %           (e-prime) Squared
mars.El         = mars.e * mars.a;      % [m]       Linear Eccentricity
mars.E2l        = mars.El^2;            % [m^2]     Linear Eccentricity
                                        %            Squared
mars.eta        = (mars.a^2 - mars.b^2)/mars.a^2;  % [ND]
mars.j2         = 1960.45e-6;           % [ND]      J2 Perturbation
                                        %            Coefficient
mars.gamma_e    = 3.71;                 % [m/s^2]   Theoretical (Normal)
                                        %            Gravity at the Equator
                                        %             (on the Ellipsoid)
mars.gamma_p    = 3.71;                 % [m/s^2]   Theoretical (Normal)
                                        %            Gravity at Pole
                                        %            (on the Ellipsoid)                                       
mars.g0         =  mars.gm / (mars.a^2 * (1 + 1.5*mars.j2));  
                                        % [m/s^2]   OLD Gravity Computation
                                        %            (Unknown Origin)
mars.m          = (mars.rate^2) * (mars.a^2) * mars.b / mars.gm;
                                        % [ND]      Gravity Ratio  
mars.k          = (mars.b*mars.gamma_p)/(mars.a*mars.gamma_e) - 1;
                                        % [ND]      Theoretical (Normal)
                                        %            Gravity Formula
                                        %            Constant (Somigliana's
                                        %            Constant)
mars.MR    = 3390000.0;                 % [m]       Volumetric (Lunar) Mean Radius
mars.g     = mars.gamma_e;              % [m/s^2]   Gravity at 'sea level'
                                        %   This only exists to stay
                                        %   consistent with Earth Structure

%% Convert to English
if (nargin == 1) && (flgUseMetric == 0)
    %% Conversions:
    conversions;

    mars.units      = 'ENGLISH';
    mars.a          = mars.a * C.M2FT;       % [ft]
    mars.b          = mars.b * C.M2FT;       % [ft]
    mars.c          = mars.c * C.M2FT;       % [ft]
    mars.gm         = mars.gm * (C.M2FT)^3;  % [ft^3/s^2]
    mars.gamma_e    = mars.gamma_e * C.M2FT; % [ft/s^2]
    mars.gamma_p    = mars.gamma_p * C.M2FT; % [ft/s^2]
    mars.g0         = mars.g0 * C.M2FT;      % [ft/s^2]
    mars.MR         = mars.MR * C.M2FT;      % [ft]
    mars.g          = mars.g * C.M2FT;       % [ft/s^2]
    
    clear C;

%% Compile Outputs:
%	mars= -1;

end % << End of function CentralBodyMars_init >>

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
