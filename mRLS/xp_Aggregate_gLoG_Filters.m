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



function [Ik] = xp_Aggregate_gLoG_Filters(imageGray, largestSigma,smallestSigma,sigmaStep, thetaStep, kernelSize)


Ik=zeros(size(imageGray,1),size(imageGray,2),pi/thetaStep+1);

FC=zeros(round(kernelSize+1),round(kernelSize+1));  %% circular multi-scale gLoG kernel
m=0;
for theta = 0: thetaStep : pi-thetaStep
    F=zeros(round(kernelSize+1),round(kernelSize+1));
    n=0;
    for sigmaX = largestSigma : sigmaStep: smallestSigma;
            for sigmaY = sigmaX : sigmaStep: smallestSigma;
                h = -elipLog([round(kernelSize+1),round(kernelSize+1)], sigmaX, sigmaY, theta);
                h=h*sigmaX*sigmaY;
                if sigmaX==sigmaY
                    FC=FC+h;
                    m=m+1;
                else
                    F=F+h;                          %% elliptical multi-scale gLoG kernels
                    n=n+1;
                end
            end
    end
    k=theta/thetaStep+2;
    Ik(:,:,k)=imfilter(imageGray,F/n,'replicate');
end
FC=FC/m;
Ik(:,:,1)=imfilter(imageGray,FC,'replicate');

end

%% to show three D surface
% surf(F)
% shading interp
% axis off