% GENERATEATTACHMENTIC Creates IC struct for Oblate Earth EOM to initialize integrators
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GenerateAttachmentIC:
%    Creates the IC structure required for the Oblate Earth Equations of
%    Motion to initialize the integrators and for other miscellaneous uses.
% 
% SYNTAX:
%	[IC] = GenerateAttachmentIC(BaseVehIC, AttachmentStruct, mst, CentralBody)
%	[IC] = GenerateAttachmentIC(BaseVehIC, AttachmentStruct, mst)
%
% INPUTS: 
%	Name            	Size	Units         Description
%   BaseVehIC           [structure]           Base Vehicle Initial 
%                                             Conditions Structure
%        .Units         [1xN]   [ND]          String designating units used
%        .P_i           [3x1]   [length]      Position in Central Body
%                                             Inertial Frame
%        .V_i           [3x1]   [length/sec]  Velocity in Central Body
%                                             Inertial Frame
%        .Euler_i       [3x1]   [deg]         Euler orientation in 
%                                             Central Body Inertial
%                                             Frame
%        .PQRb          [3x1]   [deg]         Rotational velocity in 
%                                             Aircraft Body Frame
%        .Alpha         [1x1]   [deg]         Angle of Attack
%        .Beta          [1x1]   [deg]         Angle of Sideslip
%        .Gamma         [1x1]   [deg]         Vertical flight path angle
%        .Chi           [1x1]   [deg]         Horizontal flight path angle
%                                             (heading)
%        .Mu            [1x1]   [deg]         Bank angle about the velocity
%                                             vector
%   AttachmentStruct    [structure]           Attachment Vehicle data
%                                             structure
%        .P_b_rel       [1x3]   [length]      Distance relative to 
%                                             base vehicle body axis
%        .Euler_b_rel   [1x3]   [rad]         Attachment orientation on 
%                                             base vehicle relative to base 
%                                             vehicle’s body axis
%   mst                 [1x1]   [deg]         mean sidereal time
%   CentralBody         [structure]           Central body parameters
%        .a             [1x1]   [length]      Semi-major axis (equatorial
%                                             radius)
%        .b             [1x1]   [length]      Semi-minor axis (polar
%                                             radius)
%        .flatten       [1x1]   [ND]          Flattening parameter
%        .OmegaE        [3x3]   [rad/sec]     Angular Velocity
%
% OUTPUTS: 
%	Name            	Size		Units     Description
%     IC                [structure]           IC structure required for 
%                                             Oblate earth Equations
%                                             for an attached vehicle
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[IC] = GenerateAttachmentIC(BaseVehIC, AttachmentStruct, mst, CentralBody, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[IC] = GenerateAttachmentIC(BaseVehIC, AttachmentStruct, mst, CentralBody)
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
%	Source function: <a href="matlab:edit GenerateAttachmentIC.m">GenerateAttachmentIC.m</a>
%	  Driver script: <a href="matlab:edit Driver_GenerateAttachmentIC.m">Driver_GenerateAttachmentIC.m</a>
%	  Documentation: <a href="matlab:pptOpen('GenerateAttachmentIC_Function_Documentation.pptx');">GenerateAttachmentIC_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/385
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/GenerateAttachmentIC.m $
% $Rev: 2025 $
% $Date: 2011-07-19 18:03:20 -0500 (Tue, 19 Jul 2011) $
% $Author: healypa $

function [IC] = GenerateAttachmentIC(BaseVehIC, AttachmentStruct, mst, CentralBody)

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
%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        CentralBody= ''; mst= ''; AttachmentStruct= ''; BaseVehIC= ''; 
%       case 1
%        CentralBody= ''; mst= ''; AttachmentStruct= ''; 
%       case 2
%        CentralBody= ''; mst= ''; 
%       case 3
%        CentralBody= ''; 
%       case 4
%        
%       case 5
%        
%  end
%
%  if(isempty(CentralBody))
%		CentralBody = -1;
%  end
%% Main Function:
conversions;

%% Tag structure as metric to reduce confusion:
IC.Units    = BaseVehIC.Units;

if(~isfield(IC, 'PQRb'))
    IC.PQRb = zeros(1,3);
end

%% Compute P_i, V_i, and Euler_i while on stack:
[IC.P_i, IC.V_i, IC.Euler_i, IC.PQRb] = TranslateOffset( BaseVehIC.P_i, ...
    BaseVehIC.V_i, ...
    BaseVehIC.Euler_i * C.D2R, ...
    BaseVehIC.PQRb * C.D2R, ...
    AttachmentStruct.P_b_rel, ...
    AttachmentStruct.Euler_b_rel );
IC.Euler_i = IC.Euler_i' * C.R2D;
IC.quat    = eul2quaternion( IC.Euler_i * C.D2R );
IC.B = quaternion2dcm( IC.quat );

% Fixed Position / Velocity / Orientation:
IC.P_f = eci2ecef( IC.P_i, mst );
IC.V_f = eci2ecef( IC.V_i, mst );
IC.negRhat = CalcNegRhat(IC.P_i, IC.Euler_i);

% LLA:
[IC.GeocentricLat, IC.LLA(1), IC.LLA(2), IC.LLA(3)] = eci2lla(IC.P_i, ...
    CentralBody.a, CentralBody.b, CentralBody.flatten, mst);

% NED Position / Orientation:
IC.P_ned = ecef2ned( IC.P_f, IC.LLA(1), IC.LLA(2) );
IC.V_ned = ecef2ned( IC.V_f, IC.LLA(1), IC.LLA(2) );
IC.Euler_ned = eul_i_2_eul_ned(IC.LLA(1), IC.LLA(2), mst, IC.Euler_i)';

% LVLH Orientation:
IC.Euler_lvlh = eul_i_2_eul_lvlh( IC.P_i, IC.V_i, IC.Euler_i)';

% Calculate the relative velocity in body (uvw) from the inertial
% (just to have, it is not needed in the sim):
IC.Vrel_b = (IC.B * IC.V_i' - IC.B * (CentralBody.OmegaE * IC.P_i'))';
[IC.Alpha, IC.Beta, IC.Vtrue] = Vb2AlphaBetaVtrue( IC.Vrel_b );

[IC.Gamma, IC.Chi, IC.Vtrue]  = Vned2GammaChiVtrue(IC.V_ned);
IC.Mu = BankAngle(IC.Alpha, IC.Beta, IC.Euler_ned);

IC = PosVel2OrbEl(IC.P_i, IC.V_i, CentralBody.gm, IC);

%% Compile Outputs:
%	IC= -1;

end % << End of function GenerateAttachmentIC >>

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
