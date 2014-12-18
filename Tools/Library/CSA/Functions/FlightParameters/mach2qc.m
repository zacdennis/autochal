% MACH2QC Computes Impact Pressure Qc from Mach Number
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% mach2qc:
%     Computes Impact Pressure Qc from Mach Number 
% 
% SYNTAX:
%	[Qc] = mach2qc(Mach, Pressure)
%	[Qc] = mach2qc(Mach)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	Mach	    [1]         [unitless]  Mach Number
%	Pressure	[1]         [varies]    Atmospheric Pressure
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	Qc          [1]         [varies]    Compressed Dynamic Pressure
%
% NOTES:
%   This function is non-unit-specific.  The output 'Qc' will have the same
%   units as the input 'Pressure'.  Standard English [psf] or [psi] or
%   Metric [Pa] units should be used.
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[Qc] = mach2qc(Mach, Pressure)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
% [2]   http://en.wikipedia.org/wiki/Impact_pressure
%         TODO: Replace with better source.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit mach2qc.m">mach2qc.m</a>
%	  Driver script: <a href="matlab:edit Driver_mach2qc.m">Driver_mach2qc.m</a>
%	  Documentation: <a href="matlab:pptOpen('mach2qc_Function_Documentation.pptx');">mach2qc_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/658
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [Qc] = mach2qc(Mach, Pressure)

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
switch(nargin)
    case {0, 1}
        errstr = [mfnam '>> ERROR: 2 Inputs Required.  See ' mlink ' for help'];
        error([mfnam 'class:file:InputArgChk'], errstr);
 end


%% Main Function:
Qc = Pressure * ( ( (0.2*(Mach^2) + 1)^(7/2) ) - 1 );

end % << End of function mach2qc >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101110 MWS: Created function with CreateNewFunc
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
