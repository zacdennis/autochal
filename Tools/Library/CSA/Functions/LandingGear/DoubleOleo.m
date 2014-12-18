% DOUBLEOLEO Computes the Stroke vs. Load profile for a Double-Acting Shock Absorber
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% DoubleOleo:
%   Computes the Stroke vs. Load profile for a Double-Acting Shock Absorber
% 
% SYNTAX:
%	[G] = DoubleOleo(Gin)
%
% INPUTS: 
%	Name                Size	Units   Description
%   Gin                 {struct}
%    .MaxStroke         [1]     [in]    Total Oleo Stroke
%    .Stroke_static     [1]     [in]    Static Stroke Distance
%    .StaticWOW         [1]     [lbs]   Static Load on Strut
%    .Comp_ratio_s2e    [1]     [ND]    Compression ratio: static to 
%                                       extended
%    .Comp_ratio_c2s    [1]     [ND]    Compression ratio: compressed to 
%                                       static
%    .BreakoverPoint    [1]     [g]     Breakpoint at which to activate the 
%                                       secondary chamber
%    .StaticPressure    [1]     [psi]   Static Pressure
%
% OUTPUTS: 
%	Name                Size	Units	Description
%   {Note that these are added to the input Gin structure}
%    .PistonArea        [1]     [in^2]  Piston Cross Sectional Area
%    .StrokeBreakoverPoint [1]  [in]    Stroke Distance at which Secondary
%                                        Chamber is Utilized
%    .NormStrokeBreakoverPoint [1] [ND] Stroke Distance at which Secondary
%                                        Chamber is Utilized (Normalized)
%    .Breakover_Load =  [1]     [lbs]   Strut Load at which Secondary
%                                        Chamber is Utilized
%    .NormStroke_static [1]     [ND]    Normalized Static Stroke Distance
%    .Stroke            [1x501] [in]    Stroke Distance Breakpoints
%    .NormStroke        [1x501] [ND]    Stroke Distance Breakpoints
%                                        (Normalized)
%    .AirVolume         [1x501] [in^3]  Air Volume at Stroke Extension
%    .AirPressure       [1x501] [psi]   Air Pressure at Stroke Extension
%    .Load              [1x501] [lbs]   Strut Load at Stroke Extension
%    .NormLoad          [1x501] [g]     Strut Load at Stroke Extension
%                                        (Normalized)
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
%	[G] = DoubleOleo(Gin, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[G] = DoubleOleo(Gin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
%   Currey, Norman S.  "Aircraft Landing Gear Design: Principles and
%   Practices."  AIAA Education Series.  1988.  Pages 102-109.
%
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
%	Source function: <a href="matlab:edit DoubleOleo.m">DoubleOleo.m</a>
%	  Driver script: <a href="matlab:edit Driver_DoubleOleo.m">Driver_DoubleOleo.m</a>
%	  Documentation: <a href="matlab:pptOpen('DoubleOleo_Function_Documentation.pptx');">DoubleOleo_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/34
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/LandingGear/DoubleOleo.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [G] = DoubleOleo(Gin)

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
G = Gin;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        Gin= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:
%% Copy the Input Structure into the Output Structure:


conversions;

% Pe: Air Pressure at Full Extension, [psi]:
Pe = G.StaticPressure / G.Comp_ratio_s2e;

% Ps: Pressure in primary chamber at static position, [psi]:
Ps = G.StaticPressure;

% Pc: Air Pressure in the Fully Compressed Position, [psi]:
Pc = G.StaticPressure * G.Comp_ratio_c2s;

% Piston Area, [in^2]:
G.PistonArea = G.StaticWOW / G.StaticPressure;

% Volume of Air Displaced when going from Fully Extended to Static, [in^3]:
V_displacement = (G.Stroke_static * G.PistonArea);

% Ve: Air Volume in Primary Chamber at Full Extension, [in^3]:
Ve = Ps/(Ps-Pe)*V_displacement;

% Vs: Air Volume in Primary Chamber at Static Extension, [in^3]:
Vs = Ve - V_displacement;

% P1s: Pressure in primary chamber required to actuate the secondary
% chamber (function of BreakoverPoint); prevents on-and-off secondary
% chamber actuation during normal airport maneuvering [psi]:
P1s = G.BreakoverPoint * G.StaticWOW / G.PistonArea;

% V1s: Air Volume in primary chamber when secondary is actuated [in^3]:
V1s = Pe*Ve/P1s;

% StrokeBreakoverPoint: Stroke Distance at which secondary chamber is
% utilized, [in]:
G.StrokeBreakoverPoint      = (Ve-V1s)/G.PistonArea;
G.NormStrokeBreakoverPoint  = G.StrokeBreakoverPoint/G.MaxStroke;

G.K1(1) = G.BreakoverPoint*G.NormStrokeBreakoverPoint ...
    /(G.Comp_ratio_s2e*G.BreakoverPoint - 1);
G.K2(1) = G.K1(1)*G.Comp_ratio_s2e;

G.Breakover_Load            = G.BreakoverPoint * G.StaticWOW;

% Vc: Air Volume in primary chamber at full compression, [in^3]:
Vc = Pe*Ve/Pc;

% dVc: Total Volume Change from Actuation of the Secondary Chamber to Fully
% Compressed, [in^3]:
dVc = (G.MaxStroke - G.StrokeBreakoverPoint)*G.PistonArea;

% P2s: Pressure in the Secondary Chamber (the precharge Pressure) at full
% extension - equal to P1s, [psi]:
P2s = P1s;

% V2s: Air Volume in Secondary Chamber at Full Extension, [in^3]:
V2s = -Pc*(dVc - Vc)/(P2s-Pc);

% Vsc: Air Volume in Secondary Chamber at Full Compression, [in^3]:
Vsc = V2s - (dVc - Vc);

%% Static Parameters
G.NormStroke_static = G.Stroke_static / G.MaxStroke;    % [ND]

G.FnThreshold = 1/G.Comp_ratio_s2e;

%% Compute Force Load Profile for Various Stroke Distances:
G.Stroke = [0:G.MaxStroke/500:G.MaxStroke];                 % [dist]
G.NormStroke = G.Stroke / G.MaxStroke;                      % [ND]

for i = 1:length(G.Stroke);
    curStroke = G.Stroke(i);
    
    if(curStroke <= G.StrokeBreakoverPoint)
        AirVolume = Ve - (curStroke * G.PistonArea);        % [in^3]
        AirPressure = Pe*Ve/AirVolume;                      % [psi]
    else
        AirVolume = (V2s+V1s) ...
            -(curStroke-G.StrokeBreakoverPoint)*G.PistonArea;% [in^3]
        AirPressure = P1s * (V2s+V1s)/AirVolume;            % [psi]
    end
    
    G.AirVolume(i)      = AirVolume;                        % [in^3]
    G.AirPressure(i)    = AirPressure;                      % [psi]
    G.Load(i)           = G.AirPressure(i)*G.PistonArea;    % [lbs]
    G.NormLoad(i)       = G.Load(i)/G.StaticWOW;            % [ND]
end

g1 = G.NormLoad(end);
G.K2(2) = (G.NormStrokeBreakoverPoint*G.BreakoverPoint - g1) ...
    /(G.BreakoverPoint - g1);
G.K1(2) = G.BreakoverPoint * (G.K2(2) - G.NormStrokeBreakoverPoint);

%% Compile Outputs:
%	G= -1;

end % << End of function DoubleOleo >>

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
