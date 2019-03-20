function [Weights, Cluster_type] = trainKohonenNetwork(Train_data, Alpha, handles)
%% TRAINKOHONENNETWORK computes the Synaptic Weights for a given Dataset

% Inputs
%     Train_data    - Dataset for computing Weight Vector
%     Alpha         - Initial Learning Rate
%     handles       - Enables acces to the GUI widgets
%
% Outputs
%     Weights       - Synaptic Weights after Convergence
%     Cluster_tpye  - Clusters corresponding to the computed Weights

%% Function starts here

% Intial Random Synaptic Weights between[0, 1]
Weights = rand(size(Train_data,2),2);

% Initialization for calculating Convergence Error
Weights1 = [];
temp=2;

% Number of Training Cycles
Iter = 100;

%% Begin Training

for i = 1:Iter
    for j = 1:size(Train_data,1)
        
        % Calculate distances between each Node and the given Data
        Distance1 = norm(Train_data(j,:)-Weights(:,1)')^2;
        Distance2 = norm(Train_data(j,:)-Weights(:,2)')^2;
        
        % Calculate Nearest Node and Update Weights accordingly
        if Distance1 < Distance2
            Weights(:,1) = Weights(:,1) + Alpha*(Train_data(j,:)' - Weights(:,1));
            
            % Define the Cluster type
            if j == 1
                Cluster_type = 1; 
            end
        else
            Weights(:,2) = Weights(:,2) + Alpha*(Train_data(j,:)' - Weights(:,2));
            if j == 1
                Cluster_type = 2;
            end
        end
    end
    
    % Decay Learning Rate
    Alpha = Alpha * exp(-i/Iter);
    
    %% Calculate the Convergence Error (If Error is less than a Threshold, Training Stops)
    
    Weights1 = [Weights1 Weights];
    if i ~= 1
        Error =  sum(sum(Weights1(:,temp-1:temp) - Weights1(:,temp+1:temp+2))); % Convergence Error
        
        % Plot the Error vs Iterations graph
        axes(handles.ConvergenceAxes);
        scatter(i-1,Error,'b*');
        xlabel('Iterations');
        ylabel('Weight Convergence Error');
        hold on;
        pause(1e-10);
        temp = temp + 2;
        
        % Check if Error is less than a certain Threshold
        if Error < 1e-20
            set(handles.ConvergenceEdit,'String',num2str(i));
            break;
        end
    end
end

end