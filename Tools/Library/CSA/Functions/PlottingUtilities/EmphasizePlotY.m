% EMPHASIZEPLOTY Emphasizes a desired region in the current figure
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% EmphasizePlotY:
% Specify the y value of a plot and the direction (up/down) to shade in a
% region on the figure.  User can specify color and alpha (transparency).
% This function operates on the current figure.
% 
% SYNTAX:
%	[h] = EmphasizePlotY(y,direction,color,alpha)
%	[h] = EmphasizePlotY(y,direction,color)
%
% INPUTS: 
%	Name		Size            Units           Description
%	y   		[1x1] or [1x2]	[User Defined]  Value to draw limit at                                        
%	direction	[1xn]           [ND]            String of either 'up' or 
%                                               'down' to shade from limit                                       
%	color		[1x1]           [ND]        	Colorspec to shade the box.
%                                               (e.g. 'k' for black)
%	alpha		[1x1]           [ND]    		Transparency value from 0-1
%                                               0 is fully transparent and 
%                                               1 is fully opaque.
%
%                                               Default: alpha=0.5; 
%                                                        color=g;  %Green
%
% OUTPUTS: 
%	Name		Size            Units		Description
%	h   		[1x1]           [ND]        Handle of the current figure
%
% NOTES:
%	Variable size for y can be [1x1] to shade out to the chart max or min. 
%   Also, it can be [1x2] to shade within a segment of the chart. 
%
% EXAMPLES:
%	Example 1: Ranged With Default Values
%   
%   Plot a green shaded region (default) from 3 to 5 with transparency at
%   1/2 full color (default).
%	
%   figure(1);
%   axis([0 10 0 10]);
%   EmphasizePlotX([3 5], 'up')
%
%   Example 2: Single Use
%
%   Plot a red shaded region from -0.4 up with transparency at 1/10th the
%   full color.
%
%	figure(2);
%   axis([-5 5 -5 5]);
%   EmphasizePlotY(-0.4,'up','r',0.1)
%
%   Example 3: Transparency test
%   
%   Plot a black band (alpha=1) under a circle. Above 0.5 there will be a 
%   green region at alpha=0.75, and green band from -0.5 to 0.5 at 
%   alpha = 0.25
%   
%   figure(3);
%   axis([-1 1 -1 1]);
%   circle(0, 0, 1, 'k','LineWidth', 2);   
%   h(1) = EmphasizePlotY( -1, 'up', 'k', 1);
%   h(2) = EmphasizePlotY( 0.5, 'up', 'g', 0.75);
%   h(3) = EmphasizePlotY( [-0.5 0.5], 'down', 'g', 0.25);
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit EmphasizePlotY.m">EmphasizePlotY.m</a>
%	  Driver script: <a href="matlab:edit Driver_EmphasizePlotY.m">Driver_EmphasizePlotY.m</a>
%	  Documentation: <a href="matlab:pptOpen('EmphasizePlotY_Function_Documentation.pptx');">EmphasizePlotY_Function_Documentation.pptx</a>
%
% See also EmphasizePlotX EmphasizeCurve
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/484
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/EmphasizePlotY.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [h] = EmphasizePlotY(y,direction,color,alpha)

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
h= -1;

%% Input Argument Conditioning:
if nargin < 2
   disp([mfnam ' :: Please refer to useage of EmphasizePlotY...']);
   help EmphasizePlotY;
end;

if nargin < 3
   color = 'g';
   alpha = 0.5;
end;

if nargin < 4
   alpha = 0.5;
end;

direction = lower(direction);
if (~strcmp('down', direction) && ~strcmp('up', direction))
    errstr = [mfnam tab 'ERROR: Not a defined direction for'...
        ' EmphasizePlotY. Please use ''up'' or ''down''.'];
    error([mfnam 'class:file:Identifier'], errstr);
end

%% Main Function:

%% Get figure axis properties:
XLimit = get(gca,'XLim');
minx = XLimit(1);
maxx = XLimit(2);

YLimit = get(gca,'YLim');
miny = YLimit(1);
maxy = YLimit(2);

if (max(y) > maxy || min(y) < miny)
   
    errstr = [mfnam tab 'ERROR: The specified shaded region is outside'...
        ' of the figure limits. Please re-specify a shaded region '...
        'within the figure limits']; 
    error([mfnam 'class:file:Identifier'],errstr);
    
end

%% Create patch graphic:
if length(y) > 1
    h = patch([minx minx maxx maxx], [y(1) y(2) y(2) y(1)], color);
else
    if strcmp(direction, 'up')
        h = patch([minx minx maxx maxx], [y maxy maxy y], color);
    elseif strcmp(direction, 'down')
        h = patch([minx minx maxx maxx], [y miny miny y], color);
    else
        disp([mfnam ' :: Please specify either ''up'' or ''down'' for direction']);
    end
end
%% Set the transparency:
set(h, 'FaceAlpha', alpha)
ylim(YLimit);
xlim(XLimit);

%% Compile Outputs:
%	h= -1;

end % << End of function EmphasizePlotY >>

%% REVISION HISTORY
% YYMMDD INI: note
%
% 100915 JPG: Modified the function to match EmphasizePlotX.
% 100902 JPG: Filled in the template per COSMO format.
% 100902 JPG: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% JPG: James Patrick Gray   : James.Gray2@ngc.com   : g61720 

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
