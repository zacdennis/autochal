% UPGRADE_VSI_TO_CSA Upgrades All Simulink Models from the VSI to CSA
% Library
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Upgrade_VSI_to_CSA:
%   This function upgrades all Simulink models to reference the CSA_Library
%   instead of the VSI_Library.  The function first finds all the Simulink
%   models (.mdl) within the provided 'RootFolder'.  Cyling through each
%   model, the function first checks to see if any members of the inputted
%   'lstExclude' are present.  If they are not, all references to the
%   VSI_Library are replaced with their CSA_Library equivalent.  Note that
%   some VSI_Library blocks have had their names changed when they were
%   ported over to the CSA_Library.
%
% SYNTAX:
%	[lstUpgrade] = Upgrade_VSI_to_CSA(RootFolder, lstExclude)
%	[lstUpgrade] = Upgrade_VSI_to_CSA(RootFolder)
%	[lstUpgrade] = Upgrade_VSI_to_CSA()
%
% INPUTS:
%	Name            Size		Units		Description
%	RootFolder		'string'    N/A         Root Folder in which to begin
%                                            upgrade
%                                            Default: pwd
%   lstExclude      {'string'}  N/A         Cell array of strings to look
%                                            when deciding if a particular 
%                                            model is to be upgraded
%                                            Default: {'CSA_Library'; 
%                                            'SimulinkBlockVerification'}
% OUTPUTS:
%	Name            Size		Units		Description
%   lstUpgrade      {'string'}  N/A         Log output of all files
%                                            modified in cell array of 
%                                            string format
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[lstUpgrade] = Upgrade_VSI_to_CSA(RootFolder)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[lstUpgrade] = Upgrade_VSI_to_CSA(RootFolder)
%	% <Copy expected outputs from Command Window>
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Upgrade_VSI_to_CSA.m">Upgrade_VSI_to_CSA.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_Upgrade_VSI_to_CSA.m">DRIVER_Upgrade_VSI_to_CSA.m</a>
%	  Documentation: <a href="matlab:pptOpen('Upgrade_VSI_to_CSA Documentation.pptx');">Upgrade_VSI_to_CSA Documentation.pptx</a>
%
% See also <add relevant functions>
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/640
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoSMO_Utilities/Upgrade_VSI_to_CSA.m $
% $Rev: 2348 $
% $Date: 2012-07-10 12:34:04 -0500 (Tue, 10 Jul 2012) $
% $Author: sufanmi $

function [lstUpgrade] = Upgrade_VSI_to_CSA(RootFolder, lstExclude)

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
lstUpgrade= {};

%% Input Argument Conditioning:
switch(nargin)
    case 0
        lstExclude = {'CSA_Library';'SimulinkBlockVerification'};      
        RootFolder = '';
    case 1
        lstExclude = {'CSA_Library';'SimulinkBlockVerification'};      
end

if(isempty(RootFolder))
    RootFolder = pwd;
end

%% Main Function:

% Close all Cached Simulink Libraries
close_system(find_system('type', 'block_diagram'));

%% Create List of Items to Replace/Rename
i = 0;
% lstReplace(:,1): Old Name
% lstReplace(:,2): New Name

% General Updates
i = i + 1; lstReplace(i,:) = {'VSI_Library', 'CSA_Library'};

% Updated Utilities
i = i + 1; lstReplace(i,:) = {'CSA_Library/Utilities/-180<ang<180',         'CSA_Library/Utilities/Wrap180'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Utilities/-pi<ang<pi',           'CSA_Library/Utilities/WrapPi'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Utilities/0<ang<2*pi',           'CSA_Library/Utilities/Wrap2Pi'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Utilities/0<ang<360',            'CSA_Library/Utilities/Wrap360'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Utilities/Detect\nIncrease',     'CSA_Library/Utilities/DetectIncrease'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Utilities/Genereic_2D_Lookup',   'CSA_Library/Utilities/Generic_2D_Lookup'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Utilities/Genereic_3D_Lookup',   'CSA_Library/Utilities/Generic_3D_Lookup'};

i = i + 1; lstReplace(i,:) = {'CSA_Library/Utilities/NGC_CompareGreaterThanConstant',   'CSA_Library/Utilities/CompareToConstant'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Utilities/NGC_CompareLessThanConstant',   'CSA_Library/Utilities/CompareToConstant'};



i = i + 1; lstReplace(i,:) = {'CSA_Library/Utilities/ForcesMoments_Lib',                'CSA_Library/Propulsion/ForcesMoments'};

i = i + 1; lstReplace(i,:) = {'CSA_Library/Utilities/eul2dcm',                  'CSA_Library/CoordinateTransformations/eul2dcm'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Utilities/Vb_2_AlphaBetaVtrue',      'CSA_Library/FlightParameters/Vb_2_AlphaBetaVtrue'};

i = i + 1; lstReplace(i,:) = {'CSA_Library/EOM/BankAngle_Lib',                  'CSA_Library/FlightParameters/BankAngleMu'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/EOM/Vned_2_GammaChiVtrue',           'CSA_Library/FlightParameters/Vned_2_GammaChiVtrue'};

i = i + 1; lstReplace(i,:) = {'CSA_Library/Utilities/Vector_Cross_Product',           'CSA_Library/Utilities/VectorCrossProduct'};



% Updated Environment
i = i + 1; lstReplace(i,:) = {'CSA_Library/Atmosphere/COESA_1976_Atmosphere_Lib',   'CSA_Library/Environment/Atmosphere/Coesa1976'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Atmosphere/SteadyWind',                  'CSA_Library/Environment/Wind/SteadyWind'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Atmosphere/WindShear',                   'CSA_Library/Environment/Wind/WindShear'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Atmosphere/DiscreteGust',                'CSA_Library/Environment/Wind/DiscreteGust'};




% Updated Tools
i = i + 1; lstReplace(i,:) = {'CSA_Library/Tools/Joysticks/Linux/HOTAS Cougar\nUSB Input (busses)',                             'CSA_Library/Tools/Joysticks/Linux/HOTASCougar_USB'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Tools/Joysticks/Linux/Logitech Cordless Freedom 2.4\n USB Input (busses) Linux',     'CSA_Library/Tools/Joysticks/Linux/LogitechCordlessFreedom2p4_USB'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Tools/Joysticks/Linux/S-Function',                                                   'CSA_Library/Tools/Joysticks/Linux/SharedMemory'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Tools/Joysticks/Linux/S-Function1',                                                  'CSA_Library/Tools/Joysticks/Linux/ThreadTest'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Tools/Send_UDP_Any',                                                                 'CSA_Library/Tools/Universal_UDP_Send'};

% STK
i = i + 1; lstReplace(i,:) = {'CSA_Library/STK/Send_UDP_STK_Spaceview',                                 'CSA_Library/STK/udpsend_STK'};

% Updated MassProperties
i = i + 1; lstReplace(i,:) = {'CSA_Library/MassProperties/InertiaMatrixSplitup',                        'CSA_Library/MassProperties/InertiaMatrixSplit'};

% Updated Orbital Dynamics
i = i + 1; lstReplace(i,:) = {'CSA_Library/OrbitalDyanmics', 'CSA_Library/OrbitalDynamics'};

% Updated Coordinate Transformations
i = i + 1; lstReplace(i,:) = {'CSA_Library/CoordinateTransformations/QuatEulerOperations',               'CSA_Library/CoordinateTransformations'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/CoordinateTransformations/Quaternion\nComposition',           'CSA_Library/CoordinateTransformations/QuaternionComposition'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/CoordinateTransformations/Quaternion\nConjugate',             'CSA_Library/CoordinateTransformations/QuaternionConjugate'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/CoordinateTransformations/Quaternion\nDecomposition',         'CSA_Library/CoordinateTransformations/QuaternionDecomposition'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/CoordinateTransformations/Quaternion\nMultiply',              'CSA_Library/CoordinateTransformations/QuaternionMultiply'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/CoordinateTransformations/Quaternion\nVector Rotation',       'CSA_Library/CoordinateTransformations/QuaternionVectorRotation'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/CoordinateTransformations/Quaternion\nVector Transform',      'CSA_Library/CoordinateTransformations/QuaternionVectorTransform'};

% Updated Aerodynamic Functions
i = i + 1; lstReplace(i,:) = {'CSA_Library/Aerodynamics/BodyAxisMomentTransfer_n-D',      'CSA_Library/Aerodynamics/BodyAxisMomentTransfer'};

% Updated Propulsion
i = i + 1; lstReplace(i,:) = {'CSA_Library/Propulsion/Gimbal_to_PointingDir',       'CSA_Library/Propulsion/Gimbal2PointingDir'};
i = i + 1; lstReplace(i,:) = {'CSA_Library/Propulsion/SingleGimbal_2_PointingDir',  'CSA_Library/Propulsion/Gimbal2PointingDir'};


% Find all the libraries
disp([mfnam '>> Finding all Simulink Models...' ]);
lstModels = dir_list('*.mdl', 1, RootFolder, lstExclude);
numModels = size(lstModels, 1);
disp([mfnam '>> ' num2str(numModels) ' found.  Processing upgrade...']);

iUpgrade = 0;   % Initialize Log Counter
% Loop Through all the Models
for iModel = 1:numModels
    curModel = lstModels{iModel, :};

    disp([mfnam '>> Scanning  (' num2str(iModel) '/' num2str(numModels) ...
        ') ' curModel '...']);
    
    for iMem2Replace = 1:size(lstReplace, 1)
        curMem2Lookfor = lstReplace{iMem2Replace, 1};
        curMem2Replace = lstReplace{iMem2Replace, 2};
        nReplaced = txtReplace(curModel, curMem2Lookfor, curMem2Replace);
        
        if(nReplaced > 1)
            strS = 's';
        else
            strS = ' ';
        end
        
        if(nReplaced > 0)
            iUpgrade = iUpgrade + 1;
            
            str2disp = sprintf('Replaced %d instance%s of ''%s'' with ''%s'' in ''%s''', ...
                nReplaced, strS, curMem2Lookfor, curMem2Replace, curModel);
            disp([mfnam '>> ' str2disp]);
            lstUpgrade(iUpgrade,:) = { str2disp }; %#okAGROW
        end
        
    end
end

disp([mfnam '>> Finished!']);

% Close all Cached Simulink Models
close_system(find_system('type', 'block_diagram'));

end % << End of function Upgrade_VSI_to_CSA >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 100902 CNF: Function template created using CreateNewFunc
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
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is
%   subject to severe civil and/or criminal penalties.

% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
