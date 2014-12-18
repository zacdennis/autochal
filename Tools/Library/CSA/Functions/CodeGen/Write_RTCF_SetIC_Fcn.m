% WRITE_RTCF_SETIC_FCN Constructs the Python version of the RTCF SetIC Function
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Write_RTCF_SetIC_Fcn:
%   Constructs the RTCF SetIC function call used to set the initial
%   conditions of an RTCF component.  Currently only the 'Python' scripting
%   language is supported.
% 
% SYNTAX:
%	[strFilename] = Write_RTCF_SetIC_Fcn(lstIC, varargin, 'PropertyName', PropertyValue)
%	[strFilename] = Write_RTCF_SetIC_Fcn(lstIC, varargin)
%	[strFilename] = Write_RTCF_SetIC_Fcn(lstIC)
%
% INPUTS: 
%	Name       	Size		Units		Description
%	lstIC	    {Nx2}                   Cell array with RTCF Mapping
%    (:,1)      'string'    [char]      Workspace variable name
%    (:,2)      'string'    [char]      Simulink signal name
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name       	Size		Units		Description
%	strFilename	'string'    [char]      Name of file created
%
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'Markings'          'string'        'Default'   Name of file containing
%                                                    default markings
%   'SaveFolder'        'string'        pwd         Folder in which to save
%                                                    created file
%   'Language'          'string'        'Python'    Desired output script
%                                                    format
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[strFilename] = Write_RTCF_SetIC_Fcn(lstIC, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Write_RTCF_SetIC_Fcn.m">Write_RTCF_SetIC_Fcn.m</a>
%	  Driver script: <a href="matlab:edit Driver_Write_RTCF_SetIC_Fcn.m">Driver_Write_RTCF_SetIC_Fcn.m</a>
%	  Documentation: <a href="matlab:pptOpen('Write_RTCF_SetIC_Fcn_Function_Documentation.pptx');">Write_RTCF_SetIC_Fcn_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/631
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [strFilename] = Write_RTCF_SetIC_Fcn(lstIC, varargin)

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

[strMarkingsFile, varargin] = format_varargin('Markings',  'CreateNewFile_Defaults',  2, varargin);
[save_folder, varargin]     = format_varargin('SaveFolder', pwd,  2, varargin);
[Language, varargin]        = format_varargin('LanguageType', 'Python',  2, varargin);
[FcnName, varargin]        = format_varargin('FcnName', 'setICs',  2, varargin);

%% Main Code ==============================================================

switch(lower(Language))
    case 'python'
        strExt = '.py';
    otherwise
end

% Determine Number of Structure Variables to Flatten:
numIC = size(lstIC, 1);
numComments = length(findstr(cell2str(lstIC), '%%'));
numICReal = numIC - numComments;

clear newParamList;
iParamList = 0;
iICReal = 0;

flgVerbose = 1;

for iIC = 1:size(lstIC)
    cur_WS_name = lstIC{iIC, 1};
    cur_BO_name = lstIC{iIC, 2};
    
    if(strcmp(cur_WS_name(1), '%'))
        % It's a comment, ignore it.
        lengthParam = 0;
    else
        % It's a workspace variable.  Get the length of it.
        valParam = evalin('base', cur_WS_name);
        lengthParam = length(valParam);
    end
    
    if(lengthParam > 0)
        for iParam = 1:lengthParam
            
            if(isempty(cur_BO_name))
                cur_BO_name = cur_WS_name;
            end
            
            if(lengthParam > 1)
                % It's a vector
                cur_WS_IC_str = sprintf('%s%d', cur_WS_name, iParam);
                cur_WS_IC_str = MangleName(cur_WS_IC_str);
                cur_WS_IC_val = valParam(iParam);
                
                cur_BO_IC_str = sprintf('%s%d', cur_BO_name, iParam);
                cur_BO_IC_str = MangleName(cur_BO_IC_str);
                
            else
                % It's a scalar
                cur_WS_IC_str = MangleName(cur_WS_name);
                cur_WS_IC_val = valParam;
                cur_BO_IC_str = MangleName(cur_BO_name);
                
            end
            
            iParamList = iParamList + 1;
            lst_RTCF_map(iParamList,1) = { [tab tab] };
            lst_RTCF_map(iParamList,2) = { ['''' cur_WS_IC_str ''''] };
            lst_RTCF_map(iParamList,3) = { ': vmc_name + component_name +'};
            lst_RTCF_map(iParamList,4) = { ['"' cur_BO_IC_str '",'] };
        end
    end
end

%% Load in Markings for New Script
eval(sprintf('CNF_info = %s(''# '', mfnam);', strMarkingsFile));

%% Begin Constructing the file
fstr = [];

% Header Classified Lines
if ~isempty(CNF_info.Classification)
    fstr = [fstr '# ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Header ITAR Lines
if ~isempty(CNF_info.ITAR)
    fstr = [fstr '# ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

%% Header Proprietary Lines
if ~isempty(CNF_info.Proprietary)
    fstr = [fstr '# ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

% % NOTE: spaces added to prevent keyword substitution on this line
% fstr = [fstr '% Subversion Revision Information At Last Commit' endl ...
%     '% $URL: ' '$' endl ...
%     '% $Rev: ' '$' endl ...
%     '% $Date: ' '$' endl ...
%     '% $Author: ' '$' endl ...
%     endl]; %Blank Line


% Function Declaration

fstr = [fstr '#' tab 'Sets intial conditions for RTCF component.' endl];
fstr = [fstr '#' endl];
fstr = [fstr '# SYNTAX:' endl];
fstr = [fstr '#' tab FcnName '(self, vmc_name, component_name)' endl];
fstr = [fstr '#' endl];
fstr = [fstr '# INPUTS:' endl];
fstr = [fstr '#' tab 'Name' tab tab tab 'Description' endl];
fstr = [fstr '#' tab 'self' tab tab tab '<TBD>' endl];
fstr = [fstr '#' tab 'vmc_name' tab tab '''string''' endl];
fstr = [fstr '#' tab 'component_name' tab '''string''' endl];
fstr = [fstr '#' endl];
fstr = [fstr '#' tab 'This file was auto-generated using ' mfnam '.m' endl];

% Copyright
if(isfield(CNF_info, 'Copyright'))
    if(~isempty(CNF_info.Copyright))
        fstr = [fstr '#' endl];
        fstr = [fstr CNF_info.Copyright];
    end
end

fstr = [fstr endl];
fstr = [fstr 'def ' FcnName '(self, vmc_name, component_name)' endl];    

fstr = [fstr tab '# Create IC/signal dictionary' endl];
fstr = [fstr tab 'ic = {' endl];
fstr = [fstr Cell2PaddedStr(lst_RTCF_map, 'Padding', ' ')];
fstr = [fstr tab tab '}' endl];


fstr = [fstr endl];
fstr = [fstr tab '# Read IC file' endl];
fstr = [fstr tab 'f = open(os.path.abspath(self.ICfile), ''r'')' endl];
fstr = [fstr tab 'for line in f:' endl];
fstr = [fstr tab tab '# Parse line' endl];
fstr = [fstr tab tab 'lineparts = line.split('' '')' endl];
fstr = [fstr tab tab 'try:' endl];
fstr = [fstr tab tab tab '#print ic[lineparts[0]], lineparts[2]' endl];
fstr = [fstr tab tab tab '#cls_vmc(ic[lineparts[0]]).value = float(lineparts[2])' endl];
fstr = [fstr tab tab tab '#self.cls(vmc_name+"."+ic[lineparts[0]]).value = float(lineparts[2])' endl];
fstr = [fstr tab tab tab 'self.cls(ic[lineparts[0]]).value = float(lineparts[2])' endl];
fstr = [fstr tab tab tab '#self.setValue(ic[lineparts[0]], float(lineparts[2]))' endl];
fstr = [fstr tab tab 'except (KeyError, ValueError):' endl];
fstr = [fstr tab tab tab '#print lineparts[0] + " was not found in dictionary"' endl];
fstr = [fstr tab tab tab 'pass' endl];
fstr = [fstr tab tab '#else:' endl];
fstr = [fstr tab tab tab '#print ''set '' + ic[lineparts[0]] + '' to '' + lineparts[2].strip()' endl];
fstr = [fstr '' endl];
fstr = [fstr tab 'f.close()' endl];

% Itar Paragraph
if ~isempty(CNF_info.ITAR_Paragraph)
    fstr = [fstr endl];
    fstr = [fstr CNF_info.ITAR_Paragraph];
    if(~strcmp(CNF_info.ITAR_Paragraph(end), endl))
        fstr = [fstr endl];
    end
    fstr = [fstr '#' endl];
end

% Footer Proprietary Lines
if ~isempty(CNF_info.Proprietary)
    fstr = [fstr '# ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

% Footer ITAR Lines
if ~isempty(CNF_info.ITAR)
    fstr = [fstr '# ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

% Footer Classified Lines
if ~isempty(CNF_info.Classification)
    fstr = [fstr '# ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

% Write header
strFilename = [save_folder filesep FcnName strExt];
 [fid, message ] = fopen(strFilename,'wt','native');
 if fid == -1
     info.text = fstr;
     info.error = [mfnam '>> ERROR: File Not created: ' message];
     disp(info.error)
     fl = -1;
     return
 else %any answer besides 'Y'
     fprintf(fid,'%s',fstr);
     fclose(fid);
     cmdstr = ['edit ' strFilename]; evalin('base',cmdstr);
     fl = 0;
     info.text = fstr;
     info.OK = 'maybe it worked';
 end

disp(sprintf('%s : ''%s%s'' has been created in %s', mfnam, FcnName, strExt, save_folder));


end % << End of function Write_RTCF_SetIC_Fcn >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 110121 <INI>: Created function using CreateNewFunc
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
