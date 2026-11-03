clc;
clear;
close all;

% c) SUNFLOWER OIL EXTRACTION OPTIMIZATION

% Objective function
% fmincon minimizes, so we use negative efficiency

f = @(x) -(85 + 0.6*x(1) + 0.4*x(2) + 0.8*x(3) ...
    - 0.015*x(1)^2 - 0.002*x(2)^2 - 0.04*x(3)^2);

% Lower and upper bounds
lb = [20 50 5];
ub = [60 90 12];

% Initial guess
x0 = [30 70 8];

% Optimization options
options = optimoptions('fmincon', ...
    'Display','iter', ...
    'Algorithm','sqp');

% Perform optimization
[xopt, fval] = fmincon(f,x0,[],[],[],[],lb,ub,[],options);

% Calculate maximum efficiency
Emax = -fval;

% Display results
fprintf('\nOPTIMAL RESULTS\n');
fprintf('Screw press speed = %.2f RPM\n',xopt(1));
fprintf('Processing temperature = %.2f C\n',xopt(2));
fprintf('Seed moisture content = %.2f %%\n',xopt(3));
fprintf('Maximum extraction efficiency = %.2f %%\n',Emax);
% d) 3D CONTOUR PLOT

S = linspace(20,60,100);
T = linspace(50,90,100);

[SS,TT] = meshgrid(S,T);

% Keep moisture content at optimum
M = xopt(3);

% Calculate efficiency
EE = 85 + 0.6*SS + 0.4*TT + 0.8*M ...
    - 0.015*SS.^2 - 0.002*TT.^2 - 0.04*M^2;

% Create filled contour plot
figure;

contourf(SS,TT,EE,20);

colorbar;

hold on;

% Mark optimum point
plot(xopt(1),xopt(2),'r*','MarkerSize',12);

xlabel('Screw Press Speed (RPM)');
ylabel('Processing Temperature (C)');
zlabel('oil extraction efficiency(E)');
title('Contour Plot of Sunflower Oil Extraction Efficiency');

legend('Efficiency levels','Optimal point');

grid on;
hold off;