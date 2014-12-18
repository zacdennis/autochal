% PROPFORCESMOMENTS propagates forces and moments from a given thrust.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% PropForcesMoments:
%     Block transfers thrust to Forces and Moments about the Center of Gravity
% 
% SYNTAX:
% 	[matForces, matMoments, Forces, Moments] = PropForcesMoments(CG,ThrustPos, ThrustForce, ThrustDir)
% 
% INPUTS: 
% 	Name       	Size	Units               Description
%   CG          [3x1]     [length]          Center of Gravity w.r.t origin
%   ThrustPos   [3xM]   [length]            Location of Thrust w.r.t origin
%   ThrustForce [1xM]   [N] or [lbf]        Magnitude of Thrust
%   ThrustDir   [3xM]   [unit vector]       Thrust Force Direction in unit
%                                           vector form
% 
% OUTPUTS: 
% 	Name       	Size	Units               Description
%   matForces   [3xM]   [N] or [lbf]        Resultant forces from
%                                            individual thrust locations
%   matMoments  [3xM]   [N-m] or [lbf-ft]   Resultant moment from
%                                           individual thrust locations
%   Forces      [3]     [N] or [lbf]        Net Force in the body axis
%   Moments     [3]     [N-m] or [lbf]      Net Moment w.r.t body axis
% 
% NOTES:
% The positions of the CG and thrust must be from the aircrafts origin. 
% Thrust position (ThurstPos) must be entered in column format for every M
% propulsion devices. M is the number of propulsion devices being
% considered. The units of the inputs must be consistent, for example, if
% metric units are used to describe the CG position, the thrust force must be
% specified in Newtons.
%
% EXAMPLES:
%	Example 1: Find the net force and net moment in the body axis with the
%	following information using one propulsion device. Use metric units.
% 	CG=[10 0 -3]; ThrustPos=[30; 0; 5]; ThrustForce= 70*10^3;
% 	ThrustDir=[0.1952;    0.9759;    0.0976]
%  [matForces, matMoments, Forces, Moments] = PropForcesMoments(CG, ThrustPos, ThrustForce, ThrustDir)
%   Results : Forces =[13664 68313 6832];
%             Moments =[ -546504 -27328 1366260];
%
%	Example 2: An airplane with two engines, one in each wing, has an
%	engine with a net thrust of 45,000lbf each. Find the moments and forces
%	in the body axis.
%   CG=[100 0 15]; ThrustPos=[100 100; 30 -30; 5 5]; ThrustForce=[45000];
%   ThrustDir=[0.1952 0.1952; 0.9759 0.9759; 0.0976 0.0976];
% 	[matForces, matMoments, Forces, Moments] = PropForcesMoments(CG, ThrustPos, ThrustForce, ThrustDir)
%	Results : Forces =[17568    87831      8784];
%             Moments =[ 878310  -175680     0];
%
% SOURCE DOCUMENTATION:
% [1]   Pytel, Andrew, and Kiusalaas, Jaan. Engineering Mechanics Statics. Pacific Grove, CA: Brooks/Cole, 1999
%       Equation 2.4, pg #45
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit PropForcesMoments.m">PropForcesMoments.m</a>
%	  Driver script: <a href="matlab:edit Driver_PropForcesMoments.m">Driver_PropForcesMoments.m</a>
%	  Documentation: <a href="matlab:pptOpen('PropForcesMoments_Function_Documentation.pptx');">PropForcesMoments_Function_Documentation.pptx</a>
%
% See also AeroCoeffs2ForcesMoments 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/395
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/PropForcesMoments.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [matForces, matMoments, Forces, Moments] = PropForcesMoments(CG, ThrustPos, ThrustForce, ThrustDir)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

%% Input check
if nargin < 4
    error([mfnam ':InputArgCheck'], ['Not enough inputs!  See ' mlink ' documentation for help.']);
end
if ischar(CG)||ischar(ThrustPos)||ischar(ThrustForce)
    error([mfnam ':InputArgCheck'], ['Inputs must be numeric!  See ' mlink ' documentation for help.']);
end

%% Main Function:
numThrust = size(ThrustDir, 2);

MomentArm(1,:) = ThrustPos(1,:) - CG(1);
MomentArm(2,:) = ThrustPos(2,:) - CG(2);
MomentArm(3,:) = ThrustPos(3,:) - CG(3);

if(length(ThrustForce) == 1)
    ThrustForce = ones(1,numThrust)*ThrustForce;
end

matThrustForce = ones(3,1) * ThrustForce;

matForces = matThrustForce .* ThrustDir;

Forces(1) = sum(matForces(1,:));
Forces(2) = sum(matForces(2,:));
Forces(3) = sum(matForces(3,:));

matMoments = cross(MomentArm, matForces);

Moments(1) = sum(matMoments(1,:));
Moments(2) = sum(matMoments(2,:));
Moments(3) = sum(matMoments(3,:));



end 

%% REVISION HISTORY
% YYMMDD INI: note
% 101115 JJD: Filled in description. Created examples. Added source
% documentation. Added input checks. Added notes section.
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                         :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com           :  g61720
% JJD: Jovany JImenez       :jovany.jimenez-deparias@ngc.com : g67086

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
