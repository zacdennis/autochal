% ND_DATA_2_TBL Converts 2 to 4-D tables in simple 2-D table for Excel
% export
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% nD_Data_2_tbl:
%     Generates formatted Excel 2-D table based on 2 to 4-D tabls
%
% SYNTAX:
%	[Tbl] = nD_Data_2_tbl(nD_Data, lstIV, strDV)
%
% INPUTS:
%	Name    	Size		Units		Description
%	nD_Data	    <size>		<units>		<Description>
%	lstIV	   <size>		<units>		<Description>
%	strDV	   <size>		<units>		<Description>
%	TblDim	  <size>		<units>		<Description>
%
%
% OUTPUTS:
%	Name    	Size		Units		Description
%	Tbl	 <size>		<units>		<Description>
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[Tbl] = nD_Data_2_tbl(nD_Data, lstIV, strDV, TblDim, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Tbl] = nD_Data_2_tbl(nD_Data, lstIV, strDV, TblDim)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit nD_Data_2_tbl.m">nD_Data_2_tbl.m</a>
%	  Driver script: <a href="matlab:edit Driver_nD_Data_2_tbl.m">Driver_nD_Data_2_tbl.m</a>
%	  Documentation: <a href="matlab:pptOpen('nD_Data_2_tbl_Function_Documentation.pptx');">nD_Data_2_tbl_Function_Documentation.pptx</a>
%
% See also <add relevant functions>
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/674
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): nD_Dataspace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/nD_Data_2_tbl.m $
% $Rev: 2380 $
% $Date: 2012-07-18 20:26:58 -0500 (Wed, 18 Jul 2012) $
% $Author: sufanmi $

function [Tbl] = nD_Data_2_tbl(nD_Data, lstIV, strDV, varargin)

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
% Tbl= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        TblDim= ''; strDV= ''; lstIV= ''; nD_Data= '';
%       case 1
%        TblDim= ''; strDV= ''; lstIV= '';
%       case 2
%        TblDim= ''; strDV= '';
%       case 3
%        TblDim= '';
%       case 4
%
%       case 5
%
%  end
%
%  if(isempty(TblDim))
%		TblDim = -1;
%  end
%  end

if(isstr(strDV))
    lstDV = { strDV };
else
    lstDV = strDV;
end

numIDV = size(lstIV, 1);
numDV = size(lstDV, 1);

nPts = 1;

strTitle = '(';
for iDV = 1:numDV
    strTitle = sprintf('%s %s %s', strTitle, lstDV{iDV,2}, lstDV{iDV,3});
    
    if(iDV < numDV)
        strTitle = sprintf('%s, ', strTitle);
    else
        strTitle = sprintf('%s) = fcn(', strTitle);
    end
end

for iIDV = 1:numIDV
    eval(sprintf('strIV%do = lstIV{%d, 1};', iIDV, iIDV));
    eval(sprintf('strIV%dn = lstIV{%d, 2};', iIDV, iIDV));
    eval(sprintf('unitsIV%d = lstIV{%d, 3};', iIDV, iIDV));
    eval(sprintf('arrIV%d = nD_Data.(strIV%do);', iIDV, iIDV));
    eval(sprintf('nIV%d = length(arrIV%d);', iIDV, iIDV));
    eval(sprintf('nPts = nPts * nIV%d;', iIDV));
    
    strTitle = sprintf('%s%s %s', strTitle, lstIV{iIDV, 2}, lstIV{iIDV, 3});
    
    if(iIDV == numIDV)
        strTitle = sprintf('%s)', strTitle);
    else
        strTitle = sprintf('%s, ', strTitle);        
    end
end

iRow = 0;
iRow = iRow + 1;
Tbl(iRow,1) = { strTitle };
iRow = iRow + 1;
iRow = iRow + 1;

%% Header Section
% Independent Variables
for iIDV = 1:numIDV
    Tbl(iRow,iIDV) = { sprintf('%s %s', lstIV{iIDV, 2}, lstIV{iIDV, 3}) };
end

% Dependent Variables
for iDV = 1:numDV
    Tbl(iRow, numIDV+iDV) = { sprintf('%s %s', lstDV{iDV, 2}, lstDV{iDV, 3}) };
end

%%
switch numIDV
    case 1
        for iIV1 = 1:nIV1
            curIV1 = arrIV1(iIV1);
            
            iRow = iRow + 1;
            Tbl(iRow, 1) = { curIV1 };
            
            for iDV = 1:numDV
                curTbl = nD_Data.(lstDV{iDV,1});
                curDV = curTbl(iIV1);
                
                Tbl(iRow, numIDV + iDV) = { curDV };
            end
        end
        
    case 2
        for iIV1 = 1:nIV1
            curIV1 = arrIV1(iIV1);
            
            for iIV2 = 1:nIV2
                curIV2 = arrIV2(iIV2);
                
                iRow = iRow + 1;
                Tbl(iRow,1) = { curIV1 };
                Tbl(iRow,2) = { curIV2 };
                
                for iDV = 1:numDV
                    curTbl = nD_Data.(lstDV{iDV,1});
                    curDV = curTbl(iIV1, iIV2);
                    
                    Tbl(iRow, numIDV + iDV) = { curDV };
                end
            end
        end
        
    case 3
        for iIV1 = 1:nIV1
            curIV1 = arrIV1(iIV1);
            
            for iIV2 = 1:nIV2
                curIV2 = arrIV2(iIV2);
                
                for iIV3 = 1:nIV3
                    curIV3 = arrIV3(iIV3);
                    
                    iRow = iRow + 1;
                    Tbl(iRow,1) = { curIV1 };
                    Tbl(iRow,2) = { curIV2 };
                    Tbl(iRow,3) = { curIV3 };
                    
                    for iDV = 1:numDV
                        curTbl = nD_Data.(lstDV{iDV,1});
                        curDV = curTbl(iIV1, iIV2, iIV3);
                        
                        Tbl(iRow, numIDV + iDV) = { curDV };
                    end
                end
            end
        end
        
    case 4
        for iIV1 = 1:nIV1
            curIV1 = arrIV1(iIV1);
            
            for iIV2 = 1:nIV2
                curIV2 = arrIV2(iIV2);
                
                for iIV3 = 1:nIV3
                    curIV3 = arrIV3(iIV3);
                    
                    for iIV4 = 1:nIV4
                        curIV4 = arrIV4(iIV4);
                        
                        iRow = iRow + 1;
                        Tbl(iRow,1) = { curIV1 };
                        Tbl(iRow,2) = { curIV2 };
                        Tbl(iRow,3) = { curIV3 };
                        Tbl(iRow,4) = { curIV4 };
                        
                        for iDV = 1:numDV
                            curTbl = nD_Data.(lstDV{iDV,1});
                            curDV = curTbl(iIV1, iIV2, iIV3, iIV4);
                            
                            Tbl(iRow, numIDV + iDV) = { curDV };
                        end
                    end
                end
            end
        end
        
    case 5
        for iIV1 = 1:nIV1
            curIV1 = arrIV1(iIV1);
            
            for iIV2 = 1:nIV2
                curIV2 = arrIV2(iIV2);
                
                for iIV3 = 1:nIV3
                    curIV3 = arrIV3(iIV3);
                    
                    for iIV4 = 1:nIV4
                        curIV4 = arrIV4(iIV4);
                        
                        for iIV5 = 1:nIV5
                            curIV5 = arrIV5(iIV5);
                            
                            iRow = iRow + 1;
                            Tbl(iRow,1) = { curIV1 };
                            Tbl(iRow,2) = { curIV2 };
                            Tbl(iRow,3) = { curIV3 };
                            Tbl(iRow,4) = { curIV4 };
                            Tbl(iRow,5) = { curIV5 };
                            
                            for iDV = 1:numDV
                                curTbl = nD_Data.(lstDV{iDV,1});
                                curDV = curTbl(iIV1, iIV2, iIV3, iIV4, iIV5);
                                
                                Tbl(iRow, numIDV + iDV) = { curDV };
                            end
                        end
                    end
                end
            end
        end
        
    case 6
        for iIV1 = 1:nIV1
            curIV1 = arrIV1(iIV1);
            
            for iIV2 = 1:nIV2
                curIV2 = arrIV2(iIV2);
                
                for iIV3 = 1:nIV3
                    curIV3 = arrIV3(iIV3);
                    
                    for iIV4 = 1:nIV4
                        curIV4 = arrIV4(iIV4);
                        
                        for iIV5 = 1:nIV5
                            curIV5 = arrIV5(iIV5);
                            
                            for iIV6 = 1:nIV6
                                curIV6 = arrIV6(iIV6);
                                
                                iRow = iRow + 1;
                                Tbl(iRow,1) = { curIV1 };
                                Tbl(iRow,2) = { curIV2 };
                                Tbl(iRow,3) = { curIV3 };
                                Tbl(iRow,4) = { curIV4 };
                                Tbl(iRow,5) = { curIV5 };
                                Tbl(iRow,6) = { curIV6 };
                                
                                for iDV = 1:numDV
                                    curTbl = nD_Data.(lstDV{iDV,1});
                                    curDV = curTbl(iIV1, iIV2, iIV3, iIV4, iIV5, iIV6);
                                    
                                    Tbl(iRow, numIDV + iDV) = { curDV };
                                end
                            end
                        end
                    end
                end
            end
        end
end

%% Compile Outputs:
%	Tbl= -1;

end % << End of function nD_DataData_2_tbl >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 101007 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName            : Email     : NGGN Username
% <initials>: <Fullname>   : <email>   : <NGGN username>

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
