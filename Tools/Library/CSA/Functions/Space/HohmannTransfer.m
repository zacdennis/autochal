% HOHMANNTRANSFER Computes the Delta-V required for a Hohmann Transfer
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% HohmannTransfer:
%     Computes the Delta-V required for a Hohmann Transfer
%
% *************************************************************************
% * #NOTE: To future COSMO'er, the following warning occured when running
% * CreateNewFunc.
% * CreateNewFunc>>WARNING: Selected Input argument name: "mu" is a
% * function name!
% * -JPG
% *************************************************************************
% SYNTAX:
%	[t_xfer, deltaV1, deltaV2, deltaVtotal] = HohmannTransfer(AltStart, AltFinal, SemiMajorAxis, mu, varargin, 'PropertyName', PropertyValue)
%	[t_xfer, deltaV1, deltaV2, deltaVtotal] = HohmannTransfer(AltStart, AltFinal, SemiMajorAxis, mu, varargin)
%	[t_xfer, deltaV1, deltaV2, deltaVtotal] = HohmannTransfer(AltStart,
%	AltFinal, SemiMajorAxis, mu)
%
% INPUTS: 
%	Name         	Size	Units               Description
%   AltStart                [length]            Starting Altitude
%   AltFinal                [length]            Ending Altitude
%   SemiMajorAxis           [length]            Central Body Semi-major Axis
%   mu                      [length^3/sec^2]    Central Body Gravitational Constant
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name         	Size	Units               Description
%   t_xfer                  [sec]               Transit time on Transfer Orbit
%   deltaV1                 [length/sec]        Delta-V needed to go from Starting
%                                               Orbit to Transfer Orbit
%   deltaV2                 [length/sec]        Delta-V needed to go from Transfer
%                                               Orbit to Final Orbit
%   deltaVtotal             [length/sec]        Total Delta-V required for Transfer
%                                               (|deltaV1| + |deltaV2|)
%
% NOTES:
%   Function is NOT unit specific.  However, input Altitudes, Semi-major 
%   axis, and Gravitational Constant must carry same unit on length.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[t_xfer, deltaV1, deltaV2, deltaVtotal] = HohmannTransfer(AltStart, AltFinal, SemiMajorAxis, mu, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[t_xfer, deltaV1, deltaV2, deltaVtotal] = HohmannTransfer(AltStart, AltFinal, SemiMajorAxis, mu)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
%   Vallado, David A.  Fundamentals of Astrodynamics and Applications.  New
%   York: McGraw-Hill Companies, Inc., 1997.  Pages 281-2.  Algorithm 33.
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
%	Source function: <a href="matlab:edit HohmannTransfer.m">HohmannTransfer.m</a>
%	  Driver script: <a href="matlab:edit Driver_HohmannTransfer.m">Driver_HohmannTransfer.m</a>
%	  Documentation: <a href="matlab:pptOpen('HohmannTransfer_Function_Documentation.pptx');">HohmannTransfer_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/546
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Space/HohmannTransfer.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [t_xfer, deltaV1, deltaV2, deltaVtotal] = HohmannTransfer(AltStart, AltFinal, SemiMajorAxis, mu, varargin)

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
% t_xfer= -1;
% deltaV1= -1;
% deltaV2= -1;
% deltaVtotal= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        mu= ''; SemiMajorAxis= ''; AltFinal= ''; AltStart= ''; 
%       case 1
%        mu= ''; SemiMajorAxis= ''; AltFinal= ''; 
%       case 2
%        mu= ''; SemiMajorAxis= ''; 
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
% Orbital Calculations:
r_start = AltStart + SemiMajorAxis;             % [length]
r_final = AltFinal + SemiMajorAxis;             % [length]
a_t     = (r_start + r_final)/2;                % [length]

% Transfer Time:
t_xfer = pi * sqrt( a_t^3 / mu );           % [sec]

% Circular Orbits:
v_start = sqrt(mu / r_start);                   % [length/sec]
v_final = sqrt(mu / r_final);                   % [length/sec]

% Transfer Velocities:
v_trans_a = sqrt( (2*mu/r_start) - (mu/a_t) );  % [length/sec]
v_trans_b = sqrt( (2*mu/r_final) - (mu/a_t) );  % [length/sec]

deltaV1 = v_trans_a - v_start;                  % [length/sec]
deltaV2 = v_final - v_trans_b;                  % [length/sec]
deltaVtotal = abs(deltaV1) + abs(deltaV2);      % [length/sec]

%% Compile Outputs:
%	t_xfer= -1;
%	deltaV1= -1;
%	deltaV2= -1;
%	deltaVtotal= -1;

end % << End of function HohmannTransfer >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
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
