% GRAVITYGRADIENT finds gravity gradient on an orbiting vehicle.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GravityGradient:
%   Computes the Central Body's Gravity Gradient on an orbiting vehicle
% 
% SYNTAX:
%	[GravityGradientTorque] = GravityGradient(P_i, quat, inertia, gm)
%
% INPUTS: 
%	Name                 	Size	Units           Description
%   P_i                     [3]     [dist]          Inertial Position
%   quat                    [4]     [ND]            Quaternion Vector from 
%                                                   inertial frame to body 
%                                                   frame (scaler is last
%                                                   element)
%   inertia                 [3x3]   [mass-dist^2]   Inertia Matrix
%   gm                      [1]     [dist^3/s^2]    Gravitational Constant
%
% OUTPUTS: 
%	Name                 	Size	Units           Description
%	GravityGradientTorque	[3]     [dist-force]    Torque created by 
%                                                   Gravity Gradient
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[GravityGradientTorque] = GravityGradient(P_i, quat, inertia, gm, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[GravityGradientTorque] = GravityGradient(P_i, quat, inertia, gm)
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
%	Source function: <a href="matlab:edit GravityGradient.m">GravityGradient.m</a>
%	  Driver script: <a href="matlab:edit Driver_GravityGradient.m">Driver_GravityGradient.m</a>
%	  Documentation: <a href="matlab:pptOpen('GravityGradient_Function_Documentation.pptx');">GravityGradient_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/654
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/GravityGradient.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [GravityGradientTorque] = GravityGradient(P_i, quat, inertia, gm)

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
GravityGradientTorque= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        gm= ''; inertia= ''; quat= ''; P_i= ''; 
%       case 1
%        gm= ''; inertia= ''; quat= ''; 
%       case 2
%        gm= ''; inertia= ''; 
%       case 3
%        gm= ''; 
%       case 4
%        
%       case 5
%        
%  end
%
%  if(isempty(gm))
%		gm = -1;
%  end
%% Main Function:
%% Compute Direction Cosine Matrix from Inertial to Body Frame, [ND]:
b_C_i = quaternion2dcm( quat );

%% Magnitude of Position, [length]:
Rmag    = norm(P_i);

%% Central Body Position Vector in Vehicle Body Frame, [length]:
if size(P_i,2) > size(P_i,1)
    Rs      = b_C_i * P_i';
else
    Rs      = b_C_i * P_i;
end

%% Inertia Matrix times Position Vector, [mass-dist^3]:
IRs         = inertia * Rs;
rCrossIRs   = cross(Rs, IRs);

%% Torque Craeted by the Gravity Gradient, [dist-force]:
GravityGradientTorque   = ((3 * gm) / (Rmag^5)) * rCrossIRs;
%% Compile Outputs:
%	GravityGradientTorque= -1;

end % << End of function GravityGradient >>

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
