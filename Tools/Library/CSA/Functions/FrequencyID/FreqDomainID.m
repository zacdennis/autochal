% FREQDOMAINID analyze time history in freq. domain, fit a LOES, and plot results for verification
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% FreqDomainID:
%   Frequency Domain Analysis Tool
%   Analyze a time history in the frequency domain and fit a Low Order
%   Equivalent System (LOES) while plotting results for verification. User
%   may specify and order of 1, 2, or 3 for the LOES, or 0 to generate bode 
%   plots without fitting a LOES. Units are left to the user.
% *************************************************************************
% * #NOTE: To future COSMO'er 'order' is also a matlab function.  Perhaps
% * consider changing the variable name. JPG
% *************************************************************************
% SYNTAX:
%	[SystemID] = FreqDomainID(t, u, y, order, Wmin, Wmax, Cgood)
%	[SystemID] = FreqDomainID(t, u, y, order, Wmin, Wmax)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	t   	    [1xn]		[sec]		Time vector
%	u   	    [1xn]		<units>		Time history of inputs (command)
%	y   	    [1xn]		<units>		Time history of outputs (response)
%	order	    [1x1]		<units>		Order desired for LOES for fit (0,
%                                       1, 2, or 3)
%	Wmin	    [1x1]		[rad/sec]	Lowest Frequency of LOES fit
%	Wmax	    [1x1]		[rad/sec]	Highest frequency of LOES fit
%	Cgood	    [1x1]		<units>		Optional range of Cxy threshold for
%                                       fitting.
%                                       Default: Cgood = 0.8;
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	SystemID	Struct		<units>		(Need to add field desrciptions)
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[SystemID] = FreqDomainID(t, u, y, order, Wmin, Wmax, Cgood, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[SystemID] = FreqDomainID(t, u, y, order, Wmin, Wmax, Cgood)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
% Book with One Author:
% [2]   Author Last Name, Author First Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
% Book with Two Author:
% [3]   Author #1 Last Name, Author #1 First Name, and Author #2 Full Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit FreqDomainID.m">FreqDomainID.m</a>
%	  Driver script: <a href="matlab:edit Driver_FreqDomainID.m">Driver_FreqDomainID.m</a>
%	  Documentation: <a href="matlab:pptOpen('FreqDomainID_Function_Documentation.pptx');">FreqDomainID_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/309
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/FrequencyID/FreqDomainID.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [SystemID] = FreqDomainID(t, u, y, order, Wmin, Wmax, Cgood, varargin)
tic;
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

%% Initialize Outputs:
% SystemID= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% ['AllowPlot', varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

AllowPlot = 1;

%% Argument Integrity:
if ~((order == 0) || (order == 1) || order == 2 || order == 3)
    disp('Please specify a LOES order of first (1), second (2), or third (3), or enter (0) to generate Bode plots without a LOES');
end

if nargin < 7
    Cgood = 0.8;
end

SystemID.t = t;
SystemID.u = u;
SystemID.y = y;
SystemID.order = order;



%% Main Function:
%% Create TF based on order:
[SystemID.Wxy, SystemID.Txy, SystemID.Cxy,...
    SystemID.WxyGood, SystemID.TxyGood, SystemID.CxyGood, SystemID.H] =...
    f_nltf(t,u,y, Cgood);

if (order == 0)
    toc
    return;
end

WxyFit=SystemID.WxyGood(find(SystemID.WxyGood > Wmin, 1, 'first'):...
    find(SystemID.WxyGood < Wmax, 1, 'last'));
TxyFit=SystemID.TxyGood(find(SystemID.WxyGood > Wmin, 1, 'first'):...
    find(SystemID.WxyGood < Wmax, 1, 'last'));

if (order == 1)
    [SystemID.tau, SystemID.K] = f_firstordfit(WxyFit,TxyFit);
    SystemID.sys = tf(SystemID.K, [1/SystemID.tau 1]);
    
    if(AllowPlot)
        subplot(3,1,1),title({sprintf('CMD to RESPONSE Transfer Function: LOES K = %6.2f, \\tau = %6.2f', SystemID.K, SystemID.tau), ['Coherence > ' num2str(Cgood) ' for LOES Fit']});
        strTitle(1,:) = { sprintf('\\bf\\fontsize{12}1^{st} Order Fit') };
        strTitle(2,:) = { sprintf('\\fontsize{10}K = %.5f, \\tau = %.5f', ...
            SystemID.K, SystemID.tau) };
    end
end

if (order == 2)
    [SystemID.wn, SystemID.zn, SystemID.K]=f_secordfit(WxyFit,TxyFit);
    SystemID.sys=tf([SystemID.K*SystemID.wn^2],[1 2*SystemID.zn*SystemID.wn SystemID.wn^2]);
    
    if(AllowPlot)
        subplot(3,1,1),title(sprintf('CMD to RESPONSE Transfer Function: LOES \\omega_n = %6.2f, \\zeta_n = %6.2f, K = %6.2f', SystemID.wn, SystemID.zn, SystemID.K));
        strTitle(1,:) = { sprintf('\\bf\\fontsize{12}2^{nd} Order Fit') };
        strTitle(2,:) = { sprintf('\\fontsize{10}K = %.5f, \\omega_N = %.5f, \\zeta = %.5f', ...
            SystemID.K, SystemID.wn, SystemID.zn) };
    end
end

if (order == 3)
    [SystemID.wn, SystemID.zn, SystemID.K, SystemID.tau]=f_thrordfit(WxyFit,TxyFit);
    SystemID.sys=tf([SystemID.K*SystemID.wn^2], conv([1/SystemID.tau 1], [1 2*SystemID.zn*SystemID.wn SystemID.wn^2]));
    
    if(AllowPlot)
        subplot(3,1,1),title(sprintf('CMD to RESPONSE Transfer Function: LOES \\omega_n = %6.2f, \\zeta_n = %6.2f, K = %6.2f, \\tau = %6.2f', SystemID.wn, SystemID.zn, SystemID.K, SystemID.tau));
        strTitle(1,:) = { sprintf('\\bf\\fontsize{12}2^{nd} Order Fit') };
        strTitle(2,:) = { sprintf('\\fontsize{10}K = %.5f, \\omega_N = %.5f, \\zeta_N = %.5f, \\tau = %.5f', ...
            SystemID.K, SystemID.wn, SystemID.zn, SystemID.tau) };
    end
end

%% Compute -3 dB Bandwidth:
SystemID.BW3db = bandwidth3db(SystemID.sys, WxyFit);

%% Plot the Frequency Response:
if(AllowPlot)
[SystemID.Mag, SystemID.Phase] = bode(SystemID.sys, SystemID.WxyGood);
subplot(3,1,1)
hold on; plot(SystemID.WxyGood, 20*log10(squeeze(SystemID.Mag)),'r-', 'LineWidth', 2);
subplot(3,1,2)
hold on; plot(SystemID.WxyGood, squeeze(SystemID.Phase),'r-', 'LineWidth', 2);
hold off;
end

%% Plot the command and response:
if(AllowPlot)
    yCheck = lsim(SystemID.sys, SystemID.u, SystemID.t);
   
    figure()
    h(1) = plot(t,u, 'r--', 'LineWidth', 1.5); hold on;
    h(2) = plot(t,y, 'g-', 'LineWidth', 1.5);
    h(3) = plot(t, yCheck+y(1), 'b-', 'LineWidth', 1.5);
    title(strTitle);
    ylabel('\bfAmp');
    set(gca, 'FontWeight', 'bold'); grid on;
    strLegend = {'Cmd', 'Response', 'Fit'};
    legend(strLegend, 'Location', 'SouthEast');
    xlabel('Time [sec]');
    hold off;
    
end

end

%% f_nltf
function [Wxy,Txy,Cxy,WxyGood,TxyGood,CxyGood,H] = f_nltf(t,u,y,Cgood)
y=y-mean(y);
n=max(size(u));
nfft=2^floor(log2(n/2));
DT=t(n)-t(1);
dt=(t(3)-t(1))/2;
minfreq=1/DT*2*pi;
maxfreq=1/dt*2*pi/2;
[Txy,Wxy] = tfestimate(u,y,hanning(nfft),[],nfft,1/dt);
%  [Txy,Wxy]=tfe(u,y,nfft,1/dt,hanning(nfft));
%  [Cxy,Wxy2] = cohere(u,y,nfft,1/dt,hanning(nfft));
[Cxy] = mscohere(u,y,hanning(nfft),[],nfft,1/dt);

Wxy = Wxy*2*pi;

WxyGood=Wxy(find(Cxy > Cgood, 1, 'first'):find(Cxy > Cgood, 1, 'last'));
TxyGood=Txy(find(Cxy > Cgood, 1, 'first'):find(Cxy > Cgood, 1, 'last'));
CxyGood=Cxy(find(Cxy > Cgood, 1, 'first'):find(Cxy > Cgood, 1, 'last'));

figure()
subplot(3,1,1)
semilogx(Wxy,20*log10(sqrt(real(Txy).^2+imag(Txy).^2)),'b*');
xmin=10^floor(log10(minfreq));
xmax=10^ceil(log10(maxfreq));
v=axis;
axis([xmin xmax v(3) v(4)]);
xlabel('Frequency, \omega [rad/sec]');
ylabel('Gain, |Gxy| [dB]');
grid on;
% hold on;semilogx(Wxy, Wxy*0-3, 'g-');
% hold on;semilogx(Wxy, Wxy*0-7, 'g-');
hold off;
subplot(3,1,2)
%      semilogx(Wxy,unwrap(angle(Txy))*180.0/pi,'bo');
semilogx(Wxy,angle(Txy)*180.0/pi,'b*');
v=axis;
axis([xmin xmax -180 180]);
xlabel('Frequency, \omega [rad/sec]');
ylabel('Phase, \Phixy [deg]');
grid on;
subplot(3,1,3)
semilogx(Wxy,Cxy,'b*');
axis([xmin xmax 0 1]);
xlabel('Frequency, \omega [rad/sec]');
ylabel('Coherence, Cxy ');
grid on;

orient tall;

H=gcf;
end

%% f_thrordfit
function [wn,zn,K, tau]=f_thrordfit(Wxy,Hxy)

X0(1)= 1; % omega_n
X0(2)= 0.7; % zeta
X0(3)= 1; % Gain
X0(4)= 1; % tau

X=fminsearch(@(X) thrordcost(Wxy,Hxy,X),X0);
wn=X(1);
zn=X(2);
K=X(3);
tau=X(4);

end

%% thrordcost
function F=thrordcost(Wxy,Hxy,X)
num= [X(3)*X(1)^2];
den= conv([1/X(4) 1], [1 2*X(1)*X(2) X(1)^2]);

sys=tf(num,den);

[MagL,PhaseL] = bode(sys,Wxy);

for n=1:max(size(Wxy));
    MagH(n,1) = sqrt(real(Hxy(n))^2+imag(Hxy(n))^2);
    PhaseH(n,1) = 180/pi*atan2(imag(Hxy(n)),real(Hxy(n)));
end

dMag = MagH-squeeze(MagL);
dPhase = unwrap(PhaseH)-unwrap(squeeze(PhaseL));
F = 20/(max(size(Wxy)))*(dMag'*dMag + pi/180*dPhase'*dPhase);

return
end

%% f_secordfit
function [wn,zn,K]=f_secordfit(Wxy,Hxy)

X0(1)= 1; %omega_n
X0(2)= 0.7; % zeta
X0(3)= 1; % Gain

X=fminsearch(@(X) secordcost(Wxy,Hxy,X),X0);
wn=X(1);
zn=X(2);
K=X(3);

end

%% secordcost
function F=secordcost(Wxy,Hxy,X)
num= [X(3)*X(1)^2];
den= [1 2*X(1)*X(2) X(1)^2];

sys=tf(num,den);

[MagL,PhaseL] = bode(sys,Wxy);

for n=1:max(size(Wxy));
    MagH(n,1) = sqrt(real(Hxy(n))^2+imag(Hxy(n))^2);
    PhaseH(n,1) = 180/pi*atan2(imag(Hxy(n)),real(Hxy(n)));
end

dMag = MagH-squeeze(MagL);
dPhase = unwrap(PhaseH)-unwrap(squeeze(PhaseL));
F = 20/(max(size(Wxy)))*(dMag'*dMag + pi/180*dPhase'*dPhase);

return
end

%% f_firstordfit
function [tau,K]=f_firstordfit(Wxy,Hxy)
X0 = [1 1];
X=fminsearch(@(X) firstordcost(Wxy,Hxy,X),X0);
tau=X(1);
K=X(2);
end

%% firstordcost
function F=firstordcost(Wxy,Hxy,X)
sys=tf([X(2)],[1/X(1) 1]);
[MagL,PhaseL] = bode(sys,Wxy);

for n=1:max(size(Wxy));
    MagH(n,1) = sqrt(real(Hxy(n))^2+imag(Hxy(n))^2);
    PhaseH(n,1) = 180/pi*atan2(imag(Hxy(n)),real(Hxy(n)));
end

dMag = MagH-squeeze(MagL);
dPhase = unwrap(PhaseH)-unwrap(squeeze(PhaseL));
F = 20/(max(size(Wxy)))*(dMag'*dMag + pi/180*dPhase'*dPhase);

return
end
%% Compile Outputs:
% << End of function FreqDomainID >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110405 MWS: Updated internal plotting routine
%             Noting that this function was originally developed by Pablo
%             Gonzalez and Dan Salluce for the VSI Library:
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/ANALYSIS/FREQUENCY_ID/FreqDomainID.m
% 101021 JPG: Copied over information from the old function.
% 101021 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720

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
