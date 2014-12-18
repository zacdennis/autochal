% ISFIG Determines if figure number is an actual, open MATLAB figure
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% isfig:
%     Determines if figure number is an actual, open MATLAB figure
% 
% SYNTAX:
%	[flgFig] = isfig(numFig)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	numFig      [n]         [hdl]       Object handle
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	flgFig      [n]         [bool]      Is object really a figure?
%
% NOTES:
%
% EXAMPLES:
%	% Example #1: Find all open objects (Simulink scopes included) and
%	%             determine which are figures
%   arrFigHdl = sort( allchild(0) );
%	[flgFig] = isfig(arrFigHdl)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit isfig.m">isfig.m</a>
%	  Driver script: <a href="matlab:edit Driver_isfig.m">Driver_isfig.m</a>
%	  Documentation: <a href="matlab:pptOpen('isfig_Function_Documentation.pptx');">isfig_Function_Documentation.pptx</a>
%
% See also gcf 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/490
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/isfig.m $
% $Rev: 1826 $
% $Date: 2011-05-26 20:07:38 -0500 (Thu, 26 May 2011) $
% $Author: sufanmi $

function [flgFig] = isfig(numFig)

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



%% Input Argument Conditioning:
if(nargin == 0)
    numFig = gcf;
end

%% Initialize Outputs:
flgFig = numFig * 0;

%% Main Function:
for i = 1:length(numFig)
    curFig = numFig(i);
    
    curFlgFig = 1;
    try
        figInfo = get(curFig);
        
        if(strcmp(figInfo.Tag, 'SIMULINK_SIMSCOPE_FIGURE'))
            curFlgFig = 0;
        end
        
    catch
        curFlgFig = 0;
    end
    
    flgFig(i) = curFlgFig;
end

end % << End of function isfig >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110526 MWS: Made function work for vectorized and no input
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720 
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi

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
