function sqr_preprocess(config)

	functional_dir = config.functional_dir;
	structural_dir = config.structural_dir;
	logfile_dir = config.logfile_dir;
	output_dir = config.preprocessing_output_dir;

	% extracts niftis and logfile information, removes baseline by highpass
	% filtering

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

	subjs = dir(fullfile(functional_dir, 'SQR_*'));
	nsubj = length(subjs);

	for isubj=1:nsubj
			fprintf('************************\nSubj %s\n************************\n',subjs(isubj).name)
			 %~ vols = dir(fullfile(functional_dir, subjs(isubj).name, 'nsynth*.nii')); % normalized_data
			vols = dir(fullfile(functional_dir, subjs(isubj).name, 'r_a*.nii')); % felix' data
			fprintf('\tFound %4d volumes\n',length(vols))
			
			%~ tmp = dir(fullfile(structural_dir, subjs(isubj).name, 'wrp1co*.nii')); % for normalized data
			tmp = dir(fullfile(structural_dir, subjs(isubj).name, 'c1co*.nii')); % for felix' data
	   
			fprintf('\tReslicing segmentation file %s\n',tmp(1).name)
			segfile = fullfile(structural_dir, subjs(isubj).name, tmp(1).name);
			
			spm_reslice({fullfile(functional_dir,subjs(isubj).name,vols(1).name),segfile});
			%~ segfile = regexprep(segfile, 'wrp1co', 'rwrp1co'); % used for normalized data
			segfile = regexprep(segfile, 'c1co','rc1co'); % used for felix' data
			gmask = spm_read_vols(spm_vol(segfile)) > grey_threshold;
			fprintf('\tReading Volumes of Subject %2d\n\t|',isubj)
	  
			dat = zeros(sum(gmask(:)),length(vols));
			
			for ivol = 1:length(vols)
				tmp = spm_read_vols(spm_vol(fullfile(functional_dir,subjs(isubj).name,vols(ivol).name)));
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
			tmpfname = dir(fullfile(logfile_dir,...
				[regexprep(subjs(isubj).name,'SQR_','sqr'),'*.xls']));
			logfilename = fullfile(logfile_dir,tmpfname(1).name);
			
			fprintf('\tExtract log-file %s\n',logfilename)
			[conditions,movIDs] = sqr_logextract(logfilename);
			dat = dat(:,1:min(size(dat,2),size(conditions,1)));
			[dat, K_lin, K_gauss] = gen_kernel_matrices(dat);
			
			fprintf('\tSaving to file...\n');
			save(fullfile(config.preprocessing_output_dir, [regexprep(subjs(isubj).name,'Functional_',''),'.mat']),...
				'dat', 'gmask', 'grey_threshold', 'TR', 'conditions', 'K_lin', 'K_gauss')
	end
end

function [dat, K_lin, K_gauss] = gen_kernel_matrices(dat)
	fprintf('\tGenerating kernel matrices\n');
	dat = zscore(dat')';
	
	% linear kernel
	K_lin = dat'*dat;
	K_lin = K_lin ./ max(eigs(K_lin));
	
	% gauss kernel
	kwidths = est_kwidth(dat',5);
	K_gauss = gausskern(dat', dat', kwidths(3));
	K_gauss = K_gauss ./ max(eigs(K_gauss));
end
