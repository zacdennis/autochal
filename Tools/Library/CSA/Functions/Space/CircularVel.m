% CIRCULARVEL Computes the velocity for a circular orbit
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CircularVel:
%     Computes the velocity for a circular orbit
%
% *************************************************************************
% * #NOTE: To future COSMO'er, the following warning occured when running
% * CreateNewFunc.
% * CreateNewFunc>>WARNING: Selected Input argument name: "mu" is a
% * function name!
% * -JPG
% *************************************************************************
% SYNTAX:
%	[vel] = CircularVel(r, mu, varargin, 'PropertyName', PropertyValue)
%	[vel] = CircularVel(r, mu, varargin)
%	[vel] = CircularVel(r, mu)
%
% INPUTS: 
%	Name    Size	Units               Description
%   r       [1]     [length]            Radius
%   mu      [1]     [length^3/sec^2]    Central Body Gravitational Constant
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    Size	Units               Description
%   vel     [1]     [length/sec]        Circular Velocity
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
%	[vel] = CircularVel(r, mu, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[vel] = CircularVel(r, mu)
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
%	Source function: <a href="matlab:edit CircularVel.m">CircularVel.m</a>
%	  Driver script: <a href="matlab:edit Driver_CircularVel.m">Driver_CircularVel.m</a>
%	  Documentation: <a href="matlab:pptOpen('CircularVel_Function_Documentation.pptx');">CircularVel_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/543
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Space/CircularVel.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [vel] = CircularVel(r, mu, varargin)

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
% vel= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        mu= ''; r= ''; 
%       case 1
%        mu= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(mu))
%		mu = -1;
%  end
%% Main Function:
vel = sqrt( mu/r );

%% Compile Outputs:
%	vel= -1;

end % << End of function CircularVel >>

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
