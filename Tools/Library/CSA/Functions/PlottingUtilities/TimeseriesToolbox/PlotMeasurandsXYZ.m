% PLOTMEASURANDSXYZ plots two measurands against each other.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% PlotMeasurandsXYZ:
% Utility plotting function used by VSI_LIB TIMESERIES_TOOLBOX.  Plots two
% measurands against each other (e.g. Lat vs Lon).  Multiple combinations
% of measurands can be plotted on top of each other from multiple sources.
% 
% SYNTAX:
%	[arrHdl, strLegend] = PlotMeasurandsXYZ(SourceData2Plot, lstMeasurandSets, PO, varargin, 'PropertyName', PropertyValue)
%	[arrHdl, strLegend] = PlotMeasurandsXYZ(SourceData2Plot, lstMeasurandSets, PO, varargin)
%	[arrHdl, strLegend] = PlotMeasurandsXYZ(SourceData2Plot, ...
%                                               lstMeasurandSets, PO)
%
% INPUTS: 
%	Name            	Size		Units		Description
% SourceData2Plot       {struct}                Contains all source data & info
%   .Results            {struct}                'Results' structure from
%                                                ParseRecordedData2ts
%   .Title              [string]                Description of data (e.g. version,
%                                                configuration, etc)
%   .toffset            [sec]                   Time offset to shift data
%   .filename           [string]                Filename of plotted data
%
% lstMeasurandSets      {nested cells}
%   {:,1}:                                      Measurand to Plot on X-axis
%   {:,2}:                                      Measurand to Plot on Y-axis
%   {:,3}:                                      Legend Position for plot 
%                                                (default is 'NorthEast')
%
% PO                    {struct}                Plot Options
%   .xmin               [1]                     Lower plot bounds   (default: [])
%   .xmax               [1]                     Upper plot bounds   (default: [])
%   .Title              [string]                Additonal Title     (default: '')
%   .Decimation         [1]                     Marker Decimation   (default: every
%                                                5 seconds)
%   .ForceLegend        [bool]                  {0}/1: Lists signals and units as
%                                                legend entries
%   .titlefont1         [1]                     Main Title Font     (default: 12)
%   .titlefont2         [1]                     Minor Title Font    (default: 10)
%   .LineWidth          [1]                     Line Width          (default: 1.5)
%   .MarkerSize         [1]                     Marker Size         (default: 10)
%   .FigurePosition     [1x4]                   Figure Size        (matlab default)
%   .PlotTime           [1]                     Plot Time Markers   (default: true)
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name            	Size		Units		Description
%	arrHdl	          <size>		<units>		<Description> 
%	strLegend	       <size>		<units>		<Description> 
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
% SourceData2Plot(1).Results = Results;
% SourceData2Plot(1).Title   = 'No Failures';
% SourceData2Plot(1).toffset = 0;
% SourceData2Plot(1).filename= '\\network_drive\rev50\Results.mat';
%
% EX #1: Plot Latitude vs Longitude:
%
% PlotMeasurandsXY(SourceData2Plot, ...
%     {{'LL.StateBus.Longitude', 'LL.StateBus.GeodeticLat'}, ''}, PO);
%
% EX #2: Plot Pb vs PbDot, adjusting units to be in [deg/sec] & [deg/sec^2]:
%
% PlotMeasurandsXY(SourceData2Plot, ...
%     {'LL.StateBus.PQRbody(1)*C.R2D', 'LL.StateBus.PQRbodyDot(1)*C.R2D'},
%     PO);
%
%	% <Enter Description of Example #1>
%	[arrHdl, strLegend] = PlotMeasurandsXYZ(SourceData2Plot, lstMeasurandSets, PO, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[arrHdl, strLegend] = PlotMeasurandsXYZ(SourceData2Plot, lstMeasurandSets, PO)
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
%	Source function: <a href="matlab:edit PlotMeasurandsXYZ.m">PlotMeasurandsXYZ.m</a>
%	  Driver script: <a href="matlab:edit Driver_PlotMeasurandsXYZ.m">Driver_PlotMeasurandsXYZ.m</a>
%	  Documentation: <a href="matlab:pptOpen('PlotMeasurandsXYZ_Function_Documentation.pptx');">PlotMeasurandsXYZ_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/523
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/PlotMeasurandsXYZ.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [arrHdl, strLegend] = PlotMeasurandsXYZ(SourceData2Plot, lstMeasurandSets, PO, varargin)

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
% arrHdl= -1;
% strLegend= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        PO= ''; lstMeasurandSets= ''; SourceData2Plot= ''; 
%       case 1
%        PO= ''; lstMeasurandSets= ''; 
%       case 2
%        PO= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(PO))
%		PO = -1;
%  end
%% Main Function:
numDataset      = size(SourceData2Plot, 2);
numMeasurandSets= size(lstMeasurandSets, 1);
numMeasurandCols= size(lstMeasurandSets, 2);

% Plot Option Defaults:
PO = format_struct(PO, 'xmin', []);
PO = format_struct(PO, 'xmax', []);
PO = format_struct(PO, 'LineWidth', 1.5);
PO = format_struct(PO, 'MarkerSize', 10);
PO = format_struct(PO, 'ForceLegend', 0);
PO = format_struct(PO, 'Decimation', 5);
PO = format_struct(PO, 'flgUseShortName', 0);
PO = format_struct(PO, 'FigurePosition', []);
PO = format_struct(PO, 'XDir', 'normal');

PO = format_struct(PO, 'TimeTagShow', 1);
PO = format_struct(PO, 'TimeTagAngle', 0);
PO = format_struct(PO, 'TimeTagLength', -1);
PO = format_struct(PO, 'TimeTagFrame', 'axis');
PO = format_struct(PO, 'TimeTagUseZForLabel', 0);

arrMarkers = {'x' 'o' 'v' '*' '^' 's' 'd'};
arrColors = {'b' 'g' 'r' 'c' 'm'};
numColors = length(arrColors);
ptrLine = 0;

ictr = 0;

% Loop Through Each MeasurandSet:
for iMeasSet = 1:numMeasurandSets
    lstMeasurands = lstMeasurandSets{iMeasSet,1};
    
    if(iscell(lstMeasurands))
        numMeasurands   = size(lstMeasurands, 1);
    else
        lstMeasurands = { lstMeasurands };
        numMeasurands = 1;
    end
    
    numMeasurands   = size(lstMeasurands, 1);
    
    fig_hdl = figure();
    
    if(~isempty(PO.FigurePosition))
        set(fig_hdl, 'position', PO.FigurePosition);
    end
    
    for iMeas = 1:numMeasurands
        xStr2Plot  = lstMeasurands{iMeas, 1};
        yStr2Plot  = lstMeasurands{iMeas, 2};
        zStr2Plot  = lstMeasurands{iMeas, 3};
        
        % Loop Through Each Dataset:
        for iData2Plot = 1:numDataset;
            Results     = SourceData2Plot(iData2Plot).Results;
            toffset     = SourceData2Plot(iData2Plot).toffset;
            strTitle    = SourceData2Plot(iData2Plot).Title;
            
            tsxRaw = getts(Results, xStr2Plot, toffset, 'xmin', [], 'xmax', [] );
            
            if(~isempty(PO.xmin))
                iptr = find(tsxRaw.Data <= PO.xmin, 1, 'first');
                timeStart = floor(tsxRaw.Time(iptr));

                tsx = getts(Results, xStr2Plot, toffset, 'xmin', timeStart, 'xmax', [] );
                tsy = getts(Results, yStr2Plot, toffset, 'xmin', timeStart, 'xmax', [] );
                tsz = getts(Results, zStr2Plot, toffset, 'xmin', timeStart, 'xmax', [] );
            else
                
                tsx = getts(Results, xStr2Plot, toffset, 'xmin', PO.xmin, 'xmax', PO.xmax );
                tsy = getts(Results, yStr2Plot, toffset, 'xmin', PO.xmin, 'xmax', PO.xmax );
                tsz = getts(Results, zStr2Plot, toffset, 'xmin', PO.xmin, 'xmax', PO.xmax );
            end
            
            if(numDataset > 1)
                tsx.DataInfo.UserData = sprintf('ds%d', iData2Plot);
            end
            
            if(PO.flgUseShortName)
                ptrx = strfind(tsx.Name, '.');
                if(~isempty(ptrx))
                    tsx.Name = tsx.Name((ptrx(end)+1):end);
                end
                
                ptry = strfind(tsy.Name, '.');
                if(~isempty(ptry))
                    tsy.Name = tsy.Name((ptry(end)+1):end);
                end
                
                ptrz = strfind(tsz.Name, '.');
                if(~isempty(ptrz))
                    tsz.Name = tsz.Name((ptrz(end)+1):end);
                end
                
            end
            
            ptrLine = ptrLine + 1;
            iMarker2Use = ceil(ptrLine/numColors);
            Marker2Use  = char(arrMarkers(iMarker2Use));
            
            iColor2Use  = mod((ptrLine-1), numColors) + 1;
            Color2Use   = char(arrColors(iColor2Use));
            
            Line2Use    = '-';
            FullMarker2Use = [Color2Use Marker2Use Line2Use];
                        
            lh = plotts_xyz(tsx, tsy, tsz, FullMarker2Use, ...
                'LineWidth', PO.LineWidth, 'MarkerSize', PO.MarkerSize, ...
                'Decimation', PO.Decimation, 'XDir', PO.XDir, ...
                'TimeTagShow', PO.TimeTagShow, 'TimeTagAngle', PO.TimeTagAngle, ...
                'TimeTagLength', PO.TimeTagLength, 'TimeTagFrame', PO.TimeTagFrame, ...
                'TimeTagUseZForLabel', PO.TimeTagUseZForLabel);    
            
            hold on;
            arrHdl(ptrLine) = lh;
            
            strx = [tsx.Name ' ' tsx.DataInfo.Units];
            stry = [tsy.Name ' ' tsy.DataInfo.Units];         
            strz = [tsz.Name ' ' tsz.DataInfo.Units];
            
            if((numMeasurands == 1) && (numDataset > 1))
                strLegend{ptrLine,:} = strTitle;
                PO.SkipDataNames = 1;
            else
                strLegend{ptrLine,:} = [strx ' vs. ' stry ' vs. ' strz];
            end
            
        end
    end
    
    if(~isempty(PO.xmin))
        xlimits = xlim;
        if(strcmp(PO.XDir, 'normal'))
            xlimits(1) = PO.xmin;
        else
            xlimits(2) = PO.xmin;
        end
        xlim(xlimits);
    end
    
    if(~isempty(arrHdl))
        if((numMeasurands > 1) || (PO.ForceLegend))
            if(numMeasurandCols > 1)
                PO.locLegend = lstMeasurandSets{iMeasSet, 2};
            end
            
            if(isempty(PO.locLegend))
                PO.locLegend = 'NorthEast';
            end
            legend(arrHdl, strLegend, 'Location', PO.locLegend);
            xlabel('');
            ylabel('');
            zlabel('');
        end
    end
    
    % Construct the Header and Footer:
    [lstHeader] = BuildHeader(SourceData2Plot, PO);
    title(lstHeader, 'Interpreter', 'tex');
    
end

%% Compile Outputs:
%	arrHdl= -1;
%	strLegend= -1;

end % << End of function PlotMeasurandsXYZ >>

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
