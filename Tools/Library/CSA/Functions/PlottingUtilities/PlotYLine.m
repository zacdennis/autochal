% PLOTYLINE Plots a horizontal line at a user-defined Y value
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% PlotYLine:
%  Plots horizontal lines at user-defined Y values in the current figure
%
% SYNTAX:
%	h = PlotXLine(yval, 'PropertyName', PropertyValue)
%	h = PlotYLine(yval, varargin)
%	h = PlotYLine(yval)
%
% INPUTS:
%	Name		Size		Units           Description
%	yval		[Variable]	[User Defined]	Y value at which to plot line
%	varargin	[N/A]   	[varies]		Additional plotting properties
%                                           that could be defined by the
%                                           user.  These inputs must be
%                                           entered in pairs and supported
%                                           by the lineseries plot object
% OUTPUTS:
%	Name		Size		Units           Description
%	h   		[Variable]	[double]    	Plot handle
%
% NOTES:
%   VARARGIN PROPERTIES
%   PropertyName        PropertyValue       Description
%   'AllowResize'       [bool]              Allow plot to resize itself in
%                                           'Y' if 'yval' is outside figure's
%                                           current y-limits. Default: false
%   'Color'             'string'            Line Color (e.g. 'b')
%   'LineWidth'         [double]            Line Width (e.g. 1.5)
%   'LineStyle'         'string'            Line Style {e.g. '-')
%
%   The inputed 'yval' size is variable.  It can be entered as a single, a
%   vector or a matrix input.  The returned plot handle 'h' will carry the
%   same dimensions as 'yval'.
%
% EXAMPLES:
%   Example 1: Plot two thick, dashed red lines using column inputs
%   figure(); h = PlotYLine([2; 4], 'r--', 'LineWidth', 4)
%	
%   Example 2: Plot two lines on a established figure, and allow resizing
%   figure();   axis([0 10 0 10]); yval = [2; 4];
%   h = PlotYLine(yval, 'r--', 'AllowResize', true);
%
%   Example 3: Plot six medium weight, dotted black lines using a matrix
%   figure(); h = PlotYLine([2 4 6; 3 5 7], 'k:', 'LineWidth', 2);
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit PlotYLine.m">PlotYLine.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_PlotYLine.m">DRIVER_PlotYLine.m</a>
%	  Documentation: <a href="matlab:pptOpen('PlotYLine_Function_Documentation.pptx');">PlotYLine_Function_Documentation.pptx</a>
%
% See also PlotXLine, EmphasizePlotX, EmphasizePlotY, minAll, maxAll
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/502
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/PlotYLine.m $
% $Rev: 2198 $
% $Date: 2011-09-13 14:33:00 -0500 (Tue, 13 Sep 2011) $
% $Author: sufanmi $

function [h] = PlotYLine(yval,varargin)

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

%% Initialize Outputs:
h= [];

%% Input Argument Conditioning:
[flgAllowResize, varargin]  = format_varargin('AllowResize', false, 2, varargin);

if nargin < 1
   disp([mfnam ' :: Please refer to useage of PlotYLine' endl ...
       'Function format: h = PlotYLine(yval, varargin)']);
   return
end

if(ischar(yval))
    error([mfnam ':InputArgCheck'], 'Input of type CHAR. yval''s must be a scalar vector, column or matrix ')
end

%% Main Function:
XLimit = get(gca,'XLim');
YLimit = get(gca, 'YLim');
minx = XLimit(1);
maxx = XLimit(2);
numLines=size(yval);
hold on;
for i=1:numLines(1)
    for j=1:numLines(2)
        h(i,j) = plot([minx maxx], [yval(i,j) yval(i,j)], varargin{:});
    end
end
hold off;

% Fix Axes if the shifted
xlim(XLimit);
if(flgAllowResize)
    miny = min(YLimit(1), minAll(yval));
    maxy = max(YLimit(2), maxAll(yval));
    ylim([miny maxy]);
else 
    ylim(YLimit);
end

end % << End of function PlotYLine >>

%% REVISION HISTORY
% YYMMDD INI: note
% 100911 MWS: Added abilitiy to disable resizing of the figure if the line
%              is plotted outside the current axes.
%             Resolved differences with PlotXLine.
% 100824 JJ:  Generated the capability to input columns, vectors, and
%             matrices
% 100823 JJ:  Function template created using CreateNewFunc
% 051103 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/PLOTTING_UTILITIES/PlotYLine.m
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
