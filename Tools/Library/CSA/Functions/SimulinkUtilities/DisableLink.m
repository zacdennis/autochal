% DISABLELINK Disables all links in a Simulink model
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% DisableLink:
%     Disables all Library links in a Simulink model 
% 
% SYNTAX:
%	[lstDisabled] = DisableLink(nameModel, nameModelNew)
%	[lstDisabled] = DisableLink(nameModel)
%
% INPUTS: 
%	Name            Size		Units		Description
%	nameModel       'string'    [char]      Model file in which to disable
%                                            links
%	nameModelNew	'string'    [char]      New modelname.  If provided
%                                            will perform a 'save-as' 
%                                            nameModelNew
%	varargin	[N/A]           [varies]	Optional function inputs that
%                                           should be entered in pairs.
%                                           See the 'VARARGIN' section
%                                           below for more details
%
% OUTPUTS: 
%	Name       	Size		Units		Description
%	lstDisabled	{'string'}  N/A         List of blocks disabled in model
%
% NOTES:
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'SaveFolder'        'string'        Same as nameModel's source folder
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[lstDisabled] = DisableLink(nameModel)
%	% <Copy expected outputs from Command Window>
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit DisableLink.m">DisableLink.m</a>
%	  Driver script: <a href="matlab:edit Driver_DisableLink.m">Driver_DisableLink.m</a>
%	  Documentation: <a href="matlab:pptOpen('DisableLink_Function_Documentation.pptx');">DisableLink_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/574
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/DisableLink.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [lstDisabled] = DisableLink(nameModel, nameModelNew, varargin)

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
lstDisabled={};

switch(nargin)
    case 0
        nameModelNew = ''; nameModel= bdroot;
    case 1
        nameModelNew = '';
    case 2
        % Nominal
end

strWarn = 'Simulink:SL_SaveWithDisabledLinks_Warning';
warning('off', strWarn);

if(~isempty(nameModelNew))
    curFile = which(nameModel);
    [curFilePath, curFileShort, curFileExt] = fileparts(curFile);
    
    [SaveFolder, varargin]   = format_varargin('SaveFolder', curFilePath, 2, varargin);
    
    newFileFull = [SaveFolder filesep nameModelNew curFileExt];
            
    hd = pwd;
    cd(curFilePath)
    
    if(~strcmp(curFile, newFileFull))
        copyfile(curFile, newFileFull, 'f');
    end

    cd(hd);
    nameModel = nameModelNew;
end

%% Main Function:
%  <Insert Main Function>
load_system(nameModel);
lstSubs = find_system(nameModel, 'LookUnderMasks', 'all', 'FollowLinks', 'on', 'BlockType', 'SubSystem');

iDis = 0;
for iSub = 1:size(lstSubs, 1);
    curSub = lstSubs{iSub, :};
    
    curLinkStatus = get_param(curSub, 'LinkStatus');
    if(strcmp(curLinkStatus, 'resolved'))
        iDis = iDis + 1;
        lstDisabled(iDis,:) = { curSub };
        set_param(curSub, 'LinkStatus', 'inactive');
    end
end

save_system(nameModel);
warning('on', strWarn);
open_system(nameModel);

end % << End of function DisableLink >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 101011 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName            : Email     : NGGN Username 
% <initials>: <Fullname>   : <email>   : <NGGN username> 

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
