function SIR_simulation
clear all, clc;
%%%% Set the initial parameters
alpha = 3;%reproduction number
beta = 0.9;%recovering parameter
%%%% Set the initial conditions
S0 = 0.99;
I0 = 0.01;
R0 = 0;
u0 = [S0, I0, R0]';


%%% Matlab returns the solution as a structure with fields Sol.x (the t
%%% values) and Sol.y (the solution vector at each time). We can plot the
%%% solution directly:
%plot(Sol.x, Sol.y);

%%% Or at times of our choice using the function deval

%%% Set the time interval
t0 = 0;
tend = 8;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% alpha is the reproduction number where 
t_i =3; %is the average time of incubation period
t_c =5; %is the average time of contagious period
t_2 =2.8; %is the average time of doubling period
%alpha = (1.0+ log(2)*t_i/t_2)*(1.0+ log(2)*t_c/t_2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h = figure;
filename = 'testAnimated.gif';
beta=0.0;
alpha=0.0;
for n = 1.0:0.1:6.0
    alpha = n;
    beta = beta+0.03;
    %alpha = (1.0+log(2)*t_i/t_2)*(1.0+ log(2)*t_c/t_2);
  %  Sol = ode45(@ODEs, [t0,tend], u0);
   % t_refined = t0:0.1:tend;
  %  Sol_refined = deval(Sol, t_refined);
    Sol = ode45(@ODEs, [t0,n], u0);
    t_refined = t0:0.1:n;
    Sol_refined = deval(Sol, t_refined);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    plot(t_refined, Sol_refined,'Linewidth',1.5);
    xlabel('t');
    %figTitleName = sprintf('Parameter alpha = %0.1f',alpha);
    figTitleName = sprintf('alpha = %0.1f and beta = %0.2f',alpha,beta);
    title(figTitleName);
    legend('Susceptible', 'Infected', 'Recovered');
    pause (0.5);
    drawnow 
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256);
    if n == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
    else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

function dudt = ODEs(t,u)

S = u(1);
I = u(2);
R = u(3);

dSdt = -alpha*S*I;
dIdt = alpha*S*I-beta*I;
dRdt = beta*I;

dudt = 0*u;

dudt(1) = dSdt;
dudt(2) = dIdt;
dudt(3) = dRdt;

end

end


