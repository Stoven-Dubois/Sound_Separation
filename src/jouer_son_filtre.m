function [signal_tot, F] = jouer_son_filtre( W,H,Wtot,Htot,X,Phase,noverlap, nfft, F, ind  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
V = Wtot*Htot;
Signal = (((W*H)./V).*X) .* exp(-1j*Phase);
[signal_tot, ~] = istft(Signal, noverlap, nfft, F);

signal_tot = signal_tot';
end

