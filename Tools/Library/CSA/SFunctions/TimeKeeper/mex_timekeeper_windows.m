% Use this script to mex the timekeeper.c file for Windows

hd = pwd;
cd(fileparts(mfilename('fullpath')));
mex -DWINDOWS timekeeper.c
disp(sprintf('%s : Mex Complete!', mfilename));
cd(hd); clear hd;