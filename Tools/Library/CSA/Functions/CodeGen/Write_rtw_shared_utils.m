% WRITE_RTW_SHARED_UTILS Rewrites 'rtw_shared_utils.h'
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Write_rtw_shared_utils:
%   This function re-writes the 'rtw_shared_utils.h' for a given folder.
%   When using RTCF with multiple autocoded Simulink blocks, chances are
%   the RTW shared utilities for each block were moved to a co-located
%   software folder.  When each block is autocoded, an 'rtw_shared_utils.h'
%   is automatically created for that particular block.  When multiple
%   blocks are coded and their shared utilies co-located, the
%   'rtw_shared_utils.h' file needs to be updated to include all the shared
%   utilities that exist in the final destination folder.
%
%   This is a supporting function of Write_RTCF_Wrapper.m
%
% SYNTAX:
%	info = Write_rtw_shared_utils(fldrSharedUtils, varargin, 'PropertyName', PropertyValue)
%	info = Write_rtw_shared_utils(fldrSharedUtils, varargin)
%	info = Write_rtw_shared_utils(fldrSharedUtils)
%
% INPUTS:
%	Name           	Size		Units		Description
%	fldrSharedUtils	'string'    [char]      Full path to folder containing
%                                            the RTW Shared utilities
%	varargin        [N/A]		[varies]	Optional function inputs that
%                                            should be entered in pairs.
%                                            See the 'VARARGIN' section
%                                            below for more details
%
% OUTPUTS:
%	Name           	Size		Units		Description
%	info            {struct}
%    .fname         'string'    [char]      Short name of file created
%    .fname_full    'string'    [char]      Full path & name of created file
%    .error         'string'    [char]      Error message on why file was
%                                            not created (if applicable)
%    .OK            'string'    [char]      Message saying file was
%                                            successfully created
%
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'Verbose'           [bool]          true        Show progress of
%                                                    function?
%   'OpenAfterCreated'  [bool]          true        Open the generated
%                                                    files in MATLAB's
%                                                    editor after
%                                                    creation?
%
% EXAMPLES:
%	% Example 1: Re-write the 'rtw_shared_utils.h' file in a sample folder
%   fldrSharedUtils = <Enter Shared Utilities Folder>
%	[] = Write_rtw_shared_utils(fldrSharedUtils)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Write_rtw_shared_utils.m">Write_rtw_shared_utils.m</a>
%	  Driver script: <a href="matlab:edit Driver_Write_rtw_shared_utils.m">Driver_Write_rtw_shared_utils.m</a>
%	  Documentation: <a href="matlab:winopen(which('Write_rtw_shared_utils_Function_Documentation.pptx'));">Write_rtw_shared_utils_Function_Documentation.pptx</a>
%
% See also dir_list, format_varargin
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/761
%
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function info = Write_rtw_shared_utils(fldrSharedUtils, varargin)

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
[OpenAfterCreated, varargin]    = format_varargin('OpenAfterCreated', true,  2, varargin);
[flgVerbose, varargin]          = format_varargin('Verbose', true,  2, varargin);

[strNewModel, varargin]         = format_varargin('NewModel', '',  2, varargin);
[lstNewModelIncludes, varargin] = format_varargin('NewModelIncludes', {},  2, varargin);

%% Main Function:
info.fname = 'rtw_shared_utils.h';
info.fname_full = [fldrSharedUtils filesep info.fname];
flgExist = exist(info.fname_full, 'file');

if(flgExist)
    % Open the file and compile list of used by models
    
    filedata = LoadFile(info.fname_full);
    cellText = str2cell(filedata.Text, endl);
    numLines = size(cellText, 1);
    
    % Pre-process
    lstInclude = {}; iInclude = 0; lstUsedBy = {};
    lstModels = {};
    for iLine = 1:numLines
        curLine = cellText{iLine};
        
        flgInclude = strfind(curLine, '#include');
        if(flgInclude)
            curInclude = strrep(curLine, '#include ', '');
            curInclude = strrep(curInclude, '"', '');
            curInclude = strtrim(curInclude);
            
            iInclude = iInclude + 1;
            lstInclude(iInclude).Include = curInclude;
            lstInclude(iInclude).Start = iLine + 1;
            
            if(iInclude > 1)
                lstInclude(iInclude-1).End = iLine - 1;
            end
        end
        
        flgEndIf = strfind(curLine, '#endif');
        if(flgEndIf)
            lstInclude(iInclude).End = iLine - 1;
        end
    end
    
    numIncludes = size(lstInclude, 2);
    for iInclude = 1:numIncludes
        curInclude = lstInclude(iInclude).Include;
        curStart   = lstInclude(iInclude).Start;
        curEnd     = lstInclude(iInclude).End;
        rawLines   = cellText(curStart:curEnd);
        lstUsedBy = {};
        for iLine = 1:size(rawLines, 1)
            curLine = rawLines{iLine, :};
            curLine = strrep(curLine, '/*', '');
            curLine = strrep(curLine, '*/', '');
            curLine = strtrim(curLine);
            if(~isempty(curLine))
                lstModels = [lstModels; curLine];
                lstUsedBy = [lstUsedBy; curLine];
            end
        end
        lstInclude(iInclude).UsedBy = lstUsedBy;
    end
    
    % Resort Table
    %   Instead of 'UsedBy' models being a function of 'include'...
    %   Have 'include' be a function of 'UsedBy' models
    %    This should catch when a model adds/removes an include
    lstModels = unique(lstModels);
    numModels = size(lstModels, 1);
    for iModel = 1:numModels;
        infoModel(iModel).Model = lstModels{iModel};
        infoModel(iModel).Includes = {};
    end
    
    numIncludes = size(lstInclude, 2);
    for iInclude = 1:numIncludes
        curInclude = lstInclude(iInclude).Include;
        lstUsedBy  = lstInclude(iInclude).UsedBy;
        
        for iUsedBy = 1:size(lstUsedBy,1)
            curUsedBy = lstUsedBy{iUsedBy};
            for iModel = 1:numModels
                if(strcmp(lstModels{iModel},curUsedBy))
                    curIncludes = infoModel(iModel).Includes;
                    curIncludes = [curIncludes; curInclude];
                    infoModel(iModel).Includes = curIncludes;
                end
            end
        end
    end
    
    % Now Compare Against What's just been added
    flgNew = 1;
    for iModel = 1:size(infoModel,1)
        curModel = infoModel(iModel).Model;
        if(strcmp(curModel, strNewModel))
            flgNew = 0;
            % Replace Existing Table
            for iNewInclude = 1:size(lstNewModelIncludes)
                curNewModelInclude = lstNewModelIncludes{iNewInclude};
                [~, curNewIncludeName, curExt] = fileparts(curNewModelInclude);
                curNewModelInclude = [curNewIncludeName curExt];
                lstNewModelIncludes{iNewInclude} = curNewModelInclude;
            end
            infoModel(iModel).Includes = lstNewModelIncludes; 
        end
    end
    
    if(flgNew)
        iModel = size(infoModel,2) + 1;
        infoModel(iModel).Model = strNewModel;
        
        for iNewInclude = 1:size(lstNewModelIncludes)
            curNewModelInclude = lstNewModelIncludes{iNewInclude};
            [~, curNewIncludeName, curExt] = fileparts(curNewModelInclude);
            curNewModelInclude = [curNewIncludeName curExt];
            lstNewModelIncludes{iNewInclude} = curNewModelInclude;
        end
        infoModel(iModel).Includes = lstNewModelIncludes;
    end
    
    % Rebuild Master List of Includes
    lstIncludes = {};
    for iModel = 1:size(infoModel, 2)
        curIncludes = infoModel(iModel).Includes;
        lstIncludes = [lstIncludes; curIncludes];
    end
    lstIncludes = unique(lstIncludes);
    
    %%
    lstInclude = {};
    for iInclude = 1:size(lstIncludes,1)
        curInclude = lstIncludes{iInclude};
        
        lstInclude(iInclude).Include = curInclude;
        lstInclude(iInclude).UsedBy = {};
        
        for iModel = 1:size(infoModel, 2)
            curModel    = infoModel(iModel).Model;
            curIncludes = infoModel(iModel).Includes;
            
            if(any(cell2mat(strfind(curIncludes, curInclude))))
                numUsedBy = size(lstInclude(iInclude).UsedBy, 1);
                iUsedBy = numUsedBy + 1;
                lstInclude(iInclude).UsedBy(iUsedBy,1) = { curModel };
            end
        end
    end
    
else
    % It's new
    lstInclude = {};
    numIncludes = size(lstNewModelIncludes, 1);
    iInclude = 0;
    for iIncludeRaw = 1:numIncludes
        curIncludeRaw = lstNewModelIncludes{iIncludeRaw};
        
        flgIsHFile = strmatch(curIncludeRaw(end-1:end), '.h');
        
        if(flgIsHFile)
            [~, curInclude, curExt] = fileparts(curIncludeRaw);
            iInclude = iInclude + 1;
            lstInclude(iInclude).Include = [curInclude curExt];
            lstInclude(iInclude).UsedBy = { strNewModel };
        end
    end

end


%% Re-write 'rtw_shared_utils.h'
if(1)
    
    %  Rewrite the 'rtw_shared_utils.h' file
    fstr = '';
    fstr = [fstr '#ifndef rtw_shared_utils_h_' endl];
    fstr = [fstr '# define rtw_shared_utils_h_' endl];
    fstr = [fstr endl];
    fstr = [fstr '/* Shared utilities general include header file.*/' endl];
    fstr = [fstr endl];
    
    numIncludes = size(lstInclude, 2);
    for iInclude = 1:numIncludes
        curInclude = lstInclude(iInclude).Include;
        lstUsedBy  = lstInclude(iInclude).UsedBy;
        
        fstr = [fstr '#include "' curInclude '"' endl];
        
        for i = 1:size(lstUsedBy, 1)
            curUsedBy = lstUsedBy{i};
            strUsedBy = ['/* ' curUsedBy ' */'];
            fstr = [fstr strUsedBy endl];
        end
        
        fstr = [fstr endl];
        
    end
    fstr = [fstr '#endif                                 /* rtw_shared_utils_h_ */' endl];
end


[fid, message ] = fopen(info.fname_full, 'wt','native');

if fid == -1
    info.error = [mfnam '>> ERROR: File Not created: ' message];
    disp(info.error)
    return
else %any answer besides 'Y'
    fprintf(fid,'%s',fstr);
    fclose(fid);
    if(OpenAfterCreated)
        edit(info.fname_full);
    end
    info.OK = 'maybe it worked';
    
    if(flgVerbose == 1)
        disp(sprintf('%s : ''%s'' updated in %s', mfnam, info.fname, fldrSharedUtils));
    end
end

end % << End of function Write_rtw_shared_utils >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 120809 <INI>: Created function using CreateNewFunc
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
