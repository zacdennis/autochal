% COUNTBLOCKS_MDLREF Computes raw block total for a model
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CountBlocks_mdlRef:
%     This function computes the raw block total for the specified
%     model, looking within masked subsystems, library links, and
%     model references.
% 
% SYNTAX:
%	[NumBlks] = CountBlocks_mdlRef(ModelName, varargin, 'PropertyName', PropertyValue)
%	[NumBlks] = CountBlocks_mdlRef(ModelName, varargin)
%	[NumBlks] = CountBlocks_mdlRef(ModelName)
%
% INPUTS: 
%	Name     	Size		Units		Description
%	ModelName	<size>		<units>		Name of the top model
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	NumBlks	  <size>		<units>		Block count total
%
% NOTES:
%      All reference models and libraries must exist on the MATLAB
%      path, and must not error when loaded.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%
%
%	% <Enter Description of Example #1>
%	[NumBlks] = CountBlocks_mdlRef(ModelName, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[NumBlks] = CountBlocks_mdlRef(ModelName)
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
%	Source function: <a href="matlab:edit CountBlocks_mdlRef.m">CountBlocks_mdlRef.m</a>
%	  Driver script: <a href="matlab:edit Driver_CountBlocks_mdlRef.m">Driver_CountBlocks_mdlRef.m</a>
%	  Documentation: <a href="matlab:pptOpen('CountBlocks_mdlRef_Function_Documentation.pptx');">CountBlocks_mdlRef_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/534
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CountBlocks_mdlRef.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [NumBlks] = CountBlocks_mdlRef(ModelName, varargin)

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
% NumBlks= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        ModelName= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:
% Load the model silently
load_system(ModelName);

% Count the blocks in this model
NumBlks = numel(find_system(ModelName,'FollowLinks','on','LookUnderMasks','all'));

% Find all the model reference blocks
ModelNameRefBlks = find_system(ModelName,'FollowLinks','on','LookUnderMasks','all',...
    'BlockType','ModelReference');

% Get all the referenced model names
RefModels = get_param(ModelNameRefBlks,'ModelName');

% Now get a unique list of models, and the number of instances of each
[UniqueModels, tmp, UniqueModelsLoc] = unique(RefModels);

% Loop through each model and count blocks
% Multiply by the number of instances of each reference model]
for i=1:numel(UniqueModels)
    NumInstances = sum(UniqueModelsLoc==i);
    NumBlks = NumBlks + (NumInstances * CountBlocks_mdlRef(UniqueModels{i}));
end

%% Compile Outputs:
%	NumBlks= -1;

end % << End of function CountBlocks_mdlRef >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
% 080101 MCG: Copyright 2008 The MathWorks, Inc.
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720 
% MCG: MathWorks Consulting Group

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
