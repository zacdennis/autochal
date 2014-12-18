% REMOVEVALS Removes Desired Values from a Vector
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% RemoveVals:
%     Removes Desired Values from a Vector
% 
% SYNTAX:
%	[vecNew] = RemoveVals(vecOrig, vecRemove)
%
% INPUTS: 
%	Name     	Size	Units	Description
%   vecOrig     [1xN]   [N/A]   Original Input Vector
%   vecRemove   [1xM]   [N/A]   List of Values to Remove
%
% OUTPUTS: 
%	Name     	Size	Units	Description
%   vecNew      [1xN]   [N/A]   Original Input Vector with Desired Values
%                               Removed
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%
%   vecOrig   = [1 2 3 4 5]
%
%   vecRemove = [2 4]
%
%   vecNew    = RemoveVals(vecOrig, vecRemove)
%
%   vecNew    = [1 3 5]
%
%	% <Enter Description of Example #1>
%	[vecNew] = RemoveVals(vecOrig, vecRemove, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[vecNew] = RemoveVals(vecOrig, vecRemove)
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
%	Source function: <a href="matlab:edit RemoveVals.m">RemoveVals.m</a>
%	  Driver script: <a href="matlab:edit Driver_RemoveVals.m">Driver_RemoveVals.m</a>
%	  Documentation: <a href="matlab:pptOpen('RemoveVals_Function_Documentation.pptx');">RemoveVals_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/425
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/RemoveVals.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [vecNew] = RemoveVals(vecOrig, vecRemove, varargin)

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
vecNew = [];
iNew = 0;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        vecRemove= ''; vecOrig= ''; 
%       case 1
%        vecRemove= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(vecRemove))
%		vecRemove = -1;
%  end
%% Main Function:
for iOrig = 1:length(vecOrig)
    curOrig = vecOrig(iOrig);

    flgMatch = 0;

    for iRemove = 1:length(vecRemove)
        curRemove = vecRemove(iRemove);

        if(curOrig == curRemove)
            flgMatch = 1;
            break;
        end
    end

    if(flgMatch == 0)
        iNew = iNew + 1;
        vecNew(iNew) = curOrig;
    end
end

%% Compile Outputs:
%	vecNew= -1;

end % << End of function RemoveVals >>

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
