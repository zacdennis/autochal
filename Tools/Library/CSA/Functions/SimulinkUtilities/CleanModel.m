% CLEANMODEL Resizes the Simulink model
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CleanModel:
% Resize Simulink model
% This function performs the following functions:
% 1.) Resizes Simulink systems and all subsystems.
% 2.) Closes all open scopes
% 3.) Sets the zoom factor to auto for all subsystems
% Optionally takes input for the System name and size of window
%
% SYNTAX:
%	[] = CleanModel(strSystem, newsize, flg_verbose, flg_Save)
%	[] = CleanModel(strSystem, newsize, flg_verbose)
%
% INPUTS:
%	Name       	Size		Units		Description
%   strSystem   'string'    [char]      String of Name of Simulink model
%   newsize     [1x4]       [pixels]    Desired screen location
%                                       [left top right bottom]
%   flg_verbose [1]         [bool]      Enable command line displayed text
%	flg_Save    [1]         [bool]      Put model in a saveable state?
%                                        Optional: Default is 0 (no)
%
% OUTPUTS:
%	Name       	Size		Units		Description
%   No variable outputs
%
% NOTES:
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[] = CleanModel(strSystem, newsize, flg_verbose, flg_Save, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CleanModel.m">CleanModel.m</a>
%	  Driver script: <a href="matlab:edit Driver_CleanModel.m">Driver_CleanModel.m</a>
%	  Documentation: <a href="matlab:pptOpen('CleanModel_Function_Documentation.pptx');">CleanModel_Function_Documentation.pptx</a>
%
% See also <add relevant functions>
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/533
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CleanModel.m $
% $Rev: 3150 $
% $Date: 2014-04-18 21:00:54 -0500 (Fri, 18 Apr 2014) $
% $Author: salluda $

function [] = CleanModel(strSystem, newsize, flg_verbose, flg_Save, varargin)

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

%% Input Argument Conditioning:
if nargin < 4
    flg_Save = 0;
end

if nargin < 3
    flg_verbose = 0;
end

%% Main Function:

%% Get the current screensize:
scrsz = get(0,'ScreenSize');
if(flg_verbose)
    disp('Currently Identified Screen Size:')
    disp(num2str(scrsz));
end

ModelBrowserWidth = 200;

%% Safe Sizes if not user-defined:
if nargin == 0
    strSystem = gcs;
end
strSystem = bdroot(strSystem);

lstOpenDiagrams = find_system('type', 'block_diagram');
flgIsOpen = any(strcmp(lstOpenDiagrams, strSystem));

if(flgIsOpen == 0)
    load_system(strSystem);
end

if nargin < 2 || isempty(newsize)
    switch scrsz(3)
        case 1024
            ModelBrowserWidth = 150;
            width = 700;
            height = 500;
            left = 100;
            top = 100;
            newsize = [ModelBrowserWidth+left top ModelBrowserWidth+left+width top+height];
        case 1280
            ModelBrowserWidth = 200;
            width = 800;
            height = 650;
            left = 175;
            top = 185;
            newsize = [ModelBrowserWidth+left top ModelBrowserWidth+left+width top+height];
        case 1440
            ModelBrowserWidth = 200;
            width = 900;
            height = 600;
            left = 100;
            top = 150;
            newsize = [ModelBrowserWidth+left top ModelBrowserWidth+left+width top+height];
        case 1600
            ModelBrowserWidth = 275;
            width = 900;
            height = 700;
            left = 200;
            top = 200;
            newsize = [ModelBrowserWidth+left top ModelBrowserWidth+left+width top+height];
        case 1680
            ModelBrowserWidth = 275;
            width = 900;
            height = 700;
            left = 200;
            top = 200;
            newsize = [ModelBrowserWidth+left top ModelBrowserWidth+left+width top+height];
        case 1920
            ModelBrowserWidth = 295;
            width = 1000;
            height = 700;
            left = 210;
            top = 200;
            newsize = [ModelBrowserWidth+left top ModelBrowserWidth+left+width top+height];
        case 2560
            ModelBrowserWidth = 355;
            width = 1450;
            height = 950;
            left = 100;
            top = 200;
            newsize = [ModelBrowserWidth+left top ModelBrowserWidth+left+width top+height];
        otherwise
            disp('CleanModel : No predefined window size available.');
            disp('             Please call the script with a desired size argument.');
            disp('             Defaulting to a "safe" value - this might look too small');
            ModelBrowserWidth = 100;
            width = 500;
            height = 300;
            left = 50;
            top = 100;
            newsize = [ModelBrowserWidth+left top ModelBrowserWidth+left+width top+height];
    end
end

if(flg_verbose)
    disp('Resizing to:');
    disp(num2str(newsize));
end

% Find all blocks inside current system:
allBlks = find_system(strSystem);
% Find all Subsystems within current system:
subBlks = find_system(strSystem, 'BlockType', 'SubSystem');
% Find all Open Subsystems within current system:
openBlks = find_system(strSystem, 'Open', 'on');
% Find all Scopes:
scopeBlks = find_system(strSystem, 'BlockType', 'Scope');

%% Turn on and resize the ModelBrowser:
% set_param(strSystem, 'ModelBrowserVisibility', 'on');
% set_param(strSystem, 'ModelBrowserWidth', ModelBrowserWidth);

%% Resize the root level:
set_param(strSystem, 'Location', newsize);
set_param(strSystem, 'ZoomFactor', 'FitSystem');
if (str2double(get_param(strSystem, 'ZoomFactor')) > 100)
    set_param(strSystem, 'ZoomFactor', '100')
end

%% Resize all Subsystem Blocks:
for i = 1 : length(subBlks)
    set_param(subBlks{i}, 'Location', newsize);
    % Set zoomfactor to fit:
    set_param(subBlks{i}, 'ZoomFactor', 'FitSystem');
end

%% Close Open Subsystem Blocks:
for i = 1 : length(openBlks)
    set_param(openBlks{i}, 'Open', 'off');
end

%% Close Open Scope Blocks:
for i = 1 : length(scopeBlks)
    set_param(scopeBlks{i}, 'Open', 'off');
end

%% Ensure that the root level system stays open:
set_param(strSystem, 'Open', 'on')


%% Turn on and resize the ModelBrowser:
set_param(strSystem, 'ModelBrowserVisibility', 'on');
set_param(strSystem, 'ModelBrowserWidth', ModelBrowserWidth);

%% Compile Outputs:

end % << End of function CleanModel >>

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
