% TURNOVERANGLE Computes the Turnover Angle for a Tail Dragger Aircraft
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% TurnoverAngle:
%     Computes the Turnover Angle for a Tail Dragger Aircraft 
% 
% SYNTAX:
%	[theta_turnover, theta_Main_wrt_Tail, psi_Main_wrt_Tail, CG_z_wrt_ground, CG_wrt_MainTail_line] = TurnoverAngle(TailGear, MainGear, CG, varargin, 'PropertyName', PropertyValue)
%	[theta_turnover, theta_Main_wrt_Tail, psi_Main_wrt_Tail, CG_z_wrt_ground, CG_wrt_MainTail_line] = TurnoverAngle(TailGear, MainGear, CG, varargin)
%	[theta_turnover, theta_Main_wrt_Tail, psi_Main_wrt_Tail, CG_z_wrt_ground, CG_wrt_MainTail_line] = TurnoverAngle(TailGear, MainGear, CG)
%	[theta_turnover, theta_Main_wrt_Tail, psi_Main_wrt_Tail, CG_z_wrt_ground, CG_wrt_MainTail_line] = TurnoverAngle(TailGear, MainGear)
%
% INPUTS: 
%	Name        Size	Units	Description
%   TailGear    [3]     [dist]  Ground Contact Location of the Tail (or
%                                  Nose) Gear w.r.t. Vehicle Origin
%   MainGear    [3]     [dist]  Ground Contact Location of the Main Gear
%                                  w.r.t. Vehicle Origin
%   CG          [3]     [dist]  Center of Gravity w.r.t. Vehicle Origin
%
% OUTPUTS: 
%	Name                Size    Units   Description
%   theta_turnover      [1]     [deg]   Vehicle Turnover Angle from CG
%                                       towards MainGear - TailGear Line
%   theta_Main_wrt_Tail [1]     [deg]   Angle of Vehicle wrt ground in resting
%                                       position in the body X-Z plane.
%                                       Positive indicates that the
%                                       vehicle "rests" in a nose up
%                                       orientation (ie. MainGear > TailGear)
%   psi_Main_wrt_Tail   [1]     [deg]   Angle between MainGear and TailGear 
%                                       wheel at rest in the body X-Y plane.
%                                       Positive indicates that the MainGear
%                                       is to the right of the TailGear.
%   
%   CG_z_wrt_ground     [1]     [dist]  Distance from the CG to the Ground when
%                                       the vehicle is at rest (all three 
%                                       wheels on ground)
%   CG_wrt_MainTail_line [1]    [dist]  Distance from the CG to the line drawn
%                                       through the Main and Tail Wheel.  This
%                                       perpendicular distance is used for the
%                                       turnover angle.
% NOTES:
%   These calculations assume:
%    1 - Vehicle is a Tail Dragger Aircraft
%    2 - Tail Locations are given as FS / BL / WL
%           (Positive X is aft, Y is right wing, Z is up)
%
%   These calculations are NOT unit specific.  Input distances only need to
%   be uniform (e.g. ENGLISH [ft] or METRIC [m]).
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[theta_turnover, theta_Main_wrt_Tail, psi_Main_wrt_Tail, CG_z_wrt_ground, CG_wrt_MainTail_line] = TurnoverAngle(TailGear, MainGear, CG, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[theta_turnover, theta_Main_wrt_Tail, psi_Main_wrt_Tail, CG_z_wrt_ground, CG_wrt_MainTail_line] = TurnoverAngle(TailGear, MainGear, CG)
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
%	Source function: <a href="matlab:edit TurnoverAngle.m">TurnoverAngle.m</a>
%	  Driver script: <a href="matlab:edit Driver_TurnoverAngle.m">Driver_TurnoverAngle.m</a>
%	  Documentation: <a href="matlab:pptOpen('TurnoverAngle_Function_Documentation.pptx');">TurnoverAngle_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/473
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/LandingGear/TurnoverAngle.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [theta_turnover, theta_Main_wrt_Tail, psi_Main_wrt_Tail, ...
            CG_z_wrt_ground, CG_wrt_MainTail_line] = ...
                TurnoverAngle(TailGear, MainGear, CG)

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
theta_turnover= -1;
theta_Main_wrt_Tail= -1;
psi_Main_wrt_Tail= -1;
CG_z_wrt_ground= -1;
CG_wrt_MainTail_line= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        CG= ''; MainGear= ''; TailGear= ''; 
%       case 1
%        CG= ''; MainGear= ''; 
%       case 2
%        CG= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(CG))
%		CG = -1;
%  end
%% Main Function:
%% Internal Constants:
R2D = 180/acos(-1);     % Radians to Degrees

%% Compute Static CG Height Above Ground Level:
H1 = TailGear(1) - MainGear(1);                     % [dist]
H2 = TailGear(3) - MainGear(3);                     % [dist]
theta_Main_wrt_Tail = atan2(H2,H1)*R2D;             % [deg]
H3 = CG(1) - MainGear(1);                           % [dist]
if(H3 == 0)
    H4 = H2;                                        % [dist]
else
    H4 = H2*(H1-H3)/H1;                             % [dist]
end
H5 = TailGear(3) - CG(3);                           % [dist]
H6 = H4 - H5;                                       % [dist]

CG_z_wrt_ground = H6*cosd(theta_Main_wrt_Tail);     % [dist]
CG_x_wrt_ground = H6*sind(theta_Main_wrt_Tail);     % [dist]

%% Compute Perpendicular Distance from CG to the MainGear-TailGear line:
Y1 = TailGear(1) - MainGear(1);                     % [dist]
Y2 = MainGear(2) - TailGear(2);                     % [dist]
psi_Main_wrt_Tail = atan2(Y2,Y1)*R2D;               % [deg]
Y3 = CG(1) - MainGear(1);                           % [dist]
if(Y3 == 0)
    Y4 = Y2;                                        % [dist]
else
    Y4 = Y2*(Y1-Y3)/Y1;                             % [dist]
end
Y5 = CG(2) - TailGear(2);                           % [dist]
Y6 = Y4 - Y5;                                       % [dist]

CG_wrt_MainTail_line = Y6*cosd(psi_Main_wrt_Tail);  % [dist]

%% Compute Turnover Angle:
theta_turnover = abs(atan2(CG_z_wrt_ground, ...
    CG_wrt_MainTail_line)*R2D);                     % [deg]

%% Compile Outputs:
%	theta_turnover= -1;
%	theta_Main_wrt_Tail= -1;
%	psi_Main_wrt_Tail= -1;
%	CG_z_wrt_ground= -1;
%	CG_wrt_MainTail_line= -1;

end % << End of function TurnoverAngle >>

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
