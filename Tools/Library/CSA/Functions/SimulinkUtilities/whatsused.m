% WHATSUSED Determines what workspace variables are used by a Simulink block
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% whatsused:
%     This function determines what workspace variables are used by a
%     Simulink model or block.  This is really an enhanced version of the
%     'Simulink.findVars' call.  If a block uses 'A' or any derivation
%     thereof (e.g. A.B.var), 'Simulink.findVars' will only determine that
%     'A' is used.  This function goes a step further and determines
%     exactly which members of 'A' are used.  Hence, if there exists a
%     structure 'A' in the workspace that has 100+ members, and only 2
%     variable are used (e.g. A.variable1 and A.variable99), this function
%     will return {'A.variable1'; 'A.variable99'} instead of just 'A'.
%     This function is extremely useful in understanding what variables are
%     used on a very large model or with a very large workspace variable
%     library.
%
% SYNTAX:
%	[lstVars, structVars] = whatsused(blockName)
%	[lstVars, structVars] = whatsused()
%
% INPUTS:
%	Name     	Size		Units		Description
%	blockName	'string'    [char]      Name of Simulink block or model in
%                                        which to compile list of used
%                                        variables
%                                        Default: bdroot
% OUTPUTS:
%	Name     	Size		Units		Description
%	lstVars     {'string'}  {[char]}    List of workspace variables used by
%                                        'blockName'
%   structVars                          Structure with variable use info
%    .Name      'string'    [char]      Name of workspace variable
%    .UsedByBlocks {'string'}  {[char]} List containing full model paths to
%                                        where workspace variable is used.
%
% NOTES:
%	Uses CSA_Library functions: listStruct
%
%   Limitations:
%   If a mask variable uses a mixed expression (e.g. 'variable + 2' or
%   'A.variable1 + B.variable2'), it's possible that the function won't
%   capture both variables used.  While the function attempts to account 
%   for these permutations, it may not catch all.
%
% EXAMPLES:
%	% Example #1: Determine which workspace variable are used by MATLAB's
%   %	'f14' simulation
%   [lstVars, structVars] = whatsused('f14')
%
%   % lstVars returns...
%   %     'Ka'
%   %     'Kf'
%   %     'Ki'
%   %     'Kq'
%   %     'Md'
%   %     'Mq'
%   %     'Mw'
%   %     'Swg'
%   %     'Ta'
%   %     'Tal'
%   %     'Ts'
%   %     'Uo'
%   %     'Vto'
%   %     'W1'
%   %     'W2'
%   %     'Zd'
%	%     'Zw'
%   %     'a'
%   %     'b'
%   %     'g'
%
%   % structVars = 
%   % 1x20 struct array with fields:
%   %     Name
%   %     UsedByBlocks
%
%   % structVars(17) returns...
%   %             Name: 'Zw'
%   %     UsedByBlocks: {2x1 cell}
%
%   % structVars(17).UsedByBlocks{1} returns...
%   %   f14/Aircraft
%   %   Dynamics
%   %   Model/Transfer Fcn.2
%
%   % structVars(17).UsedByBlocks{2} returns...
%   %   f14/Gain
%
%	% Example #2: Determine which workspace variable are used by MATLAB's
%   %	'f14/Controller' block
%   lstVars = whatsused('f14/Controller')
%   % lstVars returns...
%   %     'Ka'
%   %     'Kf'
%   %     'Ki'
%   %     'Kq'
%   %     'Tal'
%   %     'Ts'
%   %     'W1'
%   %     'W2'
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit whatsused.m">whatsused.m</a>
%	  Driver script: <a href="matlab:edit Driver_whatsused.m">Driver_whatsused.m</a>
%	  Documentation: <a href="matlab:pptOpen('whatsused_Function_Documentation.pptx');">whatsused_Function_Documentation.pptx</a>
%
% See also listStruct
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/734
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/whatsused.m $
% $Rev: 2183 $
% $Date: 2011-09-01 14:24:45 -0500 (Thu, 01 Sep 2011) $
% $Author: sufanmi $

function [lstVars, structVars] = whatsused(blockName)

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

if((nargin == 0) || isempty(blockName))
    blockName = bdroot;
end

%% Main Function:
%  <Insert Main Function>
lstVarsUsed = {}; iVarUsed = 0;

ptrSlashes = findstr(blockName, '/');
if(isempty(ptrSlashes))
    blockRoot = blockName;
else
    blockRoot = blockName(1:ptrSlashes(1)-1);
end

load_system(blockRoot);
LibraryType = get_param(blockRoot, 'LibraryType');
if(strcmp(LibraryType, 'BlockLibrary'))
    disp(sprintf('%s : ERROR: Function cannot be run on a Library.  See %s for help.', mfnam, mlink));
    
else
    
    
    lstVarsFound = Simulink.findVars(blockName);
    
    numFound = size(lstVarsFound, 1);
    
    for iFound = 1:numFound
        curFound = lstVarsFound(iFound);
        
        if(strcmp(curFound.WorkspaceType, 'base'))
            
            strWSvar = curFound.Name;
            try
                flgIsStruct = evalin(curFound.WorkspaceType, ['isstruct(' curFound.Name ')']);
            catch
                disp(lasterr);
            end
            
            if(flgIsStruct)
                strStructRoot = curFound.Name;
                lstStruct = evalin(curFound.WorkspaceType, ['listStruct(' curFound.Name ')']);
                
                numUsedByBlocks = size(curFound.UsedByBlocks, 1);
                for iUsedByBlocks = 1:numUsedByBlocks
                    curUsedByBlock = curFound.UsedByBlocks{iUsedByBlocks, :};
                    
                    flgIsMaskedBlock = strcmp(get_param(curUsedByBlock, 'Mask'), 'on');
                    if(flgIsMaskedBlock)
                        lstMaskValues = get_param(curUsedByBlock, 'MaskValues');
                        for iMaskValue = 1:size(lstMaskValues, 1)
                            curMaskValue = lstMaskValues{iMaskValue};
                            
                            flgMatch = ~isempty(strfind(curMaskValue, curFound.Name));
                            if(flgMatch)
                                
                                flgIsStruct = evalin(curFound.WorkspaceType, ['isstruct(' curMaskValue ')']);
                                if(flgIsStruct)
                                    %                                 disp('Figure out the mapping and continue');
                                else
                                    % I think you're done, BUT...
                                    % Note: it is possible that the mask is an
                                    % expression containg stuff other than just
                                    % a single variable
                                    iVarUsed = iVarUsed + 1;
                                    lstVarsUsed(iVarUsed,:) = { curMaskValue curUsedByBlock };
                                end
                            end
                        end
                    end
                    
                    structDialogParams = get_param(curUsedByBlock, 'DialogParameters');
                    lstDialogParams = fieldnames(structDialogParams);
                    
                    for iDialogParam = 1:size(lstDialogParams, 1);
                        curDialogParam = lstDialogParams{iDialogParam, :};
                        curDialogParamStr = get_param(curUsedByBlock, curDialogParam);
                        
                        if(~isempty(strfind(curDialogParamStr, strStructRoot)))
                            % We've got a hit.  The string in the dialog has a
                            % workspace variable in it, but it may have been
                            % entered as part of an expression (e.g. 'a+b'), so
                            % we need to check to see if we need to split up
                            % the dialog into smaller pieces
                            curDialogParamStr = strtrim( curDialogParamStr );
                            
                            lstPossibleVars = regexpi(curDialogParamStr, '[-+*%()/]', 'split');
                            for iPossibleVar = 1:size(lstPossibleVars, 1)
                                curVarToAdd = lstPossibleVars{iPossibleVar};
                                
                                if(~isempty(strfind(curVarToAdd, strStructRoot)))
                                    
                                    flgIsStruct = evalin(curFound.WorkspaceType, ['isstruct(' curVarToAdd ')']);
                                    if(~flgIsStruct)
                                        iVarUsed = iVarUsed + 1;
                                        lstVarsUsed(iVarUsed,:) = { curVarToAdd curUsedByBlock };
                                    end
                                end
                            end
                        end
                    end
                end
                
            else
                
                for i = 1:size(curFound.UsedByBlocks, 1);
                    iVarUsed = iVarUsed + 1;
                    lstVarsUsed(iVarUsed,:) = { curFound.Name curFound.UsedByBlocks{i}};
                end
            end
            
        else
            
            lstVarsUsed = MaskTrace(curFound, lstVarsUsed);
            
        end
    end
    
    
    %% Compile Outputs:
    numUsed = size(lstVarsUsed, 1);
    
    lstVars = unique(lstVarsUsed(:,1));
    
    numUnique = size(lstVars, 1);
    for iUnique = 1:numUnique
        curUnique = lstVars{iUnique};
        structVars(iUnique).Name = lstVars{iUnique};
        structVars(iUnique).UsedByBlocks = {};
        
        for iFull = 1:numUsed
            curVariable = lstVarsUsed{iFull, 1};
            
            if(strcmp(curVariable, curUnique))
                curBlock    = lstVarsUsed{iFull, 2};
                idxUnique = max(strcmp(lstVars, curVariable).*[1:numUnique]');
                
                iCount = size(structVars(iUnique).UsedByBlocks, 1);
                iCount = iCount + 1;
                
                structVars(iUnique).UsedByBlocks(iCount,1) = { curBlock };
            end
        end
        
    end
end

end % << End of function whatsused >>

%% ========================================================================

function lstVarsUsed = MaskTrace(curFound, lstVarsUsed)
iVarUsed = size(lstVarsUsed, 1);

for iUsedByBlock = 1:size(curFound.UsedByBlocks, 1)
    curUsedByBlock = curFound.UsedByBlocks{iUsedByBlock};
    
    %     get_param(curFound.Workspace, 'MaskVariables');
    arrSlashes = findstr(curFound.Workspace, '/');
    
    numSlashes = length(arrSlashes);
    
    curRoot = curFound.Name;
    fullVarName = '';
    for iLoop = numSlashes:-1:1
        if(iLoop == numSlashes)
            curPossibleWorkspace = curFound.Workspace;
        else
            curPossibleWorkspace = curFound.Workspace(1:arrSlashes(iLoop+1)-1);
        end
        
        flgIsMasked = strcmp(get_param(curPossibleWorkspace, 'Mask'), 'on');
        
        if(flgIsMasked)
            
            lstMaskNames = get_param(curPossibleWorkspace, 'MaskNames');
            lstMaskValues = get_param(curPossibleWorkspace, 'MaskValues');
            for iMaskName = 1:size(lstMaskNames, 1)
                idxMaskName = 0;
                if(strcmp(lstMaskNames{iMaskName}, curRoot))
                    idxMaskName = iMaskName;
                    break;
                end
            end
            refMaskValue = lstMaskValues{idxMaskName};
            
            if(isempty(fullVarName))
                fullVarName = refMaskValue;
            else
                ptrPeriod = strfind(fullVarName, '.');
                if(isempty(ptrPeriod))
                    fullVarName = refMaskValue;
                else
                    fullVarName = [refMaskValue fullVarName(ptrPeriod(1):end)];
                end
            end
            
            ptrPeriod = strfind(refMaskValue, '.');
            if(~isempty(ptrPeriod))
                curRoot = refMaskValue(1:ptrPeriod(1)-1);
            else
                curRoot = refMaskValue;
            end
            
            
        end
    end
    
    try
        flgIsStruct = evalin('base', ['isstruct(' fullVarName ')']);
    catch
        disp(lasterr);
        flgIsStruct = 1;
    end
    
    if(~flgIsStruct)
        
        ec = ['flgIsVariable = evalin(''base'', ''exist(''''' fullVarName ''''')'');'];
        eval(ec);
        
        if(flgIsVariable)
            iVarUsed = iVarUsed + 1;
            lstVarsUsed(iVarUsed,:) = { fullVarName curUsedByBlock};
        end
    else
        
        structDialogParams = get_param(curUsedByBlock, 'DialogParameters');
        lstDialogParams = fieldnames(structDialogParams);
        
        for iDialogParam = 1:size(lstDialogParams, 1);
            curDialogParam = lstDialogParams{iDialogParam, :};
            curDialogParamStr = get_param(curUsedByBlock, curDialogParam);
            
            if(~isempty(strfind(curDialogParamStr, curFound.Name)))
                % We've got a hit.  The string in the dialog has a
                % workspace variable in it, but it may have been
                % entered as part of an expression (e.g. 'a+b'), so
                % we need to check to see if we need to split up
                % the dialog into smaller pieces
                
                curDialogParamStr = strrep(curDialogParamStr, curFound.Name, fullVarName);
                
                curDialogParamStr = strtrim( curDialogParamStr );
                
                lstPossibleVars = regexpi(curDialogParamStr, '[-+*%()/]', 'split');
                for iPossibleVar = 1:size(lstPossibleVars, 1)
                    curVarToAdd = lstPossibleVars{iPossibleVar};
                    
                    flgIsStruct = evalin('base', ['isstruct(' curVarToAdd ')']);
                    flgIsVariable = (~isempty(strfind(curVarToAdd, curRoot)));
                    if(~flgIsStruct && flgIsVariable)
                        iVarUsed = iVarUsed + 1;
                        lstVarsUsed(iVarUsed,:) = { curVarToAdd curUsedByBlock};
                    end
                end
            end
        end
    end
end
end

%% REVISION HISTORY
% YYMMDD INI: note
% 110708 MWS: Created function using CreateNewFunc
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
