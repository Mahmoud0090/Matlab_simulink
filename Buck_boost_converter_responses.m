close all;

% Synchronous Buck dc-dc converter element values
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
Q = (1-D) * R * sqrt(C/L); % Q factor
Gd0 = Vg/((1-D)^2);

%% Open-loop control-to-output transfer function
s = tf('s');
Gvd = Gd0*(1-s/wesr)/(1+(1/Q)*(s/wo)+(s/wo)^2);

%% Plot magnitude and phase responses
figure;
bode(Gvd); % generate the magnitude and phase responses

% Set plot options
set(gca, 'XScale', 'log'); % set logarithmic scale for frequency axis
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Synchronous Buck control-to-output responses');
grid on;

% Magnitude and phase responses at a specific frequency
fx = 5000; % frequency in Hz
[magnitude_in_dB, phase_in_degrees] = bode(Gvd, 2*pi*fx); % Obtain magnitude and phase at a specific frequency
magnitude_in_dB = 20*log10(magnitude_in_dB); % Convert magnitude to dB
phase_in_degrees = unwrap(phase_in_degrees) * 180/pi; % Unwrap phase and convert to degrees
fprintf('Magnitude response of Gvd at %1.0f Hz is %1.4f dB\n', fx, magnitude_in_dB);
fprintf('Phase response of Gvd at %1.0f Hz is %1.4f degrees\n', fx, phase_in_degrees);

