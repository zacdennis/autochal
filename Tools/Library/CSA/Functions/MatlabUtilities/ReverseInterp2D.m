% REVERSEINTERP2D takes 2D table, U=f(X,Y), and inverts it to find Y=f(X,U)
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ReverseInterp2D:
%   Takes a 2-D Table where U = fcn(X, Y) and inverts it to find a table
%   where  Y = fcn(X, U)
% 
% SYNTAX:
%	[tbl_U_vs_X] = ReverseInterp2D(arrX, arrY, tbl_Y_vs_X, arrU, flgCheck)
%	[tbl_U_vs_X] = ReverseInterp2D(arrX, arrY, tbl_Y_vs_X, arrU)
%
% INPUTS: 
%	Name      	Size    Units           Description
%   arrX        [lx1]   [user defined]  Array of X datapoints
%   arrY        [Mx1]   [user defined]  Array of Y datapoints
%   tbl_Y_vs_X  [1xN]   [user defined]  Input Table where U = fcn(X,Y)
%   arrU        [1xN]   [user defined]  Array of U datapoints
%   flgCheck    [1x1]   [user defined]  Hold Endpoints when
%                                        interpolating data 
%                                        1/0: yes/no  [default is 0]%
% OUTPUTS: 
%	Name      	Size    Units           Description
%   tbl_U_vs_X  [1xN]   [user defined]  Output Table where Y = fcn(X,U)
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
%	[tbl_U_vs_X] = ReverseInterp2D(arrX, arrY, tbl_Y_vs_X, arrU, flgCheck, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[tbl_U_vs_X] = ReverseInterp2D(arrX, arrY, tbl_Y_vs_X, arrU, flgCheck)
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
%	Source function: <a href="matlab:edit ReverseInterp2D.m">ReverseInterp2D.m</a>
%	  Driver script: <a href="matlab:edit Driver_ReverseInterp2D.m">Driver_ReverseInterp2D.m</a>
%	  Documentation: <a href="matlab:pptOpen('ReverseInterp2D_Function_Documentation.pptx');">ReverseInterp2D_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/464
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/ReverseInterp2D.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [tbl_U_vs_X] = ReverseInterp2D(arrX, arrY, tbl_Y_vs_X, arrU, flgCheck, varargin)

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
% tbl_U_vs_X= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        flgCheck= ''; arrU= ''; tbl_Y_vs_X= ''; arrY= ''; arrX= ''; 
%       case 1
%        flgCheck= ''; arrU= ''; tbl_Y_vs_X= ''; arrY= ''; 
%       case 2
%        flgCheck= ''; arrU= ''; tbl_Y_vs_X= ''; 
%       case 3
%        flgCheck= ''; arrU= ''; 
%       case 4
%        flgCheck= ''; 
%       case 5
%        
%       case 6
%        
%  end
%
%  if(isempty(flgCheck))
%		flgCheck = -1;
%  end
%% Main Function:
if nargin < 5
    flgCheck = 0;
end

%% Loop Through Each X breakpoint
for iX = 1:length(arrX)
    % Grab 1-D table at X breakpoint
    arrXY = tbl_Y_vs_X(iX,:);
    
    % Check to ensure that there are no duplicates:
    [lookup_arrXY, ptr_arrXY] = unique(arrXY);
    lookup_arrY = arrY(ptr_arrXY);
    
    % Lookup Y as a fcn of U
    tbl_U_vs_X(iX,:) = Interp1D(lookup_arrXY, lookup_arrY, arrU, flgCheck);
    
end

%% Compile Outputs:
%	tbl_U_vs_X= -1;

end % << End of function ReverseInterp2D >>

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
