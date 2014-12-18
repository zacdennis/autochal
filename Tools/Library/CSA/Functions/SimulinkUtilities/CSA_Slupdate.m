% CSA_SLUPDATE Perform slupdate on a system
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CSA_Slupdate:
%     Perform slupdate on a given system (CSA_Library is default). Matlab
%     now requires the system to be compiled for a slupdate to be
%     successful. This can be a problem when the system is a lybrary and
%     cannot be compiled. CSA_Slupdate.m moves the questionable blocks to a
%     new model in order to perform slupdate, then replaces them in the
%     desired system. Reports are generated that list which blocks were
%     updated, which were ok (no change), and which still failed (require further
%     manual changes)
% 
% SYNTAX:
%	[SlupNotes_Updated,SlupNotes_Failed,SlupNotes_NoChange,SlupNotes_Original] = CSA_Slupdate(SysName, xlsFile, xlsSheet)
%
% INPUTS: 
%	Name	   Size	     Units	    Description
%	SysName    N/A       None       String of system name to perform
%                                       slupdate on
%   xlsFile    N/A       None       String of xls file to save slupdate
%                                       reports (output ifno)
%   xlsSheet   N/A       None       String of xls sheet to save slupdate
%                                       reports (output ifno)
%
% OUTPUTS: 
%	Name	                Size	Units	Description
%	 SlupNotes_Updated	    N/A     None    Cell info of the block path
%                                               that was updated and the 
%                                               reason for update
%	 SlupNotes_Failed	    N/A     None    Cell info of the block path
%                                               that failed to update and  
%                                               reason
%	 SlupNotes_NoChange	    N/A     None    Cell info of the block path
%                                               that was initially flagged
%                                               by slupdate.m, but which
%                                               required no change
%	 SlupNotes_Original	    N/A     None    Cell info of the original
%                                               analysis of slupdate.m on 
%                                               the SysName
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLE:
%	[SlupNotes_Updated,SlupNotes_Failed,SlupNotes_NoChange,SlupNotes_Original] = CSA_Slupdate('CSA_Library', 'CSA_Slupdate.xls', 'Pass1')
%
% SOURCE DOCUMENTATION:
%	[1]    http://www...
%	[2]    Author. Book Title. Publisher, City, Copyright year
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CSA_Slupdate.m">CSA_Slupdate.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_CSA_Slupdate.m">DRIVER_CSA_Slupdate.m</a>
%	  Documentation: <a href="matlab:pptOpen('CSA_Slupdate Documentation.pptx');">CSA_Slupdate Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/562
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CSA_Slupdate.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [SlupNotes_Updated,SlupNotes_Failed,SlupNotes_NoChange,SlupNotes_Original] = CSA_Slupdate(SysName, xlsFile, xlsSheet)

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

%% Initialize
% Outputs
SlupNotes_Updated.blockList = {};
SlupNotes_Updated.blockReasons = {};
SlupNotes_Failed.blockList = {};
SlupNotes_Failed.blockReasons = {};
SlupNotes_NoChange.blockList = {};
SlupNotes_NoChange.blockReasons = {};

%Loop Counters
iFail = 1;
iUpdate = 1;
iNoChange = 1;

%% Input Argument Conditioning
if nargin < 1
    SysName = 'CSA_Library';
    xlsFlag = 0;
elseif nargin < 2
    xlsFlag = 0;
elseif nargin < 3
    xlsFlag = 1;
    xlsSheet = 'Pass1';
else
    xlsFlag = 1;
end

%% Main Function
% Evaluate CSA background data that may be used by blocks in CSA Library
% slupdate requires variables to be loaded in workspace
evalin('base', 'CentralBody = CentralBodyEarth_init; conversions;')

% Open system to perform slupdate on
open(SysName)

% Perform slupdate analysis
SlupNotes_Original = slupdate(SysName, 'OperatingMode', 'Analyze');

% Loop through each flagged block
for iList = 1:length(SlupNotes_Original.blockList)
    
    % Block name as a string (required for add-block, delete_block)
    BlockName = SlupNotes_Original.blockList{iList};
    
    % Create new system to perform slupdate on with flagged block
    new_system('SlupdateTemp', 'Model')
    add_block(BlockName, 'SlupdateTemp/sys')
    
    % Perform slupdate analysis on new model
    SlupNotesTemp = slupdate('SlupdateTemp', 'OperatingMode', 'Analyze');

    % Determine status of block
    if isempty(SlupNotesTemp.blockList) % Block does not need updating, record block info
        
        SlupNotes_NoChange.blockList(iNoChange) = SlupNotes_Original.blockList(iList);
        SlupNotes_NoChange.blockReasons(iNoChange) = {'No Change'};
        % No Change Counter
        iNoChange = iNoChange + 1;
        
    elseif(strmatch(SlupNotesTemp.blockReasons{1}, 'Unable to check because slupdate was unable to compile model SlupdateTemp', 'exact')) % Block failed to update, record block info
        
        SlupNotes_Failed.blockList(iFail) = SlupNotes_Original.blockList(iList);
        SlupNotes_Failed.blockReasons(iFail) = SlupNotes_Original.blockReasons(iList);
        % Fail counter
        iFail = iFail + 1;
        
    else % Update block and record info
        
        % slupdate
        slupdate('SlupdateTemp', 0);
        % Return updated block to desired system (BlockName within SysName)
        PosTemp = get_param(BlockName, 'Position');
        delete_block(BlockName);
        add_block('SlupdateTemp/sys', BlockName, 'Position', PosTemp);
        
        SlupNotes_Updated.blockList(iUpdate:iUpdate+length(SlupNotesTemp.blockList) - 1) = SlupNotes_Original.blockList(iList:iList+length(SlupNotesTemp.blockList) - 1);
        SlupNotes_Updated.blockReasons(iUpdate:iUpdate+length(SlupNotesTemp.blockList) - 1) = SlupNotesTemp.blockReasons(1:end);
        % Update Counter
        iUpdate = iUpdate + length(SlupNotesTemp.blockList);
    end
    
    % close temp system
    close_system('SlupdateTemp', 0)
    
end

%% Display Results
clc;

disp([SysName ' updated to current version of Simulink']);

numUpdate     = length(SlupNotes_Updated.blockList);
numFail       = length(SlupNotes_Failed.blockList);
numNoChange   = length(SlupNotes_NoChange.blockList);
% fprintf('\n');
fprintf('\n%.0f Block/s updated',numUpdate)
fprintf('\n%.0f Block/s failed to update, require manual update',numFail)
fprintf('\n%.0f Block/s originally flagged by slupdate.m, did not require updates\n',numNoChange)

if(numUpdate)
    % Check for undesireable replacement of Sqrt function (only check if
    % updates made)
    sqrttext = ' ''sqrt'' function in Math block has been deprecated and should be replaced by ''signedSqrt'' function in Sqrt Function block.';
    
    for iCheck = 1:numUpdate
        CheckSQRT(iCheck) = ~isempty(strmatch(SlupNotes_Updated.blockReasons{iCheck}, sqrttext, 'exact'));
    end
    
    if(sum(CheckSQRT))
        fprintf('\n');
        disp([SysName ' contained ' '''square root''' ' functions that were replaced by ''signed square roots''']);
        disp('This may be undesireble, check block/s and possibly change to a regular ''square root''');
    end
end

%% Write xls data
if(xlsFlag)
    if ~isempty(SlupNotes_Updated.blockList)
        xlswrite(xlsFile, {'Updated Blocks'}, xlsSheet, 'A2')
        xlswrite(xlsFile, SlupNotes_Updated.blockList', xlsSheet, 'A3')
        xlswrite(xlsFile, SlupNotes_Updated.blockReasons', xlsSheet, 'B3')
    end
    
    if ~isempty(SlupNotes_Failed.blockList)
        xlswrite(xlsFile, {'Failed'}, xlsSheet, 'D2')
        xlswrite(xlsFile, SlupNotes_Failed.blockList', xlsSheet, 'D3')
        xlswrite(xlsFile, SlupNotes_Failed.blockReasons', xlsSheet, 'E3')
    end
    
    if ~isempty(SlupNotes_NoChange.blockList)
        xlswrite(xlsFile, {'No Change'}, xlsSheet, 'G2')
        xlswrite(xlsFile, SlupNotes_NoChange.blockList', xlsSheet, 'G3')
        xlswrite(xlsFile, SlupNotes_NoChange.blockReasons', xlsSheet, 'H3')
    end
end

end % << End of function CSA_Slupdate >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 100817 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName  :  Email  :  NGGN Username 
% PBH: Patrick Healy : patrick.healy@ngc.com : healypa

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
