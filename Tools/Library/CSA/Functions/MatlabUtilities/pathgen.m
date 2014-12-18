% PATHGEN Generates a path string using recursion
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% pathgen:
%  Returns a path string starting at the inputted 'fldrRoot' folder.  Has
%  built-in plugs to allow user to specify keywords to discard.  Note that
%  this function is similar to MATLAB's genpath function, but this gives
%  the user the power to include or ignore special folders like those with
%  a '@' that are used for classes or those with a '+' that are used for
%  overloaded packages.
% 
% SYNTAX:
%	[strPath] = pathgen(fldrRoot, lstExclude, varargin, 'PropertyName', PropertyValue)
%	[strPath] = pathgen(fldrRoot, lstExclude, varargin)
%	[strPath] = pathgen(fldrRoot, lstExclude)
%	[strPath] = pathgen(fldrRoot)
%
% INPUTS: 
%	Name		Size		Units		Description
%	fldrRoot    'string'    [char]      Top level folder from which to
%                                        start path generation
%	lstExclude {'string'}   [char]      Cell array of keyword strings to
%                                        avoid when adding directory to path
%										 Default: {'@';'+';'.svn';'private'}
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
%   flgRelative [1]         [bool]      Retern relative path?
%                                        Default: 0 (no)
% OUTPUTS:
%	Name		Size		Units		Description
%	strPath		'string'    [char]      Generated path where compiled
%                                        folders are separated by ';'
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'Relative'          boolean         false       Output generated path
%                                                   relative to root?
%                                                   False returns full path
%   'OutputAsCell'      boolean         false       Return path in cell
%                                                   array format? False
%                                                   returns a string.
%   'IncludeRoot'       boolean         true        Include the root
%                                                   directory in returned
%                                                   path?
%
% EXAMPLES:
%	% Return the full path of the current folder and display it as a cell
%	% array:
%   fldrRoot = pwd;
%	strPath = pathgen(fldrRoot)
%   lstPath = str2cell(strPath, ';')
%   % This also works
%   cellPath = path
%
%	% Return the full path of the current folder including all classes,
%	% overloaded package directories, and Subversion folders
%	[strPath] = pathgen(fldrRoot, '')
%   lstPath = str2cell(strPath, ';')
%
%   % Return just the directories in cell array format:
%   cellDir = pathgen(fldrRoot, 'IncludeRoot', 0, 'OutputAsCell', 1)
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit pathgen.m">pathgen.m</a>
%	  Driver script: <a href="matlab:edit Driver_pathgen.m">Driver_pathgen.m</a>
%	  Documentation: <a href="matlab:winopen(which('pathgen_Function_Documentation.pptx'));">pathgen_Function_Documentation.pptx</a>
%
% See also str2cell, genpath, path, addpath, rmpath, savepath 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/572
%
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/pathgen.m $
% $Rev: 2977 $
% $Date: 2013-07-23 19:46:47 -0500 (Tue, 23 Jul 2013) $
% $Author: sufanmi $

function [strPath] = pathgen(varargin)

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
[flgRelative, varargin]     = format_varargin('Relative', false, 2, varargin);
[flgOutputAsCell, varargin] = format_varargin('OutputAsCell', false, 2, varargin);
[flgIncludeRoot, varargin]  = format_varargin('IncludeRoot', true, 2, varargin);

num_varargin = size(varargin, 2);
switch(num_varargin)
    case 0
        fldrRoot    = '';
        lstExclude  = {'@';'+';'.svn';'private'};
    case 1
        fldrRoot    = varargin{1};
        lstExclude  = {'@';'+';'.svn';'private'};
    case 2
        fldrRoot    = varargin{1};
        lstExclude  = varargin{2};
 end
 
 if(~iscell(lstExclude))
     lstExclude = {lstExclude};
 end
 
 if(isempty(fldrRoot))
     fldrRoot = pwd;
 end

%% Main Function:
% initialise variables
strPath = '';           % path to be returned

% Generate path based on given root directory
files = dir(fldrRoot);
if isempty(files)
  return
end

% Add fldrRoot to the path even if it is empty.
if(flgIncludeRoot)
    strPath = [strPath fldrRoot pathsep];
end

% set logical vector for subdirectory entries in d
isdir = logical(cat(1,files.isdir));
%
% Recursively descend through directories which are neither
% private nor "class" directories.
%
dirs = files(isdir); % select only directory entries from the current listing

for i=1:length(dirs)
   dirname = dirs(i).name;
   
   flgAdd = 1;
   
   for iExclude = 1:size(lstExclude, 1)
       curExclude = lstExclude{iExclude,:};
       if(~isempty(strfind(dirname, curExclude)))
           flgAdd = 0;
       end 
       if(~isempty(strfind(fullfile(fldrRoot,dirname), curExclude)))
           flgAdd = 0;
       end
   end
   if(strcmp( dirname,'.'))
       flgAdd = 0;
   end
   if(strcmp(dirname, '..'))
       flgAdd = 0;
   end
   
   if(flgAdd)
       strPathRecursive = pathgen(fullfile(fldrRoot, dirname), lstExclude, ...
           'Relative', 0, 'OutputAsCell', 0, 'IncludeRoot', 1);
       
      strPath = [strPath strPathRecursive]; % recursive calling of this function.
   end
end

if(flgRelative)
    strPath = strrep(strPath, [fldrRoot filesep], '');
    strPath = strrep(strPath, [fldrRoot ';'], '');
end

if(flgOutputAsCell)
    cellPath = str2cell(strPath, ';');
    strPath = cellPath;
end

end % << End of function pathgen >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110517 MWS: Added ability to return relative path instead of full path
% 101003 MWS: Created function based on MATLAB's genpath function using
%              CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         : Email                 : NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi

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
