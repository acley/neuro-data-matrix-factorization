import numpy as np
import scipy as sp
import h5py
import time
import pdb

#def train_MRMF(entity_types, relation_types, k, mu, gamma, delta):
#	# entity_types: 	a list of tuples describing the entities:
#	#					[(<name_of_entity_type>, <num_of_entities_in_type>),...]
#	# relation_types:	a list of the observed relations of each relation type where each
#	#					observed relation consists of a tuple of the indices of the corresponding
#	#					entities, i.e.:
#	#					[((e_a, e_b), [(e_a_i, e_b_j),...]), 
#	#					 ((e_a, e_c), [(e_a_i, e_c_j),...])]
#	# k: 				number of factors
#	# mu: 				learning rate
#	# gamma: 			regularization parameter
#	# delta: 			convergence threshold

#	# initialize entity types with random values
#	E = []
#	for (i,entity_type) in enumerate(entity_types):
#		entity_dim = entity_type[1]
#		E_i = numpy.random.rand(entity_dim, k)
#		E.append(E_i)
#	
#	converged = false
#	while not(converged):
#		# select random observed relation
#		rand_rel_type = relation_types[numpy.random.randint(len(relation_types))]
#		rand_obs_rel = rand_rel_type[1][numpy.random.randin(len(ran_rel_type))]

#		# entity type information for randomly selected observation
#		entity_idx_a = rand_rel_type[0][0]
#		entity_idx_b = rand_rel_type[0][1]
#		entity_a = E[entity_idx_a][rand_obs_rel[0,:]
#		entity_b = E[entity_idx_b][rand_obs_rel[1,:]

#		# compute gradient
#		grad_e_a = gamma * entity_a - 2 *
		
def train_MRMF_vanilla(h5py_file, h5py_file2, entity_types, relation_types, k, mu, reg, conv_delta,main_log,side_log):

	# initialize entity types with random values
	for (i,entity_type) in enumerate(entity_types):
		name = entity_type[0]
		num_entities = entity_type[1]
		print str(num_entities) + ' ' + str(k) + ' ' + name
		tmp = np.random.rand(num_entities, k)
		dset = h5py_file2.create_dataset(name, data=tmp)
	
	error = 0
	converged = False
	it = 0
	while not(converged):
		relation_time = time.time()
		# reset error
		error_list = []
		error_tmp = 0
		for (i,relation) in enumerate(relation_types):
			# select data sets from h5py file
			load_time = time.time()
			relation_name = relation[0]
			entity_A_name = relation[1]
			entity_B_name = relation[2]
			relation_matrix = h5py_file[relation_name]
			E_a = h5py_file2[entity_A_name]
			E_b = h5py_file2[entity_B_name]
			load_time = time.time() - load_time
			
			# update error
			ent_error_time = time.time()
			if entity_A_name in error_list:
				error_tmp += entity_type_error(E_a)
			if (entity_B_name in error_list):
				error_tmp += entity_type_error(E_b)
			ent_error_time = time.time() - ent_error_time
			
			grad_time = time.time()
#			for row in sp.arange(relation_matrix.shape[0]):
#				nz_columns = relation_matrix[row,:].nonzero()[0]
#				for col in sp.arange(nz_columns.size):
#					R_ij = relation_matrix[row,col]
#					e_ai = E_a[row,:]
#					e_bj = E_b[col,:]
#					
#					grad_A = gradient(reg, R_ij, e_ai, e_bj)
#					grad_B = gradient(reg, R_ij, e_bj, e_ai)
#					
#					E_a[row,:] = e_ai - mu * grad_A
#					E_b[col,:] = e_bj - mu * grad_B
			grad_time = time.time() - grad_time
			
			# calculate squared error
			main_error_time = time.time()
			pdb.set_trace()
			rel_mat_f = relation_matrix[:,:]
			E_a_f = E_a[:,:]
			E_b_f = E_b[:,:]
			squared_error = np.square(rel_mat_f[rel_mat_f != 0] - E_a_f.dot(E_b_f.T)[rel_mat_f != 0])
			error_tmp += sum(sum(squared_error))
			main_error_time = time.time() - main_error_time
			
			# logging
			log_str = str(it) + ': ' + 'load_time: ' + str(load_time) + \
					', ent_error: ' + str(ent_error_time) + \
					', grad_time: ' + str(grad_time) + \
					', main_error: ' + str(main_error_time)
			side_log.write(log_str + '\n')
			print log_str
			
		# check for convergence
		if abs(error - error_tmp) < conv_delta:
			converged = True
		
		# update error
		error = error_tmp
		
		# logging final error
		relation_time = time.time() - relation_time
		log_str = 'error: ' + str(error) + 'rel_time: ' + str(relation_time)
		main_log.write(str(it) + ': ' + log_str + '\n')
		print('===============' + log_str + '===================================================')
		it += 1		

def calc_gradient(reg, R_ij, e_ai, e_bj):
	grad = reg*e_ai - 2*(R_ij - e_ai.dot(e_bj.T))*e_bj
	return grad
	
def entity_type_error(reg, E):
	error = reg * np.square(np.linalg.norm(E))
	return error
	
	
#with h5py.File('neurodata.h5py','r') as f, \
#	h5py.File('test.h5py') as f2, \
#	open('main_log.txt', 'w') as f3, \
#	open('main_log.txt', 'w') as f4:

with h5py.File('neurodata.hdf5', 'r') as f1, h5py.File('test.hdf5') as f2:
	
	f3 = open('main_log.txt', 'w')
	f4 = open('side_log.txt', 'w')
	
	num_voxel = 902629
	entity_types = [('voxel', num_voxel), \
					('features', 525), \
					('001', 712), \
					('002', 712), \
					('003', 672), \
					('004', 712), \
					('005', 711)]
	relation_types = [('nsynth_data', 'voxel', 'features'), \
						('SQR_001', 'voxel', '001'), \
						('SQR_002', 'voxel', '002'), \
						('SQR_003', 'voxel', '003'), \
						('SQR_004', 'voxel', '004'), \
						('SQR_005', 'voxel', '005')]

	reg = 0.06
	mu = 0.005
	k = 50
	conv_delta = 100
	train_MRMF_vanilla(f1, f2, entity_types, relation_types, k, mu, reg, conv_delta,f3,f4)
	
	f3.close()
	f4.close()
			
			
			
			
			
			
			
		
