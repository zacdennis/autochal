% CONZAERO Creates ZAERO bulk data file that defines a control system for
% ASE analysis
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% conzaero:
%     conzaero(a,b,c,d,name,filename) creates the file filename which
%     contains the state-space matrices a,b,c,d written using bulk
%     data cards DMI and DMIL.
%      
%     conzaero(a,b,c,d,name,filename,sensors,actuat,csurf,idcon) creates
%     the file filename which contains full description of the control
%     system.
% 
% SYNTAX:
%	[outstr] = conzaero(a, b, c, d, name, filename, sensors, actuat, csurf, idcon, gforce)
%	[outstr] = conzaero(a, b, c, d, name, filename, sensors, actuat, csurf, idcon)
%	[outstr] = conzaero(a, b, c, d, name, filename)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	a   	    <size>		<units>		State matrix
%	b   	    <size>		<units>		Input matrix
%	c   	    <size>		<units>		Output matrix
%	d   	    <size>		<units>		Feedthrough (or feedforward) matrix
%	name	    String		<units>		Label of the DMI entry defining the
%                                       a,b,c,d.
%	filename	String		<units>		Name of the file to output the
%                                       control system
%	sensors     <size>		<units>		Matrix with the number of rows
%                                       equal to 3.  See notes for more
%                                       information.
%	actuat      <size>		<units>		Matrix with the number of rows
%                                       equal to the number of the outputs 
%                                       of the control system and number of
%                                       columns equal to 3.  See notes for
%                                       more details.
%	csurf       {cell}      <units>		contains the labels of the control
%                                       surfaces
%	idcon       <size>		<units>		ID number of the control system.
%	gforce      <size>		<units>		<Description>
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	outstr	  <size>		<units>		<Description> 
%
% NOTES:
%	sensors Note:The first column contains the numbers of the inputs of the
%                control system, the second - ID numbers of the sensors,
%                the third defines the type of connection between the
%                control system input and the sensor: =0 fixed connection;
%                =G gain connection with the gain equal G.
%                Example: sensors=[1 100 0; 2 200 -1.0] defines fixed 
%                connection between first input of the control system
%                and the sensor with ID number equal 100, and gain 
%                connection with the gain equal -1.0 between second input
%                and the sensor with ID=200. 
%   actuat Note:The first column contains the numbers of the outputs of the
%               control system, the second - ID numbers of the actuators,
%               the third defines the type of connection between the
%               control system input and the actuator: =0 fixed connection;
%               =G gain connection with the gain equal G.
%               Example: actuat=[1 10 0.01; 2 20 0] defines gain connection
%               with the gain equal 0.01 between first output of the control
%               system and the actuator with ID number equal 10, and fixed 
%               connection between second output and the actuator with
%               ID=20.
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[outstr] = conzaero(a, b, c, d, name, filename, sensors, actuat, csurf, idcon, gforce, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[outstr] = conzaero(a, b, c, d, name, filename, sensors, actuat, csurf, idcon, gforce)
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
%	Source function: <a href="matlab:edit conzaero.m">conzaero.m</a>
%	  Driver script: <a href="matlab:edit Driver_conzaero.m">Driver_conzaero.m</a>
%	  Documentation: <a href="matlab:pptOpen('conzaero_Function_Documentation.pptx');">conzaero_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/30
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AeroServoElastic/conzaero.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [outstr] = conzaero(a, b, c, d, name, filename, sensors, actuat, csurf, idcon, gforce)

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
outstr= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        gforce= ''; idcon= ''; csurf= ''; actuat= ''; sensors= ''; filename= ''; name= ''; d= ''; c= ''; b= ''; a= ''; 
%       case 1
%        gforce= ''; idcon= ''; csurf= ''; actuat= ''; sensors= ''; filename= ''; name= ''; d= ''; c= ''; b= ''; 
%       case 2
%        gforce= ''; idcon= ''; csurf= ''; actuat= ''; sensors= ''; filename= ''; name= ''; d= ''; c= ''; 
%       case 3
%        gforce= ''; idcon= ''; csurf= ''; actuat= ''; sensors= ''; filename= ''; name= ''; d= ''; 
%       case 4
%        gforce= ''; idcon= ''; csurf= ''; actuat= ''; sensors= ''; filename= ''; name= ''; 
%       case 5
%        gforce= ''; idcon= ''; csurf= ''; actuat= ''; sensors= ''; filename= ''; 
%       case 6
%        gforce= ''; idcon= ''; csurf= ''; actuat= ''; sensors= ''; 
%       case 7
%        gforce= ''; idcon= ''; csurf= ''; actuat= ''; 
%       case 8
%        gforce= ''; idcon= ''; csurf= ''; 
%       case 9
%        gforce= ''; idcon= ''; 
%       case 10
%        gforce= ''; 
%       case 11
%        
%       case 12
%        
%  end
%
%  if(isempty(gforce))
%		gforce = -1;
%  end
%% Main Function:
%disp([mfilename '>> Running...']);

nag1 = nargin;
nag2 = nargout;
if nag2 == 1
    outstr = '-1: Error in conzaero';
else
    outstr = 'Conzaero>> Function is Running or Errored';
end;

if nag1 ~= 6 & nag1 ~= 11
   disp('ERROR in function CONZAERO: Number of input arguments must be 6 or 11.')
   return;
end
tin=1;
fid=fopen(filename,'w+');   
dollar='$';
coment='$ STATE-SPACE MATRICES OF THE CONTROL SYSTEM';
fprintf(fid,'%s\n',dollar); fprintf(fid,'%s\n',coment); fprintf(fid,'%s\n',dollar); 
[ntf,nu,ny,NAME]=forzaero(fid,a,b,c,d,name,tin);
if nag1 == 11
%  Make bulk data card MIMOSS
   mimossid=idcon+10;
   sidmimo=[int2str(mimossid) blanks(8-length(int2str(mimossid)))];
   sntf=[int2str(ntf) blanks(8-length(int2str(ntf)))];
   snu=[int2str(nu) blanks(8-length(int2str(nu)))];
   sny=[int2str(ny) blanks(8-length(int2str(ny)))];
   stmp=['MIMOSS  ' sidmimo sntf snu sny NAME];
   coment='$ MIMO CONTROL ELEMENT';
   fprintf(fid,'%s\n',dollar); fprintf(fid,'%s\n',coment); fprintf(fid,'%s\n',dollar); 
   fprintf(fid,'%s\n',stmp);
%  Make bulk data cards CONCT
   conset=[]; asegset=[]; conid=mimossid;
%  Connections to sensors
   [nscon,tmp]=size(sensors);
   if tmp ~= 3
      disp('ERROR in function CONZAERO: Number of columns in matrix SENSORS must be 3.')
      return;
   end
   if nscon ~= nu
      disp('ERROR in function CONZAERO:')
      disp(' Number of rows in matrix SENSORS must be equal to the number inputs of control system.')
      return;
   end
   coment='$ CONNECTIONS OF SENSORS TO INPUTS OF THE CONTROL SYSTEM';
   fprintf(fid,'%s\n',dollar); fprintf(fid,'%s\n',coment); fprintf(fid,'%s\n',dollar); 
   inputs=sensors(:,1);
   sensid=sensors(:,2);
   for iu=1:nu
      iinp=find(inputs==iu);
      if isempty(iinp)
         disp('WARNING in function CONZAERO:')
         disp(' Input number num2str(iu) of the control system is not connected to any sensor.')
      end
      if length(iinp)~=1
         disp('ERROR in function CONZAERO:')
         disp(' Input number num2str(iu) of the control system is connected to more than one sensor.')
         return;
      end
      G=sensors(iinp,3);
      idsen=sensid(iinp(1));
      conid=conid+10;
      sidsen=[int2str(idsen) blanks(8-length(int2str(idsen)))];
      sconid=[int2str(conid) blanks(8-length(int2str(conid)))];
      sci=[int2str(iu) blanks(8-length(int2str(iu)))];
      if G==0
         conset=[conset; conid];
         conct=['CONCT   ' sconid sidsen '1       ' sidmimo sci];
      else
         asegset=[asegset; conid];
         sG=field8(G);
         conct=['ASEGAIN ' sconid sidsen '1       ' sidmimo sci sG];
      end
      fprintf(fid,'%s\n',conct);
   end
%  Connections to actuators
   [nacon,tmp]=size(actuat);
   if tmp ~= 3
      disp('ERROR in function CONZAERO: Number of columns in matrix ACTUAT must be 3.')
      return;
   end
   if nacon ~= ny
      disp('ERROR in function CONZAERO:')
      disp(' Number of rows in matrix ACTUAT must be equal to the number outputs of control system.')
      return;
   end
   outputs=actuat(:,1);
   actid=actuat(:,2);
   coment='$ CONNECTIONS OF OUTPUTS OF THE CONTROL SYSTEM TO ACTUATORS';
   fprintf(fid,'%s\n',dollar); fprintf(fid,'%s\n',coment); fprintf(fid,'%s\n',dollar); 
   for iy=1:ny
      iout=find(outputs==iy);
      if isempty(iout)
         disp('WARNING in function CONZAERO:')
         disp(' Output number num2str(iy) of the control system is not connected to any actuator.')
      end
      if length(iinp)~=1
         disp('ERROR in function CONZAERO:')
         disp(' Output number num2str(iy) of the control system is connected to more than one actuator.')
         return;
      end
      G=actuat(iout,3);
      idact=actid(iout(1));
      conid=conid+10;
      sidact=[int2str(idact) blanks(8-length(int2str(idact)))];
      sconid=[int2str(conid) blanks(8-length(int2str(conid)))];
      sco=[int2str(iy) blanks(8-length(int2str(iy)))];
      if G==0
         conset=[conset; conid];
         conct=['CONCT   ' sconid sidmimo sco sidact '1       '];
      else
         asegset=[asegset; conid];
         sG=field8(G);
         conct=['ASEGAIN ' sconid sidmimo sco sidact '1       ' sG];
      end
      fprintf(fid,'%s\n',conct);
   end
   coment='$ SETS OF SENSORS, CONTROL SURFACES, CONTROL ELEMENTS, AND CONNECTIONS';
   fprintf(fid,'%s\n',dollar); fprintf(fid,'%s\n',coment); fprintf(fid,'%s\n',dollar); 
%  Make bulk data card SENSET
   sensetid=conid+10;
   mkset('SENSET  ',sensetid,sensid,fid);
%  Make bulk data card SURFSET
   surfsetid=sensetid+10;
   mkset('SURFSET ',surfsetid,csurf,fid);
   mkset('GRDFSET ',surfsetid,gforce,fid);
%  Make bulk data card TFSET
   tfid=surfsetid+10;
   stfid=[int2str(tfid) blanks(8-length(int2str(tfid)))];
   tfset=['TFSET   ' stfid sidmimo];
   fprintf(fid,'%s\n',tfset);
%  Make bulk data card CNCTSET
   cncid=tfid+10;
   mkset('CNCTSET ',cncid,conset,fid);
%  Make bulk data card GAINSET
   gsid=cncid+10;
   mkset('GAINSET ',gsid,asegset,fid);
%  Make bulk data card ASECONT
   sidcon=[int2str(idcon) blanks(8-length(int2str(idcon)))];
   ssurfid=[int2str(surfsetid) blanks(8-length(int2str(surfsetid)))];
   ssensid=[int2str(sensetid) blanks(8-length(int2str(sensetid)))];
   stfid=[int2str(tfid) blanks(8-length(int2str(tfid)))];
   sgainid=[int2str(gsid) blanks(8-length(int2str(gsid)))];
   sconctid=[int2str(cncid) blanks(8-length(int2str(cncid)))];
   if conset~=''
       asecont=['ASECONT ' sidcon ssurfid ssensid stfid sgainid sconctid];
   else
       asecont=['ASECONT ' sidcon ssurfid ssensid stfid sgainid];
   end
   coment='$ CONTROL SYSTEM DEFINITION';
   fprintf(fid,'%s\n',dollar); fprintf(fid,'%s\n',coment); fprintf(fid,'%s\n',dollar); 
   fprintf(fid,'%s\n',asecont);
end
fclose(fid);
outstr = [' 0: File "' filename '" Created Successfully.'];

if nag2 ==0;
    disp(['CONZAER>>' outstr(4:end)]);
end;

return; %conzaero

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FCN: field8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function str8=field8(a)
str8=sprintf('%8g',a);
if length(str8)==8 & ~isempty(findstr(str8,'.'));
    return;
end;
if isempty(findstr(str8,'.')) & isempty(findstr(str8,'e')) & str8(1)==' ', str8=[str8(2:8) '.'];
      return;
end
while 1
   disp(['Gain value is ' str8]);
   sinp=input('Enter it in ZAERO format (8 characters) ','s')
   if ~isempty(str2num(sinp))&length(sinp)==8, str8=sinp;
      return;
   end
end
return %field8

%%%%%%%%%%%%%%%%%%%
%% FCN: mkset
%%%%%%%%%%%%%%%%%%%
function mkset(card,sid,idnum,fid)
if ~(iscell(idnum))
    if sum(idnum)==0 % changed to no make a line if the cell is empty
        return
    end
end
ssid=[int2str(sid) blanks(8-length(int2str(sid)))];
if ~iscellstr(idnum)
   sidnum=int2str(idnum);
   [nr, nc]=size(sidnum); bl=blanks(8-nc);
   str=[];
   for ir=1:nr
      str=[str bl sidnum(ir,:)];
   end
else
   strcs=char(idnum);
   [nr, nc]=size(strcs); bl=blanks(8-nc);
   if nc > 8
      disp('ERROR in function CONZAERO:')
      disp('Control surface label must contain 8 characters or less.')
      disp('Bulk data card SURFSET was not created.')
      return;
   end
   str=[];
   for ir=1:nr
      str=[str strcs(ir,:) bl];
   end
end
if nr < 8
   setcard=[card ssid str];
   fprintf(fid,'%s\n',setcard);
else
   ncont=ceil((nr-7)/8);
   cont=['+' card(1:3) ssid(1:2) int2str(1)];
   setcard=[card ssid str(1:8*7) cont];
   fprintf(fid,'%s\n',setcard);
   nwrt=7;
   nnrest=nr-7;
   for icard=1:ncont
      nncur=min([nnrest 8]);
      contn=['+' card(1:3) ssid(1:2) int2str(icard+1)];
      if icard==ncont, contn=''; end;
      setcard=[cont blanks(8-length(cont)) str(8*nwrt+1:8*(nwrt+nncur)) contn];
      fprintf(fid,'%s\n',setcard);
      nnrest=nnrest-nncur; nwrt=nwrt+nncur; cont=contn;
   end
end
return; % mkset
%
function [ntf,nu,ny,NAME]=forzaero(fid,a,b,c,d,name,tin);
%
% Check dimensions
[nra, nca]=size(a);
if nra ~= nca,
   disp('ERROR in function FORZAERO: Matrix A must be squire.'); 
      return;
end
[nrb, ncb]=size(b);
if nra ~= nrb,
   disp('ERROR in function FORZAERO:');
   disp('Matrices A and B must have equal number of rows.'); 
      return;
end
[nrc, ncc]=size(c);
if nca ~= ncc,
   disp('ERROR in function FORZAERO:');
   disp('Matrices A and C must have equal number of columns.'); 
      return;
end
[nrd, ncd]=size(d);
if ncb ~= ncd,
   disp('ERROR in function FORZAERO:');
   disp('Matrices B and D must have equal number of columns.'); 
      return;
end
if nrc ~= nrd,
   disp('ERROR in function FORZAERO:');
   disp('Matrices C and D must have equal number of rows.');
      return;
end
ntf=nra; nu=ncb; ny=nrc;
%
%%% this is a new line compared to TV's
fprintf(fid,'$  [NTF, NU, NY] = [%3i %3i %3i] \n',ntf,nu,ny);
%%%

% Check tin and large
if tin~=1&tin~=2,
   disp('ERROR in function FORZAERO: TIN must be either 1 or 2'); 
      return;
end
%large=deblank(large)
%if upper(large)~='DMIL'|upper(large)~='DMIS',
%   disp('ERROR in function FORZAERO: LARGE must be either DMIL or DMIS'); break
%end
tmp=[a b; c d];
%fid=fopen(filename,'w+');   
%
% Make bulk data card DMI
dmi='DMI     '; zer0='0       '; form='2       '; stin=[int2str(tin) blanks(7)];
if length(name)>8,
   NAME=upper(name(1:8));
   disp(['WARNING in function FORZAERO: NAME was reduced to 8 characters: ' NAME]);
else
   NAME=[upper(name) blanks(8-length(name))];
end
m=nra+nrc; n=nca+ncb;
sm=sprintf('%8s',int2str(m)); sn=sprintf('%8s',int2str(n));
%DMICARD=strcat(dmi,NAME,zer0,form,stin,blanks(8),'DMIL',blanks(4),sm,sn);
DMICARD=[dmi NAME zer0 form stin blanks(8) 'DMIL' blanks(4) sm sn];
fprintf(fid,'%s\n',DMICARD);
%
% Make bulk data card DMIL/DMIS
for icol=1:n,
   scol=[]; nn=0; col=tmp(:,icol);
   inz=find(col);
   if ~isempty(inz)
%      scol=sprintf('%16s',int2str(icol)); nn=nn+1;
      stmp=int2str(icol); scol=[stmp blanks(16-length(stmp))]; nn=nn+1;
%      scol=strcat(scol,sprintf('%16d',inz(1)),sprintf('%16.9e',col(inz(1))));
      stmp=int2str(inz(1));
      scol=[scol stmp blanks(16-length(stmp)) sprintf('%16.8e',col(inz(1)))];
      nn=nn+2;
      for irow=2:length(inz),
         if inz(irow)==inz(irow-1)+1,
            scol=strcat(scol,sprintf('%16.8e',col(inz(irow))));
            nn=nn+1;
         else
            stmp=int2str(inz(irow));
%%exp       scol=[scol stmp blanks(16-length(stmp)) sprintf('%16.8e',col(inz(irow)))];

            scol=strcat(scol,sprintf('%16d',inz(irow)),sprintf('%16.8e',col(inz(irow))));

%            scol=strcat(scol,sprintf('%16d',inz(irow)),sprintf('%16.9e',col(inz(irow))));
            nn=nn+2;
         end
      end
   end
conx=['+       '];
conx2=['+       '];
   if nn<4
      DMILCARD=['DMIL    ' NAME blanks(8) scol];
      fprintf(fid,'%s\n',upper(DMILCARD));
   else
      ncont=ceil((nn-3)/4);
      cont=['+' NAME(1:3) int2str(icol) int2str(1)];
%%    DMILCARD=['DMIL    ' NAME blanks(8) scol(1:16*3) cont];
      DMILCARD=['DMIL    ' NAME blanks(8) scol(1:16*3) conx];
      fprintf(fid,'%s\n',upper(DMILCARD));
      nwrt=3;
      nnrest=nn-3;
      for icard=1:ncont
         nncur=min([nnrest 4]);
         contn=['+' NAME(1:3) int2str(icol) int2str(icard+1)];
%%       if icard==ncont, contn=''; end;
%%       DMILCARD=[cont blanks(8-length(cont)) scol(16*nwrt+1:16*(nwrt+nncur)) contn];

         if icard==ncont, conx2=''; end;
         DMILCARD=[conx scol(16*nwrt+1:16*(nwrt+nncur)) conx2];

         fprintf(fid,'%s\n',upper(DMILCARD));
         nnrest=nnrest-nncur; nwrt=nwrt+nncur; cont=contn;
      end
   end
end

return; %forzaero

%% Compile Outputs:
%	outstr= -1;

% << End of function conzaero >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101021 JPG: Copied over information from the old function.
% 101021 CNF: Function template created using CreateNewFunc
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
