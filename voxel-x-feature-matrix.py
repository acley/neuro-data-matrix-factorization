from scipy import *
from pylab import *
import neurosynth
from neurosynth.base.dataset import Dataset

def create_dataset(database_location, feature_location):
	dataset = Dataset(database_location)
	dataset.add_features(feature_location)
	dataset.save('dataset.pkl')
	return dataset
	
def do_full_analysis(dataset):
	feature_list = dataset.get_feature_names()
	meta.analyze_features(dataset, feature_list, threshold=0.001,save='results/')
	
def coordinates_to_voxel_idx(coords_xyz, masker):
	# transform to homogeneous coordinates
	coords_h_xyz = append(coords_xyz, ones([1,coords_xyz.shape[1]]),axis=0)
	
	# apply inverse affine transformation to get homogeneous coordinates in voxel space
	inv_transf = linalg.inv(masker.volume.get_affine())
	coords_h_voxel_space = inv_transf.dot(coords_h_xyz)
	coords_h_voxel_space = rint(coords_h_voxel_space).astype(int)
	
	# remove homogeneous dimension
	coords_voxel_space = coords_h_voxel_space[0:-1,:]
	
	# convert coordinates to idcs in a flattened voxel space
	flattened_idcs = ravel_multi_index(coords_voxel_space, masker.dims)
	
	# check if there is any study data for the flattened idcs
	voxel_idcs = zeros((1,len(flattened_idcs)),dtype=int64)
	for i in range(0,len(flattened_idcs)):
		idcs = find(masker.in_mask == flattened_idcs[i])
		if len(idcs > 0):
			voxel_idcs[0,i] = find(masker.in_mask == flattened_idcs[i])
		else:
			voxel_idcs[0,i] = nan
			
	return voxel_idcs
	
def voxel_idx_to_coordinates(voxel_idcs, masker):
	# find idcs in non-sparse, flattened voxel space
	flattened_idcs = zeros((1,voxel_idcs.shape[1]),dtype=int64)
	for i in range(0,voxel_idcs.shape[1]):
		flattened_idcs[0,i] = masker.in_mask[0][voxel_idcs[0,i]]

	# find non-homogeneous voxel-space coordinates
	coords_voxel_space = unravel_index(flattened_idcs, masker.dims)
	
	# transform into homogeneous coordinates in voxel space
	coords_h_voxel_space = array([coords_voxel_space[0][0],
								coords_voxel_space[1][0],
								coords_voxel_space[2][0]])
	coords_h_voxel_space = append(coords_h_voxel_space, 
								ones([1,size(coords_h_voxel_space,1)]), axis=0)
	
	# apply affine transformation to get real world xyz coordinates
	transform = masker.volume.get_affine()
	coords_h = transform.dot(coords_h_voxel_space)
	
	# convert into non-homogeneous coordinates
	coords_xyz = coords_h[0:-1,:]
	
	return coords_xyz
	
def create_voxel_x_feature_matrix(dataset):
	feature_list = dataset.get_feature_names()
	masker = dataset.volume
	vox_feat_matrix = zeros((len(masker.in_mask[0]), len(feature_list)))
	for (i,feature) in enumerate(feature_list):
		image_path = 'results/' + feature + '_pFgA_z.nii.gz'
		vox_feat_matrix[:,i] = masker.mask(image_path)
	return vox_feat_matrix
	
# prepare dataset. this only needs to be done once and takes a couple of minutes
#path_to_database_txt = 'data/databse.txt'
#path_to_features.txt = 'data/features.txt'
#dataset = create_dataset('data/databse.txt', 'data/features.txt')
#do_full_analysis(dataset)

dataset = Dataset.load('dataset.pkl')
masker = dataset.volume
features = dataset.get_feature_names()
voxel_feature_matrix = create_voxel_x_feature_matrix(dataset)

# testing the coordinate conversions
#xyz_coords = array([[-10,15,],[-10,5],[0,8]])
#print xyz_coords
#voxel_idcs = coordinates_to_voxel_idx(xyz_coords, masker)
#xyz_coords2 = voxel_idx_to_coordinates(voxel_idcs,masker)
#print xyz_coords2

