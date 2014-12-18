% CIRCLE Plots a circle
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% circle:
%   Plots a circle or a circular arc with plugs for additional line
%   formatting
% 
% SYNTAX:
%	[h] = circle(xc, yc, a, b, 'PropertyName', PropertyValue)
%	[h] = circle(xc, yc, r, varargin)
%	[h] = circle(xc, yc, r)
%
% INPUTS: 
%	Name		Size		Units		Description
%	xc  		[1]         [ND]		X coordinate of the circle's center
%	yc  		[1]         [ND]		Y coordinate of the circle's center
%	r   		[1]   		[ND]		Radius of the circle
%	varargin	[N/A]   	[varies]	Additional plotting properties
%                                        that could be defined by the
%                                        user.  These inputs must be
%                                        a) entered in pairs
%                                        b) supported by the lineseries 
%                                           plot object
%                                        See 'VARARGIN' description below
% OUTPUTS: 
%	Name		Size		Units		Description
%	h   		[1]		    [ND]  		Line Handle
%
% NOTES:
%
%   VARARGIN PROPERTIES:
%   PropertyName        PropertyValue   Default     Description
%   'StartAngle'        [deg]           0           Start Angle of Ellipse
%   'EndAngle'          [deg]           360         End Angle of Ellipse
%   'AngleStep'         [deg]           0.01        Ellipse Fineness
%   'Color'             'string'        'b'         Line Color
%   'LineWidth'         [double]        1           Line Width
%   'LineStyle'         'string'        '-'         Line Style
%
% EXAMPLES:
%	Example 1: Plot a thick red circle with the center at the origin, 
%   with a radius of 5.
%	
%    figure(1); axis([-15 15 -15 15]); axis equal; grid on; hold on;
%    h(2) = circle(0, 0, 5, 'r-', 'LineWidth', 3);
%
%	Example 2: Plot a green and red circular arc on a figure
%   
%    figure(2); axis([-10 10 -10 10]); axis equal; grid on; hold on;
%	 h(1) = circle(0, 0, 8, 'g-', 'StartAngle', 0, 'EndAngle', 90, 'LineWidth', 1.5)
%	 h(2) = circle(0, 0, 8, 'r-', 'StartAngle', 180, 'EndAngle', 270, 'LineWidth', 1.5)
%    legend(h, {'Arc #1'; 'Arc #2'}, 'Location', 'NorthWest')
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit circle.m">circle.m</a>
%	  Driver script: <a href="matlab:edit Driver_circle.m">Driver_circle.m</a>
%	  Documentation: <a href="matlab:pptOpen('circle_Function_Documentation.pptx');">circle_Function_Documentation.pptx</a>
%
% See also ellipse
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/478
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/circle.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [h] = circle(xc, yc, r, varargin)
%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

%% Initialize Outputs:
h= [];

%% Input Argument Conditioning:
[StartAngle, varargin]  = format_varargin('StartAngle', 0, 2, varargin);
[EndAngle, varargin]    = format_varargin('EndAngle', 360, 2, varargin);
[AngleStep, varargin]   = format_varargin('AngleStep', 0.01, 2, varargin);

if(nargin < 3)
    warning([mfnam ':InputArgCheck'], ['Must have three scalar inputs'... 
        ' xc, yc, r. \n Using default values of xc = 1, yc = 1, r = 1']);
    xc= 1; yc = 1; r = 1;
end

if(~isnumeric(xc) || ~isnumeric(yc) || ~isnumeric(r))
     error([mfnam ':InputArgCheck'], 'Input must be a scalar.')
 end

%% Main Function:
arrAng = [StartAngle : AngleStep : EndAngle];
arrX = xc + r*cosd(arrAng);
arrY = yc + r*sind(arrAng);
h = plot(arrX, arrY, varargin{:});

end 
%% REVISION HISTORY
% YYMMDD INI: note
% 100912 MWS: Added in ability to create arcs
% 100901 JPG: Finished filling in the template per COSMO format.
% 100830 JPG: Function template created using CreateNewFunc
% 090411 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/PLOTTING_UTILITIES/circle.m
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% JPG: James Patrick Gray   : James.Gray2@ngc.com   : g61720 
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi

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
