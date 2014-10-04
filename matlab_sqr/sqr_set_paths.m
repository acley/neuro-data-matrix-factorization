% if this is running on windows, choose michi's paths
ispc = false;
if ispc
    % the paths for the code
    addpath('C:\Users\mgaebler\Dropbox\Sequrea\Code');
    spmpath = 'C:\Program Files\MATLAB_SPM\spm8';
    
    datapath = 'L:\SEQUREA\SEQUREA_Analyse_no_slicetime\Individuals';
else
    % if this is not a pc it's most likely on felix machine
%    spmpath = fullfile('/Users/felix','Code','matlab','spm8');
    
    datapath = '/home/achim/masterprojekt/data/sequrea';

%    datapath = '/Users/felix/Google Drive/sequrea';
%     datapath = '/Users/felix/Data/SQR/';
%     datapath = '/Users/felix/Dropbox/Sequrea/preprocessed_smoothed';
end

% this is where functional images are 
fpath = fullfile(datapath,'functional');

if exist(fpath)~=7
mkdir(fpath)
end
% this is where anatomical images are 
spath = fullfile(datapath,'structural');
if exist(spath)~=7
mkdir(spath)
end
% this is where intermediate mat files will be saved
matsavepath = fullfile(datapath,'matexport');
if exist(matsavepath)~=7
mkdir(matsavepath)
end

volinfo = spm_vol(fullfile(fpath,'SQR_001','r_a_20131113_1322011EPItask2x2x4s003a001_001.nii'));
    tmp = spm_read_vols(volinfo);


movIDs = {'Cherryblossom','Deepsea','Rallyekorea',...
    'testPeakRamp1','testPeakRamp2','testPeakRamp3'};

