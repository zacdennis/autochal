% WRITE_RTCF_IC_FILE Builds the .ebs or .py version of an RTCF initial conditions file
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% FlattenParams:
%   Builds the .ebs or .py version of an RTCF initial conditions file
%
%   This is a work in progress...
%
% SYNTAX:
%	[full_filename] = Write_RTCF_IC_file(lstIC, strSim, strTestCase, varargin, 'PropertyName', PropertyValue)
%	[full_filename] = Write_RTCF_IC_file(lstIC, strSim, strTestCase, varargin)
%	[full_filename] = Write_RTCF_IC_file(lstIC, strSim, strTestCase)
%
% INPUTS:
%	Name            Size		Units		Description
%	lstIC           {N x 2}                 List of Initial Conditions
%                                           to write to .ebs where
%      lstIC(:,1)   'string'    [char]      IC to write to file.  Can be a
%                                           workspace variable to evaluate
%                                           or a literal string (e.g. '1')
%      lstIC(:,2)   'string'    [char]      RTCF connection point to assign
%                                            IC to
%   strSim          'string'    [char]      Name of Simulation (for
%                                                internal documenting)
%   strTestCase     {'string'}  [char]      Description of test case
%	varargin        [N/A]       [varies]	Optional function inputs that
%                                            should be entered in pairs.
%                                            See the 'VARARGIN' section
%                                            below for more details
%
% OUTPUTS:
%	Name            Size		Units		Description
%	full_filename	'string'    [char]      Full filename of IC file
%                                            created
%
% NOTES:
%   You can insert comments into the generated using the MATLAB comment
%   (%).  The '%' will be replaced by the Comment character modifiable in
%   the varargin properties.
%
%	VARARGIN PROPERTIES:
%	PropertyName    PropertyValue	Default		Description
%   Markings        'string'        'Default'   Defines format to use for
%                                               the function's Header/Footer
%   SaveFolder      'string'        pwd         Folder in which to save IC
%                                                file
%   Filename        'string'        'RTCF_IC'   Filename to use
%   'Extension'     'string'        'ebs'       Extension type to use
%                                                'ebs' Embedded Markup Scripting
%                                                'py'  Python
%   'OpenAfterSave' [bool]          0           Open IC file after it has
%                                                been created?
%   'SCMType'       'string'        'SVN'       Source Control management
%                                                type.  Note that only SVN
%                                                and MKS are supported
%   varargin);
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
%   Write_RTCF_IC_file(lstICs, strSim, strTestCase, ...
%       'Filename', strFilename, 'OpenAfterSave', 1);
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit FlattenParams.m">FlattenParams.m</a>
%	  Driver script: <a href="matlab:edit Driver_FlattenParams.m">Driver_FlattenParams.m</a>
%	  Documentation: <a href="matlab:pptOpen('FlattenParams_Function_Documentation.pptx');">FlattenParams_Function_Documentation.pptx</a>
%
% See also CreateNewFile_Defaults, Cell2PaddedStr
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/627
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [lstFiles] = Write_RTCF_IC_file(lstIC, strSim, strTestCase, varargin)

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
[MarkingsType, varargin]        = format_varargin('Markings',  'Default',  2, varargin);
[save_folder, varargin]         = format_varargin('SaveFolder', pwd,  2, varargin);
[filename, varargin]            = format_varargin('Filename', 'RTCF_IC',  2, varargin);
[lstExt, varargin]              = format_varargin('Extension', 'ebs',  2, varargin);
[flgOpenAfterSave, varargin]    = format_varargin('OpenAfterSave', 0,  2, varargin);
[SCMType, varargin]             = format_varargin('SCMType', 'SVN', 2, varargin);
[strTestCaseID, varargin]       = format_varargin('TestCaseID', '', 2, varargin);

if(ischar(lstExt))
    lstExt = { lstExt };
end

numLoops = size(lstExt,1);

for iLoop = 1:numLoops
    strExt = lstExt{iLoop, 1};
    
    %% Main Code ==============================================================
    
    switch lower(strExt)
        case 'ebs'
            strComment =  ''' ';
        case 'py'
            strComment = '# ';
    end
    
    %% Load in Markings for New Script
    switch MarkingsType
        case 'Default'
            CNF_info = CreateNewFile_Defaults(strComment, mfnam);
        otherwise
            eval(sprintf('CNF_info = %s(strComment, mfnam);', MarkingsType));
    end
    
    %% Begin Constructing the file
    fstr = [];
    
    % Header Classified Lines
    if ~isempty(CNF_info.Classification)
        fstr = [fstr strComment ' ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    %% Header ITAR Lines
    if ~isempty(CNF_info.ITAR)
        fstr = [fstr strComment ' ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    %% Header Proprietary Lines
    if ~isempty(CNF_info.Proprietary)
        fstr = [fstr strComment ' ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    fstr = [fstr strComment filename '.' strExt endl];
    fstr = [fstr strComment endl];
    fstr = [fstr strComment 'Description:' endl];
    if(isstr(strTestCase))
        fstr = [fstr strComment tab strTestCase endl];
    else
        for i = 1:size(strTestCase, 1)
            fstr = [fstr strComment tab strTestCase{i,:} endl];
        end
    end
    
    fstr = [fstr strComment endl];
    fstr = [fstr strComment ' FORMAT:' endl];
    
    switch lower(strExt)
        case 'ebs'
            fstr = [fstr strComment tab '<RTCF Connection> = <param_value>' endl];
        case 'py'
            fstr = [fstr strComment tab 'winsrvr.setValue("<RTCF Connection>" = <param_value>)' endl];
    end
    
    fstr = [fstr strComment tab 'Only one parameter can be set per line.' endl];
    
    switch lower(strExt)
        case 'ebs'
            fstr = [fstr strComment tab 'Comments must have '' ' strtrim(strComment) ' '' as the first non-whitespace character.' endl];
            fstr = [fstr strComment tab 'Comments cannot be placed on same line as a variable declaration.' endl];
        case 'py'
            fstr = [fstr strComment tab 'Comments should have '' ' strtrim(strComment) ' '' as the first non-whitespace character.' endl];
            fstr = [fstr strComment tab 'Comments can be placed on same line as a variable declaration.' endl];
    end
    
    fstr = [fstr strComment tab 'Blank lines are ignored.' endl];
    fstr = [fstr strComment endl];
    fstr = [fstr strComment tab 'This file was auto-generated using ' mfnam '.m' endl];
    
    % Copyright
    if(isfield(CNF_info, 'Copyright'))
        if(~isempty(CNF_info.Copyright))
            fstr = [fstr strComment endl];
            fstr = [fstr CNF_info.Copyright];
        end
    end
    
    
    % % NOTE: spaces added to prevent keyword substitution on this line
    switch lower(SCMType)
        case 'svn'
            fstr = [fstr strComment endl ...
                strComment ' Subversion Revision Information At Last Commit' endl ...
                strComment ' $URL: ' '$' endl ...
                strComment ' $Rev: ' '$' endl ...
                strComment ' $Date: ' '$' endl ...
                strComment ' $Author: ' '$' endl];
            
        case 'mks'
            fstr = [fstr strComment endl ...
                strComment ' MKS Revision Information At Last Commit' endl ...
                strComment ' $Name: ' '$' endl ...
                strComment ' $Revision: ' '$' endl ...
                strComment ' $Date: ' '$' endl ...
                strComment ' $Author: ' '$' endl];
            
        otherwise
            disp(sprintf('%s : Warning : SCM type ''%s'' currently not supported.', mfnam, SCMType));
    end
    
    %% Loop Through Each Test Case:
    
    fstr = [fstr endl];
    
    switch lower(strExt)
        case 'ebs'
            
            fstr = [fstr 'public RTCF as object' endl];
            fstr = [fstr endl];
            fstr = [fstr 'Sub init( args As String )' endl];
            fstr = [fstr endl];
            
        case 'py'
            
            fstr = [fstr sprintf('TC_DESCRIPTOR = "%s"', strrep(filename, strExt, '')) endl];
            fstr = [fstr sprintf('TC_ID = "%s"', strTestCaseID) endl];
            fstr = [fstr endl];
            fstr = [fstr 'def set(winsrvr):' endl];
            fstr = [fstr endl];
    end
    
    % Determine Number of Structure Variables to Flatten:
    numIC = size(lstIC, 1);
    numComments = length(findstr(cell2str(lstIC), '%%'));
    numICReal = numIC - numComments;
    
    clear newParamList;
    iParamList = 0; lstFlattenedParams = {};
    iICReal = 0;
    
    flgVerbose = 1;
    
    for iIC = 1:size(lstIC, 1)
        curIC = lstIC{iIC, 1};
        
        switch(curIC(1))
            case '%'
                lengthParam = 0;
                flgComment = 1;
            case '-'
                lengthParam = 0;
                flgComment = 0;
            case '+'
                % Logical Expression in which output needs to be boolean
                try
                    valParam = evalin('base', curIC(2:end));
                catch
                    disp(sprintf('%s : Error evaluating %s', mfnam, curIC));
                end
                lengthParam = 0;
                flgComment = 0;
                if(valParam)
                    switch lower(strExt)
                        case 'ebs'
                            curIC = '-TRUE';
                            
                        case 'py'
                            curIC = '-True';
                    end
                else
                    switch lower(strExt)
                        case 'ebs'
                            curIC = '-FALSE';
                        case 'py'
                            curIC = '-False';
                    end
                end
            otherwise
                try
                    valParam = evalin('base', curIC);
                catch
                    disp(sprintf('%s : Error evaluating %s', mfnam, curIC));
                end
                lengthParam = length(valParam);
        end
        
        if(lengthParam == 0)
            if(flgComment)
                
                % It's a comment!
                newParamStr = curIC;
                newParamStr = strrep(newParamStr, '%', '');
                if(length(newParamStr) > 0)
                    newParamStr = [strComment newParamStr];
                end
                iParamList = iParamList + 1;
                lstFlattenedParams{iParamList,1} = tab;
                lstFlattenedParams{iParamList,2} = newParamStr;
            else
                newParamStr = lstIC{iIC, 2};
                newParamVal = curIC(2:end);
                iParamList = iParamList + 1;
                lstFlattenedParams{iParamList,1} = tab;
                
                switch lower(strExt)
                    case 'ebs'
                        lstFlattenedParams{iParamList,2} = ['RTCF.' newParamStr];
                        lstFlattenedParams{iParamList,3} = ['= ' newParamVal];
                        
                    case 'py'
                        newParamVal = strrep(newParamVal, 'TRUE', 'True');
                        newParamVal = strrep(newParamVal, 'FALSE', 'False');
                        
                        lstFlattenedParams(iParamList,2) = { sprintf('winsrvr.setValue("%s",', newParamStr) };
                        lstFlattenedParams(iParamList,3) = { sprintf('%18s)', newParamVal) };
                end
            end
        else
            
            if(size(lstIC, 2) > 1)
                curConn = lstIC{iIC, 2};
            else
                curConn = '';
            end
            
            if(~isempty(curConn))
                curIC = curConn;
            end
            
            for iParam = 1:lengthParam
                
                if(lengthParam > 1)
                    
                    strUndScr = strfind(curIC, '_');
                    if(isempty(strUndScr))
                        newParamStr = sprintf('%s%d', curIC, iParam);
                    else
                        strRoot = curIC(1:strUndScr(end)-1);
                        strUnit = curIC(strUndScr(end):end);
                        
                        newParamStr = sprintf('%s%d%s', strRoot, iParam, strUnit);
                    end
                    
                    newParamStr = MangleName(newParamStr, 0);
                    curValParam = valParam(iParam);
                else
                    newParamStr = MangleName(curIC, 0);
                    curValParam = valParam;
                end
                
                iParamList = iParamList + 1;
                lstFlattenedParams{iParamList,1} = tab;
                
                switch lower(strExt)
                    case 'ebs'
                        lstFlattenedParams(iParamList,2) = { ['RTCF.' newParamStr] };
                        lstFlattenedParams(iParamList,3) = { sprintf('= %18.8f', curValParam) };
                        
                    case 'py'
                        lstFlattenedParams(iParamList,2) = { sprintf('winsrvr.setValue("%s",', newParamStr) };
                        lstFlattenedParams(iParamList,3) = { sprintf('%18.8f)', curValParam) };
                end
                
            end
        end
    end
    
    iParamList = iParamList + 2;
    lstFlattenedParams{iParamList,1} = tab;
    lstFlattenedParams(iParamList,2) = { [strComment ' ***** End Test Case *****'] };
    
    fstr = [fstr Cell2PaddedStr(lstFlattenedParams, 'Padding', ' ')];
    fstr = [fstr endl];
    
    switch lower(strExt)
        case 'ebs'
            fstr = [fstr 'End Sub' endl];
            
        case 'py'
            
    end
    
    % Itar Paragraph
    if ~isempty(CNF_info.ITAR_Paragraph)
        fstr = [fstr endl];
        fstr = [fstr CNF_info.ITAR_Paragraph];
        if(~strcmp(CNF_info.ITAR_Paragraph(end), endl))
            fstr = [fstr endl];
        end
        fstr = [fstr strComment endl];
    end
    
    % Footer Proprietary Lines
    if ~isempty(CNF_info.Proprietary)
        fstr = [fstr strComment ' ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    % Footer ITAR Lines
    if ~isempty(CNF_info.ITAR)
        fstr = [fstr strComment ' ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    % Footer Classified Lines
    if ~isempty(CNF_info.Classification)
        fstr = [fstr strComment ' ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    if(~isdir(save_folder))
        mkdir(save_folder);
    end
    
    % Write header
    info.fname = [filename '.' strExt];
    info.fname = strrep(info.fname, '..', '.');
    info.fname_full = [save_folder filesep info.fname];
    info.text = fstr;
    
    [fid, message ] = fopen(info.fname_full,'wt','native');
    if fid == -1
        info.error = [mfnam '>> ERROR: File Not created: ' message];
        disp(info.error)
        fl = -1;
        return
    else %any answer besides 'Y'
        fprintf(fid,'%s',fstr);
        fclose(fid);
        if(flgOpenAfterSave)
            edit(info.fname_full);
        end
        fl = 0;
        info.OK = 'maybe it worked';
    end
    
    lstFiles(iLoop,:) = {info.fname_full};
    
    disp(sprintf('%s : ''%s'' has been created in %s', mfnam, info.fname, save_folder));
end

%% Post Housekeeping:

end % << End of function FlattenParams >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110124 MWS: Created function
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
