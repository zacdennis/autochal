% CODECOUNT Counts the lines of code, comments, and blanks in a set of files and/or directories
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% codecount:
%     Counts the lines of code, comments, and blanks in a set of files 
%       and/or directories.  Note that this function is rather rough in
%       implmentation and should NOT replaced the company standard USC code
%       count tool.
%
%     Supported code formats:
%       Matlab .m, Python .py, RTCF .rtdr (python based), C/C++
%       .c/.cpp/.h/.hpp (// comments only)
% 
% SYNTAX:
%	[strListInfo, lstInfo] = codecount(lstFiles)
%
% INPUTS: 
%	Name            Size		Units		Description
%	lstFiles        {'string'}  N/A         Full path of files and or
%                                            directories in which to
%                                            perform the code count
%
% OUTPUTS: 
%	Name            Size		Units		Description
%	strListInfo	    'string'    [char]      Summation table of files and
%                                            code counts in a nicely
%                                            formatted string
%   lstInfo         {struct}    N/A         Code counts for individual files
%
% NOTES:
%	Function use CSA functions: dir_list, Cell2PaddedStr
%
% EXAMPLES:
%	% Example 1: Count a single file
%   lstFiles = which('codecount.m');
%	[strListInfo, lstInfo] = codecount(lstFiles);
%   disp(strListInfo);
%
%   % Example 2: Count a directory
%   % lstFiles = fileparts(mfilename('fullpath'));
%	[strListInfo, lstInfo] = codecount(lstFiles);
%   disp(strListInfo);
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit codecount.m">codecount.m</a>
%	  Driver script: <a href="matlab:edit Driver_codecount.m">Driver_codecount.m</a>
%	  Documentation: <a href="matlab:winopen(which('codecount_Function_Documentation.pptx'));">codecount_Function_Documentation.pptx</a>
%
% See also dir_list, Cell2PaddedStr 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/798
%  
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/codecount.m $
% $Rev: 2931 $
% $Date: 2013-03-27 15:48:43 -0500 (Wed, 27 Mar 2013) $
% $Author: sufanmi $

function [strListInfo, lstInfo] = codecount(lstFiles, varargin)

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
% [lstFileExclude, varargin]  = format_varargin('FileExclude',  '', 2, varargin);

%% Main Function:
if ~iscell(lstFiles)
    lstFilesRaw = { lstFiles };
else
    lstFilesRaw = lstFiles;
end
numFilesRaw = size(lstFilesRaw, 1);
lstFiles = {};
for iFileRaw = 1:numFilesRaw
    curFileRaw = lstFilesRaw{iFileRaw, :};
    if(isdir(curFileRaw))
        lst2add = dir_list('', 1, 'Root', curFileRaw);
        lstFiles = [lstFiles; lst2add];
    else
        lstFiles = [lstFiles; curFileRaw];
    end
end

numHeaders = 1;
numFiles = size(lstFiles, 1);
lstInfo = cell(numFiles+numHeaders+1,4);
lstInfo(1,1:4) = {'Filename', 'Comments', 'Blanks', 'Code'};

totalComment = 0;
totalBlank = 0;
totalCode = 0;

for iFile = 1:numFiles
    curFile = lstFiles{iFile, :};

    [pathstr, name, ext] = fileparts(curFile);
    
    switch ext
        case '.m'
            strComment = '%';
            strCommentMulti = {};
        case {'.rtdr', '.py'}
            strComment = '#';
            strCommentMulti = {};
        case {'.c', '.cpp', '.h', '.hpp'} 
            strComment = '//';
            strCommentMulti = {'/*', '*/'}; % <-- not yet supported
    end

    numComment  = 0;
    numBlank    = 0;
    numCode     = 0;
    
    % Open the file and loop through them:
    fidorig = fopen(curFile);
    
    while 1
        curLine = fgetl(fidorig);
        if ~ischar(curLine)
            break
        else
            curLine = strtrim(curLine);
            
            if(length(curLine) == 0)
                numBlank = numBlank + 1;
            else
                if(strcmp(curLine(1:length(strComment)), strComment))
                    numComment = numComment + 1;
                else
                    numCode = numCode + 1;
                end
            end
        end
    end
    fclose(fidorig);
    
    % Record Data on File
    info(iFile).Filename = curFile;
    info(iFile).Comments = numComment;
    info(iFile).Blanks   = numBlank;
    info(iFile).Code     = numCode;
    
    totalComment = totalComment + numComment;
    totalBlank = totalBlank + numBlank;
    totalCode = totalCode + numCode;
    
    lstInfo(iFile+numHeaders,1) = { curFile };
    lstInfo(iFile+numHeaders,2) = { numComment };
    lstInfo(iFile+numHeaders,3) = { numBlank };
    lstInfo(iFile+numHeaders,4) = { numCode };
    
end

lstInfo(iFile+numHeaders+1,1) = { 'Totals' };
lstInfo(iFile+numHeaders+1,2) = { totalComment };
lstInfo(iFile+numHeaders+1,3) = { totalBlank };
lstInfo(iFile+numHeaders+1,4) = { totalCode };

strListInfo = Cell2PaddedStr(lstInfo, 'Padding', '  ');


end % << End of function codecount >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 130327 <INI>: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName            : Email     : NGGN Username 
% <initials>: <Fullname>   : <email>   : <NGGN username> 

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
