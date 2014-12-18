% COFACTOR Cofactors and the cofactor matrix.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% cofactor:
%     generates the cofactors of a matrix.
% 
% SYNTAX:
%	[C] = cofactor(A, i, j)
%	[C] = cofactor(A)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	A   	    [NxN]		[ND]   		Matrix of interest
%	i   	    [1]   		[ND]   		Row to remove to produce minor.
%	j   	    [1]   		[ND]   		Column to remove to produce minor.
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	C   	    [Varies]	[ND]    	If i,j are defined, C is the
%                                       cofactor of i and j.  If not, C is
%                                       a matrix of cofactors
%
% NOTES:
%	If i and j are defined C will be a scalar.  Otherwise C will be [NxN].
%
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[C] = cofactor(A, i, j, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[C] = cofactor(A, i, j)
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
%	Source function: <a href="matlab:edit cofactor.m">cofactor.m</a>
%	  Driver script: <a href="matlab:edit Driver_cofactor.m">Driver_cofactor.m</a>
%	  Documentation: <a href="matlab:pptOpen('cofactor_Function_Documentation.pptx');">cofactor_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/42
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/LinearModel/cofactor.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [C] = cofactor(A, i, j)

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
C= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        j= ''; i= ''; A= ''; 
%       case 1
%        j= ''; i= ''; 
%       case 2
%        j= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(j))
%		j = -1;
%  end
%% Main Function:
if nargin == 3
    % Remove row i and column j to produce the minor.
    M = A;
    M(i,:) = [];
    M(:,j) = [];
    C = (-1)^(i+j)*det(M);
else
    [n,n] = size(A);
    for i = 1:n
        for j = 1:n
            C(i,j) = cofactor(A,i,j);
        end
    end
end


%% Compile Outputs:
%	C= -1;

end % << End of function cofactor >>

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
