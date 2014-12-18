% READ_DATA reads a txt file w/ a row of headers and rows of numerical data
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% read_data:
% This m-file reads in a space delimited text file formatted
% with a row of column headers and rows of numerical data.
% It returns the header row, the data in a matrix, and any error
% messages associated with opening the file.
%
% This function will only work on Windows and may have problems reading
% Windows CR markers in Linux.
% 
% SYNTAX:
%	[data, header, error_msg] = read_data(filename, option, varargin, 'PropertyName', PropertyValue)
%	[data, header, error_msg] = read_data(filename, option, varargin)
%	[data, header, error_msg] = read_data(filename, option)
%	[data, header, error_msg] = read_data(filename)
%
% INPUTS: 
%	Name     	Size    Units		Description
%	filename    [1xN]   [ND]        String of name of data file to be opened 
%                                    (with path)
%	option	   <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size    Units		Description
%	header      [1xN]   [ND]        Vector of strings that heads columns 
%	data        [MxN]   [ND]	  	Data matrix in file
%	error_msg   [1x1]   [ND]		An error message for file open
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
%	[data, header, error_msg] = read_data(filename, option, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[data, header, error_msg] = read_data(filename, option)
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
%	Source function: <a href="matlab:edit read_data.m">read_data.m</a>
%	  Driver script: <a href="matlab:edit Driver_read_data.m">Driver_read_data.m</a>
%	  Documentation: <a href="matlab:pptOpen('read_data_Function_Documentation.pptx');">read_data_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/462
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/read_data.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [data, header, error_msg] = read_data(filename, option, varargin)

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
% data= -1;
% header= -1;
% error_msg= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        option= ''; filename= ''; 
%       case 1
%        option= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(option))
%		option = -1;
%  end
%% Main Function:
if nargin<2,option=[];end
%
% intialize return arguments
%
error_msg = [];
data = [];
header=[];

%
% intialize file type variables
%
file_type=[];
block_print=0;
%
% open the data file
%
[fid,error_msg] = fopen(filename,'rt');
if fid < 0
  disp(error_msg)
  return
end
%
% read first line and determine file type
%
first_line = deblank(fgetl(fid));
if isempty(findstr(first_line,','))
  file_type=block_print;
end

%
% process the header
%
first_line = strrep(first_line,',','');

[header,remainder] = strtok(first_line);
while ~isempty(remainder)
  [string,remainder] = strtok(remainder);  
  header = char(header,string);
end

if strcmp(option,'header_only'),return;end
%
% Set up the format string
%
[m,n]=size(header');
if (file_type == block_print)
   form='%f\n';
end

%
% Read the data file
%
input=fscanf(fid,form,inf);

%
% parse data
%
m=floor(length(input)/n);
data=zeros(m,n);
for k=1:m
   data(k,:) = input((k-1)*n+1:(k*n))';
end

fclose(fid);
%
% end of read_data
%

%% Compile Outputs:
%	data= -1;
%	header= -1;
%	error_msg= -1;

end % << End of function read_data >>

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
