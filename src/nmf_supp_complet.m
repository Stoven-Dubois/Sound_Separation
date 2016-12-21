function [W_reel_complet,H_reel_complet, fignbr] = nmf_supp_complet(S_reel_complet, W_reel_complet, T_reel_complet,Dim_reel, fignbr, Nb_iterations, Visualisation_reel_complet_supp);
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    max_reel_complet = 1;
    
    
    H_reel_complet = ones(Dim_reel, length(T_reel_complet));
%     W_reel_complet = ones(size(S_reel_complet, 1),Dim_reel);
    
    for i=1:Dim_reel
        for j=1:length(T_reel_complet)
            H_reel_complet(i,j) = max_reel_complet*rand(1);
        end
%         for j = 1:size(S_reel_complet, 1)
%             W_reel_complet(j,i) = max_reel_complet*rand(1);
%         end
    end
    Cbuf = zeros(1,Nb_iterations);
    if Visualisation_reel_complet_supp
        figure(fignbr);
        fignbr = fignbr +1;
    end
    for i=1:Nb_iterations
        [~, H_reel_complet, C_reel_complet] = nmf_non_sup(W_reel_complet, H_reel_complet, S_reel_complet);
        Cbuf(i) = C_reel_complet;
        if Visualisation_reel_complet_supp
            affichage(W_reel_complet, H_reel_complet, Cbuf, S_reel_complet);
            waitforbuttonpress();
        end
    end
end

