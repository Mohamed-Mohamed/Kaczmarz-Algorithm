function [ Gz ] = KaczmarzAlgorithm ( u, y, na, nb, d, gamma, Ts, Plot )
% this function is used to estimate the parameter of discrate the transfer function
% unsing Kaczmarz Algorithm
%% Coded by
% Mohamed Mohamed El-Sayed Atyya
% mohamed.atyya94@eng-st.cu.edu.eg
%% inputs
% u    : input required signal
% y      : output signal to the system
% na   : order of thr Den. of the transfer function of the system
% ab   : order of thr Num. of the transfer function of the system
% d     : order of delay of the system
% gamma : parameter   > 0
% Ts     : sampling time
% Plot          : used to get the plot of system parameter estimation
%                   1 - if Plot = 0  --> no plot needed
%                   2- if Plot = 1  -->  plot needed and Plot(2:3) == figuires number
%% outputs
% Gz              : discreate transfer function

%% function body
theta_hat(:,1)=zeros(na+nb+1,1);
theta_hat(:,2)=zeros(na+nb+1,1);
theta_hat(:,3)=zeros(na+nb+1,1);
for i=4:length(y)
    for j=1:na
        if i-j <=0
            phiT(i,j)=0;
        else
            phiT(i,j)=[-y(i-j)];
        end
    end
    for j=0:nb
        if i-j-d <= 0
            phiT(i,j+1+na)=0;
        else
            phiT(i,j+1+na)=[u(i-j-d)];
        end
    end
    theta_hat(:,i)=theta_hat(:,i-1)+gamma*phiT(i,:)'/(phiT(i,:)*phiT(i,:)')*(y(i)-phiT(i,:)*theta_hat(:,i-1));
end

Theta_hat=theta_hat(:,end);
Gz=tf([Theta_hat(na+1:end)'],[1,Theta_hat(1:na)'],Ts);

for l=1:length(phiT(:,1))
    y1(l)=phiT(l,:)*theta_hat(:,l);
end
%% plottimg
if Plot(1)==1
    figure(Plot(2));
    set(gcf,'color','w')
    hold all;
    for k=1:na+nb+1
        plot((0:length(y1)-1)*Ts,theta_hat(k,:),'linewidth',2);
    end
    grid on;
    for m=1:na
        Ylabel{m}=['a_' num2str(m) ', '];
        Leg{m}=['a_' num2str(m) ];
    end
    for n=1:nb+1
        if n<nb+1
            Ylabel{n+na}=['b_' num2str(n-1) ', '];
            Leg{n+na}=['b_' num2str(n-1) ];
        else
            Ylabel{n+na}=['b_' num2str(n-1)];
            Leg{n+na}=['b_' num2str(n-1) ];
        end
    end
    xlabel('t(s)','fontsize',18);
    Ylabel=cell2mat(Ylabel);
    ylabel(Ylabel,'fontsize',18);
    legend(Leg)
    title('Parameter estimation with time')
    
    figure(Plot(3));
    subplot(3,1,1:2)
    set(gcf,'color','w')
    plot((0:length(y1)-1)*Ts,y,(0:length(y1)-1)*Ts,y1,'-o','linewidth',2);
    grid on;
    ylabel('y, y_e_s_t','fontsize',18);
    legend('y','y_e_s_t')
    subplot(3,1,3)
    plot((0:length(y1)-1)*Ts,abs(y-y1))
    grid on;
    xlabel('t(s)','fontsize',18);
    ylabel('y-y_e_s_t','fontsize',18);
    legend('error')
end
end