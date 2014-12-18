% ELLIPSE Plots an ellipse
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ellipse:
%   Plots an rotatable ellipse or elliptical arc with plugs for 
%   additional line formatting
% 
% SYNTAX:
%	[h] = ellipse(xc, yc, a, b, 'PropertyName', PropertyValue)
%	[h] = ellipse(xc, yc, a, b, varargin)
%	[h] = ellipse(xc, yc, a, b)
%	[h] = ellipse(xc, yc, a)
%
% INPUTS: 
%	Name		Size		Units		Description
%	xc  		[1] 		[N/A]		X coordinate of Center of Ellipse
%	yc  		[1]     	[N/A]		Y coordinate of Center of Ellipse
%	a   		[1]         [N/A]       Semi-major axis
%	b   		[1]         [N/A]		Semi-minor axis
%	varargin	[N/A]   	[varies]	Additional plotting properties
%                                        that could be defined by the
%                                        user.  These inputs must be
%                                        a) entered in pairs
%                                        b) supported by the lineseries 
%                                           plot object
%                                        See 'VARARGIN' description below
% OUTPUTS: 
%	Name		Size		Units		Description
%	h   		[1]         [ND]		Line handle 
%
% NOTES:
%
%   VARARGIN PROPERTIES:
%   PropertyName        PropertyValue   Default     Description
%   'StartAngle'        [deg]           0           Start Angle of Ellipse
%   'EndAngle'          [deg]           360         End Angle of Ellipse
%   'AngleStep'         [deg]           0.01        Ellipse Fineness
%   'Rotation'          [deg]           0           Rotation of Ellipse
%                                                    + is counter-clockwise
%   'Color'             'string'        'b'         Line Color
%   'LineWidth'         [double]        1           Line Width
%   'LineStyle'         'string'        '-'         Line Style
%
%	The function ellipse plots the ellipse on the current figure unless
%	otherwise specified.
%
% EXAMPLES:
%   Example 1: Plot a thicker red ellipse with the center at the origin 
%   and with a semi-major axis ('a') of 10 and semi-minor axis ('b') of 5, 
%   rotated by 20 degrees counter clockwise
%
%    figure(1); axis([-15 15 -15 15]); axis equal; grid on; hold on;
%    h(1) = ellipse(0, 0, 10, 5, 'r-', 'Rotation', 20, 'LineWidth', 1.5)
%
%   Example 2: Plot a green and red arc on a figure
%
%    figure(2); axis([-10 10 -10 10]); axis equal; grid on; hold on;
%    h(1) = ellipse(0, 0, 10, 5, 'g-', 'StartAngle', 0, 'EndAngle', 90, 'LineWidth', 1.5)
%    h(2) = ellipse(0, 0, 10, 5, 'r-', 'StartAngle', 180, 'EndAngle', 270, 'LineWidth', 1.5)
%    legend(h, {'Arc #1'; 'Arc #2'}, 'Location', 'NorthWest')
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ellipse.m">ellipse.m</a>
%	  Driver script: <a href="matlab:edit Driver_ellipse.m">Driver_ellipse.m</a>
%	  Documentation: <a href="matlab:pptOpen('ellipse_Function_Documentation.pptx');">ellipse_Function_Documentation.pptx</a>
%
% See also circle 
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/481
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/ellipse.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [h] = ellipse(xc, yc, a, b, varargin)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Input Check:
[StartAngle, varargin]  = format_varargin('StartAngle', 0, 2, varargin);
[EndAngle, varargin]    = format_varargin('EndAngle', 360, 2, varargin);
[AngleStep, varargin]   = format_varargin('AngleStep', 0.01, 2, varargin);
[rotation, varargin]    = format_varargin('Rotation', 0, 2, varargin);

switch nargin
    case {0, 1, 2}
        error([mfnam ':InputArgCheck'], ...
            ['Invalid Number of Inputs!  See ' mlink ' documentation for proper syntax.']);
    case 3
        b = [];
    otherwise
        % Expected
end
        
if(isempty(b))
    b = a;
end

if(ischar(yc)||ischar(xc)||ischar(a)||ischar(b))
    error([mfnam ':InputArgCheck'], 'Input of type CHAR.Input must be a scalar')
end

%% Main Function:
arrAng = [StartAngle : AngleStep : EndAngle];
arrX = xc + a*cosd(arrAng)*cosd(-rotation) + b*sind(arrAng)*sind(-rotation);
arrY = yc - a*cosd(arrAng)*sind(-rotation) + b*sind(arrAng)*cosd(-rotation);
h = plot(arrX, arrY, varargin{:});

end 
%% REVISION HISTORY
% YYMMDD INI: note
% 100912 MWS: Added in ability to create arcs
% 100827 JJ:  Created examples, filled the CosMo format
% 100819 JJ:  Function template created using CreateNewFunc
% 090411 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/PLOTTING_UTILITIES/ellipse.m
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
