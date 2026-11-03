clc;
clear;
close all;

%% a) FRUIT JUICE PRODUCTION OPTIMIZATION
% Using Linear Programming (linprog)

%% STEP 1: Define the objective function

% Profit per kg:
% Pineapples = 2000 UGX
% Oranges    = 1500 UGX
% Mangoes    = 2500 UGX

f = [2000; 1500; 2500];

%% STEP 2: Define the constraints

% Inequality constraints A*x <= b

A = [-1  0  0;
      0 -1  0;
      0  0  1;
      1  1  1];

b = [-300;
     -200;
      400;
     1000];

% Lower and upper bounds

lb = [0; 0; 0];

ub = [Inf; Inf; Inf];

%% STEP 3: Set MATLAB optimization options

options = optimoptions('linprog', ...
    'Display', 'none');

%% STEP 4: MINIMIZATION

[x_min, fval_min, exitflag_min] = ...
    linprog(f, A, b, [], [], lb, ub, options);

if exitflag_min == 1

    fprintf('\n===== MINIMIZATION RESULTS =====\n');

    fprintf('Pineapples: %.2f kg\n', x_min(1));
    fprintf('Oranges: %.2f kg\n', x_min(2));
    fprintf('Mangoes: %.2f kg\n', x_min(3));

    fprintf('Minimum Profit: UGX %.2f\n', fval_min);

else
    fprintf('Minimization did not converge.\n');
end

%% STEP 5: MAXIMIZATION

% Change signs because linprog performs minimization

f_max = -f;

[x_max, fval_max, exitflag_max] = ...
    linprog(f_max, A, b, [], [], lb, ub, options);

if exitflag_max == 1

    maximum_profit = -fval_max;

    fprintf('\n===== MAXIMIZATION RESULTS =====\n');

    fprintf('Pineapples: %.2f kg\n', x_max(1));
    fprintf('Oranges: %.2f kg\n', x_max(2));
    fprintf('Mangoes: %.2f kg\n', x_max(3));

    fprintf('Maximum Profit: UGX %.2f\n', maximum_profit);

else
    fprintf('Maximization did not converge.\n');
end

%% STEP 6: Display results in a table

Fruit = {'Pineapples'; 'Oranges'; 'Mangoes'};

Minimum_Quantity = x_min;

Maximum_Quantity = x_max;

Results = table(Fruit, Minimum_Quantity, Maximum_Quantity);

disp('===== OPTIMAL PRODUCTION TABLE =====');
disp(Results);

%% STEP 7: BAR GRAPH OF OPTIMAL QUANTITIES

figure;

bar([x_min, x_max]);

xlabel('Types of Fruits');
ylabel('Quantity (kg)');

title('Minimum and Maximum Fruit Production');

xticklabels({'Pineapples','Oranges','Mangoes'});

legend('Minimization','Maximization');

grid on;

%% STEP 8: 3D SURFACE PLOT

% Use the total processing capacity boundary:
% x1 + x2 + x3 = 1000

x1 = 300:5:800;
x2 = 200:5:700;

[X1, X2] = meshgrid(x1, x2);

X3 = 1000 - X1 - X2;

% Calculate profit on the capacity boundary

P = 2000*X1 + 1500*X2 + 2500*X3;

% Keep only feasible points

P(X3 < 0 | X3 > 400) = NaN;

figure;

surf(X1, X2, P);

shading interp;

xlabel('Pineapples (kg)');
ylabel('Oranges (kg)');
zlabel('Profit (UGX)');

title('3D Surface Plot of Fruit Production Profit');

colorbar;

grid on;

view(45,30);

hold on;

% Mark the maximum profit solution

plot3(x_max(1), x_max(2), maximum_profit, ...
    'r*', 'MarkerSize', 12, 'LineWidth', 2);

legend('Profit Surface','Maximum Profit Point');

hold off;

%% STEP 9: 3D PLOT OF OPTIMAL PRODUCTION QUANTITIES

figure;

plot3(x_min(1), x_min(2), x_min(3), ...
    'bo', 'MarkerSize', 10, 'LineWidth', 2);

hold on;

plot3(x_max(1), x_max(2), x_max(3), ...
    'r*', 'MarkerSize', 12, 'LineWidth', 2);

xlabel('Pineapples (kg)');
ylabel('Oranges (kg)');
zlabel('Mangoes (kg)');

title('3D Comparison of Optimal Production Quantities');

legend('Minimum Profit Solution','Maximum Profit Solution');

grid on;

view(45,30);

hold off;

%% STEP 10: Final comparison

fprintf('\n===== FINAL COMPARISON =====\n');

fprintf('Minimum Profit = UGX %.2f\n', fval_min);

fprintf('Maximum Profit = UGX %.2f\n', maximum_profit);