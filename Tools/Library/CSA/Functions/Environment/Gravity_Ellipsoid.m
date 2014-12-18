% GRAVITY_ELLIPSOID finds mag and vector of gravity of a central body.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Gravity_Ellipsoid:
%  Calculates Magnitude and Vector of Gravity using the Ellipsoidal Gravity
%  Formula.  The model is derived from equations in the National Imagery
%  and Mapping Agency (NIMA) technical report "NIMA TR8350.2: Department 
%  of Defense World Geodetic System 1984, Its Definition and Relationships 
%  with Local Geodetic Systems", 3rd Edition, 4 July 1997.
%
% *************************************************************************
% * #NOTE: To future COSMO'er, this warning appeared using CreateNewFunc
% * CreateNewFunc>>WARNING: Selected Input argument name: "lst" is a 
% * function name!
% * -JPG
% *************************************************************************
% SYNTAX:
%	[Gmag, G_i] = Gravity_Ellipsoid(P_i, CentralBody, lst)
%	[Gmag, G_i] = Gravity_Ellipsoid(P_i, CentralBody)
%
% INPUTS: 
%	Name       	Size		Units		Description
%   P_i         [3x1]       [dist]      Position in Central Body Centered 
%                                       Inertial Coordinates [ie ECI, LCI]
%
%   CentralBody {struct}                Central Body Parameters
%       .a      [1x1]       [dist]      Semi-major Axis
%       .b      [1x1]       [dist]      Semi-minor Axis
%       .rate   [1x1]       [rad/s]     Angular Velocity
%       .gm     [1x1]      [dist^3/s^2] Gravitational Constant
%       .El     [1x1]       [dist]      Linear Eccentricity
%       .E2l    [1x1]       [dist^2]    Linear Eccentricity Squared
%
%   lst         [1x1]       [deg]       Local Sidereal Time
%
% OUTPUTS: 
%	Name       	Size		Units		Description
%   Gmag        [1x1]       [dist/s^2]  Magnitude of Gravity Vector
%   G_i         [3x1]       [dist/s^2]  Gravity Vector in Inertial Centered
%                                       Coordiantes [ie ECI, LCI]
% NOTES:
%   This calculation is not unit specific.  Input parameters only need to
%   be of a uniform unit.  Standard METRIC [m, m^3/s^2] or ENGLISH [ft,
%   ft^3/s^2] should be used.
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[Gmag, G_i] = Gravity_Ellipsoid(P_i, CentralBody, lst, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Gmag, G_i] = Gravity_Ellipsoid(P_i, CentralBody, lst)
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
%	Source function: <a href="matlab:edit Gravity_Ellipsoid.m">Gravity_Ellipsoid.m</a>
%	  Driver script: <a href="matlab:edit Driver_Gravity_Ellipsoid.m">Driver_Gravity_Ellipsoid.m</a>
%	  Documentation: <a href="matlab:pptOpen('Gravity_Ellipsoid_Function_Documentation.pptx');">Gravity_Ellipsoid_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/651
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Gravity_Ellipsoid.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Gmag, G_i] = Gravity_Ellipsoid(P_i, CentralBody, lst)

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
Gmag= -1;
G_i= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        lst= ''; CentralBody= ''; P_i= ''; 
%       case 1
%        lst= ''; CentralBody= ''; 
%       case 2
%        lst= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(lst))
%		lst = -1;
%  end
%% Main Function:
%% Retrieve Needed Central Body Parameters:
a       = CentralBody.a;
b       = CentralBody.b;
omega   = CentralBody.rate;
gm      = CentralBody.gm;
E       = CentralBody.El;
E_2     = CentralBody.E2l;

%% ========================================================================
%      BEGIN COMPUTATIONS -- BEGIN COMPUTATIONS -- BEGIN COMPUTATIONS
%  ========================================================================

%% Convert Inertial Position into Fixed Position
P_f = eci2ecef( P_i, lst );

x = P_f(1);                     % [dist]
y = P_f(2);                     % [dist]
z = P_f(3);                     % [dist]
R = sqrt( x*x + y*y + z*z );    % [dist]

%% Compute u {Equation 4-8} -----------------------------------------------
u_p1 = (x*x) + (y*y) + (z*z) - E_2;                 % [dist^2]
u_p2 = 1.0 + sqrt( 1.0 + (4.0 * E_2 * z*z)/( u_p1 * u_p1 ) );
u2 = .5 * u_p1 * u_p2;                              % [dist^2]
u2E2 = u2 + E_2;                                    % [dist^2]
u = sqrt(u2);                                       % [dist]

%% Compute Beta {Equation 4-9} [rad] --------------------------------------
beta = atan( z * sqrt( u2E2 ) / ( u * sqrt( x*x + y*y ) ) );

%% Compute w {Equation 4-10} [dist] ---------------------------------------
w = sqrt( (u2 + E_2 * (sin(beta) * sin(beta))) / (u2E2) );

%% Compute q {Equation 4-11} ----------------------------------------------
q = 0.5 * ( ((1.0 + 3.0 * u2/(E_2)) * atan(E/u)) - (3.0*u/E) );

%% Compute q0 {Equation 4-12} ---------------------------------------------
q0 = 0.5 * ( ((1.0 + 3.0 * (b*b)/(E_2)) * atan(E/b)) - (3.0*b/E) );

%% Compute qprime {Equation 4-13} -----------------------------------------
qp = ( 3.0 * (1.0 + u2/(E_2)) * (1.0 - (u/E)*atan(E/u)) ) - 1.0;

%% Compute gamma_u {Equation 4-5} -----------------------------------------
cf_u = (u/w) * (omega * omega) * (cos(beta) * cos(beta));
cf_beta = (-1.0/w) * (omega*omega) * sqrt(u2E2) ...
    * sin(beta) * cos(beta);

gamma_u = (-1.0/w) * ( (gm/u2E2) + (omega*omega*a*a*E/u2E2) ...
    * (qp/q0) * ((.5 * sin(beta) * sin(beta)) - (1.0/6.0)) ) + cf_u;

%% Compute gamma_beta {Equation 4-6} --------------------------------------
gamma_beta = (1.0/w) * (omega*omega*a*a/sqrt(u2E2)) * (q/q0) ...
    * sin(beta)*cos(beta) + cf_beta;

%% ========================================================================
%   COMPUTE GRAVITY IN INERTIAL FRAME   [dist/s^2]
%  ========================================================================
Gmag = sqrt( gamma_u*gamma_u + gamma_beta*gamma_beta );
G_i = -Gmag * P_i/R;

%% Compile Outputs:
%	Gmag= -1;
%	G_i= -1;

end % << End of function Gravity_Ellipsoid >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
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
