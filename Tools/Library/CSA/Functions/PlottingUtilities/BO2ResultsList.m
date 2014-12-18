% BO2RESULTSLIST compiles info for parsing data using 'ParseRecordedData2ts'
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BO2ResultsList:
%     If simulation data from a defined bus object is saved to the workspace
%   using 'ToMat' blocks, this function compiles the list needed for parsing
%   that data using 'ParseRecordedData2ts'
% 
% SYNTAX:
%	[lstResults] = BO2ResultsList(BusObj, BOInfo)
%
% INPUTS: 
%	Name      	Size		Units		Description
%   BusObj      [string]                Top Level Bus Object of Recorded Data
%   BOInfo      {struct}                Bus Object Information Structure
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%   lstResults  {cell}                  List of signals with dimensions and units
%       (:,1):              [string]    Signal Name
%       (:,2):              [int]       Dimensions
%       (:,3):              [string]    Units
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
% lstBO = {
%     'Alpha'   1   ''  '[deg]';
%     'Beta'    1   ''  '[deg]';
%     };
% BOInfo.BOBus1 = lstBO;
% BuildBusObject('BOBus1', lstBO); clear lstBO;
% 
% % Create Bus2:
% lstBO = {
%     'WOW'       1   'boolean' '[bool]';
%     'Pned'      3   'single'  '[m]';
%     };
% BOInfo.BOBus2 = lstBO;
% BuildBusObject('BOBus2', lstBO); clear lstBO;
% 
% % Create Bus3 which is a combo of Bus1 and Bus2
% lstBO = {
%     'Bus1'      1,  'BOBus1';
%     'Bus2'      1,  'BOBus2';
%     };
% BOInfo.BOBus3 = lstBO;
% BuildBusObject('BOBus3', lstBO); clear lstBO;
% 
% % Desired Output:
% % lstResults = { ...
% %     'Bus1.Alpha'    [1]    '[deg]';
% %     'Bus1.Beta'     [1]    '[deg]';
% %     'Bus2.WOW'      [1]    '[bool]';
% %     'Bus2.Pned'     [3]    '[m]';
% %     };
%
%	% <Enter Description of Example #1>
%	[lstResults] = BO2ResultsList(BusObj, BOInfo, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[lstResults] = BO2ResultsList(BusObj, BOInfo)
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
%	Source function: <a href="matlab:edit BO2ResultsList.m">BO2ResultsList.m</a>
%	  Driver script: <a href="matlab:edit Driver_BO2ResultsList.m">Driver_BO2ResultsList.m</a>
%	  Documentation: <a href="matlab:pptOpen('BO2ResultsList_Function_Documentation.pptx');">BO2ResultsList_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/477
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/BO2ResultsList.m $
% $Rev: 2346 $
% $Date: 2012-07-09 19:53:31 -0500 (Mon, 09 Jul 2012) $
% $Author: sufanmi $

function [lstResults] = BO2ResultsList(BusObj, BOInfo, varargin)

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
% lstResults= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

if(~isstr(BusObj))
    BusObj = inputname(1);
end

if((nargin == 1) || isempty(BOInfo) )
    BOInfo = evalin('base', 'BOInfo');
end

%% Main Function:
lstMasterBO = BusObject2List(BusObj);
numSignals = size(lstMasterBO, 1);

for iSignal = 1:numSignals;
    curSignal = lstMasterBO{iSignal, 1};
    curDim = lstMasterBO{iSignal, 2};
    curRefBO = lstMasterBO{iSignal, 4};
    
    ptrPeriod = max(strfind(curSignal, '.'));
    if(isempty(ptrPeriod))
        str2match = curSignal;
    else
        str2match = curSignal((ptrPeriod+1):end);
    end

    if(isfield(BOInfo, curRefBO))
        lstRefBO = BOInfo.(curRefBO);
    else
        lstRefBO = BusObject2List(curRefBO);
        lstRefBO(:, 4) = { '[unknown]' };
        
    end

    numRefBOSignals = size(lstRefBO, 1);
    
    for iRefBOSignal = 1:numRefBOSignals
        curRefBOSignal = lstRefBO{iRefBOSignal, 1};
        
        if(strcmp(curRefBOSignal, str2match))
            if(size(lstRefBO,2) > 3)
                curUnits = lstRefBO{iRefBOSignal, 4};
            else
                curUnits = '[unknown]';
            end
            break;
        end
    end
    lstResults(iSignal, 1) = { curSignal };
    lstResults(iSignal, 2) = { curDim };
    lstResults(iSignal, 3) = { curUnits };
end

%% Compile Outputs:
%	lstResults= -1;

end % << End of function BO2ResultsList >>

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
