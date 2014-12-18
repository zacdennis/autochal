% FORMAT_STRUCT replaces or Adds Structure field and value
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% format_struct:
%     Replaces or Adds Structure field and value
% 
% SYNTAX:
%	[s, fieldValue] = format_struct(s, strField, valField, SortMode)
%	[s, fieldValue] = format_struct(s, strField, valField)
%
% INPUTS: 
%	Name      	Size		Units		Description
%   s           [structure]             input structure
%   strField    [string]                Field to look for
%   valField    [varies]                Default field value
%   SortMode    [1]                     {0}: Overwrites field if field is 
%                                       empty or creates field/value if it 
%                                       does not exist
%                                       1: Always overwrites field or
%                                       creates field/value if it does not
%                                       exist
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	s   	         <size>		<units>		<Description> 
%	fieldValue	<size>		<units>		<Description> 
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
% test.a = 1;
% format_struct(test,'a',2,0)
% ans =
% a: 1.00
%
% format_struct(test,'a',2,1)
% ans =
% a: 2.00
%
% format_struct(test,'b',2,1)
% ans =
% a: 1.00
% b: 2.00
%
%	% <Enter Description of Example #1>
%	[s, fieldValue] = format_struct(s, strField, valField, SortMode, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[s, fieldValue] = format_struct(s, strField, valField, SortMode)
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
%	Source function: <a href="matlab:edit format_struct.m">format_struct.m</a>
%	  Driver script: <a href="matlab:edit Driver_format_struct.m">Driver_format_struct.m</a>
%	  Documentation: <a href="matlab:pptOpen('format_struct_Function_Documentation.pptx');">format_struct_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/444
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/format_struct.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [s, fieldValue] = format_struct(s, strField, valField, SortMode)

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

% fieldValue= -1;
if nargin < 4
    SortMode = 0;
end
%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        SortMode= ''; valField= ''; strField= ''; s= ''; 
%       case 1
%        SortMode= ''; valField= ''; strField= ''; 
%       case 2
%        SortMode= ''; valField= ''; 
%       case 3
%        SortMode= ''; 
%       case 4
%        
%       case 5
%        
%  end
%
%  if(isempty(SortMode))
%		SortMode = -1;
%  end
%% Main Function:

fieldValue = valField;
if(isfield(s, strField))
    fieldValue = s.(strField);
    
    switch SortMode
        case 0
            % Overwrite only if empty:     
            if(isempty(fieldValue))
                s.(strField) = valField;
            end
            
        case 1
            % Forced Overwrite:
            s.(strField) = valField;
    end
    
else
    s.(strField) = valField;
end    

%% Compile Outputs:
%	s= -1;
%	fieldValue= -1;

end % << End of function format_struct >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
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
