original = imread('C:\Users\dcvr1\OneDrive - IIIT Bangalore\8th Semester\PE\code\in\landsat_final10.tif');
distorted = imread('C:\Users\dcvr1\OneDrive - IIIT Bangalore\8th Semester\PE\code\in\sentinel_final.tif');
ptsOriginalBRISK  = detectBRISKFeatures(original,'MinContrast',0.01,'MinQuality',0.7);
ptsDistortedBRISK = detectBRISKFeatures(distorted,'MinContrast',0.01,'MinQuality',0.7);
ptsRecoveredBRISK = detectBRISKFeatures(recovered,'MinContrast',0.01,'MinQuality',0.7);
ptsOriginalSURF  = detectSURFFeatures(original);
ptsDistortedSURF = detectSURFFeatures(distorted);
ptsRecoveredSURF = detectSURFFeatures(recovered);
[featuresOriginalFREAK,validPtsOriginalBRISK]  = ...
        extractFeatures(original,ptsOriginalBRISK);
[featuresDistortedFREAK,validPtsDistortedBRISK] = ...
        extractFeatures(distorted,ptsDistortedBRISK);
[featuresRecoveredFREAK,validPtsRecoveredBRISK] = ...
        extractFeatures(recovered,ptsRecoveredBRISK);    
[featuresOriginalSURF,validPtsOriginalSURF]  = ...
        extractFeatures(original,ptsOriginalSURF);
[featuresDistortedSURF,validPtsDistortedSURF] = ...
        extractFeatures(distorted,ptsDistortedSURF);
[featuresRecoveredSURF,validPtsRecoveredSURF] = ...
        extractFeatures(recovered,ptsRecoveredSURF);    
featuresOriginalSURF = featuresOriginalSURF(1:10000,:);
featuresDistortedSURF = featuresDistortedSURF(1:10000,:);
featuresRecoveredSURF = featuresRecoveredSURF(1:10000,:);
indexPairsBRISK = matchFeatures(featuresOriginalFREAK,...
            featuresDistortedFREAK,'MatchThreshold',10,'MaxRatio',0.8);
indexPairsBRISK_new = matchFeatures(featuresOriginalFREAK,...
            featuresRecoveredFREAK,'MatchThreshold',5,'MaxRatio',0.8);
indexPairsSURF = matchFeatures(featuresOriginalSURF,featuresDistortedSURF,'MatchThreshold',0.2);
indexPairsSURF_new = matchFeatures(featuresOriginalSURF,featuresRecoveredSURF,'MatchThreshold',0.09);
matchedOriginalBRISK  = validPtsOriginalBRISK(indexPairsBRISK(:,1));
matchedDistortedBRISK = validPtsDistortedBRISK(indexPairsBRISK(:,2));
matchedOriginalBRISK_new  = validPtsOriginalBRISK(indexPairsBRISK_new(:,1));
matchedRecoveredBRISK = validPtsRecoveredBRISK(indexPairsBRISK_new(:,2));
matchedOriginalSURF  = validPtsOriginalSURF(indexPairsSURF(:,1));
matchedDistortedSURF = validPtsDistortedSURF(indexPairsSURF(:,2));
matchedOriginalSURF_new  = validPtsOriginalSURF(indexPairsSURF_new(:,1));
matchedRecoveredSURF = validPtsRecoveredSURF(indexPairsSURF_new(:,2));
matchedOriginalXY  = ...
    [matchedOriginalSURF.Location; matchedOriginalBRISK.Location];
matchedDistortedXY = ...
    [matchedDistortedSURF.Location; matchedDistortedBRISK.Location];
matchedOriginalXY_new  = ...
    [matchedOriginalSURF_new.Location; matchedOriginalBRISK_new.Location];
matchedRecoveredXY = ...
    [matchedRecoveredSURF.Location; matchedRecoveredBRISK.Location];
[tformTotal,inlierDistortedXY,inlierOriginalXY] = ...
    estimateGeometricTransform(matchedDistortedXY,...
        matchedOriginalXY,'similarity');
outputView = imref2d(size(original));
recovered  = imwarp(distorted,tformTotal,'OutputView',outputView);
recovered_c_l  = imwarp(distorted,tformTotal,'OutputView',outputView);
recovered_c_n  = imwarp(distorted,tformTotal,'nearest','OutputView',outputView);
recovered_c_c  = imwarp(distorted,tform,'cubic','OutputView',outputView);
recovered_a_l  = imwarp(distorted,tform_affine,'OutputView',outputView);
recovered_a_n  = imwarp(distorted,tform_affine,'nearest','OutputView',outputView);
recovered_a_c  = imwarp(distorted,tform_affine,'cubic','OutputView',outputView);
recovered_p_l  = imwarp(distorted,tform_projective,'OutputView',outputView);
recovered_p_n  = imwarp(distorted,tform_projective,'nearest','OutputView',outputView);
recovered_p_c  = imwarp(distorted,tform_projective,'cubic','OutputView',outputView);
figure;
imshowpair(original,recovered,'montage')
matches1 = matchedOriginalXY;
matches2 = matchedDistortedXY;
matches1 = matchedOriginalXY_new;
matches2 = matchedRecoveredXY;
 diff = matches1-matches2;
    diffsq= diff.^2;
    sum_sq =  diffsq(:,1)+diffsq(:,2);
    MSE = mean(sum_sq);
    rmse = sqrt(MSE);