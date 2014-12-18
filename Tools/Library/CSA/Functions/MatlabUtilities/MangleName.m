% MANGLENAME Modifies a String using a List of String Find/Replaces
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% MangleName:
%   This function mangles a string using a series of string replaces
%   ('strrep').
%
% SYNTAX:
%	[strNew] = MangleName(strOrig, ReplacePeriod)
%	[strNew] = MangleName(strOrig)
%
% INPUTS:
%	Name            Size		Units		Description
%	strOrig         'string'    [char]      String to Mangle
%   ReplacePeriod   [1]         [bool]      Replace and periods ('.') in 
%                                           the 'strOrig' with an 
%                                           underscore? ('_')
%                                           Default: true (1)
% OUTPUTS:
%	Name            Size		Units		Description
%	strNew          'string'    [char]      Mangled String
%
% NOTES:
%
% EXAMPLES:
%	% Mangle an example string
%   strOrig = 'TruthStates_P_ned1_ft'
%	[strNew] = MangleName(strOrig)
%
%   % returns: strNew = TruthStates_Pn_ft
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit MangleName.m">MangleName.m</a>
%	  Driver script: <a href="matlab:edit Driver_MangleName.m">Driver_MangleName.m</a>
%	  Documentation: <a href="matlab:pptOpen('MangleName_Function_Documentation.pptx');">MangleName_Function_Documentation.pptx</a>
%
% See also strrep
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/672
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [strNew] = MangleName(strOrig, ReplacePeriod, lstUserDefined)

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

if((nargin < 3))
    lstUserDefined = {};
end

if((nargin < 2) || isempty(ReplacePeriod))
    ReplacePeriod = true;
end

%% Main Function:
strNew = strOrig;
if(ReplacePeriod)
    strNew = strrep(strNew, '.', '_');
end

%% Find/Replace User Defined:
if(~isempty(lstUserDefined))
    numExternal = size(lstUserDefined, 1);
    for iExternal = 1:numExternal
        curLook = lstUserDefined{iExternal, 1};
        curReplace = lstUserDefined{iExternal, 2};
        strNew = strrep(strNew, curLook, curReplace);
    end
end

%% Find/Replace Internal Defined:
lstInternal = {...
    'InitialEOMState'       'EOM';
    'MP_'                   '';
    'P_i1'                  'Px_i';
    'P_i2'                  'Py_i';
    'P_i3'                  'Pz_i';
    'P_f1'                  'Px_f';
    'P_f2'                  'Py_f';
    'P_f3'                  'Pz_f';
    'P_ned1'                'Pn';
    'P_ned2'                'Pe';
    'P_ned3'                'Pd';
    'P_lvlh1'               'Px_lvlh';
    'P_lvlh2'               'Py_lvlh';
    'P_lvlh3'               'Pz_lvlh';
    'P_i_Error1'            'Px_i_Error';
    'P_i_Error2'            'Py_i_Error';
    'P_i_Error3'            'Pz_i_Error';
    'P_f_Error1'            'Px_f_Error';
    'P_f_Error2'            'Py_f_Error';
    'P_f_Error3'            'Pz_f_Error';
    'P_ned_Error1'          'Pn_Error';
    'P_ned_Error2'          'Pe_Error';
    'P_ned_Error3'          'Pd_Error';    
    'LLA_Error1'            'GeodeticLat_Error';
    'LLA_Error2'            'Longitude_Error';
    'LLA_Error3'            'Alt_Error';
    'V_b1'                  'ub';
    'V_b2'                  'vb';
    'V_b3'                  'wb';
    'V_i1'                  'Vx_i';
    'V_i2'                  'Vy_i';
    'V_i3'                  'Vz_i';
    'V_f1'                  'Vx_f';
    'V_f2'                  'Vy_f';
    'V_f3'                  'Vz_f';
    'V_ned1'                'Vn';
    'V_ned2'                'Ve';
    'V_ned3'                'Vd';
    'V_lvlh1'               'Vx_lvlh';
    'V_lvlh2'               'Vy_lvlh';
    'V_lvlh3'               'Vz_lvlh';
    'V_brel1'               'ub_rel';
    'V_brel2'               'vb_rel';
    'V_brel3'               'wb_rel';
    'V_i_Error1'            'Vx_i_Error'
    'V_i_Error2'            'Vy_i_Error'
    'V_i_Error3'            'Vz_i_Error'
    'V_f_Error1'            'Vx_f_Error'
    'V_f_Error2'            'Vy_f_Error'
    'V_f_Error3'            'Vz_f_Error'
    'V_ned_Error1'          'Vn_Error'
    'V_ned_Error2'          'Ve_Error'
    'V_ned_Error3'          'Vd_Error'
    'V_lvlh_Error1'         'Vx_lvlh_Error'
    'V_lvlh_Error2'         'Vy_lvlh_Error'
    'V_lvlh_Error3'         'Vz_lvlh_Error'
    'VbDot1'                'ubDot';
    'VbDot2'                'vbDot';
    'VbDot3'                'wbDot';
    'VbDot_Vb1'             'ubDot_Vb';
    'VbDot_Vb2'             'vbDot_Vb';
    'VbDot_Vb3'             'wbDot_Vb';
    'VbDot_Pf1'             'ubDot_Pf';
    'VbDot_Pf2'             'vbDot_Pf';
    'VbDot_Pf3'             'wbDot_Pf';
    'A_i1'                  'Ax_i'
    'A_i2'                  'Ay_i'
    'A_i3'                  'Az_i'
    'A_f1'                  'Ax_f'
    'A_f2'                  'Ay_f'
    'A_f3'                  'Az_f'
    'A_ned1'                'An'
    'A_ned2'                'Ae'
    'A_ned3'                'Ad'
    'A_lvlh1'               'Ax_lvlh'
    'A_lvlh2'               'Ay_lvlh'
    'A_lvlh3'               'Az_lvlh'
    'A_b_nongrav1'          'Ax_b_nongrav'
    'A_b_nongrav2'          'Ay_b_nongrav'
    'A_b_nongrav3'          'Az_b_nongrav'
    'A_ned_nongrav1'        'An_nongrav';
    'A_ned_nongrav2'        'Ae_nongrav';
    'A_ned_nongrav3'        'Ad_nongrav';
    'G_b1'                  'Gx_b'
    'G_b2'                  'Gy_b'
    'G_b3'                  'Gz_b'
    'G_i1'                  'Gx_i'
    'G_i2'                  'Gy_i'
    'G_i3'                  'Gz_i'
    'G_f1'                  'Gx_f'
    'G_f2'                  'Gy_f'
    'G_f3'                  'Gz_f'
    'G_ned1'                'Gn'
    'G_ned2'                'Ge'
    'G_ned3'                'Gd'
    'G_lvlh1'               'Gx_lvlh'
    'G_lvlh2'               'Gy_lvlh'
    'G_lvlh3'               'Gz_lvlh'
    'Euler1'                'Phi'
    'Euler2'                'Theta'
    'Euler3'                'Psi'
    'Euler_b_rel1'          'Phi_rel'
    'Euler_b_rel2'          'Theta_rel'
    'Euler_b_rel3'          'Psi_rel'
    'Euler_i1'              'Phi_i'
    'Euler_i2'              'Theta_i'
    'Euler_i3'              'Psi_i'
    'Euler_f1'              'Phi_f'
    'Euler_f2'              'Theta_f'
    'Euler_f3'              'Psi_f'
    'Euler_ned1'            'Phi_ned'
    'Euler_ned2'            'Theta_ned'
    'Euler_ned3'            'Psi_ned'
    'Euler_lvlh1'           'Phi_lvlh'
    'Euler_lvlh2'           'Theta_lvlh'
    'Euler_lvlh3'           'Psi_lvlh'
    'Euler_i_Error1'        'Phi_i_Error'
    'Euler_i_Error2'        'Theta_i_Error'
    'Euler_i_Error3'        'Psi_i_Error'
    'Euler_f_Error1'        'Phi_f_Error'
    'Euler_f_Error2'        'Theta_f_Error'
    'Euler_f_Error3'        'Psi_f_Error'
    'Euler_ned_Error1'      'Phi_ned_Error'
    'Euler_ned_Error2'      'Theta_ned_Error'
    'Euler_ned_Error3'      'Psi_ned_Error'
    'Euler_lvlh_Error1'     'Phi_lvlh_Error'
    'Euler_lvlh_Error2'     'Theta_lvlh_Error'
    'Euler_lvlh_Error3'     'Psi_lvlh_Error'
    'EulerDot_ned1'         'PhiDot_ned'
    'EulerDot_ned2'         'ThetaDot_ned'
    'EulerDot_ned3'         'PsiDot_ned'
    'Euler_ned_Accuracy1'   'Phi_ned_Accuracy'
    'Euler_ned_Accuracy2'   'Theta_ned_Accuracy'
    'Euler_ned_Accuracy3'   'Psi_ned_Accuracy'
    'PQRbodyDot1'           'PbDot'
    'PQRbodyDot2'           'QbDot'
    'PQRbodyDot3'           'RbDot'
    'PQRbDot1'              'PbDot'
    'PQRbDot2'              'QbDot'
    'PQRbDot3'              'RbDot'
    'PQRbDotPlant1'         'PbDotPlant'
    'PQRbDotPlant2'         'QbDotPlant'
    'PQRbDotPlant3'         'RbDotPlant'
    'PQRbDotCmd1'           'PbDotCmd'
    'PQRbDotCmd2'           'QbDotCmd'
    'PQRbDotCmd3'           'RbDotCmd'
    'PQRbDotError1'         'PbDotError'
    'PQRbDotError2'         'QbDotError'
    'PQRbDotError3'         'RbDotError'
    'PQRbody1'              'Pb'
    'PQRbody2'              'Qb'
    'PQRbody3'              'Rb'
    'PQRb1'                 'Pb'
    'PQRb2'                 'Qb'
    'PQRb3'                 'Rb'
    'PQRb_wrt_i1'           'Pb_wrt_i'
    'PQRb_wrt_i2'           'Qb_wrt_i'
    'PQRb_wrt_i3'           'Rb_wrt_i'
    'PQRb_wrt_f1'           'Pb_wrt_f'
    'PQRb_wrt_f2'           'Qb_wrt_f'
    'PQRb_wrt_f3'           'Rb_wrt_f'
    'PQRb_wrt_ned1'         'Pb_wrt_ned'
    'PQRb_wrt_ned2'         'Qb_wrt_ned'
    'PQRb_wrt_ned3'         'Rb_wrt_ned'
    'PQRb_Error1'           'Pb_Error'
    'PQRb_Error2'           'Qb_Error'
    'PQRb_Error3'           'Rb_Error'
    'PQRb_Bias1'            'Pb_Bias'
    'PQRb_Bias2'            'Qb_Bias'
    'PQRb_Bias3'            'Rb_Bias'
    'PQRb_GaussNoise_var1'  'Pb_GaussNoise_var'
    'PQRb_GaussNoise_var2'  'Qb_GaussNoise_var'
    'PQRb_GaussNoise_var3'  'Rb_GaussNoise_var'
    'PQRb_GaussNoise1'      'Pb_GaussNoise'
    'PQRb_GaussNoise2'      'Qb_GaussNoise'
    'PQRb_GaussNoise3'      'Rb_GaussNoise'
    'Gyro_Noise1'           'Gyro_Pb_Noise'
    'Gyro_Noise2'           'Gyro_Qb_Noise'
    'Gyro_Noise3'           'Gyro_Rb_Noise'
    'CG1'                   'XCG'
    'CG2'                   'YCG'
    'CG3'                   'ZCG'
    'A_b1'                  'Ax_b'
    'A_b2'                  'Ay_b'
    'A_b3'                  'Az_b'
    'Load1'                 'nx'
    'Load2'                 'ny'
    'Load3'                 'nz'
    'Load_Bias1'            'nx_Bias'
    'Load_Bias2'            'ny_Bias'
    'Load_Bias3'            'nz_Bias'
    'Load_GaussNoise_var1' 'nx_GaussNoise_var'
    'Load_GaussNoise_var2' 'ny_GaussNoise_var'
    'Load_GaussNoise_var3' 'nz_GaussNoise_var'
    'Load_GaussNoise1'      'nx_GaussNoise'
    'Load_GaussNoise2'      'ny_GaussNoise'
    'Load_GaussNoise3'      'nz_GaussNoise'
    'Accel_Noise1'          'Accel_nx_Noise'
    'Accel_Noise2'          'Accel_ny_Noise'
    'Accel_Noise3'          'Accel_nz_Noise'
    'Forces1'               'Fx'
    'Forces2'               'Fy'
    'Forces3'               'Fz'
    'Moments1'              'Mx'
    'Moments2'              'My'
    'Moments3'              'Mz'
    'EpochStart1'           'EpochStartYear'
    'EpochStart2'           'EpochStartMonth'
    'EpochStart3'           'EpochStartDay'
    'EpochStart4'           'EpochStartHour'
    'EpochStart5'           'EpochStartMin'
    'EpochStart6'           'EpochStartSec'
    'InitialEOMState'       'EOM'
    };

numInternal = size(lstInternal, 1);
for iInternal = 1:numInternal
    curLook = lstInternal{iInternal, 1};
    curReplace = lstInternal{iInternal, 2};
    strNew = strrep(strNew, curLook, curReplace);
end



end % << End of function MangleName >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110120 MWS: Created function using CreateNewFunc
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
