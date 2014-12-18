% GAMMACHIVTRUE2VNED Computes North/East/Down Velocity from Gamma & Chi
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GammaChiVtrue2Vned:
%     Computes North/East/Down Velocity from Gamma & Chi
% 
% SYNTAX:
%	[Vned] = GammaChiVtrue2Vned(Gamma, Chi, Vtrue)
%
% INPUTS: 
%	Name		Size            Units           Description
%   Gamma       [1xN] or [Nx1]  [deg]           Flight Path Elevation Angle
%   Chi         [1xN] or [Nx1]  [deg]           Flight Path Heading Angle
%   Vtrue       [1xN] or [Nx1]  [length/time]   True velocity
%                                            
% OUTPUTS: 
%	Name		Size            Units           Description
%    Vned       [Nx3] or [3xN]  [length/time]   Velocity in North/East/Down Frame
%
% NOTES:
%	Input 'Vtrue' is NOT unit specific.  Output 'Vned' will carry the same 
%   units as 'Vtrue'.  Standard METRIC or ENGLISH units should be used.
%
%   This function assumes Gamma is between +/- 90 deg, while Chi is 
%   between +/- 180 deg. Out of bound inputs will be wrapped to generate a valid
%   Vned, but if trying to recover the input flight path angles from Vned and the 
%   reciprocal function, Vned2GammaChiVtrue, the retrieved flight path angles will be 
%   limited to +/- 90 deg for Gamma and +/- 180 deg for Chi
%
% EXAMPLES:
%	Example 1: Compute Vned from Gamma, Chi, and Vtrue using
%	'GammaChiVtrue2Vned'.  Then should that Gamma, Chi, and Vtrue can be
%	recovered by using 'Vned2GammaChiVtrue'
%
%   Gamma = 3; Chi = 30; Vtrue = 400; 
% 	[Vned] = GammaChiVtrue2Vned(Gamma, Chi, Vtrue)
%   [Gamma2, Chi2, Vtrue2] = Vned2GammaChiVtrue(Vned)
%   dGamma = Gamma - Gamma2
%   dChi = Chi - Chi2
%   dVtrue = Vtrue - Vtrue2
%   
%	Returns Vned = [345.9354  199.7259  -20.9344]
%           dGamma = dChi = dVtrue = ~0 (pending numerical inaccuracy)
%
%	Example 2: Compute Vned using row arrays of Gammas, Chis, and Vtrues
%   Gamma = [-3 0 3]; Chi = [0 0 90]; Vtrue = [100 200 300];
% 	[Vned] = GammaChiVtrue2Vned(Gamma, Chi, Vtrue)
%	Returns Vned = [ 99.8630         0    5.2336; <-- Vned is in row format
%                   200.0000         0         0;
%                          0  299.5889  -15.7008 ]
%
%	Example 3: Compute Vned using column arrays of Gammas, Chis, and Vtrues
%   Gamma = [-3; 0; 3]; Chi = [0; 0; 90]; Vtrue = [100; 200; 300];
% 	[Vned] = GammaChiVtrue2Vned(Gamma, Chi, Vtrue)
%	Returns Vned = [ 99.8630  200.0000         0;
%                          0         0  299.5889;
%                     5.2336         0  -15.7008 ]
%                       * ^ * Note that Vned is in column format  
%
% SOURCE DOCUMENTATION:
%	[1]    Stevens, Brian L and Lewis, Frank L. Aircraft Control and Simulation. John Wiley
%	and Sons, Hoboken, NJ, Copyright 2003. Pg.140
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit GammaChiVtrue2Vned.m">GammaChiVtrue2Vned.m</a>
%	  Driver script: <a href="matlab:edit Driver_GammaChiVtrue2Vned.m">Driver_GammaChiVtrue2Vned.m</a>
%	  Documentation: <a href="matlab:pptOpen('GammaChiVtrue2Vned_Function_Documentation.pptx');">GammaChiVtrue2Vned_Function_Documentation.pptx</a>
%
% See also Vned2GammaChiVtrue
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/343
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/GammaChiVtrue2Vned.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Vned] = GammaChiVtrue2Vned(Gamma, Chi, Vtrue)

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
% error([mfnam 'class:file:Identifier'], errstr);    % Call error function
% with error string

%% Input check
if nargin < 3
    error([mfnam ':InputArgCheck'], ['Not enough inputs!  See ' mlink ' documentation for help.']);
end
if ischar(Gamma)||ischar(Chi)||ischar(Vtrue)
    error([mfnam ':InputArgCheck'], ['Inputs must be numeric!  See ' mlink ' documentation for help.']);
end

%% Main Function:
Vn =  Vtrue .* cosd(Gamma) .* cosd(Chi);    % [length/time]
Ve =  Vtrue .* cosd(Gamma) .* sind(Chi);    % [length/time]
Vd = -Vtrue .* sind(Gamma);                 % [length/time]

[nRow, nCol] = size(Vn);

if(nRow > nCol)
    Vned = [Vn Ve Vd]';                      % [length/time]
else
    Vned = [Vn; Ve; Vd]';                    % [length/time];
end

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100909 JJ:  Filled the documentation source.
% 100819 JJ:  Function template created using CreateNewFunc
% 080114 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDI
%             NATE_TRANSFORMATIONS/GammaChiVtrue2Vned.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN Username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : g67086
% MWS: Mike Sufana      : mike.sufana@ngc.com               : sufanmi

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
