clc;
clear;

% Sampling frequency (how often we sample the signal per second)
Fs = 2400;

% Time vector for 3 second of signal
t = 0:1/Fs:3;

% Baseband signal for all users (20 Hz sine wave)
signal = sin(2*pi*20*t);

% Carrier frequencies assigned to each user (FDMA slots)
carriers = [100, 200, 300, 400];

% Bandpass filter specifications for each user:
% Format: [Fstop1, Fpass1, Fpass2, Fstop2]
% New filter specs with wider transition bands (10 Hz on each side)
filters = {
    [80, 90, 110, 120],[180, 190, 210, 220],[280, 290, 310, 320],[380, 390, 410, 420]   
};


% Arrays to hold modulated and filtered signals for each user
modulated_signals = zeros(4, length(t));
filtered_signals = zeros(4, length(t));

% -----------------------------
% Modulation and Bandpass Filter per User
% -----------------------------
for i = 1:4
    fc = carriers(i);                        % Get carrier frequency for user i
    carrier = sin(2*pi*fc*t);                % Generate carrier wave
    modulated = signal .* carrier;           % Amplitude Modulate baseband signal
    modulated_signals(i, :) = modulated;     % Store modulated signal
    
    % Get bandpass filter design parameters
    Fstop1 = filters{i}(1);
    Fpass1 = filters{i}(2);
    Fpass2 = filters{i}(3);
    Fstop2 = filters{i}(4);
    
    % Design the FIR bandpass filter using equiripple method
    d = designfilt('bandpassfir', ...
        'StopbandFrequency1', Fstop1, ...
        'PassbandFrequency1', Fpass1, ...
        'PassbandFrequency2', Fpass2, ...
        'StopbandFrequency2', Fstop2, ...
        'StopbandAttenuation1', 60, ...
        'StopbandAttenuation2', 60, ...
        'PassbandRipple', 1, ...
        'DesignMethod', 'equiripple', ...
        'SampleRate', Fs);
    
    % Apply the bandpass filter to isolate the modulated signal in its band
    filtered = filter(d, modulated);
    filtered_signals(i, :) = filtered;       % Store filtered signal
end

% -----------------------------
% MUX: Combine all filtered signals into a single FDMA signal
% -----------------------------
fdma_signal = sum(filtered_signals, 1);       % Composite signal with all users in different bands

% -----------------------------
% DEMUX: Recover individual signals using same bandpass filters
% -----------------------------
recovered_signals = zeros(4, length(t));      % Preallocate recovered signals

for i = 1:4
    % Use same filter specs as transmitter
    Fstop1 = filters{i}(1);
    Fpass1 = filters{i}(2);
    Fpass2 = filters{i}(3);
    Fstop2 = filters{i}(4);
    
    % Redesign the same bandpass filter
    d = designfilt('bandpassfir', ...
        'StopbandFrequency1', Fstop1, ...
        'PassbandFrequency1', Fpass1, ...
        'PassbandFrequency2', Fpass2, ...
        'StopbandFrequency2', Fstop2, ...
        'StopbandAttenuation1', 60, ...
        'StopbandAttenuation2', 60, ...
        'PassbandRipple', 1, ...
        'DesignMethod', 'equiripple', ...
        'SampleRate', Fs);
    
    % Apply filter to extract user i's signal from FDMA composite
    recovered = filter(d, fdma_signal);
    recovered_signals(i, :) = recovered;
end

% -----------------------------
% Plot Results
% -----------------------------
figure;

% Plot the composite FDMA signal (all users combined)
subplot(5,1,1);
plot(t, fdma_signal);
title('FDMA Composite Signal');
xlabel('Time (s)');
ylabel('Amplitude');
xlim([0 0.1]);  % Zoom in to see the waveform clearly
axis tight;

% Plot recovered signals for each user
for i = 1:4
    subplot(5,1,i+1);
    plot(t, recovered_signals(i, :));
    title(['Recovered Signal - User ', num2str(i)]);
    xlabel('Time (s)');
    ylabel('Amplitude');
    xlim([0 0.1]);
    axis tight;
end

drawnow;