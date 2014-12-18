% CONVERT2FSTR Formats a file for use within a user developed function
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% convert2fstr:
%     This is a utility script that will help users developing their own
%     functions or scripts that involve snippets of other files.  In many
%     cases, a function will auto-build another file or function by first
%     creating a string (e.g. 'fstr') and then by appending as many lines
%     as needed until the script is complete.  This function will open any
%     text based file and place comments about the code so that the coder
%     can then cherry-pick the desired lines of code for their new function
%     with the added benefit of that code being already nicely formatted.
% 
% SYNTAX:
%	[filename_m] = convert2fstr(filename_x, varargin, 'PropertyName', PropertyValue)
%	[filename_m] = convert2fstr(filename_x, varargin)
%	[filename_m] = convert2fstr(filename_x)
%
% INPUTS: 
%	Name      	Size		Units		Description
%	filename_x	'string'    [char]      Name of file to convert
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	filename_m	'string'    [char]      Name of created m-file (full path)
%
% NOTES:
%   The name of the newly created, converted file (filename_m) will be
%   named the same as the orginal file (filename_x), except the extension
%   will be '.m'.  If the file to be converted is already a MATLAB .m file,
%   it will be named [filename_m '_converted.m'], as shown in the example
%   below.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   SaveFolder          'string'        pwd         Folder in which to
%                                                   create converted file
%   OpenAfterCreated    [bool]          false       Open new converted file?
%   StrRoot             'string'        'fstr'      Local variable to use
%                                                   for function string
%
% EXAMPLES:
%   % Example 1: Format a simple .m file for use with a function
%   % Step 1: Create the m file
%   endl = sprintf('\n');   % Line Return
%   strFilename = 'test.m';
%   str = ['%% Debugging & Display Utilities:' endl ...
%         'spc  = sprintf('' '');                                % One Single Space' endl ...
%         'tab  = sprintf(''\t'');                               % One Tab' endl ...
%         'endl = sprintf(''\n'');                               % Line Return' endl ...
%         '[mfpath,mfnam] = fileparts(mfilename(''fullpath''));  % Full Path to Function, Name of Function' endl ...
%         'mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name' endl];
%   fid = fopen(strFilename, 'w');
%   fprintf(fid,'%s', str);
%   fclose(fid);
%   edit(strFilename);
%
%   % Step 2: Format the file for use with a function
%	[filename_m] = convert2fstr(strFilename, 'OpenAfterCreated', 1)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit convert2fstr.m">convert2fstr.m</a>
%	  Driver script: <a href="matlab:edit Driver_convert2fstr.m">Driver_convert2fstr.m</a>
%	  Documentation: <a href="matlab:pptOpen('convert2fstr_Function_Documentation.pptx');">convert2fstr_Function_Documentation.pptx</a>
%
% See also format_varargin 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/699
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoSMO_Utilities/convert2fstr.m $
% $Rev: 1733 $
% $Date: 2011-05-16 19:49:20 -0500 (Mon, 16 May 2011) $
% $Author: sufanmi $

function [filename_m] = convert2fstr(filename_x, varargin)

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
[SaveFolder, varargin]          = format_varargin('SaveFolder', '',  2, varargin);
[OpenAfterCreated, varargin]    = format_varargin('OpenAfterCreated', false,  2, varargin);
[str_fstr, varargin]            = format_varargin('StrRoot', 'fstr',  2, varargin);

%% Main Function:
str= '';
filename_x = which(filename_x);
[pathstr, name, ext] = fileparts(filename_x);
if(isempty(SaveFolder))
    SaveFolder = pathstr;
end
if(strcmp(ext, '.m'))
   filename_m = [SaveFolder filesep name '_converted.m'];
else
    filename_m = [SaveFolder filesep name '.m'];
end
    
strPrefix = [str_fstr ' = [' str_fstr ' '''];
strSuffix = ''' endl];';

if(~isempty(filename_x))
    
    % Open the file and loop through them:
    fid = fopen(filename_x);
    
    % Read in the entire file, note that this could get huge but was done this
    % way so that you could do multi-line searches
    while 1
        tlineo = fgetl(fid);
        if ~ischar(tlineo)
            break
        end
        
        tlineo = strrep(tlineo, '''', '''''');
        str = [str strPrefix tlineo strSuffix endl]; %#okAGROW
    end
    fclose(fid);
end

info.fname_full = filename_m;
info.text = str;
[fid, message ] = fopen(info.fname_full, 'wt','native');

if fid == -1
    info.error = [mfnam '>> ERROR: File Not created: ' message];
    disp(info.error)
    return
else %any answer besides 'Y'
    fprintf(fid,'%s',str);
    fclose(fid);
    if(OpenAfterCreated)
        edit(info.fname_full);
    end
    info.OK = 'maybe it worked';
end

end % << End of function convert2fstr >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110516 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
