% CHANGEMRMODE Change model reference mode
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ChangeMRMode:
%     Change model reference mode
%
% *************************************************************************
% * #NOTE: To future COSMO'er, the following warning occured when running
% * CreateNewFunc.
% * CreateNewFunc>>WARNING: Selected Input argument name: "Mode" is a
% * function name!
% * -JPG
% *************************************************************************
% SYNTAX:
%	[] = ChangeMRMode(model_name, Mode, varargin, 'PropertyName', PropertyValue)
%	[] = ChangeMRMode(model_name, Mode, varargin)
%	[] = ChangeMRMode(model_name, Mode)
%
% INPUTS: 
%	Name      	Size		Units		Description
%   model_name  [1xN]       [ND]        String of Model Name
%   Mode        [1xN]       [ND]        Model Reference Mode:
%                                        1: Normal
%                                        2:Accelerated
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	    	          <size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[] = ChangeMRMode(model_name, Mode, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[] = ChangeMRMode(model_name, Mode)
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
%	Source function: <a href="matlab:edit ChangeMRMode.m">ChangeMRMode.m</a>
%	  Driver script: <a href="matlab:edit Driver_ChangeMRMode.m">Driver_ChangeMRMode.m</a>
%	  Documentation: <a href="matlab:pptOpen('ChangeMRMode_Function_Documentation.pptx');">ChangeMRMode_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/531
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/ChangeMRMode.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [] = ChangeMRMode(model_name, Mode, varargin)

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


%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        Mode= ''; model_name= ''; 
%       case 1
%        Mode= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(Mode))
%		Mode = -1;
%  end
%% Main Function:
if nargin < 2
    disp('Mode to change into was not specified;')
    disp('Choose the Simulation Mode for ModelReferences:')
    disp('     1 : Normal     - No building of ModelReferences')
    disp('     2 : Acclerated - ModelReferences Build')
    choice = input('Type the number corresponding to your Mode choice [1]:');
    
    if isempty(choice)
        choice = 1;
    end
    
    Mode = choice;
    
    if Mode > 2 || Mode < 0
        disp('Incorrect Option - No Action Taken!')
        return;
    end
    
end

% Get the list of referenced models
mr_array = find_system(model_name, 'FollowLinks', 'on', 'BlockType', 'ModelReference');

% Loop through each model reference
for i = 1:length(mr_array)
    if Mode == 1
        set_param(mr_array{i}, 'SimulationMode', 'Normal');
    else
        set_param(mr_array{i}, 'SimulationMode', 'Accelerator');
    end
    
%     disp([mr_array{i} ' has been set to Normal SimulationMode']);
end
%% Compile Outputs:
%	= -1;

end % << End of function ChangeMRMode >>

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
