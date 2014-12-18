% FLATTEN_RTCF_IO Flattens and name mangles list of Simulink inputs/outputs into RTCF format
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Flatten_RTCF_IO:
%   Takes in a list containing the inputs or outputs of a code generated
%   Simulink block and returns the signal/variable names to be used when
%   building the RTCF connection scripts.
% 
% SYNTAX:
%	[lstFlattenedIO] = Flatten_RTCF_IO(lstIO, varargin, 'PropertyName', PropertyValue)
%	[lstFlattenedIO] = Flatten_RTCF_IO(lstIO, varargin)
%	[lstFlattenedIO] = Flatten_RTCF_IO(lstIO)
%
% INPUTS: 
%	Name          	Size		Units		Description
%	lstIO	        {Nx4}                   Cell array of Simulink data
%       (:, 1)      'string'    [char]      Signal Name
%       (:, 2)      [1]         [int]       Signal Dimension
%       (:, 3)      'string'    [char]      Signal Type (e.g. 'double')
%       (:, 4)      'string'    [char]      Reference bus
%                                            Optional: Default is ''
%	varargin	[N/A]		[varies]        Optional function inputs that
%                                            should be entered in pairs.
%                                            See the 'VARARGIN' section
%                                            below for more details
% OUTPUTS: 
%	Name          	Size		Units		Description
%	lstFlattenedIO	{Nx6}                   Cell array of RTCF data
%       (:, 1)      'string'    [char]      RTCF Connection name needed in
%                                            the wrapper .h/.cpp
%       (:, 2)      'string'    [char]      RTCF variable type (e.g.
%                                               'CCLSDouble')
%       (:, 3)      [1]         [int]       Signal dimensions
%       (:, 4)      'string'    [char]      Autocode name needed in the
%                                               wrapper .ccp to connect 
%                                               RTCF with the generated code
%       (:, 5)      'string'    [char]      Name of the reference bus (if
%                                            applicable)
%       (:, 6)      'string'    [char]      RTCF Connection name (only used
%                                            by .cpp file)
% NOTES:
%
% EXAMPLES:
%	% Flatten a sample single for RTCF:
%   lstIO = {'P_ned_ft', 3, 'double'}
%
%	[lstFlattenedIO] = Flatten_RTCF_IO(lstIO, varargin)
% 
% % lstFlattenedIO = [ ...
% %     'Pn_ft'    'CCLSDouble'    [1]    'P_ned_ft[0]'    ''    'Pn_ft'
% %     'Pe_ft'    'CCLSDouble'    [1]    'P_ned_ft[1]'    ''    'Pe_ft'
% %     'Pd_ft'    'CCLSDouble'    [1]    'P_ned_ft[2]'    ''    'Pd_ft' ]
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Flatten_RTCF_IO.m">Flatten_RTCF_IO.m</a>
%	  Driver script: <a href="matlab:edit Driver_Flatten_RTCF_IO.m">Driver_Flatten_RTCF_IO.m</a>
%	  Documentation: <a href="matlab:pptOpen('Flatten_RTCF_IO_Function_Documentation.pptx');">Flatten_RTCF_IO_Function_Documentation.pptx</a>
%
% See also format_varargin 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/621
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $8

function [lstFlattenedIO] = Flatten_RTCF_IO(lstIO, varargin)

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
% Pick out Properties Entered via varargin
[Prefix, varargin]          = format_varargin('Prefix', '',  2, varargin);
[lstFindReplace, varargin]  = format_varargin('ListFindReplace', {},  2, varargin);

%% Initialize Outputs:
iFlat = 0; lstFlattenedIO= {};

%% Main Function:
for i = 1:size(lstIO, 1)
    curMem      = lstIO{i, 1};
    curDim      = lstIO{i, 2};
    curType     = lstIO{i, 3};
    
    if(size(lstIO, 2) > 3)
        curBus      = lstIO{i, 4};
    else
        curBus = '';
    end
    curSubBus = curBus;
    if(~isempty(curBus))
        curBus = [curBus '.'];
    end
    
    switch curType
        case 'double'
            strVarType = 'CCLSDouble';
        case 'single'
            strVarType = 'CCLSFloat';
        case {'uint8'; 'int8'}
            strVarType = 'CCLSByte';
        case {'uint16'; 'int16'}
            strVarType = 'CCLSShort';
        case {'uint32'; 'int32'}
            strVarType = 'CCLSLong';
        case {'uint64'; 'int64'}
            strVarType = 'CCLSLong';
            disp([mfnam '>> WARNING: 64-bit integers are NOT supported by RTCF.  Converting to 32-bit for safety.']);
            disp([mfspc '    Signal: ' curBus curMem']);
        case {'bool'; 'boolean'}
            strVarType = 'CCLSBool';
        otherwise
            errstr = [mfnam '>> ERROR: Undefined RTCF Variable Type for MATLAB variable type ''' curType ''''];
            error([mfnam 'class:file:Identifier'], errstr);    % Call error function with error string
    end
    
    for iDim = 1:curDim
        iFlat = iFlat + 1;
        strRTCF = curMem;
        strWRAP = [curBus curMem];
        
        if(curDim > 1)
            flgFind = 0;
            strWRAP = sprintf('%s%s[%d]', curBus, curMem, iDim-1);
                        
            if(flgFind == 0)
                ptrSpacer = strfind(curMem, '_');
                
                if(isempty(ptrSpacer))
                    strRTCF = [curMem num2str(iDim)];
                    
                else             
                    strMemRoot = curMem(1:ptrSpacer(end)-1);
                    strMemUnits = curMem(ptrSpacer(end)+1:end);
                    strRTCF = sprintf('%s%d_%s', strMemRoot, iDim, strMemUnits);
                end
            end
        end
        
        strRTCF = MangleName(strRTCF, true, lstFindReplace);
        
        lstFlattenedIO(iFlat, 1) = { strRTCF };     % RTCF Connection name (needed in wrapper .h/.cpp)
        lstFlattenedIO(iFlat, 2) = { strVarType };  % Variable Type
        lstFlattenedIO(iFlat, 3) = { [1] };         % Dimensions
        lstFlattenedIO(iFlat, 4) = { strWRAP };     % Autocode Name (needed in wrapper .cpp)
        lstFlattenedIO(iFlat, 5) = { curSubBus };
        
        strRTCF_Conn = strRTCF;
        if(~isempty(curSubBus))
            strRTCF_Conn = [curSubBus '.' strRTCF_Conn];
        end
        
        if(~isempty(Prefix))
            strRTCF_Conn = [Prefix '.' strRTCF_Conn];
        end
                
        lstFlattenedIO(iFlat, 6) = { strRTCF_Conn };  % Full RTCF Connection name (needed in wrapper .cpp)
        
    end

end % << End of function Flatten_RTCF_IO >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 110118 <INI>: Created function using CreateNewFunc
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
