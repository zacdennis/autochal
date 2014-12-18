% STANFORD Generates a Stanford plot
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% stanford:
%   Generates a Stanford plot based on Error and Protection Level Data
%   normalized to the Alert Limit
% 
% SYNTAX:
%                       stanford(Err, PL, AL)
% [nom]               = stanford(Err, PL, AL)
% [nom, mis]          = stanford(Err, PL, AL)
% [nom, mis, haz]     = stanford(Err, PL, AL)
% [nom, mis, haz, fa] = stanford(Err, PL, AL)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	Err 	    [1xn]		[varies]	Error vector
%	PL  	    [1xn]		[varies]	Protection Level vector
%	AL  	    [1xn]		[varies]	Alert Limit vector
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	nom 	    [1]		    [ND]		Nominal performance rate
%	mis 	    [1]         [ND]        Misleading Information rate
%	haz 	    [1]         [ND]		Hazardously misleading information
%                                           rate
%	fa  	    [1]         [ND]		False Alarm rate
%
% NOTES:
%	TBD
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[nom, mis, haz, fa] = stanford(Err, PL, AL, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[nom, mis, haz, fa] = stanford(Err, PL, AL)
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
%	Source function: <a href="matlab:edit stanford.m">stanford.m</a>
%	  Driver script: <a href="matlab:edit Driver_stanford.m">Driver_stanford.m</a>
%	  Documentation: <a href="matlab:pptOpen('stanford_Function_Documentation.pptx');">stanford_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/<TicketNumber>
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [nom, mis, haz, fa] = stanford(Err, PL, AL, varargin)

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

%% Stanford Plot
error(nargchk(3,3,nargin));
if( ~isequal(size(Err),size(PL)) || ~isequal(size(Err),size(AL)) )
    error('Inputs must be of same dimensions.');
end

X = Err./AL;
Y = PL./AL;

% Stanford Plot Boundaries
x1 = [0 0 2 2];
y1 = [1 2 2 1];

x2 = [1 1 2 2];
y2 = [0 1 1 0];

x3 = [0 2 2];
y3 = [0 0 2];

figure('Name','Stanford Plot'); hold on;
% Plot Stanford Plot Boundaries
t1 = fill(x1,y1,[1 1 0]);
alpha(t1,0.1);
t2 = fill(x2,y2,'r');
alpha(t2,0.1);
t3 = fill(x3,y3,'r');
alpha(t3,0.1);
% Plot data
plot(X,Y,'b.');
% Format plot
grid on;
axis([0 2 0 2]);
xlabel('Error/AL');ylabel('PL/AL');

%% Data Analysis
if (nargout > 0)
    n = length(X);
    mi1 = 0;
    mi2 = 0;
    haz = 0;
    fa  = 0;
    for ii = 1:n
        if (X(ii) >= Y(ii) && X(ii) < 1)
            mi1 = mi1 + 1;
        elseif(X(ii) >= Y(ii) && X(ii) > 1 && Y(ii) < 1)
            haz = haz + 1;
        elseif(X(ii) >= Y(ii) && Y(ii) > 1)
            mi2 = mi2 + 1;
        elseif(X(ii) < Y(ii) && Y(ii) > 1)
            fa = fa + 1;
        end
    end
 
    mis = (mi1 + mi2)/n;
    haz = haz/n;
    fa = fa/n;
    nom = 1.0 - (mis + haz + fa);
end

end % << End of function stanford >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110615 PBH: Added CSA Headers/Footers from function created by TFH 
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         : Email                     : NGGN Username
% PBH: Patrick Healy    : Patrick.Healy@ngc.com     : healypa 
% TFH: Terry Heinrich   : Terence.Heinrich@ngc.com  : G33153 

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
