% STR2PARAGRAPH Inserts line returns in a str so it displays as paragraph
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% str2paragraph:
%   Inserts line returns in a string so that it can be displayed as a 
%   paragraph.
% 
% SYNTAX:
%	[strPar] = str2paragraph(str, varargin, 'PropertyName', PropertyValue)
%	[strPar] = str2paragraph(str, varargin)
%	[strPar] = str2paragraph(str)
%
% INPUTS: 
%	Name        Size        Units       Description
%   str         'string'    [char]      String to format into a paragraph
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
% OUTPUTS: 
%	Name        Size        Units       Description
%	strPar      'string'    [char]      String formatted into a paragraph
%
% NOTES:
%   If the words are longer than 10 characters, so it will wrap at 
%   the first available of opportunity.  In addition, the prefix and suffix
%   options will contribute to the total character count.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'MaxLength'         [int]           75          Maximum number of 
%                                                    characters per row
%   'Prefix'            'string'        ''          String to be placed at
%                                                    beginning of each
%                                                    paragraph row
%   'Suffix'            'string'        ''          String to be placed at
%                                                    end of each paragraph
%                                                    row
%
% EXAMPLES:
%	Example 1: Narrow Paragraph
%   Convert a long string to a narrow paragraph (width of 22 characters)
%   str = 'Here is a big long string that has a bunch of spaces in it'
%	[strPar] = str2paragraph(str, 'MaxLength', 22)
%   Returns strPar = 'Here is a big long
%                     string that has a
%                     bunch of spaces in it'
%
%   Example 2: Long Words to a Paragraph
%   Convert a string with long words to a paragraph (width of 10 
%   characters)
%              
%   str = 'This-big-long-string-only-has one-space-in-it'
%	[strPar] = str2paragraph(str, 'MaxLength', 10)
%   Returns strPar = 'This-big-long-string-only-has
%                    one-space-in-it'
%
%   Example 3: Adding a Prefix and Suffix
%   Convert a string to a paragraph with both a prefix and suffix.
%
%   str = ['A few asterisks will proceed each line and some' ...
%   ' exclamations will end each one.'];
%   [strPar] = str2paragraph(str, 'MaxLength', 50, 'Prefix', '***', ...
%   'Suffix', '!!!')
%   Returns strPar = ***A few asterisks will proceed each line!!!
%                    ***and someexclamations will end each one.!!!
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit str2paragraph.m">str2paragraph.m</a>
%	  Driver script: <a href="matlab:edit Driver_str2paragraph.m">Driver_str2paragraph.m</a>
%	  Documentation: <a href="matlab:pptOpen('str2paragraph_Function_Documentation.pptx');">str2paragraph_Function_Documentation.pptx</a>
%
% See also str2cell, cell2str, char
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/569
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21)
%                Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/str2paragraph.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [strPar] = str2paragraph(str, varargin)

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

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[maxLength, varargin]  = format_varargin('MaxLength', 75, 2, varargin);
[strPrefix, varargin]  = format_varargin('Prefix', '', 2, varargin);
[strSuffix, varargin]  = format_varargin('Suffix', '', 2, varargin);


 switch(nargin)
      case 0
       error([mfnam ':InputArgCheck'], ['Need at least 1 input.  See ' ...
         mlink ' documentation for help.']);
      case 1
       maxLength= ''; 
      case 2
       % Nominal Case
 end

 if(isempty(maxLength))
     maxLength = 75;
 end
 maxLength = maxLength - length(strSuffix) - length(strPrefix);

%% Main Function:
strPar = '';
strLeft = [strPrefix str];

while(~isempty(strLeft))
    % Find all spaces
    ptrSpaces = findstr(strLeft, ' ');
    if(isempty(ptrSpaces))
        % No spaces left, grab last point
        ptrLastSpace = length(strLeft)+1;
    else
        % Spaces exist, find the one closest to the max length
        if(length(strLeft) <= maxLength)
            ptrLastSpace = length(strLeft)+1;
        else          
            idxLastSpace = max((ptrSpaces <= maxLength).*[1:length(ptrSpaces)]);
            if(idxLastSpace > 0)
                ptrLastSpace = ptrSpaces(idxLastSpace);
            else
                ptrLastSpace = ptrSpaces(1);
            end
        end
    end
    % Slice off the string piece and add it to the paragram, adding a line
    % return after each line (char(10))
    strLine = [strLeft(1:ptrLastSpace-1) strSuffix];
    strLeft = strLeft(ptrLastSpace+1:end);
    
    strPar = [strPar strLine char(10)];
    
    if(~isempty(strLeft))
        strLeft = [strPrefix strLeft];
    end
    
end

end % << End of function str2paragraph >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101119 JPG: Minor edits for the COSMO process. 
% 100805 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     :  Email                :  NGGN Username
% MWS: Mike Sufana  :  mike.sufana@ngc.com  :  sufanmi
% JPG: James Gray   :  james.gray2@ngc.com  :  g61720  

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
