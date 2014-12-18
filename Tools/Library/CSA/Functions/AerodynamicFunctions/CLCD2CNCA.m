% CLCD2CNCA Converts Lift and Drag coefficients to Normal and Axial coefficients
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CLCD2CNCA:
%  Converts Aerodynamic Lift and Drag Coefficients (CL and CD) to 
%  Normal and Axial Coefficients (CN and CA) 
% 
% SYNTAX:
%	[CN, CA] = CLCD2CNCA(CL, CD, Alpha_deg)
%
% INPUTS: 
%	Name		Size            Units           Description
%	CL  		[variable]		[unitless]		Coefficient of Lift
%	CD  		[variable]      [unitless]		Coefficient of Drag
%	Alpha_deg	[variable]		[deg]           Angle of attack
%									
%
% OUTPUTS: 
%	Name		Size            Units           Description
%	CN  		[variable]      [unitless]      Coefficient of Normal Force 
%   CA          [variable]      [unitless]      Coefficient of Axial Force
%
% NOTES:
%   CL and CD should have the same dimensions, which can be singular (e.g.
%   [1]), a vector ([1xN] or [Nx1]), or a multi-dimentional matrix (M x N x
%   P x ...]
%   Alpha_deg should be either singular or the same dimensions as CL and CD
%   Alpha_deg can be of any real value and will be wrapped accordingly by Matlab's
%   cosd and sind functions
%
%   Main Equations:
%   CN = CL.*cosd(Alpha_deg) + CD.*sind(Alpha_deg)
%   CA = CD.*cosd(Alpha_deg) - CL.*sind(Alpha_deg)
%
% EXAMPLES:
%   Example 1: Singular Inputs
%   CL = 1; CD = 2; Alpha_deg = 45;
%   [CN, CA] = CLCD2CNCA(CL, CD, Alpha_deg)
%   returns CN = 2.1213, CA = 0.7071
%
%   Example 2: Vectorized Inputs
%   CL = [1 1]; CD = [2 2]; Alpha_deg = 45;
%	[CN, CA] = CLCD2CNCA(CL, CD, Alpha_deg)
%   returns CN = [ 2.1213    2.1213 ]       CA = [ 0.7071    0.7071 ]
%   Note, if CL & CD were column vectors, CN & CA would be returned as such
%
%   Example 3: Matrix Inputs
%   CL = [1 2; 3 4]; CD = [5 6; 7 8]; Alpha_deg = 30;
%   [CN, CA] = CLCD2CNCA(CL, CD, Alpha_deg)
%   returns  CN = [ 3.3660    4.7321;       CA =  [  3.8301    4.1962;
%                   6.0981    7.4641 ]               4.5622    4.9282 ]
%
%   Example 4: Show math works properly for Alpha_deg = 0 and +/-90
%              Note that usage case is NOT recommended for real code
%   CL = 1; CD = 2; Alpha_deg = [0 90 -90];
%    [CN, CA] = CLCD2CNCA(CL, CD, Alpha_deg)
%   returns CN = [ 1     2    -2 ]          CA =  [ 2    -1     1 ]
%
% SOURCE DOCUMENTATION:
%	[1]    Juri Kalviste.  Flight Dynamics Reference Handbook, Northrop 
%           Grumman Corporation, rev.06-30-89, 1988, pg. 22. 
%           'https://svn.ngst.northgrum.com/repos/CSA/trunk/Documentation/FLIGHT DYNAMICS REF.pdf'
%
% HYPERLINKS:
%	 Source function: <a href="matlab:edit CLCD2CNCA.m">CLCD2CNCA.m</a>
%      Driver script: <a href="matlab:edit Driver_CLCD2CNCA.m">Driver_CLCD2CNCA.m</a>
%      Documentation: <a href="matlab:winopen(which('CLCD2CNCA_Function_Documentation.pptx'));">CLCD2CNCA_Function_Documentation.pptx</a>
%Flight Dynamics Ref: <a href="https://svn.ngst.northgrum.com/repos/CSA/trunk/Documentation/FLIGHT DYNAMICS REF.pdf">Flight Dynamics Ref</a>
%
% See also CNCA2CLCD, CXCZ2CLCD, CLCD2CXCZ
%
%
% VERIFICATION DETAILS:
% Verified: Yes, via Peer Review
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/300
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AerodynamicFunctions/CLCD2CNCA.m $
% $Rev: 3238 $
% $Date: 2014-08-18 19:06:13 -0500 (Mon, 18 Aug 2014) $
% $Author: sufanmi $

function [CN,CA] = CLCD2CNCA(CL,CD,Alpha_deg)

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

%% Input Check:
if nargin<3
    errstr = [mfnam tab 'ERROR: Missing input for CL, CD, or Alpha_deg, please input a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

if (isempty(CL) || isempty(CD) || isempty(Alpha_deg))
    errstr = [mfnam tab 'ERROR: One Input in Alpha_deg, CL or CD is empty, please input a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

if (ischar(CL)||ischar(CD) || ischar(Alpha_deg))
    errstr = [mfnam tab 'ERROR: Input  of type string or CHAR, Please insert a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

%% Main Function:
CN = CL.*cosd(Alpha_deg) + CD.*sind(Alpha_deg);
CA = CD.*cosd(Alpha_deg) - CL.*sind(Alpha_deg);

end

%% DISTRIBUTION:
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C., Sec 2751,
%   et seq.) or the Export Administration Act of 1979 (Title 50, U.S.C.,
%   App. 2401 et set.), as amended. Violations of these export laws are
%   subject to severe criminal penalties.  Disseminate in accordance with
%   provisions of DoD Direction 5230.25.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------