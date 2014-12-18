% This M-File documents the installation and usage of the IADS 'Mex' data interface
% for Matlab. The library or 'Mex' file that contains the code to interface to
% your existing IADS data archives (files) is contained within the file 
% 'iadsread.dll'. Proper installation of the 'iadsread.dll' file will add a function
% to matlab called 'iadsread', allowing you to programmatically access your Iads
% archive data. You will then be able to write Matlab programs to read in and process
% the storehouse of flight data you have saved with IADS.
%
%
% To install 'iadsread.dll' file, just create a folder at your Iads root 
% installation directory (i.e. C:\Program Files\Iads\) called 'MatlabExtension' (if it's not already there) 
% Now, copy the 'iadsread.dll' file to this directory; Or install the dll using
% your IADS installation CD. Then you will need to add this directory
% to your Matlab path. To do this, run Matlab. Under the Matlab 'File' dropdown
% choose the option 'Set Path'. A new window will appear titled 'Set Path'. 
% Click on the button 'Add Folder'. When the folder browser dialog appears, 
% choose the 'MatlabExtension' directory that you created in the first step.
% (i.e. C:\Program Files\Iads\MatlabExtension). Click the 'Save' button to save the 
% path, and then 'Close' to close the 'Add Path' window.

% Ok! To test that the 'iadsread' function is ready to go just type:

iadsread

% It should respond with something like:
% ??? iadsread: Minimum 4 inputs required. 
%   iadsread( 'DataDirectory or ServerName', 'IrigStartTime', 'IrigEndTime' or NumSeconds, 'ParameterNameList (Comma Separated)', [optional arguments..] )
%
% Actually, this is correct! This means that your mex file is properly hooked up
% and erroring because the function call arguments are not quite complete.... 
%
% If Matlab returns with  "??? Undefined function or variable 'iadsread'." 
% your path is not set correctly. Make sure your path is set and saved to the directory where you copied iadsread.dll.


%
% Let's look at each argument in turn. 
% Argument 1) DataDirectory or ServerName$PortId 
%    This string defines the source data directory of the Iads archive data for your Flight.
%    Most flight data is arranged in a system of directories by flight/test/tail or date
%    on a server within your local network. The specific location is group dependent.
%    Use your 'Explorer' to locate the directory of your choice. Then just simply copy the directory 
%    from the top of explorer into Matlab.
%    The value should be your FULL directory path (with drive letter) to your Iads archive data
%    My data directory for this example is:  D:\PostFlightData\Demo
%
%    Another option is to specify a server name and port id in the format 'ServerName$PortId' to connect iadsread directly
%    to a real-time data stream in the CDS or PostTestDataServer. There is example code on this subject below.

% Argument 2) IrigStartTime
%    This string argument is the start time of the data that you want to import. The 
%    Format of the string is and Irig time in the format DDD:HH:MM:SS.MS   
%    That's a 3 digit day (0-364), a two digit hour (0-23), a two digit minute (0-59)
%    a two digit second (0-59), and a partial second (MS) up to 9 digits long.
%
%    This time will most likely be optained from your flight notes or the Iads EventMarker
%    Log. Eventually, this interface will have the ability to supply you with your maneuver 
%    start/end times for each flight. Let me know if you have any other ideas.

% Argument 3) IrigEndTime or NumSeconds
%    This string argument is the end time of the data that you are interested in. The 
%    Format of the string is and Irig time in the format DDD:HH:MM:SS.MS again. Your other
%    alternative to is just to specify a "scalar" number of seconds. You could, for example,
%    get 10 seconds of data from a given start time. 

% Argument 4) ParameterNameList
%    This string argument is a list of comma seperated parameter names that you want to
%    to import data from. For example, you could import ome aircraft "Wing" parameters by
%    defining a list like: 'AW0001X,AW0002X,AW0003X". Notice the name is the "Parameter"
%    name defined in the config file's "ParameterDefaults Table" (usually the parameter code)
%
%    Note: All filtering and nulling that was set in the ParameterDefaults entry for the 
%    specified parameter is applied before the data is returned to Matlab. Spike detection and wild 
%    point corrections are *not* applied as of this date. We may consider having this as an option.
%
%    One more option is being considered for next build:
%    * The DataGroupName option will allow you to access a group of parameters defined in
%    your config file under the DataGroup table.

% Argument 5) [optional]Start of Matlab style "Param/Value pairs" (optional settings)
%
%             'DecimationFactor', factor 1..N (Defaults to 1 which denotes no decimation).
%
%                This gives you the ability to reduce the amount of data from the actual parameter's update rate. If not 
%                defined, it defaults to 1 (no decimation). The decimation is always based on the largest sample rate of the 
%                parameters defined in Argument 4. For example, If you wanted a matrix of data that represents half of the original
%                data, you would enter 2. 
%
%                Decimation only removes data points using a "Decimal Sub-Sample' of your original data (i.e. skips every N points).
%                No other inperpolation method (such as linear or bspline interpolation ) is currently used.
%
%                Be aware, if you use this option, you do have the possibility of removing data that is important to your analysis.
%
%             'OutputSampleRate', sampleRate (Defaults to highest sample rate of parameters chosen. Trumps DecimationFactor).
%
%                Similar to Decimation factor above, but specifies the exact ouput sample rate desired                                 
%                    
%             'ReturnDataAtSameSR', 0=False 1=True (Defaults to True)
%
%                Controls whether the data is interpreted to same sample rate as defined by DecimationFactor or OutputSampleRate
%                By default, the iadsread function "squares off" the data to same sample rate making it easier to analyze. If this option is set
%                to 0 (False) then each vector is output at it's native sample rate and thus the lengths of each vector may vary.                                 
%                In this state, the interpolation/correlation is left to the user code.
%                
%             'ReturnTimeVector', 0=False 1=True (Defaults to False)
%
%                Controls whether a time vector is returned along with the data vector(s). The vector contains current time for each element of the
%                corresponding data vector elements. If ReturnDataAtSameSR=False then returns time/data in a struct (not implemented yet)
%
%             'ExceptionOnNoData', 0=False 1=True (Defaults to True)
%             
%                Determines whether iadsread throws an error/exception if it's unable to get data for a given parameter. If False, returns empty 
%                Vector or if Matrix fills column with NaN
%
% An example of using optional args is as follows: 
%     iadsread( directory, '001:01:01.000', 5, 'Param1,Param2,Param3', 'DecimationFactor', 4, 'ReturnTimeVector', 1 )
%
%

% Ok, let's proceed to a concrete example... Let's get some information on data from
% an Iads archive using 'iadsread'. Find a directory on your system with Iads data using Microsoft Explorer, 
% Copy the directory name using <Ctrl C> and paste it into the <Insert Your Data Directory Here> below:

iadsread( '<Paste Your Data Directory Here>' )

% The system should respond with some information about the data within this 
% directory. It should look something similar to this:
%
%   StartTime = 318:17:37:52.393   StopTime = 318:21:58:51.518
%   DataDir = D:\PostFlightData\Demo
%   Flight = 100  Test = 100-ABC  Tail = 001
%   Date = 11/14/1998

% **New** 
% If you assign the output to a varaiable, it will return the results in a structure ('struct array')
% For instance:

a = iadsread( '<Paste Your Data Directory Here>' )

% would return a struct array where each field can be accessed by the 'dot' notation. 
% a.StartTime would return '318:17:37:52.393'


% Now, let's say you want to know what parameters are available in an archive.. 
% To achieve this we put a '?' (Question Mark) in the ParameterList (argument number 4)
% My line looks like this ->
% iadsread( 'D:\PostFlightData\Demo', '', 0, '?' )    (iadsread ignores contents of arguments 2 & 3)
% Type the line below into matlab inserting your own dir into the <Insert Your Data Directory Here> text

iadsread( '<Paste Your Data Directory Here>', '', 0, '?' )

% The system should respond with the list of parameters defined in your ParameterDefaults table
% It should look something like this:
% Parameters Available: 
% DV1, IABALT, IIIALT, IATASP, IAIASP, IAMNUM, IIPCHL, IATAOA, AA06, IIROLL, IITRUE

% **New** 
% Again, if you assign the output to a varaiable, it will return the results in a 'char array' of strings
% For instance:

a = iadsread( 'D:\PostFlightData\Demo', '', 0, '?' )

% would return all of the parameter names in a 'char array' named 'a'
% To access any individual parmameter name you would use the 'a(n,1:size(a,2))' notation, where n would be the row number 
% from 1 to 'size(a,1)'. See Matlab help for more info on the 'size' function.

%
% One more tool is the ability to look at the settings of an individual parameter. It's just a small difference
% from the last line. Put a '?' (Question Mark) in the ParameterList (argument number 4) then a <space>
% then the parameter name you want more information about...
% My line looks like this ->
% iadsread( 'D:\PostFlightData\Demo', '', 0, '? IABALT' )

% iadsread returns:
%
% Parameters Info on IABALT:
%
% ParameterDefaults = Import, Parameter = IABALT, ParamType = float, ParamGroup = Group 
% ParamSubGroup = ACState, ShortName = Altitude, LongName = , Units = ft 
% Color = 16711680, Width = 1, DataSourceType = Tpp, DataSourceArguement =  
% ....... (output continues...)
%

% **New** 
% As before, if you assign the output to a varaiable, it will return the results in a structure ('struct array')
% For instance:
a = iadsread( 'D:\PostFlightData\Demo', '', 0, '? IABALT' )

% Will return a structure in the variable 'a' as follows:
       ParameterDefaults: 'STRUCTURES'
               Parameter: 'PF5032'
               ParamType: 'float'
              ParamGroup: 'LOADS'
           ParamSubGroup: 'Door - Misc'
               ShortName: 'LIRCM Bay Pressure'
                LongName: 'LIRCM Bay Pressure'
                   Units: 'psi'
                   Color: 16711680
                   Width: 1
          DataSourceType: 'Tpp'
     DataSourceArguement: '1'
              UpdateRate: 49.3213
              LLNegative: -1000
              LLPositive: 1686
              (output continues...)
% 
% where each field can be accessed by the 'dot' notation. a.Units would return 'psi'
%


% Ok, let's move on to extracting actual flight data from an IADS archive.
% Up arrow on the keyboard until you get back to our first command below and press return
% We need the output from this statement for a reasonable startTime

iadsread( '<Your data directory will be here>' )

%
% iadsread returns:
%   StartTime = 318:17:37:52.393   StopTime = 318:21:58:51.518
%   DataDir = D:\PostFlightData\Demo
%   Flight = 100  Test = 100-ABC  Tail = 001
%   Date = 11/14/1998

% Just as an example, let's read the first 5.3 seconds of data from a couple of parameters
% Use the 'StartTime' string printed above as the value of argument 1. 
% Your second argument should be 5.5 (or any number of seconds)
% Your third argument should be a list of comma seperated parameter names. Pick parameter names from the list returned above...
% My line looks something like this ->
% a = iadsread( 'D:\PostFlightData\Demo', '318:17:37:52.393', 5.5, 'Sweep,SineWave10Hz,SineWave20Hz,SineWave30Hz,SineWave40Hz' )
% Type the line below into matlab inserting your own dir, starttime, and parameter list 

a = iadsread( '<Insert Your Data Dir Here>', '<Insert StartTime Here>', 5.5, '<Your Parameter List>' )

% Hint: If you have an error getting data at this startTime, add a couple of minutes. Sometimes data for a given parameter
%       starts later than others...
%
% Alternatively, if you knew the actual StartTime and EndTime of your data, you could use it to define your
% data of interest. My line looks something like this ->
% a = iadsread( 'D:\PostFlightData\Demo', '318:17:40:53.393', '318:17:40:54.393', 'Sweep,SineWave10Hz,SineWave20Hz,SineWave30Hz,SineWave40Hz', 'DecimationFactor', 2 )
% I requested one second of data from the parameters defined in my list, and I wanted 
% the data at DecimationFactor of 2 (giving me every other point from the data).
a = iadsread( '<Insert Your Data Dir Here>', '<Insert StartTime Here>', '<Insert EndTime Here>', '<Your Parameter List>', 'DecimationFactor', 2 )

% If all is well, you'll get print out of the matrix. You can use Matlab's array editor
% (Just double-click on the array name in the workspace window) to view the data.
%

% Notice that all 5 parameters are combined into 1 matrx called 'a'. Thats because I assigned only ONE variable to the
% result of iadsread  a = iadsread(..).  Now, if you want the data in seperate vectors, you just define your left hand
% side of the equation appropriately. Here's an example below how to create 3 seperate vectors
[a,b,c] = iadsread( 'D:\PostFlightData\Demo', '318:17:40:53.393', 20, 'Sweep,SineWave10Hz,SineWave20Hz' );

% Vector 'a' will contain data from the 'Sweep' parameter, 'b' from the 'SineWave10Hz' parameter, and 'c' from 'SineWave20Hz'
%



% Writing a Matlab program to analyze data should be fairly simple, maybe something like this:
%
%
% Read in the data from IADS
% [Sweep,SineWave10Hz,SineWave20Hz,SineWave30Hz,SineWave40Hz] = iadsread( 'D:\PostFlightData\Demo', '318:17:40:53.393', '318:17:40:54.393', 'Sweep,SineWave10Hz,SineWave20Hz,SineWave30Hz,SineWave40Hz' )
%
% Call my analysis function with the resultant matrix from IADS
% b = myAnalysisFunction( Sweep, SineWave10Hz, SineWave20Hz, SineWave30Hz, SineWave40Hz )
%
% Now plot my results
% plot b     
%



%
% Here is another example of accessing data sequentially. Say you just wanted to stream
% through the entire flight worth of data for a number of parameters and plot them.
% What you have to do it call iadsread at least once with a valid start time (and
% you must use the NumSeconds option in argument 3). In you next call to iadsread, you 
% leave the StartTime string (argument 2) blank. This will tell iadsread that you wish
% to continue reading at the point you left off last. In the example below, the first call
% will read 10.0 seconds at time 318:17:40:53. Each sequential call with '' as the argument
% 3 value will return the next sequential 10.0 seconds of data.
%
% In order to make this work on your system, you'll have to modify arguments 1,2 & 4
% to the correct values for your archive
%
sweep = iadsread( 'D:\PostFlightData\Demo', '318:17:40:53', 10.0, 'Sweep' );
for j = 1 : 100
    plot( sweep );
    sweep = iadsread( 'D:\PostFlightData\Demo', '', 10.0, 'Sweep' );
    input( 'Press any key for next Plot' )
end


%
% Here is yet another example of accessing data sequentially. Say you just wanted to stream
% through the entire flight while connected to the IADS CDS or a PostTestDataServer. It's very similar
% to the last example except you'll leave the 'StartTime' field as an empty string and you'll set the 
% 1st argument (DataDirectory or ServerName$PortId) to the CDS or PostTestDataServer machine name and portId
% Don't forget to separate the ServerName and PortId by a $ (dollar sign)
% The default portId of the IADS CDS is 58000, so unless you've modified it in the setup bag this should work
% 
%
% In order to make this work on your system, you'll have to modify arguments 1 & 4
% to the correct values for your system setup
%
function testRealTime2()

for j = 1 : 100
    Press_Alt = iadsread( 'IADS-CDS$58000', '', 2.0, 'SineWave0-250' );
    plot( Press_Alt );
    pause( 1 ) 
end


% Well, that should be enough to get you started. If you have any questions or comments
% just email me at jim@iads-soft.com 
% Thanx,
% Jim




% ***New and advanced stuff to query info from the config file***
% There is now a new capability to query any piece of information in configuration file through the use of an SQL statement.
% To achieve this, we must first explain how write a simple SQL statement. 
% The basic format is: 'select <ColumnName or Comma Seperated ColumnNames> from <TableName> where <Conditional Statement>   
% (The 'where' statement is optional). In this format, the <ColumnName> refers to the name of the column in any Iads log 
% or in any ConfigTool window... Likewise, the <TableName> refers to the actual name of the log name or 'Table' name 
% in the ConfigTool.
%
% Ok, let's move right to a simple (but not very useful) example that extracts every column from every row in the 
% 'EventMarkerLog' table. If we want to get every row and column, we must use a 'wildcard' (an '*') for the column name,
% as well as no 'where' clause....

a = iadsread( 'D:\PostFlightData\Demo', '', 0, '? select * from EventMarkerLog' )

%
% iadsread returns:
% 79x1 struct array with fields:
%     Group
%     SubGroup
%     User
%     Time
%     Comment
%     PropertyBag

% Examining the first element of the struct array (i.e. the first row of the EventMarkerLog) :

a(1)

% Matlab returns:
%
%          Group: 'LOADS'
%       SubGroup: 'Maneuver Quality'
%           User: 'IadsUser2'
%           Time: '010:12:40:29.011'
%        Comment: 'E1  APU Start'
%    PropertyBag: []

% Each field can be accessed in the 'dot' notation. a.Time would return '010:12:40:29.011'
% As before, if you don't assign the output to a varaiable, it will print the results to the screen

% What if we were only concerned with the 'Time' column information? Let's limit our output to only the 'Time' column like so:

a = iadsread( 'D:\PostFlightData\Demo', '', 0, '? select Time from EventMarkerLog' )

a(1)

% Matlab returns:
% ans = 
%
%    time: '012:17:49:29.011'
%

% Now even more useful... What if we were only concerned with the 'Time' column information when a certain comment occured?
% Let's assume that we had a Comment in our 'EventMarkerLog' table that always contained the word 'Takeoff' and corresponded
% to the takeoff time of the aircraft. Let's limit our output to only the 'Time' column when the 'Comment' contained
% the word 'Takeoff'. Ok, this is where the 'where' clause comes into play. It is a conditional statement that
% will allow you to filter through the many rows of a table/log and find the specific row that you need. 
% The query would look something like:

a = iadsread( 'D:\PostFlightData\Demo', '', 0, '? select Time from EventMarkerLog where Comment = ''*Takeoff*'' ' )

% Look at the 'where' clause above....where Comment = ''*Takeoff*''.... Confusing, isn't it? First of all, the Iads' 
% SQL query statement requires that all strings in the 'where' clause be single quoted... But this confuses Matlab 
% because it already requires a single quote for it's string arguments into iadsread. To make a long story short, 
% we need two single quotes around the where clause 'Takeoff' string. We also need to use a 'Wildcard' match, placing
% asterixes '*' around the word 'Takeoff'. This tells iadsread to match any comment that has 'Takeoff' anywhere 
% in it...(i.e. 'E10  Takeoff Blah blah' matches)
% 
% iadsread returns
% a = 
%    time: '012:18:41:19.247'

a.time

% Matlab returns:
% ans =
%    012:18:41:19.247
%
%

% Thus the takeoff time of the aircraft is '012:18:41:19.247'
%

% Just remember, you can get to any piece of data in the config file now....
% If you need me to write your SQL statement or explain further, email me at jim@iads-soft.com...  
% Thanx,
% Jim


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% More examples.......
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Test Streaming data for the entire flight into a processing function
%

iadsDataInfo = iadsread( 'D:\PostFlightData\MyIadsDataDirectory' )

% This returns a struct array where each field can be accessed by the 'dot' notation.
% Choices are StartTime, StopTime, DataDir, Flight, Test, Tail, and Date 
% iadsDataInfo.StartTime would return for example: '318:17:37:52.393'

% Set block size to read.. Basically, the number of seconds to read for each computation
blockSizeInSecondsToRead = 10

% Process all the data for a given set of parameters. Fetch the next Matrix of data using iadsread until the end it reached

MyParameterList = 'Param1,Param2,Param3,Param4';
done = 0;
startTime = iadsDataInfo.StartTime;
while ( done == 0 )
    try
       data = iadsread( 'D:\PostFlightData\MyIadsDataDirectory', startTime, blockSizeInSecondsToRead, MyParameterList );
       processTheData( data );
       startTime = "";
    catch
       done = 1;
    end
end