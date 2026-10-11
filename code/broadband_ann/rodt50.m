clc; clear all;
% close all;
Fs =1/0.0045; % Sampling frequency (from time data)
lowCutoff = 0.001; % Lower cutoff frequency in Hz
highCutoff = 2; % Higher cutoff frequency in Hz
filterOrder = 2; % Order of the filter

% Create the band-pass filter
bpFilter = designfilt('bandpassiir', 'FilterOrder', filterOrder, ...
    'HalfPowerFrequency1', lowCutoff, 'HalfPowerFrequency2', highCutoff, ...
    'SampleRate', Fs);
dt = 0.0045;  % Time step (s)
files=dir('*E.sema');
files1=dir('*N.sema');
g=9.81;             % (mm/s^2)
dt=0.0045;            % Time Interval (sec)
zet=5;              % Damping Ratio (%)
endp=5;    
l=[1:14,456:462];
Vs30=[626,542,413,473,449,493,394,400,407,539,416....
    ,390,454,315,525,367,494,452,379,542,266];
Rhyp=[];
for i=1:21
data=importdata(files(l(i)).name);  
data1=importdata(files1(l(i)).name);
signal =lowpass(data(1:end,2),1.5,1/0.0045,'ImpulseResponse','auto',Steepness=0.95);
filteredSignal = filtfilt(bpFilter, signal);
Ag=filteredSignal;
signal1 =lowpass(data1(1:end,2),1.5,1/0.0045,'ImpulseResponse','auto',Steepness=0.95);
filteredSignal1 = filtfilt(bpFilter, signal1);
Ag1=filteredSignal1;
% Keep the vector with name EW for EW component of the time-history in mat file 
% Keep the vector with name NS for NS component of the time-history in mat file
% files=dir('*.mat');
% load(files.name);
EW=Ag;
NS=Ag1;
zeta=0.05; 
% T=[0.01:0.01:0.06,0.075,0.09,0.1:0.05:0.2,0.3:0.1:0.7,0.75,0.8:0.1:1,1.2,1.5,2,2.5,3,4,5,6,7,8,9,10]; 
dt=0.0045; %adjust as per time history
m=1;
T = (0.05:0.01:10)';
D_ns=zeros(length(T),1);
A_ns=zeros(length(T),1);
V_ns=zeros(length(T),1);
D_ew=zeros(length(T),1);
A_ew=zeros(length(T),1);
V_ew=zeros(length(T),1);
wn=2*pi./T;
k_cap=wn.^2*m;
C=2*zeta*wn; 
n=length(EW);
u_ew=zeros(n,1);
u_dot_ew=zeros(n,1);  
u_ddot_ew=zeros(n,1); 
u_ns=zeros(n,1);
u_dot_ns=zeros(n,1);  
u_ddot_ns=zeros(n,1); 
p_ns=m.*NS;
p_ew=m.*EW;
theta=0:1:180;
n3=length(theta);
T1 = [0 0.010  0.020  0.030   0.040 0.050  0.060  0.075  0.0900  0.10   0.15   0.20   0.30   0.40   0.50   0.60   0.70   0.75   0.80   0.90   1   1.20    1.40    1.60    1.80    2   2.20    2.40    2.80   3   3.40    3.80    4]';
[rotd_combine] = RotDxx_Calculations( EW, NS, 0.0045, 0.0045, 50, T1', 0.05 );
%--------------------------------------------------------------------------
% for k=1:n3
% NS1(k,:)=NS*cosd(theta(k))+EW*sin(theta(k));
% [~, ~, ~, ~, PSA_NS1(k,:), T] = responsespectrum(NS1(k,:)', zet, T1, dt);
% % [~,~, ~, ~, PSA_EW, T] = responsespectrum(EW, zet, T1, dt);
% end
% loglog(T1,rotd_combine)
Th=0.75;
cc=find(T1>=Th);
[PSA_ANN_BB, T] = BBANN_him_Final_T1(7.8, Rhyp(i), 3, Vs30(i), rotd_combine(cc)./9.81, T1(cc), Th);
figure(7)
subplot(7,3,i)
% hold on
loglog(T,PSA_ANN_BB);
title(files(l(i)).name);
[Sa, sigma, T] = DR_2017(7.8,T1, 50,760, 1, 3);
end
% hold on
% plot(T,GM_Rodt100)
