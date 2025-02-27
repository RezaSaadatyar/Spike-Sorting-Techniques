function [Center,Mu] = fcm_cluster(InputClust,NumClus,Center,Nepoch,m)
%% step 1: initialize membership functions, determine number of culsters
N= size(InputClust,2);d= size(InputClust,1);Mu= rand(NumClus,N);
% Center= zeros(d,NumClus);
if d>1
    for iter= 1:Nepoch
        %% step 2: update centers
        num=((Mu.^m) * InputClust')';denum= sum(Mu.^m,2)';D= repmat(denum,d,1);
%         if iter~=1;Center= num./(D+eps);end
        Center= num./(D+eps);
        %% step 3: update membership function
        dis=zeros(NumClus,N);
        for j=1:NumClus
            cj=Center(:,j);reptCj=repmat(cj,1,N);dis(j,:)=sqrt(sum((reptCj-InputClust).^2));
        end
        for j=1:NumClus
            disj=dis(j,:);Dj=repmat(disj,NumClus,1);denumM=(Dj./dis).^(2/(m-1));
            Dnum=sum(denumM);Mu(j,:)=1./(Dnum+eps);
        end
    end
elseif d==1
    for iter= 1:Nepoch
        %% step 2: update centers
        num=((Mu.^m) * InputClust')';denum= sum(Mu.^m,2)';D= repmat(denum,d,1);
        Center= num./(D+eps);
        %% step 3: update membership function
        dis=zeros(k,N);
        for j=1:NumClus
            cj=Center(:,j);reptCj=repmat(cj,1,N);dis(j,:)=sqrt(((reptCj-InputClust).^2));
        end
        for j=1:NumClus
            disj=dis(j,:);Dj= repmat(disj,NumClus,1);denumM=(Dj./dis).^(2/(m-1));
            Dnum=sum(denumM);Mu(j,:)= 1./(Dnum+eps);
        end
    end
end
end

