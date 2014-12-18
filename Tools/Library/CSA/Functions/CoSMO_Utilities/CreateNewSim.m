% CREATENEWSIM Creates a new simulation from an existing simulation
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateNewSim:
%     Creates a new simulation from an existing simulation.  This is a
%     massive copy/save-as and find/replace-all routine.
% 
% SYNTAX:
%	[lstFiles] = CreateNewSim(VehName, varargin, 'PropertyName', PropertyValue)
%	[lstFiles] = CreateNewSim(VehName, varargin)
%	[lstFiles] = CreateNewSim(VehName)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	VehName     'string'    [char]      Name of New Vehicle
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	lstFiles	{'string'}  {[char]}    Cell array of strings listing all
%                                        files created
%
% NOTES:
%	This function uses CSA functions 'dir_list' and 'format_varagin'.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'SkeletonRoot'      'string'        ''          Full path of Skeleton
%                                                    Root folder
%   'SkeletonVeh'       'string'        'StarterVeh' Name of Starter
%                                                    Vehicle
%   'NewVehRoot'        'string'        ''          Path to New Vehicle
%                                                    Directory
%   'RevHistoryInfo'    struct          ''          Structure with Revision
%                                                    History Data
%   'AdditionalFindReplace' {nx2}       {'string' string'}  Additional list
%                                                   of find/replace strings
%
%  RevHistoryInfo               Information of New Sim's Simulation Lead
%   .<struct member>    Size        Units       Description
%   .INI                'string'    [char]      Initials
%   .FullName           'string'    [char]      Full name
%   .Email              'string'    [char]      Email address
%   .NGGN               'string'    [char]      NGGN Username (5+2)
%
% EXAMPLES:
%	% Create Start Files for your new Vehicle
%	[lstFiles] = CreateNewSim('SensorCraft', 'SkeletonRoot','C:\Work\CSA\CSA\Skeletons\SRV','NewVehRoot','C:\Work\CSA\CSA\Skeletons\SensorCraft')
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CreateNewSim.m">CreateNewSim.m</a>
%	  Driver script: <a href="matlab:edit Driver_CreateNewSim.m">Driver_CreateNewSim.m</a>
%	  Documentation: <a href="matlab:pptOpen('CreateNewSim_Function_Documentation.pptx');">CreateNewSim_Function_Documentation.pptx</a>
%
% See also dir_list, format_varagin 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/759
%
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoSMO_Utilities/CreateNewSim.m $
% $Rev: 2494 $
% $Date: 2012-10-01 13:40:27 -0500 (Mon, 01 Oct 2012) $
% $Author: sufanmi $
function [lstFiles] = CreateNewSim(VehName, varargin)
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
lstFiles= {};

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[SkeletonRoot, varargin]        = format_varargin('SkeletonRoot', '', 2, varargin);
[strSkeletonVeh, varargin]      = format_varargin('SkeletonVeh', 'SRV', 2, varargin);
[NewVehRoot, varargin]          = format_varargin('NewVehRoot', '', 2, varargin);
[RevHistoryInfo, varargin]      = format_varargin('RevHistoryInfo', '', 2, varargin);
[lstDirsToExclude, varargin]    = format_varargin('DirExclude', {'.svn';'private';'CSA_LIB';'slprj'}, 2, varargin);
[lstFilesToExclude, varargin]   = format_varargin('FileExclude', {'sfun.mexw32';'msf.mexw32'}, 2, varargin);
[lstUserFindReplace, varargin]  = format_varargin('AdditionalFindReplace', '', 2, varargin);

if(isempty(SkeletonRoot))
    SkeletonRoot = [fileparts(mfilename('fullpath')) filesep 'Skeletons' filesep strSkeletonVeh];
    SkeletonRoot = strrep(SkeletonRoot, ['CSA' filesep 'Functions' filesep 'CoSMO_Utilities' filesep], '');
end

%% Main Function:
if(isempty(VehName))
    disp(sprintf('ERROR: VehName must be provided'));
else
    if(isempty(NewVehRoot))
        NewVehRoot = [fileparts(mfilename('fullpath')) filesep 'Skeletons' filesep VehName];
    end
    % Create the New vehicle's root director
     if(~isdir(NewVehRoot))
        mkdir(NewVehRoot);
    end
%     cd(NewVehRoot);
 
    % Compile the list of all the files to copy
    disp(sprintf('%s: Compiling list of reference files to copy.  Using ''%s''...', mfilename, strSkeletonVeh));
    lstSkeletonFiles = dir_list('', 1, 'Root', SkeletonRoot, ...
        'DirExclude',lstDirsToExclude, 'FileExclude', lstFilesToExclude);
    numFiles = size(lstSkeletonFiles, 1);
    disp(sprintf('%s: %d files found.  Copying & Reformatting files.  Changing ''%s'' to ''%s''...', ...
        mfilename, numFiles, strSkeletonVeh, VehName));
    lstFiles = cell(numFiles, 1);
    
    for iFile = 1:numFiles
    
        % Pick off File and manipulate filenames
        curFileFull = lstSkeletonFiles{iFile, :};       
        [curFolderFull, curFileShort, curFileExt] = fileparts(curFileFull);
        
        curFolderRel = strrep(curFolderFull, [SkeletonRoot], '');
        curFolderRel = strrep(curFolderRel, strSkeletonVeh, VehName);
        
        curFileRel = strrep(curFileFull, [SkeletonRoot filesep], '');

        % Construct the directory first before copying stuff into it
        newFolderFull = [NewVehRoot curFolderRel];
        if(~isdir(newFolderFull))
            mkdir(newFolderFull);
        end
        
        % Create the file's new name
        newFileShort = [strrep(curFileShort, strSkeletonVeh, VehName) curFileExt];
        newFileFull = [newFolderFull filesep newFileShort];
        
        % Create the new file
        disp(sprintf('[%d/%d] Copying File: %s --> %s', iFile, numFiles, curFileRel, newFileShort));
        copyfile(curFileFull, newFileFull);
        % Run txtReplace on new file
        
        if(isstruct(RevHistoryInfo))
            
            strFind_INI = ['% INI: FullName  :  Email  :  NGGN Username ' endl
                '% <initials>: <Fullname> : <email> : <NGGN username> ' endl];
            
            lstINI = {'INI', 'FullName', 'Email', 'NGGN Username'; 
                RevHistoryInfo.INI, RevHistoryInfo.FullName, ...
                RevHistoryInfo.Email, RevHistoryInfo.NGGN};   
            strReplace_INI = Cell2PaddedStr(lstINI);
                        
            lstFindReplace = {...
                strSkeletonVeh      VehName;
                '101015'            datestr(now,'YYmmdd');
                strFind_INI         strReplace_INI
                '<INI>'             RevHistoryInfo.INI};
        else
            lstFindReplace = {...
                strSkeletonVeh      VehName;
                '101015'            datestr(now,'YYmmdd') };
        end
        
        if(~isempty(lstUserFindReplace))
            lstFindReplace = [lstFindReplace; lstUserFindReplace];
        end
        
        txtReplace(newFileFull, lstFindReplace);
        lstFiles(iFile, :) = { newFileFull };
    end
    
    disp(sprintf('%s: Finished!  %d files for new %s sim successfully copied over.', ...
        mfilename, numFiles, VehName));
    
end
end % << End of function CreateNewSim >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101008 MWS: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**
% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi

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