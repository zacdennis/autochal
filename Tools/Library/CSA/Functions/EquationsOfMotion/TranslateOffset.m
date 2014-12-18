% TRANSLATEOFFSET computes pos, vel, and orientation of point attached to a body at a given relative dist and orientation
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% TranslateOffset:
%   Computes P_i, V_i, and Euler_i of a point P attached to a given body
%   at a given a relative distance P_b and orientation Euler_b.
% 
% SYNTAX:
%	[P_i_offset, V_i_offset, Euler_i_offset, PQRb_offset] = ...
%       TranslateOffset(P_i, V_i, Euler_i, PQRbody, Offset_P_b_rel, ...
%           Offset_Euler_b_rel)
%
% INPUTS: 
%	Name              	Size	Units           Description
%   P_i                 [1x3]   [length]        Position in Central Body
%                                                 Inertial Frame
%   V_i                 [1x3]   [length/sec]    Velocity in Central Body
%                                                 Inertial Frame
%   Euler_i             [1x3]   [rad]           Euler orientation in 
%                                                 Central Body Inertial
%                                                 Frame
%   PQRbody             [1x3]   [rad/sec]       Rotational velocity in 
%                                                 Aircraft Body Frame
%   Offset_P_b_rel      [1x3]   [length]        Pt.P Attachment Position on 
%                                                 Base Vehicle. Distance 
%                                                 relative to base vehicle 
%                                                 in base Vehicle body axis
%   Offset_Euler_b_rel  [1x3]   [rad]           Pt. P Attachment Orientation 
%                                                 on Base Vehicle Relative 
%                                                 to base vehicle’s body
%                                                 axis
%
% OUTPUTS: 
%	Name              	Size	Units           Description
%   P_i_offset          [1x3]   [length]        Position in Central Body 
%                                                 Inertial Frame of pt. p
%   V_i_offset          [1x3]   [length/sec]    Velocity in Central Body
%                                                 Inertial Frame of pt. P
%   Euler_i_offset      [1x3]   [rad]           Euler orientation in 
%                                                 Central Body Inertial 
%                                                 Frame of pt P
%   PQRbody_offset      [1x3]   [rad/sec]       Attatch points Rotational 
%                                                 velocity in Aircraft 
%                                                 Body Frame
%
% NOTES:
%   This calculation is not unit specific.  Input lengths only need to be
%   of a uniform unit.  Standard METRIC [m] or ENGLISH [ft] distances
%   should be used.  All input angles and rates MUST be in [rad].
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[P_i_offset, V_i_offset, Euler_i_offset, PQRb_offset] = TranslateOffset(P_i, V_i, Euler_i, PQRbody, Offset_P_b_rel, Offset_Euler_b_rel, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[P_i_offset, V_i_offset, Euler_i_offset, PQRb_offset] = TranslateOffset(P_i, V_i, Euler_i, PQRbody, Offset_P_b_rel, Offset_Euler_b_rel)
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
%	Source function: <a href="matlab:edit TranslateOffset.m">TranslateOffset.m</a>
%	  Driver script: <a href="matlab:edit Driver_TranslateOffset.m">Driver_TranslateOffset.m</a>
%	  Documentation: <a href="matlab:pptOpen('TranslateOffset_Function_Documentation.pptx');">TranslateOffset_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/399
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/TranslateOffset.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [P_i_offset, V_i_offset, Euler_i_offset, PQRb_offset] = TranslateOffset(P_i, V_i, Euler_i, PQRbody, Offset_P_b_rel, Offset_Euler_b_rel, varargin)

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
P_i_offset= -1;
V_i_offset= -1;
Euler_i_offset= -1;
PQRb_offset= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        Offset_Euler_b_rel= ''; Offset_P_b_rel= ''; PQRbody= ''; Euler_i= ''; V_i= ''; P_i= ''; 
%       case 1
%        Offset_Euler_b_rel= ''; Offset_P_b_rel= ''; PQRbody= ''; Euler_i= ''; V_i= ''; 
%       case 2
%        Offset_Euler_b_rel= ''; Offset_P_b_rel= ''; PQRbody= ''; Euler_i= ''; 
%       case 3
%        Offset_Euler_b_rel= ''; Offset_P_b_rel= ''; PQRbody= ''; 
%       case 4
%        Offset_Euler_b_rel= ''; Offset_P_b_rel= ''; 
%       case 5
%        Offset_Euler_b_rel= ''; 
%       case 6
%        
%       case 7
%        
%  end
%
%  if(isempty(Offset_Euler_b_rel))
%		Offset_Euler_b_rel = -1;
%  end
%% Main Function:
%% Compute DCM translating body to inertial frame:
body_C_i = eul2dcm( Euler_i );
i_C_body = body_C_i';

%% Compute P_i_offset, [length]:
P_i_offset = P_i + (i_C_body * Offset_P_b_rel')';

%% Compute V_i_offset, [length/s]:
V_i_offset = V_i + (i_C_body * cross(PQRbody, Offset_P_b_rel)')';

%% Compute Euler_i_offset, [rad]:
attach_C_body = eul2dcm( Offset_Euler_b_rel );
Euler_i_offset = dcm2eul( attach_C_body * body_C_i );

if(size(Euler_i, 2) == 3)
    Euler_i_offset = Euler_i_offset';
end

%% Compute PQR_b_offset, [rad/s]:
PQRb_offset = (attach_C_body * PQRbody')';

%% Compile Outputs:
%	P_i_offset= -1;
%	V_i_offset= -1;
%	Euler_i_offset= -1;
%	PQRb_offset= -1;

end % << End of function TranslateOffset >>

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
