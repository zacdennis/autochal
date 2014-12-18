% COMPUTEECC computes eccentric anomaly from current mean Anomaly and orbit eccentricity.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ComputeEcc:
%   Computes new Eccentric anomaly from current Mean Anomaly and orbit
%   eccentricity.
%
% SYNTAX:
%	[capE, errM] = ComputeEcc(M, e)
%
% INPUTS: 
%	Name    Size	Units		Description
%   M       [1x1]   [rad]       Mean Anomaly
%   e       [1x1]   [ND]        Orbit Eccentricity
%
% OUTPUTS: 
%	Name    Size	Units		Description
%   capE    [1x1]   [rad]       Eccentric Anomaly
%   errM    [1x1]   [rad]       Difference between Given Mean Anomaly (M) 
%                               and Internally Computed Mean Anomaly 
%                               (calculated from Eccentric Anomaly)
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[capE, errM] = ComputeEcc(M, e, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[capE, errM] = ComputeEcc(M, e)
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
%	Source function: <a href="matlab:edit ComputeEcc.m">ComputeEcc.m</a>
%	  Driver script: <a href="matlab:edit Driver_ComputeEcc.m">Driver_ComputeEcc.m</a>
%	  Documentation: <a href="matlab:pptOpen('ComputeEcc_Function_Documentation.pptx');">ComputeEcc_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/383
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/ComputeEcc.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [capE, errM] = ComputeEcc(M, e)

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
capE= -1;
errM= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        e= ''; M= ''; 
%       case 1
%        e= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(e))
%		e = -1;
%  end
%% Main Function:
%% Set Internal Varibles / Flags:
converged = 0;      % [bool]    Flag to Determine if Solution has converged
capE = 0;           % [rad]     Initial Guess at Eccentric Anomaly
kgain = .8;         % [ND]      Converging Gain
count = 0;          % [int]     Initial Iteration Counter
maxcount = 10000;   % [int]     Maximum number of allowable interations
%                               for convergence

if (e >= 0) && (e < 1)
    while converged == 0 && count < maxcount;
        count = count + 1;  % Increment Counter

        % Calculate Mean Anomaly given an Eccentric Anomaly and
        % Eccentricity:
        newM = capE - e*sin(capE);
        % Calculate Error between Given and Computed Mean Anomalies:
        errM = M - newM;

        % Check for Convergence:
        if (abs(errM) <= 1e-15);
            converged = 1;
        else
            % Updated Eccentric Anomaly Guess Given Current Mean Anomaly
            % Error
            capE = capE + errM * kgain;
        end
    end
    
    if ~(converged)
        disp('Warning: Maximum number of iterations achieved in');
        disp('         ComputeEcc.m.  Computed Eccentric anomaly');
        disp('         may not be accurate.');
        disp(sprintf('         Inputs: M: %.2f [rad] e: %.2f', M, e));
        disp(sprintf('         Computed: capE: %.6e  (M_given - M_calc) Error: %.6e', capE, errM));
    end

else
    disp('Warning: ComputeEcc.m does not support parabolic or hyperbolic');
    disp('         orbits.  Returning cap = 0 to avoid errors.');
    disp(sprintf('         Inputs: M: %.2f [rad] e: %.2f', M, e));
    errM = 0;    
    
%% Compile Outputs:
%	capE= -1;
%	errM= -1;

end % << End of function ComputeEcc >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101022 JPG: Copied over information from the old function.
% 101022 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720

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
