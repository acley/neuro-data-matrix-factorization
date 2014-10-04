import neurosynth
from neurosynth.base.dataset import Dataset
from neurosynth.analysis import meta

def create_dataset(database_location, feature_location, save_database=True):
	dataset = Dataset(database_location)
	dataset.add_features(feature_location)
	if save_database:	
		dataset.save('neurosynth-dataset.pkl')
	return dataset
	
def do_full_analysis(dataset, image_directory):
	feature_list = dataset.get_feature_names()
	meta.analyze_features(dataset, feature_list, threshold=0.001,save=image_directory)

database_txt_loc = 'data/old/database.txt'
feature_txt_loc = 'data/old/features.txt'
image_directory = 'data/old/results/'

dataset = create_dataset(database_txt_loc, feature_txt_loc)
do_full_analysis(dataset, image_directory)
