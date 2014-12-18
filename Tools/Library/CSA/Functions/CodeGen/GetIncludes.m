% GETINCLUDES Build list of .c/.h files included by a given list
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GetIncludes:
%     This function builds a list of .c/.h files that are referenced (e.g.
%     #include) by a set of .c/.h files.  Given an initial set of files,
%     this function will cycle through each file looking for any '#include'
%     tags.  If a referenced file is found, that file will then be
%     interogated for additional include files.  Plugs have also been
%     inserted to search only in a specified set of folders.
%
% SYNTAX:
%	[lstIncludes] = GetIncludes(lstFiles, lstAdditionalFldrs, flgUseOnlyAdditionalFldrs)
%	[lstIncludes] = GetIncludes(lstFiles, lstAdditionalFldrs)
%	[lstIncludes] = GetIncludes(lstFiles)
%
% INPUTS:
%	Name                Size		Units   Description
%	lstFiles            {'string'}          Starting list of files to
%                                            perform '#include' search on
%   lstAdditionalFldrs  {'string'}          Additional folders (not
%                                            currently on MATLAB path) in
%                                            which to search for files
%                                            Optional: Default is {}
%   flgUseOnlyAdditionalFldrs [1]   bool    Only search for include files
%                                            in 'lstAdditionalFldrs'?
%                                            Optional: Default is 0 (false)
%
% OUTPUTS:
%	Name                Size		Units    Description
%	lstIncludes         {'string'}           Full paths to files that were
%                                             referenced by files in
%                                             'lstFiles'
% NOTES:
%   This function was originally created to find Simulink 'include' files
%   that are referenced in an autocoded <Model>.h file.  These 'include'
%   files are normally located in: [matlabroot  '\simulink\include']
%   (e.g. C:\Program Files\MATLAB\R2010a\simulink)
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[lstIncludes] = GetIncludes(lstFiles, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit GetIncludes.m">GetIncludes.m</a>
%	  Driver script: <a href="matlab:edit Driver_GetIncludes.m">Driver_GetIncludes.m</a>
%	  Documentation: <a href="matlab:winopen(which('GetIncludes_Function_Documentation.pptx'));">GetIncludes_Function_Documentation.pptx</a>
%
% See also <add relevant functions>
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/735
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CodeGen/GetIncludes.m $
% $Rev: 2265 $
% $Date: 2011-11-22 16:34:53 -0600 (Tue, 22 Nov 2011) $
% $Author: sufanmi $

function [lstIncludes] = GetIncludes(lstFiles, lstAdditionalFldrs, flgUseOnlyAdditionalFldrs)

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

if((nargin < 3) || isempty(flgUseOnlyAdditionalFldrs))
    flgUseOnlyAdditionalFldrs = 0;
end

if(nargin < 2)
    lstAdditionalFldrs = {};
end

if(~iscell(lstFiles))
    lstFiles = { lstFiles };
end

iInclude = 0; lstIncludes = {};

%% Main Function:
for i = 1:size(lstAdditionalFldrs, 1)
    addpath(lstAdditionalFldrs{i}, '-end');
end

numFiles = size(lstFiles, 1);
for iFile = 1:numFiles
    curFile = lstFiles{iFile, :};
    if(exist(curFile) ~= 2)
        curFile = which(curFile);
    end
    
    
    filedata = LoadFile(curFile);
%     filedata = editorservices.open(curFile);
    cellText = str2cell(filedata.Text, endl);
%     filedata.close;
    
    % Find all instances of desired string
    arrMatch = strfind(cellText, '#include');
    
    for iLine = 1:size(arrMatch)
        flgMatch = arrMatch{iLine};
        if(~isempty(flgMatch))
            curLine = cellText{iLine,:};
            flg_MATLAB_file = strfind(curLine, '"');
            if(~isempty(flg_MATLAB_file))
                curInclude = curLine;
                curInclude = strrep(curInclude, '#include ', '');
                curInclude = strrep(curInclude, '"', '');
                
                if(flgUseOnlyAdditionalFldrs)
                   for i = 1:size(lstAdditionalFldrs, 1)
                       curFldr = lstAdditionalFldrs{i,:};
                       curFile = [curFldr filesep curInclude];
                       if(exist(curFile) == 2)
                           iInclude = iInclude + 1;
                           lstIncludes(iInclude,:) = { curFile };
                           break;
                       end
                   end

                else
                    
                    % Figure out full filename:
                    curIncludeFull = which(curInclude);
                    
                    if(isempty(curIncludeFull))
                        curIncludeFull = ['Full Path for ''' curInclude ''' missing'];
                    end
                    
                    iInclude = iInclude + 1;
                lstIncludes(iInclude,:) = { curIncludeFull };
                    
                end
                
                
            end
        end
    end
end

%% Main Function:
for i = 1:size(lstAdditionalFldrs, 1)
    rmpath(lstAdditionalFldrs{i});
end

end % << End of function GetIncludes >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 111102 <INI>: Created function using CreateNewFunc
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
