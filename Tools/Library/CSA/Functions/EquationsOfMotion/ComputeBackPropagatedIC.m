% COMPUTEBACKPROPAGATEDIC computes IC struct for a vehicle outside of CB's atmosphere
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ComputeBackPropagatedIC:
%   Computes the Initial Condition Structure for a vehicle outside of the
%   Central Body's atmosphere (prior to Entry Interface)
% 
% SYNTAX:
%	[IC] = ComputeBackPropagatedIC(EI, CentralBody, mst, backoutTime)
%
% INPUTS: 
%	Name            Size		Units           Description
%   EI          {structure}                     Vehicle States at Entry
%                                               Interface
%       .P_i        [1x3]       [length]        Position in Central Body
%                                               Inertial Frame
%       .V_i        [1x3]       [length/sec]    Velocity in Central Body
%                                               Inertial Frame
%       .Euler_i    [1x3]       [rad]           Euler orientation in 
%                                               Central Body Inertial
%                                               Frame
%       .PQRb       [1x3]       [rad/sec]       Rotational velocity in 
%                                               Aircraft Body Frame
%   CentralBody {structure}                     Central Body Parameters
%       .a          [1x1]       [length]        Semi-major axis
%       .b          [1x1]       [length]        Semi-minor axis
%       .flatten    [1x1]       [ND]            Flattening Parameter
%       .gm         [1x1]       [length^3/sec^2]Gravitational Constant
%   mst             [1x1]       [deg]           Mean-Sidereal Time
%   backoutTime     [1x1]       [sec]           Time prior to Entry
%                                               Interface to at which to
%                                               compute Initial Conditions
%
% OUTPUTS: 
%	Name            Size		Units           Description
%   IC          {structure}                     Vehicle's Initial States  
%                                               and Conditions
%       .P_i        [3x1]   [length]            Position in Central Body
%                                               Inertial Frame
%       .V_i        [3x1]   [length/sec]        Velocity in Central Body
%                                               Inertial Frame
%       .LLA        [3x1]   [deg deg length]    Geodetic Latitude/Longitude
%                                               /Altitude
%       .PQRb       [1x3]   [rad/sec]           Rotational velocity in  
%                                               Aircraft Body Frame
%       .Euler_i    [3x1]   [rad]               Euler orientation in 
%                                               Central Body Inertial
%                                               Frame
%       .quat       [1x4]   [ND]                Quaterions
%       .B          [3x3]   [ND]                Transformation Matrix from 
%                                               Central Body Inertial Frame 
%                                               to Aircraft Body Frame
%       .P_f        [3x1]   [length]            Initial Position in Central
%                                               Body Fixed Frame
%       .V_f        [3x1]   [length/sec]        Initial Velocity in Central
%                                               Body Fixed Frame
%       .V_ned      [3x1]   [length/sec]        Velocity in North East Down
%                                               Frame
%       .Euler_ned  [3x1]   [rad]               Euler orientation in North 
%                                               East Down Frame
%       .Vrel_b     [3x1]   [length/sec]        Relative velocity in 
%                                               Aircraft Body Frame
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[IC] = ComputeBackPropagatedIC(EI, CentralBody, mst, backoutTime, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[IC] = ComputeBackPropagatedIC(EI, CentralBody, mst, backoutTime)
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
%	Source function: <a href="matlab:edit ComputeBackPropagatedIC.m">ComputeBackPropagatedIC.m</a>
%	  Driver script: <a href="matlab:edit Driver_ComputeBackPropagatedIC.m">Driver_ComputeBackPropagatedIC.m</a>
%	  Documentation: <a href="matlab:pptOpen('ComputeBackPropagatedIC_Function_Documentation.pptx');">ComputeBackPropagatedIC_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/382
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/ComputeBackPropagatedIC.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [IC] = ComputeBackPropagatedIC(EI, CentralBody, mst, backoutTime)

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
IC= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        backoutTime= ''; mst= ''; CentralBody= ''; EI= ''; 
%       case 1
%        backoutTime= ''; mst= ''; CentralBody= ''; 
%       case 2
%        backoutTime= ''; mst= ''; 
%       case 3
%        backoutTime= ''; 
%       case 4
%        
%       case 5
%        
%  end
%
%  if(isempty(backoutTime))
%		backoutTime = -1;
%  end
%% Main Function:
%% Load Unit Conversions
conversions;    

%% Transfer Units:
IC.Units   = CentralBody.units;

%% Compute Position and Velocity in Orbit:
[IC.P_i, IC.V_i, IC.Gamma] = PropagateOrbit( EI.P_i, EI.V_i, ...
    -backoutTime, CentralBody.gm );

%% Convert Inertial Coordinates to Lat / Lon / Alt  [deg deg length]:
[IC.LLA(1), GC_lat, IC.LLA(2), IC.LLA(3)] = eci2lla( IC.P_i, ...
    CentralBody.a, CentralBody.b, CentralBody.flatten, mst );

%% Retain Same Body Rotational Rates:
IC.PQRb       = EI.PQRb;   % [rad/s]

%% Assume no moments act on vehicle, hence EulerECI does not change:
IC.Euler_i = EI.Euler_i;            % [rad]
IC.quat = eul2quaternion( IC.Euler_i );   % [ND]
IC.B = eul2dcm( IC.Euler_i );       % [ND]

%% Compute Rotation of Central Body during Backout:
lst = mst - CentralBody.rate * backoutTime;

%% Compute Fixed Position and Velocity:
[IC.P_f, f_C_i] = eci2ecef(IC.P_i, lst);
[IC.V_f, f_C_i] = eci2ecef(IC.V_i, lst);

%% Compute NED Velocity:
[IC.V_ned, ned_C_f] = ecef2ned(IC.V_f, IC.LLA(1), IC.LLA(2));

%% Compute EulerNED:
%   DCM from Inertial to NED Frame:
ned_C_i = ned_C_f * f_C_i;
%   DCM from NED to Inertial Frame:
i_C_ned = ned_C_i';
%   DCM from NED to Body Frame:
b_C_ned = IC.B * i_C_ned;
IC.Euler_ned = dcm2eul(b_C_ned);

%% Compute Relative Velocity in Body Frame, [length/sec]:
IC.Vrel_b = IC.B * IC.V_i' - IC.B * (CentralBody.OmegaE * IC.P_i');

%% Compute Flight Path Angles, [deg]:
[IC.Alpha, IC.Beta, IC.Mu, IC.Gamma, IC.Chi] = calc_fp(IC.Vrel_b, ...
    IC.V_i, IC.Euler_ned);

%% Compute Magnitude of Velocity Vector:
IC.Speed_i = norm(IC.V_i);    % [length/sec]

%% Compile Outputs:
%	IC= -1;

end % << End of function ComputeBackPropagatedIC >>

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
