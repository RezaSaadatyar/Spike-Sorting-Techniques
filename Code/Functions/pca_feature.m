%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

% Define the function `pca_feature` to perform PCA on spike data
function PcaSpik = pca_feature(spikes, Tikpca, dispca, diswave)  

% Initialize the output variable
PcaSpik = 0;

% Reset the values of the display options for PCA and waveforms
set(dispca, 'value', 0); 
set(diswave, 'value', 0);

% Check if PCA is selected (Tikpca value is 1)
if get(Tikpca, 'value') == 1
    % Check if spikes data is loaded
    if spikes == 0
        % Show a warning message if spikes data is not loaded
        msgbox('Please Load Spikes (i.e., Enter Parameters for Spike Detection)', '', 'warn'); 
        return; % Exit the function if no spikes data is loaded
    end
    
    % Calculate the mean of the spikes data and replicate it to match the size of the spikes matrix
    Xm = repmat(mean(spikes), size(spikes, 1), 1); 
    
    % Subtract the mean from the spikes data to center it
    spik = spikes - Xm; 
    
    % Compute the covariance matrix of the centered spikes data
    Cov = cov(spik); 
    
    % Perform eigenvalue decomposition on the covariance matrix
    [V, D] = eig(Cov); 
    
    % Extract the eigenvalues and sort them in descending order
    eigenval = diag(D); 
    [~, ind] = sort(eigenval, 'descend'); 
    
    % Sort the eigenvectors based on the sorted eigenvalues
    A = V(:, ind); 
    
    % Project the spikes data onto the principal components
    PcaSpik = spikes * A; 
    
    % Show a message box indicating that the operation is completed
    msgbox('Operation Completed'); 
end

end