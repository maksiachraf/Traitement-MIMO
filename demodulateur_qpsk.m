function [bit_rec] = demodulateur_qpsk(S_rec)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

    bit_rec = [];
    for i=1:length(S_rec)
        if (imag(S_rec(i)) > 0) & (real(S_rec(i)) > 0)
            bit_rec = [bit_rec 0 0];
        elseif (imag(S_rec(i)) > 0) & (real(S_rec(i)) < 0)
            bit_rec = [bit_rec 0 1];
        elseif (imag(S_rec(i)) < 0) & (real(S_rec(i)) < 0)
            bit_rec = [bit_rec 1 1];
        else
            bit_rec = [bit_rec 1 0];
        end
    end
end

