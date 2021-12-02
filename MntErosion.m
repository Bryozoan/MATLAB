%
%% open geotiff file
%opens gui to find the location of DEM, in tif format
[sFile, sPath] = uigetfile('*.tif', 'Select Tif DEM');
sFullFile = fullfile(sPath, sFile);

%load geotif
[mTopo, R] = readgeoraster(sFullFile);

%ETOPO1 = flipud(ETOPO1); %not sure if this line is needed.
%% remove NaN equivelants
%this makes all points where we have no data be zero. this works because it
%apears as if nearly all, if not all data points that are missing are in
%the sea. 
mTopo(mTopo < 0) = 0;

%change mTopo to double
mTopo = double(mTopo);

% median filter the image 
mTopofil = medfilt2(mTopo, [5 5]);


%meshlsrm(mTopo,R);
[LON, LAT] = meshgrid(R.LongitudeLimits(1)+R.CellExtentInLongitude*.5:R.CellExtentInLongitude:R.LongitudeLimits(2)-R.CellExtentInLongitude*.5, ...
    R.LatitudeLimits(1)+R.CellExtentInLongitude*.5:R.CellExtentInLatitude:R.LatgitudeLimits(2)-R.CellExtentInLatitude*.5);


surf(LON,LAT,mTopo)
coromap jet
shading interp
axis equal, view(0,90)
colorbar

%% create line to cutt off left side of island
y1 = 21.6093;
y2 = 21.4332;
x1 = -158.015; 
x2 = -158.107; 

m = (y2-y1)/(x2-x1);
b = y1 - (m*x1);

hold on
plot(m*[x1, x2] + b)

%make a matrix to cutt of above our line
mYonLine = m * LON + b;

%exclude values above cuttof line
mTopofil(LAT > mYonLine) = 0;

% set everything to zero to the right of the max elevation
for i = 1:size(mtopofil,1)
    vRow = mTopofil(i, :);
    dMaxRow = max(vRow);
    iIdx = find(vRow == dMaxRow, 1, 'last');
    vRow(iIdx + 1: end) = 0;
    mTopofil(i,:) = vRow;

end 

%calculate current island volume in (m)*(pixel area)
dArea = sum(mTopofil,"all");


%% this is suppose to pick reasonable control points... what does that mean?
%are you trying to tell me that there is some intrisic value to these
%control points? maybe elevation over a certain point? IDK 
 

