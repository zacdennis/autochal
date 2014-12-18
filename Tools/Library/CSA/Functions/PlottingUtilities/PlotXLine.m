% PLOTXLINE Plots vertical lines at user-defined X values
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% PlotXLine:
%  Plots vertical lines at user-defined X values in the current figure 
% 
% SYNTAX:
%	[h] = PlotXLine(xval, 'PropertyName', PropertyValue)
%	[h] = PlotXLine(xval, varargin)
%	[h] = PlotXLine(xval)
%
% INPUTS: 
%	Name		Size		Units           Description
%	xval		[Variable] 	[User Defined]	X value at which to plot line
%	varargin	[N/A]   	[varies]		Additional plotting properties
%                                           that could be defined by the
%                                           user.  These inputs must be
%                                           entered in pairs and supported
%                                           by the lineseries plot object
% OUTPUTS: 
%	Name		Size		Units           Description
%	h   		[Variable]  [double]        Line Handle 
%
% NOTES:
%   VARARGIN PROPERTIES
%   PropertyName        PropertyValue       Description
%   'AllowResize'       [bool]              Allow plot to resize itself in
%                                           'X' if 'xval' is outside figure's
%                                           current x-limits. Default: false
%   'Color'             'string'            Line Color (e.g. 'b')
%   'LineWidth'         [double]            Line Width (e.g. 1.5)
%   'LineStyle'         'string'            Line Style {e.g. '-')
%
%   The inputed 'xval' size is variable.  It can be entered as a single, a
%   vector or a matrix input.  The returned plot handle 'h' will carry the
%   same dimensions as 'xval'.
%
% EXAMPLES:
%   Example 1: Plot two thick, dashed red lines using column inputs
%   figure();   h = PlotXLine([-1 2], 'r--', 'LineWidth', 4);
%
%   Example 2: Plot two lines on a established figure, and allow resizing
%   figure();   axis([0 10 0 10]); xval = [-1 5];
%   h = PlotXLine(xval, 'r--', 'AllowResize', true);
%
%   Example 3: Plot six medium weight, dotted black lines using a matrix
%   figure(); 	h = PlotXLine([-2 -1 0; 1 2 3], 'k:', 'LineWidth', 2);
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit PlotXLine.m">PlotXLine.m</a>
%	  Driver script: <a href="matlab:edit Driver_PlotXLine.m">Driver_PlotXLine.m</a>
%	  Documentation: <a href="matlab:pptOpen('PlotXLine_Function_Documentation.pptx');">PlotXLine_Function_Documentation.pptx</a>
%
% See also PlotYLine, EmphasizePlotY, EmphasizePlotX, minAll, maxAll 
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/501
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/PlotXLine.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [h] = PlotXLine(xval,varargin)

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
[flgAllowResize, varargin] = format_varargin('AllowResize', false, 2, varargin);

if nargin < 1
   disp([mfnam ' :: Please refer to useage of PlotXLine' endl ...
       'Function format: h = PlotXLine(xval, varargin)']);
   return
end

if(ischar(xval))
    error([mfnam ':InputArgCheck'], 'Input of type CHAR. xval''s must be a scalar vector, column or matrix ')
end

%% Main Function:
XLimit = get(gca, 'XLim');
YLimit = get(gca, 'YLim');
miny = YLimit(1);
maxy = YLimit(2);
numLines = size(xval);
for i = 1:numLines(1)
    for j = 1:numLines(2)
        h(i,j) = plot([xval(i,j) xval(i,j)], [miny maxy], varargin{:});
        hold on;
    end
end
hold off;

% Fix Axes if the shifted
ylim(YLimit);
if(flgAllowResize)
    minx = min(XLimit(1), minAll(xval));
    maxx = max(XLimit(2), maxAll(xval));
    xlim([minx maxx]);
else 
    xlim(XLimit);
end

end % << End of function PlotXLine >>

%% REVISION HISTORY
% YYMMDD INI: note
% 100911 MWS: Added abilitiy to disable resizing of the figure if the line
%              is plotted outside the current axes.
%             Resolved differences with PlotYLine.
% 100907 JPG: Added ability to input with vector/matrix and some arguement 
%              checking. 
% 100902 JPG: Function template created using CreateNewFunc
% 051103 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/PLOTTI
%             NG_UTILITIES/PlotXLine.m
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                : NGGN Username 
% JPG: James Patrick Gray   : James.Gray2@ngc.com  : g61720 
% MWS: Mike Sufana          : mike.sufana@ngc.com  : sufanmi

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
