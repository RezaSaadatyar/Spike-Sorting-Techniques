%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

% Define the function `kmeans_cluster` to perform k-means clustering
function [Labels, Center] = kmeans_cluster(InputClust, NumClus, Center, Nepoch)

% Get the number of samples in the input data
N = size(InputClust, 2); % Number of samples

% Perform k-means clustering for the specified number of epochs (iterations)
for iter = 1:Nepoch
    %% Step 2: Calculate distance between all samples and all centers
    dis = zeros(NumClus, size(InputClust, 2)); % Initialize distance matrix
    for j = 1:NumClus
        cj = Center(:, j); % Get the current center for cluster j
        reptCj = repmat(cj, 1, N); % Replicate the center to match the number of samples
        dis(j, :) = sqrt(sum((reptCj - InputClust).^2)); % Compute Euclidean distance
    end
    
    %% Step 3: Update centers
    [~, indx] = min(dis); % Assign each sample to the nearest cluster
    for j = 1:NumClus
        xj = InputClust(:, indx == j); % Get all samples assigned to cluster j
        Center(:, j) = mean(xj, 2); % Update the center of cluster j as the mean of its samples
        if isnan(Center(:, j)) % Check for NaN values in the updated center
            t % Placeholder for handling NaN values (e.g., error handling or reinitialization)
        end
    end
end

%% Step 4: Clustering
Labels = indx; % Assign final cluster labels to the output

% Check for NaN values in the centers and compute threshold if necessary
if numel(find(isnan(Center(:)))) ~= 0
    thr = norm(Center - Old_Center); % Compute the norm of the difference between current and old centers
end
% Old_Center = centers; % Uncomment if tracking center changes across iterations
% V(iter) = thr; % Uncomment if tracking convergence criteria
end