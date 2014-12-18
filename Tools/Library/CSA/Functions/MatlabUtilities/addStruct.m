% ADDSTRUCT Adds One Structure to Another Structure
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% addStruct:
%     Adds One Structure to Another Structure
% 
% SYNTAX:
%	[combinedStruct] = addStruct(structA, structB)
%
% INPUTS: 
%	Name          	Size		Units		Description
%   structA         [structure]             Input Structure # 1
%   structB         [structure]             Input Structure # 2
%
% OUTPUTS: 
%	Name          	Size		Units		Description
%   combinedStruct  [structure]             Input Structure 1 + 2
%
% NOTES:
%   If structure A has the exact same field as structure B, structure B
%   will take precedence and overwrite structure A's value.
%
%   This function uses the listStruct function.
%
% EXAMPLES:
%
% A.a = 'Hi';
% A.b.line1 = 'line1';
% A.b.line2 = 'line2';
% A.c.ref.a = 'a';
% A.c.ref.b = 'b';
% 
% B.b.line3 = 'line3';
% B.b.line4 = 'line4';
% B.d = 'Bye';
%
% A = addStruct( A, B )
% listA = listStruct(A, 'A')     returns:
%
% listA = 
% 
%     'A.a'
%     'A.b.line1'
%     'A.b.line2'
%     'A.b.line3'
%     'A.b.line4'
%     'A.c.ref.a'
%     'A.c.ref.b'
%     'A.d'
%
%	% <Enter Description of Example #1>
%	[combinedStruct] = addStruct(structA, structB, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[combinedStruct] = addStruct(structA, structB)
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
%	Source function: <a href="matlab:edit addStruct.m">addStruct.m</a>
%	  Driver script: <a href="matlab:edit Driver_addStruct.m">Driver_addStruct.m</a>
%	  Documentation: <a href="matlab:pptOpen('addStruct_Function_Documentation.pptx');">addStruct_Function_Documentation.pptx</a>
%
% See also listStruct 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/434
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/addStruct.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [combinedStruct] = addStruct(structA, structB)

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
combinedStruct= structA;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        structB= ''; structA= ''; 
%       case 1
%        structB= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(structB))
%		structB = -1;
%  end
%% Main Function:
%% Generate A List of Structure B's Fields:
lstStruct = listStruct( structB );

%% Loop Through Each List Member:
for i = 1:size(lstStruct,1);
    %% Add Field Member to Combined Structure:
    ec = sprintf('combinedStruct.%s = structB.%s;', ...
        char(lstStruct(i,:)), char(lstStruct(i,:)) );
    eval(ec);
end

%% Compile Outputs:
%	combinedStruct= -1;

end % << End of function addStruct >>

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
