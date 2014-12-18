% READ_RTCF_IC_FILE Reads the .ebs or .py version of an RTCF initial conditions file
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Read_RTCF_IC_file:
%   Reads the .ebs or .py version of an RTCF initial conditions file.
%
% SYNTAX:
%	[CPValues] = Read_RTCF_IC_file(lstFiles)
%
% INPUTS:
%	Name            Size		Units		Description
%   lstFiles        {'string'}  [char]      Cell array list of RTCF test
%                                           case files to load
% OUTPUTS:
%	Name            Size		Units		Description
%   CPValues        [struct]    [N/A]       Structure of IC
%                                            variables/values
% NOTES:
%
% EXAMPLES:
%   % Example # 1: Sample RTCF IC file
%   %  Step 1: Create some ICs in the workspace for a sample sim
%   MySim_IC.Act.Elevator_deg                   = 1;
%   MySim_IC.Act.Rudder_deg                     = 0;
%   MySim_IC.InitialEOMState.GeodeticLat_deg    = 23;
%   MySim_IC.InitialEOMState.Longitude_deg      = -85;
%   MySim_IC.InitialEOMState.Alt_ft             = 10000;
%   MySim_IC.InitialEOMState.PQRb_dps           = [0 0 0];
%
%   % Step 2: Format those ICs into an RTCF IC file
%   %         Note the use of '%' to insert comments in the generated IC file
%   strSim = 'MySim';
%   strTestCase = {'Test Case 1: Straight and Level'; 'Cruising at 10,000 ft'};
%   strFilename = '01_CruiseAt10k';
%   lstICs = {...
%       '% Actuators'                               '';
%       'MySim_IC.Act.Elevator_deg'                 'MySim6DOF.IN.ICs.Elevator_deg';
%       'MySim_IC.Act.Rudder_deg'                   'MySim6DOF.IN.ICs.Rudder_deg';
%       '%'                                         '';
%       '% Equations of Motion'                     '';
%       'MySim_IC.InitialEOMState.GeodeticLat_deg'  'MySim6DOF.IN.ICs.GeodeticLat_deg';
%       'MySim_IC.InitialEOMState.Longitude_deg'    'MySim6DOF.IN.ICs.Longitude_deg';
%       'MySim_IC.InitialEOMState.Alt_ft'           'MySim6DOF.IN.ICs.Alt_ft';
%       'MySim_IC.InitialEOMState.PQRb_dps(1)'      'MySim6DOF.IN.ICs.Pb_dps';
%       'MySim_IC.InitialEOMState.PQRb_dps(2)'      'MySim6DOF.IN.ICs.Qb_dps';
%       'MySim_IC.InitialEOMState.PQRb_dps(3)'      'MySim6DOF.IN.ICs.Rb_dps';
%       '%'                                         '';
%       '% Set MySim off and running'               '';
%       '-TRUE'                                     'MySim6DOF.IN.MySim6DOF_DataInValid_flg';
%       };
%
%   lstExt = {'py';'ebs'};
%   lstFiles = Write_RTCF_IC_file(lstICs, strSim, strTestCase, ...
%       'Filename', strFilename, 'OpenAfterSave', 1, 'Extension', lstExt);
%
%   % Load in the .py file
%   MySim_IC_2 = Read_RTCF_IC_file(lstFiles{1,:});
%   dispStruct(MySim_IC_2)
%
%   % Load in the .ebs file
%   MySim_IC_3 = Read_RTCF_IC_file(lstFiles{2,:});
%   dispStruct(MySim_IC_3)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit FlattenParams.m">FlattenParams.m</a>
%	  Driver script: <a href="matlab:edit Driver_FlattenParams.m">Driver_FlattenParams.m</a>
%	  Documentation: <a href="matlab:pptOpen('FlattenParams_Function_Documentation.pptx');">FlattenParams_Function_Documentation.pptx</a>
%
% See also Write_RTCF_IC_file
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/807
%
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CodeGen/Read_RTCF_IC_file.m $
% $Rev: 2967 $
% $Date: 2013-06-20 18:28:10 -0500 (Thu, 20 Jun 2013) $
% $Author: sufanmi $

function [CPValues] = Read_RTCF_IC_file(lstFiles)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
tab2 = [tab tab];                                   % Two Tabs
tab3 = [tab tab tab];                               % Three Tabs
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
% Pick out Properties Entered via varargin
% [MarkingsType, varargin]        = format_varargin('Markings',  'Default',  2, varargin);
% [save_folder, varargin]         = format_varargin('SaveFolder', pwd,  2, varargin);
% % [filename, varargin]            = format_varargin('Filename', 'RTCF_IC',  2, varargin);
% % [lstExt, varargin]              = format_varargin('Extension', 'ebs',  2, varargin);
% [flgOpenAfterSave, varargin]    = format_varargin('OpenAfterSave', 0,  2, varargin);
% [SCMType, varargin]             = format_varargin('SCMType', 'SVN', 2, varargin);
% [strTestCaseID, varargin]       = format_varargin('TestCaseID', '', 2, varargin);

%% Main Code ==============================================================

% Ensure it is a cell array
if(ischar(lstFiles))
    lstFiles = { lstFiles };
end

% Loop through each file
numFiles = size(lstFiles,1);
for iFile = 1:numFiles
    curFile = lstFiles{iFile, 1};
    
    [curPathStr, curName, curExt] = fileparts(curFile);
    
    % Determine file type
    switch lower(curExt)
        case '.ebs'
            strComment =  '''';
            lstIgnore = {
                'public RTCF as object';
                'Sub init( args As String )';
                'End Sub'};
            
        case '.py'
            strComment = '#';
            lstIgnore = {
                'def set(winsrvr):';
                'TC_ID';
                'TC_DESCRIPTOR'};
            
    end
    iComment = 1:length(strComment);
    
    % Open the file and loop through it:
    fid = fopen(curFile);
    
    while 1
        tline = fgetl(fid);
        if ~ischar(tline)
            break
        else
            curLine = strtrim(tline);

            flgEvaluate = 1;
            if(isempty(curLine))
                flgEvaluate = 0;
            end
            
            if(flgEvaluate)
                if(strcmp(curLine(iComment), strComment))
                    flgEvaluate = 0;
                end
            end
            
            if(flgEvaluate)
                for iIgnore = 1:size(lstIgnore,1)
                    curIgnore = lstIgnore{iIgnore,:};
                    if(~isempty(strfind(curLine, curIgnore)))
                        flgEvaluate = 0;
                        break;
                    end
                end
            end
            
            if(flgEvaluate)
                % Replace any comments with a MATLAB '%' comment
                curLine = strrep(curLine, strComment, '; %');

                switch lower(curExt)
                    case '.ebs'
                        curLine = strrep(curLine, 'RTCF.', '');
                        curLine = [curLine ';'];
                        
                    case '.py'
                        curLine = strrep(curLine, 'winsrvr.setValue("', '');
                        curLine = strrep(curLine, '",', '=');
                        curLine = strrep(curLine, ')', ';');
                        curLine = strrep(curLine, 'True;', '1;');
                        curLine = strrep(curLine, 'False;', '0;');
                end
                
                ec = ['CPValues.' curLine];
                try
                    eval(ec);
                catch
                    disp('Error evaluating...')
                    disp(ec);
                end
            end
        end
    end
    fclose(fid);
    
end

%% Post Housekeeping:

end % << End of function Read_RTCF_IC_file >>

%% REVISION HISTORY
% YYMMDD INI: note
% 130620 MWS: Created function
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ng.com    : sufanmi

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
