% CLEARNEWVARS clears new work space variables leaving old ones alone. 
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ClearNewVars:
%function that clears new work space variables leaving any preexisting variables
%alone.   
% 
% SYNTAX:
%	[ClearVarOutput] = ClearNewVars(origvars, varargin, 'PropertyName', PropertyValue)
%	[ClearVarOutput] = ClearNewVars(origvars, varargin)
%	[ClearVarOutput] = ClearNewVars(origvars)
%
% INPUTS: 
%	Name          	Size		Units		Description
%   origvars                                Previous output of a WHO call.
%	varargin	[N/A]		[varies]        Optional function inputs that
%                                           should be entered in pairs.
%                                           See the 'VARARGIN' section
%                                           below for more details
%
% OUTPUTS: 
%	Name          	Size		Units		Description
%	clearedvars                             Cell list of cleared variables
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%
% origvars = who;
% your script here
% origvars = [origvars; {'newkeepvar1'; 'newkeepvar2'}]
% [ClearVarOutput] = ClearNewVars(origvars);
%
%	% <Enter Description of Example #1>
%	[ClearVarOutput] = ClearNewVars(origvars, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[ClearVarOutput] = ClearNewVars(origvars)
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
%	Source function: <a href="matlab:edit ClearNewVars.m">ClearNewVars.m</a>
%	  Driver script: <a href="matlab:edit Driver_ClearNewVars.m">Driver_ClearNewVars.m</a>
%	  Documentation: <a href="matlab:pptOpen('ClearNewVars_Function_Documentation.pptx');">ClearNewVars_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/43
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/ClearNewVars.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [ClearVarOutput] = ClearNewVars(origvars, varargin)

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
% ClearVarOutput= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        origvars= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:
%  <Insert Main Function>

%% Compile Outputs:
if  ~any([isa(origvars,'cell') isa(origvars,'char')]);
    disp([mfilename '>> ERROR Quiting type failure input 1']);
    ClearVarOutput.Flag = -1;
    ClearVarOutput.ClearedVars = {};
end;

for i=1:length(varargin)
    if isa(varargin{i},'cell') 
        [n,m]=size(varargin{i});
        for j=1:m
            newtopivect = (j-1)*n+1;
            newbotivect = newtopivect+n-1;
            colcell(newtopivect:newbotivect,1) = varargin{i}(:,j);
        end;
        origvars(end+1:end+length(colcell)) = colcell(:);
    elseif isa(varargin{i},'char')
        origvars{end+1} = varargin{i};
    else
        disp([mfilenam '>>ERROR. Type failure on input ' num2str(i)]);
        ClearVarOutput.Flag = -1;
        ClearVarOutput.ClearedVars = {};
    end;
end;
        

ClearVarOutput.SaveVars = origvars;
ClearVarOutput.ClearedVars = {};
ClearVarOutput.SaveListVarName = inputname(1);
ndeleted = 0;
EvalStr = '';
S= evalin('base','who');
for i = 1:length(S)
    I1 = strmatch(S{i},origvars,'exact');
    %I2 = strmatch(S{i},ClearVarOutput.SaveListVarName,'exact'); I want to
    %delete this one...
    if isempty(I1);%&& isempty(I2); %variable didn't used to exist and isn't the input variable
        ndeleted = ndeleted + 1; 
        EvalStr = [EvalStr ' ' S{i}];
        ClearVarOutput.ClearedVars{ndeleted} = S{i};
    end;
end;
if strcmp(EvalStr,'')
    %no variables to clear
    disp([mfilename '>> No variables to clear (perhaps they were duplicates of preexising)']);
else
    evalin('base',['clear ' EvalStr ';']); %perform actuall delete.. 
end;

end % << End of function ClearNewVars >>

function [colcell]=reorgCell(cellin);
% fucntion ot make a column vector out of any cell.
% called by ClearNewVars Only...

[n,m]=size(cellin);

for j=1:m
    newtopivect = (j-1)*n+1;
    newbotivect = newtopivect+n;
    colcell{newtopivect:newbotivect,1} = cellin(:,j);
end;
end

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
% 050101 TV : Created. 
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% TV : Travis Vetter

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
