% EMPHASIZERECTANGLE Create a shaded rectangle with text
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% EmphasizeRectangle:
%     Adds a shaded rectangle to a figure with user-defined text
%
% SYNTAX:
%	[hdl] = EmphasizeRectangle(left,top,w,h, varargin)
%	[hdl] = EmphasizeRectangle(left,top,w)
%
% INPUTS:
%	Name            Size		Units		Description
%	left            [1]         [N/A]       Plot-x location of lower left
%                                            corner of rectangle
%	top             [1]         [N/A]       Plot-y location of lower left
%                                            corner of rectangle
%	w               [1]         [N/A]       Rectangle Width
%	h               [1]         [N/A]       Rectangle Height
%   varargin        N/A         N/A         Coupled Inputs with additional
%                                            text properties that can be
%                                            specified in any order
%       Property Name       Property Values
%       'color'             'string'        Color of rectangle
%                                            Default: 'g'
%       'alpha'             [double]        Transparency value; 0 --> 1
%                                            Default: 0.5
%       'rotation'          [deg]           Rectangle Rotation, position
%                                            counter-clockwise
%                                            Default: 0
%       'text'              'string'        Text to place in center of box
%                                            Default: '' (none, empty string)
%       'text_rotation'     [deg]           Rotation of text, positive
%                                            counter-clockwise
%                                            Default: same as box rotation
%       'EdgeWidth'         [double]        LineWidth of Rectangle
%                                            Default: 1.5
%       'EdgeColor'         'string'        Edge color of rectangle
%                                            Default: 'k' (black)
%
% OUTPUTS:
%	Name            Size		Units		Description
%	hdl             [1] or [2]  [handle]    Handle to rectangle and
%                                            text box (if text is provided)
%
% NOTES:
%	This function uses the CSA function 'format_varargin' to help parse
%   out the inputs.  Underlying code is based on MATLAB's 'patch' function.
%
% EXAMPLES:
%	% Create a simple figure with three filled in rectangles
%   figure(); axis([-10 10 -10 10]); axis equal; grid on;
%	EmphasizeRectangle(0, 0, 5, 4, 'color', 'g')
%	EmphasizeRectangle(-5, 5, 5, 2, 'rotation', -45, 'color', 'b', 'alpha', 1, 'text', '\bfHi there')
%	EmphasizeRectangle(-5, -5, 5, 4, 'rotation', 45, 'color', 'r', 'text', {'\bfDoes Not'; 'Trim'}, 'text_rotation', 0)
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit EmphasizeRectangle.m">EmphasizeRectangle.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_EmphasizeRectangle.m">DRIVER_EmphasizeRectangle.m</a>
%	  Documentation: <a href="matlab:pptOpen('EmphasizeRectangle Documentation.pptx');">EmphasizeRectangle Documentation.pptx</a>
%
% See also <add relevant functions>
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/678
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/EmphasizeRectangle.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [hdl] = EmphasizeRectangle(left,top,w,h, varargin)

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
hdl= -1;

%% Input Argument Conditioning:
[color, varargin]           = format_varargin('color', 'g', 2, varargin);
[alpha, varargin]           = format_varargin('alpha', 0.5, 2, varargin);
[rotation, varargin]        = format_varargin('rotation', 0, 2, varargin);
[strText, varargin]         = format_varargin('text', '', 2, varargin);
[text_rotation, varargin]   = format_varargin('text_rotation', rotation, 2, varargin);
[edge_color, varargin]      = format_varargin('EdgeColor', 'k', 2, varargin);
[edge_width, varargin]      = format_varargin('LineWidth', 1.5, 2, varargin);

%% Main Function:
arrX = [0 w w 0];
arrY = [0 0 h h];
xpts = left + arrX.*cosd(rotation) - arrY.*sind(rotation);
ypts = top + arrX.*sind(rotation) + arrY.*cosd(rotation);

hdl(1) = patch(xpts, ypts, color, 'FaceAlpha', alpha, ...
    'EdgeColor', edge_color, 'LineWidth', edge_width);
if(~isempty(strText))
    tcx = left + (w/2)*cosd(rotation) - (h/2)*sind(rotation);
    txy = top + (w/2)*sind(rotation) + (h/2)*cosd(rotation);
    hdl(2) = text( tcx, txy, char(strText), ...
        'Rotation', text_rotation, ...
        'HorizontalAlignment','center', 'VerticalAlignment', ...
        'Middle', 'EdgeColor', 'black', 'LineWidth', 1.5, ...
        'BackgroundColor', 'white');
end
%% Compile Outputs:
%	hdl= -1;

end % << End of function EmphasizeRectangle >>

%% REVISION HISTORY
% YYMMDD INI: note
% 100826 MWS: Created function
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName  :  Email  :  NGGN Username
% INI: FullName         : Email                 : NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is
%   subject to severe civil and/or criminal penalties.

% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
