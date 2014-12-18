% RTDR_INFO Compiles List of Information Related to RTCF .rtdr files
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% RTDR_Info:
%     Compiles information related to RTCF .rtdr files which contain
%     desired connection points for (CPs) data recorders.  Function returns
%     the number of desired CPs in each file, the number of data recorders
%     needed for each set of CPs, and the number of leftover spots in each
%     set's final data recorder.
% 
% SYNTAX:
%	[lstInfo, lstCPs] = RTDR_Info(lstRTDRs, varargin, 'PropertyName', PropertyValue)
%	[lstInfo, lstCPs] = RTDR_Info(lstRTDRs, varargin)
%	[lstInfo, lstCPs] = RTDR_Info(lstRTDRs)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	lstRTDRs	'string'    [char]      If file, this is the RTDR file to 
%                                        interrogate.  If it's a directory,
%                 -or-                   will perform 'dir_list(*.rtdr)' to
%                                        find all RTDRs to interrogate.
%              {'string'}  {[char]}     Cell array containing RTDR files to
%                                        interrogate
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
% OUTPUTS: 
%	Name            Size        Units	Description
%	lstInfo         {N x 5}     N/A     Displayable Information List
%	lstCPs          {1 x N}     N/A     Full Info on 'N' RTDR files
%    .Filename      'string'    [char]  Filename (full)
%    .numCPs        [1]         [int]   Number of CPs in File
%    .numRTDRs      [1]         [int]   Number of RTDRs required to record
%                                        CPs (using 'CPsPerRTDR')
%    .numLeftover   [1]         [int]   Number of spots leftover in final
%                                        RTDR file
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	'Comment'           'string'        '#'         How comments are
%                                                    specified in file
%   'CPsPerRTDR'        [int]           64          Maximum number of
%                                                    connection points per
%                                                    RTDR file
%
% EXAMPLES:
%	% Example #1: View Information on All RTDRs in a given directory
%   RTDR_Directory = <full path to directory>
%	[lstInfo, lstCPs] = RTDR_Info(RTDR_Directory);
%   disp(Cell2PaddedStr(lstInfo), 'Padding', '  ');
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit RTDR_Info.m">RTDR_Info.m</a>
%	  Driver script: <a href="matlab:edit Driver_RTDR_Info.m">Driver_RTDR_Info.m</a>
%	  Documentation: <a href="matlab:winopen(which('RTDR_Info_Function_Documentation.pptx'));">RTDR_Info_Function_Documentation.pptx</a>
%
% See also dir_list 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/812
%  
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/RTCFUtilities/RTDR_Info.m $
% $Rev: 3003 $
% $Date: 2013-08-26 15:12:16 -0500 (Mon, 26 Aug 2013) $
% $Author: sufanmi $

function [lstInfo, lstCPs] = RTDR_Info(lstRTDRs, varargin)

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
[strComment, varargin]          = format_varargin('Comment', '#', 2, varargin);
[CPsPerRTDR, varargin]          = format_varargin('CPsPerRTDR', 64, 2, varargin);
iComment = 1:length(strComment);

%% Main Function:
lstInfo = {};
lstCPs = {};

if(ischar(lstRTDRs))
    if(isdir(lstRTDRs))
        lstRTDRs = dir_list('*.rtdr', 1, 'Root', lstRTDRs);
    else
        lstRTDRs = { lstRTDRs };
    end
end

numFiles = size(lstRTDRs);

lstInfo(1,:) = {'#', 'Filename', '# CPs', '# RTDRs', '# Leftover'};
iInfoLine = size(lstInfo, 1);
totalCPs = 0;
totalRTDRs = 0;
totalLeftover = 0;

for iFile = 1:numFiles
    curFilename = lstRTDRs{iFile};
    lstCPs(iFile).Filename = curFilename;
    
    iInfoLine = iInfoLine + 1;
    lstInfo(iInfoLine,1) = {num2str(iFile)};
    lstInfo(iInfoLine,2) = {curFilename};
    
    %%
    fid = fopen(curFilename);
    iLine = 0;
    lstCP = {}; iCP = 0;
    
    while 1
        curLine = fgetl(fid);
        if ~ischar(curLine)
            break
        end
        iLine = iLine + 1;
        flgEmpty = isempty(curLine);
        flgComment = 0;
        if(~flgEmpty)
            flgComment = strcmp(strComment, curLine(iComment));
        end
        flgCP = (~flgComment) && (~flgEmpty);
        
        if(flgCP)
            iCP = iCP + 1;
            lstCP(iCP,1) = { strtrim(curLine) };
        end
    end
    fclose(fid);

    numCPs = iCP;
    numRTDRs = ceil(numCPs / CPsPerRTDR);
    numLeftover = (numRTDRs*CPsPerRTDR) - numCPs;

    lstInfo(iInfoLine,3) = {sprintf('%6.0f', numCPs)};
    lstInfo(iInfoLine,4) = {sprintf('%3.0f', numRTDRs)};
    lstInfo(iInfoLine,5) = {sprintf('%3.0f', numLeftover)};

    lstCPs(iFile).numCPs = numCPs;
    lstCPs(iFile).numRTDRs = numRTDRs;
    lstCPs(iFile).numLeftover = numLeftover;
    lstCPs(iFile).lstCPs = lstCP;
    
    totalCPs = totalCPs + numCPs;
    totalRTDRs = totalRTDRs + numRTDRs;
    totalLeftover = totalLeftover + numLeftover;
    
end

    iInfoLine = iInfoLine + 1;
    lstInfo(iInfoLine,2) = {'Totals:'};
    lstInfo(iInfoLine,3) = {sprintf('%6.0f', totalCPs)};
    lstInfo(iInfoLine,4) = {sprintf('%3.0f', totalRTDRs)};
    lstInfo(iInfoLine,5) = {sprintf('%3.0f', totalLeftover)};
    

end % << End of function RTDR_Info >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 130826 <INI>: Created function using CreateNewFunc
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
