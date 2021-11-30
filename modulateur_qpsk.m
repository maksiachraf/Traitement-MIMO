function [S] = modulateur_qpsk(bits, NbT, nbs)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    symb_constellation = [exp(1i*pi/4), exp(1i*3*pi/4), exp(1i*5*pi/4), exp(1i*7*pi/4)];
    for i=1:NbT/nbs
        if (bits(1,(i-1)*nbs+1:i*nbs) == [0 0])
            S(1,i) = symb_constellation(1);
        elseif (bits((i-1)*nbs+1:i*nbs) == [0 1])
            S(1,i) = symb_constellation(2);
        elseif (bits((i-1)*nbs+1:i*nbs) == [1 1])
            S(1,i) = symb_constellation(3);
        else
            S(1,i) = symb_constellation(4);
        end
    end
end

