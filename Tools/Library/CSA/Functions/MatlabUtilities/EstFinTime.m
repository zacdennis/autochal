% ESTFINTIME Estimates the finishing time and date of an operation
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% EstFinTime:
% This function can estimate time and date of finishing an operation when 
% given the percent complete or the number completed and total number.  
%
% Inputs -StartClock: Output of {clock()||now()} at operation start
% 		 -OpVect: Vector [NumOpsCompleted TotNumOps] 
%			-0R-   a fraction 0<#<1 
%        -EndClock(Opt): Output of {clock()||now()} at iteration end
%           if ommited the current time is used
% Outputs -ETF: Estimated Time of Finishing in {datenum||datevec} 
%		  -T2F: Time Till Finished (datevec)
%		  -Fstr: Nicely Formated output string
% 
% SYNTAX:
%	[ETF, T2F, Fstr] = EstFinTime(StartClock, OpVect, EndClock, varargin, 'PropertyName', PropertyValue)
%	[ETF, T2F, Fstr] = EstFinTime(StartClock, OpVect, EndClock, varargin)
%	[ETF, T2F, Fstr] = EstFinTime(StartClock, OpVect, EndClock)
%	[ETF, T2F, Fstr] = EstFinTime(StartClock, OpVect)
%
% INPUTS: 
%	Name      	Size		Units		Description
%	StartClock	<size>		<units>		<Description>
%	OpVect	    <size>		<units>		<Description>
%	EndClock	  <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	ETF 	       <size>		<units>		<Description> 
%	T2F 	       <size>		<units>		<Description> 
%	Fstr	      <size>		<units>		<Description> 
%
% NOTES:
%	If no output variables are specified then Fstr is displayed 
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%
% Example:  [ETF,T2F,Fstr] = EstFinTime(StartClock,[3 30]); 
%              EstFinTime(now-1,0.01,now);
%
%	% <Enter Description of Example #1>
%	[ETF, T2F, Fstr] = EstFinTime(StartClock, OpVect, EndClock, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[ETF, T2F, Fstr] = EstFinTime(StartClock, OpVect, EndClock)
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
%	Source function: <a href="matlab:edit EstFinTime.m">EstFinTime.m</a>
%	  Driver script: <a href="matlab:edit Driver_EstFinTime.m">Driver_EstFinTime.m</a>
%	  Documentation: <a href="matlab:pptOpen('EstFinTime_Function_Documentation.pptx');">EstFinTime_Function_Documentation.pptx</a>
%
% See also datevec addtodate clock now UNIT_EstFinTime
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/65
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/EstFinTime.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [ETF, T2F, Fstr] = EstFinTime(StartClock, OpVect, EndClock, varargin)

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
% ETF= -1;
% T2F= -1;
% Fstr= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        EndClock= ''; OpVect= ''; StartClock= ''; 
%       case 1
%        EndClock= ''; OpVect= ''; 
%       case 2
%        EndClock= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(EndClock))
%		EndClock = -1;
%  end
wasdatenum = 0;
ETF = [];
T2F = [];
%Fstr = '';

switch nargin 
    case 2
        EndClock = clock;
    case 3
        if length(EndClock) == 1;
            EndClock = datevec(EndClock);
            wasdatenum = 1;
        end
    otherwise
        ErrorIdx = [mfnam ':InvalidNargin'];
        ErrorStr = 'Invalid number of input arguments!';
        error(ErrorIdx,ErrorStr);
end
% Check format of StartClock
if length(StartClock) == 1; % you passed it a datenum instead of a clock
    StartClock = datevec(StartClock);
end
% Convert operation count format to percent complete
if length(OpVect) == 2; %Input expressed in [CompletedOperations TotalOperations] 
	OpPer = OpVect(1)/OpVect(2);
else
	OpPer = OpVect; % was expressed in percentage complete
end;

%Note: 
%in a clock vector indexs mean
% 1 =yr, 2 = mo. 3=date, 4=hour, 5 = min, 6 = sec
%% Main Function:
%% Shortcut 0% complete
if OpPer == 0;
	Fstr = [' ** Task progress being monitored by "EstFinTime".' endl];
    ETFString = datestr(StartClock, 'yyyy-mmm-dd HH:MM:SS');
    Fstr = [Fstr ' ** Task Started at: ' ETFString '.  ' ];
    if length(OpVect) == 2;
        Fstr = [Fstr 'Tasks Remaining: ' num2str(OpVect(2))];
    else
        Fstr = [Fstr '  ' num2str(OpVect*100) '% Completed.'];
    end;
    if nargout == 0
        disp(Fstr);
    end
    return % exit funciton [null, null, Fstr] = 
end

%% Calculate Elapsed Time / Seconds Left
Telapsed = etime(EndClock,StartClock); %seconds
Tte = Telapsed/OpPer; %esitmate of total required number of seconds
Ttf = Tte-Telapsed;

%Test for Positive Ttf -> shows end time > start time
if Ttf < 0
    disp([mfnam '>>WARNING: End time is before start time! Continueing...']);
end

%% Get Completion Time
%begin Adding estimate secons onto start time
% calc seonds 
ETF    = StartClock;
ETF(6) = StartClock(6)+Tte; % Produces correct time but all in seconds
%have to go through the datenum because teh seconds are too large for datevec
ETF    = datevec(datenum(ETF)); %now convert back to datevec
% Get String Version
ETFString = datestr(ETF,31);

%% Calc Time Remain in Days

T2F(5) = floor(Ttf / 60); %how many min?
T2F(6) = rem(Ttf,60); %how many seconds areleft? 
T2F(6) = round(T2F(6)*10)/10; % round off to tenths of seconds
T2F(4) = floor(T2F(5) / 60); %how many hours
T2F(5) = rem(T2F(5),60); %Hos many minleft
T2F(3) = floor(T2F(4) / 24); % how many days?
T2F(4) = rem(T2F(4),24); %how many hours left?
T2F(2) = 0;
T2F(1) = 0;

% T2F(6) = Ttf;
% T2F    = datevec(datenum(T2F));
%Generate Output Strings

%% Format Output
if any(T2F(1:2)~=0)
% 	disp([mfilename '>> More then 1 month! Estimating days!']);
	T2Fdays = 365*T2F(1)+ 30.4*T2F(2) + T2F(3) ; %calculate in whole days (But you can't!)
%     T2F = [0 0 T2Fdays T2F(4) T2F(5) T2F(6)]; %TODO: Is this a good idea or just return the datevec?
	T2Fstr1= [' approx:  ' sprintf('%f4.1',(T2Fdays + T2F(4)/12))];
	T2Fstr2= [' days.']; %#ok<NBRAK>
    T2FString = [T2Fstr1 T2Fstr2];
else
	T2Fstr1= [num2str(T2F(3)) 'd '];
	T2Fstr2= datestr(datenum(T2F),13);
    T2FString = [T2Fstr1 T2Fstr2];
end;
Fstr = [' ** Estimated Finish Time: ' ETFString ' Time Remain: ' T2FString ];

%adjust output based on ops or percent 
if length(OpVect) == 2;
	Fstr = [Fstr '  Completed ' num2str(OpVect(1)) '  of '  num2str(OpVect(2)) '  Tasks.'];
else
	Fstr = [Fstr '  ' num2str(OpVect*100) '% Completed.'];
end;
%if input was datenum then output ETF in datenum format
if wasdatenum
    T2F = datenum(T2F);
end
% Autodisplay if no output arguments givin.  
if nargout == 0
    disp(Fstr);
end
%% Compile Outputs:
%	ETF= -1;
%	T2F= -1;
%	Fstr= -1;

end % << End of function EstFinTime >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101102 JPG: Copied over information from the old function.
% 101102 CNF: Function template created using CreateNewFunc
% 080608 TKV: Updated with features from EstFinTime2
% 070629 TKV: Added Shortcut for 0% complete and updated output string
% 070620 TKV: Cleaned Comments and Format of Function
% 070620 TKV: Simplified Date output using Datestr with custom format
% 070620 TKV: Improved method of adding days using addtodate
% 070403 TKV: Appeded %complete and task note to output string
%Revision 2:	Added Fstr output and reflected previous narout==0 behavior
%					in the help.  
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% TKV: Travis Vetter        :  travis.vetter@ngc.com:  vettetr

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
