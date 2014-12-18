% SETBLOCKVALUES Large Scale Setting of Simulink Model block Mask and Block Parameters
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% SetBlockValues:
%     Large Scale Setting of Simulink Model block Mask and Block
%     Parameters.  This function uses an Excel spreadsheet and tabs to
%     determine what Simulink models and blocks to alter.
% 
% SYNTAX:
%	[] = SetBlockValues(xlsFilename, lstTabs, varargin, 'PropertyName', PropertyValue)
%	[] = SetBlockValues(xlsFilename, lstTabs, varargin)
%	[] = SetBlockValues(xlsFilename, lstTabs)
%	[] = SetBlockValues(xlsFilename)
%
% INPUTS: 
%	Name            Size		Units       Description
%	xlsFilename     'string'    [char]      Full path of Excel spreadsheet
%	lstTabs         {'string'}  [char]      List of Tabs to use
%	varargin        [N/A]		[varies]	Optional function inputs that
%                                           should be entered in pairs.
%                                           See the 'VARARGIN' section
%                                           below for more details
%
% OUTPUTS: 
%	Name            Size		Units		Description
%	None
%
% NOTES:
%   Can be used in conjunction with the ViewValues.m report mode.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	'xlsBlockCol'       [int]           2           Excel spreadsheet
%                                                   column that contains
%                                                   the full path to the
%                                                   Simulink block to be
%                                                   changed
%   'xlsVariableCol'    [int]           4           Excel spreadsheet
%                                                   column that contains
%                                                   the block variable to
%                                                   change (e.g. a constant
%                                                   block's "Value")
%   'xlsValueCol'       [int]           7           Excel spreadsheet
%                                                   column that contains
%                                                   the new value to use
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[] = SetBlockValues(xlsFilename, lstTabs, varargin)
%	% <Copy expected outputs from Command Window>
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit SetBlockValues.m">SetBlockValues.m</a>
%	  Driver script: <a href="matlab:edit Driver_SetBlockValues.m">Driver_SetBlockValues.m</a>
%	  Documentation: <a href="matlab:winopen(which('SetBlockValues_Function_Documentation.pptx'));">SetBlockValues_Function_Documentation.pptx</a>
%
% See also ViewValues 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/863
%  
% Copyright Northrop Grumman Corp 2014
% Maintained by: Aerospace Systems
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/SetBlockValues.m $
% $Rev: 3300 $
% $Date: 2014-10-31 13:23:19 -0500 (Fri, 31 Oct 2014) $
% $Author: sufanmi $

function SetBlockValues(xlsFilename, lstTabs, varargin)

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

%% Input Argument Conditioning
[xlsBlockCol, varargin]    = format_varargin('xlsBlockCol', 2, 2, varargin);
[xlsVariableCol, varargin] = format_varargin('xlsVariableCol', 4, 2, varargin);
[xlsValueCol, varargin]    = format_varargin('xlsValueCol', 7, 2, varargin);

if(~iscell(lstTabs))
    lstTabs = { lstTabs };
end

%% Main Function:
numTabs = size(lstTabs, 1);
lstModels = {};

for iTab = 1:numTabs
    curTab = lstTabs{iTab};
    
    disp(sprintf('%s : [%d/%d] : Processing Tab ''%s'' in ''%s''...', ...
        mfilename, iTab, numTabs, curTab, xlsFilename));
    
    % Load the Excel Spreadshee Tab of Interest
    [~, ~, tblRaw] = xlsread(xlsFilename, curTab);
    numHeaders = 1;
    numRows = size(tblRaw, 1) - numHeaders;
    
    for iRow = 1:numRows
        curRow = tblRaw(iRow+numHeaders, :);

        % Extract the Block/Variable/ValueNew from the Table:
        curBlock     = curRow{xlsBlockCol};
        curVariable  = curRow{xlsVariableCol};
        curValueNew  = curRow{xlsValueCol};
        
        if( isempty(curValueNew) | isnan(curValueNew) )
            % Just Ignore It
        else
            
            % Determine the root 
            ptrSlash = findstr(curBlock, '/');
            curModel = curBlock(1:ptrSlash(1)-1);
            
            load_system(curModel);
            
            flgIsBlock = 1;
            try
                find_system(curBlock);
            catch
                flgIsBlock = 0;
            end
            
            if(flgIsBlock)
                if( strcmp(curValueNew(1), '''') && strcmp(curValueNew(end), '''') )
                    % Remove the leading/trailing quotation
                    curValueNew = curValueNew(2:end-1);
                end
                
                try
                    % Block Param
                    flgBlockParam = 1;
                    curValueOld = get_param(curBlock, curVariable);
                catch
                    % Mask Param
                    flgBlockParam = 0;
                    lstMaskNames    = get_param(curBlock, 'MaskNames');
                    iMaskName       = max(strcmp(lstMaskNames, curVariable) .* [1:size(lstMaskNames, 1)]');
                    lstMaskValues   = get_param(curBlock, 'MaskValues');
                    curValueOld     = lstMaskValues{iMaskName};
                end
                
                if(strcmp(curValueNew, curValueOld))
                    disp(sprintf('[%d/%d] : The old and new values for ''%s'' ''%s'' are identical.  Ignoring update.', ...
                        iRow, numRows, curBlock, curVariable));
                else
                    disp(sprintf('[%d/%d] : Changing the ''%s'' ''%s'' from ''%s'' to ''%s''...', ...
                        iRow, numRows, curBlock, curVariable, curValueOld, curValueNew));
                    if(flgBlockParam)
                        set_param(curBlock, curVariable, curValueNew);
                    else
                        lstMaskValues{iMaskName} = curValueNew;
                        set_param(curBlock, 'MaskValues', lstMaskValues);
                    end
                    
                    % Keep track of the Models that have changed.  Will need to
                    % go back and save them later.
                    lstModels = [lstModels; curModel];
                end
            end
        end
    end
    
    lstModels = unique(lstModels);
    numModelsChanged = size(lstModels, 1);
    if(numModelsChanged == 0)
        disp(sprintf('%s : No Models were Changed', mfilename));
    else
        for iModel = 1:numModelsChanged;
            curModel = lstModels{iModel, 1};
            disp(sprintf('%s : [%d/%d] Saving ''%s'' since model was changed...', ...
                mfilename, iModel, numModelsChanged, curModel));
            save_system(curModel);
        end
    end
end

disp(sprintf('%s : Finished!', mfilename));

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
