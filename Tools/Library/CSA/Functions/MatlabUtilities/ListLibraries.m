% LISTLIBRARIES Finds all Simulink Libraries within a Folder
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ListLibraries:
%     Finds all Simulink model libaries within a user-provided folder 
% 
% SYNTAX:
%	[lstLibs] = ListLibraries(TopLevelFolder)
%	[lstLibs] = ListLibraries()
%
% INPUTS: 
%	Name            Size		Units		Description
%	TopLevelFolder	'string'    N/A         Top Level Folder in which to
%                                            begin search
%                                            Default: Current folder (pwd)
% OUTPUTS: 
%	Name		Size            Units		Description
%	lstLibs		{'string'}      N/A         Cell array of strings with full
%                                            paths to all the libarires
%
% NOTES:
%	This function utilizes the 'dir_list' function to find all the '.mdl'
%	files.  It then loops through each file and determines which has its
%	'BlockDiagramType' set to 'library'.
%
% EXAMPLES:
%	% Finds all Simulink libraries in the current directory
%	lstLibs = ListLibraries()
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ListLibraries.m">ListLibraries.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_ListLibraries.m">DRIVER_ListLibraries.m</a>
%	  Documentation: <a href="matlab:pptOpen('ListLibraries_Function_Documentation.pptx');">ListLibraries_Function_Documentation.pptx</a>
%
% See also dir_list
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/670
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/ListLibraries.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [lstLibs] = ListLibraries(TopLevelFolder)

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
lstLibs= {};

%% Input Argument Conditioning:
 switch(nargin)
      case 0
       TopLevelFolder= ''; 
      case 1
       
 end

 if(isempty(TopLevelFolder))
		TopLevelFolder = pwd;
 end

%% Main Function:
lstModels = dir_list('*.mdl', 1, TopLevelFolder);

warnstr = 'Simulink:SL_MdlFileShadowedByFile';
warning('off', warnstr);

numModels = size(lstModels, 1);
iLib = 0;
hd = pwd;

for iModel = 1:numModels
    curModel = lstModels{iModel, :};
    [pathModel, nameModel] = fileparts(curModel);
    
    cd(pathModel);
    load_system(nameModel);
    
    typeModel = get_param(nameModel, 'BlockDiagramType');
    
    if(strcmp(typeModel, 'library'))
        iLib = iLib + 1;
        lstLibs(iLib, :) = { curModel };
    end
end

cd(hd);
warning('on', warnstr);

end % << End of function ListLibraries >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 100902 CNF: Function template created using CreateNewFunc
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
