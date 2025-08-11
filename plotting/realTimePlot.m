function realTimePlot(ch,gcfArray)
%% update plots
for i=1:length(ch)
    if ch(i).status == 'LOCK'
        figure(gcfArray(i));
        hold on;
        plot(real(ch(i).trk.P(end)),imag(ch(i).trk.P(end)),'b*');
    end
    normIQ=norm(ch(i).trk.P(end));
    if (normIQ<500&&ch.time>0.01)
        t=1;
    end
end