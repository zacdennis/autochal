% ADDDOCBLOCK Adds a DocBlock to a Simulink subsystem
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% AddDocBlock:
%     Add a Doc Block to a Simulink subsystem with a user provided comment
% 
% SYNTAX:
%	[block_pos] = AddDocBlock(BlockPath, TextToAdd)
%	[block_pos] = AddDocBlock(BlockPath)
%
% INPUTS: 
%	Name            Size        Units       Description
%	 BlockPath      [1xn]       [string]	Full Path to Block
%	 TextToAdd      [1xm]       [string]    Text to Add to Doc Block
%                                            Default: '' (none)
%
% OUTPUTS: 
%  Name             Size        Units       Description
%   block_pos       [1x4]       [int]       Position of DocBlock in 
%                                            Simulink diagram where
%                                            block_pos is defined as
%                                            [left bottom width height]
%
% NOTES:
%
% EXAMPLE:
%   % Adds a string to the f14 model
%   txt = 'This is the documentation to add'
%   AddDocBlock('f14', txt)
%
%   % Adds a cell array of strings to the f14 model
%   txt = {'This is line1', 'Line2'}
%   AddDocBlock('f14', txt)
%
% See also cell2str
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/680
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/AddDocBlock.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [block_pos] = AddDocBlock(BlockPath,TextToAdd)

%% General Header 
spc  = sprintf(' ');
tab  = sprintf('\t');
endl = sprintf('\n');
[mfpath,mfnam] = fileparts(mfilename('fullpath'));
mfspc = char(ones(1,length(mfnam))*spc);

if(nargin == 1)
    TextToAdd = '';
end

%% < Function Sections >
if(iscell(TextToAdd))
    TextToAdd = cell2str(TextToAdd, char(10));
end

ptr_slashes = findstr(BlockPath, '/');

load_system('simulink');
if(isempty(ptr_slashes))
    open_system(BlockPath, 'force');
else
    open_system(BlockPath(1:ptr_slashes(1)-1), 'force');
end

flgGood = 0; i = 0;
while(flgGood == 0)
    if(i == 0)
        curDocBlock = [BlockPath '/DocBlock'];
    else
        curDocBlock = [BlockPath '/DocBlock' num2str(i)];
    end
    
    try        
        add_block('simulink/Model-Wide Utilities/DocBlock', curDocBlock, 'UserData', TextToAdd);
        block_pos = get_param(curDocBlock, 'Position');
        block_w = block_pos(3) - block_pos(1);
        block_h = block_pos(4) - block_pos(2);
        
        block_pos(1) = 10 + 50*i;
        block_pos(2) = 10; 
        block_pos(3) = block_pos(1) + block_w;
        block_pos(4) = block_pos(2) + block_h;
        set_param(curDocBlock, 'Position', block_pos);
        
        flgGood = 1;
    catch
        
        flgGood = 0;
        i = i + 1;
        
        [a, errmsg] = lasterr;
        if(strcmp(errmsg, 'Simulink:SL_LockViolation'))
            disp(sprintf('%s >> Model is Locked.  Ignoring Command to Add DocBlock', mfnam));
        flgGood = 1;
        end
    end
end

open_system(BlockPath, 'force');

% Example of Display formats ...
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>>CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>>WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>>ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >>ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Outputs 

%% Return 
end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100804 MWS: File Created
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName  :  Email  :  NGGN Username
% MWS: Mike Sufana : mike.sufana@ngc.com : sufanmi

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
