% RECONFIGUREMASSPROPS adjusts vehicle mass prop when adding/removing items 
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ReconfigureMassProps:
%   Given a Vehicle's Current Mass Properties (mass0, cg0, and inertia0)...
%
%    Computes the total combined mass properties (mass_f, cg_f, inertia_f)
%    should an item (cg_item, mass_item, inertia_item) be attached to it
%   OR
%    Computes the vehicle's new mass properties (mass_f, cg_f, inertia_f)
%    should an item (cg_item, mass_item, inertia_item) be removed from it
% 
% SYNTAX:
%	[mass_f, cg_f, inertia_f] = ReconfigureMassProps(configtype, ...
%       mass_item, cg_item, inertia_item, mass0, cg0, inertia0)
%
% INPUTS: 
%	Name        	Size	Units           Description
%   configtype      [1xN]   [ND]            String to identify how to reconfigure
%                                              mass properties.
%                                              To ADD to the original MPs, 
%                                              configtype must be 'add','ADD',
%                                              'Add', or '+'.
%                                              To SUBTRACT from the original 
%                                              MPs, configtype must be 
%                                              'subtract', 'SUBTRACT',
%                                              'Subtract', or '-'
%   mass_item       [1x1]   [mass]          Mass of Item
%   cg_item         [3x1]   [length]        CG location of Item
%   inertia_item    [3x3]   [mass*length^2] Inertia of Item
%
%   mass0           [1x1]   [mass]          Initial Vehicle Mass
%   cg0             [3x1]   [length]        Initial Vehicle CG location
%   inertia0        [3x3]   [mass*length^2] Initial Vehicle Inertia Matrix
%
% OUTPUTS: 
%	Name        	Size	Units           Description
%   mass_f          [1x1]   [mass]          New Reconfigured Mass
%   cg_f            [3x1]   [length]        New Reconfigured CG Location
%   inertia_f       [3x3]   [mass*length^2] New Reconfigured Inertia Matrix
%
% NOTES:
%   This calculation is not unit specific.  Input parameters only need to be
%   of a uniform unit.  Standard METRIC [kg, m, kg-m^2] or ENGLISH 
%   [slug, ft, slug-ft^2] should be used.
%
%
% EXAMPLES:
%
%  Example Script
%   Use Run_ReconfigureMassProps.m in VSI_Library/UNIT_TEST
%
%	% <Enter Description of Example #1>
%	[mass_f, cg_f, inertia_f] = ReconfigureMassProps(configtype, mass_item, cg_item, inertia_item, mass0, cg0, inertia0, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[mass_f, cg_f, inertia_f] = ReconfigureMassProps(configtype, mass_item, cg_item, inertia_item, mass0, cg0, inertia0)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
%  Parallel Axis Theorem
%   http://ocw.mit.edu/NR/rdonlyres/Aeronautics-and-Astronautics/16-07Fall-
%   2004/4440D65E-123C-483F-90CB-81F7F040E673/0/d23.pdf.
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
%	Source function: <a href="matlab:edit ReconfigureMassProps.m">ReconfigureMassProps.m</a>
%	  Driver script: <a href="matlab:edit Driver_ReconfigureMassProps.m">Driver_ReconfigureMassProps.m</a>
%	  Documentation: <a href="matlab:pptOpen('ReconfigureMassProps_Function_Documentation.pptx');">ReconfigureMassProps_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/405
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MassProperties/ReconfigureMassProps.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [mass_f, cg_f, inertia_f] = ReconfigureMassProps(configtype, mass_item, cg_item, inertia_item, mass0, cg0, inertia0)

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
mass_f= -1;
cg_f= -1;
inertia_f= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        inertia0= ''; cg0= ''; mass0= ''; inertia_item= ''; cg_item= ''; mass_item= ''; configtype= ''; 
%       case 1
%        inertia0= ''; cg0= ''; mass0= ''; inertia_item= ''; cg_item= ''; mass_item= ''; 
%       case 2
%        inertia0= ''; cg0= ''; mass0= ''; inertia_item= ''; cg_item= ''; 
%       case 3
%        inertia0= ''; cg0= ''; mass0= ''; inertia_item= ''; 
%       case 4
%        inertia0= ''; cg0= ''; mass0= ''; 
%       case 5
%        inertia0= ''; cg0= ''; 
%       case 6
%        inertia0= ''; 
%       case 7
%        
%       case 8
%        
%  end
%
%  if(isempty(inertia0))
%		inertia0 = -1;
%  end
%% Main Function:
%% Compute Reconfiguration Type:
switch configtype
    case {'subtract', 'SUBTRACT', 'Subtract', '-'}
        mult = -1;
    case {'add', 'ADD', 'Add', '+'}
        mult = 1;
    otherwise
        disp('ERROR in ReconfigureMassProps.m.  Unknown configtype.');
end

%% Compute New Mass:
mass_f = mass0 + mult * mass_item;       % [mass]

%% Check to See if Mass Still Exists:
if mass_f <= 0
    %% All Mass Has been Removed
    %   Final Mass Does not Exist.  Return NULL Mass Properties.
    mass_f       = 0.0;         % [mass]
    cg_f         = zeros(1,3);  % [dist]
    inertia_f    = zeros(3,3);  % [mass-dist^2]

else
    %% Mass Still Exists

    %% Compute New CG Location:
    cg_f = ((mass0*cg0) + mult * (mass_item*cg_item))/ mass_f;  % [dist]

    if mult == 1
        %% Item is to be added to Vehicle
        %   Reconfiguration Process:
        %   1 - Compute Distance from Vehicle's old CG to new CG
        %   2 - Use Parallel Axis Theorem with computed distance from 1
        %       to Relocate Vehicle's inertia (inertia0) to new combined CG
        %   3 - Compute Distance from Item's CG to new combined CG
        %   4 - Use Parallel Axis Theorem with computed distance from 3
        %       to Relocate Added Item's inertia to new combined CG
        %   5 - Add both Inertias at new combined CG.  Result is inertia_f

        %   1 - Compute Distance from Vehicle's old CG to new CG:
        d0f = cg0 - cg_f;                                           % [dist]

        %   2 - Use Parallel Axis Theorem with computed distance from 1
        %       to Relocate Vehicle's inertia (inertia0) to new combined
        %       CG:
        I_0cg.Ixx = inertia0(1,1) + mass0*( d0f(2)^2 + d0f(3)^2 );  % [mass-dist^2]
        I_0cg.Iyy = inertia0(2,2) + mass0*( d0f(1)^2 + d0f(3)^2 );  % [mass-dist^2]
        I_0cg.Izz = inertia0(3,3) + mass0*( d0f(1)^2 + d0f(2)^2 );  % [mass-dist^2]
        I_0cg.Ixy = -inertia0(1,2) + mass0 * d0f(1) * d0f(2);       % [mass-dist^2]
        I_0cg.Ixz = -inertia0(1,3) + mass0 * d0f(1) * d0f(3);       % [mass-dist^2]
        I_0cg.Iyz = -inertia0(2,3) + mass0 * d0f(2) * d0f(3);       % [mass-dist^2]
        I_0cg.Inertia = BuildupInertia( I_0cg );                       % [mass-dist^2]

        %   3 - Compute Distance from Item's CG to new combined CG:
        dif = cg_item - cg_f;                                           % [dist]

        %   4 - Use Parallel Axis Theorem with computed distance from 3
        %       to Relocate Added Item's inertia to new combined CG:
        I_icg.Ixx = inertia_item(1,1) + mass_item*( dif(2)^2 + dif(3)^2 );  % [mass-dist^2]
        I_icg.Iyy = inertia_item(2,2) + mass_item*( dif(1)^2 + dif(3)^2 );  % [mass-dist^2]
        I_icg.Izz = inertia_item(3,3) + mass_item*( dif(1)^2 + dif(2)^2 );  % [mass-dist^2]
        I_icg.Ixy = -inertia_item(1,2) + mass_item * dif(1) * dif(2);       % [mass-dist^2]
        I_icg.Ixz = -inertia_item(1,3) + mass_item * dif(1) * dif(3);       % [mass-dist^2]
        I_icg.Iyz = -inertia_item(2,3) + mass_item * dif(2) * dif(3);       % [mass-dist^2]
        I_icg.Inertia = BuildupInertia( I_icg );                    % [mass-dist^2]

        %   5 - Add both Inertias at new combined CG.  Result is inertia_f
        inertia_f = I_0cg.Inertia + I_icg.Inertia;                   % [dist]

    else
        %% Item is to be removed from Vehicle
        %   Reconfiguration Process:
        %   1 - Compute Distance from Item's CG to Vehicle's original CG
        %   2 - Use Parallel Axis Theorem with computed distance from 1
        %       to Relocate Item's inertia to old Vehicle's CG
        %   3 - Subtract the Item's inertia from the original inertia.  The
        %       result is the Vehicle's inertia at the old CG.
        %   4 - Compute Distance from Vehicle's Old CG to the Vehicle's new
        %       CG.
        %   5 - Use Parallel Axis Theorem with computed distance from 4
        %       to Relocate Vehicle's inertia to new CG.  Result is
        %       inertia_f.

        %   1 - Compute Distance from Item's CG to Vehicle's original CG:
        di0 = cg_item - cg0;                                           % [dist]

        %   2 - Use Parallel Axis Theorem with computed distance from 1
        %       to Relocate Item's inertia to old Vehicle's CG:
        I_icg.Ixx = inertia_item(1,1) + mass_item*( di0(2)^2 + di0(3)^2 );  % [mass-dist^2]
        I_icg.Iyy = inertia_item(2,2) + mass_item*( di0(1)^2 + di0(3)^2 );  % [mass-dist^2]
        I_icg.Izz = inertia_item(3,3) + mass_item*( di0(1)^2 + di0(2)^2 );  % [mass-dist^2]
        I_icg.Ixy = -inertia_item(1,2) + mass_item * di0(1) * di0(2);       % [mass-dist^2]
        I_icg.Ixz = -inertia_item(1,3) + mass_item * di0(1) * di0(3);       % [mass-dist^2]
        I_icg.Iyz = -inertia_item(2,3) + mass_item * di0(2) * di0(3);       % [mass-dist^2]
        I_icg.Inertia = BuildupInertia( I_icg );                    % [mass-dist^2]

        %   3 - Subtract the Item's inertia from the original inertia.  The
        %       result is the Vehicle's inertia at the old CG.:
        I_foldcg = inertia0 - I_icg.Inertia;

        %   4 - Compute Distance from Vehicle's Old CG to the Vehicle's new
        %       CG:
        d0f = cg0 - cg_f;                                           % [dist]

        %   5 - Use Parallel Axis Theorem with computed distance from 4
        %       to Relocate Vehicle's inertia to new CG.  Result is
        %       inertia_f:
        I_f.Ixx = I_foldcg(1,1) - mass_f*( d0f(2)^2 + d0f(3)^2 );  % [mass-dist^2]
        I_f.Iyy = I_foldcg(2,2) - mass_f*( d0f(1)^2 + d0f(3)^2 );  % [mass-dist^2]
        I_f.Izz = I_foldcg(3,3) - mass_f*( d0f(1)^2 + d0f(2)^2 );  % [mass-dist^2]
        I_f.Ixy = -I_foldcg(1,2) - mass_f * d0f(1) * d0f(2);       % [mass-dist^2]
        I_f.Ixz = -I_foldcg(1,3) - mass_f * d0f(1) * d0f(3);       % [mass-dist^2]
        I_f.Iyz = -I_foldcg(2,3) - mass_f * d0f(2) * d0f(3);       % [mass-dist^2]
        I_f.Inertia = BuildupInertia( I_f );                  % [mass-dist^2]

        inertia_f = I_f.Inertia;
    end


%% Compile Outputs:
%	mass_f= -1;
%	cg_f= -1;
%	inertia_f= -1;

end % << End of function ReconfigureMassProps >>

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
