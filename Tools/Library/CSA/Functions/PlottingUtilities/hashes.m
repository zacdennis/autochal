% HASHES Plots Boundary hashes on line referenced by user defined xb and yb
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% hashes:
%     Plots Boundary hashes on line referenced by user defined xb and yb
% 
% SYNTAX:
%	[lh] = hashes(xb, yb, varargin, 'PropertyName', PropertyValue)
%	[lh] = hashes(xb, yb, varargin)
%	[lh] = hashes(xb, yb)
%	[lh] = hashes(xb)
%
% INPUTS: 
%	Name    	Size		Units		Description
%   xb      [1], [1xN], or [Nx1]    Reference x points for hashes
%                                   Note: If xb is singular, assumes that a
%                                   vertical line is to be hashed at xb.
%   yb      [1], [1xN], or [Nx1]    Reference y points for hashes
%                                   Note: If yb is singular, assumes that a
%                                   horizontal line is to be hashed at yb.
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	lh  	      <size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName	PropertyValue	Default		Description
%   'NumHashes'     [int]           100         Number of hashes to plot
%   'Angle'         [deg]           45          Angle of hashes w.r.t. 'Frame'
%   'Frame'         [string]        'axis'      Frame angles are referenced to:
%                                               'axis' or 'local'
%   'Color'         N/A             'b'         Can also be vector (e.g. [1 0 0])
%   'Length'        N/A             1           
%   'LineWidth'     [double]        1           Same as regular Matlab
%   'RescaleX'      [bool]          'false'     Rescale plot if hashes fall outside
%                                               of current plot window
%   'RescaleY'      [bool]          'false'     Rescale plot if hashes fall outside
%                                               of current plot window
%
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[lh] = hashes(xb, yb, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[lh] = hashes(xb, yb)
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
%	Source function: <a href="matlab:edit hashes.m">hashes.m</a>
%	  Driver script: <a href="matlab:edit Driver_hashes.m">Driver_hashes.m</a>
%	  Documentation: <a href="matlab:pptOpen('hashes_Function_Documentation.pptx');">hashes_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/489
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/hashes.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [lh] = hashes(xb, yb, varargin)

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
% lh= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        yb= ''; xb= ''; 
%       case 1
%        yb= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(yb))
%		yb = -1;
%  end
%% Main Function:
%% Hash Options:
HO.NumHashes    = ReplaceDefault('NumHashes', 100, varargin);
HO.Angle        = ReplaceDefault('Angle', 45, varargin);
HO.Frame        = ReplaceDefault('Frame', 'axis', varargin);
HO.Color        = ReplaceDefault('Color', 'b', varargin);
HO.Length       = ReplaceDefault('Length', 1, varargin);
HO.LineWidth    = ReplaceDefault('LineWidth', 1, varargin);
HO.RescaleX     = ReplaceDefault('RescaleX', 'false', varargin);
HO.RescaleY     = ReplaceDefault('RescaleY', 'false', varargin);
HO.useLocal     = strcmp(lower(HO.Frame), 'local');

%% Check input Arguments:
if(isempty(xb) && isempty(yb))
    disp(sprintf('%s : ERROR : Need at least one x or y point for plotting', ...
        mfilename));
    help(mfilename);
    return;
end

xlimits = get(gca, 'XLim');
ylimits = get(gca, 'YLim');

if(isempty(xb))
    xb = xlimits;
    yb = [yb yb];
end

if(isempty(yb))
    xb = [xb xb];
    yb = ylimits;
end

%% Convert to 'time' domain to avoid interp1 problems with vertical lines
tb = [1:length(xb)];
t  = linspace(1, length(xb), HO.NumHashes);

x1 = interp1(tb, xb, t);
y1 = interp1(tb, yb, t);

hold on;
plot(xb, yb, '-', 'Color', HO.Color, 'LineWidth', HO.LineWidth);

x2 = x1 + HO.Length * cosd(HO.Angle);
y2 = y1 + HO.Length * sind(HO.Angle);

for i = 1:HO.NumHashes

    if(HO.useLocal)
        if(i > 1)
            localAngle = atan2( (y1(i)-y1(i-1)), (x1(i)-x1(i-1)) ) * 180/pi;
            x2(i) = x1(i) + HO.Length * cosd(localAngle + HO.Angle);
            y2(i) = y1(i) + HO.Length * sind(localAngle + HO.Angle);
        end
    end
    
    if(i == 1)
        lh = line([x1(i) x2(i)], [y1(i) y2(i)], 'Color', HO.Color, 'LineWidth', HO.LineWidth);
    else
        line([x1(i) x2(i)], [y1(i) y2(i)], 'Color', HO.Color, 'LineWidth', HO.LineWidth);
    end
end

if(strcmp(lower(HO.RescaleX), 'false'))
    set(gca, 'XLim', xlimits);
end

if(strcmp(lower(HO.RescaleY), 'false'))
    set(gca, 'YLim', ylimits);
end

return;

function y = ReplaceDefault(strDefault, valDefault, argin)
numArgin = size(argin, 2);

y = valDefault;
for i = 1:numArgin
    curArg = argin{i};
    
    if(strcmp(curArg, strDefault))       
        y = argin{i+1};
        break;
    end
end


end % << End of function hashes >>
end
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
