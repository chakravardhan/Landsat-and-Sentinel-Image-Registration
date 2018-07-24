run('vlfeat-0.9.21/toolbox/vl_setup')
original = imread('C:\Users\dcvr1\OneDrive - IIIT Bangalore\8th Semester\PE\code\in\landsat_final10.tif');
distorted = imread('C:\Users\dcvr1\OneDrive - IIIT Bangalore\8th Semester\PE\code\in\sentinel_final.tif');
original = single(original);
distorted = single(distorted);
[ptsOriginal,featuresOriginal] = vl_sift(original);
featuresOriginal=featuresOriginal';
[ptsDistorted,featuresDistorted] = vl_sift(distorted);
featuresDistorted=featuresDistorted';
[ptsRecovered_c_l,featuresRecovered_c_l] = vl_sift(recovered_c_l);
featuresRecovered_c_l=featuresRecovered_c_l';
[ptsRecovered_c_n,featuresRecovered_c_n] = vl_sift(recovered_c_n);
featuresRecovered_c_n=featuresRecovered_c_n';
[ptsRecovered_c_c,featuresRecovered_c_c] = vl_sift(recovered_c_c);
featuresRecovered_c_c=featuresRecovered_c_c';
[ptsRecovered_a_l,featuresRecovered_a_l] = vl_sift(recovered_a_l);
featuresRecovered_a_l=featuresRecovered_a_l';
[ptsRecovered_a_n,featuresRecovered_a_n] = vl_sift(recovered_a_n);
featuresRecovered_a_n=featuresRecovered_a_n';
[ptsRecovered_a_c,featuresRecovered_a_c] = vl_sift(recovered_a_c);
featuresRecovered_a_c=featuresRecovered_a_c';
[ptsRecovered_p_l,featuresRecovered_p_l] = vl_sift(recovered_p_l);
featuresRecovered_p_l=featuresRecovered_p_l';
[ptsRecovered_p_n,featuresRecovered_p_n] = vl_sift(recovered_p_n);
featuresRecovered_p_n=featuresRecovered_p_n';
[ptsRecovered_p_c,featuresRecovered_p_c] = vl_sift(recovered_p_c);
featuresRecovered_p_c=featuresRecovered_p_c';
featuresOriginal_new = featuresOriginal(1:20000,:);
featuresDistorted_new = featuresDistorted(1:20000,:);
featuresRecovered_new = featuresRecovered_c_l(1:20000,:);
indexPairs = matchFeatures(featuresOriginal_new,featuresDistorted_new);
indexPairs_new = matchFeatures(featuresOriginal_new,featuresRecovered_new);
matchedOriginal=[];
matchedDistorted=[];
matchedOriginal_new=[];
matchedRecovered=[];
for i = 1:size(indexPairs,1)
a=[ptsOriginal(1,indexPairs(i,1)),ptsOriginal(2,indexPairs(i,1))];
matchedOriginal=[matchedOriginal;a];
end
for i = 1:size(indexPairs,1)
a=[ptsDistorted(1,indexPairs(i,2)),ptsDistorted(2,indexPairs(i,2))];
matchedDistorted=[matchedDistorted;a];
end

for i = 1:size(indexPairs_new,1)
a=[ptsOriginal(1,indexPairs_new(i,1)),ptsOriginal(2,indexPairs_new(i,1))];
matchedOriginal_new=[matchedOriginal_new;a];
end
for i = 1:size(indexPairs_new,1)
a=[ptsRecovered_c_l(1,indexPairs_new(i,2)),ptsRecovered_c_l(2,indexPairs_new(i,2))];
matchedRecovered=[matchedRecovered;a];
end
%figure
%showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted)
%title('Candidate matched points (including outliers)')
[tform, inlierDistorted,inlierOriginal] = ...
estimateGeometricTransform(matchedDistorted,...
matchedOriginal,'similarity');
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
matches1 = matchedOriginal;
matches2 = matchedDistorted;
matches1 = matchedOriginal_new;
matches2 = matchedRecovered;
function rmse = compute_rmse(matches1,matches2)
    diff = matches1-matches2;
    diffsq= diff.^2;
    sum_sq = diffsq(1,:)+diffsq(2,:);
    MSE = mean(sum_sq);
    rmse = sqrt(MSE);
end

