% FORMATLABEL Formats a string for easier plotting
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% FormatLabel:
%   Generates an easier to read plot string.  Converts signals like
%   P_ned(:,1) --> Pn for plotting purposes. 
% 
% SYNTAX:
%	[strLabel] = FormatLabel(strMeasurand, flgAllowFormat)
%	[strLabel] = FormatLabel(strMeasurand)
%
% INPUTS: 
%	Name          	Size		Units		Description
%  strMeasurand     [string]    [char]      String to format
%  flgAllowFormat   [1]         [bool]      Perform Formatting?
%                                            Default: 1 (true)
% OUTPUTS: 
%	Name          	Size		Units		Description
%  strLabel         'string'    [char]      Formatted String
%
% NOTES:
%
% EXAMPLES:
%   Example #1:
%   FormatLabel('P_ned(:,1)')
%   Returns Pn
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
%	Source function: <a href="matlab:edit FormatLabel.m">FormatLabel.m</a>
%	  Driver script: <a href="matlab:edit Driver_FormatLabel.m">Driver_FormatLabel.m</a>
%	  Documentation: <a href="matlab:pptOpen('FormatLabel_Function_Documentation.pptx');">FormatLabel_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/487
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/FormatLabel.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [strLabel] = FormatLabel(strMeasurand, flgAllowFormat)

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

strLabel = strMeasurand;

if nargin < 2
    flgAllowFormat = 1;
end

if(flgAllowFormat)

    strLabel = strrep(strLabel, '(:,', '(');
    
    strLabel = strrep(strLabel, 'Load(1)', 'nx');
    strLabel = strrep(strLabel, 'Load(2)', 'ny');
    strLabel = strrep(strLabel, 'Load(3)', 'nz');
    
    strLabel = strrep(strLabel, 'P_ned(1)', 'Pn');
    strLabel = strrep(strLabel, 'P_ned(2)', 'Pe');
    strLabel = strrep(strLabel, 'P_ned(3)', 'Pd');

    strLabel = strrep(strLabel, 'V_ned(1)', 'Vn');
    strLabel = strrep(strLabel, 'V_ned(2)', 'Ve');
    strLabel = strrep(strLabel, 'V_ned(3)', 'Vd');
        
    strLabel = strrep(strLabel, 'Euler_i(1)', 'Phi_{i}');
    strLabel = strrep(strLabel, 'Euler_i(2)', 'Theta_{i}');
    strLabel = strrep(strLabel, 'Euler_i(3)', 'Psi_{i}');
    
    strLabel = strrep(strLabel, 'Euler_lvlh(1)', 'Phi_{lvlh}');
    strLabel = strrep(strLabel, 'Euler_lvlh(2)', 'Theta_{lvlh}');
    strLabel = strrep(strLabel, 'Euler_lvlh(3)', 'Psi_{lvlh}');
    
    strLabel = strrep(strLabel, 'Euler_ned(1)', 'Phi_{ned}');
    strLabel = strrep(strLabel, 'Euler_ned(2)', 'Theta_{ned}');
    strLabel = strrep(strLabel, 'Euler_ned(3)', 'Psi_{ned}');
    
    strLabel = strrep(strLabel, 'Euler_ned(1)', 'Phi_{ned}');
    strLabel = strrep(strLabel, 'Euler_ned(2)', 'Theta_{ned}');
    strLabel = strrep(strLabel, 'Euler_ned(3)', 'Psi_{ned}');

    strLabel = strrep(strLabel, 'EulerError(1)', 'PhiError');
    strLabel = strrep(strLabel, 'EulerError(2)', 'ThetaError');
    strLabel = strrep(strLabel, 'EulerError(3)', 'PsiError');
    
    strLabel = strrep(strLabel, 'EulerDeadband(1)', 'PhiDeadband');
    strLabel = strrep(strLabel, 'EulerDeadband(2)', 'ThetaDeadband');
    strLabel = strrep(strLabel, 'EulerDeadband(3)', 'PsiDeadband');
    
    strLabel = strrep(strLabel, 'PosCmd(1)', 'XPosCmd');
    strLabel = strrep(strLabel, 'PosCmd(2)', 'YPosCmd');
    strLabel = strrep(strLabel, 'PosCmd(3)', 'ZPosCmd');
    
    strLabel = strrep(strLabel, 'Pos(1)', 'XPos');
    strLabel = strrep(strLabel, 'Pos(2)', 'YPos');
    strLabel = strrep(strLabel, 'Pos(3)', 'ZPos');
    
    strLabel = strrep(strLabel, 'PosError(1)', 'XPosError');
    strLabel = strrep(strLabel, 'PosError(2)', 'YPosError');
    strLabel = strrep(strLabel, 'PosError(3)', 'ZPosError');
    
    strLabel = strrep(strLabel, 'PositionDeadband(1)', 'XPosDeadband');
    strLabel = strrep(strLabel, 'PositionDeadband(2)', 'YPosDeadband');
    strLabel = strrep(strLabel, 'PositionDeadband(3)', 'ZPosDeadband');
    
    strLabel = strrep(strLabel, 'Euler_deg(1)', 'Phi');
    strLabel = strrep(strLabel, 'Euler_deg(2)', 'Theta');
    strLabel = strrep(strLabel, 'Euler_deg(3)', 'Psi');
    
    strLabel = strrep(strLabel, 'EulerCmd_deg(1)', 'PhiCmd');
    strLabel = strrep(strLabel, 'EulerCmd_deg(2)', 'ThetaCmd');
    strLabel = strrep(strLabel, 'EulerCmd_deg(3)', 'PsiCmd');
    
    strLabel = strrep(strLabel, 'EulerError_deg(1)', 'PhiError');
    strLabel = strrep(strLabel, 'EulerError_deg(2)', 'ThetaError');
    strLabel = strrep(strLabel, 'EulerError_deg(3)', 'PsiError');
    
    strLabel = strrep(strLabel, 'PQRbody(1)', 'Pb');
    strLabel = strrep(strLabel, 'PQRbody(2)', 'Qb');
    strLabel = strrep(strLabel, 'PQRbody(3)', 'Rb');

    strLabel = strrep(strLabel, 'PQRbodyDot(1)', 'PbDot');
    strLabel = strrep(strLabel, 'PQRbodyDot(2)', 'QbDot');
    strLabel = strrep(strLabel, 'PQRbodyDot(3)', 'RbDot');
    
    strLabel = strrep(strLabel, 'CG(1)', 'XCG');
    strLabel = strrep(strLabel, 'CG(2)', 'YCG');
    strLabel = strrep(strLabel, 'CG(3)', 'ZCG');
    
    strLabel = strrep(strLabel, 'Forces(1)', 'Fx');
    strLabel = strrep(strLabel, 'Forces(2)', 'Fy');
    strLabel = strrep(strLabel, 'Forces(3)', 'Fz');
    
    strLabel = strrep(strLabel, 'MomentCmds(1)', 'MxCmd');
    strLabel = strrep(strLabel, 'MomentCmds(2)', 'MyCmd');
    strLabel = strrep(strLabel, 'MomentCmds(3)', 'MzCmd');
    
    strLabel = strrep(strLabel, 'Moments(1)', 'Mx');
    strLabel = strrep(strLabel, 'Moments(2)', 'My');
    strLabel = strrep(strLabel, 'Moments(3)', 'Mz');
    
    strLabel = strrep(strLabel, 'EulerCmdPlusDB(1)', 'PhiCmdPlusDB');
    strLabel = strrep(strLabel, 'EulerCmdPlusDB(2)', 'ThetaCmdPlusDB');
    strLabel = strrep(strLabel, 'EulerCmdPlusDB(3)', 'PsiCmdPlusDB');
    
    strLabel = strrep(strLabel, 'EulerCmdMinusDB(1)', 'PhiCmdMinusDB');
    strLabel = strrep(strLabel, 'EulerCmdMinusDB(2)', 'ThetaCmdMinusDB');
    strLabel = strrep(strLabel, 'EulerCmdMinusDB(3)', 'PsiCmdMinusDB');

    strLabel = strrep(strLabel, 'Target_PQRb_Rel_to_Chaser_in_Chaser_body(1)', 'Target_Pb_Rel_to_Chaser_in_Chaser_body');
    strLabel = strrep(strLabel, 'Target_PQRb_Rel_to_Chaser_in_Chaser_body(2)', 'Target_Qb_Rel_to_Chaser_in_Chaser_body');
    strLabel = strrep(strLabel, 'Target_PQRb_Rel_to_Chaser_in_Chaser_body(3)', 'Target_Rb_Rel_to_Chaser_in_Chaser_body');
    
    strLabel = strrep(strLabel, 'Euler_deg_from_Chaser_body_to_Target_body(1)', 'Phi_from_Chaser_body_to_Target_body');
    strLabel = strrep(strLabel, 'Euler_deg_from_Chaser_body_to_Target_body(2)', 'Theta_from_Chaser_body_to_Target_body');
    strLabel = strrep(strLabel, 'Euler_deg_from_Chaser_body_to_Target_body(3)', 'Psi_from_Chaser_body_to_Target_body');
    

end % << End of function FormatLabel >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101019 CNF: Cleaned up function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
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
