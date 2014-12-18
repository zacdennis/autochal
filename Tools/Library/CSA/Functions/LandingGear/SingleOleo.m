% SINGLEOLEO Computes the Stroke vs. Load profile for a Single-Acting Shock Absorber
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% SingleOleo:
%     Computes the Stroke vs. Load profile for a Single-Acting Shock
%     Absorber
% 
% SYNTAX:
%	[G] = SingleOleo(Gin)
%
% INPUTS: 
%	Name                Size    Units   Description
%   Gin         {struct}
%    .MaxStroke         [1]     [in]    Total Oleo Stroke
%    .StaticWOW         [1]     [lbs]   Static Load on Strut
%    .Comp_ratio_s2e    [1]     [ND]    Compression ratio: static to 
%                                       extended
%    .Comp_ratio_c2s    [1]     [ND]    Compression ratio: compressed to 
%                                       static
%    .StaticPressure    [1]     [psi]   Static Pressure
%
% OUTPUTS: 
%	Name                Size	Units	Description
%   {Note that these are added to the input Gin structure}
%    .PistonArea        [1]     [in^2]  Piston Cross Sectional Area
%    .Stroke_static     [1]     [in]    Static Stroke Distance
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
%	[G] = SingleOleo(Gin, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[G] = SingleOleo(Gin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%   Currey, Norman S.  "Aircraft Landing Gear Design: Principles and
%   Practices."  AIAA Education Series.  1988.  Pages 99-102.
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
%	Source function: <a href="matlab:edit SingleOleo.m">SingleOleo.m</a>
%	  Driver script: <a href="matlab:edit Driver_SingleOleo.m">Driver_SingleOleo.m</a>
%	  Documentation: <a href="matlab:pptOpen('SingleOleo_Function_Documentation.pptx');">SingleOleo_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/33
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/LandingGear/SingleOleo.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [G] = SingleOleo(Gin)

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


% Pe: Air Pressure at Full Extension, [psi]:
Pe = G.StaticPressure / G.Comp_ratio_s2e;

% Ps: Air Pressure at the Static Position, [psi]:
Ps = G.StaticPressure;

% Pc: Air Pressure in the Fully Compressed Position, [psi]:
Pc = G.StaticPressure * G.Comp_ratio_c2s;

% Piston Area, [in^2]:
G.PistonArea = G.StaticWOW / G.StaticPressure;

% Volume of Displaceable Air within Strut
%   (Total Stroke x Piston Area), [in^3]:
V_displacement = G.MaxStroke * G.PistonArea;

% Ve: Air Volume at Full Extension, [in^3]:
Ve = -(Pc/(Pe-Pc))*V_displacement;

% Vs: Air Volume at Static Extension, [in^3]:
Vs = Pe*Ve/Ps;

%% Static Parameters
G.NormStroke_static = (Ve-Vs)/V_displacement;
G.Stroke_static = G.MaxStroke - (1-G.NormStroke_static)*G.MaxStroke;

%% Compute Force Load Profile for Various Stroke Distances:
G.Stroke = [0:G.MaxStroke/500:G.MaxStroke];     % [in]
G.NormStroke = G.Stroke / G.MaxStroke;          % [ND]

for i = 1:length(G.Stroke);
    Vratio(i) = 1 - ((G.MaxStroke - G.Stroke(i))/G.MaxStroke);

    % AirVolume: Air Volume at Stroke Extension, [in^3]:
    G.AirVolume(i) = Ve - Vratio(i)*V_displacement;

    % AirPressure: Air Pressure at Stroke Extension, [psi]:
    G.AirPressure(i) = Pe*Ve/G.AirVolume(i); 
    
    % Load: Strut Load at Stroke Extension, [lbs]:
    G.Load(i) = G.AirPressure(i) * G.PistonArea;
    G.NormLoad(i) = G.Load(i) / G.StaticWOW;
end

%% Compile Outputs:
%	G= -1;

end % << End of function SingleOleo >>

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
