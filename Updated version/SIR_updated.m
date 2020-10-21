function SIR_simulation

%%%% Set the parameters
global alpha;
alpha = 0.0;
global beta;
beta = 0.0;
global number_of_lockdown;
number_of_lockdown=0;
%%%% Set the initial conditions
S0 = 0.99;
I0 = 0.01;
R0 = 0;
u0 = [S0, I0, R0]';

%%% Set the time interval
t0 = 0;
tend = 10;

Sol = ode45(@ODEs, [t0,tend], u0);

%%% Matlab returns the solution as a structure with fields Sol.x (the t
%%% values) and Sol.y (the solution vector at each time). We can plot the
%%% solution directly:
%plot(Sol.x, Sol.y);

%%% Or at times of our choice using the function deval
t_refined = t0:0.1:tend;
Sol_refined = deval(Sol, t_refined);

h = figure;
filename = 'testAnimated.gif'; 

for i=1:1:length(t_refined)
    plot(t_refined(i), Sol_refined(2,i),'.r','MarkerSize',15);
    plot(t_refined(i), Sol_refined(3,i),'.g','MarkerSize',15);
    plot(t_refined(i), Sol_refined(1,i),'.b','MarkerSize',15);
    hold on
    grid on
    xlabel('t');
    figTitleName = sprintf('COVID-19');
    title(figTitleName);
    legend('Susceptible', 'Infected', 'Recovered');
    %pause (0.3);
    drawnow 
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256);
    if i == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
    else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
    end
end

function dudt = ODEs(t,u)

S = u(1);
I = u(2);
R = u(3);

alpha=alpha+0.02;
beta=beta+0.005;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%lockdown
if (I>=0.25)
    if number_of_lockdown == 0   
        alpha=0.001;
        number_of_lockdown=number_of_lockdown+1;
    end
end 
if (R>=0.25)
    alpha=alpha+0.15;
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%s
dSdt = -alpha*S*I;
dIdt = alpha*S*I-beta*I;
dRdt = beta*I;

dudt = 0*u;

dudt(1) = dSdt;
dudt(2) = dIdt;
dudt(3) = dRdt;

end

end