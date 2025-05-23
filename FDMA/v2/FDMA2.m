% Design and simulation of Frequency Division Multiplexing in MATLAB
clc;
clear all
close all
samples=1000;
% number of users
nos=5;
% modulating signal frequency in Hz
mfreq=[30 40 50 60 70 80 90 100]; 
% carrier frequency allocated to the different users in Hz
cfreq=[300 600 900 12000 1500 1800 2100 2400];
% choose frequency deviation
freqdev=10;
% generate modulating signal 
t=linspace(0,1000,samples);
parfor i=1:nos
    m(i,:)=sin(2*pi*mfreq(1,i)*t)+2*sin(pi*8*t);
end
% Generate the modulated signal
parfor i=1:nos
    y(i,:)=fmmod(m(i,:),cfreq(1,i),10*cfreq(1,i),freqdev);
end
% pass the modulated signal through the channel 
ch_op=awgn(sum(y),0,'measured');
% demodulate the received signal at the base station 
parfor i=1:nos
    z(i,:)=fmdemod(y(i,:),cfreq(1,i),10*cfreq(1,i),freqdev);
end
% display the transmitted signal  and received signal at the base station
% figure
C = {'k','b','r','g','y',[.5 .6 .7],[.8 .2 .6],[.3 .2 .2]}; % Cell array of colros.
for i=1:nos 
    figure (1)
    hold on 
    plot(y(i,:),'color',C{i});
    xlabel('time index'); ylabel('amplitude'); title('Signal from different users combined in the channel');
    figure
    subplot(3,1,1)
    plot(m(i,:))               % modulating signal
    xlabel('time index'); ylabel('amplitude'); title('modulating Signal from user');
    subplot(3,1,2)
    plot(y(i,:),'color',C{i}); % modulated signal
    xlabel('time index'); ylabel('amplitude'); title('modulated Signal from user');
    subplot(3,1,3)
    plot(z(i,:),'color',C{i}); % demodulated signal 
    xlabel('time index'); ylabel('amplitude'); title('demodulated Signal from user at the base station');
end
figure 
plot(ch_op) % combination of all modulated signals passed through the channel
xlabel('time index'); ylabel('amplitude'); title('Signal after passing through the channel');