% COPYFILES Copies a list of files to a destination folder
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% copyfiles:
%     Copies a list of files to a destination folder 
% 
% SYNTAX:
%	[lstLog] = copyfiles(lstFiles, destination, 'PropertyName', PropertyValue)
%	[lstLog] = copyfiles(lstFiles, destination, varargin)
%	[lstLog] = copyfiles(lstFiles, destination)
%
% INPUTS: 
%	Name        	Size		Units		Description
%   lstFiles        {'string'}  [char]      List of files to copy
%   destination     'string'    [char]      Full path to destination folder
%
% OUTPUTS: 
%	Name        	Size		Units		Description
%	lstLog 	        {'string'}  [char]      If 'LogFormat' is...
%                                            'ListNew', filenames of newly
%                                                       created files
%                                            'Detailed', old and new
%                                                       filenames
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'SourceFolder'      'string'        pwd         Source folder of files
%   'minbytes'          [int]           0           Minimum filesize for
%                                                   files to copy (prevents
%                                                   blank files from being
%                                                   copied)
%   'Verbose'           [bool]          1           Show details of copy?
%   'CollapseFolders'   [bool]          0           Maintain subfolder
%                                                   structure during copy?
%   'LogFormat'         'string'        'ListNew'   Log Formatting type
%                                                   'ListNew': shows only
%                                                   names of new files
%                                                   'Detailed': shows
%                                                   old and new filenames
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[Out] = copyfiles(lstFiles, destination, varargin)
%	% <Copy expected outputs from Command Window>
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit copyfiles.m">copyfiles.m</a>
%	  Driver script: <a href="matlab:edit Driver_copyfiles.m">Driver_copyfiles.m</a>
%	  Documentation: <a href="matlab:pptOpen('copyfiles_Function_Documentation.pptx');">copyfiles_Function_Documentation.pptx</a>
%
% See also format_varargin 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/440
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/copyfiles.m $
% $Rev: 2213 $
% $Date: 2011-09-23 19:22:47 -0500 (Fri, 23 Sep 2011) $
% $Author: sufanmi $

function [lstLog] = copyfiles(lstFiles, destination, varargin)

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
[sourcefolder, varargin]  = format_varargin('SourceFolder', '', 2, varargin);
[minbytes, varargin]  = format_varargin('MinBytes', 0, 2, varargin);
[flgVerbose, varargin]  = format_varargin('Verbose', 1, 2, varargin);
[flgCollapseFolders, varargin]  = format_varargin('CollapseFolders', 0, 2, varargin);
[logFormat, varargin]  = format_varargin('LogFormat', 'ListNew', 2, varargin);

minbytes = round(minbytes);
minbytes = max(minbytes, 0);

if(~isdir(destination))
    if(flgVerbose)
        disp(sprintf('%s : Folder ''%s'' does not exist.  Creating...', ...
            mfilename, destination));
    end
    mkdir(destination);
end

if(ischar(lstFiles))
    lstFiles = { lstFiles };
end

numfiles = size(lstFiles,1);
iLog = 0; lstLog = {};
for ifiles = 1:numfiles
    file2move = lstFiles{ifiles,:};
    
    if(~isempty(sourcefolder))
        if(isempty(strfind(file2move, sourcefolder)))
            origin = [sourcefolder filesep file2move];
        else
            origin = file2move;
        end
    else
        origin = file2move;
    end
    
    if(~isempty(ls(origin)))
        fileinfo = dir(origin);
        if(fileinfo.bytes > minbytes)   
            
            if(flgCollapseFolders)          
                [pathstr, name, ext] = fileparts(origin);
                destination_filename = [destination filesep name ext];
            else
                destination_filename = strrep(origin, sourcefolder, destination);
            end
            
            try
                destination_folder = strrep(destination_filename, fileinfo.name, '');
                if(~isdir(destination_folder))
                    mkdir(destination_folder);
                end
                
                copyfile(origin, destination_filename,'f');
                
                iLog = iLog + 1;
                
                switch lower(logFormat)
                    case 'detailed'
                        
                        strLog = sprintf('%s : [%d/%d] : Copied ''%s'' to ''%s''', mfilename, ...
                            ifiles, numfiles, file2move, destination_folder);
                        
                    case 'listnew'
                        strLog = destination_filename;
                end
                    
                lstLog(iLog,:) = {strLog };
                
                if(flgVerbose)
                    disp(strLog);
                end
                
             catch
               disp(sprintf('%s : Error Copying %s', mfnam, origin)); 
            end
            
        end
    end
end


end % << End of function copyfiles >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
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
