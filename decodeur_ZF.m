function [S_rec] = decodeur_ZF(Y, H, val)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
        
    [N, L] = size(H);

    Fzf = pinv(transpose(conj(H))); % Le filtre ZF
    Z = transpose(conj(Fzf))*Y; % Filtrage du signal recu
    
    X_chapeau = zeros(N,L);
    for u=1:N
        for v=1:L
            vect_abs = zeros(1,N*L);
            for jjj=1:N*L
                vect_abs(jjj) = (abs(Z(u,v)-val(jjj)))^2;
            end
            [~, id_min_vect_abs] = min(vect_abs);
            X_chapeau(u,v) = val(id_min_vect_abs);
        end
    end
    S_rec = reshape(X_chapeau, 1,N*L);
end

