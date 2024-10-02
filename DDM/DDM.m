drift_rate = [1.6346, 0.6734, 1.6071];

decision_boundary = [0.4374, 0.5099, 0.4962];

nonDecision_t = [0.3546, 0.3502, 0.3020];
phase = [1, 2, 3];
colors = {'b', 'g', 'r'};
figure;
hold on
plot(phase, drift_rate, '-o', 'Color', 'g', 'LineWidth',1); 
for i = 1:3
    scatter(phase(i), drift_rate(i), 'filled', 'MarkerFaceColor', colors{i})
end
xlabel("Phase")
ylabel("Drift Rate")
hold off

figure;
hold on
plot(phase, nonDecision_t, '-o', 'Color', 'g', 'LineWidth',1); 
for i = 1:3
    scatter(phase(i), nonDecision_t(i), 'filled', 'MarkerFaceColor', colors{i})
end
xlabel("Phase")
ylabel("Non Dec. time")
hold off

figure;
hold on
plot(phase, decision_boundary, '-o', 'Color', 'g', 'LineWidth',1); 
for i = 1:3
    scatter(phase(i), decision_boundary(i), 'filled', 'MarkerFaceColor', colors{i})
end
xlabel("Phase")
ylabel("Decision Boundary")
hold off