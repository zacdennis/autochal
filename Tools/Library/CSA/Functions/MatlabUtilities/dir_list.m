% DIR_LIST Recursive Directory List
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% dir_list:
%  Lists the files in a directory and any subdirectory.  Has built-in plugs
%  to allow user to specify what sub-directories not to use.  This works
%  similar to MATLAB's 'dir' function, but has the added features of being
%  able to recurse into subdirectories as well as specifying the starting
%  folder and a list of directory-name keyword strings to avoid while
%  searching.
% 
% SYNTAX:
%	[lstFiles] = dir_list(lstCombos, flgRecurse, varargin, ...
%                          'PropertyName', PropertyValue)
%	[lstFiles] = dir_list(lstCombos, flgRecurse, varargin)
%	[lstFiles] = dir_list(lstCombos, flgRecurse)
%	[lstFiles] = dir_list(lstCombos)
%	[lstFiles] = dir_list()
%
% INPUTS: 
%	Name      	Size		Units		Description
%	lstCombos	'string'    [char]      String or cell array of strings
%              {'string'}  {[char]}      with file keywords to look for
%                                        Default: '' (i.e. return 
%                                        everything)
%	flgRecurse	[1]         [bool]      Recurse into subdirectories?
%                                        Default: false (0)
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
% OUTPUTS: 
%	Name      	Size		Units		Description
%	lstFiles	{'string'}  [char]      Cell array of all found files
%                                        matching 'lstCombos'
% NOTES:
%   This function uses the CSA Library function 'pathgen' and 'str2cell' if
%   it is set to recurse into subdirectories (i.e. flgRecurse = 1)
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	'Root'              'string'        pwd         Folder in which to 
%                                                   begin directory search
%   'DirExclude'        {'string'}      {'.svn';'private'}  String or cell
%                                                   array of keywords to
%                                                   exclude when searching
%                                                   directories
%   'FileExclude'       {'string'}      ''          String or cell array of
%                                                   keywords to exclude
%                                                   when searching
%                                                   filenames
%   'ReturnString'      boolean         false       Return 'lstFiles' as a
%                                                   string if only 1 result
%                                                   found
%
% EXAMPLES:
%	Example 1: Show contents of current directory
%	lstFiles = dir_list()
%
%	Example 2: Find all MATLAB .m files in the current directory and any
%	subdirectories, including class and overloaded package directories
%	lstFiles = dir_list('*.m', 1)
%
%	Example 3: Find all MATLAB .m files in the current directory and any
%	subdirectories, ignoring directories pertaining to MATLATB classes,
%	overloaded packages, and Tortoise SVN folders
%	lstFiles = dir_list('*.m', 1, 'DirExclude', {'@';'+';'.svn';'private'})
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit dir_list.m">dir_list.m</a>
%	  Driver script: <a href="matlab:edit Driver_dir_list.m">Driver_dir_list.m</a>
%	  Documentation: <a href="matlab:pptOpen('dir_list_Function_Documentation.pptx');">dir_list_Function_Documentation.pptx</a>
%
% See also pathgen, str2cell, dir 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/442
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/dir_list.m $
% $Rev: 3004 $
% $Date: 2013-08-28 14:25:59 -0500 (Wed, 28 Aug 2013) $
% $Author: sufanmi $

function [lstFiles] = dir_list(lstCombos, flgRecurse, varargin)

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

%% Input Argument Conditioning
[fldrRoot, varargin]        = format_varargin('Root', pwd, 2, varargin);
[lstDirExclude, varargin]   = format_varargin('DirExclude',  {'.svn';'private'}, 2, varargin);
[lstFileExclude, varargin]  = format_varargin('FileExclude',  '', 2, varargin);
[ReturnString, varargin]    = format_varargin('ReturnString',  false, 2, varargin);

switch nargin
    case 0 
        lstCombos = '';
        flgRecurse = [];
    case 1
        flgRecurse = []; 
    case 2
        % Full
end

if(isstr(lstFileExclude))
    lstFileExclude = {lstFileExclude};
end

if(isempty(flgRecurse))
    flgRecurse = 0;
end

numCombos = size(lstCombos, 1);
lstFiles = {};

if((numCombos == 1) && ischar(lstCombos))
    
    ptrSlash = strfind(lstCombos, filesep);
    if(~isempty(ptrSlash))
        fldrRoot = lstCombos(1:ptrSlash(end));
        lstCombos = { lstCombos(ptrSlash(end)+1:end) };
    else
        lstCombos = { lstCombos };
    end
end

if(isempty(lstCombos))
    lstCombos = { '' };
    numCombos = 1;
end

if(flgRecurse)
    lstFolders = str2cell(pathgen(fldrRoot, lstDirExclude), ';');
else
    lstFolders = { fldrRoot };
end
numFolders = size(lstFolders, 1);
iCtr = 0;

for iFolder = 1:numFolders
    curFolder = lstFolders{iFolder,:};

    for iCombo = 1:numCombos
        curCombo = lstCombos{iCombo, :};

        if(isempty(curCombo))
            lst = dir(curFolder);
        else
            lst = dir([curFolder filesep curCombo]);
        end

        for i = 1:size(lst, 1)
            flgAdd = 1;

            if(lst(i).isdir)
                flgAdd = 0;
            else
                for iFileExclude = 1:size(lstFileExclude,1)
                    curFileExclude = lstFileExclude{iFileExclude,:};
                    if(~isempty(strfind(lst(i).name, curFileExclude)))
                        flgAdd = 0;
                    end
                end

                if(flgAdd)
                    % Only Count the file if it's not a directory
                    iCtr = iCtr + 1;
                    if(flgRecurse)
                        lstFiles(iCtr,:)={[curFolder filesep lst(i).name]};
                    else
                        lstFiles(iCtr,:) = { [lst(i).name] };
                    end
                end
            end
        end
    end
end

numFiles = size(lstFiles, 1);
if((numFiles == 1) && (ReturnString))
    lstFiles = lstFiles{1,:};
end

end

%% << End of function dir_list >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110517 MWS: Added in ability to specify the search folder for a given
%             'lstCombos'.  Assumes that only one combo (e.g.
%             size(lstCombos, 1) == 1) exists
% 110125 JPG: CoSMO'd the function. Fixed minor bug on line 124, flgRecurse
%             wasn't defined before that point.
% 101004 CNF: Function template created using CreateNewFunc
% 100614 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/MATLAB_UTILITES/dir_list.m
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email              	: NGGN Username
% JPG: James Gray 	: james.gray2@ngc.com	: G61720
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

%% FOOTER
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
