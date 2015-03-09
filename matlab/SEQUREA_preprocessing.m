			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% batch script zur automatisierten Vorverarbeitung von fMRT-Daten mit SPM8
% modified from spm5 script (fimlab, 05/2007) by Christine Stelzel
% modified for CBASP preprocessing by Michael Gaebler (06/2013)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [] = SEQUREA_preprocessing(config)


%clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     GENERAL SETTINGS    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DIRECTORIES

%data = 'SEQUREA_Analyse';  % which data set? name of folder that contains your subject directories

%study_dir = fullfile('D:',data,'Individuals');  % folder containing subject directories
%%spm_dir = fullfile('C:','Program Files (x86)','MATLAB_Tools','spm8'); % --> help: "which spm"

%spm_dir = fullfile('C:','Program Files (x86)','MATLAB_Tools','spm12b'); % --> help: "which spm"

%% template_dir = fullfile(study_dir, 'Templates'); % ANPASSEN

%template_dir = 'C:\Program Files (x86)\MATLAB_Tools\spm8\toolbox\vbm8'; % ANPASSEN


% Der ordner mit allen 'SQR_*'-Unterordnern, die wiederum alle 'r_a*.nii' 
config.functional_dir = '/home/achim/Data/dummy_sequrea/functional';
config.structural_dir = '/home/achim/Data/dummy_sequrea/structural';

study_dir = config.functional_dir; % direcotry containing all 'SQR_*' subfolders which in turn contain 
spm_dir = '/home/achim/Builds/spm8';
template_dir = '/home/achim/Builds/spm8/toolbox/vbm8';


subjs = dir(fullfile(study_dir,'SQR_*'));





% PARAMETERS
number_slices = 30; 
TR = 3;
ref_slice = 1; % 19;   %10 bedeutet die 10. von unten (obwohl wir von oben gemessen haben). SPM nummeriert die slices per convention von unten nach oben von 1 bis number_of_slices.
% in diesem Fall habe ich 10 gewählt, da diese slice relativ nah am VMPFC ist (meine region of interest). 
% nicht vergessen je nach reference slice die onsets entsprechend zu korrigieren mit microtime onset and
% microtime bins bei der 1st level specification - slice 7 ist AMYGDALA
% (laut JaPe) --> Hariri und Emoreg
% focus, slice 10 für Kelley task in Ordnung (und für ToM)
slice_order = [2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29]; % [37:-1:1]; % descending
timegap = 0; 



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %     JOBS
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for isub = 1:length(subjs)

	direc_funct = fullfile(config.functional_dir, subjs(isub).name);
	direc_struct = fullfile(config.structural_dir, strcat('Structural_', subjs(isub).name));
	[anat_filename, dirs] = spm_select('List', direc_struct, '^co2013*.*\.nii$');
   

 % slicetiming() 
   %realign()
  % realign_reslice()

   %coreg_highres_meanepi()
%    
% spm_segment()
 
 %apply_deform()
%smooth()
   
%   dartel_existing()
    norm2mni()
    
end



 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	NORMALIZE TO MNI (DARTEL)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [] = norm2mni()
        
    clear jobs
 
%    [funct_filenames_norm, dirs] = spm_select('List', direc_funct, '^a_f.*\.nii$') % ANPASSEN!!
	[funct_filenames_norm, dirs] = spm_select('List', direc_funct, '^r_a.*\.nii$');
    filenames_for_norm = strcat(direc_funct,filesep,funct_filenames_norm);
    
%    flowfield_filename = dir(fullfile(direc_struct, 'u_rc1*'))
	flowfield_filename = dir(fullfile(direc_struct, 'c1*'));
    %[flowfield_filename, dirs] = spm_select('List', fullfile(template_dir, 'u_rc1_spezial','2'), strcat('u_rc1.*',all_subjs(isub).name,'.*\.nii$'));
    flowfield = fullfile(direc_struct, flowfield_filename.name);
   
    jobs{1}.tools{1}.dartel{1}.mni_norm.template = {fullfile(template_dir, 'Template_6_IXI550_MNI152.nii')}; % adjust!!!
    
    jobs{1}.tools{1}.dartel{1}.mni_norm.vox = [2 2 4]; % IS THAT RIGHT??? % [3 3 3];
    jobs{1}.tools{1}.dartel{1}.mni_norm.bb = [NaN NaN NaN 
                                              NaN NaN NaN];
    jobs{1}.tools{1}.dartel{1}.mni_norm.preserve = 0;
    jobs{1}.tools{1}.dartel{1}.mni_norm.fwhm = [6 6 6]; % [8 8 8] ist default
    
    jobs{1}.tools{1}.dartel{1}.mni_norm.data.subj.flowfield = {flowfield};
    jobs{1}.tools{1}.dartel{1}.mni_norm.data.subj.images = cellstr(filenames_for_norm);
    
    spm_jobman('initcfg')
    spm_jobman('run',jobs);
   % clear jobs
   


    disp(strcat({'@ Normalize to MNI (DARTEL) for: '}, subjs(isub).name, {' done.'}))

end % end function normalize to MNI
   
end 









