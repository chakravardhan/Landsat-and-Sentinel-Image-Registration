original = imread('C:\Users\dcvr1\OneDrive - IIIT Bangalore\8th Semester\PE\code\in\landsat_final10.tif');
distorted = imread('C:\Users\dcvr1\OneDrive - IIIT Bangalore\8th Semester\PE\code\in\sentinel_final.tif');
ptsOriginalBRISK  = detectBRISKFeatures(original,'MinContrast',0.01,'MinQuality',0.7);
ptsDistortedBRISK = detectBRISKFeatures(distorted,'MinContrast',0.01,'MinQuality',0.7);
ptsRecoveredBRISK = detectBRISKFeatures(recovered,'MinContrast',0.01,'MinQuality',0.7);
[featuresOriginalFREAK,validPtsOriginalBRISK]  = ...
        extractFeatures(original,ptsOriginalBRISK);
[featuresDistortedFREAK,validPtsDistortedBRISK] = ...
        extractFeatures(distorted,ptsDistortedBRISK);
[featuresRecoveredFREAK,validPtsRecoveredBRISK] = ...
        extractFeatures(recovered,ptsRecoveredBRISK);
indexPairsBRISK = matchFeatures(featuresOriginalFREAK,...
            featuresDistortedFREAK,'MatchThreshold',10,'MaxRatio',0.8);
indexPairsBRISK_new = matchFeatures(featuresOriginalFREAK,...
            featuresRecoveredFREAK,'MatchThreshold',10,'MaxRatio',0.8);        
matchedOriginalBRISK  = validPtsOriginalBRISK(indexPairsBRISK(:,1));
matchedDistortedBRISK = validPtsDistortedBRISK(indexPairsBRISK(:,2));
matchedOriginalBRISK_new  = validPtsOriginalBRISK(indexPairsBRISK_new(:,1));
matchedRecoveredBRISK = validPtsRecoveredBRISK(indexPairsBRISK_new(:,2));
%figure
%showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted)
%title('Candidate matched points (including outliers)')
[tform, inlierDistorted,inlierOriginal] = ...
estimateGeometricTransform(matchedDistortedBRISK,...
matchedOriginalBRISK,'similarity');
%figure
%showMatchedFeatures(original,distorted,inlierOriginal,inlierDistorted)
%title('Matching points (inliers only)')
%legend('ptsOriginal','ptsDistorted')
outputView = imref2d(size(original));
recovered  = imwarp(distorted,tform,'OutputView',outputView);
recovered_c_l  = imwarp(distorted,tform,'OutputView',outputView);
recovered_c_n  = imwarp(distorted,tform,'nearest','OutputView',outputView);
recovered_c_c  = imwarp(distorted,tform,'cubic','OutputView',outputView);
recovered_a_l  = imwarp(distorted,tform_affine,'OutputView',outputView);
recovered_a_n  = imwarp(distorted,tform_affine,'nearest','OutputView',outputView);
recovered_a_c  = imwarp(distorted,tform_affine,'cubic','OutputView',outputView);
recovered_p_l  = imwarp(distorted,tform_projective,'OutputView',outputView);
recovered_p_n  = imwarp(distorted,tform_projective,'nearest','OutputView',outputView);
recovered_p_c  = imwarp(distorted,tform_projective,'cubic','OutputView',outputView);

%figure
%imshowpair(original,recovered,'montage')
%dlmwrite('sentinel_band3.txt',recovered,' ');
matches1 = matchedOriginalBRISK.Location;
matches2 = matchedDistortedBRISK.Location;
matches1 = matchedOriginalBRISK_new.Location;
matches2 = matchedRecoveredBRISK.Location;
function rmse = compute_rmse(matches1,matches2)
    diff = matches1-matches2;
    diffsq= diff.^2;
    sum_sq =  diffsq(:,1)+diffsq(:,2);
    MSE = mean(sum_sq);
    rmse = sqrt(MSE);
end

