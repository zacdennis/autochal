% DR2BO_INITFCN_CALLBACK InitFcn Callback for DR2BO block
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% DR2BO_InitFcn_Callback:
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/811
%  
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CreateDR2BO.m $
% $Rev: 2993 $
% $Date: 2013-08-20 12:58:58 -0700 (Tue, 20 Aug 2013) $
% $Author: sufanmi $
function DR2BO_InitFcn_Callback(hdl, lst_BlockName_Filename)
% Grab Mask Values
% hdl = gcb;
mskValues = get_param(hdl, 'MaskValues');
saveDir     = mskValues{1,1};
% strBOInfo   = mskValues{2,1};
strRoot     = evalin('base', mskValues{2,1});

% Process 'saveDir'
if(strcmp(saveDir, '0'))
    saveDir = 'pwd';
end
saveDir = evalin('base',saveDir);
if(~strcmp(saveDir(end), filesep))
    saveDir = [saveDir filesep];
end

% Process 'strBOInfo'
% ptrPeriod = strfind(strBOInfo, '.');
% if(isempty(ptrPeriod))
%     strBO = strBOInfo;
% else
%     strBO = strBOInfo(ptrPeriod(end)+1:end);
% end
% lstBOInfo = evalin('base', strBOInfo);

% [numSignals, numCols] = size(lstBOInfo);
[numSignals, numCols] = size(lst_BlockName_Filename);

% hdlBC = [hdl '/BusCreator'];
% numBCSignals = size(get_param(hdlBC, 'InputSignalNames'),2);
% if(numSignals ~= numBCSignals)
%     strError = sprintf('Error : Number of signals in bus object ''%s'' (%d) does not match the number of signals set in underlying bus creator (%d). Current DR2BO appears outdated.  Rerun CreateDR2BO to fix.', ...
%     strBO, numSignals, numBCSignals);
%     error(strError);
% end

for iSignal = 1:numSignals
    curBlockName = lst_BlockName_Filename{iSignal, 1};
    curFilename  = lst_BlockName_Filename{iSignal, 2};
%     curSignal = lstBOInfo{iSignal, 1};
    hdlDR = [hdl '/' curBlockName];
%     if(isempty(strBO))
%         hdlDR = [hdl '/' curSignal];
%     else
%         hdlDR = [hdl '/' strBO '.' curSignal];
%     end
    if(isempty(strRoot))
        strFilename = [saveDir curFilename '.mat'];
    else
        strFilename = [saveDir strRoot '.' curFilename '.mat'];
    end
    set_param(hdlDR, 'Filename', strFilename);
end
