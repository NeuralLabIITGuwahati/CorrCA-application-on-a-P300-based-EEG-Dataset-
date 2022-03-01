% Kalpajyoti Hazarika
% Date: '13-Feb-2021' ( Originally created)
% Required statistical and machine learning toolbox
% This function will generate plots from the input files of EEG data
% The plots includes 
% 1) Bar plot of the signal to noise ratio of channels and the CorrCA
% components
% 2) Averaged trials of the channels and the components ( Here first and
% second components plots are shown)
% 3) Topoplots to visualize the neural activity consistent with the
% components
%{

One of the important point is the if you want to apply corrca on large
number of electrodes then the sample points also should be large. ( The ratio
of number of channels and sample points should be negligible or close to
zero, other wise it will perform worse. More Electrodes needs more sample
points.
For more info Lucas C Parra et al.2019. Extracted correlated components: Multivariate analysis. 
%}
% You can arrange the channels lables according to your data 
% see also est_K_shift

%% 
function  corrca_plot(data)
clf;
% l_data = load(data);
% X = l_data.X;
X = permute(data,[2,1,3]);
[T,D,N] = size(X);
fs = 32; %sampling frequency
tiv =  1/fs; % sampling interval
time = 1000*(0:tiv:(1-tiv)); %set of the time interval

% Channel location file and channel file
locfile = 'D:\Kalpa\BCI_classification\coord.loc';


% The compute the Signal to noise ratio of seach channles

% compute inter-trial correlation on the raw data
[~,ITCx]=corrca(X,'fixed',eye(D));

subplot(5,3,1);
SNRx=(ITCx+1/(N-1))./(1-ITCx)*sqrt(N);
bar(SNRx); xlabel('EEG channels'); ylabel('SNR*\surd N')
axis([0 D 0 3.5])
set(gca,'XTickLabel',{'Fz','Cz','Pz','Oz','P7','P3','P4','P8'});

% electrodes picked 'by hand' by looking at ERP (FCz and Cz)
[~,indx]=sort(SNRx);

% Here only the Cz and Pz channel data are used... You can change it  
chan_id =["Cz","Pz"];

% visulization of Raw EEG data across the channels
% Here both the average trail plots and the all the individual trials vs
% time plotts are shown
n=4; 
for i=[2 3]
    x=squeeze(X(:,i,:));
    subplot(5,3,n); n=n+3; ploterp(x',[],300,time);
    title(['Trial averaged channel ', num2str(chan_id(i-1))]);
    ylabel('\mu V')
    subplot(5,3,n); n=n+3; imagesc(time,[],x');
    ylabel('Trials');
    title(['Single trial ',num2str(chan_id(i-1))])
    caxis([-1 1]*prctile(abs(x(:)),100))
end
xlabel('time (ms)');

% Find corrca components, and evalute performance on
% leave-one-out sample

for i=N:-1:1
    Xtrain = X; 
    Xtrain(:,:,i)=[];
    [W(:,:,i),~,~,A(:,:,i)] = corrca(Xtrain,'shrinkage',0.4);
    Sign = -diag(sign(diag(inv(W(:,:,N))*W(:,:,i)))); % fix arbitrary sign
    Ytest(:,:,i) = X(:,:,i)*W(:,:,i)*Sign;
    
end

[~,ITCy,~,~]=corrca(Ytest,'fixed',eye(D));


% find the corrca components and establish statistical significance through random circular shifting

[K, p] = est_K_shift(X, 100, 0.2);
disp(['Number of significant components using circular shuffle p<0.05:' num2str(K)]);

subplot(5,3,2);
SNRy=(ITCy+1/(N-1))./(1-ITCy)*sqrt(N);
bar(SNRy); hold on 
i=K+1:D; bar(i,SNRy(i),'FaceColor',[0.75 0.75 1]);
axis([0 D 0 3.5])
xlabel('CorrCA components'); ylabel('SNR*\surd N ');

% Forward models
n=5;
A= mean(A,3);
for i=1:2
    y=squeeze(Ytest(:,i,:));
    subplot(5,3,n); n=n+3;
    ploterp(y',[],300,time);
    title(['trial averaged component ' num2str(i) ])
    ylabel('\mu V')
    xlabel('time (ms)')
    subplot(2,3,3*i);
    topoplot(A(:,i),locfile,'electrodes','numbers');
    colorbar 
    title(['a_' num2str(i)])
    h=subplot(5,3,n); n=n+3;
    imagesc(time,[],y');
    ylabel('trials');
    title(['single trial component ' num2str(i) ])
    caxis([-1 1]*prctile(abs(y(:)),100))
    pos=get(h,'Position');
end

xlabel('time (ms)');
h=subplot(5,3,14);
drawnow
pos=get(h,'Position');
hcbar=colorbar; title(hcbar,'\mu V')
set(h,'Position',pos);

% add some helpful lines
for i=[4 5 7 8]
    subplot(5,3,i);
    ax = axis;
    hold on;
    plot([0 0], ax(3:4), 'k')
    plot([800 800], ax(3:4), 'r')
end

end
