% WRITE_CODECHECK_VCPROJ Builds the .vcproj file needed to code check an autocded block
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Write_CodeCheck_vcproj:
%     Builds the .vcproj file needed to compile the code check verification
%     code.
%
% SYNTAX:
%	[filename] = Write_CodeCheck_vcproj(strModel, lstIncludes, varargin, 'PropertyName', PropertyValue)
%	[filename] = Write_CodeCheck_vcproj(strModel, lstIncludes, varargin)
%	[filename] = Write_CodeCheck_vcproj(strModel, lstIncludes)
%	[filename] = Write_CodeCheck_vcproj(strModel)
%
% INPUTS:
%	Name       	Size		Units		Description
%	strModel	   <size>		<units>		<Description>
%	lstIncludes	<size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS:
%	Name       	Size		Units		Description
%	filename	   <size>		<units>		<Description>
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
%	[filename] = Write_CodeCheck_vcproj(strModel, lstIncludes, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Write_CodeCheck_vcproj.m">Write_CodeCheck_vcproj.m</a>
%	  Driver script: <a href="matlab:edit Driver_Write_CodeCheck_vcproj.m">Driver_Write_CodeCheck_vcproj.m</a>
%	  Documentation: <a href="matlab:pptOpen('Write_CodeCheck_vcproj_Function_Documentation.pptx');">Write_CodeCheck_vcproj_Function_Documentation.pptx</a>
%
% See also <add relevant functions>
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/700
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [filename] = Write_CodeCheck_vcproj(strModel, lstIncludes, varargin)

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
[SaveFolder, varargin]      = format_varargin('SaveFolder', pwd,  2, varargin);
[OpenAfterCreated, varargin]= format_varargin('OpenAfterCreated', true,  2, varargin);
[TestModelName, varargin]= format_varargin('TestModelName', ['CodeCheck_' strModel],  2, varargin);
% OpenAfterCreated = true;

%% Main Function:
Project = randstr('"{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}"');
ProjectGUID = randstr('{72FCCC43-5AAA-417D-9B6A-0130B2E2869B}');

%%  Write the .sln
if(0)
    filename= [TestModelName '.sln'];
    fstr = '';
    fstr = [fstr '﻿' endl];
    fstr = [fstr 'Microsoft Visual Studio Solution File, Format Version 9.00' endl];
    fstr = [fstr '# Visual Studio 2005' endl];
    fstr = [fstr 'Project(' Project ') = "TestMain", "TestMain.vcproj", "' ProjectGUID '"' endl];
    fstr = [fstr 'EndProject' endl];
    fstr = [fstr 'Global' endl];
    fstr = [fstr '	GlobalSection(SolutionConfigurationPlatforms) = preSolution' endl];
    fstr = [fstr '		Debug|Win32 = Debug|Win32' endl];
    fstr = [fstr '		Release|Win32 = Release|Win32' endl];
    fstr = [fstr '	EndGlobalSection' endl];
    fstr = [fstr '	GlobalSection(ProjectConfigurationPlatforms) = postSolution' endl];
    fstr = [fstr '		' ProjectGUID '.Debug|Win32.ActiveCfg = Debug|Win32' endl];
    fstr = [fstr '		' ProjectGUID '.Debug|Win32.Build.0 = Debug|Win32' endl];
    fstr = [fstr '		' ProjectGUID '.Release|Win32.ActiveCfg = Release|Win32' endl];
    fstr = [fstr '		' ProjectGUID '.Release|Win32.Build.0 = Release|Win32' endl];
    fstr = [fstr '	EndGlobalSection' endl];
    fstr = [fstr '	GlobalSection(SolutionProperties) = preSolution' endl];
    fstr = [fstr '		HideSolutionNode = FALSE' endl];
    fstr = [fstr '	EndGlobalSection' endl];
    fstr = [fstr 'EndGlobal' endl];
    %
    % Write header
    info.fname = filename;
    
    info.fname_full = [SaveFolder filesep info.fname];
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
end

%%
filename= [TestModelName '.vcproj'];
fstr = '';
fstr = [fstr '<?xml version="1.0" encoding="Windows-1252"?>' endl];
fstr = [fstr '<VisualStudioProject' endl];
fstr = [fstr '	ProjectType="Visual C++"' endl];
fstr = [fstr '	Version="8.00"' endl];
fstr = [fstr '	Name="' TestModelName '"' endl];
fstr = [fstr '	ProjectGUID="' ProjectGUID '"' endl];
fstr = [fstr '	RootNamespace="TestMain"' endl];
fstr = [fstr '	Keyword="Win32Proj"' endl];
fstr = [fstr '	>' endl];
fstr = [fstr '	<Platforms>' endl];
fstr = [fstr '		<Platform' endl];
fstr = [fstr '			Name="Win32"' endl];
fstr = [fstr '		/>' endl];
fstr = [fstr '	</Platforms>' endl];
fstr = [fstr '	<ToolFiles>' endl];
fstr = [fstr '	</ToolFiles>' endl];
fstr = [fstr '	<Configurations>' endl];
fstr = [fstr '		<Configuration' endl];
fstr = [fstr '			Name="Debug|Win32"' endl];
fstr = [fstr '			OutputDirectory="$(SolutionDir)"' endl];
fstr = [fstr '			IntermediateDirectory="$(ConfigurationName)"' endl];
fstr = [fstr '			ConfigurationType="1"' endl];
fstr = [fstr '			CharacterSet="1"' endl];
fstr = [fstr '			>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCPreBuildEventTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCCustomBuildTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCXMLDataGeneratorTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCWebServiceProxyGeneratorTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCMIDLTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCCLCompilerTool"' endl];
fstr = [fstr '				Optimization="0"' endl];
fstr = [fstr '				PreprocessorDefinitions="WIN32;_DEBUG;_CONSOLE"' endl];
fstr = [fstr '				MinimalRebuild="true"' endl];
fstr = [fstr '				BasicRuntimeChecks="3"' endl];
fstr = [fstr '				RuntimeLibrary="3"' endl];
fstr = [fstr '				UsePrecompiledHeader="0"' endl];
fstr = [fstr '				WarningLevel="3"' endl];
fstr = [fstr '				Detect64BitPortabilityProblems="true"' endl];
fstr = [fstr '				DebugInformationFormat="4"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCManagedResourceCompilerTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCResourceCompilerTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCPreLinkEventTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCLinkerTool"' endl];
fstr = [fstr '				OutputFile="$(SolutionDir)$(ProjectName).exe"' endl];
fstr = [fstr '				LinkIncremental="2"' endl];
fstr = [fstr '				GenerateDebugInformation="true"' endl];
fstr = [fstr '				SubSystem="1"' endl];
fstr = [fstr '				TargetMachine="1"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCALinkTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCManifestTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCXDCMakeTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCBscMakeTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCFxCopTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCAppVerifierTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCWebDeploymentTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCPostBuildEventTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '		</Configuration>' endl];
fstr = [fstr '		<Configuration' endl];
fstr = [fstr '			Name="Release|Win32"' endl];
fstr = [fstr '			OutputDirectory="$(SolutionDir)$(ConfigurationName)"' endl];
fstr = [fstr '			IntermediateDirectory="$(ConfigurationName)"' endl];
fstr = [fstr '			ConfigurationType="1"' endl];
fstr = [fstr '			CharacterSet="1"' endl];
fstr = [fstr '			WholeProgramOptimization="1"' endl];
fstr = [fstr '			>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCPreBuildEventTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCCustomBuildTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCXMLDataGeneratorTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCWebServiceProxyGeneratorTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCMIDLTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCCLCompilerTool"' endl];
fstr = [fstr '				PreprocessorDefinitions="WIN32;NDEBUG;_CONSOLE"' endl];
fstr = [fstr '				RuntimeLibrary="2"' endl];
fstr = [fstr '				UsePrecompiledHeader="0"' endl];
fstr = [fstr '				WarningLevel="3"' endl];
fstr = [fstr '				Detect64BitPortabilityProblems="true"' endl];
fstr = [fstr '				DebugInformationFormat="3"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCManagedResourceCompilerTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCResourceCompilerTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCPreLinkEventTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCLinkerTool"' endl];
fstr = [fstr '				LinkIncremental="1"' endl];
fstr = [fstr '				GenerateDebugInformation="true"' endl];
fstr = [fstr '				SubSystem="1"' endl];
fstr = [fstr '				OptimizeReferences="2"' endl];
fstr = [fstr '				EnableCOMDATFolding="2"' endl];
fstr = [fstr '				TargetMachine="1"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCALinkTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCManifestTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCXDCMakeTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCBscMakeTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCFxCopTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCAppVerifierTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCWebDeploymentTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '			<Tool' endl];
fstr = [fstr '				Name="VCPostBuildEventTool"' endl];
fstr = [fstr '			/>' endl];
fstr = [fstr '		</Configuration>' endl];
fstr = [fstr '	</Configurations>' endl];
fstr = [fstr '	<References>' endl];
fstr = [fstr '	</References>' endl];
fstr = [fstr '	<Files>' endl];
fstr = [fstr '		<Filter' endl];
fstr = [fstr '			Name="Source Files"' endl];
fstr = [fstr '			Filter="cpp;c;cc;cxx;def;odl;idl;hpj;bat;asm;asmx"' endl];

UniqueIdentifier = randstr('"{4FC737F1-C7A5-4376-A066-2A32D752A2FF}"');

fstr = [fstr '			UniqueIdentifier=' UniqueIdentifier endl];
fstr = [fstr '			>' endl];

for i = 1:size(lstIncludes, 1)
    curInclude = lstIncludes{i,:};
    fstr = [fstr '			<File' endl];
    fstr = [fstr '				RelativePath=".\' curInclude '"' endl];
    fstr = [fstr '				>' endl];
    fstr = [fstr '			</File>' endl];
end

fstr = [fstr '			<File' endl];
fstr = [fstr '				RelativePath=".\' strModel '.cpp"' endl];
fstr = [fstr '				>' endl];
fstr = [fstr '			</File>' endl];
fstr = [fstr '			<File' endl];
fstr = [fstr '				RelativePath=".\' strModel '_data.cpp"' endl];
fstr = [fstr '				>' endl];
fstr = [fstr '			</File>' endl];
fstr = [fstr '			<File' endl];
fstr = [fstr '				RelativePath=".\' TestModelName '.cpp"' endl];
fstr = [fstr '				>' endl];
fstr = [fstr '			</File>' endl];
fstr = [fstr '		</Filter>' endl];
fstr = [fstr '		<Filter' endl];
fstr = [fstr '			Name="Header Files"' endl];
fstr = [fstr '			Filter="h;hpp;hxx;hm;inl;inc;xsd"' endl];

UniqueIdentifier = randstr('"{93995380-89BD-4b04-88EB-625FBE52EBFB}"');

fstr = [fstr '			UniqueIdentifier=' UniqueIdentifier endl];
fstr = [fstr '			>' endl];

for i = 1:size(lstIncludes, 1)
    curInclude = lstIncludes{i,:};
    curInclude = strrep(curInclude, '.cpp', '');
    curInclude = strrep(curInclude, '.c', '');
    fstr = [fstr '			<File' endl];
    fstr = [fstr '				RelativePath=".\' curInclude '.h"' endl];
    fstr = [fstr '				>' endl];
    fstr = [fstr '			</File>' endl];
end

fstr = [fstr '			<File' endl];
fstr = [fstr '				RelativePath=".\rtw_shared_utils.h"' endl];
fstr = [fstr '				>' endl];
fstr = [fstr '			</File>' endl];
fstr = [fstr '			<File' endl];
fstr = [fstr '				RelativePath=".\rtwtypes.h"' endl];
fstr = [fstr '				>' endl];
fstr = [fstr '			</File>' endl];
fstr = [fstr '			<File' endl];
fstr = [fstr '				RelativePath=".\' strModel '.h"' endl];
fstr = [fstr '				>' endl];
fstr = [fstr '			</File>' endl];
fstr = [fstr '			<File' endl];
fstr = [fstr '				RelativePath=".\' strModel '_private.h"' endl];
fstr = [fstr '				>' endl];
fstr = [fstr '			</File>' endl];
fstr = [fstr '			<File' endl];
fstr = [fstr '				RelativePath=".\' strModel '_types.h"' endl];
fstr = [fstr '				>' endl];
fstr = [fstr '			</File>' endl];
fstr = [fstr '		</Filter>' endl];
fstr = [fstr '		<Filter' endl];
fstr = [fstr '			Name="Resource Files"' endl];
fstr = [fstr '			Filter="rc;ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe;resx;tiff;tif;png;wav"' endl];

UniqueIdentifier = randstr('"{67DA6AB6-F800-4c08-8B7A-83BB121AAD01}"');

fstr = [fstr '			UniqueIdentifier=' UniqueIdentifier endl];
fstr = [fstr '			>' endl];
fstr = [fstr '		</Filter>' endl];
fstr = [fstr '	</Files>' endl];
fstr = [fstr '	<Globals>' endl];
fstr = [fstr '	</Globals>' endl];
fstr = [fstr '</VisualStudioProject>' endl];

%%
% Write header
info.fname = filename;

info.fname_full = [SaveFolder filesep info.fname];
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

end % << End of function Write_CodeCheck_vcproj >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110516 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName         : Email                 : NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi

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