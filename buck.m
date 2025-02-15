%% Introduction to Converter Frequency Response Analysis using MATLAB
% Power Electronics
% University of Colorado Boulder
close all;

% Synchronous Buck dc-dc converter element values based on the LTspice circuit
% model SyncBuck_switching_CL.asc
L = 160e-6; % inductance
Rs = 30e-3; % series resistance RL + Ron
C = 160e-6; % output filter capacitance
Resr = 0.8e-3; % capacitor equivalent series resistance 
Vg = 30; % input voltage
R = 10; % load resistance
VM = 1; % PWM saw-tooth amplitude
Vref = 1.8; % reference voltage
H = 1; % sensing gain
D = 0.6;

%% Gvd transfer function salient features 
wesr = (((1-D)^2) * R)/(D * L); % esr zero
wo = (1-D)/sqrt(C*L); % center frequency of the pair of poles
%Qload = R/sqrt(L/C);
%Qloss = sqrt(L/C)/(Resr+Rs);
Q = (1-D) * R * sqrt(C/L); % Q factor
Gd0 = Vg/((1-D)^2);


%% Open-loop control-to-output transfer function
s = tf('s');
Gvd = Gd0*(1-s/wesr)/(1+(1/Q)*(s/wo)+(s/wo)^2);
% Bode plots of magnitude and phase response 
fmin=10; % minimum frequency = 10 Hz
fmax=1e6; % maximum frequency = 1 MHz
% Set Bode plot options
BodeOptions = bodeoptions;
BodeOptions.FreqUnits = 'Hz'; % we prefer Hz, not rad/s
BodeOptions.Xlim = [fmin fmax]; % frequency-axis limits
BodeOptions.Ylim = {[-100,40];[-180,0]}; % magnitude and phase axes limits
BodeOptions.Grid = 'on'; % include grid
% define plot title
BodeOptions.Title.String = 'Synchronous Buck control-to-output responses';


%% Plot magnitude and phase responses
Gvdfigure=figure(1); 
bode(Gvd,BodeOptions,'b'); % generate the magnitude and phase responses
% The lines below are just to make the plots look nicer
h = findobj(gcf,'type','line');
set(h,'LineWidth',2); % thicker line width
Gvd_axis_handles=get(Gvdfigure,'Children');
axes(Gvd_axis_handles(3)); % magnitude plot, thicker grid lines
ax = gca;
ax.LineWidth = 1; 
ax.GridAlpha = 0.4;
axes(Gvd_axis_handles(2)); % phase plot, thicker grid lines
ax = gca;
ax.LineWidth = 1;
ax.GridAlpha = 0.4;


% Magnitude and phase responses at a specific frequency
fx = 5000; % frequency in Hz
magnitude_in_dB = 20*log10(abs(freqresp(Gvd,fx,'Hz')));
phase_in_degrees = angle(freqresp(Gvd,fx,'Hz'))*180/pi;
% 'angle' returns phase between -pi and pi, unwrap if needed
if phase_in_degrees > 0 
    phase_in_degrees = -360 + phase_in_degrees;
end
fprintf('Magnitude response of Gvd at %1.0f Hz is %1.4f dB\n', fx, magnitude_in_dB);
fprintf('Phase response of Gvd at %1.0f Hz is %1.4f degrees\n', fx, phase_in_degrees);