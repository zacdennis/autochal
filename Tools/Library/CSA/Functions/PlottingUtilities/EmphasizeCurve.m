% EMPHASIZECURVE Shades everything above or below a user defined curve
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% EmphasizeCurve:
%     Shades everything above or below a user defined curve
% 
% *************************************************************************
% * #NOTE: To future COSMO'er, the following warning occured when running
% * CreateNewFunc.
% * CreateNewFunc>>WARNING: Selected Input argument name: "color, alpha" is
% * a function name!
% * -JPG
% *************************************************************************
% SYNTAX:
%	[h] = EmphasizeCurve(x, y, direction, color, alpha)
%	[h] = EmphasizeCurve(x, y, direction, color)
%
% INPUTS: 
%	Name     	Size		Units		Description
%   x           [array]                 X points of reference curve
%   y           [array]                 Y points of reference curve
%   direction   [string]                Direction of shading: 'up' or 'down'
%   color       [string]                Colorspec to shade box (e.g. 'r' for red)
%   alpha       [1]                     Transparency value (e.g. 0.5 is half
%                                       transparent)
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	h   	        <size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%
%   Shade everything above the given curve red, and everything below it
%   green:
%       x = 0:.01:10; y = sin(x); figure(); plot(x,y); grid on;
%       EmphasizeCurve(x, y, 'down', 'r', 0.1)
%       EmphasizeCurve(x, y, 'up', 'g', 0.5)
%
%	% <Enter Description of Example #1>
%	[h] = EmphasizeCurve(x, y, direction, color, alpha, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[h] = EmphasizeCurve(x, y, direction, color, alpha)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
% Book with One Author:
% [2]   Author Last Name, Author First Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
% Book with Two Author:
% [3]   Author #1 Last Name, Author #1 First Name, and Author #2 Full Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit EmphasizeCurve.m">EmphasizeCurve.m</a>
%	  Driver script: <a href="matlab:edit Driver_EmphasizeCurve.m">Driver_EmphasizeCurve.m</a>
%	  Documentation: <a href="matlab:pptOpen('EmphasizeCurve_Function_Documentation.pptx');">EmphasizeCurve_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/482
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/EmphasizeCurve.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [h] = EmphasizeCurve(x, y, direction, color, alpha, varargin)

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
% h= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        alpha= ''; color= ''; direction= ''; y= ''; x= ''; 
%       case 1
%        alpha= ''; color= ''; direction= ''; y= ''; 
%       case 2
%        alpha= ''; color= ''; direction= ''; 
%       case 3
%        alpha= ''; color= ''; 
%       case 4
%        alpha= ''; 
%       case 5
%        
%       case 6
%        
%  end
%
%  if(isempty(alpha))
%		alpha = -1;
%  end
if nargin < 3
   disp('EmphasizeCurve :: Please refer to useage of EmphasizeCurve...');
   help EmphasizeCurve;
end;

if nargin < 4
   color = 'g';
   alpha = 0.5;
end;

if nargin < 5
   alpha = 0.5;
end;
%% Main Function:
%% Get figure axis properties:
XLimit = get(gca,'XLim');
minx = XLimit(1);
maxx = XLimit(2);

YLimit = get(gca,'YLim');
miny = YLimit(1);
maxy = YLimit(2);

%% Create patch graphic:

if(~isempty(x))
    if strcmp(direction, 'up')
        xpts = [minx x maxx];
        ypts = [maxy y maxy];
    else
        xpts = [minx x maxx];
        ypts = [miny y miny];
    end
    h = patch(xpts, ypts, color);
    
else
    if length(y) > 1
        h = patch([minx minx maxx maxx], [y(1) y(2) y(2) y(1)], color);
    else
        if strcmp(direction, 'up')
            h = patch([minx minx maxx maxx], [y maxy maxy y], color);
        elseif strcmp(direction, 'down')
            h = patch([minx minx maxx maxx], [y miny miny y], color);
        else
            disp('EmphasizeCurve :: Please specify either ''up'' or ''down'' for direction');
        end
    end
end

%% Set the transparency:
set(h, 'FaceAlpha', alpha)
ylim(YLimit);
xlim(XLimit);

%% Compile Outputs:
%	h= -1;

end % << End of function EmphasizeCurve >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720 

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
