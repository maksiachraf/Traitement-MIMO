clear all
close all
clc

num_fig=1;
%% Parametres
M = 2;         % Le nombre d'antennes de receptions
N = 2;         % Le nombre d'antennes d'emission
L = 2;         % Le nombre de symboles
nbs = 2;       % Nombre de bits/symbole 
NbT = nbs*L;   % Nombre de bits emis
Ns = 4;        % Le nombre de symboles dans la constellation

Nr = 1000;     % Le nombre de realisations

SNR_min = 0;  
SNR_max = 10; 
SNR_pas = 1;
SNR = SNR_min:SNR_pas:SNR_max; % SNR en dB

symb_constellation = [exp(1i*pi/4), exp(1i*3*pi/4), exp(1i*5*pi/4), exp(1i*7*pi/4)];
% Generer H
sigma_H = 1;
H = sqrt(sigma_H/2)*( randn(M,N) + 1i*randn(M,N));

%% Simulation de la transmission
proba_err = zeros(1,length(SNR)); % Vecteur des taux d'erreur binaire
for j=1:length(SNR)
    Nb_err = 0;
    for kk=1:Nr
        %% Emetteur
        bits = randn(1,NbT) > 0; % Generation des bits
        S = modulateur_qpsk(bits, NbT, nbs); % Bits -> Symboles
        
        % Code d'Alamouti
        X(1,1) = S(1); 
        X(2,2) = conj(S(1)); 
        X(2,1) = S(2); 
        X(1,2) = -conj(S(2)); 
        
        %% Canal
        sigma_V = 10^(-SNR(j)/10);
        V = sqrt(sigma_V/2)*( randn(M,L) + 1i*randn(M,L));
        Y = H*X + V;
        
        %% Recepteur
        %------------------------------------------------------------------
        z1 = conj(transpose(H(:,1)))*Y(:,1) + conj(transpose(Y(:,2)))*H(:,2); 
        z2 = conj(transpose(H(:,2)))*Y(:,1) - conj(transpose(Y(:,2)))*H(:,1);  
        norm_frob_car_H = norm(H,'fro')^2;
        for i_symb=1:4
            x1_chapeau(i_symb) = abs(z1-norm_frob_car_H*symb_constellation(i_symb))^2;
            x2_chapeau(i_symb) = abs(z2-norm_frob_car_H*symb_constellation(i_symb))^2;
        end
        [~, argmin_x1_chapeau] = min(x1_chapeau);
        [~, argmin_x2_chapeau] = min(x2_chapeau);
        
        S_rec(1) = symb_constellation(argmin_x1_chapeau);
        S_rec(2) = symb_constellation(argmin_x2_chapeau);
        %------------------------------------------------------------------

        bit_rec = demodulateur_qpsk(S_rec); % Demodulation QPSK
        
        % Calcul du nombre d'erreur
        cpt = mean(abs(bits-bit_rec));
        if (cpt ~= 0)
            Nb_err = Nb_err + 1;
        end
    end
    
    % Calcul de la proba d'erreur
    proba_err(j) = Nb_err/Nr;
end


%% Affichage
figure(num_fig)
num_fig=num_fig+1;
semilogy(SNR,proba_err);
hold all
ylim([1e-6 1])
xlabel('SNR en dB', 'FontSize',14)
ylabel("Probabilité d'erreur",'FontSize',14)
grid on 
% ylim([10^(-2) 1])

