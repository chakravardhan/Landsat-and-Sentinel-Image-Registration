original = imread('C:\Users\dcvr1\OneDrive - IIIT Bangalore\8th Semester\PE\code\in\landsat_final10.tif');
distorted = imread('C:\Users\dcvr1\OneDrive - IIIT Bangalore\8th Semester\PE\code\in\sentinel_final.tif');
ptsOriginalBRISK  = detectBRISKFeatures(original,'MinContrast',0.01,'MinQuality',0.7);
ptsDistortedBRISK = detectBRISKFeatures(distorted,'MinContrast',0.01,'MinQuality',0.7);
ptsOriginalSURF  = detectSURFFeatures(original);
ptsDistortedSURF = detectSURFFeatures(distorted);
[featuresOriginalFREAK,validPtsOriginalBRISK]  = ...
        extractFeatures(original,ptsOriginalBRISK);
[featuresDistortedFREAK,validPtsDistortedBRISK] = ...
        extractFeatures(distorted,ptsDistortedBRISK);
[featuresOriginalSURF,validPtsOriginalSURF]  = ...
        extractFeatures(original,ptsOriginalSURF);
[featuresDistortedSURF,validPtsDistortedSURF] = ...
        extractFeatures(distorted,ptsDistortedSURF);
%featuresOriginalFREAK = featuresOriginalFREAK(1:10000,:);
%featuresDistortedFREAK = featuresDistortedFREAK(1:10000,:);
featuresOriginalSURF = featuresOriginalSURF(1:10000,:);
featuresDistortedSURF = featuresDistortedSURF(1:10000,:);
indexPairsBRISK = matchFeatures(featuresOriginalFREAK,...
            featuresDistortedFREAK,'MatchThreshold',10,'MaxRatio',0.8);
indexPairsSURF = matchFeatures(featuresOriginalSURF,featuresDistortedSURF);
matchedOriginalBRISK  = validPtsOriginalBRISK(indexPairsBRISK(:,1));
matchedDistortedBRISK = validPtsDistortedBRISK(indexPairsBRISK(:,2));
matchedOriginalSURF  = validPtsOriginalSURF(indexPairsSURF(:,1));
matchedDistortedSURF = validPtsDistortedSURF(indexPairsSURF(:,2));
matchedOriginalXY  = ...
    [matchedOriginalSURF.Location; matchedOriginalBRISK.Location];
matchedDistortedXY = ...
    [matchedDistortedSURF.Location; matchedDistortedBRISK.Location];
[tformTotal,inlierDistortedXY,inlierOriginalXY] = ...
    estimateGeometricTransform(matchedDistortedXY,...
        matchedOriginalXY,'similarity');
outputView = imref2d(size(original));
recovered  = imwarp(distorted,tformTotal,'OutputView',outputView);
figure;
imshowpair(original,recovered,'montage')