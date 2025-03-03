%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function [Labels,Center]=kmeans_cluster(InputClust,NumClus,Center,Nepoch)
N= size(InputClust,2); % Number of samples
for iter=1:Nepoch
    %% step 2:calculate distance between all samples and all centers
    dis=zeros(NumClus,size(InputClust,2));
    for j=1:NumClus
        cj=Center(:,j);
        reptCj=repmat(cj,1,N);
        dis(j,:)=sqrt(sum((reptCj-InputClust).^2));
    end
    %% step 3: update centers
    [~,indx]= min(dis);
    for j=1:NumClus
        xj=InputClust(:,indx==j);
        Center(:,j)=mean(xj,2);
        if isnan(Center(:,j))
            t
        end
    end
end
%% step 4: clustering 
Labels= indx;
if numel(find(isnan(Center(:))))~=0;thr = norm(Center-Old_Center);end
% Old_Center=centers;V(iter)=thr;
end
