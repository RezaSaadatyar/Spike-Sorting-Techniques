%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

% Function to perform Fuzzy C-Means (FCM) clustering
function [Center, Mu] = fcm_cluster(InputClust, NumClus, Center, Nepoch, m)

% Step 1: Initialize membership functions and determine the number of clusters
N = size(InputClust, 2); % Number of data points
d = size(InputClust, 1); % Dimension of each data point
Mu = rand(NumClus, N); % Initialize membership matrix randomly

% If the data is multi-dimensional (d > 1)
if d > 1
    for iter = 1:Nepoch % Iterate for the specified number of epochs
        %% Step 2: Update cluster centers
        num = ((Mu.^m) * InputClust')'; % Numerator for center calculation
        denum = sum(Mu.^m, 2)'; % Denominator for center calculation
        D = repmat(denum, d, 1); % Replicate denominator for division
        Center = num ./ (D + eps); % Update cluster centers (avoid division by zero using eps)

        %% Step 3: Update membership functions
        dis = zeros(NumClus, N); % Initialize distance matrix
        for j = 1:NumClus
            cj = Center(:, j); % Current cluster center
            reptCj = repmat(cj, 1, N); % Replicate center for distance calculation
            dis(j, :) = sqrt(sum((reptCj - InputClust).^2)); % Calculate Euclidean distance
        end

        for j = 1:NumClus
            disj = dis(j, :); % Distance of data points to the j-th cluster
            Dj = repmat(disj, NumClus, 1); % Replicate distances for membership update
            denumM = (Dj ./ dis).^(2 / (m - 1)); % Denominator for membership update
            Dnum = sum(denumM); % Sum of denominator terms
            Mu(j, :) = 1 ./ (Dnum + eps); % Update membership values (avoid division by zero using eps)
        end
    end

% If the data is one-dimensional (d == 1)
elseif d == 1
    for iter = 1:Nepoch % Iterate for the specified number of epochs
        %% Step 2: Update cluster centers
        num = ((Mu.^m) * InputClust')'; % Numerator for center calculation
        denum = sum(Mu.^m, 2)'; % Denominator for center calculation
        D = repmat(denum, d, 1); % Replicate denominator for division
        Center = num ./ (D + eps); % Update cluster centers (avoid division by zero using eps)

        %% Step 3: Update membership functions
        dis = zeros(NumClus, N); % Initialize distance matrix
        for j = 1:NumClus
            cj = Center(:, j); % Current cluster center
            reptCj = repmat(cj, 1, N); % Replicate center for distance calculation
            dis(j, :) = sqrt(((reptCj - InputClust).^2)); % Calculate Euclidean distance
        end

        for j = 1:NumClus
            disj = dis(j, :); % Distance of data points to the j-th cluster
            Dj = repmat(disj, NumClus, 1); % Replicate distances for membership update
            denumM = (Dj ./ dis).^(2 / (m - 1)); % Denominator for membership update
            Dnum = sum(denumM); % Sum of denominator terms
            Mu(j, :) = 1 ./ (Dnum + eps); % Update membership values (avoid division by zero using eps)
        end
    end
end
end