% ONPATH Determines if the given folder is on MATLAB's path
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% onpath:
%     Determines if the given folder is on MATLAB's path
% 
% SYNTAX:
%	[flgOnPath] = onpath(strFolder)
%
% INPUTS: 
%	Name     	Size		Units		Description
%	strFolder	'string'    [char]      Folder in Question
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	flgOnPath	[1]         [bool]      Is folder on MATLAB's path?
%
% NOTES:
%
% EXAMPLES:
%   % Example 1: Show that a folder is and then is not on the path
%   strFolder = 'TempDir';  % Name a folder
%   mkdir(strFolder);       % First Create the folder
%   addpath(strFolder);     % Add the Folder to the path
%   
%   % Show that the folder is on the path:
%   [flgOnPath] = onpath(strFolder)
%   % returns flgOnPath = 1
%
%   % Now remove the folder from the path and show 'onpath' working:
%   rmpath(strFolder);
%	[flgOnPath] = onpath(strFolder)
%   % returns flgOnPath = 0
%
%   % Remove the temporary folder (good housekeeping)
%   rmdir(strFolder);
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit onpath.m">onpath.m</a>
%	  Driver script: <a href="matlab:edit Driver_onpath.m">Driver_onpath.m</a>
%	  Documentation: <a href="matlab:pptOpen('onpath_Function_Documentation.pptx');">onpath_Function_Documentation.pptx</a>
%
% See also path
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/605
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [flgOnPath] = onpath(strFolder)

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

%% Main Function:
ptrLoc = strfind(path, strFolder);
flgOnPath = ~isempty(ptrLoc);

end % << End of function onpath >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110510 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         : Email                 : NGGN Username 
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi

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
