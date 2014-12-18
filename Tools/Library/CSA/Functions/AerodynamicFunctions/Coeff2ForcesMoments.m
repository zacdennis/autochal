%COEFF2FORCESMOMENTS  Computes Aerodynamic Forces and Moments from Aerodynamic Coefficients and Reference Distances
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Coeff2ForcesMoments:
% Computes the Aero Forces and Moments based on the force coefficients (CX, 
% CY, CZ) and moment coefficients (Cl, Cm, Cn) at the AeroRef.  For moments,
% this function first computes the moment coefficients at the CG before computing
% the moments.
% 
% SYNTAX:
% 	[Faero, Maero] = Coeff2ForcesMoments(Qbar, PQRbody, Vtrue, ...
%       CX, CY, CZ, Clp, Cmq, Cnr, Cl_cg, Cm_cg, Cn_cg, Sref, mac, span)
%
% INPUTS: 
%	Name    Size	Units                   Description
%   Qbar    [1]     [mass/(length*sec2)]    Dynamic Pressure
%   PQRbody [3]     [rad/s]                 Rotational velocity in 
%                                             Aircraft Body Frame
%   Vtrue   [1]     [length/sec]            True Velocity
%   CX      [1]     [ND]                    Coefficient of X-force 
%                                             in Aircraft Body Frame
%   CY      [1]     [ND]                    Coefficient of Y-force (Sideforce)
%                                             in Aircraft Body Frame
%   CZ      [1]     [ND]                    Coefficient of Z-force in 
%                                             Aircraft Body Frame
%   Clp     [1]     [ND]                    Dynamic Derivative Coefficient
%                                             of Rolling Moment with due
%                                             to Roll Rate in Aircraft
%                                             Body Frame
%   Cmq     [1]     [ND]                    Dynamic Derivative Coefficient
%                                             of Pitching Moment with due
%                                             to Pitch Rate in Aircraft
%                                             Body Frame
%   Cnr     [1]     [ND]                    Dynamic Derivative Coefficient
%                                             of Yawing Moment with due
%                                             to Yaw Rate in Aircraft
%                                             Body Frame
%   Cl_cg   [1]     [ND]                    Coefficient of Rolling Moment 
%                                             in Aircraft Body Frame at
%                                             Center of Gravity
%   Cm_cg   [1]     [ND]                    Coefficient of Pitching Moment 
%                                             in Aircraft Body Frame at
%                                             Center of Gravity
%   Cn_cg   [1]     [ND]                    Coefficient of Yawing Moment 
%                                             in Aircraft Body Frame at
%                                             Center of Gravity
%   Sref    [1]     [area]                  Vehicle Reference Area
%   mac     [1]     [length]                Vehicle Reference Chord
%   span    [1]     [length]                Vehicle Reference Span 
%
% OUTPUTS: 
% 	Name    Size	Units                   Description
%   Faero   [3]     [force]                 Forces due to Aerodynamic Coefficients
%                                             in Aircraft Body Frame
%   Maero   [3]     [force*length]          Moments due to Aerodynamic Coefficients
%                                             in Aircraft Body Frame
%
% NOTES:
%   This function is NOT unit specific.  Distances only need to be uniform
%   and should be in standard English [ft] or Metric [m].
%
% EXAMPLES:
%	Example 1:Find the aero forces and moments with the information give
%   Qbar=10; PQRbody=[10 20 30]; Vtrue= 100; CX=1; CY=2; CZ=3; Clp=5;
%   Cmq=4; Cnr=0.5; Cl_cg=2; Cm_cg=3; Cn_cg=10; Sref=100; mac=5; span=50;
% 	[Faero, Maero] = Coeff2ForcesMoments(Qbar, PQRbody, Vtrue, CX, CY, ...
%   CZ, Clp, Cmq, Cnr, Cl_cg, Cm_cg, Cn_cg, Sref, mac, span)
%	Results: Faero = [1000 2000 3000]
%            Maero = [1.001 0.1500 5.000]* e^+005
%
% SOURCE DOCUMENTATION:
%
% [1]   Stevens, Brian L. Lewis, Frank L.Aircraft Control and Simulation. Hooboken , NJ. John and Wiley
%       2003. Eqn 2.3, pg 75
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Coeff2ForcesMoments.m">Coeff2ForcesMoments.m</a>
%	  Driver script: <a href="matlab:edit Driver_Coeff2ForcesMoments.m">Driver_Coeff2ForcesMoments.m</a>
%	  Documentation: <a href="matlab:pptOpen('Coeff2ForcesMoments_Function_Documentation.pptx');">Coeff2ForcesMoments_Function_Documentation.pptx</a>
%
%  See also CLCD2CXCZ, BodyAxisMomentTransfer, ForcesMoments2AeroCoeffs 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/297
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AerodynamicFunctions/Coeff2ForcesMoments.m $
% $Rev: 1714 $
% $Date: 2011-05-11 15:23:59 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Faero, Maero] = Coeff2ForcesMoments(Qbar, PQRbody, Vtrue, CX, CY, CZ, Clp, Cmq, Cnr, Cl_cg, Cm_cg, Cn_cg, Sref, mac, span)

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

%% Input Check:
if nargin<15
    errstr = [mfnam tab 'ERROR: Missing input, please input a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

if (isempty(CX) || isempty(CY) || isempty(CZ) || isempty(Clp) || isempty(Cmq) || isempty(Cnr) || isempty(Cl_cg))
    errstr = [mfnam tab 'ERROR: One Input is empty, please input a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

if (ischar([Qbar Vtrue CX CY CZ Clp Cmq Cnr Cl_cg Cm_cg Cn_cg Sref]))|| ischar(PQRbody)
    errstr = [mfnam tab 'ERROR: Input  of type string or CHAR, Please insert a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

%% Main Function:
Faero = [CX CY CZ] * Qbar * Sref;


Maero(1) = Cl_cg * Qbar * span * Sref + Clp * (PQRbody(1) * span) / (2 * Vtrue);
Maero(2) = Cm_cg * Qbar * mac * Sref + Cmq * (PQRbody(2) * mac) / (2 * Vtrue);
Maero(3) = Cn_cg * Qbar * span * Sref + Cnr * (PQRbody(3) * span) / (2 * Vtrue);


end 

% % REVISION HISTORY
% YYMMDD INI: note
% 101206  JJ: Created example, source documentation, input checks, clean.
% 101021 JPG: Copied over information from the old function.
% 101021 CNF: Function template created using CreateNewFunc
% **Add New Revision notes to TOP of list**
% 
% Initials Identification: 
% INI: FullName             :  Email                            :  NGGN Username 
%  JJ: Jovany Jimenez       : jovany.jimenez-deparias@ngc.com   : g67086
% JPG: James Patrick Gray   :  james.gray2@ngc.com              :  g61720

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
