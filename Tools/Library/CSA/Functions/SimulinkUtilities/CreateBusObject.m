% CREATEBUSOBJECT Creates a non-virtual bus from virtual bus creator block.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateBusObject:
%   Creates a Bus Object (non-virtual bus) from a user selected virtual bus
%   creator block. The user is prompted to click on the bus creator block
%   of his/her choice and the function will create the bus object and the
%   bus object creation script of the same name prefixed by 'bo_'.
% 
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/535
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CreateBusObject.m $
% $Rev: 2918 $
% $Date: 2013-03-18 21:04:41 -0500 (Mon, 18 Mar 2013) $
% $Author: salluda $

function [] = CreateBusObject(block)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

clc;

if nargin < 1
    disp('Click on the bus creator you wish to convert to a nonvirtual bus object');
    disp('Press any key');
    disp(' ');
    pause
    block = gcb;
end
    system = gcs;
    model = bdroot(gcs);

disp(['Found block: ' system ' ' block]);
disp(' ');
% Check to see if it is a BusCreator block:
if( strcmp(get_param(block, 'BlockType'), 'BusCreator') )
    disp('The block you selected is indeed a BusCreator.');
    
    % Check to see if there is a BusObject specified already:
    if (strcmp(get_param(block, 'UseBusObject'), 'on'))
        disp('A Bus Object is already specified for this BusCreator.')
        disp(' ');
        disp('You should try changing this BusCreator to');
        disp('not use a BusObject prior to using this function.');
        disp('Exiting.');
        return;
    end
    
    % Get the bus name from the bus creator:
    p = get_param(block, 'PortHandles');
    l = get_param(p.Outport, 'Line');
    BusNameCreated = get_param(l, 'Name');
    
    disp(['The bus name found is: ' BusNameCreated]);
    
    % Check to see if the bus definition file exists already:
    if ( exist(['Build_BO_' BusNameCreated], 'file') == 2)
        disp(['The bus definition file bo_' BusNameCreated '.m already exists']);
        disp('The file will be replaced.');
        
        delete(['Build_BO_' BusNameCreated '.m']);
    end
    
    % Check to see if the bus exists in the workspace:
    BOexists = evalin('base', ['exist(''' BusNameCreated ''', ''var'')']);
    if ( BOexists == 1)
        disp(['The bus: ' BusNameCreated ' already exists']);
        disp('(Replacing BusObject variable)');
        
        evalin('base', ['clear ' BusNameCreated]);
    end
    
    Simulink.Bus.createObject(model, block, ['Build_BO_' BusNameCreated], 'cell');
    
    % Convert the Bus Creator over to using the BusObject:
    % Must first ensure that the model is not still updating/initializing.
    % This is required for larger models because a model update occurs
    % before creating the BusObject and it may take a while:
    disp('Ensuring model is unlocked...');
    SimStatus = get_param(model, 'SimulationStatus');    
    while ( (strcmpi(SimStatus, 'updating')) || (strcmpi(SimStatus, 'initializing')) )
        pause(0.05);
        disp('...');
    end
    
    
    disp('Model is unlocked');

    
    % Proceed with setting the BusObject:
    set_param(block, 'UseBusObject', 'on');
    set_param(block, 'BusObject', BusNameCreated);
    disp([BusNameCreated ' is now specified for use in the BusCreator']);
    
    disp('Created Bus Object build script:');
    disp(['Build_BO_' BusNameCreated '.m']);
    
else
    disp('The block you selected is not a BusCreator');
    disp('Please try again and select a BusCreator.');
    disp('Exiting.')
    return;
end

end % << End of function CreateBusObject >>

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
