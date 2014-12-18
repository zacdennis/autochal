% EUL_RSW_2_EUL_I converts orientation w.r.t RSW to orientation w.r.t. inertial frame
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% eul_rsw_2_eul_i:
%   Converts Orientation w.r.t. Satellite Coordinate System, RSW to 
%   Orientation w.r.t. Inertial Frame
% 
% SYNTAX:
%	[Euler_i, rsw_C_i] = eul_rsw_2_eul_i(P_i, V_i, Euler_rsw)
%
% INPUTS: 
%	Name     	Size    Units		Description
%   P_i         [3]     [length]    Position in Central Body Inertial Frame
%   V_i         [3]     [length/sec]Velocity in Central Body Inertial Frame
%   Euler_i     [3]     [rad]       Body orientation w.r.t. Inertial Frame 
%
% OUTPUTS: 
%	Name     	Size	Units		Description
%   Euler_rsw   [3]     [rad]       Body orientation w.r.t. RSW Frame
%   i_C_rsw     [3 3]   [ND]        DCM from RSW to Inertial Frame
%
% NOTES:
%   Satellite Coordinate System (RSW)
%   Right handed system moves with the satellite and is sometimes called
%   the Gaussian Coordinate System
%
%   R Axis -    Always points from center of central body to vehicle;
%               Positive out (-NADIR)
%   S Axis -    In Orbital plane, points towards velocity vector (if orbit
%               is circular, S Axis is parallel to velocity vector)
%   W Axis -    Cross-track axis; Completes coordiante system (R x S)
%
%  This function is NOT unit specific.  However, input position and 
%  velocity vectors must carry same distance unit.
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[Euler_i, rsw_C_i] = eul_rsw_2_eul_i(P_i, V_i, Euler_rsw, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Euler_i, rsw_C_i] = eul_rsw_2_eul_i(P_i, V_i, Euler_rsw)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
% [1]Vallado, David A.  Fundamentals of Astrodynamics and Applications.  
% New York: McGraw-Hill Companies, Inc., 1997.  Pages 43-51.  Equation 1-26
%
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
%
% Book with One Author:
% [2]   Author Last Name, Author First Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
% Book with Two Author:
% [3]   Author #1 Last Name, Author #1 First Name, and Author #2 Full Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit eul_rsw_2_eul_i.m">eul_rsw_2_eul_i.m</a>
%	  Driver script: <a href="matlab:edit Driver_eul_rsw_2_eul_i.m">Driver_eul_rsw_2_eul_i.m</a>
%	  Documentation: <a href="matlab:pptOpen('eul_rsw_2_eul_i_Function_Documentation.pptx');">eul_rsw_2_eul_i_Function_Documentation.pptx</a>
%
% See also eul_i_2_eul_rsw
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/337
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/eul_rsw_2_eul_i.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Euler_i, rsw_C_i] = eul_rsw_2_eul_i(P_i, V_i, Euler_rsw)

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
Euler_i= -1;
rsw_C_i= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        Euler_rsw= ''; V_i= ''; P_i= ''; 
%       case 1
%        Euler_rsw= ''; V_i= ''; 
%       case 2
%        Euler_rsw= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(Euler_rsw))
%		Euler_rsw = -1;
%  end
%% Main Function:
%% Compute Satellite Coordiante System Parameters:
Rhat = unitv( P_i );                % [ND]  Normalized Position Vector
Hvec = cross( P_i, V_i );
What = unitv(Hvec);                 % [ND]  Cross-track Position Vector
Shat = cross( What, Rhat );         % [ND]  In Orbit Velocity Vector

%% DCM from Satellite Coordinate System (rsw) to Inertial Frame (i):
i_C_rsw(:,1) = Rhat;
i_C_rsw(:,2) = Shat;
i_C_rsw(:,3) = What;
rsw_C_i = i_C_rsw';

%% DCM from RSW to Body Frame:
b_C_rsw = eul2dcm( Euler_rsw );

%% DCM from Inertial to Body Frame:
b_C_i = b_C_rsw * rsw_C_i;

%% Compute Inertial Euler Orientation:
Euler_i = dcm2eul( b_C_i );

% If input is a row vector, return a row vector:
if(size(Euler_rsw, 2) == 3)
    Euler_i = Euler_i';
end

%% Compile Outputs:
%	Euler_i= -1;
%	rsw_C_i= -1;

end % << End of function eul_rsw_2_eul_i >>

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
