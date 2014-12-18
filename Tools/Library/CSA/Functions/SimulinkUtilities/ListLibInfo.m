% LISTLIBINFO Determines which Libary blocks are used by a list of Simulink models
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ListLibInfo:
%     This function determines which Library blocks are used by a list of
%     Simulink models.  The default Reference Library is the 'CSA_Library'.
%     In addition to a simple list of used blocks, function will also
%     return an information structure containing where in each simulation
%     the reference blocks are used.
% 
% SYNTAX:
%	[lstBlocksInUse, simInfo] = ListLibInfo(lstSims, RefLib)
%	[lstBlocksInUse, simInfo] = ListLibInfo(lstSims)
%
% INPUTS: 
%	Name            Size		Units		Description
%	lstSims	       {'string'}   [char]      Name of Simulink models to
%                                            check
%                                            Default: bdroot
%   RefLib          'string'    [char]      Reference Simulink Library
%                                            Default: CSA_Library
%
% OUTPUTS:
%	Name         	Size		Units		Description
%	lstBlocksInUse  {'string'}  [char]      List of blocks in 'RefLib' used
%                                           by the simulations listed in 
%                                           'lstSims'
%   simInfo         struct      [varies]    Structure containing lists of
%                                           where each 'RefLib' block is 
%                                           used in each simulation (see
%                                           below)
% NOTES:
%   'simInfo' Breakdown:
%     .Name                     'string'    Name of Simulation file
%     .ReferenceLibrary         'string'    Name of Reference Simulink lib
%     .lstBlocksUsed           {'string'}   List of Library blocks used by
%                                            current simulation
%     .BlockBreakdown.RefBlock  'string'    Reference library block
%     .BlockBreakdown.Blocks   {'string'}   Where each reference block is
%                                           used in the simulation
%
% EXAMPLES:
%	% Example #1: Determine 'CSA_Library' blocks used in the active
%   % simulation.  Note that all these methods work the same:
%	lstBlocksInUse = ListLibInfo()
%	lstBlocksInUse = ListLibInfo(bdroot)
%	lstBlocksInUse = ListLibInfo([], 'CSA_Library')
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ListLibInfo.m">ListLibInfo.m</a>
%	  Driver script: <a href="matlab:edit Driver_ListLibInfo.m">Driver_ListLibInfo.m</a>
%	  Documentation: <a href="matlab:pptOpen('ListLibInfo_Function_Documentation.pptx');">ListLibInfo_Function_Documentation.pptx</a>
%
% See also libinfo, unique
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/692
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/ListLibInfo.m $
% $Rev: 1859 $
% $Date: 2011-06-02 13:22:45 -0500 (Thu, 02 Jun 2011) $
% $Author: sufanmi $

function [lstBlocksInUse, simInfo] = ListLibInfo(lstSims, RefLib)

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

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
if((nargin < 2) || isempty(RefLib))
    RefLib = 'CSA_Library';
end

if((nargin < 1) || isempty(lstSims))
    lstSims = bdroot;
end

if(ischar(lstSims))
    lstSims = { lstSims };
end

%% Main Function:
lstBlocksInUse = {};    % Initialize Output List

for iSim = 1:size(lstSims, 1)
    strSim = lstSims{iSim, 1};
    
    load_system(strSim);
    info = libinfo(strSim);
    
    lstBlocksUsed= {}; iBU = 0;
    infoRef = {};
    arrBU = [];
    
    for i = 1:size(info, 1)
        curLinkedBlock = info(i);
        if(strcmp(curLinkedBlock.Library, RefLib))
            iBU = iBU + 1;
            lstBlocksUsed(iBU,1) = { curLinkedBlock.ReferenceBlock };
            infoRef(iBU) = { curLinkedBlock };
            arrBU(iBU) = i;
        end
    end
    lstBlocksUsed = unique(lstBlocksUsed);
    for iBU = 1:size(lstBlocksUsed, 1);
        strLinkedBlock = lstBlocksUsed{iBU,:};
        infoRef2(iBU).RefBlock = strLinkedBlock;
        infoRef2(iBU).Blocks = {};
    end
    
    for iBU = 1:size(lstBlocksUsed, 1);
        strLinkedBlock = lstBlocksUsed{iBU,:};
        iUsed = 0;
        for i = 1:length(arrBU)
            curIndex = arrBU(i);
            curLinkedBlock = info(curIndex);
            if(strcmp(curLinkedBlock.ReferenceBlock, strLinkedBlock))
                iUsed = iUsed + 1;
                infoRef2(iBU).Blocks(iUsed,1) = { curLinkedBlock.Block };
                infoRef2(iBU).Blocks(iUsed,2) = { curLinkedBlock.LinkStatus };
            end
        end
    end
    
    % Add to Master
    simInfo(iSim).Name              = strSim;
    simInfo(iSim).ReferenceLibrary  = RefLib;
    simInfo(iSim).lstBlocksUsed     = lstBlocksUsed;
    simInfo(iSim).BlockBreakdown    = infoRef2;
    
    lstBlocksInUse = [lstBlocksInUse; lstBlocksUsed];
end

lstBlocksInUse = unique(lstBlocksInUse);


end % << End of function ListLibInfo >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110602 MWS: Expanded function to compare RefLib against a list of
%             simulations (instead of just 1).  Added documentation.
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
