% FDMA (Frequency Division Multiple Access) Simulation in MATLAB
% This script simulates multiple users transmitting simultaneously
% using different frequency bands (carriers), and combines them
% into a single composite signal.

clc;
clear;

%% Simulation Parameters
fs = 10000;          % Sampling frequency (in Hz)
t = 0:1/fs:1;        % Time vector for 1 second duration

%% Generate Baseband Signals for 3 Users
% These signals represent the data each user wants to send.
% For simplicity, we use sinusoidal signals as placeholders.

user1 = sin(2*pi*100*t);   % User 1 baseband signal (100 Hz)
user2 = sin(2*pi*200*t);   % User 2 baseband signal (200 Hz)
user3 = sin(2*pi*300*t);   % User 3 baseband signal (300 Hz)

% You can replace these sinusoids with actual data, e.g., audio samples or binary data.

%% Assign Carrier Frequencies to Each User
% In FDMA, each user gets a unique carrier frequency to modulate their signal.

f1 = 1000;   % Carrier frequency for User 1 (1 kHz)
f2 = 2000;   % Carrier frequency for User 2 (2 kHz)
f3 = 3000;   % Carrier frequency for User 3 (3 kHz)

%% Modulate Each User's Signal using AM (Amplitude Modulation)
% This shifts the baseband signals to different frequency bands (subchannels).

fdma1 = user1 .* cos(2*pi*f1*t);  % Modulated signal for User 1
fdma2 = user2 .* cos(2*pi*f2*t);  % Modulated signal for User 2
fdma3 = user3 .* cos(2*pi*f3*t);  % Modulated signal for User 3

% Note: We're using Double Sideband Amplitude Modulation (DSB-AM) here.
% Each user’s signal now occupies a unique frequency range.

%% Combine All Modulated Signals into One FDMA Signal
% This simulates the channel carrying all users' signals at once.

fdma_signal = fdma1 + fdma2 + fdma3;  % FDMA composite signal

%% Plot Time Domain Signal
figure;
plot(t, fdma_signal);
title('FDMA Composite Signal in Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Observation: The resulting waveform looks like a complex mix of all 3 signals.

%% Plot Frequency Spectrum of FDMA Signal
% We'll use FFT to observe the frequency components.

n = length(fdma_signal);            % Number of samples
f = (-n/2:n/2-1)*(fs/n);            % Frequency axis (centered)
FDMA_freq = fftshift(abs(fft(fdma_signal)));  % Compute FFT and shift it to center

figure;
plot(f, FDMA_freq);
title('Frequency Spectrum of FDMA Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

% Observation: You should see distinct peaks around 1 kHz, 2 kHz, and 3 kHz,
% each representing a user's modulated signal in its assigned frequency band.

