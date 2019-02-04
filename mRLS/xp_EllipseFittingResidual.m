
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is designed by Hongming Xu,
% Deptment of Eletrical and Computer Engineering,
% University of Alberta, Canada.  1th April, 2016
% If you have any problem feel free to contact me.
% Please address questions or comments to: mxu@ualberta.ca

% Terms of use: You are free to copy,
% distribute, display, and use this work, under the following
% conditions. (1) You must give the original authors credit. (2) You may
% not use or redistribute this work for commercial purposes. (3) You may
% not alter, transform, or build upon this work. (4) For any reuse or
% distribution, you must make clear to others the license terms of this
% work. (5) Any of these conditions can be waived if you get permission
% from the authors.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [efr]=xp_EllipseFittingResidual(bw)
cc = bwconncomp(bw,8);
stats = regionprops(cc,'Centroid','Orientation','MajorAxisLength','MinorAxisLength');
phi=linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);

xbar = stats.Centroid(1);
ybar = stats.Centroid(2);

%    hold on,plot(xbar,ybar,'g*');

a = stats.MajorAxisLength/2;
b = stats.MinorAxisLength/2;

theta = pi*stats.Orientation/180; %% Orientation ranging from -90 to 90 degrees
R = [ cos(theta)   sin(theta);  %% counterclockwise roatation if theta is positive
    -sin(theta)   cos(theta)];  %% clockwise rotation if theta is negative

xy = [a*cosphi; b*sinphi];
xy = R*xy;

x = xy(1,:) + xbar;
y = xy(2,:) + ybar;

%hold on, plot(x,y,'r','LineWidth',2);

bwe=poly2mask(x,y,size(bw,1),size(bw,2));
efr=1-sum(sum(bwe&bw))/sum(bwe(:));
