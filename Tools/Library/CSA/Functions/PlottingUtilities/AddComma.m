% ADDCOMMA Adds a comma, ‘,’, to the end of a string
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% AddComma:
%     Adds a comma, ‘,’, to the end of a string
% 
% SYNTAX:
%	[str] = AddComma(strIn, flgAddComma)
%
% INPUTS: 
%	Name        Size    Units		Description
%   srtIn       [1xN]   [ND]        Input string
%   flgAddComma [1x1]   [ND]        Flag (1) to add comma  
%
% OUTPUTS: 
%	Name       	Size	Units		Description
%   str         [1xN]   [ND]        String with added comma
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
%	[str] = AddComma(strIn, flgAddComma, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[str] = AddComma(strIn, flgAddComma)
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
%	Source function: <a href="matlab:edit AddComma.m">AddComma.m</a>
%	  Driver script: <a href="matlab:edit Driver_AddComma.m">Driver_AddComma.m</a>
%	  Documentation: <a href="matlab:pptOpen('AddComma_Function_Documentation.pptx');">AddComma_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/474
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/AddComma.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [str] = AddComma(strIn, flgAddComma, varargin)

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
% str= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        flgAddComma= ''; strIn= ''; 
%       case 1
%        flgAddComma= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(flgAddComma))
%		flgAddComma = -1;
%  end
%% Main Function:
if(nargin < 2)
    flgAddComma = 1;
end

if(isnumeric(strIn))
    strIn = num2str(strIn);
end

if(~flgAddComma)
    str = strIn;
else

    ptr = findstr(strIn, '.');

    if(isempty(ptr))
        ptr = length(strIn);
    end

    strLeft = strIn(1:(ptr-1));
    strRight = strIn(ptr:end);

    if(strcmp(strLeft(1), '-'))
        strPrefix = '-';
        strLeft = strLeft(2:end);
    else
        strPrefix = '';
    end
    
    lengthStrLeft = length(strLeft);
    if(lengthStrLeft > 3)
        numIts = ceil(lengthStrLeft/3);  %-1;

        str = strRight;

        for iIt = 1:numIts
            p2 = lengthStrLeft - (iIt-1)*3;
            p1 = lengthStrLeft - (iIt)*3+1;

            if(p1 <= 1)
                p1 = 1;
                str = sprintf('%s%s', strLeft(p1:p2), str);
            else
                str = sprintf(',%s%s', strLeft(p1:p2), str);
            end
        end
        str = [strPrefix str];
    else
        str = strIn;
    end
end

%% Compile Outputs:
%	str= -1;

end % << End of function AddComma >>

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
