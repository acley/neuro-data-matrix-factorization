% List of open inputs
nrun = 2;%X; % enter the number of runs here
jobfile = {'/home/achim/Projects/neuro-data-matrix-factorization/matlab/VBM8_segmentation_normalization_job_ACHIM.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
%	jobs{crun}
end
%spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('serial', jobs, '', inputs{:});
