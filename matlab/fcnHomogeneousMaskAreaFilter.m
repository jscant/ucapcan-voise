function outputImage = fcnHomogeneousMaskAreaFilter(inputImage)

% fcnHomogeneousMaskAreaFilter performs noise filtering on an image based
%   on searching for the most homogeneous mask within a search area around
%   a pixel of interest.
%
%   OUTPUTIMAGE = fcnHomogeneousMaskAreaFilter(INPUTIMAGE) performs
%   filtering of an image using the homogeneous mask area filter around 
%   each pixel. It uses a square neighborhood of 5x5 pixels with 3x3 masks
%   to estimate the gray-level homogeneity in each of the masks. The
%   central pixel is replaced with the central estimate of the most
%   homogeneous 3x3 mask found within the 5x5 search area around the pixel.
%   Supported data type for INPUTIMAGE are uint8, uint16, uint32, uint64,
%   int8, int16, int32, int64, single, double. OUTPUTIMAGE has the same
%   image type as INPUTIMAGE.
% 
%   Details of the method are avilable in
% 
%   M. Nagao and T. Matsuyama, "Edge preserving smoothing," Computer
%   Graphics and Image Processing, vol. 9, no. 4, pp. 394–407, 1979. 
%   [http://dx.doi.org/10.1016/0146-664X(79)90102-3]
%
%   This implementation is based on information available in
%
%   D. Sheet, S. Pal, A. Chakraborty, J. Chatterjee, A.K. Ray, 
%   "Image quality assessment for performance evaluation of despeckle 
%   filters in Optical Coherence Tomography of human skin," 
%   2010 IEEE EMBS Conf. Biomedical Engineering and Sciences (IECBES), 
%   pp.499-504, Nov. 30 2010 - Dec. 2 2010.
%   [http://dx.doi.org/10.1109/IECBES.2010.5742289] 
%
%   D. Sheet, S. Pal, A. Chakraborty, J. Chatterjee, A.K. Ray,
%   "Visual importance pooling for image quality assessment of despeckle 
%   filters in Optical Coherence Tomography," 2010 Intl. Conf. Systems in 
%   Medicine and Biology (ICSMB), pp.102-107, 16-18 Dec. 2010.
%   [http://dx.doi.org/10.1109/ICSMB.2010.5735353] 
%
%   2010 (c) Debdoot Sheet, Indian Institute of Technology Kharagpur, India
%       Ver 1.0     20 October 2010
%       Ver 2.0     13 October 2011
%           Rev 1.0 15 December 2011
%
% Example
% -------
% inputImage = imnoise(imread('cameraman.tif'),'speckle',0.01);
% outputImage = fcnHomogeneousMaskAreaFilter(inputImage);
% figure, subplot 121, imshow(inputImage), subplot 122,
% imshow(outputImage);
%

% 2010 (c) Debdoot Sheet, Indian Institute of Technology Kharagpur, India
% All rights reserved.
% 
% Permission is hereby granted, without written agreement and without 
% license or royalty fees, to use, copy, modify, and distribute this code 
% (the source files) and its documentation for any purpose, provided that 
% the copyright notice in its entirety appear in all copies of this code, 
% and the original source of this code. Further Indian Institute of 
% Technology Kharagpur (IIT Kharagpur / IITKGP)  is acknowledged in any
% publication that reports research or any usage using this code. The 
% implementation of the work is to be cited using the bibliography as
% 
%   D. Sheet, S. Pal, A. Chakraborty, J. Chatterjee, A.K. Ray, 
%   "Image quality assessment for performance evaluation of despeckle 
%   filters in Optical Coherence Tomography of human skin," 
%   2010 IEEE EMBS Conf. Biomedical Engineering and Sciences (IECBES), 
%   pp.499-504, Nov. 30 2010 - Dec. 2 2010
%   [http://dx.doi.org/10.1109/IECBES.2010.5742289] 
%
%   D. Sheet, S. Pal, A. Chakraborty, J. Chatterjee, A.K. Ray,
%   "Visual importance pooling for image quality assessment of despeckle 
%   filters in Optical Coherence Tomography," 2010 Intl. Conf. Systems in 
%   Medicine and Biology (ICSMB), pp.102-107, 16-18 Dec. 2010
%   [http://dx.doi.org/10.1109/ICSMB.2010.5735353]
% 
% In no circumstantial cases or events the Indian Institute of Technology
% Kharagpur or the author(s) of this particular disclosure be liable to any
% party for direct, indirectm special, incidental, or consequential 
% damages if any arising out of due usage. Indian Institute of Technology 
% Kharagpur and the author(s) disclaim any warranty, including but not 
% limited to the implied warranties of merchantability and fitness for a 
% particular purpose. The disclosure is provided hereunder "as in" 
% voluntarily for community development and the contributing parties have 
% no obligation to provide maintenance, support, updates, enhancements, 
% or modification.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input argument support check

iptcheckinput(inputImage,{'uint8','uint16','uint32','uint64','int8','int16','int32','int64','single','double'}, {'nonsparse','2d'}, mfilename,'I',1);

if nargin ~= 1
    error('Unsupported calling of fcnFirstOrderStatisticsFilter');
end

imageType = class(inputImage);

inputImage = padarray(inputImage,[2 2],'symmetric','both');

outputImage = inputImage;

inputImage=double(inputImage);

[nRows,nCols] = size(inputImage);

localMean = zeros([1 9]);
localVar  = zeros([1 9]);

localMean,localVar, pause
for i=3:nRows-2
    for j=3:nCols-2
        localWindow = inputImage(i-2:i+2,j-2:j+2);
				size(localWindow)
        for p=2:3
            for q=2:3
                subWindow = localWindow(p-1:p+1,q-1:q+1);
                localMean = mean(subWindow);
                localVar  = var(subWindow);
            end
        end
localMean,localVar, pause
        C_k = localVar./(localMean+eps);
        [~,index] = min(C_k);
        outputImage(i,j) = (localMean(index));
    end
end

outputImage = outputImage(3:end-2,3:end-2);

outputImage = cast(outputImage,imageType);               
