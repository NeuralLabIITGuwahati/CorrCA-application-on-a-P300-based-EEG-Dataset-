% Kalpajyoti Hazarika
% Plot forward model for the subjects consistent with the components
% 
% A16 denotes the data with 16 channels and A denotes data with 8 channels
% AN means nontarget and A means target 
% for example AN16_1 means eeg data consists of 16 channels and non target trials of subject 1 
% Subject 1 to 4 are disabled subjects and 6 to 9 are healthy subjects.
%%
% All the subjects with non-target trials
files = {'AN16_1','AN16_2','AN16_3','AN16_4','AN16_6','AN16_7','AN16_8','AN16_9'};

% All the subjects with target trials 
% files = {'A1','A2','A3','A4','A5','A6','A7','A8'};

% All the healthy subjects with targt trials
% files = {'A5','A6','A7','A8'};

% All the disabled subjects with non- targt trials
% files = {'AN16_1','AN16_2','AN16_3','AN16_4'};

% All the healthy subjects with non-targt trials
% files = {'AN16_6','AN16_7','AN16_8','AN16_9'};

% channel location file 
locfile = 'D:\Kalpa\BCI_classification\coord1.loc';

% Concatenate all the trials from each subjects
x = [];
for i = 1:length(files)  
   f= load(files{i});
   x = cat(3,x,f.A);
end

%%
% Change the directory where your topoplot.m and channel location file
% exists

cd 'D:\Kalpa\BCI_classification'
A = mean(x,3);
for i = 1:3
    subplot(3,1,i)
    topoplot(A(:,i),locfile,'electrodes','numbers');
    title(['A_' num2str(i)]);
    colorbar;
end




