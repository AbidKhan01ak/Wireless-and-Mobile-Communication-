%Random node generation and network simulation
% Number of nodes
numNodes = 10;
% Area dimensions (for a 100x100 unit area)
areaX = 100;
areaY = 100;
% Maximum distance for a link to be established (e.g., 20 units)
maxDistance = 20;
% Generate random node positions
nodePositions = [areaX*rand(numNodes, 1), areaY*rand(numNodes, 1)];
% Initialize adjacency matrix for links
adjMatrix = zeros(numNodes);
% Calculate distances and establish links
for i = 1:numNodes
    for j = i+1:numNodes
        distance = sqrt((nodePositions(i, 1) - nodePositions(j, 1))^2 + ...
                        (nodePositions(i, 2) - nodePositions(j, 2))^2);
        if distance <= maxDistance
            adjMatrix(i, j) = 1;
            adjMatrix(j, i) = 1;
        end
    end
end
% Plot the network
figure;
hold on;
grid on;
axis([0 areaX 0 areaY]);
% Plot nodes
plot(nodePositions(:, 1), nodePositions(:, 2), 'ro', 'MarkerSize', 18, 'MarkerFaceColor', 'g');
% Plot links
for i = 1:numNodes
    for j = i+1:numNodes
        if adjMatrix(i, j) == 1
            plot([nodePositions(i, 1), nodePositions(j, 1)], ...
                 [nodePositions(i, 2), nodePositions(j, 2)], 'r-');
        end
    end
end
title('Wireless Network Simulation');
xlabel('X Position');
ylabel('Y Position');
hold off;