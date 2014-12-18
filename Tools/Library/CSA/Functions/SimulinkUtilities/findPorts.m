% FINDPORTS Finds input and output ports of a simulink model
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% findPorts:
%     This block compiles a list of a Simulink block's inputs and outputs.
%     If the block is in an uncompiled model, only the input port names
%     will be returned.  If the model is compiled, the compiled port data
%     type and dimensions will also be provided.
% 
% SYNTAX:
%	[inputPorts, outputPorts] = findPorts(blockName)
%
% INPUTS: 
%	Name		Size            Units		Description
%	blockName	'string'        [char]      Full path to Simulink block on
%                                           which to search for input & 
%                                           output ports
%
% OUTPUTS: 
%	Name		Size            Units       Description
%	inputPorts	{nx3}           Note #1     List of input ports
%	outputPorts	{mx3}           Note #1     List of output ports
%
% NOTES:
%  Note #1: If uncompiled, inputPorts and outputPorts will be of form:
%       lstPorts(:,1): 'string'     Name of input or output port (Name)
%       lstPorts(:,2): [int]        Port input or output signal dimension
%                                    (PortDimensions)
%       lstPorts(:,3): 'string'     Port input or output datatype
%                                    (OutDataTypeStr)
%
%   If compiled, inputPorts and outputPorts will be of form:
%       lstPorts(:,1): 'string'     Name of input or output port (Name)
%       lstPorts(:,2): [int]        Port input or output signal dimension
%                                    (CompiledPortDimensions)
%       lstPorts(:,3): 'string'     Port input or output datatype
%                                    (CompiledPortDataTypes)
%
% EXAMPLES:
%	% Example 1: Get Port Information for the 'Aircraft Dynamics Model'
%	%            block inside of the MATLAB 'f14' model
%   %  Option 1: Call model in an uncompiled state:
%   blockName = sprintf('f14/Aircraft\nDynamics\nModel');
%	[inputPorts, outputPorts] = findPorts(blockName)
%
%   %  Option 2: Call the model in a compiled state:
%   f14([], [], [], 'compile');
%	[inputPorts, outputPorts] = findPorts(blockName)
%   f14([], [], [], 'term');
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit findPorts.m">findPorts.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_findPorts.m">DRIVER_findPorts.m</a>
%	  Documentation: <a href="matlab:pptOpen('findPorts Documentation.pptx');">findPorts Documentation.pptx</a>
%
% See also find_system, get_param
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/686
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/findPorts.m $
% $Rev: 2280 $
% $Date: 2011-12-07 19:35:05 -0600 (Wed, 07 Dec 2011) $
% $Author: sufanmi $

function [lstInports,lstOutports] = findPorts(blockName, flgFull)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Initialize Outputs:
lstInports= {};
lstOutports= {};

%% Input Argument Conditioning:
switch nargin
    case 1
        flgFull = '';
end
    
if(isempty(flgFull))
    flgFull = 0;
end

%% Main Function:

TopLevelSim = bdroot(blockName);
flgIsCompiled = strcmp(get_param(TopLevelSim, 'SimulationStatus'), 'paused');

%  Compile Inports
hInports = find_system(blockName, 'FindAll', 'on', ...
    'FollowLinks', 'on', 'LookUnderMasks', 'all', 'BlockType', 'Inport');
nin = size(hInports,1);
iinCtr = 0;
    
for iin = 1:nin
    hPort = hInports(iin);
    strInport = get_param(hPort, 'Name');
    hPortParent = get_param(hPort, 'Parent');
    
    if(strcmp(hPortParent, blockName))
        iinCtr = iinCtr + 1;
        
        if(flgFull)
            strInport = [blockName '/' strInport];
        end
        
        lstInports(iinCtr, 1) = { strInport };

        if(flgIsCompiled)
            PortData = get_param(hPort, 'CompiledPortDimensions');
           strPortDim = PortData.Outport(2);
           lstInports(iinCtr, 2) = { strPortDim };
            
           PortData = get_param(hPort, 'CompiledPortDataTypes');
           strPortType = PortData.Outport{:};
           lstInports(iinCtr, 3) = { strPortType };
           
        else
            PortDim = get_param(hPort, 'PortDimensions');
            lstInports(iinCtr, 2) = { num2str(PortDim) };
            
            strPortType = get_param(hPort, 'OutDataTypeStr');
            lstInports(iinCtr, 3) = { strPortType };
        end
    end
end
    
%   Compile Outports
hOutports = find_system(blockName, 'FindAll', 'on', ...
    'FollowLinks', 'on', 'LookUnderMasks', 'all', 'BlockType', 'Outport');
nout = size(hOutports,1);
    
ioutCtr = 0;

for iout = 1:nout
    hPort = hOutports(iout);
    strOutport = get_param(hPort, 'Name');
     hPortParent = get_param(hPort, 'Parent');
     
     if(strcmp(hPortParent, blockName))
         ioutCtr = ioutCtr + 1;

         if(flgFull)
             strOutport = [blockName '/' strOutport];
         end
         lstOutports(ioutCtr, 1) = { strOutport };
                  
         if(flgIsCompiled)
             PortData = get_param(hPort, 'CompiledPortDimensions');
             strPortDim = PortData.Inport(2);
             lstOutports(ioutCtr, 2) = { strPortDim };
             
             PortData = get_param(hPort, 'CompiledPortDataTypes');
             strPortType = PortData.Inport{:};
             lstOutports(ioutCtr, 3) = { strPortType };
         else
             PortDim = get_param(hPort, 'PortDimensions');
             lstOutports(ioutCtr, 2) = { num2str(PortDim) };
             
             strPortType = get_param(hPort, 'OutDataTypeStr');
             lstOutports(ioutCtr, 3) = {strPortType };
         end
     end
end

end % << End of function findPorts >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 100818 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName  :  Email  :  NGGN Username 
% <initials>: <Fullname> : <email> : <NGGN username> 

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
