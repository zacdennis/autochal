% COMPLETEIC completes the IC struct for Oblate Earth Equations of motion
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CompleteIC:
%    Completes the IC structure required for the Oblate Earth Equations of
%    Motion to initialize the integrators and for other miscellaneous uses.
% 
% SYNTAX:
%	[IC] = CompleteIC(IC, mst, CentralBody)
%
% INPUTS: 
%	Name            Size		Units		Description
%   IC {structure}  [various]   [various]   Initial Condition Structure
%   mst             [1x1]       [deg]       Mean sidereal time
%   CentralBody     [various]   [various]   Central Body Structure
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
%	Because the integrators are in pure inertial space, the
%   initialization must ultimately be for IC.V_i. This can occur in the
%   following cases for identifying the velocity of the vehicle:
%   1.) Simply define the inertial velocity as components of IC.V_i
%       For when they are known in any condition (direct and simple)
%   2.) Define relative speed IC.Vtrue = |IC.Vrel_b| and flight path
%       Usually for atmospheric flight
%   3.) Define the pure relative velocity components IC.Vrel_b = [u v w]
%       Usually for atmospheric flight with known velocity components
%       (no flight path definition)
%   4.) Define total speed in inertial frame IC.Speed_i = |IC.V_i|
%       Usually for reentry conditions at entry interface defined by
%       flight path in NED and by inertial speed
%   This means that for these cases when we want to initialize in 
%   relative space, we must add the relative motion of the earth's 
%   atmosphere.  These caluclations are performed based on which parameters
%   were actually defined above in the user section (i.e. useIC). There
%   should be no need to change this initialization:
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[IC] = CompleteIC(IC, mst, CentralBody, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[IC] = CompleteIC(IC, mst, CentralBody)
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
%	Source function: <a href="matlab:edit CompleteIC.m">CompleteIC.m</a>
%	  Driver script: <a href="matlab:edit Driver_CompleteIC.m">Driver_CompleteIC.m</a>
%	  Documentation: <a href="matlab:pptOpen('CompleteIC_Function_Documentation.pptx');">CompleteIC_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/381
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/CompleteIC.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [IC] = CompleteIC(IC, mst, CentralBody)

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
%        CentralBody= ''; mst= ''; IC= ''; 
%       case 1
%        CentralBody= ''; mst= ''; 
%       case 2
%        CentralBody= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(CentralBody))
%		CentralBody = -1;
%  end
%% Main Function:
conversions;

%% Tag structure as metric to reduce confusion:
IC.Units   = CentralBody.units;

%% Convert LLA to Inertial Coordinates:
if (isfield(IC, 'P_i') ~= 1)
    [ IC.P_i ] = lla2eci( IC.LLA, CentralBody.flatten, CentralBody.a, mst);
else
    % Calculate LLA from the P_i which is defined:
    [IC.latcentric, IC.LLA(1), IC.LLA(2), IC.LLA(3)] ...
        = eci2lla(IC.P_i, CentralBody.a, CentralBody.b, CentralBody.flatten, mst);
end

% Calculate EulerECF:
IC.Euler_i = ned2eci( IC.LLA(1), IC.LLA(2), mst, IC.Euler_ned );
IC.Euler_f = eci2ecef( IC.Euler_i, mst );

%% Convert EulerECI orientation into quaternion representation
% Set the initial quaternion ony if it hasn't already been defined directly
if (isfield(IC, 'quat') ~= 1)
    IC.quat = eul2quaternion( IC.Euler_i * C.D2R );
end

% Calculate B:
IC.B = quaternion2dcm( IC.quat );

%% Calculate V_i based on how velocity was defined above:
if (isfield(IC, 'V_i') == 1)
    % Case 1 above
    % Do nothing; IC.V_i is defined.
elseif (isfield(IC, 'Vtrue') == 1)
    % Case 2 above
    % Convert IC.Vtrue and flight path into IC.V_i:
    
    % Calculate Relative Velocity in Body Frame
    IC.Vrel_b = [IC.Vtrue * cosd(IC.Beta) * cosd(IC.Alpha), ...
        IC.Vtrue * sind(IC.Beta), ...
        IC.Vtrue * cosd(IC.Beta) * sind(IC.Alpha)]';

    % Calculate the Inertial Velocity from the Relative Velocity
    IC.V_i = IC.B' * (IC.Vrel_b + IC.B * (CentralBody.OmegaE * IC.P_i'));
                 
elseif (isfield(IC, 'Vrel_b') == 1)
    % Case 3 above
    % TODO: Add the calculation for this (basically take the body and add
    % reverse the equation for case 4 (below) which calculates body from
    % inertial.
    
    % Calculate the Inertial Velocity from the Relative Velocity
    IC.V_i = IC.B' * (IC.Vrel_b' + IC.B * (CentralBody.OmegaE * IC.P_i'));
    
elseif (isfield(IC, 'Speed_i') == 1)
    % Case 4 above
    % Project IC.Speed_i onto components of IC.V_i with flight path
    % Calculate Inertial Speed in NED frame:
    IC.V_ned = abc2ned([0, IC.Gamma*C.D2R, IC.Chi*C.D2R]',[IC.Speed_i, 0, 0]');

    % Calculate the Inertial Velocity from NED velocity
    % using the Stevens and Lewis buildup rotating about mst and longitude:
    IC.V_i = ned2eci_old( IC.LLA(1)*C.D2R, (mst + IC.LLA(2))*C.D2R, IC.V_ned );
    
    % Calculate the relative velocity in body (uvw) from the inertial
    % (just to have, it is not needed in the sim):
    IC.Vrel_b = IC.B * IC.V_i - IC.B * (CentralBody.OmegaE * IC.P_i');
    
end

%% Calculate initial flight path variables unless already specified
if (isfield(IC, 'Alpha') ~= 1)
  if (isfield(IC, 'Vrel_b') ~= 1)
     IC.Vrel_b = IC.B * IC.V_i' - IC.B * (CentralBody.OmegaE * IC.P_i');
  end
  [IC.Alpha, IC.Beta, IC.Mu, IC.Gamma, IC.Chi] ...
      = calc_fp(IC.Vrel_b, IC.V_i, IC.Euler_ned);

%% Compile Outputs:
%	IC= -1;

end % << End of function CompleteIC >>

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
