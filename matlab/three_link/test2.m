%% Learning-based algorithm
I = 20;
J = 20;

A = [zeros(3), eye(3);
    12.54 -8.26 -0.39 -0.043 2.75 -0.36;
    -4.38 36.95 -3.00 0.086 -9.57 2.29;
    -6.82 -22.94 11.93 -0.034 6.82 -2.86;];

B = [zeros(3,2);
    -50.0 6.12;
    174.4 -38.93;
    -124.2 48.62;];

D = [zeros(3,3);eye(3)];

[P, K, L] = solve_ARE(A, B, D, Q, R, gamma-2);
[T_v_vs, T_vs_v] = Trans_vec_vecs(xn);
T_xx_vecv = Trans_kron_vecv(xn);
T_vt = Trans_vec(un,xn);

K_store = zeros(I,un,xn);
K_store(1,:,:) = K;
P_store = zeros(I,J,xn,xn);
L_store = zeros(I,J,wn,xn);

for i = 1:I
    L = zeros(wn, xn);
    for j = 1:J
        LD = kron(eye(xn),L'*D') + kron(L'*D',eye(xn));
        LD = T_v_vs*LD*T_vs_v;                
        KI = T_v_vs*(kron(eye(xn), K') + kron(K', eye(xn))*T_vt);        
        Q_KL = Q + K'*R*K - gamma^2*(L'*L);
        
        Lambda = Phi_inv(1:n_vecv,:)*Xi - KI*Phi_inv(n_vecv+1:n_vecv+xn*un,:)*Xi + LD;
         
        [ZZ,RankFlag] = chol(Lambda'*Lambda);
        RankFlag
        
        P_vecs = -pinv(Lambda)*vecs(Q_KL);   

        P = vecs_inv(P_vecs);
        L = gamma^(-2)*D'*P;
        L_store(i,j,:,:) = L;
        P_store(i,j,:,:) = P;
    end   
    BP = Phi_inv(n_vecv+1:n_vecv+xn*un,:)*Xi*P_vecs;
    BP = reshape(BP,[un,xn]);
    K = R^(-1)*BP;
    K_store(i+1,:,:) = K;
end

[P_opt, K_opt, L_opt] = solve_ARE(A, B, D, Q, R, gamma);

Knorm = zeros(I+1,1);
for i=1:I+1
    Knorm(i) = norm(reshape(K_store(i,:,:),[un,xn])-K_opt, "fro")/norm(K_opt, "fro");
end
figure(1)
plot(1:I+1,Knorm,'-o','LineWidth',1.3)
xlabel({'\bf Iterations'},'Interpreter','latex', 'FontSize',30)
ylabel({'\bf Error'},'Interpreter','latex','FontSize',30)
title('Gain Matrix Error','Interpreter','latex','FontSize',30)
legend({'$||K_i - K^\star||_F/||K^\star||_F$'},'Interpreter','latex','FontSize',30)
set(gca,'FontSize',30)
grid on
xlim([1,I+1])
grid on
set(gca, 'LooseInset', [0,0,0,0]);
% set (gcf,'Position',[0,0,500,500]);
saveas(gca, 'Plots/Knorm_learn_triple.eps', 'epsc')

Pnorm = zeros(I,1);
for i=1:I
    Pnorm(i) = norm(reshape(P_store(i,end,:,:),[xn,xn])-P_opt, "fro")/norm(P_opt, "fro");
end
figure(2)
plot(1:I,Pnorm,'-o','LineWidth',1.3)
xlabel({'\bf Iterations'},'Interpreter','latex','FontSize',30)
ylabel({'\bf Error'},'Interpreter','latex','FontSize',30)
title('Cost Matrix Error','Interpreter','latex','FontSize',30)
legend({'$||P_{K_i} - P^\star||_F/||P^\star||_F$'},'Interpreter','latex','FontSize',30)
set(gca,'FontSize',30)
xlim([1,I])
grid on
set(gca, 'LooseInset', [0,0,0,0]);
% set (gcf,'Position',[0,0,500,500]);
saveas(gca, 'Plots/Pnorm_learn_triple.eps', 'epsc')

Hnorm = zeros(I+1,1);
for i=1:I+1
    Ki = reshape(K_store(i,:,:),[un,xn]);
    sys_lqr = ss(A-B*Ki,D,C-E*Ki,zeros(xn+un,wn));
    sys_tf_lqr = tf(sys_lqr);
    [ninf,~] = hinfnorm(sys_tf_lqr);
    Hnorm(i) = ninf;
end
figure(3)
plot(1:I+1,Hnorm,'-o','LineWidth',1.3)
xlabel({'\bf Iterations'},'Interpreter','latex','FontSize',30)
ylabel({'\bf $Norm$'},'Interpreter','latex','FontSize',30)
title('\bf $\mathbf{\mathcal{H}_\infty} Norm$','Interpreter','latex','FontSize',30)
legend({'$||\mathcal{T}(K_i)||_{\mathcal{H}_{\infty}}$'},'Interpreter','latex','FontSize',30)
set(gca,'FontSize',30)
xlim([1,I+1])
ylim([23,25])
grid on
set(gca,'YTick',[23,25]);
set(gca, 'LooseInset', [0,0,0,0]);
saveas(gca, 'Plots/Hnorm_learn_triple.eps', 'epsc')
% set (gcf,'Position',[0,0,500,500]);

