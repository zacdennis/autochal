% Used to mex the sendsimIO S-function
% Note that the #define for windows and linux is all caps and is specified
% with the -D flag:
% -DWINDOWS or -DLINUX

hd = pwd;
cd(fileparts(mfilename('fullpath')));
mex -v -DWINDOWS Universal_UDP_send.c socket_multi.c
disp(sprintf('%s : Mex Complete.', mfilename));
cd(hd);
