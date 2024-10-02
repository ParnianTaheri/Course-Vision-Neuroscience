clc
clear
close all

names = ["Parnian", "S1"];
coherence = [0.032, 0.064, 0.128, 0.256];  
coherence_label = [3.2, 6.4, 12.8, 25.6];  

num = 50;

% Load data
for i = 1:length(names)
    for j = 1:8
        file_name = names(i)+"_block_"+j;
        data{i,j} = open("/Users/parniantaheri/Desktop/temp/class/term 8/Vision/Project/تکلیف کامپیوتری درس علوم اعصاب بینایی/Proj/data/"+file_name+".mat");
    end
end

% Calculate Accuracy and RT
acc = zeros(length(coherence), length(names)*8);
RT = zeros(length(coherence), length(names)*8);
acc_std = zeros(length(coherence),1);
RT_std = zeros(length(coherence),1);
for k = 1:length(coherence)
    for i = 1:length(names)
        for j = 1:8
            ind = find(data{i,j}.data.result(:,2) == coherence(k));
            ind_ans = find(data{i,j}.data.result(:,7) == 1); % Answered trials 
            final_ind = intersect(ind, ind_ans);
            acc(k, 8*(i-1)+j) = mean(data{i,j}.data.result(final_ind,5),1)*100;
            RT(k, 8*(i-1)+j) = mean(data{i,j}.data.result(final_ind,6),1)*1000;
        end
    end
    acc_std(k) = std(acc(k,:))/100;
    RT_std(k) = std(RT(k,:));
end
acc = acc/100;

acc_coherance = sum(acc,2)/(size(acc,2));
RT_coherance = sum(RT,2)/(size(RT,2));

% Accuracy
figure;
errorbar(coherence_label,acc_coherance, acc_std, '-o', 'MarkerFaceColor', 'black', 'Color','black', 'LineWidth', 2)
xlabel("Motion Strength (%Coh)")
ylabel("Probability Correct")
title("Accuracy of Each Coherency")
ylim([0 1])

% Reaction Time with Error Bars
figure;
errorbar(coherence_label, RT_coherance, RT_std, '-o', 'MarkerFaceColor', 'black', 'Color','black', 'LineWidth', 2)
xlabel("Motion Strength (%Coh)")
ylabel("Reaction Time (ms)")
title("Reaction Time of Each Coherency")
ylim([200 max(RT_coherance)+100])


%%
phase_1 = data{:,1:2};
phase_2 = data{:,3:7};
phase_3 = data{:,8};
save("phase_1.mat","phase_1")
save("phase_2.mat","phase_2")
save("phase_3.mat","phase_3")

for i=1:length(names)
    n = 8*(i-1);
    acc_1(:,2*(i-1)+1:2*(i-1)+2) = acc(:,(n+1:n+2));
    acc_2(:,5*(i-1)+1:5*(i-1)+5) = acc(:,(n+3:n+7));
    acc_3(:,i) = acc(:,(n+8));

    RT_1(:,2*(i-1)+1:2*(i-1)+2) = RT(:,(n+1:n+2));
    RT_2(:,5*(i-1)+1:5*(i-1)+5) = RT(:,(n+3:n+7));
    RT_3(:,i) = RT(:,(n+8));
end

%%
% STD
acc_1_std = std(acc_1, 0,2);

acc_2_std = std(acc_2, 0,2);

acc_3_std = std(acc_3, 0,2);

RT_1_std = std(RT_1, 0,2);

RT_2_std = std(RT_2, 0,2);

RT_3_std = std(RT_3, 0,2);

%%
acc_1_avg = mean(acc_1,2);
acc_2_avg = mean(acc_2,2);
acc_3_avg = mean(acc_3,2);


acc_1_std_all = std(acc_1,0,"all");
acc_2_std_all = std(acc_2,0,"all");
acc_3_std_all = std(acc_3,0,"all");


RT_1_avg = mean(RT_1,2);
RT_2_avg = mean(RT_2,2);
RT_3_avg = mean(RT_3,2);

RT_1_std_all = std(RT_1,0,"all");
RT_2_std_all = std(RT_2,0,"all");
RT_3_std_all = std(RT_3,0,"all");

figure;
for i=1:4
subplot(2,4,i)
x = [1,2,3];
y = [acc_1_avg(i),acc_2_avg(i),acc_3_avg(i)];
err = [acc_1_std(i), acc_2_std(i), acc_3_std(i)];
bar(x,y)
hold on
errorbar(x, y, err, 'k', 'LineStyle', 'none', 'LineWidth', 1)
ylabel("Probability Correct")
title("Coherency: "+ coherence_label(i)+ "%")

subplot(2,4,i+4)
y = [RT_1_avg(i),RT_2_avg(i),RT_3_avg(i)];
err = [RT_1_std(i), RT_2_std(i), RT_3_std(i)];
bar(x,y)
hold on
errorbar(x, y, err, 'k', 'LineStyle', 'none', 'LineWidth', 1)
xlabel("Phase")
ylabel("Reaction Time")
end

figure;
sgtitle("Average Accuracy and Reaction Time for All the Coherencies")
subplot(1,2,1)
x = [1,2,3];
y = [mean(acc_1_avg),mean(acc_2_avg),mean(acc_3_avg)];
err = [acc_1_std_all, acc_2_std_all, acc_3_std_all];
bar(x,y)
hold on
errorbar(x, y, err, 'k', 'LineStyle', 'none', 'LineWidth', 1)
hold off
xlabel("Phase")
ylabel("Probability Correct")

subplot(1,2,2)
y = [mean(RT_1_avg),mean(RT_2_avg),mean(RT_3_avg)];
err = [RT_1_std_all, RT_2_std_all, RT_3_std_all];
bar(x,y)
hold on
errorbar(x, y, err, 'k', 'LineStyle', 'none', 'LineWidth', 1)
hold off
xlabel("Phase")
ylabel("Reaction Time")

%%
% Perform t-tests between phases
% Accuracy

% Perform t-tests between phases
[h_acc_12, p_acc_12, ci_acc_12, stats_acc_12] = ttest(acc_1_avg, acc_2_avg);
[h_acc_13, p_acc_13, ci_acc_13, stats_acc_13] = ttest(acc_1_avg, acc_3_avg);
[h_acc_23, p_acc_23, ci_acc_23, stats_acc_23] = ttest(acc_2_avg, acc_3_avg);

% Display results
disp("Accuracy:")
fprintf('T-test between Phase 1 and Phase 2 for Accuracy:\n');
fprintf('p-value: %.4f\n', p_acc_12);
fprintf('t-statistic: %.4f\n', stats_acc_12.tstat);
fprintf('Degrees of freedom: %.4f\n', stats_acc_12.df);
fprintf('Confidence interval: [%.4f, %.4f]\n', ci_acc_12(1), ci_acc_12(2));

fprintf('\nT-test between Phase 1 and Phase 3 for Accuracy:\n');
fprintf('p-value: %.4f\n', p_acc_13);
fprintf('t-statistic: %.4f\n', stats_acc_13.tstat);
fprintf('Degrees of freedom: %.4f\n', stats_acc_13.df);
fprintf('Confidence interval: [%.4f, %.4f]\n', ci_acc_13(1), ci_acc_13(2));

fprintf('\nT-test between Phase 2 and Phase 3 for Accuracy:\n');
fprintf('p-value: %.4f\n', p_acc_23);
fprintf('t-statistic: %.4f\n', stats_acc_23.tstat);
fprintf('Degrees of freedom: %.4f\n', stats_acc_23.df);
fprintf('Confidence interval: [%.4f, %.4f]\n', ci_acc_23(1), ci_acc_23(2));


% RT
[h12, p12, ci12, stats12] = ttest(RT_1_avg, RT_2_avg);
[h13, p13, ci13, stats13] = ttest(RT_1_avg, RT_3_avg);
[h23, p23, ci23, stats23] = ttest(RT_2_avg, RT_3_avg);

% Display results
disp("Reaction Time:")
fprintf('T-test between Phase 1 and Phase 2:\n');
fprintf('p-value: %.4f\n', p12);
fprintf('t-statistic: %.4f\n', stats12.tstat);
fprintf('Degrees of freedom: %.4f\n', stats12.df);
fprintf('Confidence interval: [%.4f, %.4f]\n', ci12(1), ci12(2));

fprintf('\nT-test between Phase 1 and Phase 3:\n');
fprintf('p-value: %.4f\n', p13);
fprintf('t-statistic: %.4f\n', stats13.tstat);
fprintf('Degrees of freedom: %.4f\n', stats13.df);
fprintf('Confidence interval: [%.4f, %.4f]\n', ci13(1), ci13(2));

fprintf('\nT-test between Phase 2 and Phase 3:\n');
fprintf('p-value: %.4f\n', p23);
fprintf('t-statistic: %.4f\n', stats23.tstat);
fprintf('Degrees of freedom: %.4f\n', stats23.df);
fprintf('Confidence interval: [%.4f, %.4f]\n', ci23(1), ci23(2));


