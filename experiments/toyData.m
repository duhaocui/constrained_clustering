clear all; close all; clc;

% generate sampel continues data
size1 = 200; 
mean1 = [2,-1];
cov1 = [1,0.1; 0.1,1];
mean2 = [8,3];
cov2 = [1 .2; 0.2,1];
X = [mvnrnd(mean1, cov1, size1); mvnrnd(mean2, cov2, size1)];
Y = [ones(size1,1)  ; -1*ones(size1,1)]; 
order = randperm(400); 
X = X(order,:); 
Y = Y(order,:); 


% cluster : k-means 
k = 2; 
[centroid, pointsInCluster, assignment]= kmeans2(X, k); 
Xtmp = X(Y ==1, :);
plot(Xtmp(:, 1), Xtmp(:, 2), 'xr')
hold on;
Xtmp = X(Y ==-1, :);
plot(Xtmp(:, 1), Xtmp(:, 2), 'xb')
for i = 1:k 
    plot(centroid(i,1), centroid(i,2),'--rs','LineWidth',2,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','g',...
                    'MarkerSize',10)
end    


% cluster: bp-means: 
lambda = 25; 
[centroid, pointsInCluster, assignment, clusterSize]= bpmeans(X, lambda); 
Xtmp = X(Y ==1, :);
plot(Xtmp(:, 1), Xtmp(:, 2), 'xr')
hold on;
Xtmp = X(Y ==-1, :);
plot(Xtmp(:, 1), Xtmp(:, 2), 'xb')
for i = 1:clusterSize 
    plot(X(pointsInCluster(i),1), X(pointsInCluster(i),2),'--rs','LineWidth',2,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','g',...
                    'MarkerSize',10)
end


% cluster : dpm 
T = 50; % maximum number of clusters
[gamma, phi, m, beta, s, p] = variational_dpm(X, 20, T, 1);
[maxVal, clusters] = max(phi);
for t = 1:T
    xt = X(clusters == t, :);
    if size(xt) ~= 0
        disp( ['T = ' num2str(t) ' size(xt,1) = ' num2str(size(xt,1)) ' m(t,:) ' num2str(m(t,:)) ])
    end
end


% constrained k-means 