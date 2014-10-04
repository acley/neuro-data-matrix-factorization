function sqr_preprocess()
% extracts niftis and logfile information, removes baseline by highpass
% filtering

sqr_set_paths

% length after stimulus offset to include into analysis window (in secs)
lag = 9;
% movie length in seconds
movlength = 120;

% duration of one fMRI volume in seconds
TR = 3;

% grey matter threshold
grey_threshold = 0.1;

% bandstops for filter
bandstart = .005;
[b,a]=butter(5,bandstart*2/(1/TR),'high');

% remove some TRs at end and start
zeroTRs = 3;

subjs = dir(fullfile(fpath,'SQR_*'));

nsubj = length(subjs);

for isubj=1:nsubj
    try
        fprintf('************************\nSubj %s\n************************\n',subjs(isubj).name)
        vols = dir(fullfile(fpath,subjs(isubj).name,'*.nii'));
        fprintf('\tFound %4d volumes\n',length(vols))
        
        tmp = dir(fullfile(spath,...
                ['Structural_',subjs(isubj).name],...
                'c1co*.nii'));
   
        fprintf('\tReslicing segmentation file %s\n',tmp(1).name)
        segfile = fullfile(spath,...
            ['Structural_',subjs(isubj).name],...
            tmp(1).name);
        
        spm_reslice({fullfile(fpath,subjs(isubj).name,vols(1).name),segfile});
        segfile = regexprep(segfile,'c1co','rc1co');
        gmask = spm_read_vols(spm_vol(segfile)) > grey_threshold;
        fprintf('\tReading Volumes Subject %2d\n\t|',isubj)
  
        dat = zeros(sum(gmask(:)),length(vols));
        
        for ivol = 1:length(vols)
            tmp = spm_read_vols(spm_vol(fullfile(fpath,subjs(isubj).name,vols(ivol).name)));
            dat(:,ivol) = tmp(gmask(:));
            if mod(ivol,round(length(vols)/20))==0
               fprintf('=')
            end
        end
        fprintf('|\n')
        
        fprintf('\tRemoving Baseline\n')
        dat(:,[zeroTRs:end-zeroTRs]) = filtfilt(b,a,double(dat(:,[zeroTRs:end-zeroTRs]))')';
        dat(:,[1:zeroTRs end-zeroTRs:end]) = 0;
        
        % extract logfiles
        tmpfname = dir(fullfile(datapath,'logfiles',...
            [regexprep(subjs(isubj).name,'SQR_','sqr'),'*.xls']));
        logfilename = fullfile(datapath,'logfiles',tmpfname(1).name);
        
        fprintf('\tExtract log-file %s\n',logfilename)
        [conditions,movIDs] = sqr_logextract(logfilename);
        
        dat = dat(:,1:min(size(dat,2),size(conditions,1)));
        
        fprintf('\tSaving raw data and log-files\n')
        
        save(fullfile(matsavepath,[regexprep(subjs(isubj).name,'Functional_',''),'.mat']),...
            'dat','gmask','grey_threshold','TR','conditions')
        
    catch
        %keyboard
    end
end
