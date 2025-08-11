function rmse = computeRMSE(actual, predicted, N)
    % computeRMSE calculates the Root Mean Squared Error (RMSE)
    % between the actual and predicted values.
    %
    % Inputs:
    %   actual    - A vector of actual values
    %   predicted - A vector of predicted values
    %   N         - Number of initial values to skip in computation
    %
    % Output:
    %   rmse - The computed RMSE value
    %
    % Ensure inputs are column vectors
    actual = actual(:);
    predicted = predicted(:);
    
    if nargin >2
        % Skip the first N values
        actual = actual(N+1:end);
        predicted = predicted(N+1:end);
    end
    % Check if the inputs have the same length
    if length(actual) ~= length(predicted)
        error('Input vectors must have the same length');
    end
    
    % Remove NaN values
    validIndices = ~isnan(predicted);
    actual = actual(validIndices);
    predicted = predicted(validIndices);
    
    % Compute RMSE
    rmse = sqrt(mean((actual - predicted).^2));
end
