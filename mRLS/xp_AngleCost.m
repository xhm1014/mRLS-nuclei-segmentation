
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

function [ac]=xp_AngleCost(iIx,iIy,theta)
angle=atan2(iIy,iIx);
ind=find(angle<0);
angle(ind)=2*pi+angle(ind);  %% change from [-pi pi] to [0 2*pi]
theta2=repmat(theta',[1,size(angle,2)]);
ac=cos(abs(angle-theta2));
%ac(ac<0)=-10;
end