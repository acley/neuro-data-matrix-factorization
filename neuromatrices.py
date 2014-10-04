import nibabel as nib
import scipy as sp
import glob
import numpy as np
import h5py
import os
from neurosynth.base.dataset import Dataset

class AutoExpandingArray:
	def __init__(self):
		self.data = np.zeros((2,100))
		self.capacity = 100
		self.size = 0

	def update(self, row):
		for r in row:
			self.add(r)

	def add(self, x, rowidx):
		if (self.size + x.shape[0]) >= self.capacity:
			self.capacity = max((self.size + x.shape[0]), self.capacity*4)
			newdata = np.zeros((2,self.capacity,))
			newdata[:,:self.size] = self.data[:,:self.size]
			self.data = newdata
		tempdata = sp.append(sp.vstack(x).T,sp.ones((1,x.shape[0]))*rowidx,axis=0)
		self.data[:,self.size:self.size+x.shape[0]] = tempdata
		self.size += x.shape[0]

	def finalize(self):
		data = self.data[:,:self.size]
		return data

def numpy_voxel_feature_matrix(dataset, image_folder):
	feature_list = dataset.get_feature_names()
	num_voxel = dataset.volume.full.shape[0]
	num_features = len(feature_list)
	voxel_by_features = sp.zeros((num_voxel, num_features), dtype=sp.int16)
	for (i,feature) in enumerate(feature_list):
		image_path = image_folder + feature + '_pFgA_z.nii.gz'
		image = nib.load(image_path)
		voxel_by_features[:,i] = image.get_data().ravel()
	return voxel_by_features

def numpy_voxel_activity_matrix(dataset, image_folder):
	image_list = sorted(glob.glob(image_folder + 'rr_*.nii'))
	num_voxel = dataset.volume.full.shape[0]
	num_scans = len(image_list)
	voxel_activity_mat = sp.zeros((num_voxel, num_scans), dtype=sp.int16)
	for (i,image_path) in enumerate(image_list):
		image = nib.load(image_path)
		voxel_activity_mat[:,i] = image.get_data().ravel()
	return voxel_activity_mat

def add_h5py_voxel_activity_matrix(h5py_file, dataset, image_folder, dset_name):
	image_list = sorted(glob.glob(image_folder + 'rr_*.nii'))
	num_voxel = dataset.volume.full.shape[0]
	num_scans = len(image_list)
	dset = h5py_file.create_dataset(dset_name, (num_voxel, num_scans), dtype=np.int16)
	for (i,image_path) in enumerate(image_list):
		image = nib.load(image_path)
		dset[:,i] = image.get_data().ravel()
		
def add_h5py_voxel_feature_matrix(h5py_file, dataset, image_folder, dset_name):
	feature_list = sorted(dataset.get_feature_names())
	num_voxel = dataset.volume.full.shape[0]
	num_features = len(feature_list)
	dset = h5py_file.create_dataset(dset_name, (num_voxel, num_features), dtype=np.int16)
	for (i,feature) in enumerate(feature_list):
		image_path = image_folder + feature + '_pFgA_z.nii.gz'
		image = nib.load(image_path)
		dset[:,i] = image.get_data().ravel()
	
dataset_loc = 'data/old/neurosynth-dataset.pkl'
neurosynth_image_loc = 'data/old/results/'
fMRI_base_dir = '/home/achim/masterprojekt/data/functional_realigned/'
dataset = Dataset.load(dataset_loc)

# load matrices in hdf5 database
with h5py.File('neurodata.hdf5') as f:
	# add voxel feature matrix (from neurosynth)
	add_h5py_voxel_feature_matrix(f, dataset, neurosynth_image_loc, 'nsynth_mat')
	print('neurosynth data added.')

	# add voxel activity matrices (from fMRI scans)
	subject_folders = sorted(os.listdir(fMRI_base_dir))
	for (i,folder) in enumerate(subject_folders):
		image_folder_path = fMRI_base_dir + folder + '/'
		add_h5py_voxel_activity_matrix(f, dataset, image_folder_path, 's_' + str(i+1))
		print(folder + ' added.')

#with h5py.File('neurodata.hdf5', 'a') as f:
#	keys = sorted(os.listdir(fMRI_base_dir))
#	for (i,key) in enumerate(keys):
#		dset = f[key]
#		nonzero_entries = AutoExpandingArray()
		
#a = AutoExpandingArray()
#b = sp.rand(80)
#a.add(b,1)
#b = sp.rand(80)
#a.add(b,2)	


