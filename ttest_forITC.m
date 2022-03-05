% Kalpajyoti Hazarika
% hihger ITC within the condition than the across condition

% clear;
% comp = mean(Y_tar,3);

% ITC value of the target and nontarget trials 1
%%

ITC_tar = table2array(itrsubjectsS1(:,2));

ITC_nontar = table2array(itrsubjectsS1(:,5));

% mean_tar = mean(ITC_tar(1:end-1));
% mean_nontar = mean(ITC_nontar(2:end));
% sd_tar = std(ITC_tar(1:end-1));
% sd_nontar = std(ITC_nontar(2:end));

%{
this test shows that the dependent t test shows that the ITC during the
target condition is sigficantly higher than the non target conditon
%}


% [h,p,ci,stats] = ttest(ITC_tar(1:end-1),ITC_nontar(2:end),'Alpha',0.01);

mean_tar = mean(ITC_tar);
mean_nontar = mean(ITC_nontar);
sd_tar = std(ITC_tar);
sd_nontar = std(ITC_nontar);

[h,p,ci,stats] = ttest(ITC_tar,ITC_nontar,'Alpha',0.01);

% Cohens' size effect

cohens_D = (mean_tar - mean_nontar)/(sqrt((sd_tar^2+sd_nontar^2)/2));
disp(['h: ',num2str(h), ' p: ', num2str(p), ' cohens_D: ', num2str(cohens_D)]);

display(stats);

N = length(ITC_tar);

if (N<40)
    cohens_small = cohens_D*((N-3)/(N-2.25))*sqrt((N-2)/N);
else
    cohens_large = cohens_D;
end
 























