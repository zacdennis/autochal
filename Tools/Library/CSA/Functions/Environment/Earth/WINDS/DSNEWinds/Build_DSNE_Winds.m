%% NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I
%
% WARNING - This document contains technical data whose export is 
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50, 
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% Build_DSNE_Winds.m
% Design Specification Natural Environment Builder
%   (Worst Case Scenario Winds for Kennedy Space Center)
%   Build script to create DSNE_Winds.mat from DSNE_Winds.xls

%% Open the Excel Table:
[num, txt, raw] = xlsread('DSNE_Winds.xls');

DSNE_Wind.Title = 'Design Specification Natural Environment (KSC Worst Case)';
DSNE_Wind.Source = 'Kevin Rawson, Northrop Grumman Mission Systems';
DSNE_Wind.info = {'Original DSNE data goes to 1524 m.  Increased this to'
    '20,000 m, using the same values that occured at 1524 m. NGMS SBCA KCR'
    '6/25/06.  DSNE_Wind.velocity is the peak wind velocity (m/s), and '
    'DSNE_Wind.azimuth is the wind direction (going to, as opposed to '
    'coming from)'};

DSNE_Wind.AllUnits.azimuth      = '[deg]';
DSNE_Wind.AllUnits.altitude     = '[m]';
DSNE_Wind.AllUnits.peak_vel     = '[m/s]';
DSNE_Wind.AllUnits.steady_vel   = '[m/s]';

% Must add 180°, since wind direction is from, instead of to
DSNE_Wind.azimuth  = [num(:, 3) + 180; num(end, 3) + 180];  % [deg]
DSNE_Wind.altitude = [num(:, 1); 20000] ;                   % [m]    
DSNE_Wind.peak_vel   = [num(:, 7); num(end, 7)] ;           % [m/s]
DSNE_Wind.steady_vel = [num(:, 5); num(end, 5)] ;           % [m/s]

save DSNE_Winds DSNE_Wind
clear DSNE_Wind num txt raw 