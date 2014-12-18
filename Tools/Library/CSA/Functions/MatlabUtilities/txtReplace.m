% TXTREPLACE Performs find/replace all on textfiles
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% txtReplace:
%   Performs find/replace all on textfiles
%
% SYNTAX:
%   Method #1 (Find/Replace specified in different strings or nx1 cell arrays):
%	[Report, lstReplaced] = txtReplace(txtfile, strFind, strReplace, varargin, 'PropertyName', PropertyValue)
%	[Report, lstReplaced] = txtReplace(txtfile, strFind, strReplace, varargin)
%	[Report, lstReplaced] = txtReplace(txtfile, strFind, strReplace)
%
%   Method #2 (Find/Replace specified in one nx2 cell array):
%	[Report, lstReplaced] = txtReplace(txtfile, lstFindReplace, varargin, 'PropertyName', PropertyValue)
%	[Report, lstReplaced] = txtReplace(txtfile, lstFindReplace, varargin)
%	[Report, lstReplaced] = txtReplace(txtfile, lstFindReplace)
%
% INPUTS:
%	Name       	Size                    Units		Description
%	txtfile	    'string' or {'strings'} N/A         File(s) to perform find
%                                                    and replace all on
%
%   Method #1:
%	strFind	    'string'                [char]      String(s) to look for
%                or {n x 1}
%	strReplace	'string'                [char]      New string(s) to use
%                or {n x 1}                          for overwrite
%
%   Method #2:
%   lstReplace  {n x 2}                 [char]      Cell array of find /
%                                                    replace combos
% 
%	varargin	[N/A]                   [varies]	Optional function inputs that
%                                                   should be entered in pairs.
%                                                   See the 'VARARGIN' section
%                                                    below for more details
% OUTPUTS:
%	Name        Size                    Units		Description
%   Report      struct                  N/A         Report of file(s)
%                                                    containing
%                                                    find/replace sections
%                                                    and their associated
%                                                    line(s)
%	lstReplaced	{'string'}              N/A         List of Find/Replaces
%
% NOTES:
%   There multiple ways to use this function:
%
%	VARARGIN PROPERTIES:
%	PropertyName            PropertyValue	Default		Description
%   OpenAfterEdit           [bool]          false       Open the file(s)
%                                                       after they've been
%                                                       edited?
%   CellMode                [bool]          false       Assume file is a
%                                                       MATLAB function and
%                                                       edit complete cell
%                                                       (e.g. look for %%)?
%   ReplaceWholeLine        [bool]          false       Replace the entire
%                                                       line instead of
%                                                       doing a
%                                                       find/replace? Only
%                                                       works when CellMode
%                                                       is false.
%   ReportOnly              [bool]          false       Only output report?
%   Report                     {cell array}    {}          Report File to append
%   Verbose                 [bool]          true        Show function
%                                                        working
%
%   Option 1: Use this for a single file with a single find/replace pair
%   txtReplace('MyFile.txt', 'LookForThis', 'ReplaceWithThis')
%
%   Option 2: Use this for multiple files and/or multiple find/replace
%   pairs where the Find and Replaces are provided as individual cell
%   arrays of strings.
%   lstFiles    = {'File1.txt'; 'File2.txt'}
%   lstFind     = {'Find1';     'Find2'}
%   lstReplace  = {'Replace1';  'Replace2'}
%   txtReplace(lstFiles, lstFind, lstReplace}
%
%   Option 3: Use this for multiple files and/or multiple find/replace
%   pairs where the Find and Replaces are provided as a single cell array
%   of strings
%   lstFiles        = {'File1.txt'; 'File2.txt'}
%   lstFindReplace  = {'Find1'  'Replace1';
%                      'Find2'  'Replace2'}
%   txtReplace(lstFiles, lstFindReplace}
%
% EXAMPLES:
%   % Example #1:
%   %   Create a file with data to alter
%   strFunc = 'foo';
%   if(exist(strFunc) == 2)
%     delete(which(strFunc));
%   end
%   CreateNewFunc(strFunc, 3, 2);
%
%   % Example #1.1: Single Find/Replace
%   %   Find 'Out1' and replace with 'Output1'
%   %   Multiple Ways:
%   [Report, lstReplaced] = txtReplace(strFunc, 'Out1', 'Output1')
%   [Report, lstReplaced] = txtReplace(strFunc, {'Out1', 'Output1'})
%
%   % Example #1.2: Multiple Find/Replace
%   %   Find 'Out1' and replace with 'Output1'
%   %   Find 'Out2' and replace with 'Output2'
%   lstFindReplace = {...
%           'Out1'     'Output1';
%           'Out2'     'Output2';
%           };
%   [Report, lstReplaced] = txtReplace(strFunc, lstFindReplace)
%
%   % Example #1.3: Only Generate the Report (Don't actually change anything)
%   [Report, lstReplaced] = txtReplace(strFunc, lstFindReplace, 'ReportOnly', true)
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit txtReplace.m">txtReplace.m</a>
%	  Driver script: <a href="matlab:edit Driver_txtReplace.m">Driver_txtReplace.m</a>
%	  Documentation: <a href="matlab:winopen(which('txtReplace_Function_Documentation.pptx'));">txtReplace_Function_Documentation.pptx</a>
%
% See also str2cell, spaces
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/469
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21)
%                Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/txtReplace.m $
% $Rev: 3296 $
% $Date: 2014-10-30 14:50:35 -0500 (Thu, 30 Oct 2014) $
% $Author: sufanmi $

function [Report, lstReplaced] = txtReplace(txtfile, varargin)

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
[OpenAfterEdit, varargin]       = format_varargin('OpenAfterEdit', false, 2, varargin);
[CellMode, varargin]            = format_varargin('CellMode', false, 2, varargin);
[ReplaceWholeLine, varargin]    = format_varargin('ReplaceWholeLine', false, 2, varargin);
[ReportOnly, varargin]          = format_varargin('ReportOnly', false, 2, varargin);
[Report, varargin]              = format_varargin('Report', {}, 2, varargin);
[flgVerbose, varargin]          = format_varargin('Verbose', true, 2, varargin);

nvarargin = size(varargin, 2);
if(nvarargin == 1)
    lstFindReplace = varargin{1};
elseif(nvarargin == 2)
    lstFind     = varargin{1};
    if(~iscell(lstFind))
        lstFind = { lstFind };
    end
    
    lstReplace  = varargin{2};
    if(~iscell(lstReplace))
        lstReplace = { lstReplace };
    end
    lstFindReplace = [lstFind lstReplace];
end

%% Construct temporary file:
warning off MATLAB:DELETE:Permission

if(~iscell(txtfile))
    lstTextfiles = {txtfile};
else
    lstTextfiles = txtfile;
end

numFindReplace = size(lstFindReplace, 1);
numReplaced = 0;
lstReplaced = {};
iMaster = 0;

numFiles = size(lstTextfiles, 1);
for iFile = 1:numFiles
    curFile = lstTextfiles{iFile, :};
    if(flgVerbose)
        disp(sprintf('%s : [%d/%d] : Processing ''%s''...', ...
            mfilename, iFile, numFiles, curFile));
    end
    
    % Open the file and loop through them:
    fidorig = fopen(curFile);
    
    % Read in the entire file, note that this could get huge but was done this
    % way so that you could do multi-line searches
    endl = sprintf('\n');
    strFileOrig = '';
    while 1
        tlineo = fgetl(fidorig);
        if ~ischar(tlineo)
            break
        end
        strFileOrig = [strFileOrig tlineo endl]; %#okAGROW
    end
    fclose(fidorig);
    
    % Loop through all the different find/replaces and do the swap
    strFileNew = strFileOrig;
    numChangesToFile = 0;
    
    for iFindReplace = 1:numFindReplace
        str2lookfor     = lstFindReplace{iFindReplace, 1};
        str2useinstead  = lstFindReplace{iFindReplace, 2};
        
        % Figure out how many instances we're replacing
        ptrMatches  = strfind(strFileNew, str2lookfor);
        numFound    = length(ptrMatches);
        if(numFound == 0)
            arrLines = [];
        else
            ptrEndl     = strfind(strFileNew, endl);
            arrLines    = ceil(interp1(ptrEndl, [1:length(ptrEndl)], ptrMatches));
        end
        
        if(numFound > 0)
            Report(iFindReplace).Find = str2lookfor;
            if( ~isfield(Report(iFindReplace), 'File') )
                Report(iFindReplace).File = {};
            end
            i_nf = size(Report(iFindReplace).File, 1) + 1;
            Report(iFindReplace).File(i_nf).Filename   = curFile;
            Report(iFindReplace).File(i_nf).Lines      = arrLines;
        end
        
        if(~ReportOnly)
            iCellChange = 0;
            if(CellMode)
            
            lstFileOrig = str2cell(strFileOrig, endl);
            numLines = size(lstFileOrig, 1);
            
            lstFileNew = {}; inew = 0; flgAdd = 1; flgInCell = 0;
            
            for iLine = 1:numLines
                curLine = lstFileOrig{iLine, :};
                if(strncmp(curLine, str2lookfor, length(str2lookfor)))
                    numChangesToFile = numChangesToFile + 1;
                    iCellChange = iCellChange + 1;
                    flgInCell = 1;
                    flgAdd = 0;
                    % Start of the cell,
                else
                    if(flgInCell)
                        if( strncmp(curLine, '%%', 2) || (iLine == numLines) )
                            flgAdd = (iLine < numLines);
                            flgInCell = 0;
                            
                            lstNew = str2cell(str2useinstead, endl);
                            lstFileNew = [lstFileNew; lstNew];
                            numNew = size(lstNew, 1);
                            for i = 1:numNew
                                inew = inew + 1;
                                lstFileNew(inew,:) = lstNew(i,:);
                            end
                        end
                    end
                end
                
                if(flgAdd)
                    inew = inew + 1;
                    lstFileNew(inew,:) = { curLine };
                end
            end
            
            iMaster = iMaster + 1;
            if(iCellChange > 1)
                strPlural = 's';
            else
                strPlural = '';
            end
            lstReplaced(iMaster,:) = {sprintf('%s: Replaced %d cell instance%s of ''%s''', ...
                curFile, iCellChange, strPlural, str2lookfor)}; %#okAGROW
            
            strFileNew = cell2str(lstFileNew, endl );
            
        else
            iMaster = iMaster + 1;
            if(numFound > 1)
                strPlural = 's';
            else
                strPlural = '';
            end
            lstReplaced(iMaster,:) = {sprintf('%s: Replaced %d instance%s of ''%s'' with ''%s''', ...
                curFile, numFound, strPlural, str2lookfor, str2useinstead)}; %#okAGROW
                
                numReplaced = numReplaced + numFound;
                numChangesToFile = numChangesToFile + numFound;
                
                % Replace those sections
                if(numFound > 0)
                    if(ReplaceWholeLine)
                        lstFileNew = str2cell(strFileNew, endl);
                        numLines = size(lstFileNew, 1);
                        for iLine = 1:numLines
                            curLine = lstFileNew{iLine, :};
                            if(~isempty(strfind(curLine, str2lookfor)))
                                curLine = str2useinstead;
                            end
                            lstFileNew{iLine, :} = curLine;
                        end
                        strFileNew = cell2str(lstFileNew, endl);
                    else
                        strFileNew = strrep(strFileNew, str2lookfor, str2useinstead);
                    end
                end
            end
        end
    end
    
    if(numChangesToFile > 0)
        % Only Create the New File and Delete the Old One if it's been
        % changed
        [pathFile, nameFile, ext] = fileparts(curFile);
        tmpfile = [pathFile filesep nameFile '_tmp' ext];
        fidnew  = fopen(tmpfile, 'w');
        fprintf(fidnew, '%s', strFileNew);
        fclose(fidnew);
        
        copyfile(tmpfile, curFile);
        delete(tmpfile);
        
        if(OpenAfterEdit)
            edit(curFile);
        end
    end
    
end

warning on MATLAB:DELETE:Permission

end % << End of function txtReplace >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110124 JPG: Fixed a minor bug the function.  When calling the function
%              with strReplace as a cell lstNew would never be created.
% 101001 MWS: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName             : Email                 : NGGN Username
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi
% JPG: James Gray           : james.gray2@ngc.com	: G61720

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
