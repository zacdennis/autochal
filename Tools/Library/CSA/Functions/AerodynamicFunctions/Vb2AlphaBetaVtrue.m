% VB2ALPHABETAVTRUE  Converts Body Velocity into Alpha & Beta
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Vb2AlphaBetaVtrue:
%      Converts Body Velocity into Alpha & Beta
% 
% SYNTAX:
% 	[Alpha,Beta,Vtrue] = Vb2AlphaBetaVtrue(Vb)
% 
% INPUTS: 
% 	Name        Size                 Units           Description
% 	Vb          [1x3] or [3x1]       [length/time]   Velocity in Aircraft Body Frame
% 
% OUTPUTS: 
% 	Name		Size                 Units           Description
%   Alpha       [1x1]                [deg]           Angle of Attack
%   Beta        [1x1]                [deg]           Sideslip Angle
%   Vtrue       [1x1]                [length/time]   True velocity 
% 
% NOTES:
%   This function is NOT unit specific.  Unit specific outputs will be
%   based on the units of the inputs.  Standard METRIC or ENGLISH units
%   should be used.
%
%   The function will wrap Alpha between +/- 180 deg, and Beta between +/-
%   90 deg
%
% EXAMPLES:
%	Example 1: An aircraft is going 10 m/s in the positive x direction, 5
%	m/s downward and 2 m/s to the right wing direction. Calulate alpha,
%	beta and Vtrue
%   Vb=[10 2 5];
% 	[Alpha,Beta,Vtrue] = Vb2AlphaBetaVtrue(Vb)
%	Returns Alpha= 26.5651 Beta= 10.1421 Vtrue=11.3578
%
%	Example 2: An aircraft is going 100 ft/s in the positive x direction, 25
%	ft/s upward and 10 ft/s to the left wing direction. Calulate alpha,
%	beta and Vtrue
%   Vb=[100 -10 -25];
% 	[Alpha,Beta,Vtrue] = Vb2AlphaBetaVtrue(Vb)
%	Returns Alpha= -14.0362 Beta= -5.5412 Vtrue=103.5616
%
% SOURCE DOCUMENTATION:
% 	[1]     Stevens, Brian L and Lewis, Frank L. Aircraft Control and Simulation.
%           John wiley and sons, Hoboken, NJ, Copyright 2003 P.74
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Vb2AlphaBetaVtrue.m">Vb2AlphaBetaVtrue.m</a>
%	  Driver script: <a href="matlab:edit Driver_Vb2AlphaBetaVtrue.m">Driver_Vb2AlphaBetaVtrue.m</a>
%	  Documentation: <a href="matlab:pptOpen('Vb2AlphaBetaVtrue_Function_Documentation.pptx');">Vb2AlphaBetaVtrue_Function_Documentation.pptx</a>
%
% See also AlphaBetaVtrue2Vb
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/307
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AerodynamicFunctions/Vb2AlphaBetaVtrue.m $
% $Rev: 1714 $
% $Date: 2011-05-11 15:23:59 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Alpha,Beta,Vtrue] = Vb2AlphaBetaVtrue(Vb)

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
%% Input check
if size(Vb)==0
    error([mfnam ':InputArgCheck'], 'Velocity in body must be specified. Please enter Vb [1x3]')
end
if ischar(Vb)
     error([mfnam ':InputArgCheck'], 'Input of type string or CHAR. Must be expressed in scalar form.')
end

%% Main Function:
conversions;

Alpha   = atan2( Vb(3), Vb(1) ) * C.R2D;                    % [deg]
Beta    = atan2( Vb(2), sqrt(Vb(1)^2 + Vb(3)^2) ) * C.R2D;  % [deg]
Vtrue   = norm( Vb );                                       % [length/sec]

end 

% % REVISION HISTORY
% YYMMDD INI: note
% 100907 JJ:  Filled the documentation source.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/AERODYNAMIC_FUNCTIONS/Vb2AlphaBetaVtrue.m
%**Add New Revision notes to TOP of list**

% % Initials Identification:
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
