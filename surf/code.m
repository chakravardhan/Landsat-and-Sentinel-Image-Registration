original = imread('C:\Users\dcvr1\OneDrive - IIIT Bangalore\8th Semester\PE\code\in\landsat_final10.tif');
distorted = imread('C:\Users\dcvr1\OneDrive - IIIT Bangalore\8th Semester\PE\code\in\sentinel_final.tif');
ptsOriginal  = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);
%ptsRecovered = detectSURFFeatures(recovered);
[featuresOriginal,validPtsOriginal] = ...
extractFeatures(original,ptsOriginal);
[featuresDistorted,validPtsDistorted] = ...
extractFeatures(distorted,ptsDistorted);
%[featuresRecovered,validPtsRecovered] = ...
%extractFeatures(recovered,ptsRecovered);
featuresOriginal = featuresOriginal(1:10000,:);
featuresDistorted = featuresDistorted(1:10000,:);
%featuresRecovered = featuresRecovered(1:10000,:);
indexPairs = matchFeatures(featuresOriginal,featuresDistorted,'MatchThreshold',0.2,'Unique',true);
indexPairs_new = matchFeatures(featuresOriginal,featuresRecovered,'MatchThreshold',0.2,'Unique',true);
matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));
matchedOriginal_new  = validPtsOriginal(indexPairs_new(:,1));
matchedRecovered = validPtsRecovered(indexPairs_new(:,2));
figure
showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted)
title('Candidate matched points (including outliers)')
[tform, inlierDistorted,inlierOriginal] = ...
estimateGeometricTransform(matchedDistorted,...
matchedOriginal,'similarity');
%figure
%showMatchedFeatures(original,distorted,inlierOriginal,inlierDistorted)
%title('Matching points (inliers only)')
%legend('ptsOriginal','ptsDistorted')
outputView = imref2d(size(original));
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
matches1 = matchedOriginal.Location;
matches2 = matchedDistorted.Location;
matches1 = matchedOriginal_new.Location;
matches2 = matchedRecovered.Location;
function rmse = compute_rmse(matches1,matches2)
    diff = matches1-matches2;
    diffsq= diff.^2;
    sum_sq = diffsq(:,1)+diffsq(:,1);
    MSE = mean(sum_sq);
    rmse = sqrt(MSE);
end

