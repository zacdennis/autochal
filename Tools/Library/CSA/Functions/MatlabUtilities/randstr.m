% RANDSTR Random string generator
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% randstr:
%     Produces a string of random numbers and letters (upper and/or lower)
% 
% SYNTAX:
%	[str] = randstr(strFormat)
%	[str] = randstr()
%
% INPUTS: 
%	Name     	Size                Units		Description
%	strFormat	'string' or [int]   N/A         String format to randomly
%                                               produce (See Note 1)
%
% OUTPUTS: 
%	Name     	Size                Units		Description
%	str 	    'string'            [char]      Randomly created string
%
% NOTES:
%   Note 1: If 'strFormat' is passed in as a string, the function will
%   parse through the string to determine what type of character (number,
%   uppercase letter, or lowercase letter) is desired.  Numbers can be
%   specified using any number (0-9) or the '#' symbol.  Any uppercase
%   letter 'A-Z' will trigger a random uppercase letter.  Any lowercase
%   letter 'a-z' will trigger a random lowercase letter.  Any other
%   character (other than '#') will be passed through to the output,
%   meaning that you can pass through common symbols like dashes ('-') and
%   colons (:).  See below for examples.
%
% EXAMPLES:
%	% Example 1: Produce a string of random letters and numbers by
%	%            specifying the number of characters
%	[str] = randstr(10)
%
%   % Returns...
%   %   str = 0i5rky29A1
%
%	% Example 2: Produce a string specifying which character are to be
%   %            numbers and which are to be characters.  Note that you can
%   %            specify the character's case (upper or lower) in the
%   %            format string.  Note that none number or letter characters
%   %            are ignored.  
%	[str] = randstr('Aaa, Aaaaa-Aaa: $1111.##')
%
%   % Returns...
%   %   str = Grc, Qrsxz-Tpy: $5018.48
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit randstr.m">randstr.m</a>
%	  Driver script: <a href="matlab:edit Driver_randstr.m">Driver_randstr.m</a>
%	  Documentation: <a href="matlab:pptOpen('randstr_Function_Documentation.pptx');">randstr_Function_Documentation.pptx</a>
%
% See also randi, char, num2str, double
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/701
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/randstr.m $
% $Rev: 1740 $
% $Date: 2011-05-17 12:30:38 -0500 (Tue, 17 May 2011) $
% $Author: sufanmi $

function [str] = randstr(strFormat)

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
str= '';

%% Input Argument Conditioning:
if(nargin == 0)
    strFormat = 1;
end

%% Main Function:
if(isnumeric(strFormat))
    % 'strFormat' is numeric.  Randomly generated a string of length 
    % 'strFormat' consisting of A-Z (26), a-z (26), and 0-9 (10)
    numChar = 26 + 26 + 10;     % [int]
    arrRandom = randi(numChar, [1 strFormat]);
    
    for i = 1:strFormat
        curRand = arrRandom(i);

        if(curRand <= 26)
            % Map to A-Z
            str(i) = char(curRand + 64);
        elseif( (curRand > 26) && (curRand <= 52) )
            % Map to a-z
            str(i) = char((curRand-26) + 96);
        else
            % Map to 0-9
            str(i) = num2str(curRand-53);
        end
    end
    
else
    % 'strFormat' is a string    
    for i = 1:length(strFormat)
        curChar = strFormat(i);
        idxChar = double(curChar);
        
        if( (idxChar >= 65) && (idxChar <= 90) )
            % It's A-Z
            str(i) = upper(char(randi(26) + 64));
        elseif( (idxChar >= 97) && (idxChar <= 122) )
            % It's a-z
            str(i) = lower(char(randi(26) + 64));
        elseif( ((idxChar >= 48) && (idxChar <= 57)) || (idxChar == 35) )
            % It's 0-9, or #
            str(i) = num2str(randi(10)-1);
        else
            str(i) = curChar;
        end
    end
    
end

end % << End of function randstr >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110517 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username 
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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