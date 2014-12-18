% ALPHABETAVTRUE2VB Computes Body Velocity from Alpha & Beta
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% AlphaBetaVtrue2Vb:
%     Computes Body Velocity from Alpha & Beta 
% 
% SYNTAX:
% 	[Vb] = AlphaBetaVtrue2Vb(Alpha, Beta, Vtrue)
% 
% INPUTS: 
% 	Name		Size                 Units           Description
%   Alpha       [1xN] or [Nx1]       [deg]           Angle of Attack
%   Beta        [1xN] or [Nx1]       [deg]           Sideslip Angle
%   Vtrue       [1xN] or [Nx1]       [length/time]   True velocity
% 
% OUTPUTS: 
% 	Name		Size                 Units           Description
%   Vb          [3xN] or [Nx3]       [length/time]   Velocity in Aircraft Body Frame 
% 
% NOTES:
% 	This function is NOT unit specific.  Unit specific outputs will be
%   based on the units of the inputs.  Standard METRIC or ENGLISH units
%   should be used.
%
%   This function assumes Alpha is between +/- 180 deg, while Chi is 
%   between +/- 90 deg. Out of bound inputs will be wrapped to generate a valid
%   Vb, but if trying to recover the input aero angles from Vb and the 
%   reciprocal function, Vb2AlphaBetaVtrue, the retrieved aero angles will be 
%   limited to +/- 180 deg for Alpha and +/- 90 deg for Beta
% 
% EXAMPLES:
%	Example 1: Compute Vbody from alpha, beta and Vtrue using
%	'AlphaBetaVtrue'. Then should that alpha, beta and vtrue be recovered
%	using 'Vb2AlphaBetaVtrue'
%   Alpha=10; Beta=25; Vtrue=300;
% 	[Vb] = AlphaBetaVtrue2Vb(Alpha, Beta, Vtrue)
%	Returns Vb =[267.7617  126.7855   47.2136]
%
%   [Alpha2,Beta2,Vtrue2] = Vb2AlphaBetaVtrue(Vb)
%   Alpha - Alpha2 = ~0
%   Beta  - Beta2  = ~0
%   Vtrue - Vtrue2 = ~0
%
%	Example 2 : Compute Vb using row arrays of alpha, beta and Vtrues.
%   Alpha=[10 25 30]; Beta=[5 10 15]; Vtrue=[200 250 300];
% 	[Vb] = AlphaBetaVtrue2Vb(Alpha, Beta, Vtrue)
%	Returns Vb =[ 196.2121  223.1347  250.9549
%                  17.4311   43.4120   77.6457
%                  34.5975  104.0494  144.8889 ]
%
% SOURCE DOCUMENTATION:
% 	[1]     Stevens, Brian L and Lewis, Frank L. Aircraft Control and Simulation.
%           John wiley and sons, Hoboken, NJ, Copyright 2003 P.74
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit AlphaBetaVtrue2Vb.m">AlphaBetaVtrue2Vb.m</a>
%	  Driver script: <a href="matlab:edit Driver_AlphaBetaVtrue2Vb.m">Driver_AlphaBetaVtrue2Vb.m</a>
%	  Documentation: <a href="matlab:pptOpen('AlphaBetaVtrue2Vb_Function_Documentation.pptx');">AlphaBetaVtrue2Vb_Function_Documentation.pptx</a>
%
% See also Vb2AlphaBetaVtrue
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/298
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AerodynamicFunctions/AlphaBetaVtrue2Vb.m $
% $Rev: 1714 $
% $Date: 2011-05-11 15:23:59 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Vb] = AlphaBetaVtrue2Vb(Alpha, Beta, Vtrue)

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

%% Input check
if nargin < 3
    error([mfnam ':InputArgCheck'], ['Not enough inputs!  See ' mlink ' documentation for help.']);
end
if ischar(Alpha)||ischar(Beta)||ischar(Vtrue)
    error([mfnam ':InputArgCheck'], ['Inputs must be numeric!  See ' mlink ' documentation for help.']);
end

%% Main Function:
Vb_x   = Vtrue .* cosd(Beta) .* cosd(Alpha);     
Vb_y   = Vtrue .* sind(Beta);                   
Vb_z   = Vtrue .* cosd(Beta) .* sind(Alpha);     

[nRow, nCol] = size(Vb_x);

if (nRow>nCol)
    Vb=[Vb_x Vb_y Vb_z];
else
    
    Vb=[Vb_x; Vb_y; Vb_z];
end
end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100915 PBH: Making sure output dimensions match input dimensions
%             1xN input results in 3xN output and vice versa
% 100915 JJ:  Added the capability to compute arrays  
% 100907 JJ:  Filled the documentation source.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/AERODYNAMIC_FUNCTIONS/AlphaBetaVtrue2Vb.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN Username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : g67086
% MWS: Mike Sufana      : mike.sufana@ngc.com               : sufanmi
% PBH: patrick Healy    : patrick.healy@ngc.com             : healypa
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
