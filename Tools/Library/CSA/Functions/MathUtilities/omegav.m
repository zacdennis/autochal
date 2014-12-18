% OMEGAV Generates a logarithmically spaced vector
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% omegav:
%     Similar to logspace, function generates a logarithmically spaced
%     vector using start/stop values and a multiplication factor
%     (where w(n+1) = mult factor * w(n)).
% 
% SYNTAX:
%	[w] = omegav(wi, wf, dw)
%	[w] = omegav(wi, wf)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	wi  	    [1]         [N/A]       Starting Value
%	wf  	    [1]         [N/A]       Final Value
%	dw  	    [1]         [unitless]  Gain Factor (must be >= 1.0001)
%                                        Default: 1.05 (5% increase)
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	w   	    [n]         [N/A]       Logarithmically spaced vector where
%                                        w(1)    = wi
%                                        w(i)    = w(i-1)*dw
%                                        w(last) = wf   
%
% NOTES:
%	This function is basically the standard compound interest equation.
%	'n' is the number of periods required to get from 'wi' to 'wf' given
%	the gain 'dw'.  n = ( log(wf) - log(wi) )/ log(dw) ).  Note that
%	interest rate is (dw - 1)*100 (e.g. 1.05 is a 5% rate)
%
% EXAMPLES:
%	% Create an array between 1 and 2 with a gain of 1.1
%	[w] = omegav(1,2,1.1)
%   % Returns:
%   %             1
%   %           1.1
%   %          1.21
%   %         1.331
%   %        1.4641
%   %        1.6105
%   %        1.7716
%   %             2
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit omegav.m">omegav.m</a>
%	  Driver script: <a href="matlab:edit Driver_omegav.m">Driver_omegav.m</a>
%	  Documentation: <a href="matlab:winopen(which('omegav_Function_Documentation.pptx'));">omegav_Function_Documentation.pptx</a>
%
% See also logspace 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/782
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/omegav.m $
% $Rev: 2659 $
% $Date: 2012-11-19 17:50:07 -0600 (Mon, 19 Nov 2012) $
% $Author: sufanmi $

function [w] = omegav(wi, wf, dw)

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

%% Input Argument Conditioning:
if( ~exist('dw') | isempty(dw) ) 
   dw = 1.05;   % 5% Increase
end

min_dw = 1 + 1e-4;

if(dw <= min_dw)
    disp([mfnam '>> WARNING: ''dw'' is set too small (<' num2str(min_dw) '.  Using ' num2str(min_dw) ' instead.']);
    dw = min_dw;
end

%% Main Function:
%   http://en.wikipedia.org/wiki/Compound_interest
numIterations = ceil( (log(wf)-log(wi))/(log(dw)) );
numIterations = max(numIterations, 2);

w = zeros(numIterations, 1);

w(1) = wi;
for i = 2:numIterations
    w(i)=w(i-1)*dw;
end
w(numIterations) = wf;

end % << End of function omegav >>

%% REVISION HISTORY
% YYMMDD INI: note
% 121119 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
