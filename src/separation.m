%% TP de traitement avancée du son, sur le sujet de la séparation des sources audio.
% Auteurs : Alexis Stoven-Dubois, Oscar Widemann

clear all;
close all;

fignbr = 1;

%% Chargement des fichiers audio

% Exemple du piano do-mi-sol-accord
[Piano_simple,Fpiano_simple] = audioread('audioSource_mix.wav');

% Exemple réel
[Reel_complet,Freel_complet] = audioread('sunrise-Mix_Bal_Pan.wav');
[Reel_guitare,Freel_guitare] = audioread('acoustik_gtr.wav');
[Reel_bass,Freel_bass] = audioread('bass.wav');
[Reel_cello,Freel_cello] = audioread('cello.wav');
[Reel_drums,Freel_drums] = audioread('drums.wav');
[Reel_electrique,Freel_electrique] = audioread('elec_gtrs.wav');
[Reel_lead,Freel_lead] = audioread('lead_vocal.wav');
[Reel_piano,Freel_piano] = audioread('piano.wav');
[Reel_voix2,Freel_voix2] = audioread('voic_harmo2.wav');
[Reel_voix1,Freel_voix1] = audioread('voix_harmo1.wav');
Reel_instruments = [Reel_guitare(:,1),Reel_bass(:,1),Reel_cello(:,1),Reel_drums(:,1),Reel_electrique(:,1),Reel_lead(:,1),Reel_piano(:,1),Reel_voix2(:,1),Reel_voix1(:,1)];
nom_instruments = stringArray('guitare', 'bass', 'cello', 'drums', 'electrique', 'lead', 'piano', 'voix2', 'voix1');

% Nombre de voies du morceau réel
nb_pistes = 9;

% Les fréquences étant toutes les mêmes, on pose :
F = Fpiano_simple;

%% Paramètres

% Pour les dimensions d'W et de H, on prend un paramètre pour l'exemple
% simple connu (3), et un entre 50 et 100 pour l'exemple réel.
Dim_piano = 3;
Dim_reel = 50;
Dim_instruments = 30;

% Nombre d'itération fixe de l'algorithme du NMF
Nb_iterations = 50;

% Bornes du segment d'apprentissage et de test
min_base = 90*Freel_complet+1;
max_base = 100*Freel_complet;
min_test = min_base;
max_test = max_base;
%min_test = 120*Freel_complet+1;
%max_test = 130*Freel_complet;

% Paramètres permettant de visualiser l'évolution des différents algorithmes
Visualisation_piano_simple_non_supp = 0;
Visualisation_reel_complet_non_supp = 0;
Visualisation_reel_complet_supp = 0;

% Paramètres permettant d'entendre les signaux reconstruits
Reconstruction_piano_simple_non_supp = 0;
Reconstruction_reel_complet_non_supp = 1;
Reconstruction_reel_complet_supp = 0;


%% Exemple du piano simple, NMF non supervisée

if Visualisation_piano_simple_non_supp || Reconstruction_piano_simple_non_supp
    window = 2048;
    noverlap = 1024;
    nfft = 2048;
    [S_piano_simple, F_piano_simple, T_piano_simple] = stft(Piano_simple,window, noverlap, nfft, Fpiano_simple);
    
    Phase_piano_simple = angle(S_piano_simple);
    S_piano_simple = abs(S_piano_simple);
    [W_piano_simple,H_piano_simple, fignbr] = nmf_non_supp_complet(S_piano_simple, T_piano_simple,Dim_piano, fignbr, Nb_iterations, Visualisation_piano_simple_non_supp);
end
%% Reconstruction du signal du piano simple

if Reconstruction_piano_simple_non_supp
    fprintf('Reconstruction du signal du piano simple\n');
    for i=1:Dim_piano
        fprintf('Joue le son numéro : %d\n', i);
        [signal_piano, F_piano] = jouer_son(W_piano_simple,H_piano_simple,Phase_piano_simple,noverlap, nfft, Fpiano_simple,i);
        waitforbuttonpress();
        clear sound;
        name = char(strcat('results/note', char(i), '.wav'));
        audiowrite(name,signal_piano, F_piano);
    end
    [signal_piano, F_piano] = jouer_son(W_piano_simple,H_piano_simple,Phase_piano_simple,noverlap, nfft, Fpiano_simple,0);
    fprintf('Joue le morceau reconstruit\n');
    sound(signal_piano, F_piano);
    waitforbuttonpress();
    clear sound;
    audiowrite('results/piano_reconstruit.wav',signal_piano, F_piano);
end

%% Exemple réel, NMF non supervisée

if Visualisation_reel_complet_non_supp || Reconstruction_reel_complet_non_supp
    
    window = 2048;
    noverlap = 1024;
    nfft = 2048;
    [S_reel_complet, F_reel_complet, T_reel_complet] = stft(Reel_complet(min_test:max_test,1),window, noverlap, nfft, Freel_complet);
    Phase_reel_complet = angle(S_reel_complet);
    S_reel_complet = abs(S_reel_complet);
    [W_reel_complet,H_reel_complet, fignbr] = nmf_non_supp_complet(S_reel_complet, T_reel_complet,Dim_reel, fignbr, Nb_iterations, Visualisation_reel_complet_non_supp);
    
end

%% Reconstruction du signal réel par NMF non suppervisé

if Reconstruction_reel_complet_non_supp
    fprintf('Reconstruction du signal du morceau de musique\n');
        i = 1;
        clear sound;
        while i < Dim_reel
            fprintf('Joue le son numéro : %d\n', i);
            jouer_son(W_reel_complet,H_reel_complet,Phase_reel_complet,noverlap, nfft, Freel_complet,i);
            waitforbuttonpress();
            clear sound;
            i = i + floor(Dim_reel/5);
        end
    %[signal_reel_non_supp, F_reel_non_supp] = jouer_son(W_reel_complet,H_reel_complet,Phase_reel_complet,noverlap, nfft, Freel_complet,0);
    [signal_reel_non_supp, F_reel_non_supp] = jouer_son_filtre(W_reel_complet,H_reel_complet, W_reel_complet, H_reel_complet,S_reel_complet,Phase_reel_complet,noverlap, nfft, Freel_complet);
    fprintf('Joue le morceau reconstruit\n');
    sound(signal_reel_non_supp, F_reel_non_supp);
    waitforbuttonpress();
    clear sound;
    audiowrite('results/reel_reconstruit_non_supp.wav',signal_reel_non_supp, F_reel_non_supp);
end

%% Exemple réel, NMF supervisée

if Visualisation_reel_complet_supp || Reconstruction_reel_complet_supp
    
    window = 2048;
    noverlap = 1024;
    nfft = 2048;
    
    Sig_instruments=zeros(nb_pistes,max_base+1-min_base);
    S_reel_instruments=zeros(nb_pistes,1+floor(nfft/2), floor(length(Sig_instruments)/noverlap)-1);
    F_reel_instruments=zeros(nb_pistes,1,(floor(window/2))+1);
    T_reel_instruments=zeros(nb_pistes,1,floor(length(Sig_instruments)/noverlap)-1);
    Phase_reel_instruments=zeros(nb_pistes,1+floor(nfft/2),floor(length(Sig_instruments)/noverlap)-1);
    W_reel_instruments=zeros(nb_pistes,1+floor(nfft/2),Dim_instruments);
    H_reel_instruments=zeros(nb_pistes,Dim_instruments,floor(length(Sig_instruments)/noverlap)-1);
    
    for i=1:nb_pistes
        Sig_instruments(i,:) = Reel_instruments(min_base:max_base,i);
        [S_reel_instruments(i,:,:), F_reel_instruments(i,:,:), T_reel_instruments(i,:,:)] = stft(Sig_instruments(i,:),window, noverlap, nfft, Freel_complet);
        Phase_reel_instruments(i,:,:) = angle(S_reel_instruments(i,:,:));
        S_reel_instruments(i,:,:) = abs(S_reel_instruments(i,:,:));
        [W_reel_instruments(i,:,:),H_reel_instruments(i,:,:), fignbr] = nmf_non_supp_complet(squeeze(S_reel_instruments(i,:,:)), squeeze(T_reel_instruments(i,:,:))',Dim_instruments, fignbr, Nb_iterations, 0);
    end
    
    W_final_instruments = squeeze(W_reel_instruments(1,:,:));
    for j=2:nb_pistes
        W_final_instruments = horzcat(squeeze(W_final_instruments), squeeze(W_reel_instruments(j,:,:)));
    end
    
    [S_reel_complet, F_reel_complet, T_reel_complet] = stft(Reel_complet(min_test:max_test,1),window, noverlap, nfft, Freel_complet);
    Phase_reel_complet = angle(S_reel_complet);
    S_reel_complet = abs(S_reel_complet);
    [W_reel_complet,H_reel_complet, fignbr] = nmf_supp_complet(S_reel_complet, W_final_instruments, T_reel_complet, Dim_instruments*nb_pistes, fignbr, Nb_iterations, Visualisation_reel_complet_supp);
    
end

%% Reconstruction du signal réel par NMF suppervisé

if Reconstruction_reel_complet_supp
    fprintf('Reconstruction du signal du morceau de musique\n');
    clear sound;
    
    % son avant apprentissage des pistes, ici i=5 : electrique
    %[signal_instr, F_instr] = jouer_son(squeeze(W_reel_instruments(5,:,:)),squeeze(H_reel_instruments(5,:,:)),squeeze(Phase_reel_instruments(5,:,:)),noverlap, nfft, Freel_complet,0)
    
    for i=1:nb_pistes
        %[signal_reel_supp, F_reel_supp] = jouer_son(W_reel_complet(:,1+(i-1)*Dim_instruments:i*Dim_instruments),H_reel_complet(1+(i-1)*Dim_instruments:i*Dim_instruments,:),Phase_reel_complet,noverlap, nfft, Freel_complet,0);
        [signal_reel_supp, F_reel_supp] = jouer_son_filtre(W_reel_complet(:,1+(i-1)*Dim_instruments:i*Dim_instruments),H_reel_complet(1+(i-1)*Dim_instruments:i*Dim_instruments,:), W_reel_complet, H_reel_complet,S_reel_complet,Phase_reel_complet,noverlap, nfft, Freel_complet);
        fprintf('Joue la piste : %s\n', nom_instruments(i));
        sound(signal_reel_supp, F_reel_supp);
        waitforbuttonpress();
        clear sound;
        name = char(strcat('results/reel_', nom_instruments(i), '.wav'));
        audiowrite(name,signal_reel_supp, F_reel_supp);
    end
    
    %[signal_reel_supp, F_reel_supp] = jouer_son(W_reel_complet,H_reel_complet,Phase_reel_complet, noverlap, nfft, Freel_complet,0);
    [signal_reel_supp, F_reel_supp] = jouer_son_filtre(W_reel_complet,H_reel_complet, W_reel_complet, H_reel_complet,S_reel_complet,Phase_reel_complet,noverlap, nfft, Freel_complet);
    fprintf('Joue le morceau reconstruit\n');
    sound(signal_reel_supp, F_reel_supp);
    waitforbuttonpress();
    clear sound;
    audiowrite('results/reel_reconstruit.wav',signal_reel_supp, F_reel_supp);
end