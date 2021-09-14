% MTRN2500 20T3 Assignment 2 - z5207471 %

% Variables used in parts 1 & 2
l = 1;            % Length of the pendulum in meters (constant)
m = 1;            % Mass of the pendulum bob in kilograms (constant)
g = 9.81;         % Gravitational acceleration in m/s^2 (constant)
k = 4;            % Steady state friction of the system in Newtons (initialised with value for part 1)
timeSpan = [0 5]; % Time span of the experiment in seconds (initialised with values for part 1)

%====== Part 1 ========================================
initConds = linspace(-2*pi, 2*pi, 100); % Initial condition values
figure('Name','Part 1 Figure - z5207471','NumberTitle','off');
hold on % Enable hold, since multiple plots are required on the same figure
for n = 1:100 % Plot the solution across the given timespan for each of the 100 initial conditions
	[t,v] = ode45(@(t,v) System(t,v,l,m,g,k),timeSpan,[initConds(n); 0]); % Get solutions for v1 and v2
	plot(t,v(:,1),'-');  % Plot the solution of v1
end
hold off
title('Solutions of Equation 3 Under Varying Initial Conditions');
xlabel('Time t (s)');
ylabel('$\mathrm{v_1 (rad)}$', 'Interpreter', 'latex'); % Use LaTex interpreter to enable use of subscript

%====== Part 2 ========================================
k = 0.5; % Steady state friction of the system in Newtons (Change value to 0.5 for part 2)
timeSpan = [0 20]; % Time span of the experiment in seconds (Change values to 0, 20 for part 2)
theta_0 = -pi+0.1; % Given initial condition for theta

[t,v] = ode45(@(t,v) System(t,v,l,m,g,k),timeSpan,[theta_0; 0]); % Get solutions for v1 and v2

% Plot of angular position over time
figure('Name','Part 2 Figure - z5207471','NumberTitle','off');
subplot(2,2,3);
plot(t,v(:,1),'-');
grid on
maxVal = max(abs(v(:,1))); % Obtain maximum magnitude of solution values
axis([0,20,-maxVal,maxVal]); % Set x-axis to span from 0 to 20 seconds, and y-axis to be tight and symmetrical
title('Angular Position');
xlabel('t (sec)');
ylabel('\Theta(t) (rad)');

% Plot of angular velocity over time
subplot(2,2,4);
plot(t,v(:,2),'-')
grid on
maxVal = max(abs(v(:,2))); % Obtain maximum magnitude of solution values
axis([0,20,-maxVal,maxVal]); % Set x-axis to span from 0 to 20 seconds, and y-axis to be tight and symmetrical
title('Angular Velocity');
xlabel('t (sec)');
ylabel('$\mathrm{\dot{\theta}(t) (rad/s)}$', 'Interpreter', 'latex'); % Use LaTex interpreter to enable use of theta-dot symbol

% Animated plot of pendulum position over 20 seconds
subplot(2,1,1); % Set subplot to be set in the middle of the first row
box on % Enable box, to show an outline around all plot edges
axis([-1.2,1.2,-1.2,1.2]);

% Set ticks of both axes to be identical
animPlotTicks = [-1,-0.5,0,0.5,1]; % Define the tick values for both axes in the animated plot
xticks(animPlotTicks);
yticks(animPlotTicks);

daspect([1 1 1]); % Set both axes to be of same scale, for accurate visual representation

% Obtain x and y coordinates for the pendulum bob from theta values
x_pos = sin(v(:,1));
y_pos = -cos(v(:,1));

title('Pendulum Simulation');
xlabel('x (m)');
ylabel('y (m)');
hold on

% Define object handles for the time label text and arm and bob plots
% Display time and position for initial time value
tLabel = text(-1.1,1,['Time = ' num2str(t(1))],'HorizontalAlignment','left');
arm = plot([0, x_pos(1)],[0, y_pos(1)],'-', 'Color', 'k'); % Plot the arm as a line from (0,0) to bob position, in black
bob = plot(x_pos(1), y_pos(1), 'O', 'Color', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 10); % Plot the bob as a size 10 circle, in black

hold off
% For each time value in the interval 0-20s, display the time, arm and bob
for n = 2:length(t)
   drawnow % Refresh the plot to display current state
   pause(0.01)
   tLabel.String = ['Time = ' num2str(t(n))]; % Update time label text
   % Update data of plots for arm and bob
   arm.XData = [0, x_pos(n)];
   arm.YData = [0, y_pos(n)];
   bob.XData = x_pos(n);
   bob.YData = y_pos(n);
end

%====== System model definition ========================
% Defines equation 3 from the assignment brief
% The state-space representation of the second-order ODE representing the
% motion of a pendulum with time-varying friction
function vDot = System(t,v,l,m,g,k)
    vDot = [v(2); -g/l*sin(v(1))-(2*exp(-0.3*t)+k)/m*v(2)];
end