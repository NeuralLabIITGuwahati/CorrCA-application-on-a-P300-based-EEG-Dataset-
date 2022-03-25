% Kalpajyoti Hazarika
% Data: Date: '4-Feb-2021' ( Originally created)
% This function will do the preprocessing of the session EEG data
% If you want to skip the filtering part ( or you have already done
% filtering) then replace EEG.data with your data and also
% update the other parameters such as sampling frequency, time vector,
% number of channels, number of trials and number of sample points etc...
% A simple covariance based artifacts detection method is used to
% remove the flawed trials
% the final preprocessed data will be the input to the corrca_plot function
% See also corrca_plot


%% Preprocessing

function preprocessedata = extract_P300(files)
clf
% Fz, Cz, Pz, Oz, P7, P3, P4, P8 
% channels = [31 32 13 16 11 12 19 20]; 

% for example:
% extract_P300({'s61','s62','s63','s64'})
% extract_P300({'s81','s82','s83','s84'})

% Fz, Cz, Pz, Oz, P7, P3, P4, P8, O1, O2, C3, C4, FC1, FC2, CP1, CP2 
% channels = [31 32 13 16 11 12 19 20 15 17 8 23 5 26 9 22];
channels = [31 32 13 16 11 12 19 20];
% All electrodes
% channels =[1:32];
% load training files and concatenate data and labels into two big arrays
% Choose the path where you have utilites folder
path(path,'D:\Kalpa\BCI_classification\utilities')

x = [];
y = [];
for i = 1:length(files)
    fprintf('loading %s\n',files{i});
    f = load(files{i});
    n_runs = length(f.runs);
    for j = 1:n_runs
        x = cat(3,x,f.runs{j}.x);
        y = [y f.runs{j}.y];
    end
end

% select channels, windsorize
x = x(channels,:,:);   % training files
w = windsor;
w = train(w,x,0.1);
x = apply(w,x);

% Normalize 
% I have use the fragmented parts of the file normalization ( Ulrich
% Hoffman)
n_channels = size(x,1);
n_samples  = size(x,2);
n_trials   = size(x,3);
x = reshape(x,n_channels,n_samples*n_trials);
n.mean = mean(x,2);
n.std = std(x,[],2);
x = x -  repmat(n.mean,1,n_samples*n_trials);
x = x ./ repmat(n.std,1,n_samples*n_trials);  
x = reshape(x,n_channels,n_samples,n_trials);


% Findin the target trials
% Put y ==1 for target and y==-1 for the non target trials
tar_trial = find(y==1);
EEG.data = x(:,:,tar_trial);
EEG.nbchan = size(EEG.data,1);
EEG.trials = size(EEG.data,3);
fs = 32; % sampling rate inclc Hz
tiv = 1/fs; % time interval
EEG.times =1000*(0:tiv:(1-tiv));

% compute covariances and distances

% compute average of single-trial covariances
covave = zeros( EEG.nbchan );
for triali=1:EEG.trials
    % finding the covaiance matrix trial wise and the cov matrix in each
    % iteration willbe added to the next interation cov matrix
    covave = covave + cov( squeeze(EEG.data(:,:,triali))' );% covariance is calculated across the 8 channels each of 32 samples
end

% divide by number of trials
% To find the mean of the covaraince matrix of all the trials
covave = covave / triali;

% now loop through trials and compute the distance to the average
covdist = zeros(EEG.trials,1);

for triali=1:EEG.trials
    
    
    thistrialcov = cov( squeeze(EEG.data(:,:,triali))' );
    
    % compute Frobenius distance
    covdist(triali) = sqrt( sum(thistrialcov(:) .* covave(:)) );
    % previous line is the same as this one:
    %covdist(triali) = sqrt( trace(thistrialcov*covave) );
    
    % alternative: Euclidean distance (gives similiar results)
    %covdist(triali) = sqrt( sum((thistrialcov(:) - covave(:)).^2) );
end

% convert to z
covdistz = (covdist-mean(covdist)) / std(covdist);

% visual inspection of covariance distances to average

% show the covariance distances
figure(1), clf
subplot(2,3,1:2)
plot(covdistz,'ks-','linew',2,'markerfacecolor','w','markersize',12)
xlabel('Trial'), ylabel('Z_{dist}')
title('Z-scored covariance distances')

% % histogram of distances

% subplot(233)
% histogram(covdistz,10)
% xlabel('Distances'), ylabel('Count')
% title('Histogram of distances')

% pick a threshold and reject trials
% threshold
thresh = 2.3; % ~0.1

% identify trials that exceed the threshold
toofar = covdistz>thresh;
toofar_idx = find(toofar==1);
% remove those trials from the data
preprocessedata = EEG.data;
preprocessedata(:,:,toofar) = [];

% plot time courses
subplot(212), hold on
plot(EEG.times,mean(EEG.data(3,:,:),3),'k','linew',2)
plot(EEG.times,mean(preprocessedata(3,:,:),3),'r','linew',2)
xlabel('Time (ms)'),ylabel('Amplitude')
legend({'Original data';'Trials removed'})
title('Time series before and after covariance cleaning')
zoom on

corrca_plot(preprocessedata);

end

