% QUATROTATE creates a quaternion rotation matrix.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% quatRotate:
%    Create Quaternion Rotation matrix. Uses the 4-element rotation defined 
%    by quaternions with elements Q0r, Q1r, Q2r, and Q3r to build a 4x4 
%    rotation matrix
% 
% SYNTAX:
%	[qr44] = quatRotate(q0r, q1r, q2r, q3r)
%
% INPUTS: 
%	Name        Size		Units		Description
%   q0r         [1x1]       [ND]        Element 0 of quaternion
%   q1r         [1x1]       [ND]        Element 1 of quaternion
%   q2r         [1x1]       [ND]        Element 2 of quaternion
%   q3r         [1x1]       [ND]        Element 3 of quaternion
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%   qr44       [4x4]        [ND]        Quaternion rotation matrix
%
% NOTES:
%   Ref. Sidi, Spacecraft Dynamics and Control.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[qr44] = quatRotate(q0r, q1r, q2r, q3r, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[qr44] = quatRotate(q0r, q1r, q2r, q3r)
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
%	Source function: <a href="matlab:edit quatRotate.m">quatRotate.m</a>
%	  Driver script: <a href="matlab:edit Driver_quatRotate.m">Driver_quatRotate.m</a>
%	  Documentation: <a href="matlab:pptOpen('quatRotate_Function_Documentation.pptx');">quatRotate_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/360
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/quatRotate.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [qr44] = quatRotate(q0r, q1r, q2r, q3r)

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
qr44= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        q3r= ''; q2r= ''; q1r= ''; q0r= ''; 
%       case 1
%        q3r= ''; q2r= ''; q1r= ''; 
%       case 2
%        q3r= ''; q2r= ''; 
%       case 3
%        q3r= ''; 
%       case 4
%        
%       case 5
%        
%  end
%
%  if(isempty(q3r))
%		q3r = -1;
%  end
%% Main Function:
qr44  = [ q0r  q3r -q2r q1r;
         -q3r  q0r  q1r q2r;
          q2r -q1r  q0r q3r;
         -q1r -q2r -q3r q0r];

%% Compile Outputs:
%	qr44= -1;

end % << End of function quatRotate >>

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
