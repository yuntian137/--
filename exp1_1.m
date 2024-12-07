% 初始化
clc;
clear;
close all;

% 设置中文字体支持
set(0, 'DefaultTextInterpreter', 'none', 'DefaultAxesFontName', 'SimHei');

% 采样频率 100Hz
fs = 100;
time = (0:1/fs:1498/fs)'; % 时间向量

% 初始化数据列表
velocity = [];
location = [];
directives = [];

% 读取第一个数据文件
fileID = fopen('直流偏置/velPosDataAz.txt', 'r');
data = textscan(fileID, '%f %f');
fclose(fileID);
velocity = data{1};
location = data{2};

fileID = fopen('直流偏置/identDataAz.txt', 'r');
data = textscan(fileID, '%f %f');
fclose(fileID);
directives = data{1};

% 确保位置的范围为 0~360°
location(location < 0) = location(location < 0) + 360;

% 取 5s 后的数据
velocity = velocity(500:end);
location = location(500:end);

% 绘制时间-位置数据曲线
figure('Position', [100, 100, 800, 300]);
plot(time(500:end), velocity, 'b-');
xlabel('时间 (s)');
ylabel('位置 (deg)');
title('给定为3500的时间-位置数据曲线图');
grid on;

% 对位置与速度数据做平滑处理
total_data = cell(360, 1);
for i = 1:length(location)
    angle = floor(location(i));
    if angle >= 1 && angle <= 360
        total_data{angle} = [total_data{angle}, velocity(i)];
    end
end

velocity_smooth = zeros(360, 1);
location_smooth = (1:360)';

for i = 1:360
    if ~isempty(total_data{i})
        velocity_smooth(i) = mean(total_data{i});
    end
end

% 指定点的大小
% pointSize = 20;
% 绘制平滑曲线
figure('Position', [100, 100, 800, 300]);
%scatter(mapped_angle, filtered_velocity, pointSize,'filled');
plot(location_smooth, velocity_smooth, 'b-');
xlabel('角度 (deg)');
ylabel('角速度 (deg/s)');
title('给定为3500的位置-速度曲线图');
grid on;

% 读取第二组数据
fileID = fopen('直流_正弦/velPosDataAz.txt', 'r');
data = textscan(fileID, '%f %f');
fclose(fileID);
velocity = data{1};
location = data{2};

fileID = fopen('直流_正弦/identDataAz.txt', 'r');
data = textscan(fileID, '%f %f');
fclose(fileID);
directives = data{1};

% 确保位置的范围为 0~360°
location(location < 0) = location(location < 0) + 360;

% 绘制时间-位置曲线
figure('Position', [100, 100, 800, 300]);
plot(time(1000:end), velocity(1000:end), 'b-');
xlabel('时间 (s)');
ylabel('位置 (deg)');
title('直流偏置+0.5Hz正弦的时间-位置数据曲线图');
grid on;

% 数据截取和处理
upp = 1300;
wide = 1;
velocity = velocity(1000:upp);
location = location(1000:upp);
directives = directives(1000:upp);
time = time(1000:upp);

% 处理指令数据
directives = directives - 3500;
directives = directives / 20;

% 去除偏置
velocity = velocity - 607;

% 绘制去除偏置的曲线
figure('Position', [100, 100, 800, 300]);
plot(time, velocity, 'b-', 'LineWidth', wide, 'DisplayName', '输出响应');
hold on;
plot(time, directives, 'r-', 'LineWidth', wide, 'DisplayName', '0.05给定');
yline(0,  'yellow', 'LineWidth', 0.75);
xlabel('时间 (s)');
ylabel('速度 (deg/s)');
title('去除偏置的0.5Hz正弦响应曲线');
legend;
grid on;

% % 定义正弦函数模型
% sine_function = @(x, A, B, C) A * sin(B * x + C);

% % 使用 curve fitting 工具进行拟合
% ft = fittype('A*sin(B*x + C)', 'independent', 'x');
% opts = fitoptions('Method', 'NonlinearLeastSquares');
% opts.StartPoint = [1, 0.1, 1];
% 
% % 拟合数据
% [fitresult, gof] = fit(time, velocity, ft, opts);
% A = fitresult.A;
% B = fitresult.B;
% C = fitresult.C;
% disp(['拟合参数：A=', num2str(A), ', B=', num2str(B), ', C=', num2str(C)]);
% 
% % 绘制拟合曲线
% figure('Position', [100, 100, 800, 300]);
% plot(time, velocity, 'b--', 'LineWidth', wide, 'DisplayName', '数据');
% hold on;
% plot(time, sine_function(time, A, B, C), 'r-', 'LineWidth', wide, 'DisplayName', '拟合曲线');
% yline(0,  'yellow', 'LineWidth', 0.75);
% xlabel('时间 (s)');
% ylabel('速度 (deg/s)');
% title('去除偏置的0.5Hz正弦响应拟合曲线');
% legend;
% grid on;


% 定义正弦函数
%sine_function = @(params, t) params(1) * sin(params(2) * t) + params(3);

%sine_function = @(x, A, B, C) A * sin(B * x + C);
%sine_function = @(params, x) params(1) * sin(params(2) * x + params(3)); % 函数接受参数向量
% 定义正弦函数
sine_function = @(params, t) params(1) * sin(params(2) * t + params(3)); 
% 初始参数
initial_params = [100, 2, 0]; % A, B, C 的初始值

% 使用 nlinfit 进行拟合
%params = nlinfit(time, velocity, sine_function, initial_params);
% 使用 nlinfit 进行拟合
params = nlinfit(time, velocity, @(p, t) sine_function(p, t), initial_params);

% 打印拟合参数
A = params(1);
B = params(2);
C = params(3);
fprintf('拟合参数：A=%.2f, B=%.2f, C=%.2f\n', A, B, C);

% 使用拟合参数生成模型数据
fitted_velocity = sine_function(params, time);

% 绘制数据和拟合曲线
figure('Position', [100, 100, 800, 300]);
plot(time, velocity, 'b--', 'LineWidth', 1.5, 'DisplayName', '数据'); % 原始数据
hold on;
plot(time, fitted_velocity, 'r', 'LineWidth', 1.5, 'DisplayName', '拟合曲线'); % 拟合曲线
yline(0,  'yellow', 'LineWidth', 0.75); % y=0 线
xlabel('时间 (s)');
ylabel('速度 (deg/s)');
title('去除偏置的0.5Hz正弦响应拟合曲线');
ylim([-500, 500]);
legend('show');
hold off;