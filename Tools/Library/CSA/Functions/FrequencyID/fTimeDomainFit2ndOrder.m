% FTIMEDOMAINFIT2NDORDER Computes 2nd order dynamics of time history
% response
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% fTimeDomainFit2ndOrder:
%     Performs a 2nd order time domain fit of inputted data 
% 
% SYNTAX:
%	[K,wn,zn,tau] = fTimeDomainFit2ndOrder(t, u, y, flgPlotAtEnd, flgWatchFit)
%	[K,wn,zn,tau] = fTimeDomainFit2ndOrder(t, u, y, flgPlotAtEnd)
%	[K,wn,zn,tau] = fTimeDomainFit2ndOrder(t, u, y)
%
% INPUTS: 
%	Name            Size	Units       Description
%	 t              [Nx1]   [sec]       Time Vector
%    u              [Nx1]   [N/A]       Commanded Input
%    y              [Nx1]   [N/A]       Recorded Output
%    flgPlotAtEnd   [1]     ["bool"]    (0 or 1), Plot the final fit?
%                                        Default: 0 (no)
%    flgWatchFit    [1]     ["bool"]    (0 or 1), Plot the fit as it happens?
%                                        Default: 0 (no)
%
% OUTPUTS: 
%	Name        Size	Units       Description
%	 K          [1]     [ND]        Gain
%	 wn         [1]     [rad/sec]	Natural Frequency
%	 zn         [1]     [ND]        Damping Ratio
%	 tau        [1]     [sec]       Time Delay
%
% NOTES:
%
% EXAMPLE:
%  % Creates a 2nd order system, runs a step through it, and then fits 
%  %  the data to the response.
%   clc;
%   %  Build the Truth 2nd Order System:
%   K = 1;                              % [non-dimensional]
%   wn = 1;                             % [rad/sec]
%   zn = 0.7;                           % [non-dimensional]
%   A=[[0 1];[-wn^2 -2*zn*wn]];         % 2nd Order system
%   B=[0;K*wn^2];
%   C=[1 0];
%   D=[0];
%   sys = ss(A,B,C,D);
%   %  Run the 2nd Order System with a Step Response:
%   t = [0:.01:20]';                    % [sec]
%   u = t * 0;                          % Builds the command
%   u(find(t>=1)) = 1;                  % Adds a step at 1 [sec]
%   y = lsim(sys, u, t);                % Runs the system
%   %  Fit the Response to Recover original 2nd Order Paramters:
%   flgPlotAtEnd = 1;                   % Plot the final fit?
%   flgWatchFit = 1;                    % Plot the fit as it happens?
%   [K_fit, wn_fit, zn_fit, tau_fit]= fTimeDomainFit2ndOrder(t, u, y, flgPlotAtEnd, flgWatchFit)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit fTimeDomainFit2ndOrder.m">fTimeDomainFit2ndOrder.m</a>
%	  Driver script: <a href="matlab:edit Driver_fTimeDomainFit2ndOrder.m">Driver_fTimeDomainFit2ndOrder.m</a>
%	  Documentation: <a href="matlab:pptOpen('fTimeDomainFit2ndOrder_Function_Documentation.pptx');">fTimeDomainFit2ndOrder_Function_Documentation.pptx</a>
%
% See also fTimeDomainFit1stOrder, FreqDomainID
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/619
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/FrequencyID/fTimeDomainFit2ndOrder.m $
% $Rev:: $
% $Date:: $

function [K,wn,zn,tau] = fTimeDomainFit2ndOrder(t,u,y,flgPlotAtEnd,flgWatchFit)

if(nargin < 5)
    flgWatchFit = 0;
end

if(nargin < 4)
    flgPlotAtEnd = 0;
end

%% Set Initial Guess
K = 1.0;
wn = 10.0;
zn = 0.7;
tau = 0.0;
Xo = [K wn zn tau];

%% Call Optimal Search Algorithm
X = fminsearch(@(X) fCost(X,t,u,y,0,flgWatchFit),Xo);

%% Extract Results
K = X(1);
wn = X(2);
zn = X(3);
tau = X(4);

if(flgPlotAtEnd)
    fCost(X,t,u,y,1,0);
end

return;

%% Search Cost Function
function J = fCost(X,t,u,y,flgPlot,flgWatchFitPlot)
%% Extract Linear Model Parameters
K = X(1);
wn = X(2);
zn = X(3);
tau = X(4);

% Generate Cost
if (tau<0)
% If tau is less than zero set cost to infinity to ensure positive time delays
    J = inf;
else
    % Create linear system
%     sys = tf([K*wn^2],[1 2*zn*wn wn^2]);
%     [A,B,C,D] = ssdata(sys);
    
    A=[[0 1];[-wn^2 -2*zn*wn]];
    B=[0;K*wn^2];
    C=[1 0];
    D=[0];
    
    clear sys;
    sys = ss(A,B,C,D);
    
    set(sys,'InputDelay',tau);
    
    ul = u-u(1);
    yl = y-y(1);
    tl = t-t(1);
    
    % Set initial condition
    xo(1) = ul(1)*K;
    xo(2) = (ul(2)-ul(1))/(tl(2)-tl(1))*K;
    % Simulate linear system
    [Y,T,X] = lsim(sys,ul,tl,xo);
    % Compute cost as the square of the error between the LOES & the time
    % history provided.
    n=size(Y,1);
    J = 0;
    for i=[1:n]
        J = J + (Y(i)-yl(i))^2;
    end
    
    if(flgPlot || flgWatchFitPlot)
        if(flgPlot)
            figure();
        end
        
        if(flgWatchFitPlot)
            figure(99);
        end
        clf;
        
        subplot(211);
        h(1) = plot(t,u, 'r--', 'LineWidth', 1.5); hold on;
        h(2) = plot(t,y, 'g-', 'LineWidth', 1.5);
        h(3) = plot(t, Y+y(1), 'b-.', 'LineWidth', 1.5);
        
        ylabel('\bfAmp');
        set(gca, 'FontWeight', 'bold'); grid on;
        strLegend = {'Cmd', 'Response', 'Fit'};
        legend(strLegend, 'Location', 'SouthEast');
        
        strTitle(1,:) = { sprintf('\\bf\\fontsize{12}2^{nd} Order Fit using ''fTimeDomainFit2ndOrder.m''') };
        strTitle(2,:) = { sprintf('\\fontsize{10}K = %.5f, \\omega_N = %.5f [rad/sec], \\zeta = %.5f, \\tau = %.5f [sec]', ...
            K, wn, zn, tau) };
        title(strTitle);
        
        subplot(212);
        plot(t,((Y+y(1)) - y), 'b-', 'LineWidth', 1.5);
        set(gca, 'FontWeight', 'bold'); grid on;
        ylabel('\bfFit Error');
        xlabel('\bfTime [sec]');
        
    end
end

return;

%% REVISION HISTORY
% YYMMDD INI: note
% 100805 MWS: Cleaned up function using CreateNewFunc
%             Originally developed by Elaine Shaw on AAR program:  
%             https://vodka.ccc.northgrum.com/svn/AAR/trunk/Simulation/FlightTest/Analysis/InnerLoopID/fTimeDomainFit.m
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         : Email     : NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi
% ES:  Elaine Shaw      : elaine.shaw@ngc.com   : shawel

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
