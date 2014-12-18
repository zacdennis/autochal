% EARTHSURFACEINIT creates an initial Ground structure for the environment
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% EarthSurfaceInit:
%     <Function Description> 
% 
% SYNTAX:
%	[Ground] = EarthSurfaceInit(flgPlotSurface, varargin, 'PropertyName', PropertyValue)
%	[Ground] = EarthSurfaceInit(flgPlotSurface, varargin)
%	[Ground] = EarthSurfaceInit(flgPlotSurface)
%
% INPUTS: 
%	Name          	Size		Units		Description
%	flgPlotSurface	[1]         boolean		if true, the initialized ground
%                                           will be plotted.
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name          	Size		Units		Description
%	Ground	        Structure               Contains the ground information
%   .arrPn
%   .arrPe
%   .tablePd
%   .arrLat
%   .arrLon
%   .tableAlt
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
%	[Ground] = EarthSurfaceInit(flgPlotSurface, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Ground] = EarthSurfaceInit(flgPlotSurface)
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
%	Source function: <a href="matlab:edit EarthSurfaceInit.m">EarthSurfaceInit.m</a>
%	  Driver script: <a href="matlab:edit Driver_EarthSurfaceInit.m">Driver_EarthSurfaceInit.m</a>
%	  Documentation: <a href="matlab:pptOpen('EarthSurfaceInit_Function_Documentation.pptx');">EarthSurfaceInit_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/642
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Earth/EarthSurfaceInit.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Ground] = EarthSurfaceInit(flgPlotSurface, varargin)

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
% Ground= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        flgPlotSurface= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:
if nargin < 1
    flgPlotSurface = 0;
end

conversions;

Ground.Units    = 'English [m]';
Ground.Description  = 'Simple Earth Surface';

%% BaseTerrain Information
BaseTerrain.Length = 10000;
BaseTerrain.Width = 10000;
BaseTerrain.Alt   = 0;
BaseTerrain = BuildSurface(BaseTerrain, 'CentralBody');
i = 1;
Grounds(i).Ground = BaseTerrain;

%% Add Surface to Base Terrain:
i = i + 1;
Surface.Alt = 2*0;
Surface.Length = 10000;       % [m]
Surface.Width = 10000;         % [m]
Surface.Pned = [-Surface.Length/2; 0; -Surface.Alt];
Surface.Euler_ned(1) = 0.0;      % [deg]     Ground / Surface Roll Slope
Surface.Euler_ned(2) = 0.0;      % [deg]     Ground / Surface Pitch Slope
Surface.Euler_ned(3) = 0.0;      % [deg]     Ground / Surface Heading
Surface.V_ned        = [0 0 0];  % [ft/s]    Ground / Surface Velocity
Surface.PQRb         = [0 0 0];  % [rad/s]   Ground / Surface Body Rates
Surface = BuildSurface(Surface, 'Flat');
Grounds(i).Ground = Surface;

%% Mesh Surfaces Together:
Ground = BuildGround(Grounds);
Ground.arrLat = [-90 -30 30 90];
Ground.arrLon = [-180 -60 60 180];
Ground.tableAlt = -Ground.tablePd;
%% Plot Results:
if(flgPlotSurface)
close all;
PlotRunway(Surface);
PlotRunway(Ground);
end

%% Compile Outputs:
%	Ground= -1;

end % << End of function EarthSurfaceInit >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101022 JPG: Copied over information from the old function.
% 101022 CNF: Function template created using CreateNewFunc
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
