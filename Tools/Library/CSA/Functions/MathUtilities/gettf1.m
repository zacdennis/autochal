% GETTF1 obtains a transfer function from data
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% gettf1:
%     <Function Description> 
%
% 'gettf1' obtains a transfer function 
% from a time sequence and regressor
% g --> Estimated continuous transfer function Output/Input (y/u)
% g --> Estimated discrete transfer function Output/Input (y/u)
% regmax --> Best regressor when used with optimization (i.e. flag=1)
% u --> Input sequence
% y --> Output sequence
% nn --> Regressor [na nb nk]
% tt --> Time sequence
% flag --> (0 to just use the given regressor, and 1 to search for 
%           the optimum regressor using the given one as the upper bound)
%
% *************************************************************************
% * #NOTE: To future COSMO'er, this warning appeared using CreateNewFunc
% * CreateNewFunc>>WARNING: Selected Input argument name: "flag" is a 
% * function name!
% * -JPG
% *************************************************************************
% SYNTAX:
%	[g, gd, regmax] = gettf1(u, y, nn, tt, flag)
%	[g, gd, regmax] = gettf1(u, y, nn, tt)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	u   	       <size>		<units>		<Description>
%	y   	       <size>		<units>		<Description>
%	nn  	      <size>		<units>		<Description>
%	tt  	      <size>		<units>		<Description>
%	flag	    <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	g   	       <size>		<units>		<Description> 
%	gd  	      <size>		<units>		<Description> 
%	regmax	  <size>		<units>		<Description> 
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
%	[g, gd, regmax] = gettf1(u, y, nn, tt, flag, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[g, gd, regmax] = gettf1(u, y, nn, tt, flag)
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
%	Source function: <a href="matlab:edit gettf1.m">gettf1.m</a>
%	  Driver script: <a href="matlab:edit Driver_gettf1.m">Driver_gettf1.m</a>
%	  Documentation: <a href="matlab:pptOpen('gettf1_Function_Documentation.pptx');">gettf1_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/63
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/gettf1.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [g, gd, regmax] = gettf1(u, y, nn, tt, flag)

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
g= -1;
gd= -1;
regmax= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        flag= ''; tt= ''; nn= ''; y= ''; u= ''; 
%       case 1
%        flag= ''; tt= ''; nn= ''; y= ''; 
%       case 2
%        flag= ''; tt= ''; nn= ''; 
%       case 3
%        flag= ''; tt= ''; 
%       case 4
%        flag= ''; 
%       case 5
%        
%       case 6
%        
%  end
%
%  if(isempty(flag))
%		flag = -1;
%  end
%% Main Function:
u=u';
y=y';
ts=tt(6)-tt(5);
NN=nn;

if flag==1,
   val=[];
   regr=[];
   
   for NA=1:nn(1),
      for NB=1:nn(2),
         for NK=-3:nn(3),
   
 na=NA;nb=NB;nk=NK;  
   
   j=0;
   a=[];
   b=[];
   













for i=10+(nk-1):length(u)-(na+(nk-1))-10,
   j=j+1;
   a(j,1:na)=y(i:i+na-1);
   a(j,na+1:na+nb)=u(i+na-nk-nb+1:i+na-nk);
   b(j,1)=y(i+na);
   
end

x=a\b;
xy=x(na:-1:1);
xu=x(na+nb:-1:na+1);
xy1=zeros(1,nk-1);

gdd=tf([xu'],[1 -xy' xy1 ],ts);
gg=d2c(gdd,'tustin');
gg=minreal(gg);

[yc,t,x]=lsim(gg,u,tt);

err=yc'-y;
ems=sqrt(err*err');
val=[val;1/(ems+eps)];
regr=[regr;NA NB NK];



end
end
end
maxval=max(val);
imaxval=find(val==maxval);
NN=regr(imaxval,:);







end %end if



a=[];
b=[];

if isempty(NN)==0,
   
na=NN(1);
nb=NN(2);
nk=NN(3);
   j=0;















for i=10+(nk-1):length(u)-(na+(nk-1))-10,
   j=j+1;
   a(j,1:na)=y(i:i+na-1);
   a(j,na+1:na+nb)=u(i+na-nk-nb+1:i+na-nk);
   b(j,1)=y(i+na);
   
end

x=a\b;
xy=x(na:-1:1);
xu=x(na+nb:-1:na+1);
xy1=zeros(1,nk-1);

gdd=tf([xu'],[1 -xy' xy1 ],ts);
gg=d2c(gdd,'tustin');
gg=minreal(gg);

[yc,t,x]=lsim(gg,u,tt);
plot(tt,y,tt,yc,'r')

err=yc'-y;
ems=sqrt(err*err');
val=1/(ems+eps)
gd=gdd;
g=gg;
regmax=NN;
else
  
   g=[];
   gd=[];
   regmax=[];
end

%% Compile Outputs:
%	g= -1;
%	gd= -1;
%	regmax= -1;

end % << End of function gettf1 >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
% 000816 YZ : Function Created
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% YZ : Y. Zeyada

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
