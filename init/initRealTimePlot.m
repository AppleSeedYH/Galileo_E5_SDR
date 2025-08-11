function [gcfArray] = initRealTimePlot(config)

for i=1:config.chNumber
    figure(i);
    title("Discrete-Time Scatter Plot PRN " + config.prn(i));
    xlabel('I prompt');
    ylabel('Q prompt');
    gcfArray(i)=gcf;
    
end