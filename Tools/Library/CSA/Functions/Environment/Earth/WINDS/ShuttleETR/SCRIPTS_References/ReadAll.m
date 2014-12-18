%% File to load in all the ETR wind data and save MAT files:
%% NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I

if(1)
    ETR_Wind.jan = ReadWindMonth('jan.xls');
    ETR_Wind.feb = ReadWindMonth('feb.xls');
    ETR_Wind.mar = ReadWindMonth('mar.xls');
    ETR_Wind.apr = ReadWindMonth('apr.xls');
    ETR_Wind.may = ReadWindMonth('may.xls');
    ETR_Wind.jun = ReadWindMonth('jun.xls');
    ETR_Wind.jul = ReadWindMonth('jul.xls');
    ETR_Wind.aug = ReadWindMonth('aug.xls');
    ETR_Wind.sep = ReadWindMonth('sep.xls');
    ETR_Wind.oct = ReadWindMonth('oct.xls');
    ETR_Wind.nov = ReadWindMonth('nov.xls');
    ETR_Wind.dec = ReadWindMonth('dec.xls');
end

save ETR_Wind_Year;
disp('Saved file to ETR_Wind_Year');
