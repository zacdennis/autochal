% TRAPEZOIDINTEGRATION integrates using a defined time frame.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% TrapezoidIntegration:
%    This is a trapezoid integration routine using a user-specified frame
%  time.  This version has the ability to reset the integrator to the initial
%  condition.  Note that integration continues in the same frame in which the
%  reset operation occurs.
% 
% SYNTAX:
%	[X] = TrapezoidIntegration(Xdot, X_ic, reset_int, dt, ...
%                       Xdot_n_minus_1, X_n_minus_1, inTrimMode)
%
% INPUTS: 
%	Name          	Size	Units	Description
%   Xdot            [1x1]   [N/A]   Input Derivative
%   X_ic            [1x1]   [N/A]   Initial Condition of Output
%   reset_int       [1x1]   [bool]  Reset Integrator?
%   Xdot_n_minus_1  [1x1]   [N/A]   Previous Derivative Xdot(n-1)
%   X_n_minus_1     [1x1]   [N/A]   Previous Output X(n-1)
%   dt              [1x1]   [sec]   Frame stepsize
%   inTrimMode      [1x1]   [bool]  In Trim Mode?
%
% OUTPUTS: 
%	Name          	Size	Units   Description
%   X               [1x1]   [N/A]   Integrated Value
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
%	[X] = TrapezoidIntegration(Xdot, X_ic, reset_int, dt, Xdot_n_minus_1, X_n_minus_1, inTrimMode, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[X] = TrapezoidIntegration(Xdot, X_ic, reset_int, dt, Xdot_n_minus_1, X_n_minus_1, inTrimMode)
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
%	Source function: <a href="matlab:edit TrapezoidIntegration.m">TrapezoidIntegration.m</a>
%	  Driver script: <a href="matlab:edit Driver_TrapezoidIntegration.m">Driver_TrapezoidIntegration.m</a>
%	  Documentation: <a href="matlab:pptOpen('TrapezoidIntegration_Function_Documentation.pptx');">TrapezoidIntegration_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/52
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/TrapezoidIntegration.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [X] = TrapezoidIntegration(Xdot, X_ic, reset_int, dt, Xdot_n_minus_1, X_n_minus_1, inTrimMode)

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
X= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        inTrimMode= ''; X_n_minus_1= ''; Xdot_n_minus_1= ''; dt= ''; reset_int= ''; X_ic= ''; Xdot= ''; 
%       case 1
%        inTrimMode= ''; X_n_minus_1= ''; Xdot_n_minus_1= ''; dt= ''; reset_int= ''; X_ic= ''; 
%       case 2
%        inTrimMode= ''; X_n_minus_1= ''; Xdot_n_minus_1= ''; dt= ''; reset_int= ''; 
%       case 3
%        inTrimMode= ''; X_n_minus_1= ''; Xdot_n_minus_1= ''; dt= ''; 
%       case 4
%        inTrimMode= ''; X_n_minus_1= ''; Xdot_n_minus_1= ''; 
%       case 5
%        inTrimMode= ''; X_n_minus_1= ''; 
%       case 6
%        inTrimMode= ''; 
%       case 7
%        
%       case 8
%        
%  end
%
%  if(isempty(inTrimMode))
%		inTrimMode = -1;
%  end
%% Main Function:
if(inTrimMode)
    %% Vehicle is Trimming:
    X = X_ic;

else
    %% Regular Operation:

    if(reset_int)
        %% Reset Integrator:
        X = X_ic + Xdot * dt;
    else
        %% Trapezoidal Integration:
        X = X_n_minus_1 + 0.5*dt*(Xdot + Xdot_n_minus_1);
    end
end

%% Compile Outputs:
%	X= -1;

end % << End of function TrapezoidIntegration >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
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
