clear all
close all
clc

num_fig=1;
%% Parametres
M = 2;         % Le nombre d'antenne de receptions
N = 2;         % Le nombre d'antenne d'emission
L = 2;         % Le nombre de symboles
nbs = 2;       % Nombre de bits/symbole 
NbT = nbs*N*L; % Nombre de bits emis
Ns = 4;        % Le nombre de symboles dans la constellation

Nr = 1000;     % Le nombre de realisations

SNR_min = 0;  
SNR_max = 10; 
SNR_pas = 1;
SNR = SNR_min:SNR_pas:SNR_max; % SNR en dB

% Generer H
sigma_H = 1;
H = sqrt(sigma_H/2)*( randn(M,N) + 1i*randn(M,N));

% Generer C
symb_constellation = [exp(1i*pi/4), exp(1i*3*pi/4), exp(1i*5*pi/4), exp(1i*7*pi/4)];
matrix_C = construire_ensbl_mat(symb_constellation, N, L, Ns);

%% Simulation de la transmission
proba_err = zeros(1,length(SNR)); % Vecteur des taux d'erreur binaire
for j=1:length(SNR)
    Nb_err = 0;
    for kk=1:Nr
        %% Emetteur
        bits = randn(1,NbT) > 0; % Generation des bits
        S = modulateur_qpsk(bits, NbT, nbs); % Bits -> Symboles
        X = reshape(S, N, L);
        
        %% Canal
        sigma_V = 10^(-SNR(j)/10);
        V = sqrt(sigma_V/2)*( randn(M,L) + 1i*randn(M,L));
        Y = H*X + V;
        
        %% Recepteur
%         S_rec = decodeur_ML(Y, H, matrix_C); %Decodage ML
        S_rec = decodeur_ZF(Y, H, symb_constellation); %Decodage ZF
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

ylim([10^(-2) 1])
% legend('ML', 'ZF')

%%%%%%
%zf est plus rapide mais beaucoup moins performant.



