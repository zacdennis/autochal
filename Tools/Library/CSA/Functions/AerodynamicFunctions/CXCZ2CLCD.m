% CXCZ2CLCD Converts Body Axis Aerodynamic Coefficients (CX and CZ) to Lift and Drag Coefficients (CL and CD)
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CXCZ2CLCD:
%   Converts Body Axis Aerodynamic Coefficients (CX and CZ) to Lift and 
%   Drag Coefficients (CL and CD)
% 
% SYNTAX:
%	[CL, CD] = CXCZ2CLCD(CX, CZ, Alpha_deg)
%	
%
% INPUTS: 
%	Name		Size            Units                Description
%	CX  		[variable]		[unitless]           Coefficient of X-force in Aircraft Body Frame 
%   CZ          [variable]		[unitless]           Coefficient of Z-force in Aircraft Body Frame
%	Alpha_deg	[variable]		 [degrees]           Angle of attack
%										
%
% OUTPUTS: 
%	Name		Size            Units               Description
%	CL  		[variable]		[unitless]          Coefficient of Lift
%	CD  		[variable]		[unitless]          Coefficient of Drag 
%
%  NOTES:
%   CX and CZ should have the same dimensions, which can be singular (e.g.
%   [1]), a vector ([1xN] or [Nx1]), or a multi-dimentional matrix (M x N x
%   P x ...]
%   Alpha_deg should be either singular or the same dimensions as CX and CZ
%   Alpha_deg can be of any real value and will be wrapped accordingly by Matlab's
%   cosd and sind functions
%
%  MAIN EQUATIONS:
%   CL =  CX*sind(Alpha_deg) - CZ*cosd(Alpha_deg)
%   CD = -CX*cosd(Alpha_deg) - CZ*sind(Alpha_deg)
%
% EXAMPLES:
%   Example 1: Singular Inputs
%   CX = 1; CZ = 2; Alpha_deg = 45;
%   [CL, CD] = CXCZ2CLCD(CX, CZ, Alpha_deg)
%   returns CL = -0.7071, CD = -2.1213
%
%   Example 2: Vectorized Inputs
%   CX = [1 1]; CZ = [2 2]; Alpha_deg = 45;
%	[CL, CD] = CXCZ2CLCD(CX, CZ, Alpha_deg)
%   returns CL = [ -0.7071    -0.7071 ]       CD = [ -2.1213   -2.1213 ]
%   Note, if CX & CZ were column vectors, CL & CD would be returned as such
%
%   Example 3: Matrix Inputs
%   CX = [1 2; 3 4]; CZ = [5 6; 7 8]; Alpha_deg = 30;
%   [CL, CD] = CXCZ2CLCD(CX, CZ, Alpha_deg)
%   returns  CL = [ -3.8301   -4.1962;       CD =  [   -3.3660   -4.7321;
%                   -4.5622   -4.9282 ]               -6.0981   -7.4641 ]
%
%   Example 4: Show math works properly for Alpha_deg = 0 and +/-90
%              Note that usage case is NOT recommended for real code
%   CX = 1; CZ = 2; Alpha_deg = [0 90 -90];
%    [CL, CD] = CXCZ2CLCD(CX, CZ, Alpha_deg)
%   returns CL = [ -2     1    -1 ]          CD =  [ -1    -2     2 ]
%
% SOURCE DOCUMENTATION:
%	[1]    Juri Kalviste.  Flight Dynamics Reference Handbook, Northrop 
%           Grumman Corporation, rev.06-30-89, 1988, pg. 22. 
%           \\vsishare1\VSI\Library\Juri Kalviste documents\FLIGHT DYNAMICS REF.pdf
%
% HYPERLINKS:
%     Source function: <a href="matlab:edit CXCZ2CLCD.m">CXCZ2CLCD.m</a>
%       Driver script: <a href="matlab:edit Driver_CXCZ2CLCD.m">Driver_CXCZ2CLCD.m</a>
%       Documentation: <a href="matlab:pptOpen('CXCZ2CLCD_Function_Documentation.pptx');">CXCZ2CLCD_Function_Documentation.pptx</a>
% Flight Dynamics Ref: <a href="\\vsishare1\VSI\Library\Juri Kalviste documents\FLIGHT DYNAMICS REF.pdf">Flight Dynamics Ref</a>
% 
% See also CLCD2CXCZ, CNCA2CLCD, CLCD2CNCA
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/305
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AerodynamicFunctions/CXCZ2CLCD.m $
% $Rev: 3029 $
% $Date: 2013-10-16 15:55:38 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [CL,CD] = CXCZ2CLCD(CX,CZ,Alpha_deg)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Input checks:
if nargin<3
    errstr = [mfnam tab 'ERROR: Missing input for CL, CD, or Alpha_deg, please input a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

if (isempty(CX)|| isempty(CZ)||isempty(Alpha_deg))
    errstr = [mfnam tab 'ERROR: One Input in Alpha_deg, CL or CD is empty, please input a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

if (ischar(CX)||ischar(CZ) || ischar(Alpha_deg))
    errstr = [mfnam tab 'ERROR: Input  of type string or CHAR, Please insert a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

%% Main Function:
CL = CX.*sind(Alpha_deg) - CZ.*cosd(Alpha_deg);
CD = -CX.*cosd(Alpha_deg) - CZ.*sind(Alpha_deg);

end % << End of function CXCZ2CLCD >>

%% REVISION HISTORY
% YYMMDD INI:jj
% 100818 JJ: Added vector and matrix capabilities. Updated examples.
% 100817 JJ: Function template created using CreateNewFunc and filled out 

%% Initials Identification: 
% INI: FullName  :     Email  :                         NGGN Username 
% jj: jovany jimenez : jovany.jimenez-deparias@ngc.com : g67086  

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
