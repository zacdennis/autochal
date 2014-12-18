% BO2DR_CALLBACKS BO2DR Block Callbacks
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/766
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CreateBO2DR.m $
% $Rev: 2339 $
% $Date: 2012-07-09 17:24:48 -0700 (Mon, 09 Jul 2012) $
% $Author: sufanmi $

function BO2DR_Callbacks(hdl, strMode)

switch lower(strMode)
    case 'init'
        
        % Grab Mask Values
        % hdl = gcb;
        mskValues = get_param(hdl, 'MaskValues');
        saveDir     = mskValues{1,1};
        strBOInfo   = mskValues{2,1};
        strRoot     = evalin('base', mskValues{3,1});
        
        % Process 'saveDir'
        if(strcmp(saveDir, '0'))
            saveDir = 'pwd';
        end
        saveDir = evalin('base',saveDir);
        if(~isdir(saveDir))
            mkdir(saveDir);
        end
        if(~strcmp(saveDir(end), filesep))
            saveDir = [saveDir filesep];
        end
        
        % Process 'strBOInfo'
        ptrPeriod = strfind(strBOInfo, '.');
        if(isempty(ptrPeriod))
            strBO = strBOInfo;
        else
            strBO = strBOInfo(ptrPeriod(end)+1:end);
        end
        lstBOInfo = evalin('base', strBOInfo);
        
        [numSignals, numCols] = size(lstBOInfo);
        
        hdlBS = [hdl '/BusSelector'];
        numBSSignals = size(get_param(hdlBS, 'OutputSignalNames'),2);
        if(numSignals ~= numBSSignals)
            strError = sprintf('Error : Number of signals in bus object ''%s'' (%d) does not match the number of signals selected in underlying bus selector (%d). Current BO2DR appears outdated.  Rerun CreateBO2DR to fix.', ...
                strBO, numSignals, numBSSignals);
            error(strError);
        end
        
        for iSignal = 1:numSignals
            curSignal = lstBOInfo{iSignal, 1};
            hdlDR = [hdl '/' strBO '.' curSignal];
            if(isempty(strRoot))
                strFilename = [saveDir curSignal '.mat'];
            else
                strFilename = [saveDir strRoot '.' curSignal '.mat'];
            end
            set_param(hdlDR, 'Filename', strFilename);
        end
        
    case 'stop'
        % Grab Mask Values
%         hdl = gcb;
        mskValues = get_param(hdl, 'MaskValues');
        saveDir     = mskValues{1,1};
        strBOInfo   = mskValues{2,1};
        strRoot     = evalin('base', mskValues{3,1});
        
        % Process 'saveDir'
        if(strcmp(saveDir, '0'))
            saveDir = 'pwd';
        end
        saveDir = evalin('base',saveDir);
        if(~isdir(saveDir))
            mkdir(saveDir);
        end
        if(~strcmp(saveDir(end), filesep))
            saveDir = [saveDir filesep];
        end
        
        % Process 'strBOInfo'
        ptrPeriod = strfind(strBOInfo, '.');
        if(isempty(ptrPeriod))
            strBO = strBOInfo;
        else
            strBO = strBOInfo(ptrPeriod(end)+1:end);
        end
        lstBOInfo = evalin('base', strBOInfo);
        
        [numSignals, numCols] = size(lstBOInfo);
        flgUnits  = numCols > 3;
        for iSignal = 1:numSignals
            curSignal = lstBOInfo{iSignal, 1};
            hdlDR = [hdl '/' strBO '.' curSignal];
            if(isempty(strRoot))
                strFilename = [saveDir curSignal '.mat'];
            else
                strFilename = [saveDir strRoot '.' curSignal '.mat'];
            end
            if(flgUnits)
                curUnits  = lstBOInfo{iSignal, 4};
                if(~isempty(curUnits))
                    disp(sprintf('%s Stop Callback : %d/%d : %s.%s : Appending ''%s'' units...', ...
                        gcb, iSignal, numSignals, strRoot, curSignal, curUnits));
                    load(strFilename);
                    ts.DataInfo.Units = curUnits;
                    if(isempty(strRoot))
                        ts.Name = curSignal;
                    else
                        ts.Name = [strRoot '.' curSignal];
                    end
                    save(strFilename, 'ts');
                end
            end
        end
        
        
        
end
