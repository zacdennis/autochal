% LISTMFILES Builds contents-style table of MATLAB .m files
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ListMfiles:
%     Builds contents-style table of MATLAB .m files 
% 
% SYNTAX:
%	lstMfiles = ListMfiles(TopLevelFolder, varargin, 'PropertyName', PropertyValue)
%	lstMfiles = ListMfiles(TopLevelFolder, varargin)
%	lstMfiles = ListMfiles(TopLevelFolder)
%	lstMfiles = ListMfiles()
%
% INPUTS: 
%	Name            Size		Units		Description
%   TopLevelFolder  'string'    [char]      Top level folder in which to
%                                            find .m files
%                                            Default: pwd
%	varargin        [N/A]		[varies]	Optional function inputs that
%                                            should be entered in pairs.
%                                            See the 'VARARGIN' section
%                                            below for more details
%
% OUTPUTS: 
%	Name            Size		Units		Description
%   lstMfiles       'string'    [char]      List of found .m files
%
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'BuildContents'     [bool]          true        Build a contents .m file?
%                                                   File will be saved in
%                                                   the 'TopLevelFolder'
%   'ContentsFilename'  'string'        'Contents'  Name of file to write
%   'Verbose'           [bool]          true        Show status of file
%                                                    generation?
%    'DirExclude'       {'strings'}     *see below  Cell array of folders
%                                                   to ignore when 
%                                                   searching for .m files
%
%   Default Ignored Folders: '@', '+', '.svn', 'private', 'DSNEWinds', ...
%                               'ShuttleETR', 'SFunctions', 'glpk'
%   
% EXAMPLES:
%	% Build a 'Contents.m' for the CSA Library
%   TopLevelFolder = fileparts(which('CSA_Library.mdl'));
%
%	ListMfiles(TopLevelFolder)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ListMfiles.m">ListMfiles.m</a>
%	  Driver script: <a href="matlab:edit Driver_ListMfiles.m">Driver_ListMfiles.m</a>
%	  Documentation: <a href="matlab:winopen(which('ListMfiles_Function_Documentation.pptx'));">ListMfiles_Function_Documentation.pptx</a>
%
% See also format_varargin, dir_list, Cell2PaddedStr
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/671
%
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/ListMfiles.m $
% $Rev: 3037 $
% $Date: 2013-10-16 17:41:10 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [lstMfiles] = ListMfiles(TopLevelFolder, varargin)

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
lstDirExclude = {'@';'+';'.svn';'private';'DSNEWinds';'ShuttleETR';'SFunctions';'glpk'};

[BuildContents, varargin]   = format_varargin('BuildContents',    true,       2, varargin);
[ContentsFilename, varargin]= format_varargin('ContentsFilename', 'Contents', 2, varargin);
[flgVerbose, varargin]      = format_varargin('Verbose', true, 2, varargin);
[lstDirExclude, varargin]   = format_varargin('DirExclude', lstDirExclude, 2, varargin);
[WriteToFile, varargin]     = format_varargin('WriteToFile', false, 2, varargin);
[CatalogFilename, varargin] = format_varargin('CatalogFilename', '', 2, varargin);
[OpenAfterWrite, varargin]  = format_varargin('OpenAfterWrite', true, 2, varargin);

if((nargin == 0) || (isempty(TopLevelFolder)))
    TopLevelFolder = pwd;
end

[pathToTopLevelFolder, strTopLevelFolder] = fileparts(TopLevelFolder);

VerifiedCount = 0; % Counter for number of scripts/functions that have been verified

%% Main Code:

fldrRootContents = [TopLevelFolder filesep ContentsFilename '.m'];
[TopLevelPath, TopLevelName] = fileparts(TopLevelFolder);

lst_files = dir_list('*.m', 1, 'Root', TopLevelFolder, ...
    'DirExclude', lstDirExclude);
num_files = size(lst_files, 1);

if(isempty(CatalogFilename))
    CatalogFilename = [TopLevelName '_Mfiles_Catalog.xls'];
end

lst_Contents = {};
ih = 0;
lastFolder = '';

iFunc = 0; lstFunc = {};
iScript = 0; lstScript = {};

for i_file = 1:num_files
    cur_file = lst_files{i_file,:};
    
    if(flgVerbose)
        disp(sprintf('[%d/%d]: Processing %s...', i_file, num_files, cur_file));
    end
    
    [file_full_path, file_short] = fileparts(cur_file);
    fldr_name_rel = strrep(file_full_path, [TopLevelFolder filesep], '');
    file_name_rel = strrep(cur_file, [TopLevelFolder filesep], '');
    
    if(~strcmp(lastFolder, fldr_name_rel))
        if(i_file > 1)
            ih = ih + 1;
        end
        ih = ih + 1;
        ptrSlash = findstr(fldr_name_rel, filesep);
        if(isempty(ptrSlash))
            lst_Contents(ih, 1) = {fldr_name_rel};
        else
            lst_Contents(ih, 1) = {[fldr_name_rel(ptrSlash(end)+1:end) ':']};
            lst_Contents(ih, 2) = {['Parent Directory: ' fldr_name_rel]};
%             lst_Contents(ih, 2) = {['Parent Directory: ' fldr_name_rel(1:ptrSlash(end)-1)]};
        end
        lastFolder = fldr_name_rel;
    end
    
    if(isempty(strfind(file_short, '_old')))
        
        ih = ih + 1;
        lst_Contents(ih, 1) = { ['  ' file_short]};
%         lst_Contents(ih, 4) = { file_name_rel };
        
        flgFunc = isfunction(file_short);
        if(flgFunc)
            iFunc = iFunc + 1;
            lstFunc(iFunc,:) = {cur_file};  % #ok<AGROW>
        else
            if(isempty(strfind(cur_file, 'mex')))
                iScript = iScript + 1;
                lstScript(iScript,:) = {cur_file};  % #ok<AGROW>
            end
        end
        
        strHelp = help(cur_file);
        
        if(isempty(strHelp))
            cellHelp = {''};
        else
            cellHelp = str2cell(strHelp, endl);
        end
        
        strOneLine = cellHelp{1,:};
        
        if(strcmp(cur_file, fldrRootContents))
            strOneLine = [strTopLevelFolder ' Table of Contents (e.g. this file)'];
            strOneLine(1) = upper(strOneLine(1));
            strOneLine = ['- ' strOneLine];
            
            lst_Contents(ih, 2) = { strOneLine };
        else
            
            if(strfind(strOneLine, upper(file_short)))
                % This is good
                strOneLine = strrep(strOneLine, [upper(file_short) ' '], '');
            else
                if(strfind(strOneLine, 'NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I'))
                    strOneLine = 'Function Needs to be CoSMO''d';
                end
                
                if(strfind(strOneLine, '------------------------- UNCLASSIFIED -------------------------'))
                    strOneLine = 'Function Needs to be CoSMO''d';
                end
                
                if(strfind(strOneLine, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'))
                    strOneLine = 'Function Needs to be CoSMO''d';
                end
                
                if(strfind(strOneLine, '#eml'))
                    strOneLine = 'Function Needs to be CoSMO''d';
                end
                
                strOneLine = strrep(strOneLine, 'FUNCTION', '');
                strOneLine = strrep(strOneLine, file_short, '');
            end
            
            
            % Remove any leading/trailing spaces
            strOneLine = strtrim(strOneLine);
            
            if(isempty(strOneLine))
                strOneLine = 'Function Needs to be CoSMO''d';
            else
                strOneLine(1) = upper(strOneLine(1));
                
                % Strip off any periods at end of description
                if(strcmp(strOneLine(end), '.'))
                    strOneLine = strOneLine(1:end-1);
                end
            end
            
            strOneLine = ['- ' strOneLine];
            
            lst_Contents(ih, 2) = { strOneLine };
            
            flgFunction = isfunction(file_short);
            
            lst_Contents(ih, 3) = { bool2str(flgFunction,'(function)','(script)') };
            
            k = strfind(cellHelp, 'Verified:');
            for iv = 1:length(k)
                if k{iv}
                    lst_Contents(ih, 4) = {strtrim(cellHelp{iv,:})};
                    break
                end
                lst_Contents(ih, 4) = {''};
            end
            
            kv = strfind(cellHelp{iv,:}, 'Verified: Yes');
            if(kv)
                VerifiedCount = VerifiedCount + 1;
            end
        end
    end
end

ih = ih + 2;
lst_Contents(ih, 1) = { 'Summary Report' };
ih = ih + 1;
lst_Contents(ih, 1) = {'MATLAB .m Functions:'};
lst_Contents(ih, 2) = {num2str(iFunc)};

ih = ih + 1;
lst_Contents(ih, 1) = {'MATLAB .m Scripts:'};
lst_Contents(ih, 2) = {num2str(iScript)  };

ih = ih + 1;
lst_Contents(ih, 1) = {'MATLAB .m Verified:'};
lst_Contents(ih, 2) = {sprintf('%s (%s%%)', num2str(VerifiedCount), ...
    num2str(VerifiedCount/(iFunc+iScript)*100)) };

ih = ih + 1;
lst_Contents(ih, 1) = {'Auto-generated on:'};
lst_Contents(ih, 2) = { datestr(now, 'ddd, mmm-dd-yyyy') };
ih = ih + 1;
lst_Contents(ih, 1) = {'Auto-generated using:'};
lst_Contents(ih, 2) = {mfnam};

strContents = Cell2PaddedStr(lst_Contents, 'Padding', ' ', 'Prefix', '% ');


[fid, message] = fopen(fldrRootContents,'wt');
fprintf(fid, '%s', strContents);
fclose(fid);
edit(fldrRootContents);

lstMfiles.Functions = lstFunc;
lstMfiles.Scripts = lstScript;

if(WriteToFile)
    CatalogFilenameFull = [TopLevelFolder filesep CatalogFilename];
    [~,~, ext] = fileparts(CatalogFilenameFull);
    if(isempty(ext))
        CatalogFilenameFull = [CatalogFilenameFull '.xlsx'];
    end
    if(exist(CatalogFilenameFull))
        delete(CatalogFilenameFull);
    end
    
    xlswrite(CatalogFilenameFull, lst_Contents);
    if(OpenAfterWrite)
        winopen(CatalogFilenameFull);
    end
end

if(flgVerbose)
    disp(sprintf('%s : Finished!  Contents have been written to: %s', mfilename, fldrRootContents));
end

end % << End of function ListMfiles >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 101221 <INI>: Created function using CreateNewFunc
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
