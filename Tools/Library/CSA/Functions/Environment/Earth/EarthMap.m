% EARTHMAP Plots Earth's Landmasses, Rivers, and Cities given Lat/Lon Bounds
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% EarthMap:
%     Plots the Earth's land masses, rivers, and cities given latitude and
%     longitude bounds.
% 
% SYNTAX:
%	fighdl = EarthMap(LatLimits_deg, LonLimits_deg, varargin, 'PropertyName', PropertyValue)
%	fighdl = EarthMap(LatLimits_deg, LonLimits_deg, varargin)
%	fighdl = EarthMap(LatLimits_deg, LonLimits_deg)
%	fighdl = EarthMap(LatLimits_deg)
%	fighdl = EarthMap()
%
% INPUTS: 
%	Name         	Size		Units		Description
%	LatLimits_deg	[2]         [deg]       Geodetic latitude limits for 
%                                           map, [min max]
%	LonLimits_deg	[2]         [deg]       Longitude limits for map, 
%                                           [min max]
%	varargin	[N/A]		[varies]        Optional function inputs that
%                                            should be entered in pairs.
%                                            See the 'VARARGIN' section
%                                            below for more details
%
% OUTPUTS: 
%	Name         	Size		Units		Description
%   fighdl          [1]         [int]       Figure handle containing the
%                                            Earth map
%
% NOTES:
%   If LatLimit_deg and/or LonLimit_deg is not defined, values for the Los
%   Angeles area will be used.  Latitude will default to  [32 35.5] deg and
%   Longitude will default to [-121 -116.5].
%
%   EarthMap uses the MATLAB Mapping Toolbox.  In order to plot on the
%   EarthMap, use 'geoshow' instead of 'plot', and 'textm' instead of
%   'text'.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'IncludeRunways'    boolean         true        Include runways when
%                                                    plotting default
%                                                    points of interest?
%   'POIs'              Cell Structure  {}          User defined points of
%                                                    interest to include.
%                                                    See Note #1 for
%                                                    structure format.
%
% Note #1: POI Structure
%	POIs(n)         {struct}    [N/A]       Output structure
%    .Name          'string'    [char]      Point of Interest
%    .Latitude_deg  [1]         [deg]       Latitude
%    .Longitude_deg [1]         [deg]       Longitude
%
% EXAMPLES:
%	% Example #1: Plot the Los Angeles (default) area
%   figure();
%	[fighdl] = EarthMap()
%
%	% Example #2: Plot the New York City area
%   figure();
%	[fighdl] = EarthMap([39.8 40.9], [-75.2 -73.5]);
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit EarthMap.m">EarthMap.m</a>
%	  Driver script: <a href="matlab:edit Driver_EarthMap.m">Driver_EarthMap.m</a>
%	  Documentation: <a href="matlab:winopen(which('EarthMap_Function_Documentation.pptx'));">EarthMap_Function_Documentation.pptx</a>
%
% See also GetPOIInfo 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/756
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Earth/EarthMap.m $
% $Rev: 3255 $
% $Date: 2014-10-02 11:01:36 -0500 (Thu, 02 Oct 2014) $
% $Author: sufanmi $

function [fighdl] = EarthMap(LatLimits_deg, LonLimits_deg, varargin)

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
fighdl= gcf;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[IncludeRunways, varargin]      = format_varargin('IncludeRunways', 0, 2, varargin);
[lstUserPOIs, varargin]         = format_varargin('POIs', {}, 2, varargin);
[ShowDTED, varargin]            = format_varargin('ShowDTED', false, 2, varargin);
[DTEDData, varargin]            = format_varargin('DTEDData', {}, 2, varargin);
[ShowDTEDContour, varargin]     = format_varargin('ShowDTEDContour', ShowDTED, 2, varargin);
[ShowDTEDBreakpoints, varargin] = format_varargin('ShowDTEDBreakpoints', false, 2, varargin);
[ContourInterval_var, varargin] = format_varargin('ContourInterval', 100, 2, varargin);
[ShowContourText, varargin]     = format_varargin('ShowContourText', false, 2, varargin);
[DTEDUseEnglish, varargin]      = format_varargin('DTEDUseEnglish', true, 2, varargin);


 switch(nargin)
      case 0
       LonLimits_deg= ''; LatLimits_deg= ''; 
      case 1
       LonLimits_deg= ''; 
 end

 if(isempty(LatLimits_deg))
     LatLimits_deg = [32 35.5];
 end
  
 if(isempty(LonLimits_deg))
     LonLimits_deg = [-121 -116.5];
 end

 if( LatLimits_deg(1) > LatLimits_deg(2) )
     LatLimits_deg = fliplr(Lat_Limits_deg);
 end

 flgMapToolbox = license('test','map_toolbox');
 
 if(~flgMapToolbox)
     xlim(LonLimits_deg);
     ylim(LatLimits_deg);
     set(gca, 'FontWeight', 'bold');
%      set(gcf, 'color', [0.4 0.7 .95])
%      set(gca, 'color', 'g');
%      set(gca, 'color', [0 172 32]/256);
     grid on;
%     axis off
     
 else
 
 if( LonLimits_deg(1) < LonLimits_deg(2) )
     states = shaperead('usastatehi',...
         'UseGeoCoords', true, 'BoundingBox', [LonLimits_deg', LatLimits_deg']);
     flgUS = size(states, 1) > 0;
 else
     % LonLimits are reversed meaning that it crosses international date
     % line (+/-180 deg), so just default to the world map
     flgUS = 0;
 end

if(flgUS)
    ax = usamap(LatLimits_deg,LonLimits_deg);
    setm(ax, 'ffacecolor', [0.4 0.7 .95])
    axis off
    stateColor = [0.5 0.7 0.5];
    geoshow(ax, states, 'FaceColor', stateColor);
    
    for k = 1:numel(states)
        labelPointIsWithinLimits =...
            LatLimits_deg(1) < states(k).LabelLat &&...
            LatLimits_deg(2) > states(k).LabelLat &&...
            LonLimits_deg(1) < states(k).LabelLon &&...
            LonLimits_deg(2) > states(k).LabelLon;
        if labelPointIsWithinLimits
            textm(states(k).LabelLat,...
                states(k).LabelLon, states(k).Name, ...
                'HorizontalAlignment', 'center', ...
                'FontWeight', 'bold', 'FontSize', 12)
        end
    end
    
else
    ax = worldmap(LatLimits_deg, LonLimits_deg);
    setm(ax, 'ffacecolor', [0.4 0.7 .95])
    axis off
    
    land = shaperead('landareas', 'UseGeoCoords', true);
    geoshow(ax, land, 'FaceColor', [0.5 0.7 0.5])
end



xlimits = xlim;
ylimits = ylim;

%% DTED Setup
if(ShowDTED)
    
    [matDTEDLat_deg, matDTEDLon_deg] = meshgrid(DTEDData.Lat_deg, DTEDData.Lon_deg);
    
    if(DTEDUseEnglish)
        C.FT2M = 0.3048;  % [ft] to [m]
        C.M2FT = 1/C.FT2M;
        tblDTEDAlt_ft = DTEDData.Alt_m'*C.M2FT;
        iLT0 = find(tblDTEDAlt_ft <= 0);
        tblDTEDAlt_ft(iLT0) = -1;
        geoshow(matDTEDLat_deg, matDTEDLon_deg, tblDTEDAlt_ft, 'DisplayType', 'texturemap')
        demcmap(tblDTEDAlt_ft)
        daspectm('m',1)
        if(ShowDTEDContour)
            geoshow(matDTEDLat_deg, matDTEDLon_deg, tblDTEDAlt_ft, 'DisplayType', 'contour', ...
                'LineColor', 'black', 'LevelStep', ContourInterval_var, ...
                'ShowText', bool2str(ShowContourText, 'on', 'off'));
        end
        
    else
        tblDTEDAlt_m = DTEDData.Alt_m';
        iLT0 = find(tblDTEDAlt_m <= 0);
        tblDTEDAlt_m(iLT0) = -1;
        geoshow(matDTEDLat_deg, matDTEDLon_deg, tblDTEDAlt_m, 'DisplayType', 'texturemap')
        demcmap(tblDTEDAlt_m)
        daspectm('m',1)
        if(ShowDTEDContour)
            geoshow(matDTEDLat_deg, matDTEDLon_deg, tblDTEDAlt_m, 'DisplayType', 'contour', ...
                'LineColor', 'black', 'LevelStep', ContourInterval_var, ...
                'ShowText', bool2str(ShowContourText, 'on', 'off'));
        end
    end

    if(ShowDTEDBreakpoints)
        numLat = length(DTEDData.Lat_deg);
        numLon = length(DTEDData.Lon_deg);
        numPts = numLat * numLon;
        
        arrLat = reshape(matDTEDLat, numPts, 1);
        arrLon = reshape(matDTEDLon_deg, numPts, 1);
        geoshow(arrLat, arrLon, 'Marker', 'x', 'Color', 'black', 'MarkerSize', 8);
    end
    
end

lakes = shaperead('worldlakes', 'UseGeoCoords', true);
geoshow(lakes, 'FaceColor', 'blue');
rivers = shaperead('worldrivers', 'UseGeoCoords', true);
geoshow(rivers, 'Color', 'blue');
xlim(xlimits);
ylim(ylimits);
 end
%% Process Cities and Points of Interest:
lstPOIs = GetPOIInfo('all', 'IncludeRunways', IncludeRunways);

if(~isempty(lstUserPOIs))
    lstPOIs = [lstPOIs; lstUserPOIs];   % TODO: Make this smarter
end

for iPOI = 1:numel(lstPOIs)
    curPOI = lstPOIs(iPOI);
    labelPointIsWithinLimits =...
        LatLimits_deg(1) < curPOI.Latitude_deg &&...
        LatLimits_deg(2) > curPOI.Latitude_deg &&...
        LonLimits_deg(1) < curPOI.Longitude_deg &&...
        LonLimits_deg(2) > curPOI.Longitude_deg;
    
    if labelPointIsWithinLimits
        if( flgMapToolbox )
            geoshow(curPOI.Latitude_deg, curPOI.Longitude_deg, 'Marker', '.', 'Color', 'red', 'MarkerSize', 8)
            textm(curPOI.Latitude_deg, curPOI.Longitude_deg, curPOI.Name, ...
                'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', ...
                'FontWeight', 'bold', 'FontSize', 8, 'FontAngle', 'italic');
        else
            plot(curPOI.Longitude_deg, curPOI.Latitude_deg, 'Marker', '.', 'Color', 'red', 'MarkerSize', 8)
            text(curPOI.Longitude_deg, curPOI.Latitude_deg, curPOI.Name, ...
                'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', ...
                'FontWeight', 'bold', 'FontSize', 8, 'FontAngle', 'italic');
            xlim(LonLimits_deg);
            ylim(LatLimits_deg);
        end
    end
end

hold on;

end % << End of function EarthMap >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 120725 <INI>: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName            : Email     : NGGN Username 
% <initials>: <Fullname>   : <email>   : <NGGN username> 

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
