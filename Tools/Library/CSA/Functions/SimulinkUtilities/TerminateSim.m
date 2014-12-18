% TERMINATESIM Check that a previous model isn't still running
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% TerminateSim:
%     Check that a previous model isn't still running: No output variables 
%   created 
% 
% SYNTAX:
%	[] = TerminateSim(SimName, flgVerbose)
%	[] = TerminateSim(SimName)
%
% INPUTS: 
%	Name    	Size		Units		Description
%   SimName     [1xN]       [ND]        String of name of simulation
%   flgVerbose  [1]         [bool]      Inform User of Progress?
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%   None
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[] = TerminateSim(SimName, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit TerminateSim.m">TerminateSim.m</a>
%	  Driver script: <a href="matlab:edit Driver_TerminateSim.m">Driver_TerminateSim.m</a>
%	  Documentation: <a href="matlab:pptOpen('TerminateSim_Function_Documentation.pptx');">TerminateSim_Function_Documentation.pptx</a>
%
% See also format_varargin 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/540
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/TerminateSim.m $
% $Rev: 1787 $
% $Date: 2011-05-23 20:23:29 -0500 (Mon, 23 May 2011) $
% $Author: sufanmi $

function [] = TerminateSim(SimName, flgVerbose)

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
if( (nargin == 1) || isempty(flgVerbose) )
    flgVerbose = 1;
end
%
%% Main Function:
try
    if strcmp(get_param(SimName, 'SimulationStatus'), 'paused')
        if(flgVerbose == 1)
            disp(['Terminating ' SimName ' because it is still in use']);
        end
        eval_cmd = [SimName '([], [], [], ''term'');' ];
        eval(eval_cmd);
    end
catch
end

%% Compile Outputs:
%	= -1;

end % << End of function TerminateSim >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720 

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
