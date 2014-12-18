% RESULTS2IC script to get states at the end and apply them to IC's of a new run 
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Results2IC.m
%   Code for pulling the state values at the end of a time history and 
%   applying them to the intial conditions of a new run
%   Calls:
%     Construct_Results2IC
%     GetBusState
%     lst
%     ParseAll
%     PropagateTimestep
%     
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/657
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/Results2IC.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

%% Main Code
%% Make the Results structure from the model output

ParseAll;

%% Get Last States for all vessels

LastStates.CM = GetBusState( Results.CM.StateBus );
LastStates.SM = GetBusState( Results.SM.StateBus );
LastStates.LAS = GetBusState( Results.LAS.StateBus );
LastStates.CLV = GetBusState( Results.CLV.StateBus );

%% Grab LST
lst0 = LastStates.CM.LST;

%% Compute New Epoch
 
 Time.EpochStart = PropagateTimestep(Time.EpochStart, LastStates.CM.simtime);
 Time.EpochStart(7) = 0;   %Dummy Longitude value
 
%% Run new Epoch to find new MST
Time.mst = lst( Time.EpochStart );    % [deg]
Time.EpochDay = datenum(Time.EpochStart(1:6));
Time.EpochString = [datestr(Time.EpochStart(1:6), ' dd mmm yyyy HH:MM:SS.FFF UTCG')];
Time.EpochStrSTK = [datestr(Time.EpochStart(1:6), 'dd mmm yyyy HH:MM:SS.FFF')];

 
%% Rewrite ICs

Units = CM.IC.Units;

CM.IC = Construct_Results2IC(LastStates.CM, Units, 'CM ');
SM.IC = Construct_Results2IC(LastStates.SM, Units, 'SM ');

% LAS.IC AbortStartTime initialized but not stored in Results
 AbortStartTimeHold = LAS.IC.AbortStartTime - LastStates.LAS.simtime;
 if AbortStartTimeHold < 0
     AbortStartTimeHold = 0;
 end
 
LAS.IC = Construct_Results2IC(LastStates.LAS, Units, 'LAS');
LAS.IC.AbortStartTime = AbortStartTimeHold;

% CLV.IC carries a title and Timealoft value
TitleHold = CLV.IC.Title;
TimealoftHold = CLV.IC.timealoft - LastStates.CLV.simtime;
if TimealoftHold < 0
    TimealoftHold = 0;
end

CLV.IC = Construct_Results2IC(LastStates.CLV, Units, 'CLV');
CLV.IC.Title = TitleHold;
CLV.IC.timealoft = TimealoftHold;

%% << End of Script Results2IC.m >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720

%% FOOTER
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
