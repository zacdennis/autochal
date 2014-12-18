% PLOT_ND_DATA Generic 1 to 6-D table plotting routine
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Plot_nD_Data:
%   This is a generic plot routine for plotting 1 to 6-dimensional tables.
%
% SYNTAX:
%	Plot_nD_Data(TableND, strLabel, lstIDV, lstDV, varargin, 'PropertyName', PropertyValue)
%	Plot_nD_Data(TableND, strLabel, lstIDV, lstDV, varargin)
%	Plot_nD_Data(TableND, strLabel, lstIDV, lstDV)
%
% INPUTS:
%	Name    	Size		Units		Description
%	TableND		{struct}    N/A         Structure with 1 to 6-D Table Data
%	strLabel	'string'                Master Label of Data
%	lstIDV		{Nx4}       'string'	Cell array list of Independent
%                                        Variables (IV)
%    lstIDV{:,1}            'string'    Name of IV in TableND
%    lstIDV{:,2}            'string'    Units for IV in TableND
%    lstIDV{:,3}            'string'    IV name to plot on figure (TeX)
%                                        Optional Entry
%                                        Default: Same as lstIDV{:,1}
%    lstIDV{:,4}             [double]    Breakpoints to lookup
%                                        Optional Entry
%                                        Default: blank (all available)
%	lstDV		{Mx3}       'string'    Cell array of Dependent Variables
%                 or {Mx5}               (DV) to Plot
%    lstDV{:,1}              'string'    Name of DV in TableND to plot on
%                                         Y-axis
%    lstDV{:,2}              'string'    DV string to use for plotting
%                                        (works with TeX)
%    lstDV{:,3}              'string'    Legend Location (only needed if
%                                        'PlotSingle' is true OR if no
%                                        master 'legend' defined)
%    lstDV{:,4}              'string'   Name of DV in TableND to plot on
%                                        X-axis if plotting DV1 vs DV2
%    lstDV{:,5}              'string'   DV string to use for plotting
%                                        (works with TeX)
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
% OUTPUTS:
%	Name		Size		Units		Description
%   None
%
% NOTES:
%   You should always use this function with the additional 'VARARGIN'
%   properties 'XAxisIndex' and 'LegIndex'
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'XAxisIndex'        [1]             1           Index of IV for x-axis
%   'LegIndex'          [1]             2           Index of IV for legends
%   'PlotSingle'        [bool]          0           Plot Each DV on
%                                                    separate plot?
%   'PlotDim'           [1 x 2]         varies      Arrangement of subplot
%                                                    figures
%   'LabelFontSize'     [int]           12          X&Y axis label FontSize
%   'TitleFontSize'     [int]           12          Title Font Size
%   'LineWidth'         [double]        1.5         Figure line width
%   'MarkerSize'        [double]        10          Figure marker size
%   'FigPosition'       [1x4]           []          Figure Position
%   'LegPosition'       [1x4]           []          Legend Position
%   'PlotDec'           [1]             1           Plot Decimation (Plot
%                                                   every n-th point)
%   'UniformYLimits'    [bool]          0           For multi-plot figures,
%                                                   standardize the
%                                                   y-limits for all
%                                                   non-legend plots?
%   'TitleLine1'        'string'        ''          String to use for the
%                                                   1st row of the plot
%                                                   title.  Will use
%                                                   TableND.Title if blank
%   'TitleLine2'        'string'        ''          Dependent Variable
%                                                   string to use on the
%                                                   2nd line of the plot
%                                                   title.  Will
%                                                   autocompute this based
%                                                   on 'lstDV' if blank.
%
%   Default Plot Dimensions, 'PlotDim', are based on the number of
%   dependent variables (DV) listed in 'lstDV'. If the number of DVs is
%   greater than 1, subplots will be used according to the follow table:
%       # of DV         Plot Dimensions
%       1               [1 1]
%       2               [1 2]
%       3               [1 3]
%       4               [2 2]
%       5+              [ceil(# of DV/3) 3]
%   Hence, if 'lstDV' has 4 members, then each figure will have 4 subplots,
%   arranged in a 2x2 format, with the 1st member being in the upper left
%   corner, the 2nd in the upper right, the 3rd in the lower left, and the
%   4th in lower right.
%
% EXAMPLES:
% %% Example #1: Show Plot_nD_Data for a simple 3-D Table
% %  We'll create a simple 3-D Engine Model where engine thrust and fuel
% %  flow are functions of throttle, altitude, and mach number.
% %
% %  Step 1a: Create the Reference n-D Table
% TableND.Title = 'Example Engine Model';
% TableND.Description = '(Thrust [lbf], Fuel Flow [slug/sec]) = fcn(Throttle [%], Alt [ft], Mach [ND])';
% %  Step 1b: Define the breakpoints and add them to the table
% arrThrottle = [0:50:100];       % [%]
% arrAlt      = [0:10000:30000];  % [ft]
% arrMach     = [0:0.2:0.8];      % [ND]
% TableND.Throttle = arrThrottle;
% TableND.Alt     = arrAlt;
% TableND.Mach    = arrMach;
% % Step 1c: Build the reference tables for thrust and fuel flow based on
% %           some idealized parameters
% maxThrust   = 8000;     % [lbf]
% maxFuelFlow = 0.03;     % [slug/sec]
% tblThrust = zeros(length(arrThrottle), length(arrAlt), length(arrMach));
% % Loop through each Mach number
% for iMach = 1:length(arrMach)
%     scaleMach = iMach/length(arrMach);
%     % Loop through each Altitude
%     for iAlt = 1:length(arrAlt)
%        scaleAlt = 1 - (iAlt/length(arrAlt))^2*.2;
%         % Loop through each throttle
%         for iThrottle = 1:length(arrThrottle)
%             curThrottle = arrThrottle(iThrottle);   % [%] Current Throttle
%             % Create some Thrust and Fuel Flow Data and add to TableND
%             curThrust = interp1([0 100], [0 maxThrust], curThrottle) ...
%                 * scaleAlt * scaleMach;     % [lbf]
%             curFuelFlow = interp1([0 100], [0 maxFuelFlow], curThrottle) ...
%                 * scaleAlt * scaleMach;     % [lbf]
%             TableND.Thrust(iThrottle, iAlt, iMach) = curThrust;
%             TableND.FuelFlow(iThrottle, iAlt, iMach) = curFuelFlow;
%         end
%     end
% end
% % Step 2: Setup and run Plot_nD_Data
% % Step 2a: Compile the list of independent variables
% % lstIDV(:,1): Name of the Independent Variable in 'TableND'
% % lstIDV(:,2): Units to use for each IV
% % lstIDV(:,3): Name to actually plot (TeX enabled); optional input
% % lstIDV(:,4): Breakpoints to use (use [] for all); optional input
% lstIDV = {...
%     'Throttle', '[%]', '',          [];
%     'Alt',      '[ft]', 'Altitude', [];
%     'Mach',     '[ND]', 'Mach',     [0.4]};
% % Step 2b: Compile the list of dependent variables
% %          This is the plotting order to use.  For multiple DV's, it might
% %          be desired to have just one legend.  In that case, just specify
% %          that 'legend' be used
% % lstDV(:,1): Name of the Dependent Variable in 'TableND'
% % lstDV(:,2): String to use for plotting (TeX enabled)
% % lstDV(:,3): Legend Location to use if 'PlotSingle' is 'true'
% lstDV = { ...
%     'Thrust'    'Thrust [lbf]';
%     'FuelFlow'  'Fuel Flow [slug/sec]';
%     'legend'    '';
%     };
% % Step 3: Call Plot_nD_Data a variety of ways
% % Example 1.1: Create one figure with multiple subplots of each DV. Specify
% %              the 1st DV (Throttle) to be on the x-axis and the 2nd DV
% %              (Altitude) to be in the legend.
% Plot_nD_Data(TableND, TableND.Title, lstIDV, lstDV, 'XAxisIndex', 1, ...
%     'LegIndex', 2);
% % Note that you could also have called it like this:
% Plot_nD_Data(TableND, TableND.Title, lstIDV, lstDV, 'XAxisIndex', 'Throttle', ...
%     'LegIndex', 'Alt');
%
% % Example 1.2: Create individual figures for each DV with the same axes
% %              configuration as before.
% Plot_nD_Data(TableND, TableND.Title, lstIDV, lstDV, 'XAxisIndex', 1, ...
%     'LegIndex', 2, 'PlotSingle', 1);
% % Example 1.3: Plot Throttle vs. Mach at 15000 [ft]
% %              Note: 15,000 [ft] is NOT a breakpoint, but it'll
% %                   interpolate it there just fine
% lstIDV(3,4) = { [] };       % Free up the Mach breakpoints to use
% lstIDV(2,4) = { [15000] };  % Set the Altitude breakpoints to use
% Plot_nD_Data(TableND, TableND.Title, lstIDV, lstDV, 'XAxisIndex', 1, ...
%     'LegIndex', 3);
% % Example 1.4: Same as 1.3, but plot Mach vs. Throttle
% Plot_nD_Data(TableND, TableND.Title, lstIDV, lstDV, 'XAxisIndex', 3, ...
%     'LegIndex', 1);
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Plot_nD_Data.m">Plot_nD_Data.m</a>
%	  Driver script: <a href="matlab:edit Driver_Plot_nD_Data.m">Driver_Plot_nD_Data.m</a>
%	  Documentation: <a href="matlab:pptOpen('Plot_nD_Data_Function_Documentation.pptx');">Plot_nD_Data_Function_Documentation.pptx</a>
%
% See also plotd, Interp3D, Interp4D, Interp5D, Interp6D
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/581
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/Plot_nD_Data.m $
% $Rev: 3027 $
% $Date: 2013-10-09 14:37:00 -0500 (Wed, 09 Oct 2013) $
% $Author: sufanmi $

function Plot_nD_Data(TableND, strLabel, lstIDV, lstDV, varargin)

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

%% Main Function:

[rawXAxisIndex, varargin]   = format_varargin('XAxisIndex', '', 2, varargin);
[rawLegIndex, varargin]     = format_varargin('LegIndex', '', 2, varargin);
[plotSingles, varargin]     = format_varargin('PlotSingle', false, 2, varargin);
[plot_dim, varargin]        = format_varargin('PlotDim', [], 2, varargin);
[LabelFontSize, varargin]   = format_varargin('LabelFontSize', 12, 2, varargin);
[TitleFontSize, varargin]   = format_varargin('TitleFontSize', 12, 2, varargin);
[TitleFontSize2, varargin]  = format_varargin('TitleFontSize2', 10, 2, varargin);
[lw, varargin]              = format_varargin('LineWidth', 1.5, 2, varargin);
[ms, varargin]              = format_varargin('MarkerSize', 10, 2, varargin);
[FigPos, varargin]          = format_varargin('FigPosition', [], 2, varargin);
[LegPos, varargin]          = format_varargin('LegPosition', [], 2, varargin);
[PlotDec, varargin]         = format_varargin('PlotDec', 1, 2, varargin);
[UniformYLimits, varargin]  = format_varargin('UniformYLimits', 0, 2, varargin);
[TitleLine1, varargin]      = format_varargin('TitleLine1', '', 2, varargin);
[TitleLine2, varargin]      = format_varargin('TitleLine2', '', 2, varargin);
% [StartMarkMarker, varargin] = format_varargin('StartMarkMarker', 'h', 2, varargin);
% [StartMarkColor, varargin]  = format_varargin('StartMarkColor', 'k', 2, varargin);
% [EndMarkMarker, varargin]   = format_varargin('EndMarkMarker', 'v', 2, varargin);
% [EndMarkColor, varargin]    = format_varargin('EndMarkColor', 'k', 2, varargin);

iFig = 0;

numDV = size(lstDV, 1);
numIDV = size(lstIDV, 1);

if(numDV == 1)
    plotSingles = 1;
end

if(ischar(rawXAxisIndex))
    % The name of the Independent Variable was provided instead.  Determine
    % the index
    for iIDV = 1:numIDV
        curIDV = lstIDV{iIDV, 1};
        if(strmatch(lower(curIDV), lower(rawXAxisIndex)))
            XAxisIndex = iIDV;
            break;
        end
    end
else
    XAxisIndex = rawXAxisIndex;
end

if(ischar(rawLegIndex))
    % The name of the Independent Variable was provided instead.  Determine
    % the index
    for iIDV = 1:numIDV
        curIDV = lstIDV{iIDV, 1};
        if(strmatch(lower(curIDV), lower(rawLegIndex)))
            LegIndex = iIDV;
            break;
        end
    end
else
    LegIndex = rawLegIndex;
end

for iIDV = 1:numIDV
    curIDV = lstIDV{iIDV, 1};
    [IDV_Values_to_use, varargin]  = format_varargin(curIDV, [], 2, varargin);
    
    if(~isempty(IDV_Values_to_use))
        lstIDV{iIDV, 4} = IDV_Values_to_use;
    end
end
[numIDV, numColIDV] = size(lstIDV);

if(iscell(strLabel))
    strLabel = cell2str(strLabel, endl);
end
if(~isempty(TitleLine1))
    strTitle1 = sprintf('\\bf\\fontsize{%d}%s', TitleFontSize, TitleLine1);
else
    strTitle1 = sprintf('\\bf\\fontsize{%d}%s', TitleFontSize, strLabel);
end

%% Build strTitle2
strTitle2_DV = sprintf('\\bf\\fontsize{%d}', TitleFontSize2);
flg = 0;
lstUsedDV = {}; iUsedDV = 0;
for iPlot = 1:numDV;
    strData = lstDV{iPlot, :};
    
    if(~strcmp(lower(strData), 'legend'))
        
        flgMatch = any(strcmp(lstUsedDV, strData));
        if(~flgMatch)
            iUsedDV = iUsedDV + 1;
            lstUsedDV(iUsedDV) = { strData };
            
            if(size(lstDV, 2) > 1)
                strDataLabel = lstDV{iPlot, 2};
            else
                strDataLabel = '';
            end
            
            if(isempty(strDataLabel))
                strDataLabel = strData;
            end
            
            if(flg == 0)
                strTitle2_DV = sprintf('%s%s', strTitle2_DV, strDataLabel);
                flg = 1;
            else
                strTitle2_DV = sprintf('%s, %s', strTitle2_DV, strDataLabel);
            end
        end
    end
end
if(~isempty(TitleLine2))
    strTitle2_DV = TitleLine2;
end

if(isempty(plot_dim))
    switch numDV
        case 1
            plot_dim = [1 1];
        case 2
            plot_dim = [1 2];
        case 3
            plot_dim = [1 3];
        case 4
            plot_dim = [2 2];
        otherwise
            plot_dim(1) = ceil(numDV/3);
            plot_dim(2) = 3;
    end
end

if( (isnumeric(XAxisIndex)) && (~isempty(XAxisIndex)) )
    % Overwrite XAxisIndex
    plotOrder(1) = XAxisIndex;
    if( (isnumeric(LegIndex)) && (~isempty(LegIndex)) )
        % Overwrite LegIndex
        plotOrder(2) = LegIndex;
    end
    
else
    if( (isnumeric(LegIndex)) && (~isempty(LegIndex)) )
        arrIndicesLeft = setxor(LegIndex, [1:numIDV]);
        plotOrder(1) = arrIndicesLeft(1);
        plotOrder(2) = LegIndex;
    end
end

if(numIDV > 1)
    arrOrders2Add = setxor(plotOrder, [1:numIDV]);
    if(~isempty(arrOrders2Add))
        plotOrder = [plotOrder arrOrders2Add];
    end
else
    plotOrder = 1;
end

for iIDV = 1:numIDV
    eval(sprintf('ID%d = lstIDV{%d, 1};', iIDV, iIDV));
    eval(sprintf('ID%dunits = lstIDV{%d, 2};', iIDV, iIDV));
    eval(sprintf('arrID%d = TableND.(ID%d);', iIDV, iIDV));
    
    if(numColIDV > 2)
        strID = lstIDV{iIDV, 3};
        if(~isempty(strID))
            eval(sprintf('strID%d = strrep(lstIDV{%d, 3}, ''_'', ''\\_'');', iIDV, iIDV));
        else
            eval(sprintf('strID%d = strrep(ID%d, ''_'', ''\\_'');', iIDV, iIDV));
        end
    else
        eval(sprintf('strID%d = strrep(ID%d, ''_'', ''\\_'');', iIDV, iIDV));
    end
    
    if(numColIDV > 3)
        eval(sprintf('lookupID%d = lstIDV{%d, 4};', iIDV, iIDV));
    else
        eval(sprintf('lookupID%d = [];', iIDV));
    end
    
    eval(sprintf('flgEmpty = isempty(strID%d);', iIDV));
    if(flgEmpty)
        eval(sprintf('strID%d = strrep(ID%d, ''_'', ''\\_'');', iIDV, iIDV));
    end
    
    eval(sprintf('flgEmpty = isempty(lookupID%d);', iIDV));
    if(flgEmpty)
        eval(sprintf('lookupID%d = arrID%d;', iIDV, iIDV));
    end
end

%%
for iIDV = 1:numIDV
    eval(sprintf('lookupID_PO%d = lookupID%d;', iIDV, plotOrder(iIDV)));
    eval(sprintf('ID_PO%d = ID%d;', iIDV, plotOrder(iIDV)));
    eval(sprintf('ID_PO%d_units = ID%dunits;', iIDV, plotOrder(iIDV)));
    eval(sprintf('strID_PO%d = strID%d;', iIDV, plotOrder(iIDV)));
    eval(sprintf('arrID_PO%d = arrID%d;', iIDV, plotOrder(iIDV)));
    eval(sprintf('num_lookupID_PO%d = length(lookupID_PO%d);', iIDV, iIDV));
end

if(numIDV < 2)
    num_lookupID_PO2 = 1;
end

if(numIDV < 3)
    num_lookupID_PO3 = 1;
end

if(numIDV < 4)
    num_lookupID_PO4 = 1;
end

if(numIDV < 5)
    num_lookupID_PO5 = 1;
end

if(numIDV < 6)
    num_lookupID_PO6 = 1;
end

% Determine if 'legend' exists in lstDV
flgSepLeg = 0;
for iPlot = 1:size(lstDV, 1);
    strData = lstDV{iPlot, :};
    if(strcmp(lower(strData), 'legend'))
        flgSepLeg = 1;
        break;
    end
end

if(plotSingles)
    numRows = size(lstDV, 1);
    iC2 = 0;
    % Remove the legend string
    for iRow = 1:numRows
        curRow = lstDV{iRow, 1};
        
        if(~strcmp(lower(curRow), 'legend'))
            iC2 = iC2 + 1;
            lstC2(iC2,:) = lstDV(iRow,:);
        end
    end
    lstDV = lstC2;
    plot_dim = [1 1];
end

% Incorporate Any Desired Lookup Points on the x-axis

if(length(lookupID_PO1) == 1)
    if(size(arrID_PO1, 1)>1)
        arrID_PO1 = arrID_PO1';
    end
    lookupID_PO1 = unique([lookupID_PO1 arrID_PO1]);
end
curID_PO1 = lookupID_PO1;

% Loop through the 6th plot order point
for iID_PO6 = 1:num_lookupID_PO6
    if(numIDV > 5)
        curID_PO6 = lookupID_PO6(iID_PO6);
    end
    
    % Loop through the 5th plot order point
    for iID_PO5 = 1:num_lookupID_PO5
        if(numIDV > 4)
            curID_PO5 = lookupID_PO5(iID_PO5);
        end
        
        % Loop through the 4th plot order point
        for iID_PO4 = 1:num_lookupID_PO4
            if(numIDV > 3)
                curID_PO4 = lookupID_PO4(iID_PO4);
            end
            
            % Loop through the 3rd plot order point
            for iID_PO3 = 1:num_lookupID_PO3
                if(numIDV > 2)
                    curID_PO3 = lookupID_PO3(iID_PO3);
                end
                
                clear h strLegend;
                
                % Loop through the 2nd plot order point
                for iID_PO2 = 1:num_lookupID_PO2
                    if(numIDV > 1)
                        curID_PO2 = lookupID_PO2(iID_PO2);
                    end
                    
                    numDV = size(lstDV, 1);
                    for iPlot = 1:numDV;
                        
                        % Pick off name of table as it exists in
                        % TableND
                        strData = lstDV{iPlot, :};
                        
                        % Determine plot string to use when displaying
                        % data
                        if(size(lstDV, 2) > 1)
                            strDataLabel = lstDV{iPlot, 2};
                        else
                            strDataLabel = '';
                        end
                        
                        if(isempty(strDataLabel))
                            strDataLabel = strData;
                        end
                        
                        % Determine legend location
                        if(size(lstDV, 2) > 2)
                            legloc = lstDV{iPlot, 3};
                        else
                            legloc = 'NorthEastOutside';
                        end
                        
                        % Determine Special DV vs DV case (eg CL vs CD)
                        flgDV2 = 0;
                        if(size(lstDV, 2) > 3)
                            strData2 = lstDV{iPlot, 4};
                            
                            if(~isempty(strData2))
                                flgDV2 = 1;
                                
                                if(size(lstDV, 2) > 4)
                                    strData2Label = lstDV{iPlot, 5};
                                else
                                    strData2Label = '';
                                end
                                
                                if(isempty(strData2Label))
                                    strData2Label = strData2;
                                end
                            end
                        end
                        
                        if((iID_PO2 == 1) || (iID_PO2 == num_lookupID_PO2))
                            
                            for iIDV = 1:numIDV
                                eval(sprintf('curID%d = curID_PO%d;', plotOrder(iIDV), iIDV));
                            end
                            % Label Fix
                            if(numIDV > 1)
                                eval(sprintf('curID%d = lookupID_PO2;', plotOrder(2)));
                            end
                            
                            strTitle = sprintf('\\bf\\fontsize{%d}', TitleFontSize2);
                            
                            if(plotSingles)
                                strFig = sprintf('%s: %s = fcn(', strLabel, strDataLabel);
                                strTitle = sprintf('%s%s = fcn(', strTitle, strDataLabel);
                            else
                                strFig = sprintf('%s = fcn(', strLabel);
                                strTitle = sprintf('%s%s = fcn(', strTitle, strTitle2_DV);
                            end
                            
                            if(length(curID1) > 1)
                                strFig = sprintf('%s%s %s', strFig, ID1, ID1units);
                                strTitle = sprintf('%s%s %s', strTitle, strID1, ID1units);
                            else
                                strFig = sprintf('%s%s = %s %s', strFig, ID1, num2str(curID1), ID1units);
                                if(strcmp(ID1units, '[deg]'))
                                    strTitle = sprintf('%s%s = %s^o', strTitle, strID1, num2str(curID1));
                                else
                                    strTitle = sprintf('%s%s = %s %s', strTitle, strID1, num2str(curID1), ID1units);
                                end
                            end
                            
                            if(numIDV > 1)
                                if(length(curID2) > 1)
                                    strFig = sprintf('%s, %s %s', strFig, ID2, ID2units);
                                    strTitle = sprintf('%s, %s %s', strTitle, strID2, ID2units);
                                else
                                    strFig = sprintf('%s, %s = %s %s', strFig, ID2, num2str(curID2), ID2units);
                                    if(strcmp(ID2units, '[deg]'))
                                        strTitle = sprintf('%s, %s = %s^o', strTitle, strID2, num2str(curID2));
                                    else
                                        strTitle = sprintf('%s, %s = %s %s', strTitle, strID2, num2str(curID2), ID2units);
                                    end
                                end
                                
                                if(numIDV > 2)
                                    if(length(curID3) > 1)
                                        strFig = sprintf('%s, %s %s', strFig, ID3, ID3units);
                                        strTitle = sprintf('%s, %s %s', strTitle, strID3, ID3units);
                                    else
                                        strFig = sprintf('%s, %s = %s %s', strFig, ID3, num2str(curID3), ID3units);
                                        if(strcmp(ID3units, '[deg]'))
                                            strTitle = sprintf('%s, %s = %s^o', strTitle, strID3, num2str(curID3));
                                        else
                                            strTitle = sprintf('%s, %s = %s %s', strTitle, strID3, num2str(curID3), ID3units);
                                        end
                                    end
                                    
                                    if(numIDV > 3)
                                        if(length(curID4) > 1)
                                            strFig = sprintf('%s, %s %s', strFig, ID4, ID4units);
                                            strTitle = sprintf('%s, %s %s', strTitle, strID4, ID4units);
                                        else
                                            strFig = sprintf('%s, %s = %s %s', strFig, ID4, num2str(curID4), ID4units);
                                            if(strcmp(ID4units, '[deg]'))
                                                strTitle = sprintf('%s, %s = %s^o', strTitle, strID4, num2str(curID4));
                                            else
                                                strTitle = sprintf('%s, %s = %s %s', strTitle, strID4, num2str(curID4), ID4units);
                                            end
                                        end
                                        
                                        if(numIDV > 4)
                                            if(length(curID5) > 1)
                                                strFig = sprintf('%s, %s %s', strFig, ID5, ID5units);
                                                strTitle = sprintf('%s, %s %s', strTitle, strID5, ID5units);
                                            else
                                                strFig = sprintf('%s, %s = %s %s', strFig, ID5, num2str(curID5), ID5units);
                                                if(strcmp(ID5units, '[deg]'))
                                                    strTitle = sprintf('%s, %s = %s^o', strTitle, strID5, num2str(curID5));
                                                else
                                                    strTitle = sprintf('%s, %s = %s %s', strTitle, strID5, num2str(curID5), ID5units);
                                                end
                                            end
                                            
                                            if(numIDV > 5)
                                                if(length(curID6) > 1)
                                                    strFig = sprintf('%s, %s %s', strFig, ID6, ID6units);
                                                    strTitle = sprintf('%s, %s %s', strTitle, strID6, ID6units);
                                                else
                                                    strFig = sprintf('%s, %s = %s %s', strFig, ID6, num2str(curID6), ID6units);
                                                    if(strcmp(ID6units, '[deg]'))
                                                        strTitle = sprintf('%s, %s = %s^o', strTitle, strID6, num2str(curID6));
                                                    else
                                                        strTitle = sprintf('%s, %s = %s %s', strTitle, strID6, num2str(curID6), ID6units);
                                                    end
                                                end
                                            else
                                                strFig = sprintf('%s)', strFig);
                                                strTitle = sprintf('%s)', strTitle);
                                                
                                            end
                                        else
                                            strFig = sprintf('%s)', strFig);
                                            strTitle = sprintf('%s)', strTitle);
                                        end
                                    else
                                        strFig = sprintf('%s)', strFig);
                                        strTitle = sprintf('%s)', strTitle);
                                    end
                                else
                                    strFig = sprintf('%s)', strFig);
                                    strTitle = sprintf('%s)', strTitle);
                                end
                            else
                                strFig = sprintf('%s)', strFig);
                                strTitle = sprintf('%s)', strTitle);
                            end
                            strFig = strrep(strFig, endl, '');
                            
                        end
                        
                        if(plotSingles)
                            if(iID_PO2 == 1)
                                fh(iPlot) = figure('Name',  strFig);
                                iFig = iFig + 1;
                                figInfo(iFig).fh = fh(iPlot);
                            else
                                figure(fh(iPlot));
                                iFig = iFig + 1;
                                figInfo(iFig).fh = fh(iPlot);
                            end
                        else
                            if((iPlot == 1) && (iID_PO2 == 1))
                                fh(iPlot) = figure('Name',  strFig);
                                iFig = iFig + 1;
                                figInfo(iFig).fh = fh(iPlot);
                            end
                            
                            sph = subplot(plot_dim(1), plot_dim(2), iPlot);
                            figInfo(iFig).sph(iPlot).sph = sph;
                            figInfo(iFig).sph(iPlot).islegend = 0;
                            
                        end
                        
                        if(strcmp(strData, 'legend'))
                            hl(iID_PO2) = plotd(curID_PO1*0, curID_PO1*0, PlotDec, 'LineWidth', lw, 'MarkerSize', ms);
                            
                        else
                            
                            for iIDV = 1:numIDV
                                eval(sprintf('curID%d = curID_PO%d;', plotOrder(iIDV), iIDV));
                            end
                            
                            switch numIDV
                                case 1
                                    arr.(strData) = squeeze(Interp1D(arrID1, ...
                                        TableND.(strData), curID1));
                                case 2
                                    arr.(strData) = squeeze(Interp2D(arrID1, arrID2, ...
                                        TableND.(strData), ...
                                        curID1, curID2));
                                case 3
                                    arr.(strData) = squeeze(Interp3D(arrID1, arrID2, ...
                                        arrID3, TableND.(strData), ...
                                        curID1, curID2, curID3));
                                case 4
                                    arr.(strData) = squeeze(Interp4D(arrID1, arrID2, ...
                                        arrID3, arrID4, TableND.(strData), ...
                                        curID1, curID2, curID3, curID4));
                                case 5
                                    arr.(strData) = squeeze(Interp5D(arrID1, arrID2, ...
                                        arrID3, arrID4, arrID5, TableND.(strData), ...
                                        curID1, curID2, curID3, curID4, curID5));
                                case 6
                                    arr.(strData) = squeeze(Interp6D(arrID1, arrID2, ...
                                        arrID3, arrID4, arrID5, arrID6, TableND.(strData), ...
                                        curID1, curID2, curID3, curID4, curID5, curID6));
                            end
                            
                            
                            if(flgDV2)
                                switch numIDV
                                    case 1
                                        arr.(strData2) = squeeze(Interp1D(arrID1, ...
                                            TableND.(strData2), curID1));
                                    case 2
                                        arr.(strData2) = squeeze(Interp2D(arrID1, arrID2, ...
                                            TableND.(strData2), ...
                                            curID1, curID2));
                                    case 3
                                        arr.(strData2) = squeeze(Interp3D(arrID1, arrID2, ...
                                            arrID3, TableND.(strData2), ...
                                            curID1, curID2, curID3));
                                    case 4
                                        arr.(strData2) = squeeze(Interp4D(arrID1, arrID2, ...
                                            arrID3, arrID4, TableND.(strData2), ...
                                            curID1, curID2, curID3, curID4));
                                    case 5
                                        arr.(strData2) = squeeze(Interp5D(arrID1, arrID2, ...
                                            arrID3, arrID4, arrID5, TableND.(strData2), ...
                                            curID1, curID2, curID3, curID4, curID5));
                                    case 6
                                        arr.(strData2) = squeeze(Interp6D(arrID1, arrID2, ...
                                            arrID3, arrID4, arrID5, arrID6, TableND.(strData2), ...
                                            curID1, curID2, curID3, curID4, curID5, curID6));
                                end
                            end
                            
                            
                            if(numIDV > 1)
                                str4Legend = sprintf('%s = %s %s', strID_PO2, num2str(curID_PO2), ID_PO2_units);
                                str4Legend = strrep(str4Legend, ' [deg]', '^o');
                                strLegend(iID_PO2,:) = { str4Legend };
                            end
                            if(size(curID_PO1, 2) > 1)
                                curID_PO1 = curID_PO1';
                            end
                            if(size(arr.(strData), 2)>1)
                                eval(sprintf('arr.%s = arr.%s'';', strData, strData));
                            end
                            
                            if(flgDV2)
                                if(size(arr.(strData2), 2)>1)
                                    eval(sprintf('arr.%s = arr.%s'';', strData2, strData2));
                                end
                            end
                            
                            if(~flgDV2)
                                h(iPlot,iID_PO2) = plotd(curID_PO1, arr.(strData), PlotDec, 'LineWidth', lw, 'MarkerSize', ms);
                            else
                                h(iPlot,iID_PO2) = plotd(arr.(strData2), arr.(strData), PlotDec, 'LineWidth', lw, 'MarkerSize', ms);
                                
                                % Plot a different marker for the
                                % first/last points and label points
                                % for first/last curID_PO1
                                %
                                %   This section is a work in progress.
                                %    It doesn't currently work with
                                %    plotd.  Need to move functionality
                                %    into plotd?
                                % lstStartEnd = {[strID_PO1 ' = ' num2str(curID_PO1(1)) ' ' ID_PO1_units];
                                %     [strID_PO1 ' = ' num2str(curID_PO1(end)) ' ' ID_PO1_units]};
                                % Plot First PO1
                                % plot(arr.(strData2)(1), arr.(strData)(1), 'Color', StartMarkColor, 'Marker', StartMarkMarker, 'MarkerSize', ms+2);
                                % Plot Last PO1
                                % plot(arr.(strData2)(end), arr.(strData)(end), 'Color', EndMarkColor, 'Marker', EndMarkMarker, 'MarkerSize', ms+2);
                            end
                            ylimits = ylim;
                            figInfo(iFig).sph(iPlot).ylim = ylimits;
                            
                            if(plotSingles)
                                hl(iPlot,iID_PO2) = h(iID_PO2);
                            end
                        end
                        
                        if(iID_PO2 == 1)
                            hold on;
                        end
                        
                        if(iID_PO2 == num_lookupID_PO2)
                            grid on; set(gca, 'FontWeight', 'bold', 'FontSize', LabelFontSize);
                            
                            if(flgDV2)
                                xlabel(['\bf\fontsize{' num2str(LabelFontSize) '}' strData2Label]);
                            else
                                xlabel(['\bf\fontsize{' num2str(LabelFontSize) '}' strID_PO1 ' ' ID_PO1_units]);
                            end
                            ylabel(['\bf\fontsize{' num2str(LabelFontSize) '}' strDataLabel]);
                            
                            if(plotSingles)
                                if(isempty(legloc))
                                    legloc = 'NorthEastOutside';
                                end
                                if(numIDV > 1)
                                    if(~strcmp(lower(legloc), 'none'))
                                        legend(h(iPlot,:)', strLegend, 'Location', legloc);
                                    end
                                end
                                title([strTitle1 endl strTitle]);
                            else
                                
                                if(flgSepLeg)
                                    % One subplot is dedicated to just
                                    % the legend
                                    if(strcmp(strData, 'legend'))
                                        legend(hl, strLegend, 'Location', 'NorthWest');
                                        
                                        axis([1 2 1 2]);
                                        set(sph, 'Visible', 'off');
                                        figInfo(iFig).sph(iPlot).islegend = 1;
                                    end
                                else
                                    if(~strcmp(lower(legloc), 'none'))
                                        legend(h(iPlot,:)', strLegend, 'Location', legloc);
                                    end
                                end
                                
                                if((numDV == 2) || (numDV == 4))
                                    if(iPlot == numDV)
                                        subplot(plot_dim(1), plot_dim(2), 1);
                                        TitleSubPlot([strTitle1 endl strTitle]);
                                    end
                                else
                                    if(iPlot == 2)
                                        %                                             title({strTitle;'\fontsize{4}'});
                                        title([strTitle1 endl strTitle]);
                                    end
                                end
                            end
                            if ~isempty(FigPos)
                                set(gcf,'Position',FigPos)
                            end
                            
                            if ~isempty(LegPos)
                                set(legend,'Position',LegPos)
                            end
                            
                        end
                    end
                end
            end
        end
    end
end

%%
if(UniformYLimits)
    %   Readjust the y-limits on each figure so that they're the same
    numFigs = size(figInfo,2);
    for iFig = 1:numFigs
        cur_fh = figInfo(iFig).fh;
        
        numSubplots = size(figInfo(iFig).sph, 2);
        ylimits = [0 0];
        for iSubplot = 1:numSubplots
            curSubplot = figInfo(iFig).sph(iSubplot);
            if(~curSubplot.islegend)
                ylimits(1) = min(ylimits(1), curSubplot.ylim(1));
                ylimits(2) = max(ylimits(2), curSubplot.ylim(2));
            end
        end
        
        figure(cur_fh);
        for iSubplot = 1:numSubplots
            curSubplot = figInfo(iFig).sph(iSubplot);
            if(~curSubplot.islegend)
                set(curSubplot.sph, 'Ylim', ylimits);
            end
        end
    end
end

%% Compile Outputs:

% << End of function Plot_nD_Data >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101101 JPG: Copied over information from the old function.
% 100914 MWS: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName             :  Email                :  NGGN Username
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% MWS: Mike Sufana          : mike.sufana@ngc.com   :  sufanmi

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
