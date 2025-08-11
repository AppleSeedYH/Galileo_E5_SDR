% Initialize figure
figure;
hold on;
grid on;
xlabel('X-axis');
ylabel('Y-axis');
title('Dynamic Plot Update');
xlim([0, 100]); % Adjust the limits as needed
ylim([0, 100]);

% Initialize data
xData = [];
yData = [];

% Plot object (to update dynamically)
hPlot = plot(xData, yData, 'b-o', 'LineWidth', 1.5);

% Simulate data addition in a loop
for k = 1:20
    % Simulate new data point
    newX = k;               % Example: x-coordinate
    newY = randi([0, 100]); % Example: y-coordinate (random data)

    % Update data
    xData = [xData, newX];
    yData = [yData, newY];

    % Update plot
    set(hPlot, 'XData', xData, 'YData', yData);
    drawnow; % Update the figure immediately

    pause(0.5); % Pause for visibility (adjust or remove as needed)
end

hold off;


%%
t = [0:1:4000];
fs = 4500;     
Input1 = sin((2*pi*t)/fs);
quant=max(Input1)/(2^7-1)
y=round(Input1/quant)
signe=uint8((sign(y)'+1)/2)
out=[signe dec2bin(abs(y),7)]  % The first bit represents the sign of the number