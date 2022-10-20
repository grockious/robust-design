
clear all
clear 
clc

dt = 0.001;
t_f = 20;

A = [zeros(2), eye(2);
    12.49 -12.54 0 0;
    -14.49 29.36 0 0];

B = [0; 0; -2.98; 5.98];

D = [zeros(2,2); eye(2)];

C = [diag([1,1,1,1]);zeros(1,4)];
E = [zeros(4,1);1];
gamma = 30;

[K_lqr,~,~] = lqr(A,B,C'*C,E'*E);
[P_inf,K_inf,L_inf] = solve_ARE(A, B, D, C'*C, E'*E, gamma);

sys_lqr = ss(A-B*K_lqr,D,C-E*K_lqr,zeros(5,2));
sys_tf_lqr = tf(sys_lqr);
[ninf_lqr,~] = hinfnorm(sys_tf_lqr);

sys_inf = ss(A-B*K_inf,D,C-E*K_inf,zeros(5,2));
sys_tf_inf = tf(sys_inf);
[ninf_inf,~] = hinfnorm(sys_tf_inf);

X_inf = zeros(floor(t_f/dt+1),4);
X_lqr = zeros(floor(t_f/dt+1),4);
X_inf(1,:) = [0,-5,10,10];
X_lqr(1,:) = [0,-5,10,10];

for step = 1:floor(t_f/dt)
    noise = normrnd(0,1,[2,1]);
    x_lqr = X_lqr(step,:)';
    x_lqr = x_lqr + (A*x_lqr - B*K_lqr*x_lqr)*dt + D*noise*sqrt(dt);
    X_lqr(step+1,:) = x_lqr';

    x_inf = X_inf(step,:)';
    x_inf = x_inf + (A*x_inf - B*K_inf*x_inf)*dt + D*noise*sqrt(dt);
    X_inf(step+1,:) = x_inf';
end

figure(1)
plot(0:dt:t_f,X_inf(:,1:2),'LineWidth',1.2);
xlabel({'\bf Time (s)'},'Interpreter','latex','fontweight','bold','FontSize',20)
ylabel({'$\mathbf{\theta}$ (deg) '},'Interpreter','latex','fontweight','bold','FontSize',20)
legend('$\mathbf{\theta_1}$', '$\mathbf{\theta_2}$', 'Interpreter','latex','fontweight','bold','FontSize',20)
set(gca,'FontSize',20)
set(gca,'XLim',[0,t_f])
set(gca,'YLim',[-50,100])
grid on

figure(2)
plot(0:dt:t_f,X_inf(:,3:4),'LineWidth',1.2);
xlabel({'\bf Time (s)'},'Interpreter','latex','fontweight','bold','FontSize',20)
ylabel({'$\mathbf{\dot{\theta}}$ (deg/s) '},'Interpreter','latex','fontweight','bold','FontSize',20)
legend('$\mathbf{\dot{\theta}_1}$', '$\mathbf{\dot{\theta}_2}$','Interpreter','latex','fontweight','bold', 'FontSize',20)
set(gca,'FontSize',20)
set(gca,'XLim',[0,t_f])
set(gca,'YLim',[-300,600])
grid on

figure(3)
plot(0:dt:t_f,X_lqr(:,1:2),'LineWidth',1.2);
xlabel({'\bf Time (s)'},'Interpreter','latex','fontweight','bold','FontSize',20)
ylabel({'$\mathbf{\theta}$ (deg) '},'Interpreter','latex','fontweight','bold','FontSize',20)
legend('$\mathbf{\theta_1}$', '$\mathbf{\theta_2}$', 'Interpreter','latex','fontweight','bold', 'FontSize',20)
set(gca,'FontSize',20)
set(gca,'XLim',[0,t_f])
set(gca,'YLim',[-50,100])
grid on

figure(4)
plot(0:dt:t_f,X_lqr(:,3:4),'LineWidth',1.2);
xlabel({'\bf Time (s)'},'Interpreter','latex','fontweight','bold','FontSize',20)
ylabel({'$\mathbf{\dot{\theta}}$ (deg/s) '},'Interpreter','latex','fontweight','bold','FontSize',20)
legend('$\mathbf{\dot{\theta}_1}$', '$\mathbf{\dot{\theta}_2}$','Interpreter','latex','fontweight','bold', 'FontSize',20)
set(gca,'FontSize',20)
set(gca,'XLim',[0,t_f])
set(gca,'YLim',[-300,600])
grid on
