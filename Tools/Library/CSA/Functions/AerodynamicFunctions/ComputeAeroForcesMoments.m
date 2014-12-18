% COMPUTEAEROFORCESMOMENTS Computes Aerodynamic Forces and Moments from Aerodynamic Coefficients and Reference Distances
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ComputeAeroForcesMoments:
% Computes the Aero Forces and Moments based on the force coefficients (CX, 
% CY, CZ) and moment coefficients (Cl, Cm, Cn) at the AeroRef.  For 
% moments, this function first computes the moment coefficients at the CG 
% before computing the moments.
% 
% SYNTAX:
%   [Clcg, Cmcg, Cncg, Faero, Maero] = ComputeAeroForcesMoments(... 
%       CX, CY, CZ, Clb, Cmb, Cnb, Qbar, CG, AeroRef, span, Sref, mac)
%
% INPUTS: 
%	Name        Size	Units                   Description
%   Qbar        [1]     [mass/(length*sec2)]    Dynamic Pressure
%   PQRbody     [3]     [rad/s]                 Rotational velocity in 
%                                               Aircraft Body Frame
%   Vtrue       [1]     [length/sec]            True Velocity
%   CX          [1]     [ND]                    Coefficient of X-force 
%                                               in Aircraft Body Frame
%   CY          [1]     [ND]                    Coefficient of Y-force (Sideforce)
%                                               in Aircraft Body Frame
%   CZ          [1]     [ND]                    Coefficient of Z-force in 
%                                               Aircraft Body Frame
%   Clb         [1xN]   [unitless]              Rolling Moment Coefficient at AeroRef
%   Cmb         [1xN]   [unitless]              Pitching Moment Coefficient at AeroRef
%   Cnb         [1xN]   [unitless]              Yawing Moment Coefficient at AeroRef
%   Qbar        [1]     [Pa] or [lbf/ft^2]      Dynamic Pressure
%   CG          [3]     [m] or [ft]             Center of Gravity
%   AeroRef     [3]     [m] or [ft]             Aerodynamic Reference
%   span        [1]     [m] or [ft]             Reference wingspan, b
%   Sref        [1]     [m^2] or [ft^2]         Reference wing area
%   mac         [1]     [m] or [ft]             Reference mean aerodynamic chord
%  
% OUTPUTS: 
%  	Name        Size	Units                   Description
%   Clcg        [1xN]   [unitless]              Rolling Moment Coefficient at CG
%   Cmcg        [1xN]   [unitless]              Pitching Moment Coefficient at CG
%   Cncg        [1xN]   [unitless]              Yawing Moment Coefficient at CG
%   AeroForces  [3xN]   [N] or [lbf]            Aero Forces at CG
%   AeroMoments [3xN]   [N-m] or [lbf-ft]       Aero Moments at CG
%
% NOTES:
%   This function is NOT unit specific.  Distances only need to be uniform
%   and should be in standard English [ft] or Metric [m].
%
% EXAMPLES:
%	Example 1:Find the aero forces and moments with the information give
%   Qbar=10; PQRbody=[10 20 30]; Vtrue= 100; CX=1; CY=2; CZ=3; Clb=5;
%   Cmb=4; Cnb=0.5; CG=[2 3 4]; Sref=100; mac=5; AeroRef=[10 15 20];
% 	[Clcg, Cmcg, Cncg, Faero, Maero] = ComputeAeroForcesMoments(CX, CY, ...
%   CZ,Clb, Cmb, Cnb, Qbar, CG, AeroRef, span, Sref, mac)
%	Results: Faero = [1000 2000 3000]
%            Maero = [1.001 0.1500 5.000]* e^+005
%
% SOURCE DOCUMENTATION:
% Book with One Author:
% [1]   Stevens, Brian L. Lewis, Frank L.Aircraft Control and Simulation. Hooboken , NJ. John and Wiley
%       2003. Eqn 2.3, pg 75
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ComputeAeroForcesMoments.m">ComputeAeroForcesMoments.m</a>
%	  Driver script: <a href="matlab:edit Driver_ComputeAeroForcesMoments.m">Driver_ComputeAeroForcesMoments.m</a>
%	  Documentation: <a href="matlab:pptOpen('ComputeAeroForcesMoments_Function_Documentation.pptx');">ComputeAeroForcesMoments_Function_Documentation.pptx</a>
%
%  See also CLCD2CXCZ, BodyAxisMomentTransfer, ForcesMoments2AeroCoeffs 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/617
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://vodka.ccc.northgrum.com/svn/CSA/trunk/CSA/Functions/AerodynamicFunctions/ComputeAeroForcesMoments.m $
% $Rev: 1230 $
% $Date: 2010-11-29 08:09:30 -0800 (Mon, 29 Nov 2010) $
% $Author: sufanmi $

function [Clcg, Cmcg, Cncg, Faero, Maero] = ComputeAeroForcesMoments(CX, CY, CZ, Clb, Cmb, Cnb, Qbar, CG, AeroRef, span, Sref, mac)

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
if nargin<12
    errstr = [mfnam tab 'ERROR: Missing input, please input a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

if (isempty(CX) || isempty(CY) || isempty(CZ) )
    errstr = [mfnam tab 'ERROR: One Input is empty, please input a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

if (ischar([Qbar CX CY CZ Sref Clb Cmb Cnb span Sref mac]))
    errstr = [mfnam tab 'ERROR: Input  of type string or CHAR, Please insert a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

%% Main Function:
Faero = [CX CY CZ] .* Qbar .* Sref;

CG_distance=AeroRef-CG;

Moment=cross(CG_distance,[CX CY CZ]);

Clcg=Moment(1)/span+Clb;
Cmcg=Moment(2)/mac+Cmb;
Cncg=Moment(3)/span+Cnb;

Mx=Clcg.*span*Qbar.*Sref;
My=Cmcg.*mac*Qbar.*Sref;
Mz=Cncg.*span*Qbar.*Sref;

Maero=[Mx My Mz];
end 

% % REVISION HISTORY
% YYMMDD INI: note
% 110711 JPG: Fixed syntax information in the function help.
% 101206  JJ: Created example, source documentation, input checks, clean.
% 101021  JJ: Created Function to match the ComputeAeroForcesMoments
%             simulink block
% 101021 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                            :  NGGN Username 
%  JJ: Jovany Jimenez       :  jovany.jimenez-deparias@ngc.com  :  g67086
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
