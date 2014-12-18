% ADJ Matrix adjoint.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% adj:
%   Calculates the adjoint matrix of square matrix A.  It is computed using
%   the Cayley-Hamilton Theorem. The inverse of A is: 
%   INV(A) = ADJ(A)/det(A).  
% 
% SYNTAX:
%	[B] = adj(A)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	A   	    [MxM]		[ND]		Original Square Matrix
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	B   	    [MxM]		[ND]   		Inverted Matrix via Cayley-Hamilton
%
% NOTES:
%	Matrices that are not invertable still have an adjoint.
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[B] = adj(A, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[B] = adj(A)
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
%	Source function: <a href="matlab:edit adj.m">adj.m</a>
%	  Driver script: <a href="matlab:edit Driver_adj.m">Driver_adj.m</a>
%	  Documentation: <a href="matlab:pptOpen('adj_Function_Documentation.pptx');">adj_Function_Documentation.pptx</a>
%
% See also INV, PINV, RANK, SLASH
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/44
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/LinearModel/adj.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [B] = adj(A)

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
B= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        A= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:
ce = poly(eig(A));
cesize = max(size(ce));
p = [0 ce(1:(cesize-1))];
s = (-1)^(max(size(A))+1);
B = s*polyvalm(p,A);

%% Compile Outputs:
%	B= -1;

end % << End of function adj >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101022 JPG: Copied over information from the old function.
% 101021 CNF: Function template created using CreateNewFunc
% 980401 PG : Original code author.
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                    :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com      :  g61720 
% PG : Paul Godfrey         :  pjg@mlb.semi.harris.com  :

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
