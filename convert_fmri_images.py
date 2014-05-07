from neurosynth.base.dataset import Dataset
from neurosynth.base.mask import Masker
import nibabel as nib
#import nipype.interfaces.spm as spm
import glob
import os


#def reslice_fmri_scands():
#	data_dir = '/home/achim/masterprojekt/gdrive/sequrea/functional/'
#	#data_dir = '/home/achim/masterprojekt/neuro-data-matrix-factorization/test/'
#	subj_counter = 0
#	log_file = open('error-log.txt', 'w')
#	for folder in sorted(os.listdir(data_dir)):
#		#os.mkdir(folder)
#		log_file.write(folder + '\n')
#		log_file.flush()
#		for image in sorted(glob.glob(data_dir + folder + '/r_*.nii')):
#			#os.chdir(folder)
#			try:
#				myspm = spm.Reslice(in_file=image, space_defining='attention_pAgF_z.nii')
#				myspm.run()
#			except RuntimeError:
#				print 'Failed to convert: ' + folder + ': ' + image
#				log_file.write(image + '\n')
#				log_file.flush()
#			#os.chdir('..')
#	log_file.close()

def concat_fmri_scans():
	data_dir = '/home/achim/masterprojekt/gdrive/sequrea/functional_realigned/'
	folder = 'SQR_001/'
	images = sorted(glob.glob(data_dir + folder + '*.nii'))
	#c_img = nib.funcs.concat_images(images)

def reduce_fmri_images():
	dataset = 
