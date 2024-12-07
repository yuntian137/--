% 清空环境
clc;
clear;
close all;

% 初始化数据
Frequency = [];       % 频率
Magnitude = [];       % 幅值
Phase = [];           % 相位
Magnitude_Curve = []; % 幅值拟合
Phase_Curve = [];     % 相位拟合

% 读取数据文件
fileID = fopen('数值特性曲线模型/modelBodeCompareAz.txt', 'r');
data = textscan(fileID, '%f %f %f %f %f'); % 假设文件中有5列数据
fclose(fileID);

% 分别提取数据
Frequency = data{1};
Magnitude = data{2};
Phase = data{3};
Magnitude_Curve = data{4};
Phase_Curve = data{5};

% 绘图宽度
wide = 1;

% 创建一个包含两个子图的画布
figure('Position', [100, 100, 800, 600]); % 设置画布大小为800x600像素

%% 绘制幅值曲线（子图1）
subplot(2, 1, 1); % 创建第一个子图
hold on;
plot(Frequency, Magnitude, 'b-', 'LineWidth', wide, 'DisplayName', '数值解');
plot(Frequency, Magnitude_Curve, 'r-', 'LineWidth', wide, 'DisplayName', '解析解');
set(gca, 'XScale', 'log'); % 设置x轴为对数刻度
ylabel('幅值 (dB)');
title('系统的频率特性曲线');
legend('show', 'Location', 'best'); % 显示图例
grid on;
xlim([0.1, 100]); % 设置x轴范围
ylim([-70, -10]); % 设置y轴范围

% 标注特定点
scatter(0.5, -15.546, 100, [144, 255, 144]/255, 'filled'); % 绘制绿色点
text(0.5, -15.546, 'x = 0.5, y = -15.546', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontSize', 10);

%% 绘制相位曲线（子图2）
subplot(2, 1, 2); % 创建第二个子图
hold on;
plot(Frequency, Phase, 'b-', 'LineWidth', wide, 'DisplayName', '数值解');
plot(Frequency, Phase_Curve, 'r-', 'LineWidth', wide, 'DisplayName', '解析解');
set(gca, 'XScale', 'log'); % 设置x轴为对数刻度
xlabel('频率 (Hz)');
ylabel('相角 (deg)');
legend('show', 'Location', 'best'); % 显示图例
grid on;
xlim([0.1, 100]); % 设置x轴范围
ylim([-800, 100]); % 设置y轴范围

% 标注特定点
scatter(0.5, -39.742, 100, [144, 255, 144]/255, 'filled'); % 绘制绿色点
text(0.5, -39.742, 'x = 0.5, y = -39.742°', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontSize', 10);


% 设置字体
set(gca, 'FontName', 'Times New Roman');