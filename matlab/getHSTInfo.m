function params = getHSTInfo(params)
% function params = getHSTInfo(params)

%
% $Id: getHSTInfo.m,v 1.7 2018/05/29 10:46:40 patrick Exp $
%
% Copyright (c) 2012 Patrick Guio <patrick.guio@gmail.com>
% All Rights Reserved.
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 3 of the License, or (at your
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

iFile = params.iFile;

verbose = 1;

% detect whether data is from HST
TELESCOP = getFitsKeywordsValue(iFile,{'TELESCOP'},verbose);

if ~isempty(TELESCOP) && strcmp(TELESCOP,'HST'),
  % instrument identifier
  HST.INSTRUME = getFitsKeywordsValue(iFile,{'INSTRUME'},verbose);
	% proposer's target name
  HST.TARGNAME = getFitsKeywordsValue(iFile,{'TARGNAME'},verbose);
	% right ascension and declination of the target (deg) (J2000)
  [HST.RA_TARG,HST.DEC_TARG] = getFitsKeywordsValue(iFile,...
	                             {'RA_TARG','DEC_TARG'},verbose);
	% UT date and time of start of first exposure
  [HST.TDATEOBS,HST.TTIMEOBS] = getFitsKeywordsValue(iFile,...
	                              {'TDATEOBS','TTIMEOBS'},verbose);
	% exposure duration (seconds)
  HST.EXPTIME  = getFitsKeywordsValue(iFile,{'EXPTIME'},verbose);
	% total exposure time (seconds)
	HST.TEXPTIME = getFitsKeywordsValue(iFile,{'TEXPTIME'},verbose);
  if isempty(HST.TDATEOBS) & isempty(HST.TTIMEOBS),
    [HST.TDATEOBS,HST.TTIMEOBS] = getFitsKeywordsValue(iFile,...
		                              {'DATE-OBS','TIME-OBS'},verbose);
  end
	% start/end time (Modified Julian Time) of 1st/last exposure 
  %getFitsKeywordsValue(iFile,{'TEXPSTRT','TEXPEND'});
	% aperture field of view
  HST.APER_FOV = getFitsKeywordsValue(iFile,{'APER_FOV'},verbose);
	% plate scale (arcsec/pixel)
  if strcmp(HST.INSTRUME,'ACS'),
    HST.PLATESC = 0.025;
  else
    HST.PLATESC = getFitsKeywordsValue(iFile,{'PLATESC'},verbose);
  end
	% subarray axes center pt in unbinned dectector pixels
  %getFitsKeywordsValue(iFile,{'CENTERA1','CENTERA2'});
	% subarray axes size in unbinned detector pixels
	%getFitsKeywordsValue(iFile,{'SIZAXIS1','SIZAXIS2'});
	% coordinate values at reference point
  [HST.CRVAL1,HST.CRVAL2] = getFitsKeywordsValue(iFile,{'CRVAL1','CRVAL2'},...
	                          verbose);
	% pixel coordinates of the reference pixel
  [HST.CRPIX1,HST.CRPIX2] = getFitsKeywordsValue(iFile,{'CRPIX1','CRPIX2'},...
	                          verbose);
	% axis type
  [HST.CTYPE1,HST.CTYPE2] = getFitsKeywordsValue(iFile,{'CTYPE1','CTYPE2'},...
	                          verbose);
	% linear transform matrix with scale 
  % from pixel coordinate to intermediate world coordinate
	[HST.CD1_1,HST.CD1_2] = getFitsKeywordsValue(iFile,{'CD1_1','CD1_2'},verbose);
	[HST.CD2_1,HST.CD2_2] = getFitsKeywordsValue(iFile,{'CD2_1','CD2_2'},verbose);
  % inverse linear transform matrix with scale
  % from intermediate world coordinate to pixel coordinate
  invCD = inv([HST.CD1_1,HST.CD1_2;HST.CD2_1,HST.CD2_2]);
  HST.iCD1_1 = invCD(1,1);
  HST.iCD1_2 = invCD(1,2);
  HST.iCD2_1 = invCD(2,1);
  HST.iCD2_2 = invCD(2,2);

	% ra and dec of aperture reference position
  [HST.RA_APER,HST.DEC_APER] = getFitsKeywordsValue(iFile,...
	                             {'RA_APER','DEC_APER'},verbose);
	% offset in X/Y to subsection start 
  %getFitsKeywordsValue(iFile,{'LTV1','LTV2'};
	% reciprocal of sampling rate in X/Y
	%getFitsKeywordsValue(iFile,{'LTM1_1','LTM2_2'};
	% Position Angle of reference aperture center (deg)
	%getFitsKeywordsValue(iFile,{'PA_APER'});
	% position angle of image y axis (deg. e of n)
  HST.ORIENTAT = getFitsKeywordsValue(iFile,{'ORIENTAT'},verbose);
	% angle between sun and V1 axis (optical axis)
  HST.SUNANGLE = getFitsKeywordsValue(iFile,{'SUNANGLE'},verbose);

	fprintf(1,'CRPIX1 , CRPIX2   = %12.6f, %12.6f pixel\n',HST.CRPIX1,HST.CRPIX2);
	fprintf(1,'CRVAL1 , CRVAL2   = %12.6f, %12.6f deg\n',HST.CRVAL1,HST.CRVAL2);
	fprintf(1,'RA_TARG, DEC_TARG = %12.6f, %12.6f deg\n',HST.RA_TARG,HST.DEC_TARG);
	fprintf(1,'RA_APER, DEC_APER = %12.6f, %12.6f deg\n',HST.RA_APER,HST.DEC_APER);

	fprintf(1,'ORIENTAT          = %12.6f deg\n',HST.ORIENTAT);
	% find scaling and rotation
	CD = [HST.CD1_1,HST.CD1_2;HST.CD2_1,HST.CD2_2];
	% scaling
	s = [norm(CD(1,:));norm(CD(2,:))];
	% linear tranformation
	m = [CD(1,:)/s(1);CD(2,:)/s(2)];
	% rotation angle
	orientat = atan2(m(2,1), m(2,2))*180/pi;
	fprintf(1,'orientat CD(2,:)  = %12.6f deg\n', orientat);

	% embed scaling and rotation stuff into HST 
	HST.CD = CD;
	HST.s = s;
	HST.m = m;
	HST.orientat = orientat;

	% inverse linear transform matrix with scale
	HST.iCD = [HST.iCD1_1,HST.iCD1_2;HST.iCD2_1,HST.iCD2_2];

  % Embed HST into params
	params.HST = HST;

end

