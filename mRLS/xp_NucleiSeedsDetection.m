%%----------------------%%
% Input
%    R: image channel (R,G,B, or Gray channel)
%    C_mask3: the foreground with nuclei regions as foreground
%    Para: Parameters setttings
% Output:
%    bs4: the binary image with nuclei centers as foreground
% Written by Hongming Xu
% ECE U of A
% feel free to use it
%%---------------------%%


function [cs,rd]=xp_NucleiSeedsDetection(R,C_mask3,Para)


%R_hat=double(255-R);     %% assume the dark blobs
R_hat=imfill(R,'holes');
thetaStep=Para.thetaStep;          % thetaStep
largeSigma=Para.largeSigma;
smallSigma=Para.smallSigma;
sigmaStep=Para.sigmaStep;              % Sigma step
kerSize=Para.kerSize;         % Kernel size
bandwidth=Para.bandwidth;     % Mean-shift bandwidth

%% modified version with mean-shift clustering algorithm
[aggregated_response] = xp_Aggregate_gLoG_Filters(R_hat, largeSigma, smallSigma, sigmaStep,thetaStep, kerSize); %% summation with same direction

X=[;];
Y=[];
for i=1:size(aggregated_response,3)
    aggregated_response1=aggregated_response(:,:,i);
    bt=imregionalmax(aggregated_response1);
    bt(~C_mask3)=0;
    [r,c]=find(bt);
    X=[X,[r';c']];
    ind=sub2ind(size(R),r,c);
    Y=[Y,aggregated_response1(ind)'];
end

[~,~,clustMembsCell] = MeanShiftCluster(X,bandwidth);


cs=[];
for i=1:length(clustMembsCell)
    temp=clustMembsCell{i,1};
    pp=mean(X(:,temp),2);
    cs=[cs,round(pp)];  
end
cs=cs';
end