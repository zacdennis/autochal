% CLEANBLOCKPORTS Updates a Simulink Model's Input and Output ports to the CSA standard
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CleanBlockPorts:
%     This function formats a Simulink block's inputs and outputs for
%     background color and name to the CSA standard:
%       Input port background color:    green
%       Output port background color:   gray
%
%     For port names, no spaces or special characters (e.g. '/') are used.
%       -All spaces are converted to underscores, '_'
%       -All slashes ('/'), which may be used to describe desired units,
%       are converted to '_per_' unless a typical unit string is
%       encountered, like 'deg/sec' which would be converted to 'dps'
%   
% SYNTAX:
%	[lstEdits] = CleanBlockPorts(BlockName, varargin, 'PropertyName', PropertyValue))
%	[lstEdits] = CleanBlockPorts(BlockName, varargin)
%	[lstEdits] = CleanBlockPorts(BlockName)
%
% INPUTS:
%	Name		Size		Units		Description
%	BlockName	'string'    [char]      Name of Simulink block
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS:
%	Name		Size		Units		Description
%	lstEdits	{Nx1}       {'string'}  Cell array of strings listing what
%                                       edit was applied to which port
%
% NOTES:
%   This function uses the CSA_LIB functions: format_varargin
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'InputPortColor'    'string'        'Green'     Background color for
%                                                    input ports
%   'OutputPortColor'   'string'        'Gray'      Background color for
%                                                    output ports
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[lstEdits] = CleanBlockPorts(BlockName)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CleanBlockPorts.m">CleanBlockPorts.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_CleanBlockPorts.m">DRIVER_CleanBlockPorts.m</a>
%	  Documentation: <a href="matlab:pptOpen('CleanBlockPorts Documentation.pptx');">CleanBlockPorts Documentation.pptx</a>
%
% See also <add relevant functions>
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/633
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoSMO_Utilities/CleanBlockPorts.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [lstEdits] = CleanBlockPorts(blockName, varargin)

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

% Pick out Properties Entered via varargin
[inputPortColor, varargin]  = format_varargin('InputPortColor', 'Green', 2, varargin);
[outputPortColor, varargin] = format_varargin('OutputPortColor', 'gray', 2, varargin);
[LookUnderMasks, varargin] = format_varargin('LookUnderMasks', 'all', 2, varargin);
[FixColorOnly, varargin] = format_varargin('ColorOnly', false, 2, varargin);

%% Initialize Outputs:
lstEdits= {}; iCtr = 0;

% lstPortNameNoNos(:,1):    What to look for (e.g. a no-no)
% lstPortNameNoNos(:,2):    What it should be
lstPortNameNoNos = {...
    '('         '';
    ')'         '';
    '-'         '';
    'rad/sec'   'rps';
    'rad/s'     'rps';
    'r/s'       'rps';
    'deg/sec'   'dps';
    'd/sec'     'dps';
    'd/s'       'dps';
    '/'         '_per_';
    ' '         '_';
    '__'        '_';
    endl        '_';
    };

%% Main Function:

%  Compile Inports
hInports = find_system(blockName, 'FindAll', 'on', ...
    'LookUnderMasks', LookUnderMasks, 'BlockType', 'Inport');
nin = size(hInports,1);

for iin = 1:nin
    hPort = hInports(iin);
    strInport = get_param(hPort, 'Name');
    hPortParent = get_param(hPort, 'Parent');
    idxPort = get_param(hPort,'Port');
    strEdit = sprintf('%s/%s (Inport #%s)', hPortParent, strInport, idxPort);
    
    if(~FixColorOnly)
        for iName = 1:size(lstPortNameNoNos, 1)
            curNoNo = lstPortNameNoNos{iName, 1};
            
            if(strfind(strInport, curNoNo))
                curReplace = lstPortNameNoNos{iName, 2};
                strInportOld = strInport;
                strInport = strrep(strInport, curNoNo, curReplace);
                iCtr = iCtr + 1; lstEdits(iCtr,:) = { sprintf('%s : Name Fix: Changed %s to %s', strEdit, strInportOld, strInport) };
                set_param(hPort, 'Name', strInport);
            end
        end
    end
    
    PortColor = get_param(hPort, 'BackgroundColor');
    if(~strcmp(lower(PortColor), lower(inputPortColor)))
        set_param(hPort, 'BackgroundColor', inputPortColor);
        iCtr = iCtr + 1; lstEdits(iCtr,:) = { sprintf('%s : Changed Background Color to %s', strEdit, inputPortColor)};
    end
end

%   Compile Outports
hOutports = find_system(blockName, 'FindAll', 'on', ...
    'LookUnderMasks', LookUnderMasks, 'BlockType', 'Outport');
nout = size(hOutports,1);

ioutCtr = 0;

for iout = 1:nout
    hPort = hOutports(iout);
    strOutport = get_param(hPort, 'Name');
    hPortParent = get_param(hPort, 'Parent');
    idxPort = get_param(hPort,'Port');
    strEdit = sprintf('%s/%s (Outport #%s)', hPortParent, strOutport, idxPort);
    
    if(~FixColorOnly)
        
        for iName = 1:size(lstPortNameNoNos, 1)
            curNoNo = lstPortNameNoNos{iName, 1};
            
            if(strfind(strOutport, curNoNo))
                curReplace = lstPortNameNoNos{iName, 2};
                strOutportOld = strOutport;
                strOutport = strrep(strOutport, curNoNo, curReplace);
                iCtr = iCtr + 1; lstEdits(iCtr,:) = { sprintf('%s : Name Fix: Changed %s to %s', strEdit, strOutportOld, strOutport) };
                set_param(hPort, 'Name', strOutport);
            end
        end
    end
    
    PortColor = get_param(hPort, 'BackgroundColor');
    if(~strcmp(lower(PortColor), lower(outputPortColor)))
        set_param(hPort, 'BackgroundColor', outputPortColor);
        iCtr = iCtr + 1; lstEdits(iCtr,:) = { sprintf('%s : Changed Background Color to %s', strEdit, outputPortColor)};
    end
    %     end
end

end % << End of function CleanBlockPorts >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101022 JPG: Added description sentence.
% 100823 MWS: Function template created using CreateNewFunc
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
