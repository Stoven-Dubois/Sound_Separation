function [ d ] = dist_euclid( A, B )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
 [X,Y] = size(A);
 [Xx, Yy] = size(B);
 if X ~= Xx || Y ~= Yy
     error('Matrices dimensions must be the same');
     d = -1;
 else
     d = 0;
    for i=1:X
        for j=1:Y
           d = d + ((A(i,j) - B(i,j)))^2; 
        end
    end
 end
 

end

