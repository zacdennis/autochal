% WRITE_CODECHECK_BAT Writes .bat file for CodeCheck harness
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Write_CodeCheck_bat:
%     Writes .bat file for CodeCheck harness
% 
% SYNTAX:
%	[filename] = Write_CodeCheck_bat(strModel, CodeFolder, varargin, 'PropertyName', PropertyValue)
%	[filename] = Write_CodeCheck_bat(strModel, CodeFolder, varargin)
%	[filename] = Write_CodeCheck_bat(strModel, CodeFolder)
%	[filename] = Write_CodeCheck_bat(strModel)
%
% INPUTS: 
%	Name      	Size		Units		Description
%	strModel	  <size>		<units>		<Description>
%	CodeFolder	<size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	filename	  <size>		<units>		<Description> 
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
%	[filename] = Write_CodeCheck_bat(strModel, CodeFolder, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[filename] = Write_CodeCheck_bat(strModel, CodeFolder)
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
%	Source function: <a href="matlab:edit Write_CodeCheck_bat.m">Write_CodeCheck_bat.m</a>
%	  Driver script: <a href="matlab:edit Driver_Write_CodeCheck_bat.m">Driver_Write_CodeCheck_bat.m</a>
%	  Documentation: <a href="matlab:pptOpen('Write_CodeCheck_bat_Function_Documentation.pptx');">Write_CodeCheck_bat_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/703
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [filename] = Write_CodeCheck_bat(strModel, CodeFolder, varargin)

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
[OpenAfterCreated, varargin]    = format_varargin('OpenAfterCreated', true,  2, varargin);
% OpenAfterCreated = 1;

%% Initialize Outputs:
fstr = '';
fstr = [fstr '@rem This works, but it could be auto-generated in the future' endl];
fstr = [fstr '@rem' endl];
fstr = [fstr '@rem MATLAB system(''%comspec% /k ""c:\Program Files\Microsoft Visual Studio 2005\VC\vcvarsall.bat"" x86'')' endl];
fstr = [fstr '@rem will call ''C:\Program Files\Microsoft Visual Studio 2005\VC\bin\vsvarsall.bat''' endl];
fstr = [fstr '@rem which only has this line in it: "%VS80COMNTOOLS%vsvars32.bat"' endl];
fstr = [fstr '@rem' endl];
fstr = [fstr '@rem ''VS80COMNTOOLS'' is a systems environment variable whose value is:' endl];
fstr = [fstr '@rem c:\Program Files\Microsoft Visual Studio 2005\Common7\Tools\' endl];
fstr = [fstr '@rem' endl];
fstr = [fstr '@rem So you''re really calling:  c:\Program Files\Microsoft Visual Studio 2005\Common7\Tools\vsvars32.bat' endl];
fstr = [fstr '@rem' endl];
fstr = [fstr '@rem which is copied now below' endl];
fstr = [fstr '@rem' endl];
fstr = [fstr '@rem All you have to do now is two things:' endl];
fstr = [fstr '@rem 1. Remove any line returns (char(10), sprintf(''\n'') from the ''PATH'', ''INCLUDE'', ''LIB'', and ''LIBPATH''' endl];
fstr = [fstr '@rem    In other words, make sure that each set PATH, INCLUDE, etc. has it''s own line' endl];
fstr = [fstr '@rem 2. Add in the call to msbuild using form' endl];
fstr = [fstr '@rem    msbuild <full path to solution.sln>' endl];
fstr = [fstr '@rem    -OR-' endl];
fstr = [fstr '@rem    msbuild <full path to solution.vcproj>  <-- Need to test this still' endl];
fstr = [fstr '' endl];
fstr = [fstr '@SET VSINSTALLDIR=c:\Program Files\Microsoft Visual Studio 2005' endl];
fstr = [fstr '@SET VCINSTALLDIR=c:\Program Files\Microsoft Visual Studio 2005\VC' endl];
fstr = [fstr '@SET FrameworkDir=c:\WINDOWS\Microsoft.NET\Framework' endl];
fstr = [fstr '@SET FrameworkVersion=v2.0.50727' endl];
fstr = [fstr '@SET FrameworkSDKDir=c:\Program Files\Microsoft Visual Studio 2005\SDK\v2.0' endl];
fstr = [fstr '@if "%VSINSTALLDIR%"=="" goto error_no_VSINSTALLDIR' endl];
fstr = [fstr '@if "%VCINSTALLDIR%"=="" goto error_no_VCINSTALLDIR' endl];
fstr = [fstr '' endl];
fstr = [fstr '@ echo Setting environment for using Microsoft Visual Studio 2005 x86 tools.' endl];
fstr = [fstr '' endl];
fstr = [fstr '@rem' endl];
fstr = [fstr '@rem Root of Visual Studio IDE installed files.' endl];
fstr = [fstr '@rem' endl];
fstr = [fstr '@set DevEnvDir=c:\Program Files\Microsoft Visual Studio 2005\Common7\IDE' endl];
fstr = [fstr '' endl];
fstr = [fstr '@set PATH=c:\Program Files\Microsoft Visual Studio 2005\Common7\IDE;c:\Program Files\Microsoft Visual Studio 2005\VC\BIN;c:\Program Files\Microsoft Visual Studio 2005\Common7\Tools;c:\Program Files\Microsoft Visual Studio 2005\Common7\Tools\bin;c:\Program Files\Microsoft Visual Studio 2005\VC\PlatformSDK\bin;c:\Program Files\Microsoft Visual Studio 2005\SDK\v2.0\bin;c:\WINDOWS\Microsoft.NET\Framework\v2.0.50727;c:\Program Files\Microsoft Visual Studio 2005\VC\VCPackages;%PATH%' endl];
fstr = [fstr '@set INCLUDE=c:\Program Files\Microsoft Visual Studio 2005\VC\ATLMFC\INCLUDE;c:\Program Files\Microsoft Visual Studio 2005\VC\INCLUDE;c:\Program Files\Microsoft Visual Studio 2005\VC\PlatformSDK\include;c:\Program Files\Microsoft Visual Studio 2005\SDK\v2.0\include;%INCLUDE%' endl];
fstr = [fstr '@set LIB=c:\Program Files\Microsoft Visual Studio 2005\VC\ATLMFC\LIB;c:\Program Files\Microsoft Visual Studio 2005\VC\LIB;c:\Program Files\Microsoft Visual Studio 2005\VC\PlatformSDK\lib;c:\Program Files\Microsoft Visual Studio 2005\SDK\v2.0\lib;%LIB%' endl];
fstr = [fstr '@set LIBPATH=c:\WINDOWS\Microsoft.NET\Framework\v2.0.50727;c:\Program Files\Microsoft Visual Studio 2005\VC\ATLMFC\LIB' endl];
fstr = [fstr '' endl];
fstr = [fstr '@goto end' endl];
fstr = [fstr '' endl];
fstr = [fstr ':error_no_VSINSTALLDIR' endl];
fstr = [fstr '@echo ERROR: VSINSTALLDIR variable is not set. ' endl];
fstr = [fstr '@goto end' endl];
fstr = [fstr '' endl];
fstr = [fstr ':error_no_VCINSTALLDIR' endl];
fstr = [fstr '@echo ERROR: VCINSTALLDIR variable is not set. ' endl];
fstr = [fstr '@goto end' endl];
fstr = [fstr '' endl];
fstr = [fstr ':end' endl];
fstr = [fstr '' endl];
fstr = [fstr 'msbuild ' CodeFolder filesep 'CodeCheck_' strModel '.vcproj' endl];

filename = ['Build_CodeCheck_' strModel '_sln.bat'];

info.fname_full = [CodeFolder filesep filename];
info.text = fstr;

[fid, message ] = fopen(info.fname_full, 'wt','native');

if fid == -1
    info.error = [mfnam '>> ERROR: File Not created: ' message];
    disp(info.error)
    return
else %any answer besides 'Y'
    fprintf(fid,'%s',fstr);
    fclose(fid);
    if(OpenAfterCreated)
        edit(info.fname_full);
    end
    info.OK = 'maybe it worked';
end


%% Compile Outputs:
filename= info.fname_full;

end % << End of function Write_CodeCheck_bat >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 110520 <INI>: Created function using CreateNewFunc
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
