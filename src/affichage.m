function [  ] = affichage( W, H, C, S )
%AFFICHAGE Affiche proprement tout le bordel
%   Appel : affichage(W, H, C, S)

%% affichage du coup en fonction du temps
subplot('position', [0.03,0.55,0.44,0.42]);
plot(C);

%% affichage de W
nb_affichage = min(10,size(W,2));
for i=1:nb_affichage
    subplot('position',[0.01 + i*0.1/nb_affichage + (i-1)*0.40/nb_affichage,0.03, 0.40/nb_affichage, 0.48]);
    imagesc(20*log10(W(:,i)));
    axis  xy;
end
% subplot('position',[0.19, 0.02, 0.15, 0.48]);
% imagesc(20*log10(W(:,2)));
% axis  xy;
% subplot('position',[0.36, 0.02, 0.15, 0.48]);
% imagesc(20*log10(W(:,3)));
% axis  xy;

%% affichage de H
nb_affichage = min(10,size(H,1));
for i=1:nb_affichage
    subplot('position',[0.53,0.50 + i*0.1/nb_affichage + (i-1)*0.40/nb_affichage,0.45, 0.40/nb_affichage]);
    imagesc(20*log10(H(i,:)));
    axis  xy;
end
% subplot('position',[0.53,0.67,0.45, 0.15]);
% imagesc(20*log10(H(2,:)));
% axis  xy;
% subplot('position',[0.53,0.83,0.45, 0.15]);
% imagesc(20*log10(H(3,:)));
% axis  xy;

%% affichage de S
subplot('position',[0.53,0.02,0.45, 0.48]);
imagesc(20*log10(S));
axis  xy;

end

