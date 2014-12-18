% ERRORCOMBOS given N signals, computes all the different 2-signal combos
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ErrorCombos:
%   Given N number of signals, computes all the different 2-signal
%   combinations
% 
% SYNTAX:
%	[lstErrorCombos] = ErrorCombos(numSignals, flgSimple)
%	[lstErrorCombos] = ErrorCombos(numSignals)
%
% INPUTS: 
%	Name          	Size		Units           Description
%   numSignals      [1]         [int]           Number of Signals
%   flgSimple       [1]         {1/[0]:         Base combinations
%                               true/[false]}   ONLY on the 1st signal
%
% OUTPUTS: 
%	Name          	Size		Units           Description
%   lstErrorCombos  [M x 2]     [int]           Combinations of Signals
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
%  EX:
%   lstErrorCombos = ErrorCombos(3)
%   lstErrorCombos =
%           1     2
%           1     3
%           2     3
%
%   lstErrorCombos = ErrorCombos(3, 1)
%   lstErrorCombos =
%           1     2
%           1     3
%
%	% <Enter Description of Example #1>
%	[lstErrorCombos] = ErrorCombos(numSignals, flgSimple, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[lstErrorCombos] = ErrorCombos(numSignals, flgSimple)
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
%	Source function: <a href="matlab:edit ErrorCombos.m">ErrorCombos.m</a>
%	  Driver script: <a href="matlab:edit Driver_ErrorCombos.m">Driver_ErrorCombos.m</a>
%	  Documentation: <a href="matlab:pptOpen('ErrorCombos_Function_Documentation.pptx');">ErrorCombos_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/411
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/ErrorCombos.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [lstErrorCombos] = ErrorCombos(numSignals, flgSimple)

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
if(nargin < 2)
    flgSimple = 0;
end

%% Main Function:
if(numSignals <= 1)
    disp([mfilename ' : ERROR : Input ''numSignals'' of ''' ...
        num2str(numSignals) ''' must be an integer greater than 1']);
    lstErrorCombos = [];
else

    numSignals = floor(numSignals);

    iCtr = 0;

    for iSignal1 = 1:(numSignals-1)
        for iSignal2 = (iSignal1+1):numSignals
            iCtr = iCtr + 1;
            lstErrorCombos(iCtr,:) = [iSignal1 iSignal2];
        end

        if(flgSimple)
            break;
        end
    end
end
%% Compile Outputs:
%	lstErrorCombos= -1;

end % << End of function ErrorCombos >>

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
