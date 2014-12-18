% EXPORTLIBRARY Copies a Simulink library and removes all unused blocks
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ExportLibrary:
%   When delivering a Simulation library to a customer or partner, it may
%   desired to remove all unused library blocks.  This may be to make the
%   deliverable as clean as possible or may be remove proprietary blocks.
%   This function will determine what library blocks are used in the
%   inputted list of reference models.  It will then copy over the library
%   and strip out all the unused blocks, leaving just the required ones.
% 
% SYNTAX:
%	[strLibNew] = ExportLibrary(strLibOrig, lstRefSims, strLibNew)
%
% INPUTS: 
%	Name            Size		Units		Description
%	strLibOrig      'string'    [char]      Name of Simulink Library
%	lstRefSims     {'string'}  {[char]}     List of Simulink models using
%                                            the Simulink Library
%	strLibNew       'string'    [char]      Name for exported Simulink
%                                            Library.  Can be just the
%                                            library name or full path to
%                                            file.
%
% OUTPUTS: 
%	Name            Size		Units		Description
%	strLibNew       'string'    [char]      Name of exported Simulink
%                                            Library.  Can be just the
%                                            library name or full path to
%                                            file.
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[strLibNew] = ExportLibrary(strLibOrig, lstRefSims, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ExportLibrary.m">ExportLibrary.m</a>
%	  Driver script: <a href="matlab:edit Driver_ExportLibrary.m">Driver_ExportLibrary.m</a>
%	  Documentation: <a href="matlab:pptOpen('ExportLibrary_Function_Documentation.pptx');">ExportLibrary_Function_Documentation.pptx</a>
%
% See also ListLibInfo
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/685
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: http://vodka.ccc.northgrum.com/svn/LEMV/trunk/GNC/Utilities/ExportLibrary.m $
% $Rev: 1410 $
% $Date: 2012-04-16 16:26:55 -0700 (Mon, 16 Apr 2012) $
% $Author: sufanmi $

function [strLibNew] = ExportLibrary(strLibOrig, lstRefSims, strLibNew)

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
if((nargin < 3) || isempty(strLibNew))
    strLibNew = [strLibOrig '_copy'];
end

%% Main Function:

%%
try
    close_system(strLibNew);
catch
end

if(ischar(lstRefSims))
    lstRefSims = { lstRefSims };
end

load_system(strLibOrig);
set_param(strLibOrig, 'Lock', 'off');
save_system(strLibOrig, strLibNew);

% Compile list of all library blocks
lstLib = ListLib(strLibOrig);

% Compile list of what library blocks are used by the referenced
% simulations
lst_lib_blocks_used = {};
for iSim = 1:size(lstRefSims, 1)
    curSim = lstRefSims{iSim, 1};
    
    [lstBlocksInUse]= ListLibInfo(curSim, strLibOrig);
    
    if(iSim == 1)
        lst_lib_blocks_used = lstBlocksInUse;
    else
        lst_lib_blocks_used = {lst_lib_blocks_used{:,1} lstBlocksInUse{:,1} }';
        lst_lib_blocks_used = unique(lst_lib_blocks_used);
    end
end

lst_lib_blocks_to_remove = setxor(lstLib, lst_lib_blocks_used);

open_system(strLibNew);
set_param(strLibNew, 'Lock', 'off');

for i = 1:size(lst_lib_blocks_to_remove, 1)
    curBlock = lst_lib_blocks_to_remove{i,:};
    curBlock = strrep(curBlock, strLibOrig, strLibNew);
    try
        delete_block(curBlock);
    catch
    end
end

lstTopLayer = find_system(strLibNew, 'SearchDepth', 1, 'BlockType', 'SubSystem');
lst_lib_blocks_used = strrep(lst_lib_blocks_used, strLibOrig, strLibNew);

for i = 1:size(lstTopLayer, 1)
    curTopBlock = lstTopLayer{i,:};
    flgUsed = sum(cell2mat(strfind(lst_lib_blocks_used, curTopBlock))) > 0;
    if(flgUsed == 0)
        set_param(curTopBlock, 'ForegroundColor', 'gray');
    end
end

close_system(strLibOrig);

save_system(strLibNew);
close_system(strLibNew);

end % << End of function ExportLibrary >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110119 MWS: Created function using CreateNewFunc
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
