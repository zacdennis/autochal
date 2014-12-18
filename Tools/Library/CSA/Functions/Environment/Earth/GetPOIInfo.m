% GETPOIINFO Loads LLA for various Points of Interest
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GetPOIInfo:
%     Retrieves the Latitude, Longiude, & Altitude for various Points of
%     Interest
% 
% SYNTAX:
%	[POI] = GetPOIInfo(strLocal, varargin, 'PropertyName', PropertyValue)
%	[POI] = GetPOIInfo(strLocal, varargin)
%	[POI] = GetPOIInfo(strLocal)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	strLocal	'string'    [char]      Desired point of interest
%                                        Using 'all' will return entire
%                                        structure of available POI points
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name            Size		Units		Description
%	POI             {struct}    [N/A]       Output structure
%    .Name          'string'    [char]      Flight Test Site
%    .Source        'string'    [char]      Reference website
%    .Latitude_deg  [1]         [deg]       Latitude
%    .Longitude_deg [1]         [deg]       Longitude
%    .Elevation_ft  [1]         [ft]        Field elevation
%    .PsiMag_deg    [1]         [deg]       Magnetic heading
%    .PsiTrue_deg   [1]         [deg]       True heading
%
%
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'IncludeRunways'    boolean         true        Include runways in POI structure?
%                                                    Only used if all
%                                                    points are returned
%
%   'RefPOIs'           string          'EarthPOIs' Reference dataset (.mat
%                                                    file) to load
%                                                    containing various
%                                                    points of interest
%   'UserPOIs'          [1xN struct]    {}          User provided points of
%                                                    interest.  Must be a a
%                                                    structure with fields
%                                                    matching output 'POI'
% EXAMPLES:
%	% Retrieve information on LAX
%	POI = GetPOIInfo('LAX')
%	% returns POI =
%   %              Name: 'LAX'
%   %            Source: 'http://www.airnav.com/airport/KLAX'
%   %      Latitude_deg: 33.9425
%   %     Longitude_deg: -118.4081
%   %      Elevation_ft: 125
%   %        PsiMag_deg: 0
%   %       PsiTrue_deg: 0
%
%	% Retrieve all known points of interest
%	POI = GetPOIInfo()  % -or-
%	POI = GetPOIInfo('all')
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit GetPOIInfo.m">GetPOIInfo.m</a>
%	  Driver script: <a href="matlab:edit Driver_GetPOIInfo.m">Driver_GetPOIInfo.m</a>
%	  Documentation: <a href="matlab:winopen(which('GetPOIInfo_Function_Documentation.pptx'));">GetPOIInfo_Function_Documentation.pptx</a>
%
% See also shaperead, Build_EarthPOIs
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/755
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Earth/GetPOIInfo.m $
% $Rev: 2639 $
% $Date: 2012-11-08 15:21:40 -0600 (Thu, 08 Nov 2012) $
% $Author: sufanmi $

function [POI] = GetPOIInfo(strLocal, varargin)

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
[IncludeRunways_flg, varargin]  = format_varargin('IncludeRunways', 1, 2, varargin);
[RefPOIs, varargin]             = format_varargin('RefPOIs', 'EarthPOIs', 2, varargin);
[UserPOIs, varargin]            = format_varargin('UserPOIs', {}, 2, varargin);

if(nargin < 1)
    strLocal = '';
end

if(strcmp(lower(strLocal), 'all'))
    strLocal = '';
end

%% List of additional cities/points of interest to add
i = 0; lstPOIsToAdd = {};

load(RefPOIs);  % Returns 'lstPOI'

if(~isempty(UserPOIs))
    lstPOI = [lstPOI UserPOIs];
end

%%
if(~isempty(strLocal))
    strSearch = lower(strLocal);
    strSearch = strrep(strSearch, ' ', '_');
    
    for iPOI = 1:numel(lstPOI)
        curName = lstPOI(iPOI).Name;
        curName = lower(curName);
        curName = strrep(curName, ' ', '_');
        if(strmatch(strSearch, curName))
            POI = lstPOI(iPOI);
        end
    end
    
else
    if(IncludeRunways_flg)
        POI = lstPOI;
    else
        
        i = 0; POI = {};
        for iPOI = 1:numel(lstPOI)
            curPOI = lstPOI(iPOI);
            
            if( (curPOI.PsiMag_deg == 0) && (curPOI.PsiTrue_deg == 0) )
                i = i + 1;
                if(i == 1)
                    POI = curPOI;
                else
                    POI(i) = curPOI;
                end
            end
        end
    end

end % << End of function GetPOIInfo >>

if(nargin == 0)
    
    tblPOI = cell(numel(lstPOI), 1);
    for iPOI = 1:numel(lstPOI)
        curPOI = lstPOI(iPOI);
        tblPOI{iPOI} = sprintf('%3d - %s', iPOI, curPOI.Name);
    end
    disp(tblPOI);
end


%% REVISION HISTORY
% YYMMDD INI: note
% 120725 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         : Email                 : NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi

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
