% COSMO Generates all the pertinent documentation for a simulink block.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CoSMO:
%     This function generates the proper documentation package for a library block.
%     The documentation package includes a powerpoint presentation explaining the usage of the library block,
%     includes a document block next to the library block with detail
%     information of the library block itself. Also, it includes a text box
%     with the latest information on revision history.
%
% SYNTAX:
%   [lstChanges] = CoSMO(component_type, component_name, varargin)
%   [lstChanges] = CoSMO(component_type, component_name)
%
% INPUTS:
%	Name            Size        Units       Description
%	 BlockPath      <1xn>      <String>     Gives a detail path of the block to document
%	 TextToAdd      <1xn>      <String>     String to be added to the doc block
%                               Default: <Enter Default Value>
%
% OUTPUTS:
%	Name            Size        Units       Description
%	 lstChanges     <size>      <units>     <Description>
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLE:
%   % CoSMO a MATLAB Function
%	[lstChanges] = CoSMO(block_path,TextToAdd)
%
%   % CoSMO a Simulink Block
%   [lstChanges] = CoSMO('block', 'SecondOrderActuator_ExtIC_wFailures')
%
% SOURCE DOCUMENTATION:
%	[1]    http://www...
%	[2]    Author. Book Title. Publisher, City, Copyright year
%
% See also str2cell
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/634
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoSMO_Utilities/CoSMO.m $
% $Rev: 3073 $
% $Date: 2014-02-05 18:14:35 -0600 (Wed, 05 Feb 2014) $
% $Author: sufanmi $

% function [lstChanges] = CoSMO(block_fullpath,TextToAdd)
function [lstChanges] = CoSMO(component_type, component_name, varargin)

%% General Header
spc  = sprintf(' ');
tab  = sprintf('\t');
endl = sprintf('\n');
[mfpath,mfnam] = fileparts(mfilename('fullpath'));
mfspc = char(ones(1,length(mfnam))*spc);
% Example of Display formats ...
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>>CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>>WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>>ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >>ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Input Argument Conditioning
[Markings, varargin] = format_varargin('Markings', 'Default', 2, varargin);
[TextToAdd, varargin] = format_varargin('TextToAdd', '',  2, varargin);
% [ReferenceLib, varargin] = format_varargin('ReferenceLib', 'CSA_Library',  2, varargin);

iCtr = 0; lstChanges = {};

%% Main Code
hd = pwd;
this_filepath = fileparts(mfilename('fullpath'));
cd(this_filepath); cd ..; cd ..; cd ..;
CSA_root = pwd;

switch lower(component_type)
    
    case {'function', 'f', 'fcn', 'func'}
        % CoSMO a MATLAB Function
        
        % Create the Function (if it doesn't already exist)
        function_name = component_name;
        
        if( (exist(function_name) ~= 2) | (length(varargin) > 0) )
            [fi, info] = CreateNewFunc(function_name, varargin{:});
            if(fi == 0)
                % No errors detected, add to log:
                iCtr = iCtr + 1; lstChanges(iCtr,:) = {['CreateNewFunc: ' info.fname]};
            end
        end
       
        % Determine the Master Verification folder:
        lstFldrs = {};
        lstPath = str2cell(path, ';');
        numDir = size(lstPath, 1);
        for iDir = 1:numDir
            curDir = lstPath{iDir};
            if(~isempty(strfind(curDir, 'MATLABFunctionVerification')))
                lstFldrs = {curDir};
                break;
            end
        end

        if(isempty(lstFldrs))
            verification_head = [CSA_root filesep 'MATLABFunctionVerification'];
        else
            verification_head = lstFldrs{1,:};
        end
        
        % Create the Master Verification folder:
        if(~isdir(verification_head))
            mkdir(verification_head);
            iCtr = iCtr + 1; lstChanges(iCtr,:) = {['mkdir: ' verification_head]};
        end
                
        % Create the Function's Verification Folder:
        function_verify_head = [verification_head filesep function_name];
        if(~isdir(function_verify_head))
            mkdir(function_verify_head);
            iCtr = iCtr + 1; lstChanges(iCtr,:) = {['mkdir: ' function_verify_head]};
        end

        % Build the function driver:
        [fi, info] = CreateNewScript(function_name, 'Description', TextToAdd, ...
            'SaveFolder', function_verify_head, 'Markings', Markings);
        if(fi == 0)
            % No errors detected, add to log:
            iCtr = iCtr + 1; lstChanges(iCtr,:) = {['CreateNewScript: ' info.fname]};
        end
        
        % Add External Documentation if it doesn't exist:
        docRefFile = which('MATLAB Function Documentation Template.pptx');
        docFilename = [function_verify_head filesep function_name '_Function_Documentation.pptx'];
        if(~exist(docFilename, 'file'))
            copyfile(docRefFile, docFilename);
            iCtr = iCtr + 1; lstChanges(iCtr,:) = {['AddDocumentation: ' docFilename]};
        end
        
    case {'script'}
        % CoSMO a MATLAB Script - TBD/TODO
        
    case {'block', 'b', 'simblock', 's'}
        
        block_name = component_name;
        
%         ptrSlash = findstr(component_name, '/');
%         if(isempty(ptrSlash))
%             block_fullpath = ListLib(ReferenceLib, 'Name', component_name);
%             
%             if(isempty(block_fullpath))
%                 block_fullpath = '';
%             else
%                 block_fullpath = block_fullpath{1,:};
%             end
%             block_name = component_name;
%         else
%             block_fullpath = component_name(1:ptrSlash(end)-1);
%             block_name = component_name(ptrSlash(end)+1:end);
%         end
        
        % Determine the Master Verification folder:
        lstFldrs = {};
        lstPath = str2cell(path, ';');
        numDir = size(lstPath, 1);
        for iDir = 1:numDir
            curDir = lstPath{iDir};
            if(~isempty(strfind(curDir, 'SimulinkBlockVerification')))
                lstFldrs = {curDir};
                break;
            end
        end
        if(isempty(lstFldrs))
            verification_head = [CSA_root filesep 'SimulinkBlockVerification'];
        else
            verification_head = lstFldrs{1,:};
        end
        
        % Create the Master Verification folder:
        if(~isdir(verification_head))
            mkdir(verification_head);
            iCtr = iCtr + 1; lstChanges(iCtr,:) = {['mkdir: ' verification_head]};
        end
%         cd(verification_head);
        
        % Create the Block's Verification Folder
        block_verify_head = [verification_head filesep block_name];
        if(~isdir(block_verify_head))
            mkdir(block_verify_head);
            iCtr = iCtr + 1; lstChanges(iCtr,:) = {['mkdir: ' block_verify_head]};
        end
        
        [SaveFolder, varargin] = format_varargin('SaveFolder', block_verify_head, 2, varargin);
        testModel = CreateUnitTestModel(block_name, {}, {}, 'SaveFolder', SaveFolder, 'Markings', Markings);
        
        if(~isempty(testModel))
            iCtr = iCtr + 1; lstChanges(iCtr,:) = {['CreateUnitTestModel: ' testModel]};
        end
        
        % Add documentation if it doesn't exist
        docRefFile = which('Simulink Block Documentation Template.pptx');
        docFilename = [block_verify_head filesep block_name '_Block_Documentation.pptx'];
        
        if((~exist(docFilename, 'file') && (exist(docRefFile, 'file'))))
            copyfile(docRefFile, docFilename);
            iCtr = iCtr + 1; lstChanges(iCtr,:) = {['AddDocumentation: ' docFilename]};
        end
        
        % Create Driver script for Unit Test Model
        CreateBlock_DriverScript(testModel, 'Markings', Markings, 'SaveFolder', SaveFolder);
        iCtr = iCtr + 1; lstChanges(iCtr,:) = {['CreateBlock_DriverScript: Driver_Test_' block_name '.m']};

case {'c'}
        % CoSMO a CSA_LIB.c function (ie test wrapper in MATLAB)
        
        % Create the Function (if it doesn't already exist)
        function_name = component_name;

        % Determine the Master Verification folder:
        lstFldrs = {};
        lstPath = str2cell(path, ';');
        numDir = size(lstPath, 1);
        for iDir = 1:numDir
            curDir = lstPath{iDir};
            if(~isempty(strfind(curDir, 'CCodeVerification')))
                lstFldrs = {curDir};
                break;
            end
        end

        if(isempty(lstFldrs))
            verification_head = [CSA_root filesep 'CCodeVerification'];
        else
            verification_head = lstFldrs{1,:};
        end
        
        % Create the Master Verification folder:
        if(~isdir(verification_head))
            mkdir(verification_head);
            iCtr = iCtr + 1; lstChanges(iCtr,:) = {['mkdir: ' verification_head]};
        end
                
        % Create the Function's Verification Folder:
        function_verify_head = [verification_head filesep function_name];
        if(~isdir(function_verify_head))
            mkdir(function_verify_head);
            iCtr = iCtr + 1; lstChanges(iCtr,:) = {['mkdir: ' function_verify_head]};
        end

        % Build the function driver:
        [fi, info] = CreateNewScript(function_name, 'Description', TextToAdd, ...
            'SaveFolder', function_verify_head, 'Markings', Markings);
        if(fi == 0)
            % No errors detected, add to log:
            iCtr = iCtr + 1; lstChanges(iCtr,:) = {['CreateNewScript: ' info.fname]};
        end
        
        % Add External Documentation if it doesn't exist:
        docRefFile = which('MATLAB Function Documentation Template.pptx');
        docFilename = [function_verify_head filesep function_name '_CCode_Documentation.pptx'];
        if(~exist(docFilename, 'file'))
            copyfile(docRefFile, docFilename);
            iCtr = iCtr + 1; lstChanges(iCtr,:) = {['AddDocumentation: ' docFilename]};
        end
        
end

cd(hd);

end % << end of CoSMO function >>

%% REVISION HISTORY
% YYMMDD INI: note
% 100810 CNF: File Created by CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName  :  Email  :  NGGN Username
% MWS: Mike Sufana : mike.sufana@ngc.com : sufanmi
% <ini>: <Fullname> : <email> : <NGGN username>

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is
%   subject to severe civil and/or criminal penalties.

% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
