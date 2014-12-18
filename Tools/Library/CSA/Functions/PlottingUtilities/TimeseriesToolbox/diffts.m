% DIFFTS Computes the difference between two time-series signals
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% diffts:
%     Computes the difference between two time-series signals
% 
% SYNTAX:
%	[lst_diffts, numDiffSet] = diffts(lst_ts, flgUseSimpleErrors, strOperation)
%	[lst_diffts, numDiffSet] = diffts(lst_ts, flgUseSimpleErrors)
%
% INPUTS: 
%	Name              	Size		Units	Description
%  lst_ts               {cell array}        Time-series signals to difference
%  flgUseSimpleErrors   [bool]              When differencing multiple
%                                            time-series signals
%                                           0:  Difference each signal vs all
%                                            other signals
%                                            {1}: Difference each signal vs the
%                                            first signal in the list
%	varargin	[N/A]		[varies]        Optional function inputs that
%                                            should be entered in pairs.
%                                            See the 'VARARGIN' section
%                                            below for more details
%
% OUTPUTS: 
%	Name              	Size		Units		Description
%	lst_diffts	        <size>		<units>		<Description>
%   numDiffSet
%
% NOTES:
%	Uses VSI_LIB function 'ErrorCombos'.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[lst_diffts] = diffts(lst_ts, flgUseSimpleErrors, strOperation, varargin)
%	% <Copy expected outputs from Command Window>
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit diffts.m">diffts.m</a>
%	  Driver script: <a href="matlab:edit Driver_diffts.m">Driver_diffts.m</a>
%	  Documentation: <a href="matlab:pptOpen('diffts_Function_Documentation.pptx');">diffts_Function_Documentation.pptx</a>
%
% See also ErrorCombos 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/480
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/diffts.m $
% $Rev: 3269 $
% $Date: 2014-10-14 20:37:58 -0500 (Tue, 14 Oct 2014) $
% $Author: sufanmi $

function [lst_diffts, numDiffSet] = diffts(lst_ts, flgUseSimpleErrors, strOperation)

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

%% Main Function:
if nargin < 3
    strOperation = '-';
end

if nargin < 2
    flgUseSimpleErrors = 1;
end

num_ts = size(lst_ts, 1);

if(num_ts == 1)
    lst_diffts = [];
else
    lstErrorCombos = ErrorCombos(num_ts, flgUseSimpleErrors);
    numErrorPlots = size(lstErrorCombos, 1);
    
    
    for iErrorData2Plot = 1 : numErrorPlots
        ptrData1 = lstErrorCombos(iErrorData2Plot, 1);
        ptrData2 = lstErrorCombos(iErrorData2Plot, 2);
        
        a = lst_ts{ptrData1, 1};
        b = lst_ts{ptrData2, 1};
        
        if(isempty(a) || isempty(b))
            c = [];
        else
        
            dimA = size(a.Data, 2);
            dimB = size(b.Data, 2);
            if(dimA ~= dimB)
                dimMin = min(dimA, dimB);
                a.Data = a.Data(:,[1:dimMin]);
                b.Data = b.Data(:,[1:dimMin]);
                disp(sprintf('%s : WARNING : Dimension Mismatch', mfnam));
                disp(sprintf('%s   ''%s'' is of size %d while ''%s'' is of size %d', ...
                    mfspc, a.Name, dimA, b.Name, dimB));
                disp(sprintf('%s   Using the minimum (%d)', mfspc, dimMin));
            end
            
            [ts1 ts2] = synchronize(a,b,'Union');
            
            switch strOperation
                case '-'
                    c = ts1 - ts2;
                case '+'
                    c = ts1 + ts2;
            end
            
            startTime = min(a.TimeInfo.Start, b.TimeInfo.Start);
            endTime = max(a.TimeInfo.End, b.TimeInfo.End);
            fullTime = unique([startTime c.Time' endTime]);
%             fullTime = union(a.Time, b.Time);
            
            msgID = 'interpolation:interpolation:noextrap';     % VERSION?!
            msgID = 'MATLAB:linearinter:noextrap';              % R2012b
            warning('off', msgID);

            c = resample(c, fullTime);
            warning('on', msgID);
            
            if(strmatch(a.Name, b.Name))
                c.Name = ['\Delta ' a.Name];
            else
                
                c.Name = [a.Name strOperation b.Name];
            end
            
            if((~isempty(a.DataInfo.UserData)) && (~isempty(b.DataInfo.UserData)))
                c.DataInfo.UserData = [a.DataInfo.UserData strOperation b.DataInfo.UserData];
            end
            
            c.DataInfo.Units = a.DataInfo.Units;
            lst_diffts{iErrorData2Plot,1} = c;
        end
    end
    
    if(numErrorPlots == 1)
        lst_diffts = c;
    end
    
end

numDiffSet = size(lst_diffts, 1);

end % << End of function diffts >>

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
