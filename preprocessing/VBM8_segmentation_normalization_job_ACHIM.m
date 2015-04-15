%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
%%
%'/home/achim/Data/dummy_sequrea/structural/SQR_001/co20131113_132201t1mprsagp2isos002a1001.nii,1'
%'/home/achim/Data/dummy_sequrea/structural/SQR_002/co20131113_141152t1mprsagp2isos002a1001.nii,1'
%'/home/achim/Data/dummy_sequrea/structural/SQR_003/co20131113_150442t1mprsagp2isos002a1001.nii,1'
matlabbatch{1}.spm.tools.vbm8.estwrite.data = {
'/home/achim/Data/dummy_sequrea/structural/SQR_001/co20131113_132201t1mprsagp2isos002a1001.nii,1',
'/home/achim/Data/dummy_sequrea/structural/SQR_002/co20131113_141152t1mprsagp2isos002a1001.nii,1',
'/home/achim/Data/dummy_sequrea/structural/SQR_003/co20131113_150442t1mprsagp2isos002a1001.nii,1'
                                               };
%%
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.tpm = {'/home/achim/Builds/spm8/toolbox/Seg/TPM.nii,1'};
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.ngaus = [2 2 2 3 4 2];
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.biasreg = 0.0001;
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.biasfwhm = 60;
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.affreg = 'subj';
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.warpreg = 4;
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.samp = 3;
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.dartelwarp.normhigh.darteltpm = {'/home/achim/Builds/spm8/toolbox/vbm8/Template_1_IXI550_MNI152.nii,1'};
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.sanlm = 2;
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.mrf = 0.15;
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.cleanup = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.print = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.GM.native = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.GM.warped = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.GM.modulated = 2;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.GM.dartel = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.WM.native = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.WM.warped = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.WM.modulated = 2;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.WM.dartel = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.CSF.native = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.CSF.warped = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.CSF.modulated = 2;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.CSF.dartel = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.bias.native = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.bias.warped = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.bias.affine = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.label.native = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.label.warped = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.label.dartel = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.jacobian.warped = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.warps = [1 0];
