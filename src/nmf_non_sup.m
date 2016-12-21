function [ Wnew, Hnew, C ] = nmf_non_sup( W, H, S )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    Wnew = W .* ((S*H')./((W*H)*H'+eps));
    
    Hnew = H .* ((Wnew'*S)./(Wnew'*(Wnew*H)+eps));
    C = dist_euclid(S,Wnew*Hnew);
end

