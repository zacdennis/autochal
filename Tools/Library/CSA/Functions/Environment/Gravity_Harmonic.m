% GRAVITY_HARMONIC finds gravity with Spherical Harmonic Equations
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Gravity_Harmonic:
%   Computes Gravity (Vector and Magnitude) using Spherical Harmonic
%   Equations.
%
% *************************************************************************
% * #NOTE: To future COSMO'er, this warning appeared using CreateNewFunc
% * CreateNewFunc>>WARNING: Selected Input argument name: "lst" is a 
% * function name!
% * -JPG
% *************************************************************************
% SYNTAX:
%	[Gmag, G_i] = Gravity_Harmonic(P_i, CentralBody, lst, nmax)
%
% INPUTS: 
%	Name       	Size		Units		Description
%   P_i         [1x3]       [dist]      Position in Central Body Centered 
%                                        Inertial Coordinates [ie ECI, LCI]
%
%   CentralBody {struct}                Central Body Parameters
%       .a      [1x1]       [dist]       Semi-major Axis
%       .rate   [1x1]       [rad/s]      Angular Velocity
%       .gm     [1x1]       [dist^3/s^2] Gravitational Constant
%       .harmonic [MxN]     [ND]         Matrix of Normalized Gravitational
%                                         Coefficients. [Note: matrix must
%                                         be at least Mx4 in size where:
%                                         Column 3: Cosine Cnm Coefficients
%                                         Column 4: Sine Snm Coefficients
%
%   lst         [1x1]       [deg]       Local Sidereal Time
%   nmax        [1x1]       [int]       Maximum Order of Harmonic
%                                        Coefficients to use
%
% OUTPUTS: 
%	Name       	Size		Units		Description
%   Gmag        [1x1]       [dist/s^2]  Magnitude of Gravity Vector
%   G_i         [1x3]       [dist/s^2]  Gravity Vector in Inertial Centered
%                                        Coordinates [ie ECI, LCI]
%
% NOTES:
%   This calculation is not unit specific.  Input distances only need to be
%   of a uniform unit.  Standard METRIC [m, m^3/s^2] or ENGLISH 
%   [ft, ft^3/s^2] distances should be used. 
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[Gmag, G_i] = Gravity_Harmonic(P_i, CentralBody, lst, nmax, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Gmag, G_i] = Gravity_Harmonic(P_i, CentralBody, lst, nmax)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
%   Equation setup is based on:
%   [1] National Imagery and Mapping Agency (NIMA) Technical Report "NIMA
%   TR8350.2: Department of Defense World Geodetic System 1984, Its
%   Definition and Relationships with Local Geodetic Systems", Third
%   Edition, 4 July 1997.
%
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
%	Source function: <a href="matlab:edit Gravity_Harmonic.m">Gravity_Harmonic.m</a>
%	  Driver script: <a href="matlab:edit Driver_Gravity_Harmonic.m">Driver_Gravity_Harmonic.m</a>
%	  Documentation: <a href="matlab:pptOpen('Gravity_Harmonic_Function_Documentation.pptx');">Gravity_Harmonic_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/652
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Gravity_Harmonic.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Gmag, G_i] = Gravity_Harmonic(P_i, CentralBody, lst, nmax)

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
%        nmax= ''; lst= ''; CentralBody= ''; P_i= ''; 
%       case 1
%        nmax= ''; lst= ''; CentralBody= ''; 
%       case 2
%        nmax= ''; lst= ''; 
%       case 3
%        nmax= ''; 
%       case 4
%        
%       case 5
%        
%  end
%
%  if(isempty(nmax))
%		nmax = -1;
%  end
%% Main Function:
%% Check degree/order:
maxDegree = getDegree( CentralBody.harmonic );
if nmax > maxDegree
    disp('ERROR : Gravity_Harmonic');
    disp('      : Defined Degree/Order Exceeds that of Inputted Dataset');
    disp('      : Setting Defined Degree/Order to that of Input Dataset');
    nmax = maxDegree;
end

%% ========================================================================
%   BEGIN COMPUTATIONS -- BEGIN COMPUTATIONS
%  ========================================================================

%% Convert Inertial Position in Fixed:
P_f = eci2ecef( P_i, lst );     % [dist]

%% Compute Geocentric Latitude & Longitude:
lat = atan2( P_f(3), sqrt(P_f(1)*P_f(1) + P_f(2)*P_f(2)) );     % [rad]
lon = atan2( P_f(2), P_f(1) );                                  % [rad]

%% Compute Radius to Center of Earth:
R = sqrt( P_f(1)*P_f(1) + P_f(2)*P_f(2) + P_f(3)*P_f(3) );      % [dist]

%% Gravitational Potential due to Earth Rotation
%   {Equation 5-2, pg. 5-2, ref [1]}
PHI = .5 * CentralBody.rate * CentralBody.rate ...
    * (P_f(1)*P_f(1) + P_f(2)*P_f(2));

%% Compute Gravitatinoal Potential (V):
%   {Equation 5-3, pg. 5-2, ref [1]}
rowPtr = 0;
Vadd = 0;
for n = 2:nmax
    
    % Normalized Associated Legendre function
    %   Uses MATLAB FUNCTION legendre
    arrPnm = legendre( n, sin(lat), 'norm' );
    
    for m = 0:n

        rowPtr = rowPtr + 1;
        %% Lookup Cnm_bar and Snm_bar
        Cnm = CentralBody.harmonic(rowPtr, 3) * cos( m*lon );
        Snm = CentralBody.harmonic(rowPtr, 4) * sin( m*lon );
                         
        % Pick of Relevant Associated Legendre function
        Pnm_bar = arrPnm(m+1);
                      
        Vadd = Vadd + (((CentralBody.a/R)^n) * Pnm_bar * (Cnm + Snm));
    end
end

%% Gravitational Potential [dist^2/s^2]
V = (CentralBody.gm/R)*(1 + Vadd);

%% Total Gravity Potential [dist^2/s^2]
%   {Eq. 5-1, pg. 5-2, ref [1]}
W = V + PHI;

%% Compute Gravity Vector / Magnitude
Gmag = (W/R);               % [dist/s^2]   Magnitude
G_i = -Gmag * (P_i/R);      % [dist/s^2]   Vector where (P_i/R) is the unit 
                            %            vector

%% Compile Outputs:
%	Gmag= -1;
%	G_i= -1;

end % << End of function Gravity_Harmonic >>

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
