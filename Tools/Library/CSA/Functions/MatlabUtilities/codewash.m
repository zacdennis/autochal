function codewash(Cmd)
%CODEWASH   M-file code formatting tool
%
%   To run CodeWash, type: CODEWASH
%
%   CodeWash is a graphical interface tool for formatting M-file code.
%   Formatting options include flow control indentation, spacing
%   around operators, and removing comments.  For basic usage, click
%   the help button in CodeWash.
%
%   DISCLAIMER:  The software is provided "AS IS" without any warranty,
%   either expressed or implied, including, but not limited to, the
%   implied warranties of merchantability and fitness for a particular
%   purpose. The author will not be liable for any special, incidental,
%   consequential or indirect damages due to loss of data or any other
%   reason.
%
%Details of CodeWash Features
%
%--- Format Settings ---
%
%Line break after ;
%   Inserts line breaks where multiple commands are concatenated on one
%   line.
%
%Remove end-line whitespace
%   Removes invisible tabs and spaces on the end of the lines.
%
%Remove comments
%   Removes line-style comments but preserves the header comments.
%   MATLAB 7.0 block comments are not supported.
%
%Flow control indentation
%   (+) Re-indents the code according to the flow control.
%   (-) Removes indentation whitespace and deletes blank lines.
%   ( ) No change; preserves existing indentation.
%
%Leading zero before decimal
%   (+) Changes numbers like .85 to 0.85 and .01 to 0.01.
%   (-) The opposite; changes 0.85 to .85 and 0.01 to .01.
%   ( ) No change; preserves existing number notation.
%
%Space =, ==, ~=, <=, >=, <, >
%Space +, -
%Space *, /, \, ^   (includes .*, ./, .\, .^)
%Space :
%   (+) Forces spacing around operators, e.g. "x=5" becomes "x = 5".
%   (-) Removes spacing
%   ( ) No change
%
%--- Format Details ---
%
%After formatting, view a report of the format by clicking "Format
%Details" under the "View" menu.  The report shows number of lines and
%file size before and after the format and the elapsed time.  The
%exact output size may be inaccurate depending on your machine's 
%convention for saving line feeds.
% Pascal Getreuer 2004-2005
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/439
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

global G_WASH

if nargin < 1
   if ~isempty(G_WASH)
      figure(G_WASH(1));
      return;
   end

   G_WASH(1) = figure('Name','CodeWash','Numbertitle','off','Menubar','none',...
      'CloseRequestFcn',[mfilename,'(-1)']);
   Pos = get(G_WASH(1),'Position');
   DlgColor = get(G_WASH(1),'Color');  FrameColor = min(DlgColor + 0.08,1);
   set(G_WASH(1),'Position',[Pos(1:2),600,320],'ResizeFcn',[mfilename,'(0)']);
   G_WASH(2:3) = nan;
   G_WASH(4) = uicontrol('Style','listbox','Position',[190,4,407,264],'Enable','off',...
      'String',{' CodeWash 1.0','',...
         ' DISCLAIMER:  The software is provided "AS IS" without',...
         ' any warranty, either expressed or implied, including,',...
         ' but not limited to, the implied warranties of',...
         ' merchantability and fitness for a particular purpose.',...
         ' The author will not be liable for any special,',...
         ' incidental, consequential or indirect damages due to',...
         ' loss of data or any other reason.'},'Value',2);
   G_WASH(5) = uicontrol('Style','listbox','Visible','off','String','');
   set(G_WASH(4:5),'FontName','Courier New','FontSize',9,'BackgroundColor',[1,1,1]);
   G_WASH(6) = uicontrol('Style','frame','Position',[5,42,180,226]);
   G_WASH(7) = uicontrol('Style','pushbutton','String','','Tooltip','Open','CData',...
      GetIcon(1),'Callback',[mfilename,'(1)'],'Position',[10,292,26,26]);
   G_WASH(8) = uicontrol('Style','pushbutton','String','','Tooltip','Save','CData',...
      GetIcon(2),'Callback',[mfilename,'([2,1])'],'Position',[38,292,26,26],'Enable','off');
   G_WASH(9) = uicontrol('Style','pushbutton','String','','CData',GetIcon(3),'Enable','off',...
      'Tooltip','Open original file in MATLAB Editor','Callback',[mfilename,'(10)']);
   G_WASH(10) = uicontrol('Style','pushbutton','String','','CData',...
      GetIcon(4),'Callback',[mfilename,'(6)']);
   G_WASH(11) = uicontrol('Style','pushbutton','String','','CData',GetIcon(5),...
      'Callback',[mfilename,'(7)'],'Tooltip','View format details');
   G_WASH(12) = uicontrol('Style','togglebutton','HorizontalAlignment','left','String','',...
      'CData',GetIcon(6),'Callback',[mfilename,'(8)']);
   G_WASH(13) = uicontrol('Style','togglebutton','HorizontalAlignment','left','String','',...
      'CData',GetIcon(7),'Callback',[mfilename,'(9)']);
   G_WASH(14) = uicontrol('Style','text','HorizontalAlignment','left','String','');
   G_WASH(15) = uicontrol('Style','pushbutton','String','','Tooltip','Help','CData',...
      GetIcon(8),'Callback',[mfilename,'(13)']);
   set(G_WASH([7:15]),'BackgroundColor',DlgColor);
   G_WASH(16) = uicontrol('Style','popupmenu','String',{'Standard',...
         'Compress','None','Custom'},'BackgroundColor',[1,1,1],'Callback',...
      [mfilename,'(3)'],'Tooltip','Format preset');
   G_WASH(17) = uicontrol('Style','checkbox','String','Line break after ;');
   G_WASH(18) = uicontrol('Style','checkbox','String','Remove end-line whitespace');
   G_WASH(19) = uicontrol('Style','checkbox','String','Remove comments');
   set(G_WASH(17:19),'Callback',[mfilename,'(11)']);
   G_WASH(20) = uicontrol('Style','text','String','Flow control indentation');
   G_WASH(21) = uicontrol('Style','text','String','Leading zero before decimal');
   G_WASH(22) = uicontrol('Style','text','String','Space =, ==, ~=, <=, >=, <, >');
   G_WASH(23) = uicontrol('Style','text','String','Space +, -');
   G_WASH(24) = uicontrol('Style','text','String','Space *, /, \, ^');
   G_WASH(25) = uicontrol('Style','text','String','Space :');

   for k = 0:5
      G_WASH(26+k) = uicontrol('Style','pushbutton','Callback',...
         sprintf('%s([4,%d])',mfilename,26+k),'FontName','Fixedsys');
   end

   set(G_WASH([6,17:25]),'BackgroundColor',FrameColor,'HorizontalAlignment','left');

   tmp = uimenu('Label','&File');
   uimenu(tmp,'Label','&Open...','Callback',[mfilename,'(1)'],'Accelerator','O');
   G_WASH(32) = uimenu(tmp,'Label','&Save','Enable','off',...
      'Callback',[mfilename,'([2,1])'],'Accelerator','S');
   G_WASH(33) = uimenu(tmp,'Label','Save &As...','Enable','off',...
      'Callback',[mfilename,'([2,0])']);
   G_WASH(34) = uimenu(tmp,'Label','Open in &MATLAB Editor','Enable','off',...
      'Separator','on','Callback',[mfilename,'(10)']);
   uimenu(tmp,'Label','E&xit','Separator','on','Callback',[mfilename,'(-1)']);
   tmp = uimenu('Label','&View');
   uimenu(tmp,'Label','Format &Details','Callback',[mfilename,'(7)']);
   G_WASH(35) = uimenu(tmp,'Label','&Original File','Callback',[mfilename,'(8)'],...
      'Separator','on','Accelerator','1');
   G_WASH(36) = uimenu(tmp,'Label','&Formatted File','Callback',[mfilename,'(9)'],...
      'Accelerator','2');
   tmp = uimenu('Label','&Help');
   uimenu(tmp,'Label','Help &Notes','Callback',[mfilename,'(13)'],'Accelerator','H');
   uimenu(tmp,'Label','&M-File Info','Callback',['help ',mfilename]);
   uimenu(tmp,'Label','&About CodeWash','Separator','on','Callback',...
      'msgbox({''CodeWash 1.0'',''Pascal Getreuer 2005''},''About'')');
   feval(mfilename,0);
   feval(mfilename,3);
else
   switch Cmd(1)
   case -1     % close
      if ishandle(G_WASH(2)), close(G_WASH(2)); end
      if ishandle(G_WASH(3)), close(G_WASH(3)); end

      G_WASH = [];
      closereq;
   case 0      % resize
      Pos = get(G_WASH(1),'Position');
      if any(Pos(3:4) < [440,282])
         Pos = max(Pos,[-inf,-inf,440,282]);
         set(G_WASH(1),'Position',Pos);
      end

      set(G_WASH(4),'Position',[190,4,Pos(3)-193,Pos(4)-56]);
      set(G_WASH(5),'Position',[190,4,Pos(3)-193,Pos(4)-56]);
      set(G_WASH(6),'Position',[5,Pos(4)-278,180,226]);
      set(G_WASH(7),'Position',[8,Pos(4)-28,26,26]);
      set(G_WASH(8),'Position',[36,Pos(4)-28,26,26]);
      set(G_WASH(9),'Position',[66,Pos(4)-28,26,26]);
      set(G_WASH(10),'Position',[96,Pos(4)-28,58,26]);
      set(G_WASH(11),'Position',[156,Pos(4)-28,26,26]);
      set(G_WASH(12),'Position',[194,Pos(4)-28,26,26]);
      set(G_WASH(13),'Position',[222,Pos(4)-28,26,26]);
      set(G_WASH(14),'Position',[256,Pos(4)-30,Pos(3)-292,22]);
      set(G_WASH(15),'Position',[Pos(3)-34,Pos(4)-28,26,26]);
      set(G_WASH(16),'Position',[18,Pos(4)-61,75,18]);
      set(G_WASH(17),'Position',[13,Pos(4)-86,160,18]);
      set(G_WASH(18),'Position',[13,Pos(4)-108,160,18]);
      set(G_WASH(19),'Position',[13,Pos(4)-130,160,18]);

      for k = 0:5
         set(G_WASH(20+k),'Position',[36,Pos(4)-165-k*22,145,18]);
         set(G_WASH(26+k),'Position',[12,Pos(4)-163-k*22,18,18]);
      end
   case 1   % file open
      [File,Path] = uigetfile('*.m','Open');

      if File ~= 0
         set(G_WASH(14),'String',fullfile(Path,File));
         set(G_WASH(1),'Name',['CodeWash - ',File]);
         Fid = fopen(fullfile(Path,File),'r');

         if Fid == -1
            msgbox({'Error reading file',fullfile(Path,File)},'Error','error');
            return;
         end

         Buf = char(fread(Fid,[1,inf],'uchar'));
         fclose(Fid);
         Buf(find(Buf == 13)) = [];
         Buf = strrep(Buf,char(9),'   ');
         i = [0,find(Buf == 10),length(Buf)+1];
         Text = {};

         for k = 1:length(i)-1
            Text{k} = Buf(i(k)+1:i(k+1)-1);
         end

         set(G_WASH(4),'String',Text,'Visible','on','BackgroundColor',[1,1,1],'Enable','on','Value',1);
         set(G_WASH(5),'String','','Visible','off','Value',1);
         set(G_WASH(11),'UserData',[]);
         set(G_WASH(12),'Value',1);
         set(G_WASH(13),'Value',0);
         set(G_WASH([8,32:33]),'Enable','off');
         set(G_WASH([9,34]),'Enable','on');
         set(G_WASH(35),'Checked','on');
         set(G_WASH(36),'Checked','off');
      end
   case 2   % file save / save as
      if ~isempty(get(G_WASH(5),'String'))

         if Cmd(2)
            Filename = get(G_WASH(14),'String');
            Fid = fopen(Filename,'rt');

            if Fid == -1
               msgbox({'Error creating backup file',[Filename(1:end-2),'.bak']},'Error','error');
               return;
            end

            Buf = char(fread(Fid,[1,inf],'uchar'));
            fclose(Fid);
            Fid = fopen([Filename(1:end-2),'.bak'],'wt');

            if Fid == -1
               msgbox({'Error creating backup file',[Filename(1:end-2),'.bak']},'Error','error');
               return;
            end

            Len = fwrite(Fid,Buf,'uchar');

            if Len ~= length(Buf)
               fclose(Fid);
               msgbox({'Error writing backup file',[Filename(1:end-2),'.bak']},'Error','error');
               return;
            end

            fclose(Fid);
         else
            [File,Path] = uiputfile('*.m','Save');

            if File == 0
               return;
            end

            Filename = fullfile(Path,File);
         end

         Text = get(G_WASH(5),'String');
         NewLine = char(10);
         Buf = '';

         for k = 1:length(Text)-1
            Buf = [Buf,Text{k},NewLine];
         end

         Fid = fopen(Filename,'wt');

         if Fid == -1
            msgbox({'Error writing file',Filename},'Error','error');
            return;
         end

         fwrite(Fid,Buf,'uchar');
         fclose(Fid);

         if Cmd(1)
            set(G_WASH(4),'String',get(G_WASH(5),'String'));
         end
      end
   case 3      % combo box
      switch get(G_WASH(16),'Value')
      case 1
         set(G_WASH(18),'Value',1);
         set(G_WASH([17,19]),'Value',0);
         set(G_WASH(26:28),'UserData',1,'String','+','Tooltip','Force');
         set(G_WASH(29:30),'UserData',0,'String',' ','Tooltip','No change');
         set(G_WASH(31),'UserData',2,'String','-','Tooltip','Remove');
      case 2
         set(G_WASH(17),'Value',0);
         set(G_WASH(18:19),'Value',1);
         set(G_WASH(26:31),'UserData',2,'String','-','Tooltip','Remove');
      case 3
         set(G_WASH(17:18),'Value',0);
         set(G_WASH(26:31),'UserData',0,'String',' ','Tooltip','No change');
      end
   case 4      % multistate check buttons
      State = rem(get(G_WASH(Cmd(2)),'UserData') + 1,3);
      Label = {' ','+','-'};
      Tip = {'No change','Force','Remove'};
      set(G_WASH(Cmd(2)),'UserData',State,'String',Label{State+1},'Tooltip',Tip{State+1});
      set(G_WASH(16),'Value',4);
   case 6      % format
      Tab = char(9);
      NewLine = char(10);
      Delimit = [Tab,' &''()*+,-./\:;<=>[]^{|}~'];
      DelimitStr = [Tab,' &''(*+,-/\:;<=>[^{|~'];
      Digit = 48:57;
      Ops = '=<>+-*/\^:';
      FormatLineBreak = get(G_WASH(17),'Value');
      FormatEndWhitespace = get(G_WASH(18),'Value');
      FormatRemComments = get(G_WASH(19),'Value');
      FormatFlowControl = get(G_WASH(26),'UserData');
      FormatLeadingZero = get(G_WASH(27),'UserData');
      FormatSpace1 = get(G_WASH(28),'UserData');
      FormatSpace2 = get(G_WASH(29),'UserData');
      FormatSpace3 = get(G_WASH(30),'UserData');
      FormatSpace4 = get(G_WASH(31),'UserData');
      Filename = get(G_WASH(14),'String');

      if isempty(Filename)
         return;
      end

      Fid = fopen(Filename,'rt');

      if Fid == -1
         msgbox({'Error reading file',Filename},'Error','error');
         return;
      end

      CurLine = 0;
      OutLine = 0;
      OutSize = 0;
      NextIndentLevel = 0;
      ParLevel = 0;
      HeaderComment = 1;
      MidLine = 0;
      ListOutput = {};
      set(G_WASH(14),'String',sprintf('Processing line 1...'));
      FormatTime = (clock)*[0;0;86400;3600;60;1];

      while 1
         IndentLevel = NextIndentLevel;
         LastParLevel = ParLevel;

         if ~MidLine
            [Buf,lt] = fgets(Fid);

            if ~isempty(lt)
               Buf = Buf(1:end-length(lt));
            end

            if Buf == -1      % EOF
               break;
            end

            CurLine = CurLine + 1;
            Strs = {};
            IndentStr = '';
            Comment = '';

            if ~rem(CurLine,10)
               set(G_WASH(14),'String',sprintf('Processing line %d...',CurLine));
            end

            % find strings
            i = [1,find(Buf == '''')];
            LastInd = 1;

            for k = 2:length(i)
               if rem(length(Strs),2) | i(k) == 1 | any(Buf(i(k)-1) == DelimitStr)
                  Strs{end+1} = Buf(LastInd:i(k)-1);
                  LastInd = i(k);
               end
            end

            NumStrs = length(Strs)+1;
            Strs{NumStrs} = Buf(LastInd:end);

            % find indent whitespace
            i = min([find(Strs{1} ~= ' ' & Strs{1} ~= Tab),length(Strs{1})+1]);

            if FormatFlowControl == 0
               IndentStr = Strs{1}(1:i-1);
            end

            Strs{1} = Strs{1}(i:end);

            % find comment
            for k = 1:2:NumStrs
               i = find(Strs{k} == '%');

               if ~isempty(i)
                  Comment = [Strs{k}(i:end),Strs{k+1:NumStrs}];
                  NumStrs = k;
                  Strs = {Strs{1:k-1},Strs{k}(1:i-1)};
                  break;
               end
            end

            if HeaderComment
               if NumStrs > 1 | (~isempty(Strs{1}) ...
                     & isempty(findstr(Strs{1},'function')))
                  HeaderComment = 0;
                  Comment = '';
               end
            elseif FormatRemComments
               Comment = '';
            end
         else
            Strs = NextStrs;
            MidLine = 0;
         end

         FirstToken = 1;
         TokenFlag = 0;

         for k = 1:2:length(Strs)
            % format indentation
            if FormatLineBreak | FormatFlowControl == 1 | FormatLeadingZero
               i = 1;
               Token = '';

               while i <= length(Strs{k})
                  c = Strs{k}(i);

                  if any(c == Delimit)
                     TokenFlag = 1;
                  elseif i == length(Strs{k})
                     Token = [Token,c];
                     TokenFlag = 1;
                  else
                     Token = [Token,c];
                     TokenFlag = 0;
                  end

                  if TokenFlag
                     switch Token
                     case {'if','while','for','switch','try'}
                        NextIndentLevel = NextIndentLevel + 1;
                     case {'else','elseif','case','otherwise','catch'}
                        if FirstToken, IndentLevel = IndentLevel - 1; end
                     case 'end'
                        if ~ParLevel
                           if FirstToken, IndentLevel = IndentLevel - 1; end
                           NextIndentLevel = NextIndentLevel - 1;
                        end
                     end

                     Token = '';
                     FirstToken = 0;

                     switch c
                     case {'(','[','{'}
                        ParLevel = ParLevel + 1;
                     case {')',']','}'}
                        ParLevel = max(0,ParLevel - 1);
                     case {';',','}
                        if ~ParLevel & FormatLineBreak
                           Buf = [Strs{k}(i+1:end),Strs{k+1:end}];
                           j = find(Buf ~= ' ' & Buf ~= Tab);

                           if ~isempty(j)
                              NextStrs = {Strs{k}(i+j(1):end),Strs{k+1:end}};
                              Strs = {Strs{1:k-1},Strs{k}(1:i-1),strrep(Strs{k}(i),',','')};
                              MidLine = 1;
                              break;
                           end
                        end
                     case '.'
                        if FormatLeadingZero & i < length(Strs{k}) ...
                           & any(Strs{k}(i+1) == Digit)
                           if FormatLeadingZero == 1
                              if i == 1 | all(Strs{k}(i-1) ~= Digit)
                                 Strs{k} = [Strs{k}(1:i-1),'0',Strs{k}(i:end)];
                                 i = i + 1;
                              end
                           elseif i > 1 & Strs{k}(i-1) == '0' ...
                              & (i == 2 | all(Strs{k}(i-2) ~= Digit))
                              Strs{k}(i-1) = [];
                              i = i - 1;
                           end
                        end
                     end
                  end

                  i = i + 1;
               end
            end

            if MidLine, break; end

            % format spacing around operators
            if FormatSpace1
               for j = '=<>'
                  Strs{k} = strrep(strrep(Strs{k},[' ',j],j),[j,' '],j);
               end

               Strs{k} = strrep(strrep(Strs{k},' ~=','~='),'~= ','~=');

               if FormatSpace1 == 1
                  for j = '=<>'
                     Strs{k} = strrep(strrep(Strs{k},j,[' ',j,' ']),[j,'  ='],[j,'=']);
                  end

                  Strs{k} = strrep(Strs{k},'~ =',' ~=');
               end
            end

            if FormatSpace2
               Strs{k} = strrep(strrep(Strs{k},' +','+'),'+ ','+');
               Strs{k} = strrep(strrep(Strs{k},' -','-'),'- ','-');

               if FormatSpace2 == 1
                  Strs{k} = strrep(Strs{k},'+',' + ');
                  Strs{k} = strrep(Strs{k},'-',' - ');
               end
            end

            if FormatSpace3
               for j = '*/\^'
                  Strs{k} = strrep(strrep(strrep(Strs{k},[' ',j],j),...
                        [j,' '],j),[' .',j],['.',j]);
               end

               if FormatSpace3 == 1
                  for j = '*/\^'
                     Strs{k} = strrep(strrep(strrep(Strs{k},['.',j],[' .',j,' ']),...
                           j,[' ',j,' ']),['. ',j],['.',j]);
                  end
               end
            end

            if FormatSpace4
               Strs{k} = strrep(strrep(Strs{k},' :',':'),': ',':');

               if FormatSpace4 == 1
                  Strs{k} = strrep(Strs{k},':',' : ');
               end
            end
         end

         switch FormatFlowControl
         case 0
            Strs{1} = [IndentStr,Strs{1}];
         case 1
            Strs{1} = [Tab(1,ones(1,IndentLevel)),Strs{1}];
         end

         Buf = [Strs{:},Comment];

         if FormatEndWhitespace
            Buf = Buf(1:max([0,find(Buf ~= ' ' & Buf ~= Tab)]));
         end

         if FormatFlowControl ~= 2 | ~(length(Strs) == 1 & isempty(Buf)) | HeaderComment
            %fprintf('%s\n',strrep(Buf,Tab,'   '));
            Buf = [Buf,NewLine];
            i = [0,find(Buf == 10)];

            for k = 2:length(i)
               OutLine = OutLine + 1;
               OutSize = OutSize + i(k)-i(k-1)-1;
               ListOutput{OutLine} = strrep(Buf(i(k-1)+1:i(k)-1),Tab,'   ');
            end
         end

         NextIndentLevel = NextIndentLevel + ParLevel - LastParLevel;
      end
      
      if ~isempty(ListOutput{OutLine})
         ListOutput{OutLine + 1} = '';
      end
      
      set(G_WASH(11),'UserData',{ftell(Fid),OutSize + OutLine*length(NewLine),...
            CurLine,OutLine,(clock)*[0;0;86400;3600;60;1] - FormatTime});
      fclose(Fid);

      set(G_WASH(4),'Visible','off');
      set(G_WASH(5),'String',ListOutput,'Visible','on');
      set(G_WASH(14),'String',Filename);
      set(G_WASH(12),'Value',0);
      set(G_WASH(13),'Value',1);
      set(G_WASH(35),'Checked','off');
      set(G_WASH(36),'Checked','on');
      set(G_WASH([8,32:33]),'Enable','on');
      feval(mfilename,12);
   case 7  % report
      if ishandle(G_WASH(2))
         figure(G_WASH(2));
      elseif ~isempty(get(G_WASH(11),'UserData'))
         DlgColor = get(G_WASH(1),'Color');  FrameColor = min(DlgColor + 0.08,1);
         G_WASH(2) = figure('Name','Format Details','Numbertitle','off','Menubar','none',...
            'Color',DlgColor,'CloseRequestFcn',[mfilename,'(14)']);
         Pos = get(G_WASH(2),'Position');
         set(G_WASH(2),'Position',[Pos(1:2),280,130],'Resize','off');
         uicontrol('Style','frame','Position',[10,50,260,60],'BackgroundColor',FrameColor);
         uicontrol('Style','text','Position',[25,91,80,18],...
            'BackgroundColor',FrameColor,'String','Original','FontWeight','bold');
         uicontrol('Style','text','Position',[142,91,80,18],...
            'BackgroundColor',FrameColor,'String','Formatted','FontWeight','bold');
         G_WASH(37) = uicontrol('Style','text','Position',[25,71,112,17]);
         G_WASH(38) = uicontrol('Style','text','Position',[142,71,112,17]);
         G_WASH(39) = uicontrol('Style','text','Position',[25,54,112,17]);
         G_WASH(40) = uicontrol('Style','text','Position',[142,54,112,17]);
         G_WASH(41) = uicontrol('Style','text','Position',[15,18,120,17],...
            'BackgroundColor',DlgColor,'HorizontalAlignment','left');
         set(G_WASH(37:40),'BackgroundColor',FrameColor,'HorizontalAlignment','left');
         feval(mfilename,12);
      end
   case 8
      if ~isempty(get(G_WASH(14),'String'))
         set(G_WASH(4),'Visible','on');
         set(G_WASH(5),'Visible','off');
         set(G_WASH(12),'Value',1);
         set(G_WASH(13),'Value',0);
         set(G_WASH(35),'Checked','on');
         set(G_WASH(36),'Checked','off');
      else
         set(G_WASH(12),'Value',0);
         set(G_WASH(35),'Checked','off');
      end
   case 9
      if ~isempty(get(G_WASH(14),'String'))
         if isempty(get(G_WASH(5),'String'))
            feval(mfilename,6);
         else
            set(G_WASH(4),'Visible','off');
            set(G_WASH(5),'Visible','on');
            set(G_WASH(12),'Value',0);
            set(G_WASH(13),'Value',1);
            set(G_WASH(35),'Checked','off');
            set(G_WASH(36),'Checked','on');
         end
      else
         set(G_WASH(13),'Value',0);
         set(G_WASH(36),'Checked','off');
      end
   case 10
      Filename = get(G_WASH(14),'String');

      if ~isempty(Filename)
         evalin('base',['edit ',Filename]);
      end
   case 11
      set(G_WASH(16),'Value',4);
   case 12
      if ishandle(G_WASH(2))
         Report = get(G_WASH(11),'UserData');

         if Report{5} >= 0.1
            set(G_WASH(41),'String',sprintf('Elapsed time: %.1f s',Report{5}));
         else
            set(G_WASH(41),'String','Elapsed time: ~0 s');
         end

         set(G_WASH(37),'String',sprintf('Size:   %d bytes',Report{1}));
         set(G_WASH(38),'String',sprintf('Size:   %d bytes',Report{2}));
         set(G_WASH(39),'String',sprintf('Lines: %d',Report{3}));
         set(G_WASH(40),'String',sprintf('Lines: %d',Report{4}));
      end
   case 13  % help
      if ishandle(G_WASH(3))
         figure(G_WASH(3));
      else
         DlgColor = get(G_WASH(1),'Color');  FrameColor = min(DlgColor + 0.08,1);
         G_WASH(3) = figure('Name','Help','Numbertitle','off','Menubar','none',...
            'Color',DlgColor,'CloseRequestFcn',[mfilename,'(15)']);
         Pos = get(G_WASH(3),'Position');
         set(G_WASH(3),'Position',[Pos(1:2),265,240],'Resize','off');

         uicontrol('Style','frame','BackgroundColor',[1,1,1],'Position',[6,6,253,228]);
         Strings = {'Usage','1.  Open a file with','2.  Use','to select a format preset.',...
            '3.  Then press','to format the file.','4.','and','switch the view between',...
            'the original and formatted files.','5.  Press','to save the formatted file.',...
            'See the M-file info for detailed documentation.'};
         Positions = [14,208,120,20;18,187,110,20;18,159,35,20;136,159,120,20;
            18,131,70,20;154,131,90,20;18,101,20,20;67,101,25,20;122,101,135,20;
            34,76,210,20;18,48,48,20;100,48,140,20;14,10,230,20];

         for k = 1:13
            h(k) = uicontrol('Style','text','String',Strings{k},'Position',...
               Positions(k,:),'HorizontalAlignment','left','BackgroundColor',[1,1,1]);
         end

         h(2) = uicontrol('Style','pushbutton','String','','CData',GetIcon(1),...
            'Position',[112,187,26,26]);
         h(3) = uicontrol('Style','pushbutton','String','','CData',GetIcon(4),...
            'Position',[91,131,58,26]);
         h(4) = uicontrol('Style','pushbutton','String','','CData',GetIcon(6),...
            'Position',[38,101,26,26]);
         h(5) = uicontrol('Style','pushbutton','String','','CData',GetIcon(7),...
            'Position',[92,101,26,26]);
         h(6) = uicontrol('Style','pushbutton','String','','CData',GetIcon(2),...
            'Position',[68,48,26,26]);

         uicontrol('Style','popupmenu','String','Standard','Position',[58,164,75,18],...
            'BackgroundColor',[1,1,1]);

         set(h(1),'FontWeight','bold');
         set(h(2:6),'BackgroundColor',DlgColor);
      end
   case 14
      closereq;
      G_WASH(2) = nan;
   case 15
      closereq;
      G_WASH(3) = nan;
   end
end
return;

function Img = GetIcon(Num)
global G_WASH
DlgColor = get(G_WASH(1),'Color');
Spr={['2%!")*Bb$^b!b-RA#ZE!@*B)#ZC2@*D)DZC*2%6F!(&RSc%!~dZ1!a&BQ"R?!N)!]"R@!N)!]"!@!B',...
'$!:c#g'],['2%!"$)cBjZbAabI!b+RA#^I!b+RA#^I!)+R3abIab[bAd~fRb1!^$b#RQ!^-!b#RQ!^-!b\RQ',...
'0!*!_bg'],['2("#&(+,pplVb0NA2^Q6b-WA2^]Ra1_j1~iigB"!a"Bb!Z1!a"!)g~jQVb-_bTbQ_b]p@ab"',...
'aA!b)Rb"a]Zm1'],['2%!"#%jRb1^S$bZR?0>D$)RR$*^)!a$ii!a1B*!*#!D!BfB)!%#!C!2*!Z"dR1!%eR',...
'1!%c"!B1!%c"!B1e:!2+!6#!G!B1dRA!2*!~cBb)Zb"aABb)Zb"aA!a)Jb$!^)!a$!Y!R*!>c0iiiiiiiiii',...
'g'],['2&!"#%+>!B*!*#!#Z1$^$!X0JO)A]MaaMQb\]j@WE9_Zb1^b$~idB^"6ABZ)5bS[A>b)YbS"!^b"^A',...
'2b)d~g*c)!:$!M!2)!Jc%iie'],['2%!"#%ea]jabQMa]PbP\QQb]Mb^\1ab$j!Z1!a$Bbd~i^)!b&SAA^9%',...
'b"!@AJY!ZScAid'],['2%!"#%ea]jabQMa]LbP]QQa]Mb^a1ab$j!Z1!a$Bbd~h0^9%b&SA0^)!b_"@2JY)Z',...
'"c"!R)!%g'],'2$!+-iRc@!R%!%:$"Y2:.^$!@c$ie~i!"e$gBF"dC!B%ie'};
Pal = [DlgColor;0,0,0;.5,.5,.5;.9,.9,.9;1,1,1;.7,0,0;1,0,0;.6,.6,0;1,1,.6;0,0,.5;
   0,0,1;.7,.8,.7];
Spr = Spr{Num};
M='error(''Sprite data corrupt.'')';
EC=char([33:38,40:95,97:126]); DC(double(EC))=1:92; D=0:63; bit=2.^(1:6)';
D=round(rem(D(ones(6,1),:),bit(:,ones(1,64)))./bit(:,ones(1,64)));
H=DC(double(Spr(1)))-1;N=DC(double(Spr(2)))-1;
C=DC(double(Spr(2+(1:N))));T=[Spr(3+N:end),'~'];
for k=2:8,T=strrep(strrep(T,EC(63+k),EC(ones(1,k))),EC(70+k),EC(64*ones(1,k)));end
E=DC(double(T));F=find(E==length(EC));
eval('Img=D(:,E(1:F(1)-1));',M);
for k=1:ceil(log2(N))-1,eval('Img=Img+D(:,E(F(k)+1:F(k+1)-1))*2^k;',M);end
Img=C(Img(1:floor(size(Img,2)*6/H)*H)+1);
Img=reshape([Pal(Img,1),Pal(Img,2),Pal(Img,3)],H,prod(size(Img))/H,3);
return;
