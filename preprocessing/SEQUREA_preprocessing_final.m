%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% batch script zur automatisierten Vorverarbeitung von fMRT-Daten mit SPM8
% modified from spm5 script (fimlab, 05/2007) by Christine Stelzel
% modified for CBASP preprocessing by Michael Gaebler (06/2013)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [] = SEQUREA_preprocessing(config)


%clear all

% disp(' ')
% disp('do not forget to check results of each processing step!')
% disp(' ')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     GENERAL SETTINGS    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DIRECTORIES

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
%	direc_struct = fullfile(config.structural_dir, strcat('Structural_', subjs(isub).name));
	direc_struct = fullfile(config.structural_dir, subjs(isub).name);
	[anat_filename, dirs] = spm_select('List', direc_struct, '^co2013*.*\.nii$');
	
	spm_jobman('initcfg');

	realign()


	coreg_highres_meanepi()    
end

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	REALIGNMENT - estimate reslice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
function [] = realign()
    
%     uhr = fix(clock);
%     disp(strcat({'Startzeit '},num2str(uhr(4)),':',num2str(uhr(5)),':',num2str(uhr(6))))

    clear jobs

    jobs{1}.spatial{1}.realign{1}.estwrite.eoptions.quality = 0.9;
    jobs{1}.spatial{1}.realign{1}.estwrite.eoptions.sep = 6; % default: 4
    jobs{1}.spatial{1}.realign{1}.estwrite.eoptions.fwhm = 5;
    jobs{1}.spatial{1}.realign{1}.estwrite.eoptions.rtm = 1;
    jobs{1}.spatial{1}.realign{1}.estwrite.eoptions.interp = 4; % default: 2
    jobs{1}.spatial{1}.realign{1}.estwrite.eoptions.wrap = [0 0 0];
    jobs{1}.spatial{1}.realign{1}.estwrite.eoptions.weight = {};
    
    jobs{1}.spatial{1}.realign{1}.estwrite.roptions.which = [2 1];%[0 1]; % Resliced Images ([0 1] > Only Mean Image; Default: [2 1] > All Images + Mean Image) 
    jobs{1}.spatial{1}.realign{1}.estwrite.roptions.interp = 5; % Interpolation (Default: 4th Degree B-Spline) 
    jobs{1}.spatial{1}.realign{1}.estwrite.roptions.wrap = [0 0 0]; % Wrapping (Default: No wrap) 
    jobs{1}.spatial{1}.realign{1}.estwrite.roptions.mask = 1; % Masking (Default: Mask images) 
    jobs{1}.spatial{1}.realign{1}.estwrite.roptions.prefix= 'r_';
    
%    [raw_func_filenames_ra, dirs] = spm_select('List', direc_funct, '^r_a_.*\.nii$');
	
	[raw_func_filenames_ra, dirs] = spm_select('List', direc_funct, '^2013.*\.nii$');
    filenames_for_ra = strcat(direc_funct,filesep,raw_func_filenames_ra); 
    
    
    jobs{1}.spatial{1}.realign{1}.estwrite.data{1} = cellstr(filenames_for_ra);
  
    
    
    spm_jobman('run', jobs); 
	%clear jobs
    
    disp(strcat({'@ Realignment for '},subjs(isub).name, {' done'}))
    
      
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	COREGISTRATION: Estimate I  (Highres to meanepi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = coreg_highres_meanepi()

%     uhr = fix(clock);
%     disp(strcat({'Startzeit '},num2str(uhr(4)),':',num2str(uhr(5)),':',num2str(uhr(6))))
    
    clear jobs
    
    [meanepi_filename, dirs] = spm_select('List', direc_funct, '^mean.*\.nii$'); % after realignment & unwarp with a "*u*"
   
        
    meanepi = fullfile(direc_funct,meanepi_filename);
    highres = fullfile(direc_struct,anat_filename);

    jobs{1}.spatial{1}.coreg{1}.estimate.ref = {meanepi};   %reference image > where to coreg to?
    jobs{1}.spatial{1}.coreg{1}.estimate.source = {highres}; % source image > what to coreg?
    
    jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.cost_fun = 'nmi';
    jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.sep = [4 2];
    jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.tol = [0.0200 0.0200 0.0200 0.0010 0.0010 0.0010 0.0100 0.0100 0.0100 0.0010 0.0010 0.0010];
    jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.fwhm = [7 7];      
    jobs{1}.spatial{1}.coreg{1}.estimate.other = {''};
    
    spm_jobman('initcfg')

    spm_jobman('run',jobs);
   % clear jobs

    disp(strcat({'@ Coregistration for '},subjs(isub).name, {' done.'}))

end % end function coregistration
 
 
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	SPM SEGMENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = spm_segment()
        
         
   
%     uhr = fix(clock);
%     disp(strcat({'Startzeit '},num2str(uhr(4)),':',num2str(uhr(5)),':',num2str(uhr(6))))
%     
    clear jobs 
    
    jobs{1}.spatial{1}.preproc.channel.vols = { fullfile(direc_struct,anat_filename) };
    jobs{1}.spatial{1}.preproc.channel.biasreg = 0.0001;
    jobs{1}.spatial{1}.preproc.channel.biasfwhm = 60;
    jobs{1}.spatial{1}.preproc.channel.write = [0 0];
    jobs{1}.spatial{1}.preproc.tissue(1).tpm = {strcat(spm_dir,'\tpm\TPM.nii,1')};
    jobs{1}.spatial{1}.preproc.tissue(1).ngaus = 2; %default: 1;
    jobs{1}.spatial{1}.preproc.tissue(1).native = [1 1];
    jobs{1}.spatial{1}.preproc.tissue(1).warped = [0 0];
    jobs{1}.spatial{1}.preproc.tissue(2).tpm = {strcat(spm_dir,'\tpm\TPM.nii,2')};
    jobs{1}.spatial{1}.preproc.tissue(2).ngaus = 2;  %default: 1;
    jobs{1}.spatial{1}.preproc.tissue(2).native = [1 1];
    jobs{1}.spatial{1}.preproc.tissue(2).warped = [0 0];
    jobs{1}.spatial{1}.preproc.tissue(3).tpm = {strcat(spm_dir,'\tpm\TPM.nii,3')};
    jobs{1}.spatial{1}.preproc.tissue(3).ngaus = 2;
    jobs{1}.spatial{1}.preproc.tissue(3).native = [1 1]; %  CSF mit ausgeben; 
    jobs{1}.spatial{1}.preproc.tissue(3).warped = [0 0];
    jobs{1}.spatial{1}.preproc.tissue(4).tpm = {strcat(spm_dir,'\tpm\TPM.nii,4')};
    jobs{1}.spatial{1}.preproc.tissue(4).ngaus = 3;
    jobs{1}.spatial{1}.preproc.tissue(4).native = [0 0]; % brauch man im Zweifelsfall nicht [1 0]
    jobs{1}.spatial{1}.preproc.tissue(4).warped = [0 0];
    jobs{1}.spatial{1}.preproc.tissue(5).tpm = {strcat(spm_dir,'\tpm\TPM.nii,5')};
    jobs{1}.spatial{1}.preproc.tissue(5).ngaus = 4;
    jobs{1}.spatial{1}.preproc.tissue(5).native = [0 0]; % brauch man im Zweifelsfall nicht [1 0]
    jobs{1}.spatial{1}.preproc.tissue(5).warped = [0 0];
    jobs{1}.spatial{1}.preproc.tissue(6).tpm = {strcat(spm_dir,'\tpm\TPM.nii,6')};
    jobs{1}.spatial{1}.preproc.tissue(6).ngaus = 2;
    jobs{1}.spatial{1}.preproc.tissue(6).native = [0 0];
    jobs{1}.spatial{1}.preproc.tissue(6).warped = [0 0];
    jobs{1}.spatial{1}.preproc.warp.mrf = 1; % was 0, MG 18.11.2013
    jobs{1}.spatial{1}.preproc.warp.cleanup = 1; 
    jobs{1}.spatial{1}.preproc.warp.reg = [0 0.001 0.5 0.05 0.2]; % was 4, MG 18.11.2013
    jobs{1}.spatial{1}.preproc.warp.affreg = 'mni';
    jobs{1}.spatial{1}.preproc.warp.fwhm = 0;
    jobs{1}.spatial{1}.preproc.warp.samp = 3;
    jobs{1}.spatial{1}.preproc.warp.write = [0 0];
    
    spm_jobman('initcfg')
    spm_jobman('run',jobs);
   % clear jobs

   disp(strcat({'@ SPM Segment for '}, subjs(isub).name, {' done.'}))
   
end % end function spm segment
 
 


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 	CREATE TEMPLATE (DARTEL)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% function [] = dartel_create()
%         
%     clear jobs
%     inclusion = dir(fullfile(template_dir,'*.txt'));
%     
%     names = textread(fullfile(template_dir,inclusion.name),'%s');
%     
%     
%     for irc = 1:3
%     
%         
%         for iname = 1:length(names)
%         
%             rc_dir = fullfile(study_dir,'Individuals',names{iname},'T1');
%             
%             warpim = dir(fullfile(rc_dir,strcat('rc',num2str(irc),'s_',names{iname},'*')));
%             warpimages{irc}(iname) = {fullfile(rc_dir,warpim.name)};
%                               
%             
%             
%         end
%         
%     end
%         
%     jobs{1}.tools{1}.dartel{1}.warp.images = {
%                                              %  {
%                                                warpimages{1}(:)
%                                               % }
%                                              %  {
%                                                warpimages{2}(:)
%                                             %   }
%                                             %   {
%                                                warpimages{3}(:)
%                                             %   }
%                                                }';
%                                            
%     
% %%
% jobs{1}.tools{1}.dartel{1}.warp.settings.template = 'Template';
% jobs{1}.tools{1}.dartel{1}.warp.settings.rform = 0;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(1).its = 3;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(1).rparam = [4 2 1e-06];
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(1).K = 0;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(1).slam = 16;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(2).its = 3;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(2).rparam = [2 1 1e-06];
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(2).K = 0;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(2).slam = 8;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(3).its = 3;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(3).rparam = [1 0.5 1e-06];
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(3).K = 1;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(3).slam = 4;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(4).its = 3;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(4).K = 2;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(4).slam = 2;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(5).its = 3;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(5).K = 4;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(5).slam = 1;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(6).its = 3;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(6).K = 6;
% jobs{1}.tools{1}.dartel{1}.warp.settings.param(6).slam = 0.5;
% jobs{1}.tools{1}.dartel{1}.warp.settings.optim.lmreg = 0.01;
% jobs{1}.tools{1}.dartel{1}.warp.settings.optim.cyc = 3;
% jobs{1}.tools{1}.dartel{1}.warp.settings.optim.its = 3;
%     
%         spm_jobman('initcfg')
%     spm_jobman('run',jobs);
%    % clear jobs
%    
% 
% 
%     disp(strcat({'@ DARTEL template created.'}))
% 
% end % end function 






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 	APPLY DEFORM (VBM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = apply_deform()
        
    clear jobs

    
    [raw_func_filenames_deform, dirs] = spm_select('List', direc_funct, '^r_a_.*\.nii$');
    filenames_for_deform = strcat(direc_funct,filesep,raw_func_filenames_deform); 
    
    [field_deform, dirs] = spm_select('List', direc_struct, '^y_rco.*\.nii$');
    field_for_deform = strcat(direc_struct,filesep,field_deform); 
    
    
    jobs{1}.tools{1}.vbm8.tools.defs.field1 = {field_for_deform};
    jobs{1}.tools{1}.vbm8.tools.defs.images = cellstr(filenames_for_deform);
    jobs{1}.tools{1}.vbm8.tools.defs.interp = 5;
    jobs{1}.tools{1}.vbm8.tools.defs.modulate = 0;
       
  %  spm_jobman('initcfg')
    spm_jobman('run',jobs);
   


    disp(strcat({'@ Deformation applied for '}, subjs(isub).name))    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 	SMOOTH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = smooth()
        
    clear jobs

    [raw_func_filenames_smooth, dirs] = spm_select('List', direc_funct, '^wr_a_.*\.nii$');
    filenames_for_smooth = strcat(direc_funct,filesep,raw_func_filenames_smooth); 
    
    jobs{1}.spatial{1}.smooth.data = cellstr(filenames_for_smooth);
    jobs{1}.spatial{1}.smooth.fwhm = [5 5 5];
    jobs{1}.spatial{1}.smooth.dtype = 0;
    jobs{1}.spatial{1}.smooth.im = 0;
    jobs{1}.spatial{1}.smooth.prefix = 's_';
    
  %  spm_jobman('initcfg')
    spm_jobman('run',jobs);
   


    disp(strcat({'@ Smoothing finished for '}, subjs(isub).name))    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	EXISTING TEMPLATE (DARTEL)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = dartel_existing()
        
    clear jobs
    %inclusion = dir(fullfile(template_dir,'*.txt'));
    
    %names = textread(fullfile(template_dir,inclusion.name),'%s');
    
    
    
    for iname = 1:length(subjs)
     %   if ~ismember(all_subjs(iname).name,names)
            
           rc_dir = fullfile(study_dir,subjs(isub).name,strcat('Structural_',subjs(isub).name,'_DARTEL'));
       
           for irc = 1:3
           
                warpim = dir(fullfile(rc_dir,strcat('rc',num2str(irc),'co','*')));
                warpimages{irc}{isub} = fullfile(rc_dir,warpim.name);
              
            end
      %  else end
        
    end
    
    warpimages{1}(cellfun(@isempty,warpimages{1})) = [];
    warpimages{2}(cellfun(@isempty,warpimages{2})) = [];
    warpimages{3}(cellfun(@isempty,warpimages{3})) = [];
    
     jobs{1}.tools{1}.dartel{1}.warp1.images = {
                                               warpimages{1}(:)
                                               warpimages{2}(:)
                                               warpimages{3}(:)
                                               
                                                }';
%%
 jobs{1}.tools{1}.dartel{1}.warp1.settings.rform = 0;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(1).its = 3;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(1).rparam = [4 2 1e-06];
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(1).K = 0;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(1).template = {strcat(template_dir,'\rTemplate_1_IXI550_MNI152.nii')};
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(2).its = 3;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(2).rparam = [2 1 1e-06];
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(2).K = 0;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(2).template = {strcat(template_dir,'\rTemplate_2_IXI550_MNI152.nii')};
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(3).its = 3;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(3).rparam = [1 0.5 1e-06];
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(3).K = 1;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(3).template = {strcat(template_dir,'\rTemplate_3_IXI550_MNI152.nii')};
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(4).its = 3;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(4).rparam = [0.5 0.25 1e-06];
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(4).K = 2;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(4).template = {strcat(template_dir,'\rTemplate_4_IXI550_MNI152.nii')};
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(5).its = 3;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(5).rparam = [0.25 0.125 1e-06];
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(5).K = 4;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(5).template = {strcat(template_dir,'\rTemplate_5_IXI550_MNI152.nii')};
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(6).its = 3;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(6).rparam = [0.25 0.125 1e-06];
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(6).K = 6;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.param(6).template = {strcat(template_dir,'\rTemplate_6_IXI550_MNI152.nii')};
 jobs{1}.tools{1}.dartel{1}.warp1.settings.optim.lmreg = 0.01;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.optim.cyc = 3;
 jobs{1}.tools{1}.dartel{1}.warp1.settings.optim.its = 3;
    
       

    spm_jobman('initcfg')
    spm_jobman('run',jobs);
   % clear jobs
   


    disp(strcat({'@ existing DARTEL template applied.'}))

end % end function existing DARTEL


 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	NORMALIZE TO MNI (DARTEL)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [] = norm2mni()
        
    clear jobs
 
%    [funct_filenames_norm, dirs] = spm_select('List', direc_funct, '^a_f.*\.nii$'); % ANPASSEN!!
	[funct_filenames_norm, dirs] = spm_select('List', direc_funct, '^r_r_a_.*\.nii$');
    filenames_for_norm = strcat(direc_funct,filesep,funct_filenames_norm); 
    
    flowfield_filename = dir(fullfile(direc_struct, 'wco*'));
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

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % REALIGN & UNWARP
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% function [] = realign_unwarp()
% 
% %for i = 1:number_subjects_all  
%     
%     disp(strcat({'@ Realign and Unwarp for: '},subject_dir_all{i}))
%     uhr = fix(clock);
%     disp(strcat({'Startzeit '},num2str(uhr(4)),':',num2str(uhr(5)),':',num2str(uhr(6))))
%     
%     [funct_filenames, dirs] = spm_select('List', direc_funct, '^f_.*\.nii$');
%     filenames_w_path = strcat(direc_funct,filesep,funct_filenames); 
%     
%     
%   
%     jobs{1}.spatial{1}.realignunwarp.eoptions.quality = 0.9; % Quality (Default: 0.9)
%     jobs{1}.spatial{1}.realignunwarp.eoptions.sep = 6; % Separation (Default: 4) 
%     jobs{1}.spatial{1}.realignunwarp.eoptions.fwhm = 5; % Smoothing (FWHM) (Default: 5)
%     jobs{1}.spatial{1}.realignunwarp.eoptions.rtm = 1;% Num Passes (Default: Register to mean) 
%     jobs{1}.spatial{1}.realignunwarp.eoptions.einterp = 4;% Interpolation (Default: 2nd Degree B-Spline)
%     jobs{1}.spatial{1}.realignunwarp.eoptions.ewrap = [0 0 0]; % Wrapping (Default: No wrap) 
%     jobs{1}.spatial{1}.realignunwarp.eoptions.weight = ''; % Weighting (Default: None) {''};
%     jobs{1}.spatial{1}.realignunwarp.uwroptions.uwwhich = [2 1];% Resliced Images ([0 1] > Only Mean Image; Default: [2 1] > All Images + Mean Image)       
%                         % Bei UNWARP gibt es nur die Optionen "Alle Images"
%                         % oder "Alle Images + MEAN". Man muss also direkt
%                         % schreiben. Stimmt dann die Reihenfolge mit
%                         % slice-timing nocH?
%     jobs{1}.spatial{1}.realignunwarp.uwroptions.rinterp = 5;% Interpolation (Default: 4th Degree B-Spline) 
%     jobs{1}.spatial{1}.realignunwarp.uwroptions.wrap = [0 0 0]; % Wrapping (Default: No wrap) 
%     jobs{1}.spatial{1}.realignunwarp.uwroptions.mask = 1; % Masking (Default: Mask images) 
%     
%     %Die Einstellungen hier drunter weiß ich nicht, habe ich von Batch die
%     %Defaults übernommen
%     jobs{1}.spatial{1}.realignunwarp.uweoptions.basfcn = [12 12];
%     jobs{1}.spatial{1}.realignunwarp.uweoptions.regorder = 1;
%     jobs{1}.spatial{1}.realignunwarp.uweoptions.lambda = 100000;
%     jobs{1}.spatial{1}.realignunwarp.uweoptions.jm = 0;
%     jobs{1}.spatial{1}.realignunwarp.uweoptions.fot = [4 5];
%     jobs{1}.spatial{1}.realignunwarp.uweoptions.sot = [];
%     jobs{1}.spatial{1}.realignunwarp.uweoptions.uwfwhm = 4;
%     jobs{1}.spatial{1}.realignunwarp.uweoptions.rem = 1;
%     jobs{1}.spatial{1}.realignunwarp.uweoptions.noi = 5;
%     jobs{1}.spatial{1}.realignunwarp.uweoptions.expround = 'Average';
%     jobs{1}.spatial{1}.realignunwarp.uwroptions.prefix = 'u_';
% 
%         
%    %jobs{1}.spatial{1}.realignunwarp.data.pmscan = {fullfile(direc_fm,vdm_filename)};
%     jobs{1}.spatial{1}.realignunwarp.data.scans = cellstr(filenames_for_realign_1); %(j)
%         
%         
% 	spm_jobman('initcfg')
% 	spm_jobman('run', jobs); 
% 	clear jobs
%     
% %end % end i loop
% disp('Realign & Unwarp done')
% 
% end % end function realign & unwarp
% 
% 
% 
% 

% 
% 

%     
% 

    
end 









