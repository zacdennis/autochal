% WRITE_RTCF_VCPROJ Writes the RTCF .vcproj and .sln files
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Write_RTCF_vcproj:
%     Writes the RTCF .vcproj and .sln files
%
% SYNTAX:
%	[filename] = Write_RTCF_vcproj(strModel, lstIncludes, varargin, 'PropertyName', PropertyValue)
%	[filename] = Write_RTCF_vcproj(strModel, lstIncludes, varargin)
%	[filename] = Write_RTCF_vcproj(strModel, lstIncludes)
%	[filename] = Write_RTCF_vcproj(strModel)
%
% INPUTS:
%	Name       	Size		Units       Description
%	strModel	'string'    [char]      Name of model being coded
%	lstIncludes	{'string'}  {[char]}    Full path to .c/.cpp/.h files to
%                                        include
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
%   'RootCodeFolder'    'string'        pwd         Reference top-level
%                                                    folder from which all
%                                                    RTCF folders are
%                                                    determined
%   'CCodeFolder'       'string'        strModel    Name of folder under
%                                                    'RootCodeFolder'in
%                                                    which to place wrapper
%                                                    .h/.cpp files
%   'BinFolder'         'string'        'bin'       Name of folder under
%                                                    'RootCodeFolder' in
%                                                    which to place
%                                                    compiled RTCF .dll
%   'IncludeFolders'    {'string'}      {}          List of additional
%                                                    folders to include
%                                                    that are relative to
%                                                    'RootCodeFolder'
%   'OpenAfterCreated'  [bool]          true        Open files in editor
%                                                    after they have been
%                                                    created?
%   'TreatWChar_tAsBuiltInType'      [bool] true    .vcproj Language option
%                                                    under C/C++ Property
%                                                    Page (RTCF v5.8 default)
%   'ForceConformanceInForLoopScope' [bool] true    .vcproj Language option
%                                                    under C/C++ Property
%                                                    Page (RTCF v5.8 default)
%   'RuntimeTypeInfo'                [bool] true    .vcproj Language option
%                                                    under C/C++ Property
%                                                    Page (RTCF v5.8 default)
%   'GenerateDebugInformation'       [bool] false   .vcproj Debugging
%                                                    option under Liker
%                                                    Property Page
%   'RTCF_HOME'                     'string' 'C:\RTCF\5_9_4\RTCF_5_9_4'
%                                                   Main home of RTCF
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[filename] = Write_RTCF_vcproj(strModel, lstIncludes, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Write_RTCF_vcproj.m">Write_RTCF_vcproj.m</a>
%	  Driver script: <a href="matlab:edit Driver_Write_RTCF_vcproj.m">Driver_Write_RTCF_vcproj.m</a>
%	  Documentation: <a href="matlab:pptOpen('Write_RTCF_vcproj_Function_Documentation.pptx');">Write_RTCF_vcproj_Function_Documentation.pptx</a>
%
% See also format_varargin, bool2str
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/715
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CodeGen/Write_RTCF_vcproj.m $
% $Rev: 3228 $
% $Date: 2014-08-05 14:28:27 -0500 (Tue, 05 Aug 2014) $
% $Author: sufanmi $

function [filename] = Write_RTCF_vcproj(strModel, lstIncludes, varargin)

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
[RootCodeFolder, varargin]              = format_varargin('RootCodeFolder', pwd,  2, varargin);
[CCodeFolder, varargin]                 = format_varargin('CCodeFolder', strModel,  2, varargin);
[BinFolder, varargin]                   = format_varargin('BinFolder', 'bin', 0, varargin);
[lstIncludeFolders, varargin]           = format_varargin('IncludeFolders', {}, 0, varargin);
[OpenAfterCreated, varargin]            = format_varargin('OpenAfterCreated', true,  2, varargin);
[RTCFSourceFolder, varargin]            = format_varargin('RTCFSourceFolder', 'Source/',  3, varargin);
[TreatWChar_tAsBuiltInType, varargin]   = format_varargin('TreatWChar_tAsBuiltInType', true,  2, varargin);
[ForceConformanceInForLoopScope, varargin] = format_varargin('ForceConformanceInForLoopScope', true,  2, varargin);
[RuntimeTypeInfo, varargin]             = format_varargin('RuntimeTypeInfo', true,  2, varargin);
[GenerateDebugInformation, varargin]    = format_varargin('GenerateDebugInformation', false, 2, varargin);
[RTCF_HOME, varargin]                   = format_varargin('RTCF_HOME', 'C:\RTCF\5_9_4\RTCF_5_9_4', 2, varargin);

SaveFolder = [RootCodeFolder filesep CCodeFolder];

if(~iscell(lstIncludeFolders))
    lstIncludeFolders = { lstIncludeFolders };
end

mexParams = mex.getCompilerConfigurations;

%% Main Function:

numSlashes = length(strfind(CCodeFolder, filesep)) + 1;
strBackup = '';
for i = 1:numSlashes
    strBackup = [strBackup '..' filesep];
end

VS_ver = mexParams.Name;
VS_ver = strrep(VS_ver, 'Microsoft Visual C++ ', '');
VS_ver = VS_ver(1:4);

%% Supported Versions
% Version '8.0' - 'Microsoft Visual C++ 2005 SP1'
% Version '9.0' - 'Microsoft Visual C++ 2008'
% Version '10.0' - 'Microsoft Visual C++ 2010'
% VS_ver = '2008'; % Debugging

switch VS_ver
    case '2010'
        
        %%
        filename= [strModel '.vcxproj'];
        %         ProjectGUID = randstr('{71HGNC41-1UHP-946T-4R1Y-1274T3H0644P}');
        ProjectGUID = '{71HGNC41-1UHP-946T-4R1Y-1274T3H0644P}';
        fstr = '';
        
        fstr = [fstr '<?xml version="1.0" encoding="utf-8"?>' endl];
        fstr = [fstr '<Project DefaultTargets="Build" ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">' endl];
        fstr = [fstr '  <ItemGroup Label="ProjectConfigurations">' endl];
        fstr = [fstr '    <ProjectConfiguration Include="Debug|Win32">' endl];
        fstr = [fstr '      <Configuration>Debug</Configuration>' endl];
        fstr = [fstr '      <Platform>Win32</Platform>' endl];
        fstr = [fstr '    </ProjectConfiguration>' endl];
        fstr = [fstr '    <ProjectConfiguration Include="Release|Win32">' endl];
        fstr = [fstr '      <Configuration>Release</Configuration>' endl];
        fstr = [fstr '      <Platform>Win32</Platform>' endl];
        fstr = [fstr '    </ProjectConfiguration>' endl];
        fstr = [fstr '  </ItemGroup>' endl];
        fstr = [fstr '  <PropertyGroup Label="Globals">' endl];
        fstr = [fstr '    <ProjectGuid>' ProjectGUID '</ProjectGuid>' endl];
        fstr = [fstr '    <RootNamespace>' strModel '</RootNamespace>' endl];
        fstr = [fstr '    <Keyword>Win32Proj</Keyword>' endl];
        fstr = [fstr '  </PropertyGroup>' endl];
        fstr = [fstr '  <Import Project="$(VCTargetsPath)\Microsoft.Cpp.Default.props" />' endl];
        fstr = [fstr '  <PropertyGroup Condition="''$(Configuration)|$(Platform)''==''Release|Win32''" Label="Configuration">' endl];
        fstr = [fstr '    <ConfigurationType>StaticLibrary</ConfigurationType>' endl];
        fstr = [fstr '    <CharacterSet>Unicode</CharacterSet>' endl];
        fstr = [fstr '    <WholeProgramOptimization>true</WholeProgramOptimization>' endl];
        fstr = [fstr '  </PropertyGroup>' endl];
        fstr = [fstr '  <PropertyGroup Condition="''$(Configuration)|$(Platform)''==''Debug|Win32''" Label="Configuration">' endl];
        fstr = [fstr '    <ConfigurationType>DynamicLibrary</ConfigurationType>' endl];
        fstr = [fstr '    <CharacterSet>Unicode</CharacterSet>' endl];
        fstr = [fstr '  </PropertyGroup>' endl];
        fstr = [fstr '  <Import Project="$(VCTargetsPath)\Microsoft.Cpp.props" />' endl];
        fstr = [fstr '  <ImportGroup Label="ExtensionSettings">' endl];
        fstr = [fstr '  </ImportGroup>' endl];
        fstr = [fstr '  <ImportGroup Condition="''$(Configuration)|$(Platform)''==''Release|Win32''" Label="PropertySheets">' endl];
        fstr = [fstr '    <Import Project="$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props" Condition="exists(''$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props'')" Label="LocalAppDataPlatform" />' endl];
        fstr = [fstr '  </ImportGroup>' endl];
        fstr = [fstr '  <ImportGroup Condition="''$(Configuration)|$(Platform)''==''Debug|Win32''" Label="PropertySheets">' endl];
        fstr = [fstr '    <Import Project="$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props" Condition="exists(''$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props'')" Label="LocalAppDataPlatform" />' endl];
        fstr = [fstr '  </ImportGroup>' endl];
        fstr = [fstr '  <PropertyGroup Label="UserMacros" />' endl];
        fstr = [fstr '  <PropertyGroup>' endl];
        fstr = [fstr '    <_ProjectFileVersion>10.0.40219.1</_ProjectFileVersion>' endl];
        fstr = [fstr '    <OutDir Condition="''$(Configuration)|$(Platform)''==''Debug|Win32''">.\Debug\</OutDir>' endl];
        fstr = [fstr '    <IntDir Condition="''$(Configuration)|$(Platform)''==''Debug|Win32''">.\Debug\</IntDir>' endl];
        fstr = [fstr '    <LinkIncremental Condition="''$(Configuration)|$(Platform)''==''Debug|Win32''">false</LinkIncremental>' endl];
        fstr = [fstr '    <OutDir Condition="''$(Configuration)|$(Platform)''==''Release|Win32''">$(SolutionDir)$(Configuration)\</OutDir>' endl];
        fstr = [fstr '    <IntDir Condition="''$(Configuration)|$(Platform)''==''Release|Win32''">$(Configuration)\</IntDir>' endl];
        fstr = [fstr '  </PropertyGroup>' endl];
        fstr = [fstr '  <ItemDefinitionGroup Condition="''$(Configuration)|$(Platform)''==''Debug|Win32''">' endl];
        fstr = [fstr '    <ClCompile>' endl];
        fstr = [fstr '      <Optimization>Disabled</Optimization>' endl];
        fstr = [fstr '		<AdditionalIncludeDirectories>$(RTCF_HOME)/' RTCFSourceFolder 'CLSAPI;'];
        numIncludeFolders = size(lstIncludeFolders, 1);
        for iIncludeFolder = 1:numIncludeFolders
            fstr = [fstr strBackup lstIncludeFolders{iIncludeFolder} ';'];
        end
        fstr = [fstr '%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>' endl];
        
        fstr = [fstr '      <PreprocessorDefinitions>WIN32;_DEBUG;_CONSOLE;%(PreprocessorDefinitions)</PreprocessorDefinitions>' endl];
        fstr = [fstr '      <MinimalRebuild>true</MinimalRebuild>' endl];
        fstr = [fstr '      <BasicRuntimeChecks>EnableFastChecks</BasicRuntimeChecks>' endl];
        fstr = [fstr '      <RuntimeLibrary>MultiThreadedDebugDLL</RuntimeLibrary>' endl];
        fstr = [fstr '      <TreatWChar_tAsBuiltInType>' bool2str(TreatWChar_tAsBuiltInType, 'true', 'false') '</TreatWChar_tAsBuiltInType>' endl];
        fstr = [fstr '      <ForceConformanceInForLoopScope>' bool2str(ForceConformanceInForLoopScope, 'true', 'false') '</ForceConformanceInForLoopScope>' endl];
        fstr = [fstr '      <RuntimeTypeInfo>'  bool2str(RuntimeTypeInfo, 'true', 'false') '</RuntimeTypeInfo>' endl];
        fstr = [fstr '      <PrecompiledHeader>' endl];
        fstr = [fstr '      </PrecompiledHeader>' endl];
        fstr = [fstr '      <AssemblerListingLocation>.\Debug/</AssemblerListingLocation>' endl];
        fstr = [fstr '      <ObjectFileName>.\Debug/</ObjectFileName>' endl];
        fstr = [fstr '      <ProgramDataBaseFileName>.\Debug/</ProgramDataBaseFileName>' endl];
        fstr = [fstr '      <BrowseInformation>true</BrowseInformation>' endl];
        fstr = [fstr '      <BrowseInformationFile>$(IntDir)</BrowseInformationFile>' endl];
        fstr = [fstr '      <WarningLevel>Level3</WarningLevel>' endl];
        fstr = [fstr '      <DebugInformationFormat>ProgramDatabase</DebugInformationFormat>' endl];
        fstr = [fstr '      <CompileAs>Default</CompileAs>' endl];
        fstr = [fstr '    </ClCompile>' endl];
        fstr = [fstr '    <Link>' endl];
        fstr = [fstr '      <AdditionalDependencies>clsapi.lib;odbc32.lib;odbccp32.lib;wsock32.lib;%(AdditionalDependencies)</AdditionalDependencies>' endl];
        fstr = [fstr '      <OutputFile>' strBackup BinFolder filesep strModel '.dll</OutputFile>' endl];
        fstr = [fstr '      <AdditionalLibraryDirectories>$(RTCF_HOME)/bin;%(AdditionalLibraryDirectories)</AdditionalLibraryDirectories>' endl];
        fstr = [fstr '      <IgnoreSpecificDefaultLibraries>libc.lib;libcmt.lib;msvcrt.lib;libcd.lib;libcmtd.lib;%(IgnoreSpecificDefaultLibraries)</IgnoreSpecificDefaultLibraries>' endl];
        fstr = [fstr '      <GenerateDebugInformation>' bool2str(GenerateDebugInformation, 'true', 'false') '</GenerateDebugInformation>' endl];
        fstr = [fstr '      <ProgramDatabaseFile>.\Debug/' strModel '.pdb</ProgramDatabaseFile>' endl];
        fstr = [fstr '      <GenerateMapFile>true</GenerateMapFile>' endl];
        fstr = [fstr '      <MapFileName>.\Debug/' strModel '.map</MapFileName>' endl];
        fstr = [fstr '      <ImportLibrary>' strModel '.lib</ImportLibrary>' endl];
        fstr = [fstr '      <TargetMachine>MachineX86</TargetMachine>' endl];
        fstr = [fstr '    </Link>' endl];
        fstr = [fstr '  </ItemDefinitionGroup>' endl];
        fstr = [fstr '  <ItemDefinitionGroup Condition="''$(Configuration)|$(Platform)''==''Release|Win32''">' endl];
        fstr = [fstr '    <ClCompile>' endl];
        fstr = [fstr '      <PreprocessorDefinitions>WIN32;NDEBUG;_LIB;%(PreprocessorDefinitions)</PreprocessorDefinitions>' endl];
        fstr = [fstr '      <RuntimeLibrary>MultiThreadedDLL</RuntimeLibrary>' endl];
        fstr = [fstr '      <PrecompiledHeader>' endl];
        fstr = [fstr '      </PrecompiledHeader>' endl];
        fstr = [fstr '      <WarningLevel>Level3</WarningLevel>' endl];
        fstr = [fstr '      <DebugInformationFormat>ProgramDatabase</DebugInformationFormat>' endl];
        fstr = [fstr '    </ClCompile>' endl];
        fstr = [fstr '  </ItemDefinitionGroup>' endl];
        fstr = [fstr '  <ItemGroup>' endl];
        
        % Add .c/.cpp Shared Utils
        for i = 1:size(lstIncludes, 1)
            curInclude = lstIncludes{i,:};
            curInclude = strrep(curInclude, [RootCodeFolder filesep], '');
            if(isempty(strfind(curInclude, '.h')))
                fstr = [fstr '    <ClCompile Include="' strBackup curInclude '" />' endl];
            end
        end
        
        lstIncludes_cpp = dir([SaveFolder filesep '*.cpp']);
        for i = 1:size(lstIncludes_cpp, 1)
            curInclude = lstIncludes_cpp(i).name;
            fstr = [fstr '    <ClCompile Include="' curInclude '" />' endl];
        end
        fstr = [fstr '  </ItemGroup>' endl];
        fstr = [fstr '  <ItemGroup>' endl];
        
        % Add .h
        for i = 1:size(lstIncludes, 1)
            curInclude = lstIncludes{i,:};
            curInclude = strrep(curInclude, [RootCodeFolder filesep], '');
            if(~isempty(strfind(curInclude, '.h')))
                fstr = [fstr '    <ClInclude Include="' strBackup curInclude '" />' endl];
            end
        end
        
        lstIncludes2 = dir([SaveFolder filesep '*.h']);
        for i = 1:size(lstIncludes2, 1)
            curInclude = lstIncludes2(i).name;
            fstr = [fstr '    <ClInclude Include="' curInclude '" />' endl];
        end
        
        fstr = [fstr '  </ItemGroup>' endl];
        fstr = [fstr '  <Import Project="$(VCTargetsPath)\Microsoft.Cpp.targets" />' endl];
        fstr = [fstr '  <ImportGroup Label="ExtensionTargets">' endl];
        fstr = [fstr '  </ImportGroup>' endl];
        fstr = [fstr '</Project>' endl];
        
    case '2008'
        
        ProjectGUID = randstr('{75EMNZ89-6KYM-237O-7Z9N-9103P5X5457A}');
        
        %%
        filename= [strModel '.vcproj'];
        fstr = '';
        fstr = [fstr '<?xml version="1.0" encoding="Windows-1252"?>' endl];
        fstr = [fstr '<VisualStudioProject' endl];
        fstr = [fstr '	ProjectType="Visual C++"' endl];
        fstr = [fstr '	Version="9.00"' endl];
        fstr = [fstr '	Name="' strModel '"' endl];
        fstr = [fstr '	ProjectGUID="' ProjectGUID '"' endl];
        fstr = [fstr '	RootNamespace="' strModel '"' endl];
        fstr = [fstr '	Keyword="Win32Proj"' endl];
        fstr = [fstr '	TargetFrameworkVersion="131072"' endl];
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
        fstr = [fstr '			OutputDirectory=".\Debug"' endl];
        fstr = [fstr '			IntermediateDirectory=".\Debug"' endl];
        fstr = [fstr '			ConfigurationType="2"' endl];
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
        
        fstr = [fstr '				AdditionalIncludeDirectories="&quot;$(RTCF_HOME)/' RTCFSourceFolder 'CLSAPI&quot;;'];
        numIncludeFolders = size(lstIncludeFolders, 1);
        for iIncludeFolder = 1:numIncludeFolders
            fstr = [fstr strBackup lstIncludeFolders{iIncludeFolder}];
            if(iIncludeFolder < numIncludeFolders)
                fstr = [fstr ';'];
            end
        end
        fstr = [fstr '"' endl];
        
        
        fstr = [fstr '				PreprocessorDefinitions="WIN32;_DEBUG;_CONSOLE"' endl];
        fstr = [fstr '				MinimalRebuild="true"' endl];
        fstr = [fstr '				BasicRuntimeChecks="3"' endl];
        fstr = [fstr '				RuntimeLibrary="3"' endl];
        fstr = [fstr '				TreatWChar_tAsBuiltInType="' bool2str(TreatWChar_tAsBuiltInType, 'true', 'false') '"' endl];
        fstr = [fstr '				ForceConformanceInForLoopScope="' bool2str(ForceConformanceInForLoopScope, 'true', 'false') '"' endl];
        fstr = [fstr '				RuntimeTypeInfo="' bool2str(RuntimeTypeInfo, 'true', 'false') '"' endl];
        fstr = [fstr '				UsePrecompiledHeader="0"' endl];
        fstr = [fstr '				AssemblerListingLocation=".\Debug/"' endl];
        fstr = [fstr '				ObjectFile=".\Debug/"' endl];
        fstr = [fstr '				ProgramDataBaseFileName=".\Debug/"' endl];
        fstr = [fstr '				BrowseInformation="1"' endl];
        fstr = [fstr '				BrowseInformationFile="$(IntDir)\"' endl];
        fstr = [fstr '				WarningLevel="3"' endl];
        fstr = [fstr '				Detect64BitPortabilityProblems="false"' endl];
        fstr = [fstr '				DebugInformationFormat="3"' endl];
        fstr = [fstr '				CompileAs="0"' endl];
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
        fstr = [fstr '				AdditionalDependencies="clsapi.lib odbc32.lib odbccp32.lib wsock32.lib"' endl];
        fstr = [fstr '				OutputFile="' strBackup BinFolder filesep strModel '.dll"' endl];
        fstr = [fstr '				LinkIncremental="1"' endl];
        fstr = [fstr '				AdditionalLibraryDirectories="&quot;$(RTCF_HOME)/bin&quot;"' endl];
        fstr = [fstr '				IgnoreDefaultLibraryNames="libc.lib;libcmt.lib;msvcrt.lib;libcd.lib;libcmtd.lib"' endl];
        fstr = [fstr '				GenerateDebugInformation="' bool2str(GenerateDebugInformation, 'true', 'false') '"' endl];
        fstr = [fstr '				ProgramDatabaseFile=".\Debug/' strModel '.pdb"' endl];
        fstr = [fstr '				GenerateMapFile="true"' endl];
        fstr = [fstr '				MapFileName=".\Debug/' strModel '.map"' endl];
        fstr = [fstr '				RandomizedBaseAddress="1"' endl];
        fstr = [fstr '				DataExecutionPrevention="0"' endl];
        fstr = [fstr '				ImportLibrary="' strModel '.lib"' endl];
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
        fstr = [fstr '				Name="VCPostBuildEventTool"' endl];
        fstr = [fstr '			/>' endl];
        fstr = [fstr '		</Configuration>' endl];
        fstr = [fstr '		<Configuration' endl];
        fstr = [fstr '			Name="Release|Win32"' endl];
        fstr = [fstr '			OutputDirectory="$(SolutionDir)$(ConfigurationName)"' endl];
        fstr = [fstr '			IntermediateDirectory="$(ConfigurationName)"' endl];
        fstr = [fstr '			ConfigurationType="4"' endl];
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
        fstr = [fstr '				PreprocessorDefinitions="WIN32;NDEBUG;_LIB"' endl];
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
        fstr = [fstr '				Name="VCLibrarianTool"' endl];
        fstr = [fstr '			/>' endl];
        fstr = [fstr '			<Tool' endl];
        fstr = [fstr '				Name="VCALinkTool"' endl];
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
        
        UniqueIdentifier = randstr('"{8DM236E2-F1I8-4419-K863-8U48X435X7JT}"');
        
        fstr = [fstr '			UniqueIdentifier=' UniqueIdentifier endl];
        fstr = [fstr '			>' endl];
        
        for i = 1:size(lstIncludes, 1)
            curInclude = lstIncludes{i,:};
            curInclude = strrep(curInclude, [RootCodeFolder filesep], '');
            if(isempty(strfind(curInclude, '.h')))
                fstr = [fstr '			<File' endl];
                fstr = [fstr '				RelativePath="' strBackup curInclude '"' endl];
                fstr = [fstr '				>' endl];
                fstr = [fstr '			</File>' endl];
            end
        end
        
        lstIncludes2 = dir([SaveFolder filesep '*.cpp']);
        for i = 1:size(lstIncludes2, 1)
            curInclude = lstIncludes2(i).name;
            fstr = [fstr '			<File' endl];
            fstr = [fstr '				RelativePath=".\' curInclude '"' endl];
            fstr = [fstr '				>' endl];
            fstr = [fstr '			</File>' endl];
        end
        
        fstr = [fstr '		</Filter>' endl];
        fstr = [fstr '		<Filter' endl];
        fstr = [fstr '			Name="Header Files"' endl];
        fstr = [fstr '			Filter="h;hpp;hxx;hm;inl;inc;xsd"' endl];
        
        UniqueIdentifier = randstr('"{95530104-09QA-0f41-07JU-440BCP28WZMF}"');
        
        fstr = [fstr '			UniqueIdentifier=' UniqueIdentifier endl];
        fstr = [fstr '			>' endl];
        
        for i = 1:size(lstIncludes, 1)
            curInclude = lstIncludes{i,:};
            curInclude = strrep(curInclude, [RootCodeFolder filesep], '');
            if(~isempty(strfind(curInclude, '.h')))
                fstr = [fstr '			<File' endl];
                fstr = [fstr '				RelativePath="' strBackup curInclude '"' endl];
                fstr = [fstr '				>' endl];
                fstr = [fstr '			</File>' endl];
            end
        end
        
        lstIncludes2 = dir([SaveFolder filesep '*.h']);
        for i = 1:size(lstIncludes2, 1)
            curInclude = lstIncludes2(i).name;
            fstr = [fstr '			<File' endl];
            fstr = [fstr '				RelativePath=".\' curInclude '"' endl];
            fstr = [fstr '				>' endl];
            fstr = [fstr '			</File>' endl];
        end
        
        fstr = [fstr '		</Filter>' endl];
        fstr = [fstr '		<Filter' endl];
        fstr = [fstr '			Name="Resource Files"' endl];
        fstr = [fstr '			Filter="rc;ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe;resx;tiff;tif;png;wav"' endl];
        
        UniqueIdentifier = randstr('"{25TJ4QX1-S548-3e66-3U9Z-12AP148OJF49}"');
        
        fstr = [fstr '			UniqueIdentifier=' UniqueIdentifier endl];
        fstr = [fstr '			>' endl];
        fstr = [fstr '		</Filter>' endl];
        fstr = [fstr '	</Files>' endl];
        fstr = [fstr '	<Globals>' endl];
        fstr = [fstr '	</Globals>' endl];
        fstr = [fstr '</VisualStudioProject>' endl];
        
    case '2005'
        
        
        ProjectGUID = randstr('{72FCCC43-5AAA-417D-9B6A-0130B2E2869B}');
        
        %%
        filename= [strModel '.vcproj'];
        fstr = '';
        fstr = [fstr '<?xml version="1.0" encoding="Windows-1252"?>' endl];
        fstr = [fstr '<VisualStudioProject' endl];
        fstr = [fstr '	ProjectType="Visual C++"' endl];
        fstr = [fstr '	Version="8.00"' endl];
        fstr = [fstr '	Name="' strModel '"' endl];
        fstr = [fstr '	ProjectGUID="' ProjectGUID '"' endl];
        fstr = [fstr '	RootNamespace="' strModel '"' endl];
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
        fstr = [fstr '			OutputDirectory=".\Debug"' endl];
        fstr = [fstr '			IntermediateDirectory=".\Debug"' endl];
        fstr = [fstr '			ConfigurationType="2"' endl];
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
        
        % lstSharedUtilsFull = dir_list({'*.cpp';'*.h';'*.c'}, 1, 'Root', fldrAutoShareUtils);
        
        fstr = [fstr '				AdditionalIncludeDirectories="&quot;$(RTCF_HOME)/' RTCFSourceFolder 'CLSAPI&quot;;'];
        numIncludeFolders = size(lstIncludeFolders, 1);
        for iIncludeFolder = 1:numIncludeFolders
            fstr = [fstr strBackup lstIncludeFolders{iIncludeFolder}];
            if(iIncludeFolder < numIncludeFolders)
                fstr = [fstr ';'];
            end
        end
        fstr = [fstr '"' endl];
        
        fstr = [fstr '				PreprocessorDefinitions="WIN32;_DEBUG;_CONSOLE"' endl];
        fstr = [fstr '				MinimalRebuild="true"' endl];
        fstr = [fstr '				BasicRuntimeChecks="3"' endl];
        fstr = [fstr '				RuntimeLibrary="3"' endl];
        fstr = [fstr '				TreatWChar_tAsBuiltInType="' bool2str(TreatWChar_tAsBuiltInType, 'true', 'false') '"' endl];
        fstr = [fstr '				ForceConformanceInForLoopScope="' bool2str(ForceConformanceInForLoopScope, 'true', 'false') '"' endl];
        fstr = [fstr '				RuntimeTypeInfo="' bool2str(RuntimeTypeInfo, 'true', 'false') '"' endl];
        fstr = [fstr '				UsePrecompiledHeader="0"' endl];
        fstr = [fstr '				AssemblerListingLocation=".\Debug/"' endl];
        fstr = [fstr '				ObjectFile=".\Debug/"' endl];
        fstr = [fstr '				ProgramDataBaseFileName=".\Debug/"' endl];
        fstr = [fstr '				BrowseInformation="1"' endl];
        fstr = [fstr '				BrowseInformationFile="$(IntDir)\"' endl];
        fstr = [fstr '				WarningLevel="3"' endl];
        fstr = [fstr '				Detect64BitPortabilityProblems="false"' endl];
        fstr = [fstr '				DebugInformationFormat="3"' endl];
        fstr = [fstr '				CompileAs="0"' endl];
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
        fstr = [fstr '				AdditionalDependencies="clsapi.lib odbc32.lib odbccp32.lib wsock32.lib"' endl];
        
        fstr = [fstr '				OutputFile="' strBackup BinFolder filesep strModel '.dll"' endl];
        fstr = [fstr '				LinkIncremental="1"' endl];
        
        fstr = [fstr '				AdditionalLibraryDirectories="&quot;$(RTCF_HOME)/bin&quot;"' endl];
        fstr = [fstr '				IgnoreDefaultLibraryNames="libc.lib;libcmt.lib;msvcrt.lib;libcd.lib;libcmtd.lib"' endl];
        fstr = [fstr '				GenerateDebugInformation="' bool2str(GenerateDebugInformation, 'true', 'false') '"' endl];
        fstr = [fstr '				ProgramDatabaseFile=".\Debug/' strModel '.pdb"' endl];
        fstr = [fstr '				GenerateMapFile="true"' endl];
        fstr = [fstr '				MapFileName=".\Debug/' strModel '.map"' endl];
        fstr = [fstr '				ImportLibrary="' strModel '.lib"' endl];
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
        fstr = [fstr '			ConfigurationType="4"' endl];
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
        fstr = [fstr '				PreprocessorDefinitions="WIN32;NDEBUG;_LIB"' endl];
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
        fstr = [fstr '				Name="VCLibrarianTool"' endl];
        fstr = [fstr '			/>' endl];
        fstr = [fstr '			<Tool' endl];
        fstr = [fstr '				Name="VCALinkTool"' endl];
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
            curInclude = strrep(curInclude, [RootCodeFolder filesep], '');
            if(isempty(strfind(curInclude, '.h')))
                fstr = [fstr '			<File' endl];
                fstr = [fstr '				RelativePath="' strBackup curInclude '"' endl];
                fstr = [fstr '				>' endl];
                fstr = [fstr '			</File>' endl];
            end
        end
        
        lstIncludes2 = dir([SaveFolder filesep '*.cpp']);
        for i = 1:size(lstIncludes2, 1)
            curInclude = lstIncludes2(i).name;
            fstr = [fstr '			<File' endl];
            fstr = [fstr '				RelativePath=".\' curInclude '"' endl];
            fstr = [fstr '				>' endl];
            fstr = [fstr '			</File>' endl];
        end
        
        fstr = [fstr '		</Filter>' endl];
        fstr = [fstr '		<Filter' endl];
        fstr = [fstr '			Name="Header Files"' endl];
        fstr = [fstr '			Filter="h;hpp;hxx;hm;inl;inc;xsd"' endl];
        
        UniqueIdentifier = randstr('"{93995380-89BD-4b04-88EB-625FBE52EBFB}"');
        
        fstr = [fstr '			UniqueIdentifier=' UniqueIdentifier endl];
        fstr = [fstr '			>' endl];
        
        for i = 1:size(lstIncludes, 1)
            curInclude = lstIncludes{i,:};
            curInclude = strrep(curInclude, [RootCodeFolder filesep], '');
            if(~isempty(strfind(curInclude, '.h')))
                fstr = [fstr '			<File' endl];
                fstr = [fstr '				RelativePath="' strBackup curInclude '"' endl];
                fstr = [fstr '				>' endl];
                fstr = [fstr '			</File>' endl];
            end
        end
        
        lstIncludes2 = dir([SaveFolder filesep '*.h']);
        for i = 1:size(lstIncludes2, 1)
            curInclude = lstIncludes2(i).name;
            fstr = [fstr '			<File' endl];
            fstr = [fstr '				RelativePath=".\' curInclude '"' endl];
            fstr = [fstr '				>' endl];
            fstr = [fstr '			</File>' endl];
        end
        
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
        
    otherwise
        
end

%%
% Write header
info.fname = filename;

info.fname_full = [SaveFolder filesep info.fname];
info.text = fstr;
fileattrib(SaveFolder, '+w', '', 's');
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

filename = info.fname_full;

%% Write the .sln
if(1)
    
    switch VS_ver
        
        case '2010'
            Project = randstr('"{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}"');
            
            fstr = '';
            fstr = [fstr 'Microsoft Visual Studio Solution File, Format Version 11.00' endl];
            fstr = [fstr '# Visual Studio 2010' endl];
            fstr = [fstr 'Project("' Project '") = "' strModel '", "' strModel '.vcxproj", "' ProjectGUID '"' endl];
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
            
        case '2008'
            Project = randstr('"{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}"');
            fstr = '';
            fstr = [fstr 'Microsoft Visual Studio Solution File, Format Version 10.00' endl];
            fstr = [fstr '# Visual Studio 2008' endl];
            fstr = [fstr 'Project(' Project ') = "' strModel '", "' strModel '.vcproj", "' ProjectGUID '"' endl];
            fstr = [fstr 'EndProject' endl];
            fstr = [fstr 'Global' endl];
            fstr = [fstr '	GlobalSection(SolutionConfigurationPlatforms) = preSolution' endl];
            fstr = [fstr '		Debug|Win32 = Debug|Win32' endl];
            fstr = [fstr '		Release|Win32 = Release|Win32' endl];
            fstr = [fstr '	EndGlobalSection' endl];
            fstr = [fstr '	GlobalSection(ProjectConfigurationPlatforms) = postSolution' endl];
            fstr = [fstr '		' ProjectGUID '.Debug|Win32.ActiveCfg = Debug|Win32' endl];
            fstr = [fstr '		' ProjectGUID '.Release|Win32.ActiveCfg = Release|Win32' endl];
            fstr = [fstr '	EndGlobalSection' endl];
            fstr = [fstr '	GlobalSection(SolutionProperties) = preSolution' endl];
            fstr = [fstr '		HideSolutionNode = FALSE' endl];
            fstr = [fstr '	EndGlobalSection' endl];
            fstr = [fstr 'EndGlobal' endl];
            
            
        case '2005'
            Project = randstr('"{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}"');
            fstr = '';
            fstr = [fstr 'Microsoft Visual Studio Solution File, Format Version 9.00' endl];
            fstr = [fstr '# Visual Studio 2005' endl];
            fstr = [fstr 'Project(' Project ') = "' strModel '", "' strModel '.vcproj", "' ProjectGUID '"' endl];
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
            
        otherwise
    end
    
    %%
    % Write header
    info.fname = [strModel '.sln'];
    
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
    
    filename = info.fname_full;
end

%% Write the .bat file
if(1)
    
    info.fname = [strModel '_BLD.bat'];
    fstr = '';
    fstr = [fstr '@echo off' endl];
    fstr = [fstr endl];
    fstr = [fstr 'set MODEL_NAME=' strModel endl];
    switch VS_ver
        case '2010'
            fstr = [fstr 'set EXT=vcxproj' endl];
            fstr = [fstr 'set VS_Ver=2010' endl];
            fstr = [fstr 'set VS_EXE_DIR=%VS100COMNTOOLS%..\ide' endl];
        case '2008'
            fstr = [fstr 'set EXT=vcproj' endl];
            fstr = [fstr 'set VS_Ver=2008' endl];
            fstr = [fstr 'set VS_EXE_DIR=%VS90COMNTOOLS%..\ide' endl];           
        case '2005'
            fstr = [fstr 'set EXT=vcproj' endl];
            fstr = [fstr 'set VS_Ver=2005' endl];
            fstr = [fstr 'set VS_EXE_DIR=%VS80COMNTOOLS%..\ide' endl];
        otherwise
    end
    fstr = [fstr 'set RTCF_HOME=' RTCF_HOME endl];
    fstr = [fstr endl];
    fstr = [fstr 'set PRJ=%MODEL_NAME%.%EXT%' endl];
    fstr = [fstr 'echo **********************************************************************************' endl];
    fstr = [fstr 'echo * This script automatically sets local environment variables required to build:' endl];
    fstr = [fstr 'echo *    %PRJ% ' endl];
    fstr = [fstr 'echo * from Visual Studio %VS_Ver% with the correct RTCF source code.' endl];
    fstr = [fstr 'echo **********************************************************************************' endl];
    fstr = [fstr  endl];
    fstr = [fstr 'set VS_EXE=devenv.exe' endl];
    fstr = [fstr 'set SLN_DIR=%cd%' endl];
    fstr = [fstr  endl];
    fstr = [fstr 'echo RTCF_HOME=%RTCF_HOME%' endl];
    fstr = [fstr 'echo Launch %SLN_DIR%\%SLN% ' endl];
    fstr = [fstr 'echo Using  %VS_EXE_DIR%' endl];
    fstr = [fstr endl];
    fstr = [fstr 'cd %VS_EXE_DIR%' endl];
    fstr = [fstr 'set VS_EXE_DIR=%cd%' endl];
    fstr = [fstr endl];
    fstr = [fstr 'echo Right click on %MODEL_NAME% and select "Rebuild"' endl];
    fstr = [fstr 'cd "%SLN_DIR%"' endl];
    fstr = [fstr '"%VS_EXE_DIR%/%VS_EXE%" "%PRJ%"' endl];
    
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
    
    filename = info.fname_full;
end

end % << End of function Write_RTCF_vcproj >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 110602 MWS: Created function using CreateNewFunc
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
