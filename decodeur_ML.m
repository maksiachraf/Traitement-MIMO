function [S_rec] = decodeur_ML(Y, H, matrix_C)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

        [dim1, dim2, dim3] = size(matrix_C);
        for jj=1:dim3
            vect_norm_fro(jj) = norm(Y-H*matrix_C(:,:,jj),'fro');
        end
        [~, id_min_norm_fro] = min(vect_norm_fro);
        X_chapeau = matrix_C(:,:, id_min_norm_fro);
        S_rec = reshape(X_chapeau, 1, dim1*dim2);
end

