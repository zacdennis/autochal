% FORCESMOMENTS2AEROCOEFFS Computes aerodynamic coefficients from forces and moments. 
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ForcesMoments2AeroCoeffs:
%     <Function Description> 
% 
% SYNTAX:
%	[ACs] = ForcesMoments2AeroCoeffs(Forces, Moments_cg, Moments_ref, Sref, span, mac, Qbar, Alpha, varargin, 'PropertyName', PropertyValue)
%	[ACs] = ForcesMoments2AeroCoeffs(Forces, Moments_cg, Moments_ref, Sref, span, mac, Qbar, Alpha, varargin)
%	[ACs] = ForcesMoments2AeroCoeffs(Forces, Moments_cg, Moments_ref, Sref, span, mac, Qbar, Alpha)
%	[ACs] = ForcesMoments2AeroCoeffs(Forces, Moments_cg, Moments_ref, Sref, span, mac, Qbar)
%
% INPUTS: 
%	Name       	Size	Units		Description
%	Forces	    [3]		<units>		<Description>
%	Moments_cg	[3]		<units>		<Description>
%	Moments_ref	[3]		<units>		<Description>
%	Sref	    [1]		<units>		<Description>
%	span	    [1]		<units>		<Description>
%	mac 	    [1]		<units>		<Description>
%	Qbar	    [1]		<units>		<Description>
%	Alpha	    [1]		<units>		<Description>
%
% OUTPUTS: 
%	Name       	Size		Units		Description
%	ACs 	    {struct}                Aerodynamic coefficients structure 
%   .CX                                 Coefficient of X-force in Aircraft 
%                                           Body Frame
%   .CY                                 Coefficient of Y-force in Aircraft
%                                           Body Frame
%   .CZ                                 Coefficient of Z-force in Aircraft
%                                           Body Frame
%   .CL                                 Coefficient of Lift
%   .CD                                 Coefficient of Drag
%   .Cl_cg                              Coefficient of rolling moment in
%                                           Aircraft Body Frame at the
%                                           Center of Gravity
%   .Cm_cg                              Coefficient of pitching moment in
%                                           Aircraft Body Frame at the
%                                           Center of Gravity
%   .Cn_cg                              Coefficient of yawing moment in
%                                           Aircraft Body Frame at the
%                                           Center of Gravity
%   .Cl_ref                             Coefficient of rolling moment in
%                                           Aircraft Body Frame at Aero
%                                           Ref point
%   .Cm_ref                             Coefficient of pitching moment in
%                                           Aircraft Body Frame at Aero
%                                           Ref point
%   .Cn_ref                             Coefficient of yawing moment in
%                                           Aircraft Body Frame at Aero
%                                           Ref point
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
%	[ACs] = ForcesMoments2AeroCoeffs(Forces, Moments_cg, Moments_ref, Sref, span, mac, Qbar, Alpha, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[ACs] = ForcesMoments2AeroCoeffs(Forces, Moments_cg, Moments_ref, Sref, span, mac, Qbar, Alpha)
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
%	Source function: <a href="matlab:edit ForcesMoments2AeroCoeffs.m">ForcesMoments2AeroCoeffs.m</a>
%	  Driver script: <a href="matlab:edit Driver_ForcesMoments2AeroCoeffs.m">Driver_ForcesMoments2AeroCoeffs.m</a>
%	  Documentation: <a href="matlab:pptOpen('ForcesMoments2AeroCoeffs_Function_Documentation.pptx');">ForcesMoments2AeroCoeffs_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/46
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AerodynamicFunctions/ForcesMoments2AeroCoeffs.m $
% $Rev: 1714 $
% $Date: 2011-05-11 15:23:59 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [ACs] = ForcesMoments2AeroCoeffs(Forces, Moments_cg, Moments_ref, Sref, span, mac, Qbar, Alpha)

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
ACs= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        Alpha= ''; Qbar= ''; mac= ''; span= ''; Sref= ''; Moments_ref= ''; Moments_cg= ''; Forces= ''; 
%       case 1
%        Alpha= ''; Qbar= ''; mac= ''; span= ''; Sref= ''; Moments_ref= ''; Moments_cg= ''; 
%       case 2
%        Alpha= ''; Qbar= ''; mac= ''; span= ''; Sref= ''; Moments_ref= ''; 
%       case 3
%        Alpha= ''; Qbar= ''; mac= ''; span= ''; Sref= ''; 
%       case 4
%        Alpha= ''; Qbar= ''; mac= ''; span= ''; 
%       case 5
%        Alpha= ''; Qbar= ''; mac= ''; 
%       case 6
%        Alpha= ''; Qbar= ''; 
%       case 7
%        Alpha= ''; 
%       case 8
%        
%       case 9
%        
%  end
%
%  if(isempty(Alpha))
%		Alpha = -1;
%  end
%% Main Function:
ACs.CX = Forces(1) / (Qbar * Sref);
ACs.CY = Forces(2) / (Qbar * Sref);
ACs.CZ = Forces(3) / (Qbar * Sref);
[ACs.CL, ACs.CD] = CXCZ2CLCD( ACs.CX, ACs.CZ, Alpha);

ACs.Cl_cg = Moments_cg(1) / (Qbar * Sref * span);
ACs.Cm_cg = Moments_cg(2) / (Qbar * Sref * mac);
ACs.Cn_cg = Moments_cg(3) / (Qbar * Sref * span);

ACs.Cl_ref = Moments_ref(1) / (Qbar * Sref * span);
ACs.Cm_ref = Moments_ref(2) / (Qbar * Sref * mac);
ACs.Cn_ref = Moments_ref(3) / (Qbar * Sref * span);

%% Compile Outputs:
%	ACs= -1;

end % << End of function ForcesMoments2AeroCoeffs >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101021 JPG: Copied over information from the old function.
% 101021 CNF: Function template created using CreateNewFunc
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
