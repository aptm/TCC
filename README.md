# TCC

Tested on Matlab 2017a

file description:

  **experimento_transferLearningAlexnet.m** generates 7 different types of nets. Each of them trained on images with different types of noise added to them. There are two types of testing: one with the dataset with the same type of noise used in the training and other testing with all types of noise.
  
  **separabase.m will** get images from the given directory and separate them into 3 folders: train, valid and test. There were two directories to be separated: original and the augmented folder.
  
  **dataaugmentation.m** shall augment the dataset in a given folder
  
  Dataset used: 
  [MU_HandImages](https://mro.massey.ac.nz/bitstream/handle/10179/4514/GestureDatasetRLIMS2011.pdf?sequence=1&isAllowed=y) 
  
