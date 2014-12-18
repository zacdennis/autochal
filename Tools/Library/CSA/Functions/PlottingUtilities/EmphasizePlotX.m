% EMPHASIZEPLOTX Emphasizes a desired region in the current figure
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% EmphasizePlotX:
% Specify the x value of a plot and a direction (right/left) to shade in a
% region on the figure. User can specify color and alpha (transparency).
% This function operates on the current figure.
% 
% SYNTAX:
%	[h] = EmphasizePlotX(x,direction,color,alpha)
%	[h] = EmphasizePlotX(x,direction,color)
%
% INPUTS: 
%	Name		Size            Units           Description
%	x   		[1x1] or [1x2]  [User defined]	Value to draw limit at
%	direction	[1xn]           [ND]            String of either 'right' or
%                                               'left' to shade from limit
%	color		[1x1]           [ND]            Colorspec to shade the box 
%                                               (e.g 'r' for red)
%	alpha		[1x1]           [ND]            Transparency value from 0-1
%                                               0 is fully transparent and
%                                               1 is fully opaque.
%                                                   
%									            Default: color=g; %Green
%                                                        aplha= 0.5; 
%
% OUTPUTS: 
%	Name		Size            Units       Description
%	   h		[1x1]           [ND]        Handle of the current figure
%
% NOTES:
%	Variable size for x can be [1x1] to shade out the chart max or min.
%	Also, it can be [1x2] to shade within a segment of the chart.
%
% EXAMPLES:
%   Example 1: Ranged With Default Values
%
%   Plot a green shaded region (default) from 3 to 5 with transparency at
%   1/2 full color (default).
%
%   figure(1);
%   axis([0 10 0 10]);
%   EmphasizePlotX([3 5], 'left')
%
%   Example 2: Single Use
%
%   Plot a red shaded region from -0.4 right with transparency at 1/10th
%   full color.
%
%   figure(2);
%   axis([-5 5 -5 5]);
%   EmphasizePlotX(-0.4, 'right', 'r', 0.1)
%
%   Example 3: Transparency test
%   
%   Plot a black band (alpha=1) under a circle. Right of 0.5 there will be 
%   a green region at alpha=0.75, and green band from -0.5 to 0.5 at 
%   alpha = 0.25
%   
%   figure(3);
%   axis([-1 1 -1 1]);
%   circle(0, 0, 1, 'k','LineWidth', 2);   
%   h(1) = EmphasizePlotY( -1, 'right', 'k', 1);
%   h(2) = EmphasizePlotY( 0.5, 'right', 'g', 0.75);
%   h(3) = EmphasizePlotY( [-0.5 0.5], 'left', 'g', 0.5);
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit EmphasizePlotX.m">EmphasizePlotX.m</a>
%	  Driver script: <a href="matlab:edit Driver_EmphasizePlotX.m">Driver_EmphasizePlotX.m</a>
%	  Documentation: <a href="matlab:pptOpen('EmphasizePlotX_Function_Documentation.pptx');">EmphasizePlotX_Function_Documentation.pptx</a>
%
% See also EmphasizePlotY EmphasizeCurve
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/483
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/EmphasizePlotX.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [h] = EmphasizePlotX(x,direction,color,alpha)

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

%% Input Argument Conditioning:
if nargin < 2
   disp('EmphasizePlotX :: Please refer to useage of EmphasizePlotX...');
   help EmphasizePlotX;
end;

if nargin < 3
   color = 'g';
   alpha = 0.5;
end;

if nargin < 4
   alpha = 0.5;
end;

if (~strcmp('right',direction) && ~strcmp('left',direction))
   
    errstr = [mfnam tab 'ERROR: Not a defined direction for EmphasizePlotX. Please use ''right''or ''left''' ]; 
    error([mfnam 'class:file:Identifier'],errstr);
end

%% Main Function:

%% Get figure axis properties:
XLimit = get(gca,'XLim');
minx = XLimit(1);
maxx = XLimit(2);

YLimit = get(gca,'YLim');
miny = YLimit(1);
maxy = YLimit(2);

if (max(x) > maxx || min(x) < minx)
   
    errstr = [mfnam tab 'ERROR: The specified shaded region is outside of the figure limits. Please re-specify a shaded region within the figure limits']; 
    error([mfnam 'class:file:Identifier'],errstr);
    
end
%% Create patch graphic:
if length(x) > 1
    h = patch([x(1) x(1) x(2) x(2)], [miny maxy maxy miny], color);
else
    if strcmp(direction, 'right')
        h = patch([x x maxx maxx], [miny maxy maxy miny], color);
    elseif strcmp(direction, 'left')
        h = patch([minx minx x x], [miny maxy maxy miny], color);
    else
        disp('EmphasizePlotX :: Please specify either ''right'' or ''left'' for direction');
    end
end
%% Set the transparency:
set(h, 'FaceAlpha', alpha)

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100915 JPG: Modified the function to match EmphasizePlotY.
% 100908 PBH: Minor Updates to INPUTS in Header, updated input checking
%             logic (now uses && instead of || )
% 100827 JJ:  Filled the description and units of the I/O added input check
% 100819 JJ:  Function template created using CreateNewFunc
% 070122 Salluda: Originally created function for VSI_LIB
%            https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/PLOTTIN
%            G_UTILITIES/EmphasizePlotX.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN Username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : g67086
% MWS: Mike Sufana      : mike.sufana@ngc.com               : sufanmi
% PBH: Patrick Healy    : patrick.healy@ngc.com             : healypa
% JPG: James P Gray     : James.Gray2@ngc.com               : g61720

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
