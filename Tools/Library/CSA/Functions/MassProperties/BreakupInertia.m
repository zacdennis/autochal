% BREAKUPINERTIA Breaks up an inertia matrix into its components
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BreakupInertia:
%  Breaks up an inertia matrix into its individual components of Ixx, Iyy,
%  Izz, Ixy, Iyz, and Ixz
% 
% SYNTAX:
%	[MP] = BreakupInertia(MP, strUnits)
%	[MP] = BreakupInertia(MP)
%
% INPUTS: 
%	Name		Size    Units               Description
%	MP                  [structure]         Mass Property Data Structure
%   .Inertia   [3x3]    [mass*length^2]     Inertia Matrix where,
%                                           [    Ixx    -Ixy    -Ixz;
%                                               -Ixy     Iyy    -Iyz;
%                                               -Ixz    -Iyz     Izz ]
%   strUnits    'string' [char]             Units of Inputted Inertia.
%                                           Basic options are: slugft2,
%                                           kgm2, or none.  Default is
%                                           none.
%
% OUTPUTS: 
%	Name		Size    Units               Description
%   MP                  [structure]         Mass Property Data Structure
%    .Ixx       [1x1]   [mass*length^2]     Principal Inertia Element
%    .Iyy       [1x1]   [mass*length^2]     Principal Inertia Element
%    .Izz       [1x1]   [mass*length^2]     Principal Inertia Element
%    .Ixy       [1x1]   [mass*length^2]     Product of Inertia Element
%    .Ixz       [1x1]   [mass*length^2]     Product of Inertia Element
%    .Iyz       [1x1]   [mass*length^2]     Product of Inertia Element
%
% NOTES:
%   If 'strUnits' is 'slug-ft^2' or 'slugft2', function will look for
%   MP.Inertia_slugft2 and will return individual inertias of the form:
%   MP.<Inertia>_slugft2.
%
%   If 'strUnits' is 'kg-m^2' or 'kgm2', function will look for
%   MP.Inertia_kgm2 and will return individual inertias of the form:
%   MP.<Inertia>_kgm2.
%
%   If 'strUnits' is 'none' or not defined, function will look for
%   MP.Inertia and will return individual inertias of the form:
%   MP.<Inertia>.
%
% EXAMPLES:
%	% Example 1: Break up the Inertia matrix into its compenents
%   MP.Inertia = [25 -6 -8;
%                 -6 20 -12;
%                 -8 -12 13];
% 	[MP] = BreakupInertia(MP)
%	% Returns MP = 
%   %    Inertia: [3x3 double]
%   %        Ixx: 25
%   %        Iyy: 20
%   %        Izz: 13
%   %        Ixy: 6
%   %        Ixz: 8
%   %        Iyz: 12
%
%   % Example 2: Double check that breaking down after it was just built up
%   % returns the same inputs (e.g. show that you can go A --> B --> A)
%   MP.Ixx=25; MP.Iyy=20; MP.Izz=13; MP.Ixy= 6; MP.Ixz=8; MP.Iyz=12 
%   MP2.Inertia = BuildupInertia(MP);
%   MP2 = BreakupInertia(MP2);
%   dIxx = MP2.Ixx - MP.Ixx
%   dIyy = MP2.Iyy - MP.Iyy
%   dIzz = MP2.Izz - MP.Izz
%   dIxy = MP2.Ixy - MP.Ixy
%   dIyz = MP2.Iyz - MP.Iyz
%   dIxz = MP2.Ixz - MP.Ixz
%   % Returns all zeros for dIxx, dIyy, dIzz, dIxy, dIyz, and dIxz
%
%	% Example 3: Break up the Inertia matrix into its compenents
%   MP.Inertia_slugft2 = [25 -6 -8;
%                 -6 20 -12;
%                 -8 -12 13];
% 	[MP] = BreakupInertia(MP, 'slugft2')
%	% Returns MP = 
%   %   Inertia_slugft2: [3x3 double]
%   %       Ixx_slugft2: 25
%   %       Iyy_slugft2: 20
%   %       Izz_slugft2: 13
%   %       Ixy_slugft2: 6
%   %       Ixz_slugft2: 8
%   %       Iyz_slugft2: 12
%
% SOURCE DOCUMENTATION:
%	[1]    Hasbun, Javier E. Classical mechanics with MATLAB applications. 
%          Jones and Barlett, Sudbury, MA, Copyright 2009. Pg. 396
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit BreakupInertia.m">BreakupInertia.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_BreakupInertia.m">DRIVER_BreakupInertia.m</a>
%	  Documentation: <a href="matlab:pptOpen('BreakupInertia_Function_Documentation.pptx');">BreakupInertia_Function_Documentation.pptx</a>
%
% See also BuildupInertia 
%
% VERIFICATION DETAILS:
% Verified: Partial.  r628 was verified via Peer Review.  July 2012
%           enhancements have forced back into Peer Review queue.
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/400
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MassProperties/BreakupInertia.m $
% $Rev: 2417 $
% $Date: 2012-07-24 16:39:56 -0500 (Tue, 24 Jul 2012) $
% $Author: sufanmi $

function [MP] = BreakupInertia(MP, strUnits)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

if((nargin < 2) || isempty(strUnits))
    strUnits = 'none';
end

switch lower(strUnits)
    
    case {'slugft2'; '[slug-ft^2]'; 'slug-ft^2'}
        MP.Ixx_slugft2 = MP.Inertia_slugft2(1,1);
        MP.Iyy_slugft2 = MP.Inertia_slugft2(2,2);
        MP.Izz_slugft2 = MP.Inertia_slugft2(3,3);
        
        MP.Ixy_slugft2 = -MP.Inertia_slugft2(1,2);
        MP.Ixz_slugft2 = -MP.Inertia_slugft2(1,3);
        MP.Iyz_slugft2 = -MP.Inertia_slugft2(2,3);
        
    case {'kgm2'; '[kg-m^2]';'kg-m^2'}
        MP.Ixx_kgm2 = MP.Inertia_kgm2(1,1);
        MP.Iyy_kgm2 = MP.Inertia_kgm2(2,2);
        MP.Izz_kgm2 = MP.Inertia_kgm2(3,3);
        
        MP.Ixy_kgm2 = -MP.Inertia_kgm2(1,2);
        MP.Ixz_kgm2 = -MP.Inertia_kgm2(1,3);
        MP.Iyz_kgm2 = -MP.Inertia_kgm2(2,3);
        
    otherwise
        MP.Ixx = MP.Inertia(1,1);
        MP.Iyy = MP.Inertia(2,2);
        MP.Izz = MP.Inertia(3,3);
        
        MP.Ixy = -MP.Inertia(1,2);
        MP.Ixz = -MP.Inertia(1,3);
        MP.Iyz = -MP.Inertia(2,3);
end
end

%% REVISION HISTORY
% YYMMDD INI: note
% 120724 MWS: Added ability to specify units, either slugft2 or kgm2
% 100830 JJ:  Filled the example and source documentation
% 100819 JJ:  Function template created using CreateNewFunc
% 080910 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/MASS_PROPERTIES/BreakupInertia.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN Username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : g67086
% MWS: Mike Sufana      : mike.sufana@ngc.com               : sufanmi

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
