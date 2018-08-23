saveMissedPred.m

savedirmissed = strcat(savedir,'missedPredictions\');
mkdir savedirmissed

idx = find(predictedLabels !=valLabels);
fe = length(filepath_dataset);

for k = 1:length(idx)
	filename = validationImages.Files{idx(k)}(fe+3:end-4);
	im = readImage(validationImages,idx(k));
	Pred = strcat('_P_',char(predictedLabels(idx(k))),'.png');
	imwrite(im,strcat(savedirmissed,filename,Pred))
end