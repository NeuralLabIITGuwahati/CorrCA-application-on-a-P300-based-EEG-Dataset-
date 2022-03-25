% Kalpajyoti Hazarika
% Plot forward model for the subjects consistent with the components
% 
% A16 denotes the data with 16 channels and A denotes data with 8 channels
% AN means nontarget and A means target 
% for example AN16_1 means eeg data consists of 16 channels and non target trials of subject 1 
% Subject 1 to 4 are disabled subjects and 6 to 9 are healthy subjects.
%%
% All the subjects with non-target trials
% Set the directory for the forward models
cd 'F:\corrca_files\forward models';
% files = {'AN16_1','AN16_2','AN16_3','AN16_4','AN16_6','AN16_7','AN16_8','AN16_9'};

% All the subjects with target trials with 8 channels
files1 = {'A1','A2','A3','A4','A6','A7','A8','A9'};
files2 = {'A1','A2','A3','A4'};
files3={'A6','A7','A8','A9'};
files = {files1,files2,files3};

% for non target trials with 8 channels
% files1 = {'AN1','AN2','AN3','AN4','AN5','AN6','AN7','AN8'};
% files2 = {'AN1','AN2','AN3','AN4'};
% files3 = {'AN5','AN6','AN7','AN8'};
% files = {files1,files2,files3};

% All the disabled subjects with non- targt trials with 16 channels
% files = {'AN16_1','AN16_2','AN16_3','AN16_4'};

% All the healthy subjects with non-targt trials with 16 channels
% files = {'AN16_6','AN16_7','AN16_8','AN16_9'};

% channel location file 
locfile = 'F:\corrca_files\coord.loc';
% Concatenate all the trials from each subjects
x = {};
m = [];

% Concatenate all the trials 
for i = 1:3 
    tempfiles = files{i};
    for j = 1:length(tempfiles)      
        f = load(tempfiles{j});
        m = cat(3,m,f.A);
    end
    x{i} = m;
    m = [];
end

% If you want to use only single files . files1, files2, files3 and files
% for i = 1:length(files1)  
%    f= load(files1{i});
%    x = cat(3,x,f.A);
% end

%%
% Change the directory to location of your topoplot.m and channel location file
cd 'F:\corrca_files'
A = {};
B = size(8,6);

for i = 1:length(x)
    A{i} = mean(x{i},3);
        
end
B = [];
k = 0;
for j = 1:3
    B(:,j+k:j+k+2) = A{j}(:,1:3);
    k = k+2;
end
C = [];

% Disabled + Able bodied Subjects 
C(:,1:3) = B(:,[1,4,7]);
% Disabled Subjects
C(:,4:6) = B(:,[2,5,8]);
% Able-Bodied Subjects
C(:,7:9) = B(:,[3,6,9]);

for k = 1:9
    subplot(3,3,k);
    topoplot(C(:,k),locfile,'electrodes','numbers');
    colormap('hot');
    colorbar;
end
