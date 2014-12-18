% COMPUTEDERIVATIVES2 Find a linear derivative using tangent line approximation, best on non-uniform distribution in x.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ComputeDerivatives2:
%   Computes the linear derivative of some function y = f(x) using a tangent
%   line approximation. Unlike ComputeDerivatives, this function does NOT do
%   any curve fitting of the data. It merely does a forward difference on the
%   first point, central differences on the midpoints, and backward
%   difference on the end point. This is better suited for use on data which
%   is not uniform distributed in x.
% 
% SYNTAX:
%	[dydx] = ComputeDerivatives2(x, y)
%
% INPUTS: 
%	Name    Size	Units	Description
%   x       [1xn]   [ND]    Array of x-points
%   y       [1xn]   [ND]    Array of y-points
%
% OUTPUTS: 
%	Name    Size	Units	Description
%   dydx    [1xn]   [ND]    Array of dy/dx for each x
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[dydx] = ComputeDerivatives2(x, y, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[dydx] = ComputeDerivatives2(x, y)
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
%	Source function: <a href="matlab:edit ComputeDerivatives2.m">ComputeDerivatives2.m</a>
%	  Driver script: <a href="matlab:edit Driver_ComputeDerivatives2.m">Driver_ComputeDerivatives2.m</a>
%	  Documentation: <a href="matlab:pptOpen('ComputeDerivatives2_Function_Documentation.pptx');">ComputeDerivatives2_Function_Documentation.pptx</a>
%
% See also ComputeDerivatives
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/304
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AerodynamicFunctions/ComputeDerivatives2.m $
% $Rev: 1714 $
% $Date: 2011-05-11 15:23:59 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [dydx] = ComputeDerivatives2(x, y)

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
dydx= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        y= ''; x= ''; 
%       case 1
%        y= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(y))
%		y = -1;
%  end

ii=find(isnan(y)~=1);
nn=max(size(ii));

%% Main Function:
xx = x;
yy = y;

% for jj=[2:nn*20-1]
for jj=[2:nn-1]
    dyydxx(jj) = (yy(jj+1)-yy(jj-1))/(xx(jj+1)-xx(jj-1));
end;

dyydxx(1) = (yy(2)-yy(1))/(xx(2)-xx(1));
% dyydxx(nn*20) = (yy(nn*20)-yy(nn*20-1))/(xx(nn*20)-xx(nn*20-1));
dyydxx(nn) = (yy(nn)-yy(nn-1))/(xx(nn)-xx(nn-1));

dydx = ones(size(y))*nan;
dydx(ii) = interp1(xx,dyydxx,x(ii));

return;

%% Compile Outputs:
%	dydx= -1;

end % << End of function ComputeDerivatives2 >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101021 JPG: Copied over information from the old function.
% 101021 CNF: Function template created using CreateNewFunc
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
