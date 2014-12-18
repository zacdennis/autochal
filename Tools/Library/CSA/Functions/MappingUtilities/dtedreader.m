% DTEDREADER Compiles Terrain Map using U.S. Department of Defence Digital Terrain Elevation Data (DTED)
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% dtedreader:
%    Function uses MATLAB's Mapping Toolbox function 'dted' to load in a
%    directory of U.S. Department of Defense Digital Terain Elevation Data
%    (DTED).  It then computes the associated latitude and longitude
%    vectors which are needed for 2-D interpolation of the ground altitude
%    map.
%
% SYNTAX:
%	[Terrain] = dtedreader(RootDirectory, varargin, 'PropertyName', PropertyValue)
%	[Terrain] = dtedreader(RootDirectory, varargin)
%	[Terrain] = dtedreader(RootDirectory)
%
% INPUTS:
%	Name         	Size		Units		Description
%	RootDirectory	'string'    [char]      Root directory containing DTED data
%	varargin        [N/A]		[varies]	Optional function inputs that
%                                            should be entered in pairs.
%                                            See the 'VARARGIN' section
%                                            below for more details
%
% OUTPUTS:
%	Name         	Size		Units		Description
%	Terrain	      <size>		<units>		<Description>
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[Terrain] = dtedreader(RootDirectory, varargin)
%	% <Copy expected outputs from Command Window>
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit dtedreader.m">dtedreader.m</a>
%	  Driver script: <a href="matlab:edit Driver_dtedreader.m">Driver_dtedreader.m</a>
%	  Documentation: <a href="matlab:winopen(which('dtedreader_Function_Documentation.pptx'));">dtedreader_Function_Documentation.pptx</a>
%
% See also dted
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/810
%
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MappingUtilities/dtedreader.m $
% $Rev: 3059 $
% $Date: 2013-12-17 19:27:52 -0600 (Tue, 17 Dec 2013) $
% $Author: sufanmi $

function [Terrain] = dtedreader(RootDirectory, varargin)

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

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
Default.LatBounds = [];     % [deg]
Default.LonBounds = [];     % [deg]
[Bounds2Use, varargin]  = format_varargin('Bounds2Use', Default, 2, varargin);

%% Main Function:
LatBounds = Bounds2Use.LatBounds;
LonBounds = Bounds2Use.LonBounds;

if(isempty(LatBounds) || isempty(LonBounds))
    % Figure out the Lat/Lon Bounds
    lstFiles = dir_list('', 1, 'Root', RootDirectory, 'FileExclude', {'.dir';'.min';'.max';'.dt';'.txt';'dmed'});
    lstFiles = strrep(lstFiles, RootDirectory, '');
    lstFiles = strrep(lstFiles, '\dted\', '');
    lstFiles = strrep(lstFiles, '.avg', '');
    lstFiles = strrep(lstFiles, '\', ',');
    lstFiles = strrep(lstFiles, 'n', '');
    lstFiles = strrep(lstFiles, 's', '-');
    lstFiles = strrep(lstFiles, 'w', '-');
    lstFiles = strrep(lstFiles, 'e', '');
    numFiles = size(lstFiles, 1);
    
    for i = 1:numFiles
        curRow = lstFiles{i};
        ptrComma = strfind(curRow, ',');
        curLon = str2double(curRow(1:(ptrComma-1)));
        curLat = str2double(curRow((ptrComma+1):end));
        if(i == 1)
            LatBounds = [curLat curLat];
            LonBounds = [curLon curLon];
        else
            LatBounds(1) = min(LatBounds(1), curLat);
            LatBounds(2) = max(LatBounds(2), curLat);
            LonBounds(1) = min(LonBounds(1), curLon);
            LonBounds(2) = max(LonBounds(2), curLon);
        end
    end
end

LatBounds(1) = floor(LatBounds(1));
LatBounds(2) = ceil(LatBounds(2));
LonBounds(1) = floor(LonBounds(1));
LonBounds(2) = ceil(LonBounds(2));
[z,refvec,uhl, dsi, acc] = dted(RootDirectory, 1, LatBounds, LonBounds);

% Build the Lat/Lon Arrays
arrLat = [];
arrLon = [];

[numLatFiles, numLonFiles] = size(dsi);
for iLatFile = 1:numLatFiles
    for iLonFile = 1:numLonFiles
        curDSI = dsi(iLatFile, iLonFile);
        
        flgData = ~isempty(curDSI.RecognitionSentinel);
        
        if(flgData)
            % Filter Latitude
            curNS = curDSI.Latitudeoforigin(end);
            LatStart = str2double(curDSI.Latitudeoforigin(1:end-7));
            numLatPts = str2double(curDSI.NumberofLatitudelines);
            
            if(strcmp(upper(curNS), 'N'))
                dirNS = 1;  % Going North
                LatEnd = LatStart + dirNS;
                Lat2Add = [LatStart : 1/(numLatPts-1) : LatEnd];
            else
                % Going South
                %   TBD: Haven't tested this section
                LatEnd = LatStart + -1;
                Lat2Add = [LatStart : -1/(numLatPts-1) : LatEnd];
            end
            arrLat = [arrLat Lat2Add];
            
            % Filter Longitude
            curEW = curDSI.Longitudeoforigin(end);
            LonStart = str2double(curDSI.Longitudeoforigin(1:end-7));
            numLonPts = str2double(curDSI.NumberofLongitudelines);
            if(strcmp(upper(curEW), 'W'))
                % Going West
                LonStart = -LonStart;
                LonEnd = LonStart + 1;
                Lon2Add = [LonStart : 1/(numLonPts-1) : LonEnd];
            else
                dirEW = 1;  % Going East
                LonEnd = LonStart + dirEW;
                Lon2Add = [LonStart : 1/(numLonPts-1) : LonEnd];
            end
            
            arrLon = [arrLon Lon2Add];
        end
    end
end

% Filter Out Duplicates
arrLat = unique(arrLat);
arrLon = unique(arrLon);

Terrain.Title       = 'DTED Data for Western US';
Terrain.Description = 'Ground Alt [m] = fcn( Latitude [deg], Longitude [deg])';
Terrain.Lat_deg     = arrLat;
Terrain.Lon_deg     = arrLon;
Terrain.Alt_m       = z;        clear z;

Terrain.uhl         = uhl;
Terrain.dsi         = dsi;
Terrain.acc         = acc;

end % << End of function dtedreader >>

%% REVISION HISTORY
% YYMMDD INI: note
% 130808 MWS: Created function
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
