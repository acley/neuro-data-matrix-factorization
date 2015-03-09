%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
%%
matlabbatch{1}.spm.tools.vbm8.estwrite.data = {
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_001\co20131113_132201t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_002\co20131113_141152t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_003\co20131113_150442t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_004\co20131113_160424t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_005\co20131113_170313t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_006\co20131118_131806t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_007\co20131118_142840t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_008\co20131118_153139t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_009\co20131118_161716t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_010\co20131118_170644t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_011\co20131119_132105t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_012\co20131119_142157t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_013\co20131119_152354t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_014\co20131119_162533t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_015\co20131119_173326t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_016\co20131125_131225t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_017\co20131125_140522t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_018\co20131125_151639t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_019\co20131125_160128t1mprsagp2isos002a1001.nii,1'
	'D:\home\achim\Masterprojekt\ORIGINAL\structural\Structural_SQR_020\co20131125_170101t1mprsagp2isos002a1001.nii,1'
                                               };
%%
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.tpm = {'C:\Program Files (x86)\MATLAB_Tools\spm8\toolbox\Seg\TPM.nii,1'};
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.ngaus = [2 2 2 3 4 2];
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.biasreg = 0.0001;
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.biasfwhm = 60;
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.affreg = 'subj';
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.warpreg = 4;
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.samp = 3;
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.dartelwarp.normhigh.darteltpm = {'C:\Program Files (x86)\MATLAB_Tools\spm8\toolbox\vbm8\Template_1_IXI550_MNI152.nii,1'};
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
