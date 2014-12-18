% PPTOPEN Opens a PowerPoint file
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% pptOpen:
%     This function opens up a PowerPoint file.
% 
% SYNTAX:
%	pptOpen(pptFilename)
%
% INPUTS: 
%	Name            Size        Units       Description
%	 pptFilename	'string'    [char]      Name of PPT file to open
%
% OUTPUTS: 
%	Name            Size        Units       Description
%	 None
%
% NOTES:
%	This function is incredibly simple and should be avoided if possible.
%	Entire function is: winopen(which(pptFilename))
%
% EXAMPLE:
%   % Open the latest NGC PowerPoint template: 'NGCTemplate.pptx' 
%	pptOpen('NGCTemplate.pptx')
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit pptOpen.m">pptOpen.m</a>
%	  Driver script: <a href="matlab:edit Driver_pptOpen.m">Driver_pptOpen.m</a>
%	  Documentation: <a href="matlab:winopen(which('pptOpen_Function_Documentation.pptx'));">pptOpen_Function_Documentation.pptx</a>
%
% See also winopen 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/557
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PowerPointUtilities/pptOpen.m $
% $Rev: 2230 $
% $Date: 2011-10-24 17:55:47 -0500 (Mon, 24 Oct 2011) $
% $Author: sufanmi $

function pptOpen(pptFilename)

%% Debugging & Display Utilities 
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats ...
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Input Argument Conditioning

%% Main Function
filenamefull = which(pptFilename);
if(exist(filenamefull))
    winopen(filenamefull);
end

%% Compile Outputs
%	No Outputs Specified

end % << End of function pptOpen >>

%% REVISION HISTORY
% YYMMDD INI: note
% 100812 MWS: File Created
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
