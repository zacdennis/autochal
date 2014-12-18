% LASTCLICKED Retrieves handle of last block or signal line clicked
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% LastClicked:
%     Retrieves handle of last block or signal line clicked 
% 
% SYNTAX:
%	[hdl, strLastClicked] = LastClicked()
%
% INPUTS: 
%	Name    	Size		Units		Description
%   No Inputs
%
% OUTPUTS: 
%	Name            Size		Units               Description
%   hdl             [1]         [Simulink handle]   Handle to last selected
%                                                   block or line
%   stLastClicked   'string'    [char]              Descriptive string of
%                                                   last item selected
%
% NOTES:
%
% EXAMPLES:
%	% The following examples were generated clicking on different blocks
%	% and lines in the 'f14' model and running: [hdl] = LastClicked()
%
%   % Example Output 1: Named Line
%	% hdl = 4.3820e+003
%   % str = 'w' line from f14/Aircraft Dynamics Model (Outport #1) to f14/Gain5 (Inport #1)
%
%   % Example Output 2: Unnamed Line
%   % hdl = 4.3960e+003
%   % str = '<unnamed>' line from f14/Gain1 (Outport #1) to f14/Sum (Inport #2)
%
%   % Example Output 3: Simulink Block
%   % hdl = 4.2680e+003
%   % str = f14/Aircraft
%   %       Dynamics
%   %       Model
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit LastClicked.m">LastClicked.m</a>
%	  Driver script: <a href="matlab:edit Driver_LastClicked.m">Driver_LastClicked.m</a>
%	  Documentation: <a href="matlab:pptOpen('LastClicked_Function_Documentation.pptx');">LastClicked_Function_Documentation.pptx</a>
%
% See also get_param
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/690
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [hdl, strLastClicked] = LastClicked(varargin)

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
hdl= [];
strLastClicked = '';

%% Main Function:
%  Try the line first:
line = find_system(gcs, 'SearchDepth', 1, 'FindAll', 'on', ...
    'Type', 'line', 'Selected', 'on');

if(~isempty(line))
    % It's a Line:
    hdl = line;
    
    strSignalName = get_param(line, 'Name');
    if(isempty(strSignalName))
        strSignalName = '<unnamed>';
    end
    
    strParent = get_param(line, 'Parent');
    hdlLineSrc = get_param(line, 'SrcPortHandle');
    numPortSrc = get_param(hdlLineSrc, 'PortNumber');
    
    blkLineSrc = get_param(line, 'SrcBlockHandle');
    strBlockSrc = get_param(blkLineSrc, 'Name');
    strBlockSrc = strrep(strBlockSrc, endl, ' ');

    hdlLineDst = get_param(line, 'DstPortHandle');
    numPortDst = get_param(hdlLineDst, 'PortNumber');
    
    blkLineDst = get_param(line, 'DstBlockHandle');
    strBlockDst = get_param(blkLineDst, 'Name');
    strBlockDst = strrep(strBlockDst, endl, ' ');
    
    strLastClicked = sprintf('''%s'' line from %s/%s (Outport #%d) to %s/%s (Inport #%d)', ...
        strSignalName, strParent, strBlockSrc, numPortSrc, ...
        strParent, strBlockDst, numPortDst);

else
   
    % It's a Block:
    hdl = gcbh;
    strLastClicked = gcb;
    
end

end % << End of function LastClicked >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110408 MWS: Created function using CreateNewFunc
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
