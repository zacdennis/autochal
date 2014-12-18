% PLOTTS_XY Plots time-series 'a' versus time-series 'b'
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% plotts_xy:
%     Plots time-series 'a' versus time-series 'b'
% 
% SYNTAX:
%	[h] = plotts_xy(a, b, varargin, 'PropertyName', PropertyValue)
%	[h] = plotts_xy(a, b, varargin)
%	[h] = plotts_xy(a, b)
%
% INPUTS: 
%	Name    	Size		Units		Description
%   a                                   MATLAB time-series for x-axis
%   b                                   MATLAB time-series for y-axis
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%   h                       [ND]        Figure Handle
%
% NOTES:
%	Uses CSA functions 'format_varargin' and 'FormatLabel'.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'PlotTime'          0  or {1}          1       	Plot Time Labels
%   'TimeTagUnits'      'string'        'sec'       Time Units to use for
%                                                    plotting.  Options:
%                                                    'msec', {'sec'}, 'min',
%                                                    'hr', 'day'
%   'Decimation'        [int]              5 sec    Plotting decimation for 
%                                                   markers (place marker
%                                                   every n timesteps),
%                                                   where timestep is
%                                                   determiend by
%                                                   'TimeTagUnits'
%                                           
% EXAMPLES:
%	% Plot a sample flight path trajectory (lat/lon)
%   t = [0:0.01:10]*C.MIN2SEC;
%   lat = sin(t/80)*10;
%   lon = -cos(t/50)*5;
% 
%   tsLat = timeseries(lat', t');
%   tsLat.Name = 'Latitude';
%   tsLat.DataInfo.Units = '[deg]';
% 
%   tsLon = timeseries(lon', t');
%   tsLon.Name = 'Longitude';
%   tsLon.DataInfo.Units = '[deg]';
% 
%   figure();
%   h = plotts_xy(tsLon, tsLat, ...
%       'MarkerSize', 10, 'LineWidth', 1.5, ...
%       'TimeTagUnits', 'min', 'Decimation', 2);
%   title('Plotting Data with Markers every 2 minutes');
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit plotts_xy.m">plotts_xy.m</a>
%	  Driver script: <a href="matlab:edit Driver_plotts_xy.m">Driver_plotts_xy.m</a>
%	  Documentation: <a href="matlab:pptOpen('plotts_xy_Function_Documentation.pptx');">plotts_xy_Function_Documentation.pptx</a>
%
% See also format_varargin, FormatLabel 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/524
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/plotts_xy.m $
% $Rev: 3145 $
% $Date: 2014-04-17 13:17:34 -0500 (Thu, 17 Apr 2014) $
% $Author: sufanmi $

function [h] = plotts_xy(a, b, varargin)

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
[TimeTag.Show,  varargin]       = format_varargin('TimeTagShow', 1, 2, varargin);
[TimeTag.Angle, varargin]       = format_varargin('TimeTagAngle', 45, 2, varargin);
[TimeTag.Length, varargin]      = format_varargin('TimeTagLength', -1, 2, varargin);
[TimeTag.Frame, varargin]       = format_varargin('TimeTagFrame', 'axis', 2, varargin);
[TimeTag.Color, varargin]       = format_varargin('TimeTagColor', '', 2, varargin);
[TimeTag.Units, varargin]       = format_varargin('TimeTagUnits', 'HHMMSS', 2, varargin);
[PlotType, varargin]            = format_varargin('PlotType', '', 2, varargin);
TimeTag.UseLocal                = strcmp(TimeTag.Frame, 'local');
[dt, varargin]                  = format_varargin('Decimation', [], 2, varargin);
[xdir, varargin]                = format_varargin('XDir', 'normal', 2, varargin);
[ydir, varargin]                = format_varargin('YDir', 'normal', 2, varargin);
[AllowLabelStrrep, varargin]    = format_varargin('AllowLabelStrrep', true, 2, varargin);

%% Main Function:
switch lower(TimeTag.Units)
    case 'msec'
        kTime = 1e3;
    case {'sec', 'hhmmss'}
        kTime  = 1;
    case 'min'
        kTime  = 1/(60);
    case 'hr'
        kTime  = 1/(60*60);
    case 'day'
        kTime  = 1/(60*60*24);
    otherwise
        kTime  = 1;
end

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
[color2use, varargin] = format_varargin('Color', color2use, 2, varargin);

try
    [ts1 ts2] = synchronize(a,b,'Union');
catch
   disp(lasterr);
   disp('ERROR Using ''synchronize''.  Assuming timeseries are synched');
   ts1 = a;
   ts2 = b;
end

% Full Lines:
lines.time_sec = squeeze(ts1.Time);
lines.xdata = squeeze(ts1.Data);
lines.ydata = squeeze(ts2.Data);
lines.xrange = max(lines.xdata) - min(lines.xdata);
lines.yrange = max(lines.ydata) - min(lines.ydata);
lines.angle  = [0; atan2((lines.ydata(2:end) - lines.ydata(1:(end-1))), ...
    (lines.xdata(2:end) - lines.xdata(1:(end-1))))];
lines.angle  = lines.angle * 180.0/(acos(-1));

if(length(dt) > 1)
    markers.time_sec    = dt*kTime;
else
    % Down-Sampled Markers:
    if(isempty(dt))
        dt = 5;     % Assume 5 seconds
    end
    dt = dt / kTime;
    markers.time_sec    = unique([ts1.TimeInfo.Start : dt : ts1.TimeInfo.End  ts1.TimeInfo.End]);
end
markers.xdata   = interp1(lines.time_sec, lines.xdata, markers.time_sec);
markers.ydata   = interp1(lines.time_sec, lines.ydata, markers.time_sec);
markers.angle   = interp1(lines.time_sec, lines.angle, markers.time_sec);

% Legend Entry:
legends.xdata = lines.xdata(1);
legends.ydata = lines.ydata(1);

if(strcmp(lower(PlotType), 'geoshow'))
    % Raw Line (No Marker)
    geoshow(lines.ydata, lines.xdata, 'Color', color2use, ...
        'LineStyle', line2use, varargin{:}, 'Marker', 'none'); hold on;
    % 
    geoshow(markers.ydata, markers.xdata, 'Color', color2use, ...
        'Marker', marker2use, varargin{:}, 'LineStyle', 'none');
    h = geoshow(legends.ydata, legends.xdata, 'Color', color2use, ...
        'Marker', marker2use, 'LineStyle', line2use, varargin{:});
else
    plot(lines.xdata, lines.ydata, 'Color', color2use, ...
        'LineStyle', line2use, varargin{:}, 'Marker', 'none'); hold on;
    plot(markers.xdata, markers.ydata, 'Color', color2use, ...
        'Marker', marker2use, varargin{:}, 'LineStyle', 'none');
    h = plot(legends.xdata, legends.ydata, 'Color', color2use, ...
        'Marker', marker2use, 'LineStyle', line2use, varargin{:});
end
color2use_RGB = get(h, 'Color');
if(isempty(color2use_RGB))
    color2use_RGB = color2use;
end
grid on;

set(gca, 'XDir', xdir);
set(gca, 'YDir', ydir);

if(strcmp(xdir, 'reverse'))
    TimeTag.Angle = wrap180(180 - TimeTag.Angle);
end

if(TimeTag.Show)
    flgAdjustableLength = 0;
    if(TimeTag.Length == -1)
        TimeTag.Length = sqrt(lines.xrange^2 + lines.yrange^2) * .04;
        flgAdjustableLength = 1;
    end
        
    if(isempty(TimeTag.Color))
        TimeTag.Color = color2use_RGB;
    end
    
    for i = 1:length(markers.time_sec)
        curTime = markers.time_sec(i);
        xOrig = markers.xdata(i);
        yOrig = markers.ydata(i);
        
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
            
        switch lower(TimeTag.Units)
            case 'msec'
                strTime = sprintf('%.2f msec', curTime*1e3);
            case 'sec'        
                strTime = sprintf('%.2f sec', curTime);
            case 'min'
                strTime = sprintf('%.2f min', curTime/(60));
            case 'hr'
                strTime = sprintf('%.2f hr', curTime/(60*60));
            case 'day'
                strTime = sprintf('%.2f day', curTime/(60*60*24));
            case 'hhmmss'
                leftTime = curTime;
                curDay = floor(leftTime/(60*60*24));
                leftTime = leftTime - curDay * (60*60*24);
                curHr = floor(leftTime/(60*60));
                leftTime = leftTime - curHr * (60*60);
                curMin = floor(leftTime/60);
                leftTime = leftTime - curMin*60;
                
                if(max(markers.time_sec) > (60*60))
                    strTime = sprintf('%02.0f:%02.0f:%04.1f', curHr, curMin, leftTime*100);
                else
                    strTime = sprintf('%02.0f:%04.1f', curMin, leftTime*100);
                end
            otherwise
                disp(sprintf('ERROR: ''%s'' not a recognized unit of time!', TimeTag.Units));
                strTime = sprintf('%.2f', curTime);
        end
        
        if(strcmp(lower(PlotType), 'geoshow'))
            geoshow([yOrig yTime], [xOrig xTime], 'Color', TimeTag.Color);
            textm(yTime, xTime, strTime, 'EdgeColor', TimeTag.Color, 'BackgroundColor', 'w');
        else
            line([xOrig xTime], [yOrig yTime], 'Color', TimeTag.Color);
            text(xTime, yTime, strTime, 'EdgeColor', TimeTag.Color, 'BackgroundColor', 'w');
        end

    end
end

set(gca, 'FontWeight', 'bold');
xstr = [a.Name ' ' a.DataInfo.Units];
ystr = [b.Name ' ' b.DataInfo.Units];
xstr = FormatLabel(xstr);
ystr = FormatLabel(ystr);

if(AllowLabelStrrep)
    xstr = strrep(xstr, '_', '\_');
    ystr = strrep(ystr, '_', '\_');
end

xlabel(xstr, 'FontWeight', 'bold');
ylabel(ystr, 'FontWeight', 'bold');

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

end % << End of function plotts_xy >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi

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
