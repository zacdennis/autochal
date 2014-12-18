% GET_FUNCTION_DEPENDENTS Locates dependent functions of an M/P-file
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% get_function_dependents:
%   This function retrieves all the non-MATLAB provided support functions
%   of the inputted .m or .p file and copies them into a folder for easy
%   export.
%
%   This function is highly useful when you have written a big function
%   that depends on a bunch of smaller functions that you have also
%   written.  If someone wants to borrow this function, but you don't want
%   to give them your entire sim repository, you can use this function to
%   retrieve only the utilized sub-functions.  These functions will be
%   saved off in a user-defined folder for easy zip and export.
%
%   This function assumes that the user created functions are not in 
%   the MATLAB install directory (matlabroot).
% 
% SYNTAX:
%	[lstFiles] = get_function_dependents(funct_nam, 'PropertyName', PropertyValue)
%	[lstFiles] = get_function_dependents(funct_nam, varargin)
%	[lstFiles] = get_function_dependents(funct_nam)
%
% INPUTS: 
%	Name     	Size        Units       Description
%   funct_nam   'string'    [char]      Name of Function to find dependents
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	lstFiles 	{'string'}  [char]      Cell array of strings listing all
%                                       files just created
%
% NOTES:
%   There are no workspace variables created. This function just copies
%   files to a new location
%
%	VARARGIN PROPERTIES:
%	PropertyName    PropertyValue	Default         Description
%	'FldrName'      'string'        [pwd filesep 'SupportFunctions']
%                                                   Default folder in which
%                                                   to place function
%                                                   dependents
%   'ListOnly'      [bool]          0               Only list the
%                                                   dependents?
%                                                   0: no (copy files too)
%
% EXAMPLES:
%	% Example 1.1: Retrieve the function dependents of the CSA_Library 
%   %            function 'vincenty'.
%	[lstFiles] = get_function_dependents('vincenty', 'ListOnly', 1)
%   lstFiles = {'<SimRoot>\CSA_LIB\Functions\MathUtilities\CheckLatLon.m'}
%
%   % Example 1.2: Same as 1.1, but show now copy the dependents into a
%   %              exportable folder
%	[lstFiles] = get_function_dependents('vincenty')    % -OR-
%	[lstFiles] = get_function_dependents('vincenty', 'ListOnly', 0)
%   lstFiles = {'<SimRoot>\SupportFunctions\CheckLatLon.m''}
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit get_function_dependents.m">get_function_dependents.m</a>
%	  Driver script: <a href="matlab:edit Driver_get_function_dependents.m">Driver_get_function_dependents.m</a>
%	  Documentation: <a href="matlab:pptOpen('get_function_dependents_Function_Documentation.pptx');">get_function_dependents_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/447
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/get_function_dependents.m $
% $Rev: 2479 $
% $Date: 2012-09-07 18:32:04 -0500 (Fri, 07 Sep 2012) $
% $Author: g42038 $

function [lstFiles] = get_function_dependents(funct_nam, varargin)

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
% Pick out Properties Entered via varargin
[FldrName, varargin]  = format_varargin('FldrName', [pwd filesep 'SupportFunctions'], 2, varargin);
[ListOnly, varargin]  = format_varargin('ListOnly', 0, 2, varargin);
[flgVerbose, varargin]  = format_varargin('Verbose', 1, 2, varargin);

%% Main Function:
if(flgVerbose)
    disp([mfnam '>> Searching for all dependents of ' funct_nam '.  This will take awhile.  Please be patient. (Ctrl+C to boot).']);
end

list = depfun(funct_nam,'-quiet');

numDeps = size(list, 1);
arrMATLAB = cell2mat(strfind(list, matlabroot));
numMATLAB = sum(arrMATLAB);
numNonMATLAB = numDeps - numMATLAB - 1;

lstFiles = cell(numNonMATLAB, 1); iFile = 0;
for iDep = 1:numDeps;
    curDep = list{iDep, :};
    flgNonMATLAB = isempty(strfind(curDep, matlabroot));
    flgNotItself = ~strcmp(which(funct_nam), curDep);
    
    if(flgNonMATLAB && flgNotItself)
        curDep = list{iDep, :};
        
        iFile = iFile + 1;
        lstFiles(iFile,:) = {curDep};
    end
end

if(~ListOnly && (iFile > 0))
    lstFiles = copyfiles(lstFiles, FldrName, 'CollapseFolders', 1, 'OutputFormat', 'ListNew', varargin);
end

end % << End of function get_function_dependents >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
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
