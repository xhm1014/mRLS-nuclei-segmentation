%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is designed by Hongming Xu,
% Deptment of Eletrical and Computer Engineering,
% University of Alberta, Canada.  1th April, 2016
% If you have any problem feel free to contact me.
% Please address questions or comments to: mxu@ualberta.ca

% The code implement the technique described in the following paper:
% Xu, Hongming et al. "Automatic Nuclear Segmentation Using Multi-scale
% Radial Line Scanning with Dynamic Programming", TBME, 2017

% Terms of use: You are free to copy,
% distribute, display, and use this work, under the following
% conditions. (1) You must give the original authors credit. (2) You may
% not use or redistribute this work for commercial purposes. (3) You may
% not alter, transform, or build upon this work. (4) For any reuse or
% distribution, you must make clear to others the license terms of this
% work. (5) Any of these conditions can be waived if you get permission
% from the authors.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function MainNucleiSeg
close all;
clear all;

%% add the function into MATLAB searching path and enter the test dataset
p = mfilename('fullpath');
t = findstr(p,'\');
p = p(1:t(end));
addpath(p);
cd(p);
cd('images');
List = dir('*.png');


for k=1:length(List)
    imageName = List(k).name;
    I = imread(imageName);
    R=I(:,:,1);
    
    %ac=100;
    bwn=true(size(R));
    
    %% Nuclei detections by gLoG-based method kernels
    Para.thetaStep=pi/9;
    Para.largeSigma=14;
    Para.smallSigma=8;
    Para.sigmaStep=-1;
    Para.kerSize=Para.largeSigma*4;
    Para.bandwidth=10;
    cs=xp_NucleiSeedsDetection(R,bwn,Para);
    
    
    %% show nuclei detection results -- do not consider the seeds on image borders as those are parts of nuclei
    ind1=find(cs(:,1)<3 | (size(R,1)-cs(:,1))<3);
    if ~isempty(ind1)
        cs(ind1,:)=[];
    end
    ind1=find(cs(:,2)<3 | (size(R,2)-cs(:,2))<3);
    if ~isempty(ind1)
        cs(ind1,:)=[];
    end
    rs5=cs(:,1);cs5=cs(:,2);
    figure,imshow(R);
    hold on,plot(cs5,rs5,'b+','MarkerSize',13,'LineWidth',2);
    
    
    %% Nuclei segmentation using mRLS
    ss2=18:1:22;
    sig=2;
    R(:) = imfilter(double(R),fspecial('Gaussian',[2*round(3*sig)+1 2*round(3*sig)+1],sig),'same','conv','replicate');
    
    %bws=zeros(size(R));
    %bwc=zeros(size(R));
    
    tt=40;
    for i=1:length(rs5)
        cx=cs5(i);cy=rs5(i);
        %% speed up
        if cy-tt<1
            rs=1;cy2=cy;
        else
            rs=cy-tt;cy2=tt+1;
        end
        if cy+tt>size(R,1)
            re=size(R,1);
        else
            re=cy+tt;
        end
        
        if cx-tt<1
            cs=1;cx2=cx;
        else
            cs=cx-tt;cx2=tt+1;
        end
        if cx+tt>size(R,2)
            ce=size(R,2);
        else
            ce=cx+tt;
        end
        Rtemp=R(rs:re,cs:ce); %% efficient processing
        
        [bw,mcost]=xp_DP_snake_Seg(double(Rtemp),cx2,cy2,ss2);
        bw=imdilate(bw,strel('disk',1));
        bwf=false(size(R));
        bwf(rs:re,cs:ce)=bw;
        
        %bw=bw&bwn;
        %bw=bwareaopen(bw,ac);
        B=bwboundaries(bwf);
        if ~isempty(B)
            boundary = B{1};
            hold on, plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1);
        end
        %bws(cy,cx)=i;
        %bwc=bwc|bwf;
    end
    
end
end

