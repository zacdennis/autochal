% PLOTTS_XYZ Plots time-series 'a' versus time-series 'b' and 'c'
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% plotts_xyz:
%     Plots time-series 'a' versus time-series 'b' and 'c'
% 
% SYNTAX:
%	[h] = plotts_xyz(a, b, c, varargin, 'PropertyName', PropertyValue)
%	[h] = plotts_xyz(a, b, c, varargin)
%	[h] = plotts_xyz(a, b, c)
%
% INPUTS: 
%	Name    	Size            Units		Description
%   a           [time-series]               X axis Data
%   b           [time-series]               Y axis Data
%   c           [time-series]               Z axis Data
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size            Units		Description
%   h           [double]                    Figure Handle
%
% NOTES:
%	%  Uses VSI_LIB functiosn 'format_varargin' and 'FormatLabel'.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'PlotTime'          0  or {1}       'true'      Plot Time Labels 
%   'Decimation'        [int]           5 sec       Plotting decimation for markers
%                            
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[h] = plotts_xyz(a, b, c, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[h] = plotts_xyz(a, b, c)
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
%	Source function: <a href="matlab:edit plotts_xyz.m">plotts_xyz.m</a>
%	  Driver script: <a href="matlab:edit Driver_plotts_xyz.m">Driver_plotts_xyz.m</a>
%	  Documentation: <a href="matlab:pptOpen('plotts_xyz_Function_Documentation.pptx');">plotts_xyz_Function_Documentation.pptx</a>
%
% See also format_varargin, FormatLabel
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/500
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/plotts_xyz.m $
% $Rev: 3144 $
% $Date: 2014-04-09 20:50:01 -0500 (Wed, 09 Apr 2014) $
% $Author: sufanmi $

function [h] = plotts_xyz(a, b, c, varargin)

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
h= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        c= ''; b= ''; a= ''; 
%       case 1
%        c= ''; b= ''; 
%       case 2
%        c= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(c))
%		c = -1;
%  end
%% Main Function:
[TimeTag.Show,  varargin]       = format_varargin('TimeTagShow', 1, 2, varargin);
[TimeTag.Angle, varargin]       = format_varargin('TimeTagAngle', 45, 2, varargin);
[TimeTag.Length, varargin]      = format_varargin('TimeTagLength', -1, 2, varargin);
[TimeTag.Frame, varargin]       = format_varargin('TimeTagFrame', 'axis', 2, varargin);
TimeTag.UseLocal = strcmp(TimeTag.Frame, 'local');
[TimeTag.UseZForLabel, varargin]= format_varargin('TimeTagUseZForLabel', 0, 2, varargin);

[dt, varargin]                  = format_varargin('Decimation', 5, 2, varargin);
[xdir, varargin]                = format_varargin('XDir', 'normal', 2, varargin);
[ydir, varargin]                = format_varargin('YDir', 'normal', 2, varargin);
[zdir, varargin]                = format_varargin('ZDir', 'normal', 2, varargin);
[AllowLabelStrrep, varargin]    = format_varargin('AllowLabelStrrep', true, 2, varargin);

numVarargin = length(varargin);

if(mod(numVarargin, 2) == 1)
    strMarker = varargin{1};
    color2use   = find_option(strMarker, {'b';'r';'g';'c';'m';'y';'k';'w'});
    marker2use  = find_option(strMarker, {'*';'+';'o';'.';'x';'s';'d'; ...
        '^';'v';'>';'<';'p';'h'});
    line2use = find_option(strMarker, {'-';'--';':';'-.'});

    if(numVarargin == 1)
        varargin = {};
    else
        for i = 2:length(varargin)
            varargin2{i-1} = varargin{i};
        end
        varargin = varargin2;
    end

else
    color2use = 'b';
    line2use = '-';
    marker2use = '*';
end

[ts1 ts2] = synchronize(a,b,'Union');
[ts1 ts3] = synchronize(a,c,'Union');

% Full Lines:
lines.time = squeeze(ts1.Time);

lines.xdata = squeeze(ts1.Data);
lines.ydata = squeeze(ts2.Data);
lines.zdata = squeeze(ts3.Data);

lines.xrange = max(lines.xdata) - min(lines.xdata);
lines.yrange = max(lines.ydata) - min(lines.ydata);
lines.zrange = max(lines.zdata) - min(lines.zdata);

lines.angle  = [0; atan2((lines.ydata(2:end) - lines.ydata(1:(end-1))), ...
    (lines.xdata(2:end) - lines.xdata(1:(end-1))))];
lines.angle  = lines.angle * 180.0/(acos(-1));

% Down-Sampled Markers:
markers.time    = [ts1.TimeInfo.Start : dt : ts1.TimeInfo.End];
markers.xdata   = interp1(lines.time, lines.xdata, markers.time);
markers.ydata   = interp1(lines.time, lines.ydata, markers.time);
markers.zdata   = interp1(lines.time, lines.zdata, markers.time);

markers.angle   = interp1(lines.time, lines.angle, markers.time);

% Legend Entry:
legends.xdata = lines.xdata(1);
legends.ydata = lines.ydata(1);
legends.zdata = lines.zdata(1);

plot3(lines.xdata, lines.ydata, lines.zdata, 'Color', color2use, 'Marker', 'none', ...
    'LineStyle', line2use, varargin{:}); hold on;
plot3(markers.xdata, markers.ydata, markers.zdata, 'Color', color2use, ...
    'Marker', marker2use, 'LineStyle', 'none', varargin{:});
h = plot3(legends.xdata, legends.ydata, legends.zdata, 'Color', color2use, ...
    'Marker', marker2use, 'LineStyle', line2use, varargin{:});
grid on;

set(gca, 'XDir', xdir);
set(gca, 'YDir', ydir);
set(gca, 'ZDir', zdir);

if(strcmp(xdir, 'reverse'))
    TimeTag.Angle = wrap180(180 - TimeTag.Angle);
end

if(TimeTag.Show)
    flgAdjustableLength = 0;
    if(TimeTag.Length == -1)
        TimeTag.Length = sqrt(lines.xrange^2 + lines.yrange^2) * .04;
        flgAdjustableLength = 1;
    end
        
    for i = 1:length(markers.time)
        curTime = markers.time(i);
        xOrig = markers.xdata(i);
        yOrig = markers.ydata(i);
        zOrig = markers.zdata(i);

        if(TimeTag.UseLocal)
            curLocalAngle = markers.angle(i);
        else
            curLocalAngle = 0;
        end
        
        curAngle    = wrap180(TimeTag.Angle + curLocalAngle);
        curLength   = TimeTag.Length;
        
        
        % Strecth the tag length out a bit if it's on the left side of the
        % marker
        if( (cosd(curAngle) < cosd(100)) && flgAdjustableLength)
            curLength = curLength * 1.5;
        end
        
        xTime = xOrig + curLength * cosd(curAngle);
        yTime = yOrig + curLength * sind(curAngle);
        zTime = zOrig;

        if(TimeTag.UseZForLabel)
            strTime = sprintf('%.2f', zTime);
        else
            strTime = sprintf('%.2f', curTime);
        end
        line([xOrig xTime], [yOrig yTime], [zOrig zTime], 'Color', color2use);
        text(xTime, yTime, zTime, strTime, 'EdgeColor', color2use, 'BackgroundColor', 'w');

    end
end

set(gca, 'FontWeight', 'bold');
xstr = [a.Name ' ' a.DataInfo.Units];
ystr = [b.Name ' ' b.DataInfo.Units];
zstr = [c.Name ' ' c.DataInfo.Units];

xstr = FormatLabel(xstr);
ystr = FormatLabel(ystr);
zstr = FormatLabel(zstr);

if(AllowLabelStrrep)
    xstr = strrep(xstr, '_', '\_');
    ystr = strrep(ystr, '_', '\_');
    zstr = strrep(zstr, '_', '\_');
end

xlabel(xstr, 'FontWeight', 'bold');
ylabel(ystr, 'FontWeight', 'bold');
zlabel(zstr, 'FontWeight', 'bold');

end

function option = find_option(strInput, arrOption)
% Finds Option.
numOptions = length(arrOption);
iMatch = 0;

for iOption = 1:numOptions
    curOption = arrOption{iOption};
    if(~isempty(findstr(strInput, curOption)))
        iMatch = iOption;
    end
end

if(iMatch == 0)
    iMatch = 1;
end
option = arrOption{iMatch};
%% Compile Outputs:
%	h= -1;

end % << End of function plotts_xyz >>

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
