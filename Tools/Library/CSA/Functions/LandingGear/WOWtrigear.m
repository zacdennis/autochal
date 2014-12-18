% WOWTRIGEAR computes the expected weight on wheels for a plane with tricycle landing gear
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% WOWtrigear:
%   Computes the expected weight on wheels for an aircraft with a typical
%   tricycle landing gear configuration:
%   1 Nose Wheel located on centerline of vehicle (ygear = 0)
%   2 Main Wheels located equal distance from vehicle centerline such that
%   (ygear2 = -ygear3) 
% 
% SYNTAX:
%	[WOW] = WOWtrigear(mass, CG, AttachPts, CentralBody)
%
% INPUTS: 
%	Name       	Size	Units               Description
%   mass        [1]     [slugs] -or- [kg]   Vehicle Takeoff Mass
%   CG          [3]     [ft] -or- [m]       Vehicle Takeoff Center of Gravity
%   AttachPts   [3x3]   [ft] -or- [m]       Attachment Points for each gear on
%                                           vehicle body such that
%                                           AttachPts(1,:) = Gear 1's [x y z]
%                                           Distance is w.r.t. vehicle origin
%   CentralBody         {structure}         Central Body Structure
%    .g                 [ft/s^2] -or- [m/s^2] Sea-level gravity
%
% OUTPUTS: 
%	Name       	Size		Units		Description
%	WOW 	    <size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[WOW] = WOWtrigear(mass, CG, AttachPts, CentralBody, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[WOW] = WOWtrigear(mass, CG, AttachPts, CentralBody)
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
%	Source function: <a href="matlab:edit WOWtrigear.m">WOWtrigear.m</a>
%	  Driver script: <a href="matlab:edit Driver_WOWtrigear.m">Driver_WOWtrigear.m</a>
%	  Documentation: <a href="matlab:pptOpen('WOWtrigear_Function_Documentation.pptx');">WOWtrigear_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/51
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/LandingGear/WOWtrigear.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [WOW] = WOWtrigear(mass, CG, AttachPts, CentralBody)

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
WOW= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        CentralBody= ''; AttachPts= ''; CG= ''; mass= ''; 
%       case 1
%        CentralBody= ''; AttachPts= ''; CG= ''; 
%       case 2
%        CentralBody= ''; AttachPts= ''; 
%       case 3
%        CentralBody= ''; 
%       case 4
%        
%       case 5
%        
%  end
%
%  if(isempty(CentralBody))
%		CentralBody = -1;
%  end
%% Main Function:
%% Compute Sea-level weight:
W = mass * CentralBody.g;       % [lbf] -or- [N]

%% Attachment Arms:
R1x = AttachPts(1,1) - CG(1);   % [ft] -or- [m]
R2x = AttachPts(2,1) - CG(1);   % [ft] -or- [m]

WOW(1) = -W - (W*R1x/(R2x - R1x));  % [lbf] -or- [N]
WOW(2) = .5*(W*R1x/(R2x - R1x));    % [lbf] -or- [N]
WOW(3) = WOW(2);                    % [lbf] -or- [N]
WOW = abs(WOW);                     % [lbf] -or- [N]

%% Compile Outputs:
%	WOW= -1;

end % << End of function WOWtrigear >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
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
