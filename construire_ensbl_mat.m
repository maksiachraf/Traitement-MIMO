function [C_3d] = construire_ensbl_mat(symb_const, N, L, Ns)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    card_C = Ns^(N*L);
    C_2d = zeros(card_C, Ns);
    compteur = 1;
    for i=1:Ns
        for j=1:Ns
            for s=1:Ns
                for f=1:Ns                
                    C_2d(compteur,:)=[symb_const(i),symb_const(j),symb_const(s),symb_const(f)];
                    compteur=compteur+1;
                end
            end
        end
    end

    for ii=1:card_C
        C_3d(:,:,ii) = reshape(C_2d(ii, :), 2,2);
    end
end

