% WRITE_RTCF_CONNECT_COMPONENTS Writes sample .ebs code for connection two RTCF components together
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Write_RTCF_Connect_Components:
%     Writes sample .ebs code for connection two RTCF components together
%
% SYNTAX:
%	[fl, info] = Write_RTCF_Connect_Components(FromModel, ToModel, FromToPortCombos, varargin, 'PropertyName', PropertyValue)
%	[fl, info] = Write_RTCF_Connect_Components(FromModel, ToModel, FromToPortCombos, varargin)
%	[fl, info] = Write_RTCF_Connect_Components(FromModel, ToModel, FromToPortCombos)
%
% INPUTS:
%	Name                Size		Units		Description
%	FromModel           'string'    [char]      "From" Simulink Model
%   ToModel             'string'    [char]      "To" Simulink Model
%   FromToPortCombos    [N x 2]     [int]       List of From/To Port
%                                               numbers that want to be 
%                                               connected
%	varargin            [N/A]		[varies]	Optional function inputs that
%                                               should be entered in pairs.
%                                               See the 'VARARGIN' section
%                                                below for more details
%
% OUTPUTS:
%	Name                Size		Units		Description
%	fl                  [1]         [flg]       File build flag
%                                               -1: File did not build
%                                                0: File built (no errors)
%   info                {struct}    [varies]    File information where...
%    .fname             'string'    [char]      Name of file created
%    .fname_full        'string'    [char]      Full filename created
%    .fstr              'string'    [char]      Contents of created file
%    .OK                'string'    [char]      Successful creation message
%    .error             'string'    [char]      Error if unsuccessful
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default         Description
%   'MarkingsFile'      'string'        'CreateNewFile_Defaults'
%                                                       MATLAB .m file
%                                                       containing requisite
%                                                       program markings
%   'SaveFolder'        'string'        pwd             Folder in which to
%                                                       create file
%   'FileFormat'        'string'        '.ebs'          File extension type
%   'Verbose'           [bool]          1 (true)        Show progress?
%   'FromPrefix'        'string'        'OUT'           RTCF prefix to
%                                                       apply to From 
%                                                       signals (output ports)
%   'ToPrefix'          'string'        'IN'            RTCF prefix to
%                                                       apply to To signals
%                                                       (input ports)
%   'OpenAfterCreated'  [bool]          1 (true)        Open file after it
%                                                       has been created?
%   'Filename'          'string'        <see note 1>    Name for file
%
%  Note 1: Default filename will be autocreated if not specified to be:
%       ['Connect_' FromModel '_to_' ToModel]
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[fl, info] = Write_RTCF_Connect_Components(FromModel, FromPortNum, ToModel, ToPortNum, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Write_RTCF_Connect_Components.m">Write_RTCF_Connect_Components.m</a>
%	  Driver script: <a href="matlab:edit Driver_Write_RTCF_Connect_Components.m">Driver_Write_RTCF_Connect_Components.m</a>
%	  Documentation: <a href="matlab:pptOpen('Write_RTCF_Connect_Components_Function_Documentation.pptx');">Write_RTCF_Connect_Components_Function_Documentation.pptx</a>
%
% See also <add relevant functions>
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/626
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [fl, info] = Write_RTCF_Connect_Components(FromModel, ToModel, FromToPortCombos, varargin)

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
fl= -1;
info= {};

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[MarkingsFile, varargin]        = format_varargin('MarkingsFile', 'CreateNewFile_Defaults',  2, varargin);
[SaveFolder, varargin]          = format_varargin('SaveFolder', pwd,  2, varargin);
[FileFormat, varargin]          = format_varargin('FileFormat', '.ebs',  2, varargin);
[flgVerbose, varargin]          = format_varargin('Verbose', 1, 0, varargin);
[FromPrefix, varargin]          = format_varargin('FromPrefix', 'OUT', 2, varargin);
[ToPrefix, varargin]            = format_varargin('ToPrefix', 'IN', 2, varargin);
[OpenAfterCreated, varargin]    = format_varargin('OpenAfterCreated', true,  2, varargin);
[filename, varargin]            = format_varargin('Filename', '',  2, varargin);

strComment = ''' ';
strExt = FileFormat;

% TerminateSim(FromModel, flgVerbose);
% eval_cmd = ['[sys, X, States, ts] = ' root_sim '([],[],[],''compile'');'];
% eval(eval_cmd);

load_system(FromModel);
load_system(ToModel);

numCombos = size(FromToPortCombos, 1);
iConn = 0; tblConn = {};

for iCombo = 1:numCombos
    FromPortNum = FromToPortCombos(iCombo, 1);
    ToPortNum   = FromToPortCombos(iCombo, 2);
    
    hOutports = find_system(FromModel, 'SearchDepth', 1, 'BlockType', 'Outport');
    nout = size(hOutports,1);
    if(FromPortNum <= nout)
        hPort           = hOutports{FromPortNum};
        strOutport      = get_param(hPort, 'Name');
        hPortParent     = get_param(hPort, 'Parent');
        strBusObjectOut = get_param(hPort, 'BusObject');
        
        if(~strcmp(strBusObjectOut, 'BusObject'))
            % Port has a bus object associated with it
            lstBO = BusObject2List(strBusObjectOut);
            lstBO(:,4) = { strOutport };
            lstBusOut = Flatten_RTCF_IO(lstBO, 'Prefix', FromPrefix);
        else
            dimPortData = get_param(hPort, 'CompiledPortWidths');
            dimPort = dimPortData.Outport;
            typePortData = get_param(hPort, 'CompiledPortDataTypes');
            typePort = typePortData.Outport{:};
            lstBusOut = Flatten_RTCF_IO({ strOutport, dimPort, typePort, '' }, 'Prefix', FromPrefix);
        end
        numOut = size(lstBusOut, 1);
        
    else
        disp('ERROR');
    end
    
    hInports = find_system(ToModel, 'SearchDepth', 1, 'BlockType', 'Inport');
    nin = size(hInports,1);
    if(ToPortNum <= nin)
        hPort           = hInports{ToPortNum};
        strInport       = get_param(hPort, 'Name');
        hPortParent     = get_param(hPort, 'Parent');
        strBusObjectIn  = get_param(hPort, 'BusObject');
        
        if(~strcmp(strBusObjectIn, 'BusObject'))
            % Port has a bus object associated with it
            lstBO = BusObject2List(strBusObjectIn);
            lstBO(:,4) = { strInport };
            lstBusIn = Flatten_RTCF_IO(lstBO, 'Prefix', ToPrefix);
        else
            dimPortData = get_param(hPort, 'CompiledPortWidths');
            dimPort = dimPortData.Inport;
            typePortData = get_param(hPort, 'CompiledPortDataTypes');
            typePort = typePortData.Inport{:};
            lstBusIn = Flatten_RTCF_IO({ strInport, dimPort, typePort, '' }, 'Prefix', ToPrefix);
        end
        numIn = size(lstBusIn, 1);
        
    else
        disp('ERROR');
    end
    
    if(strcmp(strBusObjectOut, strBusObjectIn))
        
        iConn = iConn + 1;
        tblConn(iConn, 1) = { tab };
        tblConn(iConn, 2) = { [strComment 'Output Port #' ...
            num2str(FromPortNum) ' (' strOutport ') --> Input Port #' ...
            num2str(ToPortNum) ' (' strInport ')' ] };
        
        if(numIn == numOut)
            for i = 1:numIn
                curFromConn = lstBusOut{i,6};
                curToConn   = lstBusIn{i, 6};
                
                iConn = iConn + 1;
                tblConn(iConn, 1) = { tab };
                tblConn(iConn, 2) = { ['RTCF.' FromModel '.' curFromConn '.connect'] };
                tblConn(iConn, 3) = { ['RTCF.' ToModel '.' curToConn] };
            end
            
            % Add Spacing
            iConn = iConn + 1;
            tblConn(iConn, 1) = { tab };
        else
            disp('ERROR');
            
        end
    end
    
    %% Main Function:
    %% Load in Default Markings:
    if(exist(MarkingsFile) == 2)
        eval(sprintf('CNF_info = %s(strComment, mfnam);', MarkingsFile));
    end
    
    if(isempty(filename))
        filename = ['Connect_' FromModel '_to_' ToModel];
    end
    
    %% ========================================================================
    %  Generate File 1 of 2: _wrap.h
    fstr = [strComment filename strExt endl];
    fstr = [fstr strComment 'Connect RCTF Components: ' FromModel ' to ' ToModel endl];
    
    %% Header Classified Lines
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
    
    %% Copyright
    if(isfield(CNF_info, 'Copyright'))
        if(~isempty(CNF_info.Copyright))
            fstr = [fstr strComment endl];
            
            if(strfind(CNF_info.Copyright, 'VERIFICATION DETAILS'))
                lstCopyright = str2cell(CNF_info.Copyright, char(10));
                lstCopyright = lstCopyright(5:end,:);
                CNF_info.Copyright = cell2str(lstCopyright, char(10));
            end
            
            fstr = [fstr CNF_info.Copyright];
        end
    end
    
    %% Main Chunk
    fstr = [fstr endl];
    fstr = [fstr 'public RTCF as object' endl];
    fstr = [fstr endl];
    fstr = [fstr 'Sub init( args As String )' endl];
    fstr = [fstr endl];
    
    fstr = [fstr Cell2PaddedStr(tblConn, 'Padding', ' ')];
    
    fstr = [fstr 'End Sub' endl];
    fstr = [fstr endl];
    
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
    
    % Write header
    info.fname = [filename strExt];
    info.fname_full = [SaveFolder filesep info.fname];
    info.text = fstr;
    
    if(~isdir(SaveFolder))
        mkdir(SaveFolder);
    end
    
    [fid, message ] = fopen(info.fname_full,'wt','native');
    if fid == -1
        info.error = [mfnam '>> ERROR: File Not created: ' message];
        disp(info.error)
        fl = -1;
        return
    else %any answer besides 'Y'
        fprintf(fid,'%s',fstr);
        fclose(fid);
        if(OpenAfterCreated)
            edit(info.fname_full);
        end
        fl = 0;
        info.OK = 'maybe it worked';
    end
    
    if(flgVerbose == 1)
        disp(sprintf('%s : ''%s%s'' has been created in %s', mfnam, filename, strExt, SaveFolder));
    end
    
end % << End of function Write_RTCF_Connect_Components >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110215 MWS: Created function using CreateNewFunc
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
