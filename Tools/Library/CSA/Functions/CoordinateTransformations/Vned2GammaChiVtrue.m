% VNED2GAMMACHIVTRUE Converts North/East/Down Velocity into Gamma & Chi
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Vned2GammaChiVtrue:
%     Converts North/East/Down Velocity into Gamma & Chi
% 
% SYNTAX:
%	[Gamma, Chi, Vtrue] = Vned2GammaChiVtrue(Vned)
%
% INPUTS: 
%	Name		Size            Units           Description
%	Vned		[Nx3] or [3xN]  [length/time]   Velocity in North/East/Down Frame
%
% OUTPUTS: 
%	Name		Size            Units           Description
%   Gamma       [1xN] or [Nx1]  [deg]           Flight Path Elevation Angle
%   Chi         [1xN] or [Nx1]  [deg]           Flight Path Heading Angle
%   Vtrue       [1xN] or [Nx1]  [length/time]   Velocity Magnitude
%
% NOTES:
%	Input 'Vned' is NOT unit specific.  Output 'Vtrue' will carry the same 
%   units as 'Vned'.  Standard METRIC or ENGLISH units should be used.
%   
%   If the size of Vned is enterred as a [3x3], a row vector input
%   format is assumed.  That is, the first Vned vector is Vned(1,:).
%
%   The function will wrap Gamma between +/- 90 deg, and Chi between +/- 180
%   deg
%
% EXAMPLES:
%	Example 1: Compute Gamma, Chi, and Vtrue from a Vned vector using
%               'Vned2GammaChiVtrue'.  Then show that Vned can be recovered
%               by using 'GammaChiVtrue2Vned'.
%
%   Vned=[345.9354  199.7259  -20.9344]
% 	[Gamma, Chi, Vtrue] = Vned2GammaChiVtrue(Vned)
%   Vned2 = GammaChiVtrue2Vned(Gamma, Chi, Vtrue)
%   dVned = Vned - Vned2
%
%   Returns Gamma =  3.0000, Chi =  30.0000, and Vtrue = 400.0000
%           dVned = ~zero (pending numerical inaccuracy)
%
%	Example 2: Compute Gamma, Chi and Vtrue from row vectors of Vned
% 	Vned = [ 99.8630         0    5.2336; % <-- Vned is in row format
%           200.0000         0         0;
%                  0  299.5889  -15.7008 ]
% 	[Gamma,Chi,Vtrue] = Vned2GammaChiVtrue(Vned)
%   Returns Gamma = [  -3.0000         0     3.000 ]'
%             Chi = [        0         0        90 ]'
%           Vtrue = [ 100.0000  200.0000  300.0000 ]'
%
% SOURCE DOCUMENTATION:
%	[1]    Stevens, Brian L and Lewis, Frank L. Aircraft Control and Simulation. John Wiley
%	and Sons, Hoboken, NJ, Copyright 2003. Pg. 140
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Vned2GammaChiVtrue.m">Vned2GammaChiVtrue.m</a>
%	  Driver script: <a href="matlab:edit Driver_Vned2GammaChiVtrue.m">Driver_Vned2GammaChiVtrue.m</a>
%	  Documentation: <a href="matlab:pptOpen('Vned2GammaChiVtrue_Function_Documentation.pptx');">Vned2GammaChiVtrue_Function_Documentation.pptx</a>
%
% See also GammaChiVtrue2Vned
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/367
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/Vned2GammaChiVtrue.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Gamma, Chi, Vtrue] = Vned2GammaChiVtrue(Vned)

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
if ischar(Vned)
     error([mfnam ':InputArgCheck'], ['Input of type string or CHAR. Must be expressed in scalar form.  See ' ...
         mlink ' documentation for help.']);
end

%% Main Function:
R2D = 180.0/acos(-1);

[nRow, nCol] = size(Vned);
if(nCol == 3)
    % Row Vector Input
    % Assume Inputs are [N x 3]
    % Make Outputs [N x 1]
    Vn = Vned(:, 1);                            % [length/time]
    Ve = Vned(:, 2);                            % [length/time]
    Vd = Vned(:, 3);                            % [length/time]    
else
    % Column Vector Input
    % Assume Inputs are [3 x N]
    % Make Outputs [1 x N]
    Vn = Vned(1, :);                            % [length/time]
    Ve = Vned(2, :);                            % [length/time]
    Vd = Vned(3, :);                            % [length/time]
end

Vh = sqrt( Vn.*Vn + Ve.*Ve );                   % [length/time]
Gamma = atan2( -Vd, Vh ) * R2D;                 % [deg]
Chi     = atan2( Ve, Vn ) * R2D;                % [deg]  
Vtrue   = sqrt( Vn.*Vn + Ve.*Ve + Vd.*Vd );     % [length/time]

end 
%% REVISION HISTORY
% YYMMDD INI: note
% 100909 JJ:  Filled the documentation source.
% 100819 JJ:  Function template created using CreateNewFunc
% 080114 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDI
%             NATE_TRANSFORMATIONS/Vned2GammaChiVtrue.m
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
