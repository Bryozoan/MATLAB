%

%opens gui to find the location of DEM, in tif format
[sFile, sPath] = uigetfile('*.tif', 'Select Tif DEM');
sFullFile = fullfile(sPath, sFile);

%load geotif
[mTopo, R] = readgeoraster(sFullFile);

%ETOPO1 = flipud(ETOPO1); %not sure if this line is needed.

%this makes all points where we have no data be zero. this works because it
%apears as if nearly all, if not all data points that are missing are in
%the sea. 
mTopo(mTopo < 0) = 0;

%% We need a section here to "Finds the edges of the region of interest."
%I would maybe do this with a watershed funtion in GIS, and then have it
%pick the eastern one... Ask bickmore about this. 
%% this is suppose to pick reasonable control points... what does that mean?
%are you trying to tell me that there is some intrisic value to these
%control points? maybe elevation over a certain point? IDK 


