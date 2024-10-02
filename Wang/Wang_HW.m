clc;
clear;
close all;

% Load the phase 1 data
phase_3 = load('/Users/parniantaheri/Desktop/temp/class/term 8/Vision/Project/تکلیف کامپیوتری درس علوم اعصاب بینایی/Proj/data/phase_3.mat'); 
data = phase_3.phase_3;

% Initial parameters
thr_initial = 0.35868;
u0_initial = 6.4285;
I0_initial = 0.345;
nDT_initial = 0.04;
initial_params = [thr_initial u0_initial, I0_initial, nDT_initial];


% Use fminsearch to fit the model
options = optimset('Display', 'iter', 'TolX', 1e-5, 'TolFun', 1e-5, 'MaxIter', 100);
fitted_params_phase1 = fminsearch(@(initial_params)objective_function(initial_params, data), initial_params, options);
%%
% Extract fitted parameters
thr_phase = fitted_params_phase1(1);
u0_phase = fitted_params_phase1(2);
I0_phase = fitted_params_phase1(3);
nDT_phase = fitted_params_phase1(4);
% Display fitted parameters
disp('Fitted parameters for phase_3:');
disp(['thr: ', num2str(thr_phase)]);
disp(['u0: ', num2str(u0_phase)]);
disp(['I0: ', num2str(I0_phase)]);
disp(['nDT: ', num2str(nDT_phase)]);


visualize([thr_phase, u0_phase, I0_phase, nDT_phase], data);


%%

% Define the objective function for fitting
function error = objective_function(params, data)
    % Extract parameters
    thr = params(1);
    u0 = params(2);
    I0 = params(3);
    nDT = params(4);

    % Compute the model output
    model_output = WANG_E([thr, u0, I0, nDT]);

    % Extract model RT and Acc
    RT = model_output(:,5);
    Acc = model_output(:,6);

    % Extract data RT and Acc
    data_RT = data(:,6);
    data_Acc = data(:,5);

    % Define common bin edges for histograms
    min_value = min([min(RT), min(data_RT)]);
    max_value = max([max(RT), max(data_RT)]);
    bin_edges = linspace(min_value, max_value, 50); 

    % Compute histograms
    counts_model = histcounts(RT, bin_edges);
    counts_phase_1 = histcounts(data_RT, bin_edges);

    % Compute the difference in histograms
    diff = sum((counts_phase_1 - counts_model).^2);

    % Compute additional errors
    RT_diff = (mean(RT) - mean(data_RT))^2;
    Acc_diff = (mean(Acc) - mean(data_Acc))^2;

    % Combine errors
    error = diff + RT_diff + Acc_diff;
end

function visualize(params, data)

%%
out = WANG_E(params);

%%
RT = out(:,5);
Acc = out(:,6);

RT_mean = mean(RT);
ACC_mean = mean(Acc);

data_RT = data(:,6);
data_Acc = data(:,5);

data_RT_mean = mean(data_RT);
data_ACC_mean = mean(data_Acc);


min_value = min([min(RT), min(data_RT)]);
max_value = max([max(RT), max(data_RT)]);
bin_edges = linspace(min_value, max_value, 50); 

counts_model = histcounts(RT, bin_edges);
counts_phase_1 = histcounts(data_RT, bin_edges);

figure;
subplot(2, 1, 1);
histogram(RT, bin_edges, 'FaceColor', 'b', 'EdgeColor', 'b');
xlabel("Time[s]")
title("Histogram of Model Reaction Time")
grid("on")

subplot(2, 1, 2);
histogram(data_RT, bin_edges, 'FaceColor', 'r', 'EdgeColor', 'r');
xlabel("Time[s]")
title("Histogram of Phase 3 Reaction Time")
grid("on")

disp(['Model Mean RT: ', num2str(RT_mean)]);
disp(['Phase Mean RT: ', num2str(data_RT_mean)]);
disp(['Model Mean Accuracy: ', num2str(ACC_mean)]);
disp(['Model Mean Accuracy: ', num2str(data_ACC_mean)]);

end

