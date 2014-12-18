% PLOTMEASURANDS plots time history of a list of measurands from mult. sources
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% PlotMeasurands:
% Utility plotting function which allows you to plot single or multiple
% timeseries signals across multiple subplots from a single or multiple
% 'Result' structures.  If multiple 'Results' structures are used, function
% can plot the deltas between the stuctures for signals that exist in both.
% 
% SYNTAX:
%	fig_handles = PlotMeasurands(SourceData2Plot, lstMeasurandSets, PO)
%	fig_handles = PlotMeasurands(SourceData2Plot, lstMeasurandSets)
%
% INPUTS: 
%	Name            	Size		Units		Description
% SourceData2Plot       {struct}    Contains all source data & info
%   .Results            {struct}    'Results' structure from
%                                       ParseRecordedData2ts
%   .Title              [string]    Description of data (e.g. version,
%                                       configuration, etc)
%   .toffset            [sec]       Time offset to shift data
%   .filename           [string]    Filename of plotted data
%
% lstMeasurandSets      {nested cells}
%   {:,1}:  Cell array of results members to plot on 1 subplot
%   {:,2}:  Legend Position for regular signals (default is 'NorthEast')
%   {:,3}:  Legend Position for differenced signals (default is
%            'NorthEast')
%
% PO                    {struct}        Plot Options
%   .xmin               [1]             Lower plot bounds   (default: [])
%   .xmax               [1]             Upper plot bounds   (default: [])
%   .Title              [string]        Additonal Title     (default: '')
%   .Decimation         [1]             Marker Decimation   (default: every
%                                                              5 seconds)
%   .flgPlotErrors      [bool]         {0}/1: Plots differences between
%                                               measurand signals?
%   .flgPlotSingles     [bool]         {0}: Plots Singles and Errors on
%                                            separate figures
%                                       1 : Plots each measurand set with
%                                            errors (if desired) on same
%                                            figure
%   .ForceLegend        [bool]         {0}/1: Lists signals and units as
%                                              legend entries
%   .LabelFormat        [1]             For a measurand of the form
%                                        'A.B.C.D_units', this specifies
%                                        how the legend will be formatted
%                                        {0}: Full string (A.B.C.D_units)
%                                         1 : Short string (D_units)
%                                         2+: Incrementally removes leading
%                                               structures.  Given the
%                                               A.B.C.D_units example:
%                                            2: Removes 1 dot (B.C.D_units)
%                                            3: Removes 2 dots (C.D_units)
%                                            4: Removes 3 dots (D_units)
%   .SplitHeader        [bool]         {0}/1: Shortens legend entries by
%                                             moving common signal names to
%                                             ylabel.  Only used if 
%                                             'ForceLegend' is 0.
%   .titlefont1         [1]             Main Title Font     (default: 12)
%   .titlefont2         [1]             Minor Title Font    (default: 10)
%   .LineWidth          [1]             Line Width          (default: 1.5)
%   .MarkerSize         [1]             Marker Size         (default: 10)
%   .FigurePosition     [1x4]           Figure Size        (matlab default)
%
%
% OUTPUTS: 
%	Name            	Size		Units		Description
%   fig_handles         [n]         [index]     Handles to created figures
%
% NOTES:
%  Notes on PlotMeasurands:
%  PlotMeasurands allows you to plot single or multiple timeseries signals
%  across multiple subplots.  All data to plot, like that in the 'Results'
%  structure is a sub-member of the 1st input, SourceData2Plot.
%  Specifically, our 'Results' is in SourceData2Plot(1).Results.  If there
%  are multiple 'Results' structures, SourceData2Plot will have multiple
%  members (e.g. SourceData2Plot(2).Results, and so on).
%
%	How to call it: PlotMeasurands(SourceData2Plot, lstMeasurandSets, PO)
%
%   Here, SourceData2Plot contains your 'Results' structure as well as
%   information on where the data came from, what it represents, and how
%   the data has been offset (if at all) in the time domain.  An example
%   could be:
%
%   SourceData2Plot(1).Results = Results;
%   SourceData2Plot(1).Title   = 'No Failures';
%   SourceData2Plot(1).toffset = 0;
%   SourceData2Plot(1).filename= '\\network_drive\rev50\Results.mat';
%
%   'lstMeasurandSets' (a cell array) specifies the signals you want to
%   plot.  By careful manipulation of 'lstMeasurandSets', you can control
%   what signals get plotted on which subplot, and where the legend tags
%   need to go (if applicable).
%
%   'PO' stands for plot options, which is a structure of different options
%   you can set to change the look of the figures.  The function has
%   defaults for all members, but you can change any of them.  For
%   presentation purposes, we'll ensure that the plot legend will always be
%   on by setting PO.ForceLegend = 1.
%
%  BASIC PLOTTING:
%  To plot a signal signal in any of the 'Results' structures
%  (e.g. 'VMC.OuterLoopData.AltHoldMode_AltCmd_ft'), you can call the
%  function one of two ways:
%
%   Method #1 (without the '{}' brackets):
%     PlotMeasurands(SourceData2Plot, {
%            'VMC.OuterLoopData.AltHoldMode_AltCmd_ft'}, PO);
%   Method #2 (with the '{}' brackets):
%     PlotMeasurands(SourceData2Plot, {
%            {'VMC.OuterLoopData.AltHoldMode_AltCmd_ft'}}, PO);
%
%   Method #2 will be the more commonly used notation, as it will allow you
%   to specify a whole bunch more options.
%
%   If only one signal is to be plotted, the legend wouldn't normally be
%   plotted.  However, since we set PO.ForceLegend to be 1, the legend is
%   shown in it's default location in the inside 'NorthEast' corner. If you
%   want to be able to change this location, we can expand on Method #2.
%   Let's move the legend to the 'SouthWest' corner.
%
%     PlotMeasurands(SourceData2Plot, {
%            {'VMC.OuterLoopData.AltHoldMode_AltCmd_ft'} 'SouthWest'}, PO);
%
%  One other cool thing to note.  You can change the output units in the
%  PlotMeasurands call.  So, suppose you want to plot in degrees instead of
%  radians, or the negative of a signal (e.g. Alt = -Pd), just amend the
%  call instead of creating a new signal.  So, using our example, let's say
%  we want to plot in meters.  This is all you have to do:
%
%     PlotMeasurands(SourceData2Plot, {
%            {'VMC.OuterLoopData.AltHoldMode_AltCmd_ft*C.FT2M'} 'SouthWest'}, PO);
%
%  PLOT OVERLAYS:
%  Now suppose you want to do a plot overlay and plot the altitude command
%  against the altitude response.  You just add the signal to the inner
%  cell array like so:
%
%     PlotMeasurands(SourceData2Plot, {
%            {'VMC.OuterLoopData.AltHoldMode_AltCmd_ft';
%             'VMC.OuterLoopData.AltHoldMode_Alt_ft'} 'SouthWest'}, PO);
%
%   Since both signals are within the same brackets, they'll be plotted on
%   top of each other in a single figure.  The legend with have 2 members
%   with the full string each signal.  Since the strings are rather long,
%   you can shorten them one of two ways.
%
%   Method #1: You specify what string to use for the legend.  Do this by
%               adding a column to the cell array of signals to plot:
%     PlotMeasurands(SourceData2Plot, {
%            {'VMC.OuterLoopData.AltHoldMode_AltCmd_ft'     'AltCmd';
%             'VMC.OuterLoopData.AltHoldMode_Alt_ft'        'Alt'} 'SouthWest'}, PO);
%
%       Here, 'AltCmd' will be used for the 1st signal and 'Alt' for the
%       2nd one.
%
%   Method #2: You specify 'PO.LabelFormat' to be 1, which is the short
%               legend form.  If the signal has a bunch of dots in its name
%               (e.g. A.B.C.D), only the last string will be used.
%
%       PO.LabelFormat = 1;
%       PlotMeasurands(SourceData2Plot, {
%            {'VMC.OuterLoopData.AltHoldMode_AltCmd_ft';
%             'VMC.OuterLoopData.AltHoldMode_Alt_ft'} 'SouthWest'}, PO);
%
%       Here, 'AltHoldMode_AltCmd_ft' will be used for the 1st signal and
%       'AltHoldMode_Alt_ft' will be used for the 2nd.
%
%   Method #3: You specify 'PO.LabelFormat' to be >1.  If there are dots
%               ('.') in the signal string (e.g. A.B.C.D_units), you can
%               incrementally remove them by setting PO.Label.  If...
%
%           PO.LabelFormat = 2, 1 dot will be removed (e.g. B.C.D_units)
%           PO.LabelFormat = 3, 2 dots will be removed (e.g. C.D_units)
%           PO.LabelFormat = 4, 3 dots will be removed (e.g. D_units)
%
%  MULTIPLE SUBPLOTS:
%   Now suppose that you want to produce a figure with 2 subplots.  On the
%   top, you've got your altitude command and response, but now you want to
%   plot the error on the bottom plot.  Using PlotMeasurands, you just add
%   an additional line with the signal(s) you want plotted like so:
%
%       PlotMeasurands(SourceData2Plot, {
%            {'VMC.OuterLoopData.AltHoldMode_AltCmd_ft';
%             'VMC.OuterLoopData.AltHoldMode_Alt_ft'};
%            {'VMC.OuterLoopData.AltHoldMode_AltError_ft'}
%            }, PO);
%
% EXAMPLES:
%   Full examples need to be added.  See also Driver_PlotMeasurands
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
%	Source function: <a href="matlab:edit PlotMeasurands.m">PlotMeasurands.m</a>
%	  Driver script: <a href="matlab:edit Driver_PlotMeasurands.m">Driver_PlotMeasurands.m</a>
%	  Documentation: <a href="matlab:pptOpen('PlotMeasurands_Function_Documentation.pptx');">PlotMeasurands_Function_Documentation.pptx</a>
%
% See also format_struct, plotts, plotd
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/521
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/PlotMeasurands.m $
% $Rev: 3285 $
% $Date: 2014-10-23 19:25:07 -0500 (Thu, 23 Oct 2014) $
% $Author: sufanmi $

function fig_handles = PlotMeasurands(SourceData2Plot, lstMeasurandSets, PO, FigName)

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
fig_handles = [];

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin

if(nargin < 4)
    FigName = '';
end

if(nargin < 3)
    PO = [];
end
PO = format_struct(PO, 'xmin', []);
PO = format_struct(PO, 'xmax', []);
PO = format_struct(PO, 'Title', '');
PO = format_struct(PO, 'Decimation', 5);
PO = format_struct(PO, 'DecimationType', 2);

PO = format_struct(PO, 'flgPlotErrors', 0);
PO = format_struct(PO, 'flgSimpleErrors', 1);
PO = format_struct(PO, 'flgPlotSingles', 0);
PO = format_struct(PO, 'ForceLegend', 0);
PO = format_struct(PO, 'SplitHeader', 0);
PO = format_struct(PO, 'LineWidth', 1.5);
PO = format_struct(PO, 'MarkerSize', 10);
PO = format_struct(PO, 'titlefont1', 12);
PO = format_struct(PO, 'titlefont2', 10);
PO = format_struct(PO, 'FigurePosition', []);
PO = format_struct(PO, 'LabelFormat', 1); % 0 - Full Legend, 1 - Short Legend, 2 - Uses Title
PO = format_struct(PO, 'PlotOrder', {});
PO = format_struct(PO, 'TimeTagUnits', 'sec');
PO = format_struct(PO, 'BlankYLabel', 0);

%% Main Function:
numDataset      = size(SourceData2Plot, 2);
numMeasurandSets= size(lstMeasurandSets, 1);
numMeasurandCols= size(lstMeasurandSets, 2);

%% Preprocess
lstSignals = {};
for iMeasurandSet = 1:numMeasurandSets
    curMeasurands = lstMeasurandSets{iMeasurandSet, 1};
    
    if(ischar(curMeasurands))
        curMeasurands = { curMeasurands };
    end
    lstSignals = [lstSignals; curMeasurands];
end
lstSignals = unique(lstSignals);   

for iDataset    = 1:numDataset
    flgResults = isfield(SourceData2Plot(iDataset), 'Results');
    flgLoad = ~flgResults;
    
    if(flgResults)
        Results = SourceData2Plot(iDataset).Results;
        flgLoad = isempty(Results);
    end
    
    if(flgLoad)
        % Data is saved to .mat file instead of provide.  Load in the data
        
        curSourceFolder = SourceData2Plot(iDataset).SourceFolder;
        Results = load_saved_ts(lstSignals, 'SourceFolder', curSourceFolder, ...
            'StartTime', PO.xmin, 'EndTime', PO.xmax, ...
            'AllowReduce', false);
        SourceData2Plot(iDataset).Results = Results;
        clear Results;
    end
end

%%
if(PO.flgPlotSingles)
    
    % Loop Through Each MeasurandSet:
    for iMeasSet = 1:numMeasurandSets
        lstMeasurands = lstMeasurandSets{iMeasSet,1};
        
        if(iscell(lstMeasurands))
            numMeasurands   = size(lstMeasurands, 1);
        else
            lstMeasurands = { lstMeasurands };
            numMeasurands = 1;
        end
        
        clear FigInfo;
        fig_hdl = figure();
        fig_handles(iMeasSet) = fig_hdl;
        
        if(~isempty(PO.FigurePosition))
            set(fig_hdl, 'position', PO.FigurePosition);
        end
        
        if(~isempty(FigName))
            set(fig_hdl, 'Name', sprintf('%s%d', FigName, iMeasSet));
        end
        
        if((numMeasurands == 1) && (numDataset == 1))
            PO.flgPlotErrors = 0;
        end
        
        if(PO.flgPlotErrors)
            sp_hdl = subplot(2, 1, 1);
        else
            sp_hdl = subplot(1, 1, 1);
        end
        
        ictr = 0;
        for iMeas = 1:numMeasurands
            strData2Plot   = lstMeasurands{iMeas, :};
            
            cellName2Plot = '';
            if(size(lstMeasurands, 2) > 1)
                cellName2Plot = lstMeasurands{iMeas, 2};
            end
            
            %% Loop Through Each Dataset:
            for iData2Plot = 1:numDataset;
                Results     = SourceData2Plot(iData2Plot).Results;
                toffset     = SourceData2Plot(iData2Plot).toffset;
                strTitle    = SourceData2Plot(iData2Plot).Title;
                
                ts = getts(Results, strData2Plot, toffset, 'xmin', PO.xmin, 'xmax', PO.xmax);
                
                switch PO.LabelFormat
                    case 0
                        % Full Legend (e.g. A.B.C.D_units):
                        ts.Name = strData2Plot;
                    case 1
                        % Short Legend (e.g. D_units):
                        % <Nothing New Required>
                    otherwise
                        % Case 2+
                        % Short Legend version #2.
                        % Function of the dots ('.') in the full name
                        %   If 2, drop the toplevel #1 (e.g. B.C.D_units)
                        %   If 3, drop the toplevel #1 & 2 (e.g. C.D_units)
                        %   If 4, keep going
                        arrDots = strfind(strData2Plot, '.');
                        numDots = length(arrDots);
                        numDots2Remove = min(PO.LabelFormat - 1, numDots);
                        iEnd = arrDots(numDots2Remove)+1;
                        strNameNew = strData2Plot(iEnd:end);
                        ts.Name = strNameNew;
                end

                if(~isempty(cellName2Plot))
                    ts.Name = cellName2Plot;
                end
                
                if(numDataset > 1)
                    ts.DataInfo.UserData = sprintf('ds%d', iData2Plot);
                    if(isempty(strTitle))
                        lstSource{iData2Plot,:} = sprintf('ds%d', iData2Plot);
                    else
                        lstSource{iData2Plot,:} = strTitle;
                    end
                end
                
                ictr = ictr + 1;
                lst_ts(ictr,1) = {ts};
            end
        end
        
        if(numMeasurandCols > 1)
            PO.locLegend = lstMeasurandSets{iMeasSet, 2};
        else
            PO.locLegend = '';
        end
        
        PO.locLabel = '';
        if(iscell(PO.locLegend))
            PO.locLabel = PO.locLegend{2};
            PO.locLegend = PO.locLegend{1};
        end
        
        if(isempty(PO.locLegend))
            PO.locLegend = 'NorthEast';
        end

        ForceLegend = PO.ForceLegend;
        if(strcmp(lower(PO.locLegend), 'none'))
            ForceLegend = 0;
            
            if(isempty(PO.locLabel))
                % Special Case:
                PO.locLabel = 'NorthEastInside';
            end
        end
        
        [h_reg, lh_reg] = plotts(lst_ts, 'LineWidth', PO.LineWidth, ...
            'MarkerSize', PO.MarkerSize, 'ForceLegend', PO.ForceLegend, ...
            'SplitHeader', PO.SplitHeader, 'PlotOrder', PO.PlotOrder, ...
            'Decimation', PO.Decimation, 'xmin', PO.xmin, 'xmax', PO.xmax, ...
            'PlotOrder', PO.PlotOrder, 'TimeTagUnits', PO.TimeTagUnits);
                
        if(~isempty(lh_reg))
            if(numMeasurandCols > 1)
                set(lh_reg, 'String', lstSource);
                
                strTitle = lst_ts{1}.Name;
                ystr = lst_ts{1}.DataInfo.Unit;
                strTitle = FormatLabel(strTitle);
%                 strTitle = sprintf('%s %s', strTitle, ystr);
                strTitle = strrep(strTitle, '_', '\_');
                if(PO.BlankYLabel)
                    ylabel('');
                end
 
                if(~isempty(PO.locLabel))
                    label(strTitle, PO.locLabel);
                end
                
            end
            
            if(isempty(PO.locLegend))
                PO.locLegend = 'NorthEast';
            end
            set(lh_reg, 'Location', PO.locLegend);
        end
        
        % Construct the Header and Footer:
        [lstHeader] = BuildHeader(SourceData2Plot, PO);
        title(lstHeader, 'Interpreter', 'tex');
        
        if(PO.flgPlotErrors)
            % Error Plotting:
            lst_diffts = diffts(lst_ts, PO.flgSimpleErrors);
            
            sp_hdl = subplot(2,1,2);
            
            [h_diff, lh_diff] = plotts(lst_diffts, 'LineWidth', PO.LineWidth, ...
                'MarkerSize', PO.MarkerSize, 'ForceLegend', 1, ...
                'SplitHeader', PO.SplitHeader, 'Decimation', PO.Decimation, ...
                'PlotOrder', PO.PlotOrder, ...
                'TimeTagUnits', PO.TimeTagUnits);
            if(PO.BlankYLabel)
                ylabel('');
            end
 
            if(~isempty(PO.FigurePosition))
                set(gcf, 'position', PO.FigurePosition);
            end
            if(~isempty(FigName))
                set(gcf, 'Name', sprintf('Delta %s%d', FigName, iMeasSet));
            end
            
            if(~isempty(lh_diff))
                if(numMeasurandCols > 2)
                    PO.locLegend = lstMeasurandSets{iMeasSet, 3};
                end
                
                if(isempty(PO.locLegend))
                    PO.locLegend = 'NorthEast';
                end
                
                set(lh_diff, 'Location', PO.locLegend);
            end
            
        end
    end
else
    
    % ========================================================================
    %   OVERLAY PLOT
    clear RegFigInfo;
    clear DiffFigInfo;
    
    % Create Regular Figure:
    regfig = figure();
    fig_handles(1) = regfig;
    if(~isempty(PO.FigurePosition))
        set(regfig, 'position', PO.FigurePosition);
    end
    if(~isempty(FigName))
        set(regfig, 'Name', FigName);
    end
    
    if(PO.flgPlotErrors)
        % Create Difference Figure:
        difffig = figure();
        fig_handles(2) = difffig;
        if(~isempty(PO.FigurePosition))
            set(difffig, 'position', PO.FigurePosition);
        end
        if(~isempty(FigName))
            set(difffig, 'Name', ['Delta ' FigName]);
        end
    end
    
    %% Loop Through Each MeasurandSet:
    for iMeasSet = 1:numMeasurandSets
        lstMeasurands = lstMeasurandSets{iMeasSet,1};
        
        if(iscell(lstMeasurands))
            numMeasurands   = size(lstMeasurands, 1);
        else
            lstMeasurands = { lstMeasurands };
            numMeasurands = 1;
        end
        
        ictr = 0;
        clear lst_ts;
        %% Loop Through Each Measurand:
        for iMeas = 1:numMeasurands
            cellData2Plot = lstMeasurands{iMeas, 1};
            
            cellName2Plot = '';
            if(size(lstMeasurands, 2) > 1)
                cellName2Plot = lstMeasurands{iMeas, 2};
            end
            
            %% Loop Through Each Dataset:
            clear lstSource;
            for iData2Plot = 1:numDataset;
                if(isfield(SourceData2Plot(iData2Plot), 'toffset'))
                    toffset = SourceData2Plot(iData2Plot).toffset;
                else
                    toffset = [];
                end
                if(isempty(toffset))
                    toffset = 0;
                end
                strTitle    = SourceData2Plot(iData2Plot).Title;
                                
                if(iscell(cellData2Plot))
                    strData2Plot = cellData2Plot{1,1};
                    dim2plot = cellData2Plot{1,2};
                else
                    strData2Plot = cellData2Plot;
                end
                
                ts = getts(SourceData2Plot(iData2Plot).Results, strData2Plot, toffset, 'xmin', PO.xmin, 'xmax', PO.xmax);
                
                switch PO.LabelFormat
                    case 0
                        % Full Legend (e.g. A.B.C.D_units):
                        ts.Name = strData2Plot;
                    case 1
                        % Short Legend (e.g. D_units):
                        % <Nothing New Required>
                    otherwise
                        % Case 2+
                        % Short Legend version #2.
                        % Function of the dots ('.') in the full name
                        %   If 2, drop the toplevel #1 (e.g. B.C.D_units)
                        %   If 3, drop the toplevel #1 & 2 (e.g. C.D_units)
                        %   If 4, keep going
                        arrDots = strfind(strData2Plot, '.');
                        numDots = length(arrDots);
                        numDots2Remove = min(PO.LabelFormat - 1, numDots);
                        iEnd = arrDots(numDots2Remove)+1;
                        strNameNew = strData2Plot(iEnd:end);
                        ts.Name = strNameNew;
                end

                if(~isempty(cellName2Plot))
                    ts.Name = cellName2Plot;
                end
                
                if(numDataset > 1)
                    if(isempty(strTitle))
                        lstSource{iData2Plot,:} = sprintf('ds%d', iData2Plot);
                    else
                        lstSource{iData2Plot,:} = strTitle;
                    end
                else
                    lstSource{iData2Plot,:} = strTitle;
                end
                
                ts.DataInfo.UserData = lstSource{iData2Plot,:};
                ictr = ictr + 1;
                lst_ts(ictr,1) = {ts};
                if(iscell(cellData2Plot))
                    lst_ts(ictr,2) = {dim2plot};
                end
                
                lst_ts(ictr,3) = { lstSource{iData2Plot,:} };
            end
        end
        
        % Goto Regular Plot:
        figure(regfig);

        sp_hdl = subplot(numMeasurandSets, 1, iMeasSet);
        
        if(numMeasurandCols > 1)
            PO.locLegend = lstMeasurandSets{iMeasSet, 2};
        end
        
        PO.locLabel = '';
        if(iscell(PO.locLegend))
            PO.locLabel = PO.locLegend{2};
            PO.locLegend = PO.locLegend{1};
        end
        
        if(~isfield(PO, 'locLegend'))
            PO.locLegend = 'NorthEast';
        end
        
        if(isempty(PO.locLegend))
            PO.locLegend = 'NorthEast';
        end

        ForceLegend = PO.ForceLegend;
        if(strcmp(lower(PO.locLegend), 'none'))
            ForceLegend = 0;
            
            if(isempty(PO.locLabel))
                % Special Case:
            PO.locLabel = 'NorthEastInside';
            end
        end
        
        [h_reg, lh_reg] = plotts(lst_ts, 'LineWidth', PO.LineWidth, ...
            'MarkerSize', PO.MarkerSize, 'ForceLegend', ForceLegend, ...
            'LegLoc', PO.locLegend, ...
            'SplitHeader', PO.SplitHeader, ...
            'Decimation', PO.Decimation, 'xmin', PO.xmin, 'xmax', PO.xmax, ...
            'PlotOrder', PO.PlotOrder, ...
            'TimeTagUnits', PO.TimeTagUnits);
        if(PO.BlankYLabel)
            ylabel('');
        end
 
        if((numMeasurands == 1) && (numDataset > 1))
            set(lh_reg, 'String', strrep(lstSource, '_', '\_'));
            
            strTitle = lst_ts{1}.Name;
            ystr = lst_ts{1}.DataInfo.Unit;

            strTitle = FormatLabel(strTitle);
%             strTitle = sprintf('%s %s', strTitle, ystr);
            strTitle = strrep(strTitle, '_', '\_');
%             ylabel('');
            
            if(~isempty(PO.locLabel))
                label(strTitle, PO.locLabel);
            end
            
            if(iMeasSet == 1)
                PO.SkipDataNames = 1;
                [lstHeader] = BuildHeader(SourceData2Plot, PO);
%                 numHeader = size(lstHeader, 1);
                title(lstHeader, 'Interpreter', 'tex');
            end
        else
            
            if(iMeasSet == 1)
                PO.SkipDataNames = 1;
                [lstHeader] = BuildHeader(SourceData2Plot, PO);
                title(lstHeader, 'Interpreter', 'tex');
            end
        end
  
        if(PO.flgPlotErrors)
            % Error Plotting:
            [lst_diffts, numDiffSet] = diffts(lst_ts, PO.flgSimpleErrors);
                        
            figure(difffig);
            
            sp_hdl = subplot(numMeasurandSets, 1, iMeasSet);
            
            if((numMeasurands == 1) && (numDataset == 1))
                ts = lst_ts{1};
                str_label{1,:} = ' No Error Data to Plot for ';
                str_label{2,:} = ts.Name;
                
                xlimits(1) = ts.TimeInfo.Start;
                xlimits(2) = ts.TimeInfo.End;
                xlim(xlimits);
                set(gca, 'YTickLabel', '');
                set(gca, 'FontWeight', 'bold');
                xlabel('Time [sec]', 'FontWeight', 'bold');
                label(str_label, 'Center');
                
                if(iMeasSet == 1)
                    % Construct the Header and Footer:
                    [lstHeader] = BuildHeader(SourceData2Plot, PO);
                    title(lstHeader, 'Interpreter', 'tex');
                end
            else
                if(numMeasurandCols > 2)
                    PO.locLegend = lstMeasurandSets{iMeasSet, 3};
                end
                
                PO.locLabel = '';
                if(iscell(PO.locLegend))
                    PO.locLabel = PO.locLegend{2};
                    PO.locLegend = PO.locLegend{1};
                end
                
                if(~isempty(PO.locLabel))
%                     strLabel = lst_diffts.Name;
                    strLabel = lst_diffts.DataInfo.UserData;
                    strLabel = [' ' strrep(strLabel, '-', ' - ') ' '];
%                     lst_diffts.Name = lst_diffts.DataInfo.UserData;
                    
                end
                
                if(isempty(PO.locLegend))
                    PO.locLegend = 'NorthEast';
                end
                
                ForceLegend = PO.ForceLegend;
                if(strcmp(lower(PO.locLegend), 'none'))
                    ForceLegend = 0;
                    
                    if(isempty(PO.locLabel))
                        % Special Case:
                        PO.locLabel = 'NorthEastInside';
                    end
                end
                
                ForceLegend = true;
                
                [h_diff, lh_diff] = plotts(lst_diffts, 'LineWidth', PO.LineWidth, ...
                    'MarkerSize', PO.MarkerSize, 'ForceLegend', ForceLegend, ...
                    'LegLoc', PO.locLegend, ...
                    'SplitHeader', PO.SplitHeader, ...
                    'Decimation', PO.Decimation, 'PlotOrder', PO.PlotOrder, ...
                    'TimeTagUnits', PO.TimeTagUnits);
                if(PO.BlankYLabel)
                    ylabel('');
                end
                if(iMeasSet == 1)
                    % Construct the Header and Footer:
                    [lstHeader] = BuildHeader(SourceData2Plot, PO);
                    title(lstHeader, 'Interpreter', 'tex');
                end
                
                if(~isempty(PO.locLabel))
                    strLabel = strrep(strLabel, '_', '\_');
                    label(strLabel, PO.locLabel);
                    if(numDiffSet == 1)
                        ystr = lst_diffts.DataInfo.Unit;
                    else
                        ystr = lst_diffts{1}.DataInfo.Unit;
                    end
                    if(~PO.BlankYLabel)
                        ylabel(ystr);
                    end                 
                end
            end
        end
    end
end

end % << End of function PlotMeasurands >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720

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
