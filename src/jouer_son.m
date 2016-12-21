function [signal_tot, F] = jouer_son( W,H, Phase,noverlap, nfft, F, ind  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if ind > 0
    Signal = W(:,ind)*H(ind,:) .* exp(-1j*Phase);
    [signal, ~] = istft(Signal, noverlap, nfft, F);
    sound(signal',F);
    signal_tot =  signal';
    else
        disp('start')
        Signal = W(:,1)*H(1,:) .* exp(-1j*Phase);
        [signal_tot, ~] = istft(Signal, noverlap, nfft, F);
        for i=2:size(W,2)
            fprintf('iteration : %d / %d\n',i, size(W,2));
            Signal = W(:,i)*H(i,:) .* exp(-1j*Phase);
            [signal, ~] = istft(Signal, noverlap, nfft, F);
            signal_tot = signal_tot + signal;
        end
        signal_tot = signal_tot';
    end
end

