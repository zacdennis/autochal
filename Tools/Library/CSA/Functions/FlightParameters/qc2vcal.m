% QC2VCAL Computes Calibrated Airspeed from Impact Pressure 
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% qc2vcal:
%     Computes Calibrated Airspeed from Impact Pressure  
% 
% SYNTAX:
 
%	[vcal_kts] = qc2vcal(Qc, flgUnits, 'PropertyName', PropertyValue))
%	[vcal_kts] = qc2vcal(Qc, flgUnits, varagin)
%	[vcal_kts] = qc2vcal(Qc, flgUnits)
%	[vcal_kts] = qc2vcal(Qc)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	Qc  	    [1]         [Pa] [psf]  Compressed Dyanmic Pressure
%	flgUnits	[1]         [flag]      0: Qc is Metric (Pa)
%                                       1: Qc is English (psf)
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	vcal_kts	[1]         [knots]     Calibrated Airspeed
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'P0_Pa'             [Pa]            101325      Standard Sea Level Pressure
%   'a0_kts'            [knots]         661.4788    Standard Sea Level
%                                                    Speed of Sound
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[vcal_kts] = qc2vcal(Qc, flgUnits)
%	% <Copy expected outputs from Command Window>
%
%
% SOURCE DOCUMENTATION:
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit qc2vcal.m">qc2vcal.m</a>
%	  Driver script: <a href="matlab:edit Driver_qc2vcal.m">Driver_qc2vcal.m</a>
%	  Documentation: <a href="matlab:pptOpen('qc2vcal_Function_Documentation.pptx');">qc2vcal_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/659
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [vcal_kts] = qc2vcal(Qc, flgUnits, varargin)

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

%% Input Argument Checking:
switch(nargin)
    case 1
        flgUnits= '';
end

if(isempty(flgUnits))
    flgUnits = 1;
end

%% Internal Constants
[P0_Pa, varargin]   = format_varargin('P0_Pa', 101325, 2, varargin);     % [Pa]
[a0_kts, varargin]  = format_varargin('a0_kts', 661.478826095537, 2, varargin);     % [Pa]
PSF2PA = 47.8802589803358;  % [lb/ft^2] to [Pascal]

%% Main Function:
if(flgUnits)
     % Inputs are in ENGLISH
    Qc_Pa = Qc * PSF2PA;    % [Pa]
else
    % Inputs are in METRIC
    Qc_Pa = Qc;         % [Pa]
end

vcal_kts = a0_kts * sqrt( 5 * ( ( ( (Qc_Pa/P0_Pa) + 1)^(2/7) ) - 1) );

end % << End of function qc2vcal >>

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
