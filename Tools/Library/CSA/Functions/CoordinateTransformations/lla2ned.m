% LLA2NED Converts Lat/Lon/Alt Position to Flat North/East/Down Frame
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% lla2ned:
%     Converts Lat/Lon/Alt Position to Flat North/East/Down Frame
% 
% SYNTAX:
%	[P_ned] = lla2ned(LLA, CB)
%
% INPUTS: 
%	Name        Size		Units               Description
%   LLA         [3]         [deg deg length]    Geodetic Lat, Long, and Alt
%   CB          {struct}                        Central Body Structure
%   .a          [1]         [length]            Semi-major Axis
%   .flatten    [1]         [ND]                Flattening Parameter
%
% OUTPUTS: 
%	Name    	Size		Units               Description
%	P_ned       [3]         [length]            North/East/Down Position
%
% NOTES:
%   This function uses CSA functions: CheckLatLon, vincenty
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[P_ned] = lla2ned(LLA, CB, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[P_ned] = lla2ned(LLA, CB)
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
%	Source function: <a href="matlab:edit lla2ned.m">lla2ned.m</a>
%	  Driver script: <a href="matlab:edit Driver_lla2ned.m">Driver_lla2ned.m</a>
%	  Documentation: <a href="matlab:pptOpen('lla2ned_Function_Documentation.pptx');">lla2ned_Function_Documentation.pptx</a>
%
% See also ned2lla, CheckLatLon, vincenty
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/346
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/lla2ned.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [P_ned] = lla2ned(LLA, CB)

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
P_ned= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        CB= ''; LLA= ''; 
%       case 1
%        CB= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(CB))
%		CB = -1;
%  end
%% Main Function:
[Lat, Lon] = CheckLatLon(LLA(1), LLA(2));

P_ned = zeros(1,3);
% P_ned(1) = sign(Lat) * vincenty(0, Lon, Lat, Lon, CB.a, CB.flatten);
% P_ned(2) = sign(Lon) * vincenty(Lat, 0, Lat, Lon, CB.a, CB.flatten);

[dist, az] = vincenty(0, 0, Lat, Lon, CB.a, CB.flatten);
P_ned(1) = dist * cosd(az);
P_ned(2) = dist * sind(az);
P_ned(3) = -LLA(3);

%% Compile Outputs:
%	P_ned= -1;

end % << End of function lla2ned >>

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
