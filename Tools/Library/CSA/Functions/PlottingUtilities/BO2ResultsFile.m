% BO2RESULTSFILE Builds Bus Object information file used by 'SaveToBin' for proper post processing
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BO2ResultsFile:
%   Constructs the necessary bus object definition file used by the
%   'SaveToBin' block.  Bus object information is saved to a textfile whose
%   contents are appended to the end of the SaveToBin log file.
% 
% SYNTAX:
%	[strFilename] = BO2ResultsFile(strBO, strFilename, BOInfo, strBOprefix)
%	[strFilename] = BO2ResultsFile(strBO, strFilename, BOInfo)
%	[strFilename] = BO2ResultsFile(strBO, strFilename)
%	[strFilename] = BO2ResultsFile(strBO)
%
% INPUTS: 
%	Name            Size		Units		Description
%	strBO           'string'    [char]      Name of Bus Object
%   strFilename     'string'    [char]      Name of bus object definition file
%                                            Default: [strBus '_Info.txt']
%   BOInfo          {struct}                Bus Object Information Structure
%                                            Default: ''
%   strBOprefix     'string'    [char]      Prefix used to define bus objects
%                                            (e.g. 'BO_')
%                                            Default: ''
% OUTPUTS: 
%	Name            Size		Units		Description
%	strFilename     'string'    [char]      Name of filename created
%
% NOTES:
%   See 'Driver_Test_SaveToBin.m' for full example.
%
% EXAMPLES:
%   % Build the required 'SaveToBin' file for a sample bus object
%   % Step 1: Create the Bus Object
%   % lstBO(:,1):   'string'    Name of Bus Object Member
%   % lstBO(:,2):   [int]       Dimension of Bus Signal (optional input)
%   lstBO = {
%     'MET_sec'     1;
%     'Alpha_deg'   1;
%     'Beta_deg'    1;
%     };
%   BuildBusObject(strBO, lstBO);
%
%   % Step 2: Write the file
%   strFilename = [strBO '_Info.txt'];
%   BO2ResultsFile(strBO, strFilename)
%
%   % Open the newly created file:
%   edit(strFilename)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit BO2ResultsFile.m">BO2ResultsFile.m</a>
%	  Driver script: <a href="matlab:edit Driver_BO2ResultsFile.m">Driver_BO2ResultsFile.m</a>
%	  Documentation: <a href="matlab:pptOpen('BO2ResultsFile_Function_Documentation.pptx');">BO2ResultsFile_Function_Documentation.pptx</a>
%
% See also BuildBusObject 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/476
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/BO2ResultsFile.m $
% $Rev: 2345 $
% $Date: 2012-07-09 19:51:24 -0500 (Mon, 09 Jul 2012) $
% $Author: sufanmi $

function [strFilename] = BO2ResultsFile(strBO, strFilename, BOInfo, strBOprefix)

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

%% Main Function:
if((nargin < 4) || isempty(strBOprefix))
    strBOprefix = '';
end

if(nargin < 3)
    BOInfo = '';
end

if((nargin < 2) || isempty(strFilename))
    strFilename = sprintf('%s_Info.txt', strBus);    
end

if(~isempty(BOInfo))
    lst = BO2ResultsList(strBO, BOInfo);
    flgNoUnits = 0;
else
    lst = BusObject2List(strBO);
    flgNoUnits = 1;
end
strBus = strrep(strBO, strBOprefix, '');

fid = fopen(strFilename, 'w');

fprintf(fid, '%%%% Bus Object Information\n');
fprintf(fid, 'LogInfo.strBO = ''%s'';\n', strBO);
fprintf(fid, 'LogInfo.strBus = ''%s'';\n', strBus);
fprintf(fid, '\n');
fprintf(fid, '%% lstResultsList(:,1): ''string''   Bus Object signal name\n');
fprintf(fid, '%% lstResultsList(:,2): [int]        Signal dimensions\n');
fprintf(fid, '%% lstResultsList(:,3): ''string''   Data type\n');
fprintf(fid, 'LogInfo.lstResultsList = { ...\n');

maxSignalLength = size(char(lst(:,1)),2);
numSignals = size(lst, 1);

for iSignal = 1:numSignals
    
    if(iSignal == 1)
        curSignal = 'Time';
        curDim = 1;
        curUnits = '[sec]';
        numSpaces= maxSignalLength - length(curSignal);
        fprintf(fid, '    ''%s''%s   [%d]    ''%s'';  %% <-- Auto-Inserted DataRecorder Time\n', ...
            curSignal, spaces(numSpaces), curDim, curUnits);
    end
    
    curSignal = lst{iSignal, 1};
    curDim = lst{iSignal,2};
    
    if(numel(curDim) > 1)
        curDimToWrite = prod(curDim);
        strDim = num2str(curDim);
        strDim = strrep(strDim, '  ', ' x ');
        strComment = [' %% <-- Reshaped from a [' strDim '] matrix'];
    else
        curDimToWrite = curDim;
        strComment = '';
    end
    
    if(flgNoUnits)
        curUnits = '[unknown]';
    else
        curUnits = lst{iSignal,3};
    end
    numSpaces= maxSignalLength - length(curSignal);
    
    fprintf(fid, '    ''%s''%s   [%d]    ''%s'';%s\n', ...
        curSignal, spaces(numSpaces), curDimToWrite, curUnits, strComment);

end

fprintf(fid, '    };\n');

fclose(fid);
%% Compile Outputs:
%	strFilename= -1;

end % << End of function BO2ResultsFile >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110307 MWS: Filled out example.  Switched the input argument order from
%               'BOInfo, strFilename', to 'strFilename, BOInfo'.  This was
%               done since BOInfo doesn't technically need to be defined.
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720 
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi

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
