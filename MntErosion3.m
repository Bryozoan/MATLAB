%% Open GeoTIFF File 
% this creates a dialog box to load the data.
[sFile1, sPath1] = uigetfile('*.tif', 'Select your data file');
%puts the path together in order to find the file address for whatever
%operating system it's running on
sFullFile1 = fullfile(sPath1, sFile1);
[A, R] = readgeoraster(sFullFile1); 
%load the first dataset from sFullFile1
%% Set NaN equivalents to zero (sea level)
A(A < 0) = 0;
%% Change A to double
A = double(A);
%% Median Filter the image(5x5 neighborhood)
Af = medfilt2(A, [5 5]);
%% Create line to cut off left side of island
m = (21.4332 - 21.6093) / (-158.107 + 158.015);
b = 21.4332 + (m*158.107);
%% Cut off left side
[LON,LAT] = meshgrid(R.LongitudeLimits(1)+R.CellExtentInLongitude*0.5:R.CellExtentInLongitude:R.LongitudeLimits(2)-R.CellExtentInLongitude*0.5,...
    R.LatitudeLimits(1)+R.CellExtentInLatitude*0.5:R.CellExtentInLatitude:R.LatitudeLimits(2)-R.CellExtentInLatitude*0.5);
mYonLine = m * LON + b;
Af(LAT > mYonLine) = 0;
%% Set to zero everything on the right of the max elevation
for i = 1:size(Af, 1)
    vRow = Af(i, :);
    dMaxRow = max(vRow);
    iIdx = find(vRow == dMaxRow, 1, 'last');
    vRow(iIdx + 1: end) = 0;
    Af(i,:) = vRow;
end
%% Integrate the volume of the island above sea level in units of (pixel area) * meters
dVc = sum(Af, "all");
%% Plot
f1 = figure('Color', 'white');
surf(LON,LAT,Af)
colormap jet
shading interp
axis equal, view(0,90)
colorbar
%% Median Filter the image(5x5 neighborhood)
Af1 = medfilt2(A, [5 5]);
%% Flow direction
N = [0 -1;-1 -1;-1 0;+1 -1;0 +1;+1 +1;+1 0;-1 +1];
[a, b] = size(Af1);
grads = zeros(a,b,8);
for c = 2 : 2 : 8
    grads(:,:,c) = (circshift(Af1,[N(c,1) N(c,2)]) ...
    -Af1)/sqrt(2*90);
end
for c = 1 : 2 : 7
grads(:,:,c) = (circshift(Af1,[N(c,1) N(c,2)]) ...
-Af1)/90;
end
grads = atan(grads)/pi*2;
w = 1.1;
flow = (grads.*(-1*grads<0)).^w;
upssum = sum(flow,3);
upssum(upssum==0) = 1;
for i = 1:8
flow(:,:,i) = flow(:,:,i).*(flow(:,:,i)>0)./upssum;
end
inflowsum = upssum;
flowac = upssum;
inflow = grads*0; 
while sum(inflowsum(:))>0
for i = 1:8
inflow(:,:,i) = circshift(inflowsum,[N(i,1) N(i,2)]);
end
inflowsum = sum(inflow.*flow.*grads>0,3);
flowac = flowac + inflowsum;
end
f2 = figure('Color', 'white');
h = pcolor(log(1+flowac));
colormap(flipud(jet)), colorbar
set(h,'LineStyle','none')
axis equal
title('Flow accumulation')
[r, c] = size(flowac);
axis([1 c 1 r])
set(gca,'TickDir','out');
% surf(LON,LAT,grads)
% colormap jet
% shading interp
% axis equal, view(0,90)
% colorbar
%% Decide where the control points are.
%Neighborhood size
iSize = 51; %Must be odd number.
iEdgShft = floor(iSize/2); %Number of pixels to pad the edges.
%Pick points that have flow accumulation values above a certain threshold
%and that have elevations above a certain threshold.
mLoFlow = log(1 + flowac) < 1 & Af1 > 1 ;
%Define a neighborhood size, and see how many neighborhoods of that size
%for which each point has the highest elevation.
mHiPt = zeros(size(mLoFlow)); %To store how many neighborhoods each pixel is highest in.
for i = iEdgShft : size(Af1, 1)-iEdgShft
    for j = iEdgShft : size(Af1, 2)-iEdgShft
    mNbrEl = Af1(i-iEdgShft+1 : i+iEdgShft, j-iEdgShft+1 : j+iEdgShft);
    mNbrHiPt = mHiPt(i-iEdgShft+1 : i+iEdgShft, j-iEdgShft+1 : j+iEdgShft);
    vIdx = find(mNbrEl == max(mNbrEl, [], 'all'));
        if length(vIdx) == 1 %If multiple pixels have the max value, maybe it is a flat area.
            mNbrHiPt(vIdx) = mNbrHiPt(vIdx) + 1;
            mHiPt(i-iEdgShft+1 : i+iEdgShft, j-iEdgShft+1 : j+iEdgShft) = mNbrHiPt;
        end
    end
end
%Make a logical matrix that is true where the score in mHiPt is greater
%than some threshold value, and it's a low flow accumulation pixel.
mCtrl = mHiPt > 15 & mLoFlow;
%Extract the longitude, latitude, and elevation values for the control
%points.
vXvals = LON(mCtrl);
vYvals = LAT(mCtrl);
vZvals = Af1(mCtrl);
%% Plot the control points on the map to see if they are reasonable.
f3 = figure('Color', 'white');
surf(LON,LAT,Af1)
colormap jet
shading interp
axis equal, view(0,90)
colorbar
hold on;
plot3(vXvals, vYvals, vZvals, 'rx')
hold off;
%% Calculate current island volume in m * (pixel area) where pixel area = 1.
% Perform a harmonic spline interpolation
ZI = griddata(vXvals, vYvals,vZvals,LON,LAT,'v4');
% Create a logical mask for the ocean and cutoffs 
logicAF = Af == 0;
% Use logical mask to cutoff the sides of the island
ZI(logicAF) = 0;
% Integrate across the portion of island
dVc2 = sum(ZI, "all");
%% Plot interpolated suface
f4 = figure('Color', 'white');
surf(LON,LAT,ZI)
colormap jet
shading interp
axis equal, view(0,90)
colorbar
%% Calculate percent volume change.
dpercentChange = (dVc2-dVc)/(dVc2)*100;