# Defect_Detection_MatLab
Automated Defect Detection Project, implemented by Matlab

## Project Structure Overview
The project is written with Matlab and was run with the Matlab r2017a​ version. The project has been tested on macOS Sierra, Windows 7, Windows 10 and Ubuntu 17.10 platforms. Some parts of the code require GPU that supports CUDA to function correctly.

The project has three types of files: functions, scripts and data folders. Functions can be divided into several categories, such as data parser, screening method, etc. Scripts can be divided into several categories, such as image augmentation, train cascade object detector. To make it easy to call different functions, all the function files and scripts are directly located in the same folder. The images data are located in subfolders of project folder. Image data folder can be divided into several categories, such as positive images, negative images. For example, two set of positive images are located in the folder “positive” and “aug_training_positive_images”, separately. The overview of the project structure is presented in the figure below. More detailed information about each category is introduced in the following sections. 

## Source Code

1. Scripts

To get started with the project, please go through all the scripts to get a detailed understanding of the complete workflow. The scripts can be run step-by-step with instant results in the workspace, as well as command line window. The scripts calls both the built-in functions in Matlab and self-developed functions for this project. The figure below is a list of all the scripts written, while the left column is the categories that these scripts belong to. When all the data folder is present as the original folder, all the scripts can run independently. (that is, you can try any script without running the previous scripts.) All the categories are sorted in a sequential way.

### Dataset preparation: 

This category contains the scripts that manipulates the original image files to prepare a larger and better dataset to use in the subsequent training section. 

imageAugmentation: This script is to augment the existing positive images by rotation and mirroring.

loopDatasetPrep: This script parses excel file into txt file to save read and write time and disk space.

negImgAugmentation: This script is to augment the existing negative images by rotation, resizing, changing aspect ratio, and mirroring.

negImgGen: This script generates negative images by cropping positive region from position images

### Train Cascade Object Detector: 

This category contains the scripts that read in the dataset and train a cascade object detector.

loopDetector: This script imports the positive instances (image name + bounding boxes) and negative images, and train a cascade object detector based on the  dataset.
### CNN dataset preparation: 
This category contains the scripts that prepare the dataset that can be used to train a convolutional neural network.
cropPosimgs: This script loads a cascade object detector model and apply the model on the image set to crop true detections as loop images and false detections as non-loop images.
### Train CNN classifier: 
This category contains the script that reads in the loop image dataset and train a convolutional neural network,
readcropimages: This script is to train a CNN classifier, which contains code to read in dataset images, construct a CNN, train and test a CNN, including precision and recall curve plotting.
### Test images: 
This category contains the scripts that compares the other researchers’ labeling with the standard true labeling, and compares the machine labeling with the standard true labeling.
Human_variability: This script compares human variation with standard labeling
testImageSet: This script compares machine labeling with standard labeling. The script takes all images in the test set and give average recall and precision score over the test set.
### Helper Scripts: 
This category contains other scripts that are mainly for debugging.
label_all_pos: This script is a helper script to check if all the labeling is correct. This script shows all the images with labeled loops on them. This script is usually used for debugging.
confusionMatrix: This script is to test a single image given its labeling file name. It applies the cascade object detector on the image to detect the loop position and then calls the screening and extraction method to output the detected result.
showREconIM: This script can plot out the bounding boxes of an image given its corresponding labeling filename.
test_hough: This script is an old script that is not used anymore. The main purpose is for debugging the flood algorithm and hough ellipse transform on a single loop image
testaugmentation:This script is used to test the correctness of image augmentation, making sure that the augmented labeling files has the correct coordinates on the corresponding images.
weightLearning: This script trains a neural network (not convolutional neural network) that reads the human extracted features and tuned the weights on those features to screening loops / non-loops. Old script, cannot guarantee it will still work. 

The scripts are well commented and already broken into a series of sections to run step-by-step. (Run step-by-step is more recommended than run all at once. As the some code section may take a long time to run. And you may need to change some directory name or block some sections when you are doing some sort of task, so rerun some section of code is a frequent thing.) Please refer to the code file to get more detailed information about how each script works.


## Functions

There are some self-built functions that are used in the scripts and these functions are listed in the figure above. These functions are divided into several categories based on their purpose. For example, “Data Parser” refers to read in the labeling files and process them into some sort of data structure that can be used by Matlab built-in functions. These categories are just very general. Functions in one category can call functions in the other categories, for example, mlscreen() calls foodfitting() to get elliptical fitting of the screened images; footfitting calls flood(), flood() calls centroidFind() and crop(), etc. The following is a brief list of the purpose of these function. For more detailed information, like what arguments it takes and what value it returns, please see the detailed comments in the function file.

### Data Parser: 
This category contains functions that reads the labeling files or images

importPositive(): This function reads all labeling txt files in one given folder and returns the table datastructure that can be read by traincascadeobjectdetector() to train the detector.

getPos(): This function reads in the excel file and return a series of values about the location, shape of the loops

readData(): This function read a single txt file and return corresponding image name and the bounding boxes in the txt file

readLabel(): This function is similar to readData() except the output it returns. This function will output a cell array of image names and a cell array of bounding boxes. This function is used to be compatible with old code, so whenever possible, use readData() instead.

getImageName(): This function convert the labeling file name into the corresponding imagename. *IMPORTANT* Please note that this function is used quite a lot and it is suitable only for one layer of file directory, i.e.--imagefolder/imagename -- labelfolder/labelfile.

### Screening Method: 
This category contains functions that screen the detection results of the object detector. Currently only the mlscreen() is used in this project. Other functions are old screening methods that are not used any more.

mlscreen(): mlScreen uses machine learning to screen out bounding boxes produced by cascade object detector. 
ellipseDetection(): Fits an ellipse by examining all possible major axes (all pairs of points) and getting the minor axis using Hough transform.

ellipseFitting(): This function fits an ellipse and return the confidence score of being an ellipse and shape parameter of the fitted ellipse.

screen(): use radial sweeping method to output the confidence score of loop and output the fitted elliptical loop parameters

screenScores(): this function is an older version of screening method. It implements the radial sweeping method and also combines flood fitting, elliptical hough transform and other scoring metrics

sdg_tune_weights(): This function tunes the weights of all the hand crafted features using Stochastic gradient descent (sgd, "sdg" is a typo in the function filename)

Extraction Method: This category contains all the functions used to extract the edge of loop in a cropped image with one loop inside.

flood(): flood function implements the watershed flood algorithm for extracting edge of loops in a cropped image.

centroidFind(): This function find the centroid position of an image

weightedcentroid(): Similar to centroidFind() but uses another algorithm to find the centroid position of an image.

foodfitting(): this function calls flood function and then use regionprop to fit the extracted loop shape and returns the fitted loop shape

ellipse(): Ellipse adds ellipses to the current plot

### Image Test Methods:

testImages(): This function can test images in a specified folder. This draw ellipses, and output the number of matched bounding boxes and mismatched bounding boxes for further calculation of precision and recall scores.

compareBbox(): This function compares the two set of bounding boxes and return the number of bounding boxes matched or mismatched.

evaluate(): This function compares the true bounding boxes with labeled bounding boxes and return the precision and recall score

showbbox(): This function draws the bounding boxes on the image.

### Helper Functions

crop(): This function crops an image to subimage contained one defect by the bounding box given. This function is used quite a lot.

invert(): invert the image intensity values. Making black to white, white to black

checkboxes():  check the bounding box coordinates to make sure the box fits in the images; resize the bounding box if the box is outside the image

negGen(): generate negative image by making patches on the positive image

genNegIm(): old function; not used any more. It basically load a pre-saved dataset and generate the negative images from positive images

genPosIns(): old function, not used any more; This was originally used to read in saved matrix with image names and bounding boxes.

plotTrainingAccuracy(): Helper function in training CNN. Plot the training accuracy against the iteration number.

stopTrainingAtThreshold(): Helper function in training CNN. Stop training if the accuracy has reached a set threshold.

testDetector(): Apply the trained cascade object detector on a test image given and plot the detected bounding boxes on the image

imgDetect(): old function. not used any more. Similar to testDetector() function, expect this function has an additional screening step by radial sweeping method.

FastPeakFind(): Analyze noisy 2D images and find peaks using local maxima.

filterOverlap(): clean overlapped bounding boxes. Keep the larger one if two bounding boxes has 70% overlapping area.
viaresize(): change the size of the image and get the new bounding boxes for the resized image

viarotate(): This function rotates positive image and corresponding bounding boxes and return the rotated image and rotated bounding boxes


## Workflow
Here is the complete workflow on how this project works (without the CNN training part). CNN training is done separately in scripts in “CNN dataset preparation” and “Train CNN classifier” categories.


The positive images are stored in the positive image data folders, while negative images are stored in the negative image data folders.

..* To generate negative image from positive images by making patches, run script “negImGen.m”.

..* To augment the existing dataset, run script “imageAugmentation.m” and “negImgAugmentation.m”. Remember to change the directory name and move images to specified folder if needed. 

..* Cascade Object detector is trained in the scripts in “Train Cascade Object Detector” category.

..* The testing process is done in the scripts

..* The CNN model is loaded in the screening step. See more information in the mlscreen() function. 

..* The testing script is in the script testImageSet and function testImages(). Please read through all the code in those two files to get a detailed information of how it test the images and get the scores.

## Miscellaneous
Currently all the source code are put under Mathlab_Source_Code. To run the code correctly, all the code should be placed in the same project folder where all the data folders exists, i.e. the parent folder of the Matlab_Source_Code folder.
Pre-saved models: There are a series of trained cascade object detectors and cnn models ready for direct use without training. Currently using ones include:

trained_Cascade_Object_Detector: cascade object detector

trained_Cascade_Object_Detector_new: latest cascade object detector

trained_CNN_Screening.mat: latest neural network

Training Cascade Object Detector: There are several factors that affects the final performance of the detector. The following are some factors sorted by their importance.

Number of positive images: more images can improve recall

Number of negative images: more images can improve precision

Number of stages: depend on the number of images. With more images, increase the number of stages, will both increase precision and recall. Increase number of stage without new images added will have not much improvement in general, especially when the parameters setting are already at the best values.

Quality of images: be sure to make bounding box labeling as accurate as possible. Also make sure that negative images contains no region of interests (loops in this project).

 False positive rate: 0.2~0.5. It is a tunable parameter. This affects precision more than recall.
 
True positive rate:  ~0.99 or higher. This mainly affects recall. But also can affect precision a little.


## Data Folder
The data is availabel at [HERE](https://drive.google.com/open?id=1TEqW612v4Ad7en6vsTFEuM68F3igVBdR). Images and labeling files are the most important resources in this project. In this project, there are several versions of images and labeling files, created at different time. Data Folder contains several categories: positive images, negative images, etc. The figure below is an overview of all the data folders used in this project. The leaves in the figure are the actual data folder names, while the internal nodes are the categories.

Positive Images: Contains the positive electron microscopy images with loops inside.

positive: all the original microscopy images used in this project, including testing images. (Do not directly train the model on this folder, because it contains the test images.)  This is the image “data-lake”. We split the training and testing sets by the labeling files, and both training labeling files and testing labeling files locate their corresponding images in this folder. 

aug_training_positive_images: augmented positive image dataset, containing over 1000 images. All the images here are only training images, there is no test image inside. The image folder is created by augmenting the training labeling files and putting their corresponding augmented images in this folder. This is the most recent augmented dataset. If you want to expand or create a new one, pay attention to the overall quality of the images inside, try to make good images more frequent. See more detailed information in the script “imageAugmentation.m”.

Negative Images: contains the negative images without loops, used for object detector training.

negative: all the original images with no loops

aug_negative_images: augmented negative images. This is the folder that is currently using.

Positive loops: Generated by the script “cropPosimgs.m”. This contains all the cropped images with one loop inside correctly spotted out by the cascade object detector.

loops_for_CNN:  The uncleaned version of loop image dataset. This folder is currently used for training CNN classifier. The cascade object detector used to generate this dataset is “trained_cascade_object_detecotor.xml”.

Negative loops: Generated by the script “cropPosimgs.m”. This contains all the cropped images incorrectly spotted out by the cascade object detector, i.e. these images are not considered to be loops by human manual labeling. There might be some labeling errors in this folder, so some of the images inside may actually be the loops.

nonloop_for_CNN: The uncleaned version of negative loop image dataset. This folder is currently used for training CNN classifier. The cascade object detector used to generate this dataset is “trained_cascade_object_detecotor.xml”.

Labeled files: This category contains the most important data folders. This category has folders that contains the labeling files of the loops. There are two file types in this project, one is the excel file produced by imageJ, which contains a list of information, like area, XM, YM, Major, Minor, etc. Another type of file is the txt file only containing the matrix of bounding boxes of the loops inside. The second type of file is small in size and recommended for large augmented dataset.
raw_training _labels:  the current version of all the labeling files that are used for training the cascade object detector. The testing labeling files are not included in this folder. All the files in this folder is in excel format. 

aug_training _labels: all the augmented labeling files based on raw_training_labels folder. This is the folder that is currently using. All the files here has a corresponding image in the aug_trainging_positive_images folder. All the files are stored in .txt format for faster read speed and smaller storage size.

Test Set: this category contains the data folder with testing files inside. The performance of the detector is evaluated by this set. Please note that you need to isolate this set during the training process. 

raw_testing_labels: The complete test set that is currently using. Label Files are in .xls format. The corresponding images are stored under folder named positive.

selected_test_images:  selected six test images from the complete test images for human variability test. These are just images.

selected_test_images_ground_truth: selected six test images from the complete test images for human variability test. These are the corresponding labels from the complete test set.
