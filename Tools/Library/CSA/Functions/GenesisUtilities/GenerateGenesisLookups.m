% GENERATEGENESISLOOKUPS Computes list of InterpND calls for tables built using ReadGenesisDatabase 
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GenerateGenesisLookups:
%     Computes a list (in .m file format) of necessary InterpND (1-4
%     dimensional) calls for tables created using 'ReadGenesisDatabase.m'.
% 
% SYNTAX:
%	GenerateGenesisLookups(tblData, strFilename)
%
% INPUTS: 
%	Name       	Size		Units		Description
%	tblData     {struct}    [N/A]       Genesis table data
%	strFilename	'string'    [char]      Desired name of output file
%
% OUTPUTS: 
%	Name       	Size		Units		Description
%   No workspace variable outputs
%
% NOTES:
%
% EXAMPLES:
% % Example 1: Build the lookup calls for the Genesis F18 model:
% filename = [fileparts(which('Driver_ReadGenesisDatabase.m')) filesep 'f18_db_aero.dat'];
% [tblData] = ReadGenesisDatabase(filename);
% GenerateGenesisLookups(tblData, 'F18_Genesis_Cmds.m')
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit GenerateGenesisLookups.m">GenerateGenesisLookups.m</a>
%	  Driver script: <a href="matlab:edit Driver_GenerateGenesisLookups.m">Driver_GenerateGenesisLookups.m</a>
%	  Documentation: <a href="matlab:winopen(which('GenerateGenesisLookups_Function_Documentation.pptx'));">GenerateGenesisLookups_Function_Documentation.pptx</a>
%
% See also ReadGenesisDatabase, Cell2PaddedStr 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/771
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/GenesisUtilities/GenerateGenesisLookups.m $
% $Rev: 2566 $
% $Date: 2012-10-22 18:50:33 -0500 (Mon, 22 Oct 2012) $
% $Author: sufanmi $

function [] = GenerateGenesisLookups(tblData, strFilename)

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

%% Main Code:

% Generate Genesis Lookups
lstFields = fieldnames(tblData);
strTbl = 'tblData';
numFields = size(lstFields, 1);

lstCmds = {};
lstIDVs = {};

for iField = 1:numFields
    curField = lstFields{iField, :};
    strLookup = tblData.(curField).InterpCall;
    curIDVs   = tblData.(curField).lstIDVs;
    
    strLookup = strrep(strLookup, 'tbl', strTbl);
    lstCmds = [lstCmds; strLookup];
    lstIDVs = [lstIDVs; curIDVs];
end

lstIDVs = unique(lstIDVs);

numIDVs = size(lstIDVs, 1);
lstInitIDVs = cell(numIDVs, 2);
for iIDV = 1:numIDVs
    curIDV = lstIDVs{iIDV, 1};
    lstInitIDVs(iIDV,1) = {['cur_' curIDV]};
    lstInitIDVs(iIDV,2) = {' = 0; % [TBD]'};
end

str_initIDVs = Cell2PaddedStr(lstInitIDVs);
str_lstCmds = Cell2PaddedStr(lstCmds);

str2write = ['% Define Values for Independent Variables:' endl];
str2write = [str2write str_initIDVs];
str2write = [str2write endl];
str2write = [str2write str_lstCmds];

% Write to file
strFolder = fileparts(strFilename);
if(~isempty(strFolder))
    if(~isdir(strFolder))
        mkdir(strFolder);
    end
end

[fid, message ] = fopen(strFilename,'wt','native');
fprintf(fid, '%s', str2write);
fclose(fid);
edit(strFilename);

end % << End of function GenerateGenesisLookups >>

%% REVISION HISTORY
% YYMMDD INI: note
% 121022 MWS: Created function using CreateNewFunc
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
