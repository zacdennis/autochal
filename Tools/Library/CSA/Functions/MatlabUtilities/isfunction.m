% ISFUNCTION Determines if .m file is a MATLAB recognized function
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% isfunction:
%     Determines if .m file is a MATLAB recognized function
% 
% SYNTAX:
%	[flgFunc, pathFunc] = isfunction(funName)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	funName     'string'    [char]      File Name
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	flgFunc     [1]         ["bool"]    Is File a MATLAB function?
%	pathFunc	'string'    [char]      Full path to function
%
% NOTES:
%	This function uses the CSA_Library's 'findArgs' function.
%
% EXAMPLES:
%	Show that isfunction works on a known function:
%	flgFunc = isfunction('eul2dcm')
%	Returns:    1   (true)
%
%	Show that isfunction works on a known script:
%	flgFunc = isfunction('Driver_eul2dcm')
%	Returns:    0   (false)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit isfunction.m">isfunction.m</a>
%	  Driver script: <a href="matlab:edit Driver_isfunction.m">Driver_isfunction.m</a>
%	  Documentation: <a href="matlab:pptOpen('isfunction_Function_Documentation.pptx');">isfunction_Function_Documentation.pptx</a>
%
% See also findArgs 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/668
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/isfunction.m $
% $Rev: 3240 $
% $Date: 2014-09-02 15:24:03 -0500 (Tue, 02 Sep 2014) $
% $Author: sufanmi $

function [flgFunc, pathFunc] = isfunction(funName)

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
flgFunc= 0;
pathFunc= '';

%% Main Function:
if(exist(funName) == 2)
    [InArgList, OutArgList] = findArgs(funName, 0);
    
    if( (~isempty(InArgList)) || (~isempty(OutArgList)) )
        flgFunc = 1;
        pathFunc = fileparts(mfilename('fullpath'));
    end
end

end % << End of function isfunction >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101013 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
