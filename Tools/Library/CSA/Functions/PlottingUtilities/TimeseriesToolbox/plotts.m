% PLOTTS Plots a time-series or cell array of time-series signals
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% plotts:
%  Plots a time-series or cell array of time-series signals
% 
% SYNTAX:
%	[h, lh] = plotts(cell_ts, varargin, 'PropertyName', PropertyValue)
%	[h, lh] = plotts(cell_ts, varargin)
%	[h, lh] = plotts(cell_ts)
%
% INPUTS: 
%	Name    	Size            Units		Description
%	cell_ts     {timeseries     [varies]    Timeseries to plot
%                 cell array}
%	varargin	[N/A]           [varies]	Optional function inputs that
%                                           should be entered in pairs.
%                                           See the 'VARARGIN' section
%                                           below for more details
% OUTPUTS: 
%	Name    	Size            Units		Description
%	h   	    [1xM]           [double]    Handles to Figures
%   lh          [1xN]           [double]    Handles to Legends
%
% NOTES:
%	Uses the CSA Library functions 'format_varargin' and 'plotd'
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%  'ForceLegend'        0 or 1          1           Lists signals and units 
%                                                   as legend entries
%  'SplitHeader'        0 or 1          0           Shortens legend entries 
%                                                    by moving partial
%                                                    strings to the ylabel.
%                                                    Only used if 
%                                                   'ForceLegend' is 0.
%  'xmin'               [double]        []          Minimum plot bound
%  'xmax'               [double]        []          Maximum plot bound
%  'TimeTagUnits'       'string'        'sec'       Time Units to use for
%                                                    plotting.  Options:
%                                                    'msec', {'sec'}, 'min',
%                                                    'hr', 'day'
%  'DecimationType'     1 or 2          2           Marker Plotting Method
%                                                   1: Datapoint based
%                                                      (place marker every
%                                                      n datapoints)
%                                                   2: Time based
%                                                       (place marker every
%                                                       n timesteps), where
%                                                       timestep is
%                                                       determined by
%                                                       'TimeTagUnits'
%  'Decimation'         [int]           5           Plotting decimation for 
%                                                    markers
%  'UseShortName'       0 or 1          0           Remove Path Lineage
%  'LineWidth'          [double]        1.5         Line Width
%  'MarkerSize'         [int]           10          Marker Size
%  'Index'              [int]           []          If a timeseries is
%                                                   vectorized, specifies 
%                                                   which indices to plot;
%                                                   Default is all.
%
% EXAMPLES:
%   % Example 1: Create and Plot some Timeseries Data
%   %   Create 1st timeseries
%   clear SampleResults;
%   t = [0:0.01:10]*C.MIN2SEC;
%   y = sin(t/100);
%   ts = timeseries(y', t');
%   ts.Name = 'ElevatorPos';
%   ts.DataInfo.Units = '[deg]';
%   SampleResults.Elevator = ts; clear t y ts;
%
%   % Create 2nd timeseris
%   t2 = [0:.1:10]*C.MIN2SEC;
%   y2 = cos(t2/50);
%   ts2 = timeseries(y2', t2');
%   ts2.Name = 'RudderPos';
%   ts2.DataInfo.Units = '[deg]';
%   SampleResults.Rudder = ts2; clear t2 y2 ts2;
% 
%   figure();
%   subplot(211);
%   h = plotts({SampleResults.Elevator; SampleResults.Rudder}, 'Decimation', 30);
%   title('Plotting Data with Markers every 30 seconds');
% 
%   subplot(212);
%   h = plotts({SampleResults.Elevator; SampleResults.Rudder}, 'Decimation', 2, 'TimeTagUnits', 'min');
%   legend(h, {'Elevator (100 Hz)';'Rudder (50 Hz)'});
%   title('Plotting Data with Markers every 2 minutes');
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit plotts.m">plotts.m</a>
%	  Driver script: <a href="matlab:edit Driver_plotts.m">Driver_plotts.m</a>
%	  Documentation: <a href="matlab:pptOpen('plotts_Function_Documentation.pptx');">plotts_Function_Documentation.pptx</a>
%
% See also format_varargin, plotd 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/499
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/plotts.m $
% $Rev: 3261 $
% $Date: 2014-10-08 15:51:08 -0500 (Wed, 08 Oct 2014) $
% $Author: sufanmi $

function [h, lh] = plotts(cell_ts, varargin)

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

varargin2 = varargin;
[PO.ForceLegend, varargin]      = format_varargin('ForceLegend', 1, 2, varargin);
[PO.SplitHeader, varargin]      = format_varargin('SplitHeader', 0, 2, varargin);
[PO.xmin, varargin]             = format_varargin('xmin', [], 2, varargin);
[PO.xmax, varargin]             = format_varargin('xmax', [], 2, varargin);
[PO.TimeTagUnits, varargin]     = format_varargin('TimeTagUnits', 'sec', 2, varargin);
[PO.Decimation, varargin]       = format_varargin('Decimation', 5, 2, varargin);
[PO.DecimationType, varargin]   = format_varargin('DecimationType', 2, 2, varargin);
[PO.UseShortName, varargin]     = format_varargin('UseShortName', 0, 2, varargin);
[PO.LineWidth, varargin]        = format_varargin('LineWidth', 1.5, 2, varargin);
[PO.MarkerSize, varargin]       = format_varargin('MarkerSize', 10, 2, varargin);
[PO.FontSize, varargin]         = format_varargin('FontSize', 10, 2, varargin);
[PO.LegendLoc, varargin]        = format_varargin('LegLoc', 'NorthEast', 2, varargin);
[PO.IncludeUnits, varargin]     = format_varargin('IncludeUnits', 1, 2, varargin);
[PO.Indices, varargin]          = format_varargin('Index', [], 2, varargin);
[PO.MangleName, varargin]       = format_varargin('MangleName', 1, 2, varargin);
[PO.PlotOrder, varargin]        = format_varargin('PlotOrder', {}, 2, varargin);

if(~iscell(cell_ts))
    cell_ts = { cell_ts };
end

num_ts = size(cell_ts, 1);
numCols = size(cell_ts, 2);

iSignal = 0;

switch lower(PO.TimeTagUnits)
    case 'msec'
        strTimeUnits = '[msec]';
        kTime = 1e3;
    case 'sec'
        strTimeUnits = '[sec]';
        kTime  = 1;
    case 'min'
        strTimeUnits = '[min]';
        kTime  = 1/(60);
    case 'hr'
        strTimeUnits = '[hr]';
        kTime  = 1/(60*60);
    case 'day'
        strTimeUnits = '[day]';
        kTime  = 1/(60*60*24);
    otherwise
        strTimeUnits = '[sec]';
        kTime  = 1;
end
strTime = ['Time ' strTimeUnits];

for i_ts = 1:num_ts
    ts = cell_ts{i_ts, 1};
    
    xdata = ts.Time;
    dt = xdata(2) - xdata(1);
    ydata = ts.Data;
    
    num_ydata = size(ydata, 2);
    
    if(isempty(PO.Indices))
        PO.Indices = [1:num_ydata];
    else
        % Error checking
        PO.Indices = intersect(PO.Indices, [1:num_ydata]);
        if(isempty(PO.Indices))
            PO.Indices = [1:num_ydata];
        end
    end
    
    flgAppendIndex = 0;
    if(numCols > 1)
        lines2use = cell_ts{i_ts, 2};
        if(isempty(lines2use))
            lines2use = [1:num_ydata];
            flgAppendIndex = (num_ydata > 1);
        end
    else
        lines2use = PO.Indices;
        flgAppendIndex = (lines2use > 1);
%         lines2use = [1:num_ydata];
    end
       
    numLines = length(lines2use);
    
    for iLine = 1:numLines;
        curline2use = lines2use(iLine);
        
        xdata2plot = xdata * kTime;
        ydata2plot = ydata(:,curline2use);
        curUnits = ts.DataInfo.Units;
        
        if(flgAppendIndex)
            curSignal = sprintf('%s(:,%d)', ts.Name, curline2use);
        else
            curSignal = ts.Name;
        end
%         if((numLines == 1) && (numCols == 1))
%             curSignal = ts.Name;
%         else
%             curSignal = sprintf('%s(:,%d)', ts.Name, curline2use);
%         end
        curSignal = FormatLabel(curSignal);
        
        if(PO.UseShortName == 2)
            if(~isempty(ts.DataInfo.UserData))
                curSignal = [ts.DataInfo.UserData ': ' curSignal];
            end
        end
                
        iSignal = iSignal + 1;
        lstSignal(iSignal,:) = {curSignal};
        lstUnits(iSignal,:) = {curUnits};
        if((PO.IncludeUnits) && (PO.ForceLegend == 0))
            lstSignalUnits(iSignal,:) = {[curSignal ' ' curUnits]};
        else
            lstSignalUnits(iSignal,:) = {curSignal};
        end

        ptrPeriod = findstr(curSignal, '.');
        curSignalNoHead = '';
        curHead = '';
        strShort = curSignal;
        if(~isempty(ptrPeriod))
            curSignalNoHead = curSignal((ptrPeriod(1)+1):end);
            curHead = curSignal(1:(ptrPeriod(1)-1));
            
            strShort = curSignal((ptrPeriod(end)+1):end);           
        end
        if(PO.IncludeUnits)
            lstShortUnits(iSignal,:) = {[strShort ' ' curUnits]};
        else
            lstShortUnits(iSignal,:) = {strShort};
        end
        lstSignalNoHead(iSignal,:) = {curSignalNoHead};
        lstHead(iSignal,:) = {curHead};
        
        if(PO.DecimationType == 1)
            % Datapoint based
            Decimation = PO.Decimation;
        else
            % Time Based
            numPts  = length(xdata);
            tStart  = floorDec(xdata(1)*kTime, PO.Decimation*kTime);
            tEnd    = ceilDec(xdata(numPts)*kTime, PO.Decimation*kTime);
            tRef    = [tStart : PO.Decimation : tEnd ];
            iRefRaw = Interp1D(xdata*kTime, [1:numPts], tRef);
            iRef    = unique([iRefRaw 1 numPts]);
            Decimation = floor(iRef);
        end       
        
        if(mod(length(varargin), 2))
            % varargin is odd, assume 1st element is a plot string type
            % (e.g. 'bx-')
            LineSpec = varargin{1};
             if(length(varargin) == 1)
                varargin = {};
            else
                varargin = varargin(2:end);
             end
        else
            LineSpec = '';
        end

        h(iSignal) = plotd(xdata2plot, ydata2plot, Decimation, LineSpec, PO.PlotOrder,  ...
            'LineWidth', PO.LineWidth, 'MarkerSize', PO.MarkerSize, varargin{:});
    end
end

unique_yunits = unique(lstUnits);
num_unique_yunits = size(unique_yunits, 1);

if((iSignal == 1) && (PO.ForceLegend == 0))
    % Plot Option #1: Y label and No Legend
     if(PO.UseShortName)
            ystr = lstShortUnits;
     else
         ystr = lstSignalUnits;
     end
    lstLegend = '';
    
else
    % More Plot Options
    
    if((num_unique_yunits == 1) && (PO.ForceLegend == 0))
        % Plot Signal to Ylabel:
        unique_signals = unique(lstSignalNoHead);
        num_unique_signals = size(unique_signals, 1);
        
        if((num_unique_signals == 1) && (PO.SplitHeader))
            ystr = [unique_signals{1} ' ' unique_yunits{1}];
            lstLegend = lstHead;
        else
            ystr = unique_yunits;
            lstLegend = lstSignal;
        end
    else
        
        if(num_unique_yunits == 1)
            ystr = unique_yunits{1};
        else
            ystr = '';
        end
        
        if(PO.UseShortName)
            lstLegend = lstShortUnits;
        else
            lstLegend = lstSignalUnits;
        end
    end
end

if(PO.MangleName)
    ystr = MangleName(ystr);
    lstLegend = MangleName(lstLegend, 0);
end


set(gca, 'FontWeight', 'bold');
grid on;
xlabel(strTime, 'FontWeight', 'bold', 'FontSize', PO.FontSize);

if(~isempty(ystr))
    ystr = strrep(ystr, '_', '\_');
    ylabel(ystr, 'FontWeight', 'bold', 'FontSize', PO.FontSize);
end

if(~isempty(lstLegend))
    if(strcmp(lower(PO.LegendLoc), 'none'))
        lh = [];
    else
        lstLegend = strrep(lstLegend, '_', '\_');
        lh = legend(h,lstLegend, 'FontWeight', 'bold','Location', PO.LegendLoc);
    end
else
    lh = [];
end

xlimits = xlim;
if(~isempty(PO.xmin))
    xlimits(1) = PO.xmin;
    
    if(~isempty(PO.xmax))
        xlimits(2) = PO.xmax;
    end
    
    xlim(xlimits);
end

end % << End of function plotts >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110511 MWS: Added ability to specify indices of a given timeseries to
%               plot.
% 110307 MWS: Added ability to place legend location and not show units in
%             the legend string, if desired
% 101019 CNF: Cleaned up function using CreateNewFunc
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