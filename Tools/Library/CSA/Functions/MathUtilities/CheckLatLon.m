% CHECKLATLON Adjusts Latitude and Longitude to be within the limits.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CheckLatLon:
%   Adjusts Latitude to be within +/- 90 deg and Longitude to be within +/-
%   180 deg.
% 
% SYNTAX:
%	[Lat, Lon] = CheckLatLon(Lat0, Lon0)
%
% INPUTS: 
%	Name		Size		Units		Description
%	Lat0 		Varies		[deg]  		Input Latitude (-inf < Lat0 < inf)
%	Lon0 		Varies		[deg]  		Input Longitude(-inf < Lon0 < inf)
%
% OUTPUTS: 
%	Name		Size		Units		Description
%	Lat         Varies  	[deg]  		Fixed Latitude (-90 <= Lat <= 90)
%	Lon         Varies		[deg]  		Fixed Longitude(-180 <= Lon <= 180)
%
% NOTES:
%	Lat0 and Lon0 should have the same dimensions, which can be scalar
%	([1]), a vector ([1xN] or [Nx1]), or a multi-dimensional matrix 
%   (M x N x P x ...]).  The outputs Lat and Lon will carry the same
%   dimensions as the inputs.
%
% EXAMPLES:
%  Example 1: Single Use
%  A simple case which runs CheckLatLon with a pair of coordinates.  The
%  longitude is set to 270, which is out of range of the normal global
%  coordinate system.
%
%   Lat0 = 0;               % [deg]
%   Lon0 = 270;             % [deg]
%   [Lat1, Lon1] = CheckLatLon(Lat0, Lon0)
%   Returns  Lat1:   0      % [deg], where -90 <= Lat <= 90
%            Lon1: -90      % [deg], where -180 <= Lon <= 180
%
%  Example 2: Vector Inputs
%  A case when CheckLatLon is run with [1x6] inputs.  The inputs are chosen
%  to show the effects of the wrapping function.  For instance, choosing a
%  latitude outside of the range (going over a pole) shifts the longitude
%  180 degrees.
%
%   Lat0         = [  85    85    85    96      96      96 ];   % [deg]
%   Lon0         = [ 175   180   185   175     180     185 ];   % [deg]
%   [Lat1, Lon1] = CheckLatLon(Lat0, Lon0)
%   Returns Lat1 = [  85    85    85    84      84     84  ]    % [deg]
%           Lon1 = [ 175   180  -175    -5       0      5  ]    % [deg]
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CheckLatLon.m">CheckLatLon.m</a>
%	  Driver script: <a href="matlab:edit Driver_CheckLatLon.m">Driver_CheckLatLon.m</a>
%	  Documentation: <a href="matlab:pptOpen('CheckLatLon_Function_Documentation.pptx');">CheckLatLon_Function_Documentation.pptx</a>
%
% See also haversine vincenty
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/410
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/CheckLatLon.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Lat, Lon] = CheckLatLon(Lat0, Lon0)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

% Examples of Different Display Formats:
% disp([mfnam 'Output with filename included...' ]);
% disp([mfspc 'further outputs will be justified the same']);
% disp([mfspc 'CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam 'WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam 'ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfnam 'ERROR: <define error here> See ' mlink ' help'];      % <-- Couple with error function
% error([mfnam 'class:file:Identifier'], errstr);    % Call error function with error string

%% Input Argument Conditioning:
if nargin < 2
   disp([mfnam ' :: Please refer to useage of' mfnam endl ...
       'Syntax: [Lat, Lon] = CheckLatLon( Lat0, Lon0)']);
   return;
end;

%% Main Function:

%% Fix Latitude to be within 0 and 360
Lat1 = mod(Lat0, 360.0);

%% Compute Latitude to be within +/- 90 deg
Lat = asind( sind(Lat1) );

%% Adjust Longitude for Latitude Correction
%   If Lat1 > 90 and Lat1 < 270, add 180 to Longitude if Lat1 == 90 or 270
%   nothing will be added.
LatCheck = sign(cosd(Lat1));
ind = find(LatCheck == 0);
LatCheck(ind) = 1;
Lon1 = Lon0 + 90.0 .* (1-LatCheck);

%% Fix Longitude to be within +/- 180
Lon = mod(Lon1, 360.0);
ind = find(Lon > 180.0);
Lon(ind) = Lon(ind) - 360.0;
Lat = Lat.*ones(size(Lon));

end % << End of function CheckLatLon >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101007 JPG: Fixed the overly complicated broken error checking.  Just
%             using MATLAB's existing checks. 
% 101005 JPG: Simplified the examples for the help file.
% 100928 JPG: Modified the code to be able to take in vector and matrix
%             inputs.  Also added some error checking.
% 100928 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% JPG: James Patrick Gray   : James.Gray2@ngc.com   : g61720 

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
