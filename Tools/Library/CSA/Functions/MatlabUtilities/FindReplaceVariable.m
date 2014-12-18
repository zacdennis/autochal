% FINDREPLACEVARIABLE Find and Replace Workspace Variables used in MATLAB .m files and Simulink models
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% FindReplaceVariable:
%     Finds and replaces workspace variables used in MATLAB .m files and
%     Simulink models
%
% SYNTAX:
%	[Report] = FindReplaceVariable(RootDir, lstFindReplace, varargin, 'PropertyName', PropertyValue)
%	[Report] = FindReplaceVariable(RootDir, lstFindReplace, varargin)
%	[Report] = FindReplaceVariable(RootDir, lstFindReplace)
%
% INPUTS:
%	Name          	Size		Units		Description
%	RootDir         'string'    [char]      Top-Level Directory
%	lstFindReplace	{n x 2}     [char]      Cell array list of find and
%                                            replace variables
%                                           (:, 1) - Find
%                                           (:, 2) - Replace
%	varargin        [N/A]		[varies]	Optional function inputs that
%                                            should be entered in pairs.
%                                            See the 'VARARGIN' section
%                                            below for more details
%
% OUTPUTS:
%	Name          	Size		Units		Description
%   Report          struct      N/A         Report of file(s) and model(s)
%                                            containing workspace variables
%                                            of interest
%
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'DirExclude'        {'string'}      {'.svn';'private'}  String or cell
%                                                   array of keywords to
%                                                   exclude when searching
%                                                   directories
%   'AllowReplace'      [bool]          false       All function perform
%                                                    the find/replace?
%   'SearchMFiles'      [bool]          true        Run .m file search
%                                                    section?
%   'SearchModels'      [bool]          true        Run Simulink model
%                                                    search section?
%   'UseUserModels'     [bool]          false       Use User provided
%                                                    Simulink model list?
%   'UserModels'        {'string'}      {}          User provided Simulink
%                                                    model list
%   'WriteReport'       [bool]          true        Write a report of what
%                                                    was found to Excel?
%   'ReportFilename'    'string'        Note1       Full filename of report
%   'OpenReport'        [bool]          true        Open Report after
%                                                    completion?
%
%   Note1: Default 'ReportFilename' is [pwd filesep 'FindReplaceReport.xlsx']
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[Report] = FindReplaceVariable(RootDir, lstFindReplace, varargin)
%	% <Copy expected outputs from Command Window>
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit FindReplaceVariable.m">FindReplaceVariable.m</a>
%	  Driver script: <a href="matlab:edit Driver_FindReplaceVariable.m">Driver_FindReplaceVariable.m</a>
%	  Documentation: <a href="matlab:winopen(which('FindReplaceVariable_Function_Documentation.pptx'));">FindReplaceVariable_Function_Documentation.pptx</a>
%
% See also dir_list, spaces, txtReplace
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/862
%
% Copyright Northrop Grumman Corp 2014
% Maintained by: Aerospace Systems
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/FindReplaceVariable.m $
% $Rev: 3295 $
% $Date: 2014-10-28 18:13:14 -0500 (Tue, 28 Oct 2014) $
% $Author: sufanmi $

function [Report] = FindReplaceVariable(RootDir, lstFindReplace, varargin)

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

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[lstDirExclude, varargin]   = format_varargin('DirExclude',  {'.svn';'private'}, 2, varargin);
[flgAllowReplace, varargin] = format_varargin('AllowReplace',  false, 2, varargin);
[SearchMFiles, varargin]    = format_varargin('SearchMFiles',  true, 2, varargin);
[SearchModels, varargin]    = format_varargin('SearchModels',  true, 2, varargin);
[UseUserModels, varargin]   = format_varargin('UseUserModels', false, 2, varargin);
[lstUserModels, varargin]   = format_varargin('UserModels',  {}, 2, varargin);
[WriteReport, varargin]     = format_varargin('WriteReport',  true, 2, varargin);
[ReportFilename, varargin]  = format_varargin('ReportFilename',  [pwd filesep 'FindReplaceReport.xlsx'], 2, varargin);
[OpenReport, varargin]      = format_varargin('OpenReport',  true, 2, varargin);

if(~iscell(lstUserModels))
    lstUserModels = { lstUserModels };
end

%% Main Function:
nFindReplace = size(lstFindReplace, 1);

%%
if(SearchMFiles)
    disp(sprintf('%s : Searching for all .m files under ''%s''...', ...
        mfilename, RootDir));
    lstFiles = dir_list('*.m', 1, 'Root', RootDir, 'DirExclude', lstDirExclude);
    nFiles = size(lstFiles, 1);
    disp(sprintf('%s : Found %d files under ''%s''...', ...
        mfilename, nFiles, RootDir));
    Report = txtReplace(lstFiles, lstFindReplace, 'ReportOnly', ~flgAllowReplace);
    
else
    Report = {};
    for iFindReplace = 1:nFindReplace
        Report(iFindReplace).Find = lstFindReplace{iFindReplace, 1};
        Report(iFindReplace).File = {};
        Report(iFindReplace).Lines = [];
    end
end

%%
if(SearchModels)
    if(UseUserModels)
        lstModels = lstUserModels;
    else
        lstModels = dir_list({'*.mdl';'*.slx'}, 1, 'Root', RootDir, 'DirExclude', lstDirExclude);
    end
    
    numModels = size(lstModels, 1);
    
    for iModel = 1:numModels
        curModel = lstModels{iModel};
        
        ptrSlash = strfind(curModel, filesep);
        if(~isempty(ptrSlash))
            curModelShort = curModel(ptrSlash(end)+1:end);
        else
            curModelShort = [curModel '.mdl'];
        end
        
        flgSave = 0; nChanges = 0;
        
        strPlural = '';
        if(nFindReplace > 1)
            strPlural = 's';
        end
        disp(sprintf('%s : [%d/%d] : Searching %s for %d Variable%s of Interest...', ...
            mfilename, iModel, numModels, curModelShort, nFindReplace, strPlural));
        
        lstReport = ViewValues(1, curModel, 'ReportOnly', 1, 'Verbose', 0);
        
        lstShow = lstReport.Show;
        numShow = size(lstShow, 1);
        for iShow = 1:numShow
            curBlock = lstShow(iShow);
            
            for iFindReplace = 1:nFindReplace
                curFind = lstFindReplace{iFindReplace, 1};
                
                if( ~isempty(strfind(curBlock.Expression, curFind)) )
                    
                    if(~isfield(Report(iFindReplace), 'Block') )
                        Report(iFindReplace).Block = {};
                    end
                    i_nb = size(Report(iFindReplace).Block, 2) + 1;
                    Report(iFindReplace).Block(i_nb).Model     = curModelShort;
                    Report(iFindReplace).Block(i_nb).Block     = curBlock.Block;
                    Report(iFindReplace).Block(i_nb).BlockType = curBlock.BlockType;
                    Report(iFindReplace).Block(i_nb).Variable  = curBlock.Variable;
                    Report(iFindReplace).Block(i_nb).Expression= curBlock.Expression;
                    
                    if(flgAllowReplace)
                        curReplace = lstFindReplace{iFindReplace, 2};
                        curExpression = curBlock.Expression;
                        curExpression = strrep(curExpression, curFind, curReplace);
                        set_param(curBlock.Block, curBlock.Variable, curExpression);
                        
                        disp(sprintf('%s : Changing block ''%s''...', ...
                            mfilename, curBlock.Block));
                        disp(sprintf('%s   Replacing ''%s'' with ''%s''...', ...
                            spaces(length(mfilename)), curFind, curReplace));
                        
                        flgSave = 1;
                        nChanges = nChanges + 1;
                    end
                    
                end
            end
        end
        if(flgSave)
            disp(sprintf('%s : Saving ''%s'' since %d parameters were changed.', ...
                mfilename, curModel, nChanges));
            save_system(curModel);
            
            open_system(curModel);
        end
    end
end

%% Now write the actual Report
if(WriteReport)
    xlsFilename = ReportFilename;
    
    tbl = {}; irow = 0;
    irow = irow + 1; tbl(irow,1:5) = {'#';'#';'Find String'; 'File'; 'Line # or Block Path'};
    
    for iFindReplace = 1:nFindReplace
        ictr = 0;
        curFind = lstFindReplace{iFindReplace, 1};
        curReport = Report(iFindReplace);
        
        nFiles = size(curReport.File, 2);
        for iFile = 1:nFiles
            curFile = curReport.File(iFile);
            ictr = ictr + 1;
            irow = irow + 1;
            tbl(irow, 1) = { iFindReplace };
            tbl(irow, 2) = { ictr };
            tbl(irow, 3) = { curFind };
            tbl(irow, 4) = { strrep(curFile.Filename, [RootDir filesep], '') };
            tbl(irow, 5) = { sprintf('[%s]', num2str(curFile.Lines)) };
        end
        
        nBlocks = size(curReport.Block, 2);
        for iBlock = 1:nBlocks
            curBlock = curReport.Block(iBlock);
            ictr = ictr + 1;
            irow = irow + 1;
            tbl(irow, 1) = { iFindReplace };
            tbl(irow, 2) = { ictr };
            tbl(irow, 3) = { curFind };
            tbl(irow, 4) = { curBlock.Model };
            tbl(irow, 5) = { curBlock.Block };
        end
    end
    
    xlswrite(xlsFilename, tbl);
    if(OpenReport)
        winopen(xlsFilename);
    end
end

end % << End of function >>

%% DISTRIBUTION:
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C., Sec 2751,
%   et seq.) or the Export Administration Act of 1979 (Title 50, U.S.C.,
%   App. 2401 et set.), as amended. Violations of these export laws are
%   subject to severe criminal penalties.  Disseminate in accordance with
%   provisions of DoD Direction 5230.25.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
