% BODYAXISMOMENTTRANSFER Transfers the Aerodynamic Moment Coefficients from the Aerodynamic Reference to the Center of Gravity
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BodyAxisMomentTransfer:
%     <Function Description> 
% 
% SYNTAX:
%	[Cl_cg, Cm_cg, Cn_cg] = BodyAxisMomentTransfer(CX, CY, CZ, ...
%   Cl_ref, Cm_ref, Cn_ref, AeroRef, CG, mac, span)
%
% INPUTS: 
%	Name    Size	Units		Description
%   CX      [1]     [ND]        Coefficient of X-force in Aircraft Body 
%                                   Frame
%   CY      [1]     [ND]        Coefficient of Y-force (Sideforce) in 
%                                  Aircraft Body Frame
%   CZ      [1]     [ND]        Coefficient of Z-force in Aircraft Body
%                                   Frame
%   Cl_ref  [1]     [ND]        Coefficient of Rolling Moment in Aircraft
%                                   Body Frame at Aero Ref Point
%   Cm_ref  [1]     [ND]        Coefficient of Pitching Moment in Aircraft
%                                   Body Frame at Aero Ref Point
%   Cn_ref  [1]     [ND]        Coefficient of Yawing Moment in Aircraft
%                                   Body Frame at Aero Ref Point
%   AeroRef [3]     [length]    Aerodynamic Reference Point
%   CG      [3]     [length]    Center of Gravity
%   mac     [1]     [length]    Mean Aerodynamic Chord
%   span    [1]     [length]    Reference Span
%
% OUTPUTS: 
%	Name    Size	Units		Description
%   Cl_cg   [1]     [ND]        Coefficient of Rolling Moment in Aircraft
%                                  Body Frame at Center of Gravity
%   Cm_cg   [1]     [ND]        Coefficient of Pitching Moment in Aircraft
%                                  Body Frame at Center of Gravity
%   Cn_cg   [1]     [ND]        Coefficient of Yawing Moment in Aircraft
%                                  Body Frame at Center of Gravity
%
% NOTES:
%   This function is NOT unit specific.  Distances only need to be uniform
%   and should be in standard English [ft] or Metric [m].
%
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[Cl_cg, Cm_cg, Cn_cg] = BodyAxisMomentTransfer(CX, CY, CZ, Cl_ref, Cm_ref, Cn_ref, AeroRef, CG, mac, span, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Cl_cg, Cm_cg, Cn_cg] = BodyAxisMomentTransfer(CX, CY, CZ, Cl_ref, Cm_ref, Cn_ref, AeroRef, CG, mac, span)
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
%	Source function: <a href="matlab:edit BodyAxisMomentTransfer.m">BodyAxisMomentTransfer.m</a>
%	  Driver script: <a href="matlab:edit Driver_BodyAxisMomentTransfer.m">Driver_BodyAxisMomentTransfer.m</a>
%	  Documentation: <a href="matlab:pptOpen('BodyAxisMomentTransfer_Function_Documentation.pptx');">BodyAxisMomentTransfer_Function_Documentation.pptx</a>
%
%  See also CLCD2CXCZ, AeroCoeffs2ForcesMoments
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/299
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AerodynamicFunctions/BodyAxisMomentTransfer.m $
% $Rev: 1714 $
% $Date: 2011-05-11 15:23:59 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Cl_cg, Cm_cg, Cn_cg] = BodyAxisMomentTransfer(CX, CY, CZ, Cl_ref, Cm_ref, Cn_ref, AeroRef, CG, mac, span)

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
Cl_cg= -1;
Cm_cg= -1;
Cn_cg= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        span= ''; mac= ''; CG= ''; AeroRef= ''; Cn_ref= ''; Cm_ref= ''; Cl_ref= ''; CZ= ''; CY= ''; CX= ''; 
%       case 1
%        span= ''; mac= ''; CG= ''; AeroRef= ''; Cn_ref= ''; Cm_ref= ''; Cl_ref= ''; CZ= ''; CY= ''; 
%       case 2
%        span= ''; mac= ''; CG= ''; AeroRef= ''; Cn_ref= ''; Cm_ref= ''; Cl_ref= ''; CZ= ''; 
%       case 3
%        span= ''; mac= ''; CG= ''; AeroRef= ''; Cn_ref= ''; Cm_ref= ''; Cl_ref= ''; 
%       case 4
%        span= ''; mac= ''; CG= ''; AeroRef= ''; Cn_ref= ''; Cm_ref= ''; 
%       case 5
%        span= ''; mac= ''; CG= ''; AeroRef= ''; Cn_ref= ''; 
%       case 6
%        span= ''; mac= ''; CG= ''; AeroRef= ''; 
%       case 7
%        span= ''; mac= ''; CG= ''; 
%       case 8
%        span= ''; mac= ''; 
%       case 9
%        span= ''; 
%       case 10
%        
%       case 11
%        
%  end
%
%  if(isempty(span))
%		span = -1;
%  end

if size(AeroRef, 1) == 3
    AeroRef = AeroRef';
end

if size(CG, 1) == 3
    CG = CG';
end
%% Main Function:
Clmn_cg = ([Cl_ref Cm_ref Cn_ref] + cross( (AeroRef - CG), [CX CY CZ]) ... 
    ./ [span mac span]);

Cl_cg = Clmn_cg(1);     % [ND]
Cm_cg = Clmn_cg(2);     % [ND]
Cn_cg = Clmn_cg(3);     % [ND]

%% Compile Outputs:
%	Cl_cg= -1;
%	Cm_cg= -1;
%	Cn_cg= -1;

end % << End of function BodyAxisMomentTransfer >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101021 JPG: Copied over information from the old function.
% 101021 CNF: Function template created using CreateNewFunc
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
