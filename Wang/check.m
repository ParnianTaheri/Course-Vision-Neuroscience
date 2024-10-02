%%
clc
clear
close all

% Load the phase 1 data
phase_3 = load('/Users/parniantaheri/Desktop/temp/class/term 8/Vision/Project/تکلیف کامپیوتری درس علوم اعصاب بینایی/Proj/data/phase_3.mat'); % Assuming phase1_data contains the necessary data
data = phase_3.phase_3;

%%
% Initial parameters
thr_initial = 0.35868;
u0_initial = 6.4285;
I0_initial = 0.345;
nDT_initial = 0.04;
params = [thr_initial u0_initial, I0_initial, nDT_initial];
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
disp(['Phase Mean Accuracy: ', num2str(data_ACC_mean)]);
