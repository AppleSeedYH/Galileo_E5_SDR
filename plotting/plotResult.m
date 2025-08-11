function plotResult(ch)
%%
for i=1:length(ch)
    % plot P E L correlation
    figure();
    title('P, E, and L correlation results');
    xlabel('Time (s)');
    hold on;
    plot(ch.result.timeStamp,ch.result.correlationP,'-*');
    plot(ch.result.timeStamp,ch.result.correlationE,'-*');
    plot(ch.result.timeStamp,ch.result.correlationL,'-*');
    legend('P','E','L');
end

for i=1:length(ch)
    % plot P E L correlation
    figure();
    title('Code offset from DLL (s)');
    xlabel('Time (s)');
    hold on;
    plot(ch.result.timeStamp,ch.result.codeOffset,'-*');
end

for i=1:length(ch)
    % plot P E L correlation
    figure();
    title('Discrimniator ouput from DLL');
    xlabel('Time (s)');
    hold on;
    plot(ch.result.timeStamp,ch.result.filDLLDiscr,'-*');
end

for i=1:length(ch)
    figure();
    title('adr (cyc)');
    xlabel('Time (s)');
    hold on;
    plot(ch.result.timeStamp,ch.result.adr,'-*');
end

for i=1:length(ch)
    figure();
    title('Discrimniator ouput from PLL');
    xlabel('Time (s)');
    hold on;
    plot(ch.result.timeStamp,ch.result.filPLLDiscr,'-*');
end

for i=1:length(ch)
    figure();
    title('Doppler (Hz)');
    xlabel('Time (s)');
    hold on;
    plot(ch.result.timeStamp,ch.result.dopFreq,'-*');
end
