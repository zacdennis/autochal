% PLOTD Plots X & Y with markers at decimated timesteps
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% plotd:
%   Plots X & Y with markers at decimated timesteps.  Data must be in
%   column format.
%
% SYNTAX:
%	[h] = plotd(XData, YData, Decimation, LineSpec, lstPlotOrder, 'PropertyName', PropertyValue)
%	[h] = plotd(XData, YData, Decimation, LineSpec, lstPlotOrder, varargin)
%	[h] = plotd(XData, YData, Decimation, LineSpec, lstPlotOrder)
%	[h] = plotd(XData, YData, Decimation)
%	[h] = plotd(XData, YData)
%
% INPUTS:
%	Name            Size		Units		Description
%   XData           [m x n]     [varies]    X-axis Data where 'm' is the
%                                            number of timesteps and 'n'
%                                            are the x-values of the 
%                                            different signals to plot
%   YData           [m x n]     [varies]    Y-axis Data where 'm' is the
%                                            number of timesteps and 'n'
%                                            are the y-values of the 
%                                            different signals to plot
%	Decimation      [1] or [k]  [int]       Plot Decimation (Optional)
%                                            If length is...
%                                               1: Adds a marker to every 
%                                                  n-th point.
%                                              >1: Adds a marker at each
%                                                   index specified in
%                                                   array
%                                             Default: Decimation is varied
%                                               to get ~20 markers on plot
%   LineSpec        'string'    [char]      MATLAB shorthand plot notation
%                                            specifying the line type, 
%                                            marker symbol, and color.
%                                            (Optional)
%                                            Default: Function of
%                                            'lstPlotOrder'
%   lstPlotOrder    {y x 3}     [varies]    Plot color, plot marker, and
%                                            line style to use
%                                           Optional: See Note 2 below
%	varargin        [N/A]		[varies]	Any additional plot options
%                                            supported by the MATLAB 
%                                            'plot' command (e.g.
%                                            'LineWidth')
% OUTPUTS:
%	Name            Size		Units		Description
%	h               [n]         [double]    Plot handle(s)
%
% NOTES:
%   [1] The function call allows for variable inputs, so the call is nearly
%       identical to MATLAB's 'plot' (with the addition of the Decimation
%       parameter).
%       So, for example, these calls work too:
%           plotd(XData, YData, 'b*-')
%           plotd(XData, YData, 50, 'b*-')
%           plotd(XData, YData, 50, 'LineWidth', 2, 'MarkerSize', 10)
%   [2] Unless specifically specified via the 'LineSpec', the 'plotd'
%       function will use a color/marker/line style variation set in
%       'lstPlotOrder'.  The function is smart enough to know how many
%       signals have already been plotted on a given figure.  If 'n'
%       signals have been plotted, function will use lstPlotOrder(n+1, :)
%       on the next signal.
%
%       lstPlotOrder(:,1): Line/Marker Color, which can be the MATLAB short
%                           name (e.g. 'b'), long name (e.g. 'blue') or 
%                           RGB triple (e.g. [0 0 1])
%       lstPlotOrder(:,2): Marker Type
%       lstPlotOrder(:,3): LineStyle
%
%       Default lstPlotOrder:
%       lstPlotOrder = {...
%           'b' 'x' '-';    % 1
%           'g' 'x' '-';
%           'r' 'x' '-';
%           'c' 'x' '-';
%           'm' 'x' '-';    % 5
%           'b' 'o' '-';
%           'g' 'o' '-';
%           'r' 'o' '-';
%           'c' 'o' '-';
%           'm' 'o' '-';    % 10
%           'b' 'v' '-';
%           'g' 'v' '-';
%           'r' 'v' '-';
%           'c' 'v' '-';
%           'm' 'v' '-';    % 15
%           'b' '*' '-';
%           'g' '*' '-';
%           'r' '*' '-';
%           'c' '*' '-';
%           'm' '*' '-';    % 20
%           'b' '^' '-';
%           'g' '^' '-';
%           'r' '^' '-';
%           'c' '^' '-';
%           'm' '^' '-';    % 25
%           'b' 's' '-';
%           'g' 's' '-';
%           'r' 's' '-';
%           'c' 's' '-';
%           'm' 's' '-';    % 30
%           'b' 'd' '-';
%           'g' 'd' '-';
%           'r' 'd' '-';
%           'c' 'd' '-';
%           'm' 'd' '-';    % 35
%     };
%
%   % EXAMPLES:
%   clear XData YData;
%   XData = [0:.01:10]';
%   YData(:,1) = sin(XData);
%   YData(:,2) = cos(XData);
%
%   % Example 1: Plot the some data a variety of different ways
%   %   Plot data using regular 'plot' for reference
%   figure()
%   subplot(411);
%   h = plot(XData,YData,'*-');
%   legend(h, '1','2');
%
%   % METHOD # 1 (Preferred)
%   subplot(412);
%   h = plotd(XData, YData, 50);
%   legend(h, '1','2');
%
%   % METHOD # 2
%   subplot(413);
%   h(1) = plotd(XData, YData(:,1), 50);
%   h(2) = plotd(XData, YData(:,2), 50);
%   legend(h, {'1';'2'});
%
%   % METHOD # 3
%   subplot(414);
%   h(1) = plotd(XData, YData(:,1), 50, 'b*-');
%   h(2) = plotd(XData, YData(:,2), 50, 'g*-');
%   legend(h, '1', '2');
%
%   % Example 2: Place markers at specified points
%   figure();
%   h = plotd(XData, YData, [1 10 25 70 400 900], 'MarkerSize', 12);
%
%   % Example 3: Plot data using your own 'lstPlotOrder'
%   figure();
%   lstPlotOrder = {...
%                 'b'           'x'             '-';
%                 'r'           's'             '--';
%                 [.3 .6 .5]    'd'             '-.';
%                 'c'           '+'             ':';
%                 [1 1 0]       '*'             '-';
%                 'k'           'pentagram'     '-.';
%                 };
%   h = plotd(XData, YData, 50, lstPlotOrder)
%   legend(h, {'1';'2'});
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit plotd.m">plotd.m</a>
%	  Driver script: <a href="matlab:edit Driver_plotd.m">Driver_plotd.m</a>
%	  Documentation: <a href="matlab:pptOpen('plotd_Function_Documentation.pptx');">plotd_Function_Documentation.pptx</a>
%
% See also plot
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/496
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/plotd.m $
% $Rev: 2337 $
% $Date: 2012-07-09 19:14:22 -0500 (Mon, 09 Jul 2012) $
% $Author: sufanmi $

function [h] = plotd(XData, YData, varargin)

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

lstPlotOrder = {...
    'b' 'x' '-';    % 1
    'g' 'x' '-';
    'r' 'x' '-';
    'c' 'x' '-';
    'm' 'x' '-';    % 5
    'b' 'o' '-';
    'g' 'o' '-';
    'r' 'o' '-';
    'c' 'o' '-';
    'm' 'o' '-';    % 10
    'b' 'v' '-';
    'g' 'v' '-';
    'r' 'v' '-';
    'c' 'v' '-';
    'm' 'v' '-';    % 15
    'b' '*' '-';
    'g' '*' '-';
    'r' '*' '-';
    'c' '*' '-';
    'm' '*' '-';    % 20
    'b' '^' '-';
    'g' '^' '-';
    'r' '^' '-';
    'c' '^' '-';
    'm' '^' '-';    % 25
    'b' 's' '-';
    'g' 's' '-';
    'r' 's' '-';
    'c' 's' '-';
    'm' 's' '-';    % 30
    'b' 'd' '-';
    'g' 'd' '-';
    'r' 'd' '-';
    'c' 'd' '-';
    'm' 'd' '-';    % 35
    };

% numColors = length(arrColors);
numDataPts  = size(XData,1);
numXCols    = size(XData,2);
numYCols    = size(YData,2);

%% Input Argument Checking:
Decimation = [];
if(~isempty(varargin))
    posDecimation = varargin{1};
    if( isempty(posDecimation) || isnumeric(posDecimation) )
        Decimation = posDecimation;
        
        if(length(varargin) == 1)
            varargin = {};
        else
            varargin = varargin(2:end);
        end
    end
end

%% Check to see if User used a short string to define plot
%  Note that this string would be the 1st element in varargin, IF if is
%  indeed defined.  If it is defined (e.g. 'bx-'), it could be only
%  partially defined (e.g. 'b', 'x', '-', 'x-').  This section looks at the
%  first element and attempts to figure out if it is indeed a short string,
%  and if so, what the intended marker, color, and/or line style is
%  desired.
Color2Use   = '';   ColorSpecified  = 0;
Marker2Use  = '';   MarkerSpecified = 0;
Line2Use    = '';   LineSpecified   = 0;
if(~isempty(varargin))
    posUserMarker = varargin{1};
    
    if( ~isempty(posUserMarker) && (ischar(posUserMarker)) )
        % Support Long Name Marker Specifiers:
        posUserMarker = strrep(posUserMarker, 'square', 's');
        posUserMarker = strrep(posUserMarker, 'diamond', 'd');
        posUserMarker = strrep(posUserMarker, 'pentagram', 'p');
        posUserMarker = strrep(posUserMarker, 'hexagram', 'h');
        
        if(length(posUserMarker) <= 4)
            % Maximum Length is 4 (e.g. 'b' + 'x' + '--')
            lstDefaultLineStyle = {'--'; ':'; '-.';'-'};
            lstDefaultMarkers   = {'+'; 'o'; '*'; 'x'; 's'; ...
                'd'; '^'; 'v'; '>'; '<'; 'p'; 'h'};
            lstDefaultColors    = {'r'; 'g'; 'b'; 'c'; 'm'; 'y'; 'k'; 'w'};
            
            cmpLineStyle = regexp(posUserMarker, lstDefaultLineStyle);
            cmpMarker    = regexp(posUserMarker, lstDefaultMarkers);
            cmpColor     = regexp(posUserMarker, lstDefaultColors);
            
            for i = 1:length(cmpLineStyle)
                if(~isempty(cmpLineStyle{i}))
                    Line2Use = lstDefaultLineStyle{i};
                    LineSpecified = 1;
                    break;
                end
            end
            
            for i = 1:length(cmpMarker)
                if(~isempty(cmpMarker{i}))
                    Marker2Use = lstDefaultMarkers{i};
                    MarkerSpecified = 1;
                    break;
                end
            end
            
            for i = 1:length(cmpColor)
                if(~isempty(cmpColor{i}))
                    Color2Use = lstDefaultColors{i};
                    ColorSpecified = 1;
                    break;
                end
            end
            
            if(length(varargin) == 1)
                varargin = {};
            else
                varargin = varargin(2:end);
            end

        end
    else
        if(isempty(posUserMarker))
            
            if(length(varargin) == 1)
                varargin = {};
            else
                varargin = varargin(2:end);
            end
        end
    end
end

%% Check to see if the User has provided a lstPlotOrder:
if(~isempty(varargin))
    poslstPlotOrder = varargin{1};
    if(isempty(poslstPlotOrder))
        if(length(varargin) == 1)
            varargin = {};
        else
            varargin = varargin(2:end);
        end
    else
        
        if(iscell(poslstPlotOrder))
            lstPlotOrder = poslstPlotOrder;
            
            if(length(varargin) == 1)
                varargin = {};
            else
                varargin = varargin(2:end);
            end
        end
    end
end
numPlotOrder = size(lstPlotOrder, 1);

if(isempty(Decimation))
    Decimation = floor(numDataPts/20);
end

if(length(Decimation) > 1)
    % User Specified Down Sample
    ptrDownSample = floor(Decimation);
    ptrDownSample = max(ptrDownSample, 1);
    ptrDownSample = min(ptrDownSample, numDataPts);
    ptrDownSample = unique(ptrDownSample);

else
    Decimation = max(Decimation, 1);
    if(Decimation > numDataPts)
        Decimation = 2;
    end
    Decimation = floor(Decimation);
    if(Decimation == 1)
        ptrDownSample = 1:numDataPts;
    else
        ptrDownSample = unique([1 find(mod([1:numDataPts], Decimation) == 0) numDataPts]);
    end
end

%% Adjust XData to the same size as YData:
if(numXCols ~= numYCols)
    XData = repmat(XData, 1, numYCols);
end

%% Figure out how many lines already exist in current figure:
arrChildren = get(gca, 'Children');
ptrLine1 = 1;
for i = 1:length(arrChildren)
    ptrLine1 = ptrLine1 + strcmp(get(arrChildren(i), 'Type'), 'line')/3;
end
ptrLine = round(ptrLine1);

%% Plot Section 1: Plot the line that the legend will use:
for iCol = 1:numYCols
    
    %% Define color/marker/line if not provided:
    iPlotOrder = min(iCol+ptrLine-1, numPlotOrder);
    
    if(~ColorSpecified)
        Color2Use = lstPlotOrder{iPlotOrder, 1};
    end
    
    if(~MarkerSpecified)
        Marker2Use = lstPlotOrder{iPlotOrder, 2};
    end
    
    if(~LineSpecified)
        Line2Use = lstPlotOrder{iPlotOrder, 3};
    end
    
    %% Plot the Data:
    % The legend's line: the markers with the lines
    XData1(1:2) = XData(1);
    YData1(1:2) = YData(1,iCol);
    
    % The Full Line: Just the line without markers
    XData2 = XData(:,iCol);
    YData2 = YData(:,iCol);
    
    % The Downsampled Line: Just the reduced markers without lines
    XData3 = XData(ptrDownSample, iCol);
    YData3 = YData(ptrDownSample, iCol);
    
    % The legend's line: the markers with the lines
    h(iCol,:) = plot(XData1, YData1, 'Color', Color2Use, 'Marker', Marker2Use, 'LineStyle', Line2Use, varargin{:});
    if iCol == 1
        hold on;
    end
    
    % The Full Line: Just the line without markers
    plot(XData2, YData2, 'Color', Color2Use, 'LineStyle', Line2Use, varargin{:}, 'Marker', 'none');
    % The Downsampled Line: Just the reduced markers without lines
    plot(XData3, YData3,  'Color', Color2Use, 'Marker', Marker2Use, varargin{:}, 'LineStyle', 'none');
end

end % << End of function plotd >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110908 MWS: Overhauled function so user can specify the plot order.  Also
%               added ability to specify an array for Decimation.
% 101019 MWS: Cleaned up function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
