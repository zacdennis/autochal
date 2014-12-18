% BUILDBUSOBJECT Creates a Bus Object from a Cell Array
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BuildBusObject:
%     Creates User Defined Bus Objects based on a cell array.  Function is
%     set up to handle nested buses.
% 
% SYNTAX:
%	[BusObject] = BuildBusObject(BOname, ICD)
%
% INPUTS: 
%	Name     	Size		Units		Description
%   BOname      [string]                Desired Name of Bus Object
%   ICD         {Nx3}                   Cell array containing bus object
%                                        definitions where...
%    ICD(:,1)   'string'    [char]      Name of Bus Signal
%    ICD(:,2)   [1]         [int]       Dimension of Bus Signal
%                                        Optional: Default is [1]
%    ICD(:,3)   'string'    [char]      Datatype of Bus Signal 
%                                        (e.g. 'double', 'single')
%                                        Optional: Default is 'double'
% OUTPUTS: 
%	Name     	Size		Units		Description
%   BusObject   {BusObject}             The Bus object containing all the
%                                       defined elements.
%
% NOTES:
%   None
%
% EXAMPLES:
% % Create Bus1 using default values:
% lstBO = {
%     'Alpha';
%     'Beta';
%     };
% BuildBusObject('BOBus1', lstBO); clear lstBO;
% 
% % Create Bus2 using user-defined values:
% lstBO = {
%     'WOW'       1   'boolean';
%     'Pned'      3   'single';
%     };
% BuildBusObject('BOBus2', lstBO); clear lstBO;
% 
% % Create Bus3 which is a combo of Bus1 and Bus2
% lstBO = {
%     'Bus1'      1,  'BOBus1';
%     'Bus2'      1,  'BOBus2';
%     'RandomSignal'      1,  '';
%     };
% BuildBusObject('BOBus3', lstBO); clear lstBO;
%
% % Note that this method works as well...
% % Create Bus4 which is a combo of Bus1 and Bus2
% lstBO = {
%     'Bus1'      'BOBus1';
%     'Bus2'      'BOBus2';
%     'RandomSignal'      1;
%     };
% BuildBusObject('BOBus4', lstBO); clear lstBO;
%
% SOURCE DOCUMENTATION:
%   None
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit BuildBusObject.m">BuildBusObject.m</a>
%	  Driver script: <a href="matlab:edit Driver_BuildBusObject.m">Driver_BuildBusObject.m</a>
%	  Documentation: <a href="matlab:pptOpen('BuildBusObject_Function_Documentation.pptx');">BuildBusObject_Function_Documentation.pptx</a>
%
% See also BusObject2List, CreateTestHarness, CreateVec2BO
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/526
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21)
%                Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/BuildBusObject.m $
% $Rev: 3164 $
% $Date: 2014-05-13 12:41:31 -0500 (Tue, 13 May 2014) $
% $Author: sufanmi $

function [BusObject] = BuildBusObject(BOname, ICD)

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

%% Build Bus Object Elements:
numParam = size(ICD, 1);
numCols  = size(ICD, 2);

for iParam = 1:numParam
    curParam = ICD{iParam, 1};

    if(numCols < 2)
        dimParam = 1;
    else
        dimParam = ICD{iParam, 2};
    end
    
    if(numCols < 3)
        if(ischar(dimParam))
            curDataType = dimParam;
            dimParam = 1;
        else
            curDataType = '';
        end
    else
        curDataType = ICD{iParam, 3};
    end
   
    if(numCols < 4)
        curUnits = '';
    else
        curUnits = ICD{iParam, 4};
    end
    
    if(isempty(dimParam))
        dimParam = 1;
    end

    if(isempty(curDataType))
        curDataType = 'double';
    end

    elems(iParam)               = Simulink.BusElement;
    elems(iParam).Name          = curParam;
    elems(iParam).DataType      = curDataType;
    elems(iParam).Complexity    = 'real';
    elems(iParam).Dimensions    = dimParam;
    elems(iParam).SamplingMode  = 'Sample based';
    elems(iParam).SampleTime    = -1;
%     elems(iParam).Min           = '[]';
%     elems(iParam).Max           = '[]';
    
if(isprop(elems(iParam), 'DocUnits'))
    % Introduced in 2012b
    elems(iParam).DocUnits      = curUnits;
end
    
end

%% Build Bus Object:
BusObject = Simulink.Bus;
BusObject.HeaderFile = '';
BusObject.Description = '';
BusObject.Elements = elems;
assignin('base', BOname, BusObject);

%% Compile Outputs:
%	BusObject= -1;

end % << End of function BuildBusObject >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Used CreateNewFunc to reformat internal documentation
% 081008 MWS: Created function for old VSI Library
%              https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/SIMULINK_UTILITIES/BuildBusObject.m
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
