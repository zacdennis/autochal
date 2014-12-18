% REMOVEDOTSPATH takes current path and removes folders beginning with '.'.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% RemoveDotsPath:
% This function will take the current path and remove the folders in the
% path which begin with a '.'.
% 
% SYNTAX:
%	[cleanpath] = RemoveDotsPath(path_string)
%	[cleanpath] = RemoveDotsPath()
%
% INPUTS: 
%	Name       	Size	Units		Description
%   path_string [1xN]   [ND]        String of Current path with '.' folders 
%					                 If undefined, the path_string is  
%                                    defaulted to path
%
% OUTPUTS: 
%	Name       	Size	Units		Description
%   cleanpath   [1xN]   [ND]        String of Cleaned path without '.' 
%                                   folders
%                                    If left blank, the output is  
%                                    added/overwrites the MATLAB Path
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[cleanpath] = RemoveDotsPath(path_string, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[cleanpath] = RemoveDotsPath(path_string)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
% Book with One Author:
% [2]   Author Last Name, Author First Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
% Book with Two Author:
% [3]   Author #1 Last Name, Author #1 First Name, and Author #2 Full Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit RemoveDotsPath.m">RemoveDotsPath.m</a>
%	  Driver script: <a href="matlab:edit Driver_RemoveDotsPath.m">Driver_RemoveDotsPath.m</a>
%	  Documentation: <a href="matlab:pptOpen('RemoveDotsPath_Function_Documentation.pptx');">RemoveDotsPath_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/463
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/RemoveDotsPath.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [cleanpath] = RemoveDotsPath(path_string, varargin)

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
%% General Header 
% mfnam = mfilename;  %#NOTE: JPG left from original function, prob
%                             removable
cleanpath = '';


%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        path_string= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
switch nargin
	case 0
		% User Wants '\.' folders removed from existing path.
		path_string = path;
	case 1
		% User Wants to return a string with '\.' folders removed from input
        % path_string.
		if ~ischar(path_string)
			errorstr = 'ERROR: Argument must be or type char';
			disp([mfnam '>>' errorstr]);
			return
		end
	otherwise
		errorstr = 'ERROR: Too many input arguments!';
		disp([mfnam '>>' errorstr]);
		return
end
%% Main Function:
%% Setup Slash Direction
if(ispc)
    slsh = '\';
else
    slsh = '/';
end

%% Function Section
% Find location of path separators:
ptrs_pathsep = strfind(path_string,pathsep);
% Correction for first and last path
ptrs_pathsep = [0 ptrs_pathsep length(path_string)]; 

for i = 2:(length(ptrs_pathsep))
	%% Get ptr locations for beginning and end of path additions:
	ptr_start = ptrs_pathsep(i-1) + 1;%ignore actual pathsep
	ptr_end = ptrs_pathsep(i);

	%% Picks off path entry:
	pospath = path_string(ptr_start:ptr_end);

	%% Look at current line for [slash '.']:	
	%% Add match to path if no '.' exists
	if isempty(strfind(pospath,[slsh '.']))
		cleanpath = [cleanpath pospath];
	end
end

%% Output
switch nargout 
	case 0 %User wants output writen to Matlab path
		if nargin % then user want to apend the path
			addpath(cleanpath,'-begin')
		else %User operated on full path and wants it rewritten back to MATLAB
			path(cleanpath);
		end
	case 1
		%user wants the output to do as they please - do nothing
	otherwise
		errorstr = 'ERROR: Too many output arguments';
		disp([mfnam '>>' errorstr]);
		return;
end

%% Compile Outputs:
%	cleanpath= -1;

end % << End of function RemoveDotsPath >>

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
