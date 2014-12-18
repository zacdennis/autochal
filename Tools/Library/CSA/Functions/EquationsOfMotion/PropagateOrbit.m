% PROPAGATEORBIT computes position and velocity in an elliptical orbit from current position and velocity
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% PropagateOrbit:
%   Computes Position and Velocity in an Elliptical Orbit 'deltaT' seconds
%   from current Position and Velocity
% *************************************************************************
% * #NOTE: To future COSMO'er, this warning appeared using CreateNewFunc
% * CreateNewFunc>>WARNING: Selected Input argument name: "Mu" is a
% * function name!
% * -JPG
% *************************************************************************
% SYNTAX:
%	[P_i2, V_i2, Gamma2, OrbEl1, OrbEl2] = PropagateOrbit(P_i1, V_i1,
%	deltaT, mu)
%
% INPUTS: 
%	Name    Size	Units               Description
%   P_i1    [1x3]   [length]            Position in Central Body Inertial
%                                       Frame
%   V_i1    [1x3]   [length/sec]        Velocity in Central Body Inertial
%                                       Frame
%   deltaT  [1x1]   [sec]               Time to Move in Orbit
%   mu      [1x1]   [length^3/sec^2]    Central Body Gravitational
%   Constant
%
% OUTPUTS: 
%	Name            Size	Units       Description
%   P_i2            [1x3]   [length]    Position in Central Body Inertial
%                                       Frame after deltaT
%   V_i2            [1x3]   [length/sec]Velocity in Central Body Inertial
%                                       Frame after deltaT
%   Gamma2          [1x1]   [deg]       Flight Path Angle after deltaT
%   OrbEl1           [structure]        Orbital Elements Structure at 
%                                       Initial Position / Velocity
%   .a              [1x1]   [length]    Semi-major axis
%   .e              [1x1]   [ND]        Eccentricity
%   .theta          [1x1]   [deg]       True anomaly
%   .i              [1x1]   [deg]       Inclination
%   .omega          [1x1]   [deg]       Argument of the perigee
%   .deltaT         [1x1]   [sec]       Time since perigee passage
%   .capE           [1x1]   [deg]       Eccentric anomaly
%   .rp             [1x1]   [length]    Radius or perigee
%   .ra             [1x1]   [length]    Radius of apogee
%   .b              [1x1]   [length]    Semi-minor axis
%   .P              [1x1]   [length]    Semilatus rectum
%   .period         [1x1]   [sec]       Period of orbit
%   .n              [1x1]   [rad/sec]   mean motion
%   .M              [1x1]   [deg]       Mean anomaly
%   .omega_defined  [1x1]   [bool]      Argument of perigee defined
%                                       (omega is undefined for perfectly 
%                                       circular, e=0 and equatorial 
%                                       orbits i=0)
%   .RAAN_defined   [1x1]   [bool]      RAAN defined (RAAN is undefined
%                                       for equatorial orbits (i=0)
%   OrbEl2           [structure]        Orbital Elements after Propagation
%                                       See OrbEl1 for information on 
%                                       individual parameters within 
%                                       OrbEl2  
%
% NOTES:
%   This function is NOT unit specific.  Unit specific outputs will be
%   based on the units of the inputs.  Standard METRIC or ENGLISH units
%   should be used.
%
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[P_i2, V_i2, Gamma2, OrbEl1, OrbEl2] = PropagateOrbit(P_i1, V_i1, deltaT, mu, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[P_i2, V_i2, Gamma2, OrbEl1, OrbEl2] = PropagateOrbit(P_i1, V_i1, deltaT, mu)
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
%	Source function: <a href="matlab:edit PropagateOrbit.m">PropagateOrbit.m</a>
%	  Driver script: <a href="matlab:edit Driver_PropagateOrbit.m">Driver_PropagateOrbit.m</a>
%	  Documentation: <a href="matlab:pptOpen('PropagateOrbit_Function_Documentation.pptx');">PropagateOrbit_Function_Documentation.pptx</a>
%
% See also OrbEl2PosVel, PosVel2OrbEl
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/221
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/PropagateOrbit.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [P_i2, V_i2, Gamma2, OrbEl1, OrbEl2] = PropagateOrbit(P_i1, V_i1, deltaT, mu)

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
P_i2= -1;
V_i2= -1;
Gamma2= -1;
OrbEl1= -1;
OrbEl2= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        mu= ''; deltaT= ''; V_i1= ''; P_i1= ''; 
%       case 1
%        mu= ''; deltaT= ''; V_i1= ''; 
%       case 2
%        mu= ''; deltaT= ''; 
%       case 3
%        mu= ''; 
%       case 4
%        
%       case 5
%        
%  end
%
%  if(isempty(mu))
%		mu = -1;
%  end
%% Main Function:
conversions;        % Load Unit Conversions

%% Compute Orbital Elements for Current Position:
OrbEl1 = PosVel2OrbEl( P_i1, V_i1, mu );
OrbEl2 = OrbEl1;    % Initialize OrbEl2 Structure

%% Compute New Time Since Perigee, [sec]:
deltaT2 = OrbEl1.deltaT + deltaT;

%% Compute New Mean Anomaly, [rad]:
M = wrap2pi(OrbEl1.n * deltaT2);

%% Compute New Eccentric Anomaly, [rad]:
capE2 = ComputeEcc( M, OrbEl1.e );

%% Compute New True Anomaly, [rad]:
theta2 = 2 * atan(sqrt( (1+OrbEl1.e)/(1-OrbEl1.e) )*tan(capE2/2));

%% Convernt Angles to [deg]:
OrbEl2.theta    = wrap360( theta2 * C.R2D );
OrbEl2.capE     = wrap360( capE2 * C.R2D );
OrbEl2.M        = wrap360( M * C.R2D );

%% Compute New Position/Velocity Given new Orbital Elements:
[P_i2, V_i2, Gamma2] = OrbEl2PosVel(OrbEl2.a, OrbEl2.e, OrbEl2.theta, ...
    OrbEl2.RAAN, OrbEl2.i, OrbEl2.omega, mu);

%% Compile Outputs:
%	P_i2= -1;
%	V_i2= -1;
%	Gamma2= -1;
%	OrbEl1= -1;
%	OrbEl2= -1;

end % << End of function PropagateOrbit >>

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
