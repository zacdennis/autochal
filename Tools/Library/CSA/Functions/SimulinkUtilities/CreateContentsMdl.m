% CREATECONTENTSMDL Creates a Contents Report for *.mdl files
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateContentsMdl:
%     Creates a Contents Report for *.mdl files similar to a *.m contents
%     file.  Separates between libraries and non-libraries.  Uses the
%     "description" tag on the model as the info.  The output file is put
%     into the called directory
%
% Inputs - directory: name of directory to study
%        - sortopt: <UNIMPLEMENTED>
%
% Output - outtxt if exists, the entire file is written to a string
% variable
%
% SYNTAX:
%	[outtext] = CreateContentsMdl(directory, varargin, 'PropertyName', PropertyValue)
%	[outtext] = CreateContentsMdl(directory, varargin)
%	[outtext] = CreateContentsMdl(directory)
%
% INPUTS: 
%	Name     	Size		Units		Description
%	directory	<size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	outtext	  <size>		<units>		<Description> 
%
% NOTES:
%	This will overwrite any existing file named ContentsMDL in directory.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%   [outtxt] = CreateContentsMdl(pwd);
%
%	% <Enter Description of Example #1>
%	[outtext] = CreateContentsMdl(directory, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[outtext] = CreateContentsMdl(directory)
%	% <Copy expected outputs from Command Window>
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
%	Source function: <a href="matlab:edit CreateContentsMdl.m">CreateContentsMdl.m</a>
%	  Driver script: <a href="matlab:edit Driver_CreateContentsMdl.m">Driver_CreateContentsMdl.m</a>
%	  Documentation: <a href="matlab:pptOpen('CreateContentsMdl_Function_Documentation.pptx');">CreateContentsMdl_Function_Documentation.pptx</a>
%
% See also Contents
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/68
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CreateContentsMdl.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [outtext] = CreateContentsMdl(directory, varargin)

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
% outtext= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        directory= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:
% I will add the '%' after completed...
    outtext = ' CONTENTSMDL List of MDL files and brief summary' ; % add L1
    outtext = [outtext endl ]; %add space
    libtext = ' Libraries:'; %library header
    mdltext = ' Models   :'; %model list header
    % get mdl file list
    startdir = pwd;
    filelist = dir([directory '\*.mdl']); %get all mdl files
    cd(directory);

    % Loop through files
    for i=1:length(filelist)
        [path,name,ext,versn] = fileparts(filelist(i).name); %#ok<NASGU>
        try %works if model is already open
            LibType = get_param(name,'LibraryType');
            desc = get_param(name,'Description');
        catch %opens model, gets data, closes model
            open_system(name);
            LibType = get_param(name, 'LibraryType');
            desc = get_param(name,'Description');
            close_system(name);
        end

        %format the desc

        if length(desc)+length(name) > 68 || ~isempty(strfind(desc,endl))
            desc = [endl desc]; %#ok<AGROW> %move to a lower line
        end
        desc = strrep(desc, endl, [endl tab tab]); %matches
        switch LibType
            case 'BlockLibrary'
                libtext = [libtext endl tab name ' - ' desc]; %#ok<AGROW>
            case 'None'
                mdltext = [mdltext endl tab name ' - ' desc]; %#ok<AGROW>
            otherwise
                error('Can''t determine Library type')
        end
    end

%% Compile Outputs:
%% Outputs
   %assemble bits
    outtext = [outtext endl libtext endl endl mdltext endl];
    outtext = ['%' strrep(outtext, endl, [endl '%'])]; % add a '%' to each line
    
    
%% Write to file
    fid = fopen('ContentsMdl.m', 'wt');
    if fid <= 0
        disp([mfnam '>>ERROR: file cannot be opened']);
        return
    end
    fprintf(fid,'%s',outtext);
    fclose(fid);
    open('ContentsMdl.m');
    
%% Return
    cd(startdir);

end % << End of function CreateContentsMdl >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101101 JPG: Copied over information from the old function.
% 101101 CNF: Function template created using CreateNewFunc
% 080827 TKV: Basic features Created
% 080827 CNF: File Created by CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% TKV: Travis Vetter        :  travis.vetter@ngc.com:  vettetr

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
