% WRITE_RTCF_BUSOBJECT_HEADER Writes RTCF header file for Simulink Bus Object
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Write_RTCF_BusObject_header:
%   This function constructs the requisite RTCF header file for a Simulink
%   bus object.
% 
% SYNTAX:
%	strFilename = Write_RTCF_BusObject_header(strBusObject, varargin, 'PropertyName', PropertyValue)
%	strFilename = Write_RTCF_BusObject_header(strBusObject, varargin)
%	strFilename = Write_RTCF_BusObject_header(strBusObject)
%
% INPUTS: 
%	Name        	Size		Units		Description
%	strBusObject	'string'    [char]      Name of Bus Object in base
%                                           workspace
%   strModel        'string'    [char]      Name of Simulink block or model
%                                           being coded
%	varargin        [N/A]		[varies]	Optional function inputs that
%                                           should be entered in pairs.
%                                           See the 'VARARGIN' section
%                                           below for more details
%
% OUTPUTS: 
%	Name        	Size		Units		Description
%	strFilename     'string'    [char]      Name of Generated File
%
% NOTES:
%	This function is supported by multiple CSA_Library functions:
%	BusObject2List, CenterChars, Cell2PaddedStr, & format_varargin.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default     Description
%   'MarkingsFile'      'string'        'CreateNewFile_Defaults'
%                                                   MATLAB .m file
%                                                   containing requisite
%                                                   program markings
%   'SaveFolder'        'string'        pwd         Folder in which to save
%                                                   created file
%   'BusName'           'string'     strBusObject   Name to use in header
%                                                   file for C/C++
%                                                   structure created from
%                                                   inputted bus object
%   'OpenAfterCreated'  [bool]          true        Open the generated
%                                                   files in MATLAB's
%                                                   editor after creation?
% EXAMPLES:
%	% Generate the header file for a sample mass properties bus
%   % Step 1: Create the bus object
%   strBO = 'BO_MPStates';
%   lstBO = {
%       'Weight_lb'     1;
%       'CG_ft'         3;
%       'Ixx_slugft2'   1;
%       'Iyy_slugft2'   1;
%       'Izz_slugft2'   1;
%       'Ixy_slugft2'   1;
%       'Iyz_slugft2'   1;
%       'Ixz_slugft2'   1;
%     };
%   strModel = 'SampleSim_MPMgr';
%   BuildBusObject(strBO, lstBO);
%   % Step 2: Write the header file using 'MPStates' for the 'BusName'
%	Write_RTCF_BusObject_header(strBO, strModel, 'BusName', 'MPStates')
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Write_RTCF_BusObject_header.m">Write_RTCF_BusObject_header.m</a>
%	  Driver script: <a href="matlab:edit Driver_Write_RTCF_BusObject_header.m">Driver_Write_RTCF_BusObject_header.m</a>
%	  Documentation: <a href="matlab:pptOpen('Write_RTCF_BusObject_header_Function_Documentation.pptx');">Write_RTCF_BusObject_header_Function_Documentation.pptx</a>
%
% See also format_varargin, BusObject2List, CenterChars, Cell2PaddedStr
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/625
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function strFilename = Write_RTCF_BusObject_header(strBusObject, strModel, varargin)

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
%	No Outputs Specified
strFilename = '';

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);
[MarkingsFile, varargin]    = format_varargin('MarkingsFile', 'CreateNewFile_Defaults',  2, varargin);
[SaveFolder, varargin]      = format_varargin('SaveFolder', pwd,  2, varargin);
[strBusName, varargin]      = format_varargin('BusName', strBusObject,  2, varargin);
[OpenAfterCreated, varargin]= format_varargin('OpenAfterCreated', true,  2, varargin);

%% Main Function:

%% Build List of Bus Object members:
lstBO = BusObject2List(strBusObject);

% Compile list of vectorized bus object members:
iBOVec = 0; lstBOVec = {}; strBOVec = '';
strPut = '';
strGet = '';
strProtected = '';
lstPut = {}; lstGet = {}; lstProtected = {};

for iBO = 1:size(lstBO, 1)
    curBO_name  = lstBO{iBO, 1};
    curBO_dim   = lstBO{iBO, 2};
    curBO_type  = lstBO{iBO, 3};

    % Build lstConn: Cell array of the RTCF 'add_conn' commands:
    lstConn(iBO, 1) = {tab};
    lstConn(iBO, 2) = {tab};
    lstConn(iBO, 3) = {['add_conn( m_' curBO_name]};
    if(curBO_dim > 1)
        lstConn(iBO, 4) = {['.SetBuffer(  pBus.' curBO_name ' ),' ]};
    else
        lstConn(iBO, 4) = {['.SetBuffer( &pBus.' curBO_name ' ),' ]};
    end
    lstConn(iBO, 5) = {[' "' curBO_name '" );']};
    
    % Build lstPut: Cell array of the RTCF '.Put' commands:
    lstPut(iBO, 1) = {tab};
    lstPut(iBO, 2) = {tab};
    lstPut(iBO, 3) = {[' m_' curBO_name]};
    lstPut(iBO, 4) = {'.Put( );'};
    
    % Build lstGet: Cell array of the RTCF '.Get' commands:
    lstGet(iBO, 1) = {tab};
    lstGet(iBO, 2) = {tab};
    lstGet(iBO, 3) = {['m_' curBO_name]};
    if(curBO_dim > 1)
        lstGet(iBO, 4) = {['.Get( pBus.' curBO_name ', ' num2str(curBO_dim) ');']};
    else
        lstGet(iBO, 4) = {'.Get( );'};
    end
    
    % Build lstProcted: Cell array of the TRCF 'protected' commands:
    % TODO: Make this work for booleans / singles / etc. <-- 11/24/2010 -
    % sufanmi
    if(curBO_dim > 1)
        strProtected = 'CCLSDoubleVector';
    else
        strProtected = 'CCLSDouble';
    end
    lstProtected(iBO, 1) = {strProtected};
    lstProtected(iBO, 2) = {['m_' curBO_name ';']};
    
    if(curBO_dim > 1)
        iBOVec = iBOVec + 1;    
        lstBOVec{iBOVec, 1} = curBO_name;
        lstBOVec{iBOVec, 2} = curBO_dim;
        curBOVec = sprintf('m_%s(%d)', curBO_name, curBO_dim);
        if(iBOVec == 1)
            strBOVec = curBOVec;
        else
            strBOVec = [strBOVec ', ' curBOVec];
        end
    end
end

%% Load in Default Markings:
if(exist(MarkingsFile) == 2)
    eval_str = ['CNF_info = ' MarkingsFile '(''// '', mfnam);'];
    eval(eval_str);
end

%% Start Building File:

%% Main Information
fstr = ['// Bus Object header file for: ' strBusObject endl];

%% Header Classified Lines
if ~isempty(CNF_info.Classification)
    fstr = [fstr '// ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Header ITAR Lines
if ~isempty(CNF_info.ITAR)
    fstr = [fstr '// ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Header Proprietary Lines
if ~isempty(CNF_info.Proprietary)
    fstr = [fstr '// ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

% Copyright
if(isfield(CNF_info, 'Copyright'))
    if(~isempty(CNF_info.Copyright))
        fstr = [fstr '//' endl];
        fstr = [fstr CNF_info.Copyright];
    end
end

fstr = [fstr '//' endl];
fstr = [fstr '// This header file was auto-generated from its reference Simulink model' endl];
fstr = [fstr '// using ''' mfnam '.m''' endl];

%% ifndef / define
fstr = [fstr endl];
fstr = [fstr '#ifndef _C' upper(strBusObject) '_H_' endl];
fstr = [fstr '#define _C' upper(strBusObject) '_H_' endl];
fstr = [fstr endl];

%% includes?
fstr = [fstr '#include "' strModel '_types.h"' endl];
fstr = [fstr endl];

%% class define
fstr = [fstr 'class C' strBusName ' : public CCLSStruct' endl];
fstr = [fstr '{' endl];

%% public section:
fstr = [fstr 'public:' endl];
fstr = [fstr tab 'C' strBusName '( ' strBusObject '& pBus )'];

if(isempty(lstBOVec))
    fstr = [fstr endl];
else
    % Add the Vectorized Members
    fstr = [fstr ' : ' strBOVec endl];
end
fstr = [fstr tab '{' endl];
fstr = [fstr Cell2PaddedStr(lstConn)];
fstr = [fstr tab '}' endl];

%% Put Section:
fstr = [fstr endl];
fstr = [fstr 'void Put( ' strBusObject '& pBus )' endl];
fstr = [fstr tab '{' endl];
fstr = [fstr Cell2PaddedStr(lstPut)];
fstr = [fstr tab '}' endl];

%% Get Section:
fstr = [fstr endl];
fstr = [fstr 'void Get( ' strBusObject '& pBus )' endl];
fstr = [fstr tab '{' endl];
fstr = [fstr Cell2PaddedStr(lstGet)];
fstr = [fstr tab '}' endl];

%% Protected Section:
fstr = [fstr endl];
fstr = [fstr 'protected:' endl];
fstr = [fstr Cell2PaddedStr(lstProtected, 'Padding', ' ')];

fstr = [fstr '};' endl];
fstr = [fstr endl];
fstr = [fstr '#endif' endl];
fstr = [fstr endl];

%% Footer
    % Order is reversed from header
    % DistributionStatement,ITARparagraph Proprietary ITAR, Classification
    
    % Distribution Statement
    if ~isempty(CNF_info.DistibStatement)
        fstr = [fstr CNF_info.DistibStatement endl];
        fstr = [fstr endl];
    end
    
    % Itar Paragraph
    if ~isempty(CNF_info.ITAR_Paragraph)
        fstr = [fstr CNF_info.ITAR_Paragraph];
    end
    fstr = [fstr '//' endl];
    
    % Footer Proprietary Lines
    if ~isempty(CNF_info.Proprietary)
        fstr = [fstr '// ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    % Footer ITAR Lines
    if ~isempty(CNF_info.ITAR)
        fstr = [fstr '// ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end
    
    % Footer Classified Lines
    if ~isempty(CNF_info.Classification)
        fstr = [fstr '// ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
    end

%% Write the file
strFilename = [SaveFolder filesep strBusName '.h'];
[fid, message ] = fopen(strFilename, 'wt','native');
    
if fid == -1
    info.text = fstr;
    info.error = [mfnam '>> ERROR: File Not created: ' message];
    disp(info.error)
    return
else %any answer besides 'Y'
    fprintf(fid,'%s',fstr);
    fclose(fid);
    if(OpenAfterCreated)
        edit(strFilename);
    end
    info.text = fstr;
    info.OK = 'maybe it worked';
end

%	No Outputs Specified

end % << End of function Write_RTCF_BusObject_header >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 101124 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName            : Email     : NGGN Username 
% <initials>: <Fullname>   : <email>   : <NGGN username> 

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
