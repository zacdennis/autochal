This folder contains support utilities for Symvionics, Inc's IADS flight test display and analysis software.

From Symvionics Inc.'s website (http://iads.symvionics.com/), ...

"IADS is a Real Time and Post Test display and analysis software suite that supports multidiscipline testing in a single comprehensive package. IADS software facilitates Real Time mission analysis and raises situational awareness, safety monitoring, and test point clearance capabilities to a new level. This is accomplished by utilizing tools previously available only within Post Test environments. The IADS toolset includes high fidelity strip charts with threshold checking, frequency response plots with predicted data overlays, 2D and 3D moving maps, 3D models with system-wide visualization, XY plots with envelope calculations, and a test point system that allows the user to easily mark events and automate batch processing. All displays have the ability to instantly recall any portion of the test data for display and analysis without affecting Real Time data performance.

Utilizing an interactive interface, the engineer can easily create or customize displays, parameter definitions, analysis options and test setup in a matter of seconds. Derived equations can be added or modified on-the-fly for use throughout the system. Analysis options are easily selected using built-in property dialogs. All support data can be input using a familiar spreadsheet interface. This flexibility allows displays, data, and analysis techniques to be built, tested and saved with little effort at any time during the mission or at the engineer’s desktop. 
IADS ease of use, depth of display capability, and powerful analysis techniques can be used to save time and effort on any test program."

Notes:
Symvionics understands that engineers rely heavily on MATLAB (http://www.mathworks.com/) to post process (plot/filter/etc) flight test data.  To help facilitiate the post processing process, Symvionics has developed code that aids in loading in raw IADS data directly into MATLAB.  This means that if IADS is used to record flight test telemetry data, that data can be read directly into MATLAB for processing WITHOUT needed a separate IADS license.  This code, 'Beta version 8', was taken from the Google Groups website (http://groups.google.com/group/iads/about?pli=1) by Skye Otten back in October 2010.  Below are the Symvionics created files that have been added to the CSA Library for easy distribution.

1. HowTo.m
2. iadsread.mexw32
3. iadsread.mexw64

The rest of the files contained in this directory were created for the CSA_Library and are built up off of the Symvionics code.

Last Updated: 5 March 2012
Mike Sufana
mike.sufana@ngc.com
