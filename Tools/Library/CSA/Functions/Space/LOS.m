% LOS Determines if two vehicles can "see" each other via line of sight
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% LOS:
%     Determines if two vehicles can "see" each other via line of sight
% 
% SYNTAX:
%	[flgLOS] = LOS(r1, r2, varargin, 'PropertyName', PropertyValue)
%	[flgLOS] = LOS(r1, r2, varargin)
%	[flgLOS] = LOS(r1, r2)
%
% INPUTS:
%	Name    Size	Units		Description
%   r1      [3]     [length]    Inertial Position Vector to Vehicle 1
%   r2      [3]     [length]    Inertial Position Vector to Vehicle 2
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    Size	Units		Description
%  flgLOS   [1]     [bool]      Can Vehicle 1 see Vehicle 2?
%
% NOTES:
%  Function is NOT unit specific.  However, input positions MUST have
%  matching units.
%  LOS function only intended to be used with spherical (or round) Central
%  Bodies.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[flgLOS] = LOS(r1, r2, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[flgLOS] = LOS(r1, r2)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
%   Vallado, David A.  Fundamentals of Astrodynamics and Applications.  New
%   York.  McGraw-Hill, 1997.  Algorithm 22: Sight. Section 3.9, pg. 201.
%
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
%	Source function: <a href="matlab:edit LOS.m">LOS.m</a>
%	  Driver script: <a href="matlab:edit Driver_LOS.m">Driver_LOS.m</a>
%	  Documentation: <a href="matlab:pptOpen('LOS_Function_Documentation.pptx');">LOS_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/547
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Space/LOS.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [flgLOS] = LOS(r1, r2, varargin)

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
% flgLOS= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        r2= ''; r1= ''; 
%       case 1
%        r2= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(r2))
%		r2 = -1;
%  end
%% Main Function:
tau_min_num = normv(r1)^2 - dot(r1, r2);
 tau_min_den = normv(r1)^2 + normv(r2)^2 - 2*dot(r1,r2);
 
 tau_min = tau_min_num / tau_min_den;
 
  flg = (1-tau_min)*normv(r1)^2 + dot(r1,r2)*tau_min;
 
 flgLOS = false;
 
 if( (tau_min < 0) || (tau_min > 1) || (flg >= 1.0) )
     flgLOS = true;
 end

%% Compile Outputs:
%	flgLOS= -1;

end % << End of function LOS >>

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
