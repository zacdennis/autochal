% LISTDIR lists the directory that contains a named file
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% listDir:
%     <Function Description> 
% 
% SYNTAX:
%	[lstDir] = listDir(lstMatch,fldrRoot,lstExclude)
%	[lstDir] = listDir(lstMatch,fldrRoot)
%
% INPUTS: 
%	Name		Size		Units		Description
%	lstMatch		<size>		<units>		<Description>
%	fldrRoot		<size>		<units>		<Description>
%	lstExclude		<size>		<units>		<Description>
%										 Default: <Enter Default Value>
%
% OUTPUTS: 
%	Name		Size		Units		Description
%	lstDir		<size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[lstDir] = listDir(lstMatch,fldrRoot,lstExclude)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[lstDir] = listDir(lstMatch,fldrRoot)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%	[1]    http://www...
%	[2]    Author. Book Title. Publisher, City, Copyright year
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit listDir.m">listDir.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_listDir.m">DRIVER_listDir.m</a>
%	  Documentation: <a href="matlab:pptOpen('listDir Documentation.pptx');">listDir Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/669
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/listDir.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [lstDir] = listDir(lstMatch,fldrRoot,lstExclude)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Initialize Outputs:
% lstDir= -1;

%% Input Argument Conditioning:
 switch(nargin)
      case 0
       lstExclude= {}; fldrRoot= pwd; lstMatch= {}; 
      case 1
       lstExclude= {}; fldrRoot= pwd; 
      case 2
       lstExclude= {}; 
      case 3
       
 end

 if(~iscell(lstExclude))
     lstExclude = { lstExclude };
 end
 
 if(~iscell(lstMatch))
     lstMatch = { lstMatch };
 end
 

%% Main Function:
lstPath = str2cell(path, ';');
lstPathLocal = str2cell(genpath(fldrRoot), ';');
lstFolders = intersect(lstPath, lstPathLocal);

%% Compile Outputs:
lstDir = {}; iCtr = 0;
numFolders = size(lstFolders, 1);
for iFolder = 1:numFolders
    curFolder = lstFolders{iFolder,:};
    
    flgAdd = 1;
    
    for iExclude = 1:size(lstExclude, 1)
        curExclude = lstExclude{iExclude, :};
        if(~isempty(strfind(curFolder, curExclude)))
            flgAdd = 0;
        end
    end
    
    if(~isempty(lstMatch))
        flgAdd = 0;
        
        for iMatch = 1:size(lstMatch, 1)
            curMatch = lstMatch{iMatch, :};
            if(~isempty(strfind(curFolder, curMatch)))
                flgAdd = 1;
            end
        end
    end
    
    if(flgAdd)
        iCtr = iCtr + 1;
        lstDir(iCtr,:) = { curFolder };
    end
    
    
    
end

end % << End of function listDir >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 100908 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName  :  Email  :  NGGN Username 
% <initials>: <Fullname> : <email> : <NGGN username> 

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
