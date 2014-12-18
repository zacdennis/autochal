% COMPUTEBURNTIME Computes the Burn Time for desired Delta-V
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ComputeBurnTime:
%     Computes the Burn Time for desired Delta-V
% 
% SYNTAX:
%	[BurnTime, FuelBurned, FinalMass, DeltaV] = ComputeBurnTime(DeltaV, Thrust, Isp, FuelMass, VehMass, flgEnglishUnits, flgIgnoreFuelMass, varargin, 'PropertyName', PropertyValue)
%	[BurnTime, FuelBurned, FinalMass, DeltaV] = ComputeBurnTime(DeltaV, Thrust, Isp, FuelMass, VehMass, flgEnglishUnits, flgIgnoreFuelMass, varargin)
%	[BurnTime, FuelBurned, FinalMass, DeltaV] = ComputeBurnTime(DeltaV, Thrust, Isp, FuelMass, VehMass, flgEnglishUnits, flgIgnoreFuelMass)
%	[BurnTime, FuelBurned, FinalMass, DeltaV] = ComputeBurnTime(DeltaV, Thrust, Isp, FuelMass, VehMass, flgEnglishUnits)
%
% INPUTS: 
%	Name             	Size		Units		Description
%   DeltaV              [m/sec] Desired Velocity change of burn
%   Thrust              [N]     Thrust of Burn
%   Isp                 [sec]   Propulsion Engine Specific Impulse
%   FuelMass            [kg]    Amount of Fuel Mass Left
%   VehMass             [kg]    Vehicle Mass
%   flgEnglishUnits     [bool]  Inputs are English Units? (Default is 0)
%   flgIgnoreFuelMass   [bool]  Compute BurnTime regardless of available
%                               fuel? (Default is 0)
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name             	Size		Units		Description
%   BurnTime            [sec]   Time Required to Burn to achieved desired
%                                DeltaV
%   FuelBurned          [kg]    Amout of fuel consummed during burn
%   FinalMass           [kg]    Mass of Vehicle after burn
%   DeltaV              [m/sec] Maximum velocity change of burn (if fuel
%                                mass does not allow)
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
%	[BurnTime, FuelBurned, FinalMass, DeltaV] = ComputeBurnTime(DeltaV, Thrust, Isp, FuelMass, VehMass, flgEnglishUnits, flgIgnoreFuelMass, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[BurnTime, FuelBurned, FinalMass, DeltaV] = ComputeBurnTime(DeltaV, Thrust, Isp, FuelMass, VehMass, flgEnglishUnits, flgIgnoreFuelMass)
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
%	Source function: <a href="matlab:edit ComputeBurnTime.m">ComputeBurnTime.m</a>
%	  Driver script: <a href="matlab:edit Driver_ComputeBurnTime.m">Driver_ComputeBurnTime.m</a>
%	  Documentation: <a href="matlab:pptOpen('ComputeBurnTime_Function_Documentation.pptx');">ComputeBurnTime_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/544
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Space/ComputeBurnTime.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [BurnTime, FuelBurned, FinalMass, DeltaV] = ComputeBurnTime(DeltaV, Thrust, Isp, FuelMass, VehMass, flgEnglishUnits, flgIgnoreFuelMass, varargin)

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
% BurnTime= -1;
% FuelBurned= -1;
% FinalMass= -1;
% DeltaV= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        flgIgnoreFuelMass= ''; flgEnglishUnits= ''; VehMass= ''; FuelMass= ''; Isp= ''; Thrust= ''; DeltaV= ''; 
%       case 1
%        flgIgnoreFuelMass= ''; flgEnglishUnits= ''; VehMass= ''; FuelMass= ''; Isp= ''; Thrust= ''; 
%       case 2
%        flgIgnoreFuelMass= ''; flgEnglishUnits= ''; VehMass= ''; FuelMass= ''; Isp= ''; 
%       case 3
%        flgIgnoreFuelMass= ''; flgEnglishUnits= ''; VehMass= ''; FuelMass= ''; 
%       case 4
%        flgIgnoreFuelMass= ''; flgEnglishUnits= ''; VehMass= ''; 
%       case 5
%        flgIgnoreFuelMass= ''; flgEnglishUnits= ''; 
%       case 6
%        flgIgnoreFuelMass= ''; 
%       case 7
%        
%       case 8
%        
%  end
%
%  if(isempty(flgIgnoreFuelMass))
%		flgIgnoreFuelMass = -1;
%  end
%% Main Function:
if( (nargin < 7) || isempty(flgIgnoreFuelMass) )
    flgIgnoreFuelMass = 0;
end

if( (nargin < 6) || isempty(flgEnglishUnits) )
    flgEnglishUnits = 0;
end

% Local Constant:
% g0: Acceleration due to Gravity on the Earth's surface at a geodetic 
%     latitude of about 45.5 deg

if(flgEnglishUnits)
    g0 = 32.174048556430442;    % [ft/sec^2]
else
    g0 = 9.80665;               % [m/sec^2]
end

DeltaV = abs(DeltaV);             

% Main Code:                    
Mi = VehMass;                       % [kg]  Initial Vehicle Mass
Mf = Mi / exp(DeltaV /(Isp*g0));    % [kg]  Mass After Burn
FuelBurned = Mi - Mf;               % [kg]  Fuel Burned

if( (~flgIgnoreFuelMass) && (FuelBurned > FuelMass) )
    % Not Enough Fuel Left for Burn:
    % Calculate Delta-V left
    FuelBurned = FuelMass;
    Mf = Mi - FuelMass;
    DeltaV = log(Mi/Mf) * g0 * Isp;
end

mdot = Thrust/(Isp*g0);         % [kg/sec]  Mass Flow Rate
BurnTime = FuelBurned / mdot;   % [sec]     Time to Burn
FinalMass = Mf;                 % [kg]      Final Vehicle Mass

%% Compile Outputs:
%	BurnTime= -1;
%	FuelBurned= -1;
%	FinalMass= -1;
%	DeltaV= -1;

end % << End of function ComputeBurnTime >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
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
