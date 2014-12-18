% DMS2DEC Converts Latitude or Longitude Angle in Degrees / Minutes / Seconds 
%   format into Decimal Equivalent.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% dms2dec:
%     Converts Latitude or Longitude Angle in Degrees / Minutes / Seconds 
%     format into Decimal Equivalent.
% 
% SYNTAX:
%	decimal = dms2dec( [degrees minutes seconds], 'lat' )
%   decimal = dms2dec( [degrees minutes seconds], 'lon' )
%
% INPUTS: 
%	Name            Size		Units           Description
%	deg_min_sec     [1x3]       [deg min sec]   Degrees/minutes/seconds
%   dms_type        [1xN]       [ND]            Specify latitude (‘lat’) or
%                                               longitude (‘lon’)
% OUTPUTS: 
%	Name            Size		Units           Description
%	 dec            [1x1]       [deg]           Angle of lat or lon in degrees
%
% NOTES:
%	 Specifying the inputted angle as 'lat' or 'latitude' wraps the 
%    return latitude in [degrees] to -90 <= lat <= 90 deg
%    Specifying the inputted angle as 'lon' or 'longitude' wraps the
%    retun longitude in [degrees] to -180 <= lon <= 180 deg
%
% EXAMPLES:
%	Example 1: Find the decimal angle of longitude and latitude of the following coordinates 
%   Boston, MA: Latitude 42 deg 21' N
%               Longitude 71 deg 04' W
%   lat = dms2dec( [42 21 0], 'lat' )
%   lon = dms2dec( [-71 4 0], 'lon')
%   Returns   lat = 42.35  lon = -71.0667 deg
%
%	Example 2: Find the decimal angle equivalent of the following
%	coordinates
%   Medellin, Colombia: Latitude 10 deg 5' 60 N
%                      Longitude 75 deg 16' W            
%   lat = dms2dec( [10 5 60], 'lat' )
%   lon = dms2dec( [-75 16 0], 'lon')
%   Returns   lat = 10.1  lon = -75.2667 deg
%
% SOURCE DOCUMENTATION:
%	[1]    Duffet-Smith, Peter. Practical Astronomy with you calculator 3ed.
%          Cambridge University press, Cambridge,UK Copyright 1979 p.33
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit dms2dec.m">dms2dec.m</a>
%	  Driver script: <a href="matlab:edit Driver_dms2dec.m">Driver_dms2dec.m</a>
%	  Documentation: <a href="matlab:winopen(which('dms2dec_Function_Documentation.pptx'));">dms2dec_Function_Documentation.pptx</a>
%
% See also dec2dms 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/322
%
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/dms2dec.m $
% $Rev: 3062 $
% $Date: 2014-01-24 11:10:22 -0600 (Fri, 24 Jan 2014) $
% $Author: sufanmi $

function [dec] = dms2dec(deg_min_sec, dms_type)

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
%% Input check
if ischar(deg_min_sec)
    errstr = [mfnam tab 'ERROR: Input of type CHAR. Please input the angles in scalar form' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
%% Main Function:
if nargin == 1
    dms_type = 'null';
end

%% Covert Degrees / Minutes / Seconds into Raw Angle [deg]

ang = abs(deg_min_sec(1));

if(length(deg_min_sec) > 1)
    ang = ang + deg_min_sec(2)/60.0;
end
if(length(deg_min_sec) > 2)
    ang = ang + deg_min_sec(3)/3600.0;
end   

ang = ang * sign(deg_min_sec(1));

%% Check Angle and Wrap if Necessary
switch lower(dms_type)
    case {'lat', 'latitude'}

        %% Wraps Latitude to be within +/- 90 degrees
        dec = asin( sin(ang * pi/180) ) * 180/pi;
        if abs((dec - ang) > 1e-6)
            disp('>> Warning: Computed Latitude exceeded +/-90 deg!')
            disp('>>  Wrapping Angle.  Longitude may be off by 180 degrees!');
        end

    case {'lon', 'longitude'}
        %% Wrap Longitude to be within +/- 180 degrees
        dec = mod(ang, 360.0);
        if dec > 180.0
            dec = dec - 360.0;
        end
        
    otherwise
%         disp('>> Warning: Unidentified Type of Angle Input');
        dec = ang;
end
end 
%% REVISION HISTORY
% YYMMDD INI: note
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/dms2dec.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN Username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : G67086
% MWS: Mike Sufana      : mike.sufana@ngc.com               : sufanmi

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
