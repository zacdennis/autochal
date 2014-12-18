% BUILDDATAVIEWERCS Constructs C# code for building a textual data viewer 
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BuildDataViewerCS:
%     <Function Description> 
% 
% SYNTAX:
%	[filename] = BuildDataViewerCS(lst2write, structname, namespace, fldrSave, flgOpenAfterBuild)
%	[filename] = BuildDataViewerCS(lst2write, structname, namespace, fldrSave)
%	[filename] = BuildDataViewerCS(lst2write, structname, namespace)
%
% INPUTS: 
%	Name                Size        Units		Description
%   lst2write           {M x 2}     [N/A]       List of Data to write to .cs file
%    {:,1}              'string'    [char]      Reference Variable Name
%    {:,2}              [1]         [int]       Size of Variable
%    {:,3}              'string'    [char]      Variable's units
%    {:,4}              'string'    [char]      Additional Notes
%	structname          'string'    [char]      C# structure name
%	namespace	        'string'    [char]      C# namespace to reference
%	fldrSave	        'string'    [char]      Folder in which to save
%                                                file.  Default: pwd
%	flgOpenAfterBuild	[1]         [boolean]	Open file after it has been
%                                                 written? Default: true
% OUTPUTS: 
%	Name                Size		Units		Description
%	filename	        'string'    [char]      Name of file created
%
% NOTES:
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[filename] = BuildDataViewerCS(lst2write, structname, namespace, fldrSave, flgOpenAfterBuild, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit BuildDataViewerCS.m">BuildDataViewerCS.m</a>
%	  Driver script: <a href="matlab:edit Driver_BuildDataViewerCS.m">Driver_BuildDataViewerCS.m</a>
%	  Documentation: <a href="matlab:winopen(which('BuildDataViewerCS_Function_Documentation.pptx'));">BuildDataViewerCS_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/737
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function filename = BuildDataViewerCS(lst2write, structname, namespace, fldrSave, flgOpenAfterBuild)

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

if((nargin < 5) || isempty(flgOpenAfterBuild))
    flgOpenAfterBuild = true;
end

if((nargin < 4) || isempty(fldrSave))
    fldrSave = pwd;
end

strDGV = 'dataGridViewer';

%% Write the Actual '.cs' File
hd = pwd;
cd(fldrSave);
filename = [structname '.cs'];
fp = fopen(filename, 'w');

fprintf(fp, '%s\n','/**********************************************************************');
fprintf(fp, '%s\n','*                 NORTHROP GRUMMAN PROPRIETARY LEVEL I                *');
fprintf(fp, '%s\n','*                                                                     *');
fprintf(fp, '%s\n','*      NGC Aerospace Systems (NGAS)                                   *');
fprintf(fp, '%s\n','*      VMS & GNC 9V51                                                 *');
fprintf(fp, '%s\n','*      El Segundo, CA 90245                                           *');
fprintf(fp, '%s\n','*                                                                     *');
fprintf(fp, '%s\n','*      This .cs file was auto-generated using BuildDataViewerCS.m     *');
fprintf(fp, '%s\n','/**********************************************************************/');
fprintf(fp, '%s\n','using System;');
fprintf(fp, '%s\n','using System.Collections.Generic;');
fprintf(fp, '%s\n','using System.Text;');
fprintf(fp, '%s\n','using System.Runtime.InteropServices;');
fprintf(fp, '%s\n','using System.Drawing;');
fprintf(fp, '%s\n','using System.IO;');
fprintf(fp, '%s\n','using System.Runtime.Serialization.Formatters.Binary;');
fprintf(fp, '%s\n','using System.Net;');
fprintf(fp, '%s\n','using System.Windows.Forms;');
fprintf(fp, '\n');
fprintf(fp, 'namespace %s\n', namespace);
fprintf(fp, '{\n');

% Loop Through the Sorted List:
numSignals = size(lst2write, 1);
numCols    = size(lst2write, 2);
flgNotes = (numCols > 3);

%% Build Structure:
fprintf(fp, '    [StructLayout(LayoutKind.Sequential, Pack = 1)]\n');
fprintf(fp, '    public struct %s\n', structname);
fprintf(fp, '    {\n');
ictr = 0;
for iSignal = 1:numSignals
    strElement = lst2write{iSignal, 1};
    numElement = lst2write{iSignal, 2};
    strUnits   = lst2write{iSignal, 3};
    if(isempty(strfind(strElement, '%')))
            
        for iElement = 1:numElement;
            ictr = ictr + 1;
            if(numElement > 1)
                str2write = sprintf('%s%d', strElement, iElement);
                strID = sprintf('%s[%d]', strElement, iElement);
            else
                str2write = strElement;
                strID = strElement;
            end
            
            fprintf(fp, '        /// <summary>\n');
            fprintf(fp, '        /// %d: %s, %s\n', ictr, strID, strUnits );
            fprintf(fp, '        /// </summary>\n');
            fprintf(fp, '        public double %s;\n', str2write);
            fprintf(fp, '\n');
        end
    end
end

fprintf(fp, '\n');
fprintf(fp, '        public byte[] ToBytes()\n');    
fprintf(fp, '        {\n');
fprintf(fp, '            return ToBytes(this);\n');
fprintf(fp, '        }\n');

fprintf(fp, '\n');
fprintf(fp, '        public static byte[] ToBytes(%s data)\n', structname);    
fprintf(fp, '        {\n');
fprintf(fp, '            return Serialization.ToBytes((object)data, typeof(%s));\n', structname);
fprintf(fp, '        }\n');

fprintf(fp, '\n');
fprintf(fp, '        public static %s FromBytes(byte[] bytes)\n', structname);    
fprintf(fp, '        {\n');
fprintf(fp, '            return (%s)Serialization.FromBytes(bytes, typeof(%s));\n', structname, structname);
fprintf(fp, '        }\n');
fprintf(fp, '    }\n');
%fprintf(fp, '}\n');

%% Initialization Function:
numCells = 0;
for iSignal = 1:numSignals
    numElement = lst2write{iSignal, 2};
    
    if(~isempty(numElement))
        numCells = numCells + numElement;
    end
end

fprintf(fp, '\n');
fprintf(fp, '    public partial class %s_Functions\n', structname);
fprintf(fp, '    {\n');


%% Update Function:
fprintf(fp, '        public static void InitializeListBox(CheckedListBox cLB)\n');
fprintf(fp, '        {\n');
fprintf(fp, '           cLB.Items.Clear();\n');

% Loop Through the Sorted List:
ictr = 0;
for iSignal = 1:numSignals
    strElement = lst2write{iSignal, 1};
    numElement = lst2write{iSignal, 2};
    %strUnits   = lst2write{iSignal, 3};
    if(isempty(strfind(strElement, '%')))
            
        for iElement = 1:numElement;
            if(numElement > 1)
                str2write = sprintf('%s%d', strElement, iElement);
            else
                str2write = strElement;
            end
            fprintf(fp, '           cLB.Items.Add("%s");\n', str2write);
            ictr = ictr + 1;
        end
    end
end

fprintf(fp, '        }\n');
fprintf(fp, '\n');
fprintf(fp, '\n');


%%
fprintf(fp, '        public static void InitializeDataGridViewer(DataGridView dataGridViewer)\n');
fprintf(fp, '        {\n');
ictr = 0;
fprintf(fp, '           %s.Rows.Clear();\n', strDGV);
fprintf(fp, '           %s.ColumnCount = 4;\n', strDGV);
fprintf(fp, '           %s.Rows.Add(%d);\n', strDGV, numCells);
fprintf(fp, '\n');

for iSignal = 1:numSignals
    strElement = lst2write{iSignal, 1};
    numElement = lst2write{iSignal, 2};
    strUnits   = lst2write{iSignal, 3};
    
    if(flgNotes)
        strNotes = lst2write{iSignal, 4};
    else
        strNotes = '';
    end
    
    if(isempty(strfind(strElement, '%')))
            
        for iElement = 1:numElement;
            
            if(numElement > 1)
                str2write = sprintf('%s%d', strElement, iElement);
            else
                str2write = strElement;
            end
            
            fprintf(fp, '           %s.Rows[%d].Cells[0].Value = "%s";\n', strDGV, ictr, str2write);
            fprintf(fp, '           %s.Rows[%d].Cells[1].ValueType = typeof(double);\n', strDGV, ictr);
            fprintf(fp, '           %s.Rows[%d].Cells[1].Value = 0;\n', strDGV, ictr);
            fprintf(fp, '           %s.Rows[%d].Cells[2].ValueType = typeof(string);\n', strDGV, ictr);
            fprintf(fp, '           %s.Rows[%d].Cells[2].Value = "%s";\n', strDGV, ictr, strUnits);
            fprintf(fp, '           %s.Rows[%d].Cells[3].ValueType = typeof(string);\n', strDGV, ictr);
            fprintf(fp, '           %s.Rows[%d].Cells[3].Value = "%s";\n', strDGV, ictr, strNotes);           
            fprintf(fp, '\n');
            ictr = ictr + 1;
        end
    end
end

fprintf(fp, '        }\n');
fprintf(fp, '\n');
fprintf(fp, '\n');

%% Update Function:
fprintf(fp, '        public static void UpdateDataGridViewer(DataGridView dataGridViewer, ref %s data)\n', structname);
fprintf(fp, '        {\n');

% Loop Through the Sorted List:
ictr = 0;
for iSignal = 1:numSignals
    strElement = lst2write{iSignal, 1};
    numElement = lst2write{iSignal, 2};
    if(isempty(strfind(strElement, '%')))
            
        for iElement = 1:numElement;
            if(numElement > 1)
                str2write = sprintf('%s%d', strElement, iElement);
            else
                str2write = strElement;
            end
            fprintf(fp, '           %s.Rows[%d].Cells[1].Value = data.%s;\n', strDGV, ictr, str2write);
            ictr = ictr + 1;
        end
    end
end

fprintf(fp, '        }\n');
fprintf(fp, '\n');
fprintf(fp, '\n');


%% Retrieve Function:
fprintf(fp, '        public static void GetDataFromGridViewer(DataGridView dataGridViewer, ref %s data)\n', structname);
fprintf(fp, '        {\n');

% Loop Through the Sorted List:
ictr = 0;
for iSignal = 1:numSignals
    strElement = lst2write{iSignal, 1};
    numElement = lst2write{iSignal, 2};
    if(isempty(strfind(strElement, '%')))
            
        for iElement = 1:numElement;
            
            if(numElement > 1)
                str2write = sprintf('%s%d', strElement, iElement);
            else
                str2write = strElement;
            end
            fprintf(fp, '           data.%s = Convert.ToDouble(%s.Rows[%d].Cells[1].Value);\n', str2write, strDGV, ictr);
            ictr = ictr + 1;
        end
    end
end

fprintf(fp, '        }\n');
fprintf(fp, '\n');
fprintf(fp, '\n');


%% Save Function:
fprintf(fp, '        public static void SaveToTextfile(string default_filename, ref %s data)\n', structname);
fprintf(fp, '        {\n');


fprintf(fp, '            SaveFileDialog DialogSave = new SaveFileDialog();\n');
fprintf(fp, '            DialogSave.Filter = "Text file (*.txt)|*.txt|XML file (*.xml)|*.xml|All files (*.*)|*.*";\n');
fprintf(fp, '            DialogSave.AddExtension = true;\n');
fprintf(fp, '            DialogSave.RestoreDirectory = true;\n');
fprintf(fp, '            DialogSave.FileName = default_filename;\n');
fprintf(fp, '            DialogSave.Title = "Where do you want to save the file?";\n');
fprintf(fp, '\n');
fprintf(fp, '            if (DialogSave.ShowDialog() == DialogResult.OK)\n');
fprintf(fp, '            {\n');

fprintf(fp, '               TextWriter tw = new StreamWriter(DialogSave.FileName);\n');

maxLength = 0;
for iSignal = 1:numSignals
    strElement = lst2write{iSignal, 1};
    numElement = lst2write{iSignal, 2};
    if(isempty(strfind(strElement, '%')))
            
        for iElement = 1:numElement;
            
            if(numElement > 1)
                str2write = sprintf('%s%d', strElement, iElement);
            else
                str2write = strElement;
            end
            maxLength = max(maxLength, length(str2write));
        end
    end
end


% Loop Through the Sorted List:
for iSignal = 1:numSignals
    strElement = lst2write{iSignal, 1};
    numElement = lst2write{iSignal, 2};
    if(isempty(strfind(strElement, '%')))
            
        for iElement = 1:numElement;
            
            if(numElement > 1)
                str2write = sprintf('%s%d', strElement, iElement);
            else
                str2write = strElement;
            end
            strPadding = spaces(maxLength - length(str2write));
            fprintf(fp, '               tw.WriteLine("%s%s = " + data.%s);\n', str2write, strPadding, str2write);
        end
    end
end

fprintf(fp, '               tw.Close();\n');
fprintf(fp, '\n');
fprintf(fp, '               MessageBox.Show("%s saved to: " + DialogSave.FileName);\n', structname);
fprintf(fp, '           }\n');
fprintf(fp, '\n');
fprintf(fp, '            DialogSave.Dispose();\n');
fprintf(fp, '            DialogSave = null;\n');
fprintf(fp, '        }\n');
fprintf(fp, '\n');
fprintf(fp, '\n');

%% Export Values to XML Function:
fprintf(fp, '        public static void ExportToXML(string default_filename, ref %s data)\n', structname);
fprintf(fp, '        {\n');


fprintf(fp, '            SaveFileDialog DialogSave = new SaveFileDialog();\n');
fprintf(fp, '            DialogSave.Filter = "XML file (*.xml)|*.xml|All files (*.*)|*.*";\n');
fprintf(fp, '            DialogSave.AddExtension = true;\n');
fprintf(fp, '            DialogSave.RestoreDirectory = true;\n');
fprintf(fp, '            DialogSave.FileName = default_filename;\n');
fprintf(fp, '            DialogSave.Title = "Where do you want to save the file?";\n');
fprintf(fp, '\n');
fprintf(fp, '            if (DialogSave.ShowDialog() == DialogResult.OK)\n');
fprintf(fp, '            {\n');

fprintf(fp, '               TextWriter tw = new StreamWriter(DialogSave.FileName);\n');

% Write Header Section
fprintf(fp, '               tw.WriteLine("<!--");\n');
fprintf(fp, '               tw.WriteLine("    Northrop Grumman Proprietary Level I");\n');
fprintf(fp, '               tw.WriteLine("    NGC Aerospace Systems");\n');
fprintf(fp, '               tw.WriteLine("    VMS & GNC (Dept 9V51)");\n');
fprintf(fp, '               tw.WriteLine("-->");\n');
fprintf(fp, '               tw.WriteLine("<doublestream name=\\"%s\\">");\n', structname);

% Loop Through the List:
flgAddDefaults = 1;

ictr = 0;
for iSignal = 1:numSignals
    strElement = lst2write{iSignal, 1};
    numElement = lst2write{iSignal, 2};
    strUnits   = lst2write{iSignal, 3};
    if(isempty(strfind(strElement, '%')))
        line2write = sprintf('	<point index=\\"%d\\" name=\\"%s\\" count=\\"%d\\" units=\\"%s\\"', ictr, strElement, numElement, strUnits);
        
        if(flgAddDefaults)
            if(numElement == 1)
                line2write = sprintf('%s default=\\"" + data.%s + "\\"', line2write, strElement);
            else
                % Time to get fancy...
                line2write = sprintf('%s default=\\""', line2write);
                for iElement = 1:numElement
                    if(iElement < numElement)
                        line2write = sprintf('%s + data.%s%d + ","', line2write, strElement, iElement);
                    else
                        line2write = sprintf('%s + data.%s%d + "\\"', line2write, strElement, iElement);
                    end
                end
            end
        end

        line2write = sprintf('%s/>', line2write);
        
        fprintf(fp, '               tw.WriteLine("%s");\n', line2write);
        ictr = ictr + numElement;
    end
end

fprintf(fp, '               tw.WriteLine("</doublestream>");\n');
fprintf(fp, '               tw.Close();\n');
fprintf(fp, '\n');
fprintf(fp, '               MessageBox.Show("Values in %s saved to: " + DialogSave.FileName);\n', structname);
fprintf(fp, '           }\n');
fprintf(fp, '\n');
fprintf(fp, '            DialogSave.Dispose();\n');
fprintf(fp, '            DialogSave = null;\n');
fprintf(fp, '        }\n');
fprintf(fp, '\n');
fprintf(fp, '\n');


%% File Parse Function:
fprintf(fp, '       public static void LoadDataFromTextfile(string fileFullPath, ref %s data)\n', structname);
fprintf(fp, '       {\n');
fprintf(fp, '          if (File.Exists(fileFullPath))\n');
fprintf(fp, '          {\n');
fprintf(fp, '              FileStream fs = new FileStream(fileFullPath, FileMode.Open, FileAccess.Read, FileShare.Read);\n');
fprintf(fp, '              StreamReader sr = new StreamReader(fs);\n');
fprintf(fp, '\n');
fprintf(fp, '              char[] splitter = new char[] { '' '', ''='', ''\\n'', ''\\t'' };\n');
fprintf(fp, '              string line = "";\n');
fprintf(fp, '\n');
fprintf(fp, '              while (!sr.EndOfStream)\n');
fprintf(fp, '              {\n');
fprintf(fp, '                  line = sr.ReadLine();\n');
fprintf(fp, '                  string[] substrings = line.Split(splitter, StringSplitOptions.RemoveEmptyEntries);\n');
fprintf(fp, '\n');
fprintf(fp, '                  if (substrings.Length == 2)\n');
fprintf(fp, '                  {\n');
fprintf(fp, '                      try\n');
fprintf(fp, '                      {\n');
fprintf(fp, '                          double value = 0;\n');
fprintf(fp, '                          double.TryParse(substrings[1], out value);\n');
fprintf(fp, '\n');

% Loop Through the Sorted List:
numSignals = size(lst2write, 1);
ictr = 0;

for iSignal = 1:numSignals
    strElement = lst2write{iSignal, 1};
    numElement = lst2write{iSignal, 2};
    if(isempty(strfind(strElement, '%')))
            
        for iElement = 1:numElement;
            ictr = ictr + 1;
            if(numElement > 1)
                str2write = sprintf('%s%d', strElement, iElement);
            else
                str2write = strElement;
            end
            
            fprintf(fp, '                          if (substrings[0].Equals("%s", StringComparison.CurrentCultureIgnoreCase))\n', str2write);
            fprintf(fp, '                              data.%s = value;\n', str2write);
            fprintf(fp, '%s\n', ' ');

        end
    end
end

fprintf(fp, '                        }\n');
fprintf(fp, '                        catch\n');
fprintf(fp, '                        {\n');
fprintf(fp, '                        }\n');
fprintf(fp, '                    }\n');
fprintf(fp, '                }\n');
fprintf(fp, '            }\n');
fprintf(fp, '\n');
%fprintf(fp, '            return data;\n');
fprintf(fp, '        }\n');

%% Final Wrap Up


fprintf(fp, '    }\n');
fprintf(fp, '}\n');

fclose(fp);
cd(hd);

disp(sprintf('%s : ''%s'' has been created in %s', mfilename, filename, fldrSave));
if(flgOpenAfterBuild)
    edit(filename);
end


end % << End of function BuildDataViewerCS >>

%% REVISION HISTORY
% YYMMDD INI: note
% 120126 MWS: Cleaned up file to with CSA formatting
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
