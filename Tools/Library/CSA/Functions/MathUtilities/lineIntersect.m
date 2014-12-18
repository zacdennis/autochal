% LINEINTERSECT Computes the intersection of two lines
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% lineIntersect:
%     Computes the intersection of two lines.  Function can compute either
%     the in-line interestion or projected intersection of two segments.
%     Function also supports searching an array of line segments for
%     in-line/projected intersections.
% 
% SYNTAX:
%	[intersect_x, intersect_y, intersect_type] = lineIntersect(line1_x, line1_y, line2_x, line2_y, IncludeProjections)
%	[intersect_x, intersect_y, intersect_type] = lineIntersect(line1_x, line1_y, line2_x, line2_y)
%
% INPUTS: 
%	Name       	Size		Units		Description
%	line1_x	    [n]         [N/A]       Line #1 X points (n >= 2)
%	line1_y	    [n]         [N/A]       Line #1 Y points
%	line2_x	    [2]         [N/A]       Line #2 X points
%	line2_y	    [2]         [N/A]       Line #2 Y points
%   IncludeProjections [1]  [bool]      Include projections in returned
%                                        intersections? Default is FALSE
%                                        (ie only return in-line
%                                        intersections)
% OUTPUTS: 
%	Name       	Size		Units		Description
%	intersect_x	[m]         [N/A]       X points of in-line/projected
%                                        intersections
%	intersect_y	[m]         [N/A]       Y points of in-line/projected
%                                        intersections
%
% NOTES:
%	If the two lines are coincident (ie right on top of each other), all
%	common x/y points will be returned (technically inf number of
%	intersections).
%
% EXAMPLES:
%	% Example #1: Simple Intersection
%   line1_x = [0; 4]; line1_y = [4; 0];
%   line2_x = [0; 4]; line2_y = [0; 4];
%   [intersect_x, intersect_y, intersect_type] = lineIntersect(line1_x, line1_y, line2_x, line2_y);
%   
%   figure();
%   plot(line1_x, line1_y, 'bo-', 'LineWidth', 1.5); hold on;
%   plot(line2_x, line2_y, 'ro-', 'LineWidth', 1.5);
%   plot(intersect_x, intersect_y, 'g+', 'MarkerSize', 12, 'LineWidth', 5);
%   text(line1_x(1), line1_y(1), '\bf(x_1, y_1)', 'VerticalAlignment', 'bottom');
%   text(line1_x(2), line1_y(2), '\bf(x_2, y_2)', 'VerticalAlignment', 'top');
%   text(line2_x(1), line2_y(1), '\bf(x_3, y_3)', 'VerticalAlignment', 'top');
%   text(line2_x(2), line2_y(2), '\bf(x_4, y_4)', 'VerticalAlignment', 'bottom');
%   strText = ['\bf(' num2str(intersect_x(1)) ', ', num2str(intersect_y(1)) ') ' intersect_type];
%   text(intersect_x(1)+0.5, intersect_y(1), strText, 'VerticalAlignment', 'middle');
%   grid on; set(gca, 'FontWeight', 'bold');
%   ylimits = ylim + [-2 2]; ylim(ylimits);
%   xlimits = xlim + [-2 2]; xlim(xlimits);
%   title('\bf\fontsize{14}lineIntersect : Example # 1');
%
%   % Example #2: In-Line and Projected Intersections with an Array
%   line1_x = 0:.1:10;
%   line1_y = -sin(line1_x);
% 
%   line2_x = [0; 10];
%   line2_y = [1; -0.5];
%   [intersect12_x, intersect12_y] = lineIntersect(line1_x, line1_y, line2_x, line2_y);
% 
%   line3_x = [0; 10];
%   line3_y = [-1.1; -1.1];
%   [intersect13a_x, intersect13a_y, intersect13_type] = lineIntersect(line1_x, line1_y, line3_x, line3_y);
%   [intersect13b_x, intersect13b_y, intersect13b_type] = lineIntersect(line1_x, line1_y, line3_x, line3_y, 1);
% 
%   figure('Position', [450 335 1050 700]);
%   lstLegend = {}; i = 0; h = [];
% 
%   i = i + 1;
%   h(i) = plot(line1_x, line1_y, 'bo-', 'LineWidth', 1.5); hold on;
%   lstLegend(i,1) = {'Line #1'};
%   xlimits = xlim; ylimits = ylim;
% 
%   i = i + 1; h(i) = plot(line2_x, line2_y, 'ro-', 'LineWidth', 1.5);
%   lstLegend(i,1) = {'Line #2'};
%   i = i + 1; h(i) = plot(intersect12_x, intersect12_y, 'g+', 'MarkerSize', 12, 'LineWidth', 5);
%   lstLegend(i,1) = {'Line #1 & #2 Intersections'};
% 
%   i = i + 1; h(i) = plot(line3_x, line3_y, 'co-', 'LineWidth', 1.5);
%   lstLegend(i,1) = {'Line #3 (Note: Does NOT intersect #1)'};
%   i = i + 1; h(i) = plot(intersect13b_x, intersect13b_y, 'rx', 'MarkerSize', 12);
%   lstLegend(i,1) = {'Line #1 & #3 Intersections (projected)'};
% 
%   legend(h, lstLegend, 'Location', 'NorthEast');
%   grid on; set(gca, 'FontWeight', 'bold');
%   ylimits = ylimits + [-1 1]*.25; ylim(ylimits);
%   xlimits = xlimits + [-1 1]; xlim(xlimits);
%   title('\bf\fontsize{14}lineIntersect : Example # 2');
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit lineIntersect.m">lineIntersect.m</a>
%	  Driver script: <a href="matlab:edit Driver_lineIntersect.m">Driver_lineIntersect.m</a>
%	  Documentation: <a href="matlab:winopen(which('lineIntersect_Function_Documentation.pptx'));">lineIntersect_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/815
%  
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/lineIntersect.m $
% $Rev: 3017 $
% $Date: 2013-09-25 18:29:51 -0500 (Wed, 25 Sep 2013) $
% $Author: sufanmi $

function [intersect_x, intersect_y, intersect_type] = lineIntersect(line1_x, line1_y, line2_x, line2_y, IncludeProjections)

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

%% Initialize Outputs:
intersect_x = [];
intersect_y = [];
intersect_type = {};

%% Input Argument Conditioning:
if((nargin < 5) || isempty(IncludeProjections))
    IncludeProjections = false;
end

%% Main Function:
numLoops = length(line1_x) - 1;
iInt = 0;
flgLastCoincident = 0;

for iLoop = 1:numLoops
    x1 = line1_x(iLoop);
    y1 = line1_y(iLoop);
    
    x2 = line1_x(iLoop+1);
    y2 = line1_y(iLoop+1);
    
    x3 = line2_x(1);
    y3 = line2_y(1);
    
    x4 = line2_x(2);
    y4 = line2_y(2);
    
    den_ab = ( (y4-y3)*(x2-x1) - (x4-x3)*(y2-y1) );
    num_a = ( (x4-x3)*(y1-y3) - (y4-y3)*(x1-x3) );
    num_b = ( (x2-x1)*(y1-y3) - (y2-y1)*(x1-x3) );
    
    flgParallel = (den_ab == 0);
    flgCoincident = (num_a == 0) && (num_b == 0) && flgParallel;
    flgSingleIntersect = (~flgParallel && ~flgCoincident);
    
    Px = []; Py = [];
    if(flgSingleIntersect)
        ua = num_a / den_ab;
        ub = num_b / den_ab;
        Px = x1 + ua*(x2-x1);
        Py = y1 + ua*(y2-y1);
        flgIntersectLine1 = ((ua >= 0) && (ua <= 1));
        flgIntersectLine2 = ((ub >= 0) && (ub <= 1));
        flgIntersect = flgIntersectLine1 && flgIntersectLine2;
    end

    if(flgParallel)
        if(flgCoincident)
            if(~flgLastCoincident)
                iInt = iInt + 1;
                intersect_x(iInt) = x1;
                intersect_y(iInt) = y1;
                intersect_type(iInt) = { 'Coincident' };
            end
            
            iInt = iInt + 1;
            intersect_x(iInt) = x2; 
            intersect_y(iInt) = y2;
            intersect_type(iInt) = { 'Coincident' };
            flgLastCoincident = 1;
        else
            flgLastCoincident = 0;
        end
    else
        flgLastCoincident = 0;
        if(flgIntersect)
            iInt = iInt + 1;
            intersect_x(iInt) = Px; 
            intersect_y(iInt) = Py;
            intersect_type(iInt) = { 'Intersect' };
        else
            if(IncludeProjections)
                iInt = iInt + 1;
                intersect_x(iInt) = Px;
                intersect_y(iInt) = Py;
                intersect_type(iInt) = { 'Projection' };
            end
        end
    end
end

if(iInt == 1)
    % Return as string instead of a cell array if only 1 intersection
    % exists
    intersect_type = intersect_type{:};
end

end % << End of function lineIntersect >>

%% REVISION HISTORY
% YYMMDD INI: note
% 130917 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
