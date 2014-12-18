% BUSOBJECT2LIST Lists all the elements in a BusObject
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BusObject2List:
%     Lists all the elements in a BusObject.  Note that this is a recursive
%     function.
% 
% SYNTAX:
%	[lstMaster] = BusObject2List(curBusObject)
%
% INPUTS: 
%	Name        	Size		Units		Description
%   curBusObject                            Overloaded input with 2 options
%     (option #1)   'string'    [char]      Name of Bus Object
%     (option #2)   [Simulink.Bus]          Actual Bus Object
%	pathElement     'string'    [char]      Current sub bus (used by
%                                               recursive call)
%	lstMaster	   {Nx4}        [varies]    Current list of members (used
%                                               by recursive call)
%
% OUTPUTS: 
%	Name        	Size		Units		Description
%   lstMaster       {cell array} Output     Argument List where...
%    {:,1}:         'string'    [char]      Full Path to Signal in 
%                                            BusObject
%    {:,2}:         [1]         [int]       Signal Dimension
%    {:,3}:         'string'    [char]      Signal datatype
%    {:,4}:         'string'    [char]      Reference Parent BusObject
%
% NOTES:
%   This is a recursive function.  Additional input arguments are used by
%   the recursive function.  They are not to be used by the user.
%
% EXAMPLES:
%
% lstBO = {
%     'WOW'       1   'boolean';
%     'Pned'      3   'single';
%     };
% BuildBusObject('BOBus1', {'Pned' 3});
% BuildBusObject('BOBus2', {'WOW'  1  'boolean'});
% lstBO = {
%     'Bus1'      1,  'BOBus1';
%     'Bus2'      1,  'BOBus2';
%     'Mode'      1,  '';
%     };
% BuildBusObject('BOBus3', lstBO); clear lstBO;
%
% BusObject2List('BOBus3')
% ans = 
%     'Bus1.Pned'    [3]    'double'     'BOBus1'
%     'Bus2.WOW'     [1]    'boolean'    'BOBus2'
%     'Mode'         [1]    'double'     'BOBus3'
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit BusObject2List.m">BusObject2List.m</a>
%	  Driver script: <a href="matlab:edit Driver_BusObject2List.m">Driver_BusObject2List.m</a>
%	  Documentation: <a href="matlab:pptOpen('BusObject2List_Function_Documentation.pptx');">BusObject2List_Function_Documentation.pptx</a>
%
% See also BuildBusObject, CreateTestHarness
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/528
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21)
%                Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/BusObject2List.m $
% $Rev: 3284 $
% $Date: 2014-10-23 13:31:31 -0500 (Thu, 23 Oct 2014) $
% $Author: sufanmi $

function [lstMaster] = BusObject2List(curBusObject, pathElement, lstMaster)

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
if(nargin < 3)
    lstMaster = {};
    flgRecurse = 0;
else
    flgRecurse = 1;
end

if(nargin < 2)
    pathElement = '';
end

if(ischar(curBusObject))
    strBusObject = curBusObject;
    curBus = evalin('base', curBusObject);
    
else
    strBusObject = inputname(1);
    curBus = curBusObject;
end
numElements = size(curBus.Elements, 1);

for iElement = 1:numElements
    curElement = curBus.Elements(iElement);

    curName     = curElement.Name;
    curDataType = curElement.DataType;  

    lstNumeric = {
        'double';
        'single';
        'int8';
        'uint8';
        'int16';
        'uint16';
        'int32';
        'uint32';
        'boolean';
        };
    
    flgIsNumeric = any(strcmp(lstNumeric, curDataType));
    flgIsBO = ~flgIsNumeric;

    if(flgIsBO)
        % It's a Bus Object, Recurse Into it:
        if(flgRecurse)
            if(~isempty(pathElement))
                curName = [pathElement '.' curName];
            end
        end
%         lstMaster = BusObject2List(curDataType, curName, lstMaster);
        lst2add = BusObject2List(curDataType, curName, {});
        lst2add(:,4) = {curDataType};
        lstMaster = [lstMaster; lst2add];
    else
        % It's a Signal, log it:
        if(isempty(pathElement))
            pathSignal = curName;
        else
            pathSignal = [pathElement '.' curName];
        end
                
        signalDim = curElement.Dimensions;
        ictr = size(lstMaster, 1) + 1;
        lstMaster{ictr,1} = pathSignal;
        lstMaster{ictr,2} = signalDim;
        lstMaster{ictr,3} = curDataType;
        
        if(~ischar(curBusObject))
            lstMaster{ictr,4} = '';
        else
            lstMaster{ictr,4} = curBusObject;
        end
        
        % Units are supported in R2012b (not supported in R2012a and prior)
        try
            curDocUnits = curElement.DocUnits;
        catch
            curDocUnits = '';
        end
        lstMaster{ictr,5} = curDocUnits;
    end    
end

end % << End of function BusObject2List >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Used CreateNewFunc to update internal documentation
% 081008 MWS: Created function as complement to BuildBusObject in VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/SIMULINK_UTILITIES/BusObject2List.m
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
