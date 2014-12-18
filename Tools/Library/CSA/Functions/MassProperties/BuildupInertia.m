% BUILDUPINERTIA Builds up inertia matrix from its individual components
% property data.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BuildupInertia:
%    Builds up an inertia matrix based in its individual components of Ixx,
%    Iyy, Izz, Ixy, Iyz, and Ixz
%
% SYNTAX:
%	[Inertia] = BuildupInertia(MP, strUnits)
%	[Inertia] = BuildupInertia(MP)
%
% INPUTS:
%	Name		Size    Units               Description
%	MP                  [structure]         Mass Property Data Structure
%    .Ixx       [1x1]   [mass*length^2]     Principal Inertia Element
%    .Iyy       [1x1]   [mass*length^2]     Principal Inertia Element
%    .Izz       [1x1]   [mass*length^2]     Principal Inertia Element
%    .Ixy       [1x1]   [mass*length^2]     Product of Inertia Element
%    .Ixz       [1x1]   [mass*length^2]     Product of Inertia Element
%    .Iyz       [1x1]   [mass*length^2]     Product of Inertia Element
%   strUnits    'string' [char]             Units of Inputted Inertia.
%                                           Basic options are: slugft2,
%                                           kgm2, or none.  Default is
%                                           none.
%
% OUTPUTS:
%	Name        Size    Units               Description
%   Inertia     [3x3]   [mass*length^2]     Inertia Matrix where,
%                                           [    Ixx    -Ixy    -Ixz;
%                                               -Ixy     Iyy    -Iyz;
%                                               -Ixz    -Iyz     Izz ]                                                 Izz ]
% NOTES:
%   If 'strUnits' is 'slug-ft^2' or 'slugft2', function will look for
%   inertias of the form: MP.<Inertia>_slugft2.
%
%   If 'strUnits' is 'kg-m^2' or 'kgm2', function will look for inertias of
%   the form: MP.<Inertia>_kgm2.
%
%   If 'strUnits' is 'none' or not defined, function will look forinertias
%   of the form: MP.<Inertia>.
%
% EXAMPLES:
%	% Example 1: Build up an Inertia matrix given its components
%   MP.Ixx=25; MP.Iyy=20; MP.Izz=13; MP.Ixy= 6; MP.Ixz=8; MP.Iyz=12
% 	[Inertia] = BuildupInertia(MP)
%	% Returns Inertia =[25 -6 -8; -6 20 -12; -8 -12 13]
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
%	% Example 2: Build up an Inertia matrix given its components
%   MP.Ixx_slugft2=25; MP.Iyy_slugft2=20; MP.Izz_slugft2=13; 
%   MP.Ixy_slugft2= 6; MP.Ixz_slugft2=8;  MP.Iyz_slugft2=12
% 	[Inertia_slugft2] = BuildupInertia(MP, 'slugft2')
%	% Returns Inertia_slugft2 =[25 -6 -8; -6 20 -12; -8 -12 13]
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
% SOURCE DOCUMENTATION:
%	[1]    Hasbun, Javier E. Classical mechanics with MATLAB applications.
%          Jones and Barlett, Sudbury, MA, Copyright 2009. Pg. 396
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit BuildupInertia.m">BuildupInertia.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_BuildupInertia.m">DRIVER_BuildupInertia.m</a>
%	  Documentation: <a href="matlab:pptOpen('BuildupInertia_Function_Documentation.pptx');">BuildupInertia_Function_Documentation.pptx</a>
%
% See also BreakupInertia
%
% VERIFICATION DETAILS:
% Verified: Partial.  r628 was verified via Peer Review.  July 2012
%           enhancements have forced back into Peer Review queue.
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/401
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MassProperties/BuildupInertia.m $
% $Rev: 2417 $
% $Date: 2012-07-24 16:39:56 -0500 (Tue, 24 Jul 2012) $
% $Author: sufanmi $

function [Inertia] = BuildupInertia(MP, strUnits)

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
        %% Input check
        if isempty(MP.Ixx_slugft2)
            error([mfnam ':InputArgCheck'], 'Ixx_slugft2 is empty. Please define Ixx_slugft2 as MP.Ixx_slugft2');
        end
        if isempty(MP.Iyy_slugft2)
            error([mfnam ':InputArgCheck'], 'Iyy_slugft2 is empty. Please define Iyy_slugft2 as MP.Iyy_slugft2');
        end
        if isempty(MP.Izz_slugft2)
            error([mfnam ':InputArgCheck'], 'Izz_slugft2 is empty. Please define Izz_slugft2 as MP.Izz_slugft2');
        end
        if isempty(MP.Ixy_slugft2)
            error([mfnam ':InputArgCheck'], 'Ixy_slugft2 is empty. Please define Ixy_slugft2 as MP.Ixy_slugft2');
        end
        if isempty(MP.Ixz_slugft2)
            error([mfnam ':InputArgCheck'], 'Ixz_slugft2 is empty. Please define Ixz_slugft2 as MP.Ixz_slugft2');
        end
        if isempty(MP.Iyz_slugft2)
            error([mfnam ':InputArgCheck'], 'Iyz_slugft2 is empty. Please define Iyz_slugft2 as MP.Iyz_slugft2');
        end
        %% Main Function:
        Inertia      = zeros(3,3);   % Initialize Inertia Matrix
        Inertia(1,1) =  MP.Ixx_slugft2;
        Inertia(1,2) = -MP.Ixy_slugft2;
        Inertia(1,3) = -MP.Ixz_slugft2;
        Inertia(2,1) = -MP.Ixy_slugft2;
        Inertia(2,2) =  MP.Iyy_slugft2;
        Inertia(2,3) = -MP.Iyz_slugft2;
        Inertia(3,1) = -MP.Ixz_slugft2;
        Inertia(3,2) = -MP.Iyz_slugft2;
        Inertia(3,3) =  MP.Izz_slugft2;

    case {'kgm2'; '[kg-m^2]';'kg-m^2'}
        %% Input check
        if isempty(MP.Ixx_kgm2)
            error([mfnam ':InputArgCheck'], 'Ixx_kgm2 is empty. Please define Ixx_kgm2 as MP.Ixx_kgm2');
        end
        if isempty(MP.Iyy_kgm2)
            error([mfnam ':InputArgCheck'], 'Iyy_kgm2 is empty. Please define Iyy_kgm2 as MP.Iyy_kgm2');
        end
        if isempty(MP.Izz_kgm2)
            error([mfnam ':InputArgCheck'], 'Izz_kgm2 is empty. Please define Izz_kgm2 as MP.Izz_kgm2');
        end
        if isempty(MP.Ixy_kgm2)
            error([mfnam ':InputArgCheck'], 'Ixy_kgm2 is empty. Please define Ixy_kgm2 as MP.Ixy_kgm2');
        end
        if isempty(MP.Ixz_kgm2)
            error([mfnam ':InputArgCheck'], 'Ixz_kgm2 is empty. Please define Ixz_kgm2 as MP.Ixz_kgm2');
        end
        if isempty(MP.Iyz_kgm2)
            error([mfnam ':InputArgCheck'], 'Iyz_kgm2 is empty. Please define Iyz_kgm2 as MP.Iyz_kgm2');
        end
        %% Main Function:
        Inertia      =  zeros(3,3);   % Initialize Inertia Matrix
        Inertia(1,1) =  MP.Ixx_kgm2;
        Inertia(1,2) = -MP.Ixy_kgm2;
        Inertia(1,3) = -MP.Ixz_kgm2;
        Inertia(2,1) = -MP.Ixy_kgm2;
        Inertia(2,2) =  MP.Iyy_kgm2;
        Inertia(2,3) = -MP.Iyz_kgm2;
        Inertia(3,1) = -MP.Ixz_kgm2;
        Inertia(3,2) = -MP.Iyz_kgm2;
        Inertia(3,3) =  MP.Izz_kgm2;
        
otherwise
    
    %% Input check
    if isempty(MP.Ixx)
        error([mfnam ':InputArgCheck'], 'Ixx is empty. Please define Ixx as MP.Ixx');
    end
    if isempty(MP.Iyy)
        error([mfnam ':InputArgCheck'], 'Iyy is empty. Please define Iyy as MP.Iyy');
    end
    if isempty(MP.Izz)
        error([mfnam ':InputArgCheck'], 'Izz is empty. Please define Izz as MP.Izz');
    end
    if isempty(MP.Ixy)
        error([mfnam ':InputArgCheck'], 'Ixy is empty. Please define Ixy as MP.Ixy');
    end
    if isempty(MP.Ixz)
        error([mfnam ':InputArgCheck'], 'Ixz is empty. Please define Ixz as MP.Ixz');
    end
    if isempty(MP.Iyz)
        error([mfnam ':InputArgCheck'], 'Iyz is empty. Please define Iyz as MP.Iyz');
    end
    %% Main Function:
    Inertia = zeros(3,3);   % Initialize Inertia Matrix
    Inertia(1,1) = MP.Ixx;
    Inertia(1,2) = -MP.Ixy;
    Inertia(1,3) = -MP.Ixz;
    Inertia(2,1) = -MP.Ixy;
    Inertia(2,2) = MP.Iyy;
    Inertia(2,3) = -MP.Iyz;
    Inertia(3,1) = -MP.Ixz;
    Inertia(3,2) = -MP.Iyz;
    Inertia(3,3) = MP.Izz;
end

end

%% REVISION HISTORY
% YYMMDD INI: note
% 120724 MWS: Added ability to specify units, either slugft2 or kgm2
% 100830 JJ:  Filled the example and source documentation
% 100819 JJ:  Function template created using CreateNewFunc
% 080910 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/MASS_PROPERTIES/BuildupInertia.m
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
