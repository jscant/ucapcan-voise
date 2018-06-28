% Generate_Conic
% Author: N. Achilleos
% Date: August 2002
% Description:
%    This is a MATLAB program which fits a set of points (coordinate
%    pairs) to the functional form of a conic section
%    (e.g. ellipse, parabola).
%
%
% Change History: June 2005 - modified the technique to use Levenberg Marquardt method
%
function [LSizeFit, eccenFit, XOffsetFit, errorLSize, errorEccen, errorXOffset] = ...
         ApplyConicFit(noPoints, xCoords, yCoords, LSizeStart, eccenStart, XOffsetStart)

% CONFIGURATION: Global variables
  TOLERANCE = 1.0E-10;
  
 
  LAMBDA_PARAM = 0.0;
  errorSq = 1.0e7;
  
% EXECUTABLE CODE

  repeatFit = 1;
  iCount = 0;
  
  % Take a first guess at the conic parameters:
  LSize = LSizeStart;
  eccen = eccenStart;
  XOffset = XOffsetStart;
  
  while(repeatFit)
     
     % Initialise variables:
     GMat = zeros(3,3);
     MVec = zeros(3,1);
      
     disp('Old Parameters :');
     disp(LSize);
     disp(eccen);
     disp(XOffset);

     % Calculate the 'L' vector which measures modulus squared of function gradient:
     for iCount = 1: noPoints
        x = xCoords(iCount);
        y = yCoords(iCount);
        LGrad(iCount) = derivX(x,y,LSize,eccen,XOffset)^2 + ...
                        derivY(x,y,LSize,eccen,XOffset)^2;                 
     end
  
     % Calculate the elements of the matrix GMat
     for iCount = 1: noPoints
        x = xCoords(iCount);
        y = yCoords(iCount);
        GMat(1,1) = GMat(1,1) + derivLSize(x,y,LSize,eccen,XOffset)*derivLSize(x,y,LSize,eccen,XOffset)...
                             / LGrad(iCount);    
        GMat(1,2) = GMat(1,2) + derivLSize(x,y,LSize,eccen,XOffset)*derivEccen(x,y,LSize,eccen,XOffset)...
                             / LGrad(iCount);    
        GMat(1,3) = GMat(1,3) + derivLSize(x,y,LSize,eccen,XOffset)*derivXOffset(x,y,LSize,eccen,XOffset)...
                             / LGrad(iCount);    
        GMat(2,2) = GMat(2,2) + derivEccen(x,y,LSize,eccen,XOffset)*derivEccen(x,y,LSize,eccen,XOffset)...
                             / LGrad(iCount);    
        GMat(2,3) = GMat(2,3) + derivEccen(x,y,LSize,eccen,XOffset)*derivXOffset(x,y,LSize,eccen,XOffset)...
                             / LGrad(iCount);    
        GMat(3,3) = GMat(3,3) + derivXOffset(x,y,LSize,eccen,XOffset)*derivXOffset(x,y,LSize,eccen,XOffset)...
                             / LGrad(iCount);    
      
     end
  
     % Fill in symmetric elements:
     GMat(2,1) = GMat(1,2);
     GMat(3,1) = GMat(1,3);
     GMat(3,2) = GMat(2,3);
  
     % Multiply diagonal elements to get LM style matrix
     for k = 1:3
        GMat(k,k) = (1.+LAMBDA_PARAM)*GMat(k,k);    
     end
     disp(['LAMBDA_PARAM: ',num2str(LAMBDA_PARAM)]);
     
     % Calculate the elements of the 'M'vector which measures function derivatives
  
     for iCount = 1:noPoints
        x = xCoords(iCount);
        y = yCoords(iCount);
        MVec(1) = MVec(1) + ConicFunction(x,y,LSize,eccen,XOffset)*derivLSize(x,y,LSize,eccen,XOffset)...
                         / LGrad(iCount);
        MVec(2) = MVec(2) + ConicFunction(x,y,LSize,eccen,XOffset)*derivEccen(x,y,LSize,eccen,XOffset)...
                         / LGrad(iCount);
        MVec(3) = MVec(3) + ConicFunction(x,y,LSize,eccen,XOffset)*derivXOffset(x,y,LSize,eccen,XOffset)...
                         / LGrad(iCount);
     
     
     end
 
     % Calculate updates to current fit parameters:
     DeltaParam = inv(GMat)*MVec;
       
     % answ = input ('Any key to continue :');
  
     % Update parameters and check convergence
     DeltaLSizeRel = abs(DeltaParam(1)/LSize);
     DeltaEccenRel = abs(DeltaParam(2)/eccen);
     %DeltaXOffsetRel = abs(DeltaParam(3)/XOffset);

     disp('Parameter Changes :');
     disp([num2str(DeltaParam(1)), ' Relative: ', num2str(DeltaLSizeRel)]);
     disp([num2str(DeltaParam(2)), ' Relative: ', num2str(DeltaEccenRel)]);
     disp(DeltaParam(3));

     disp('New Parameters :');
     disp(LSize - DeltaParam(1));
     disp(eccen - DeltaParam(2));
     disp(XOffset - DeltaParam(3));

     if (DeltaLSizeRel < TOLERANCE & DeltaEccenRel < TOLERANCE)
        disp('TOLERANCE LIMIT OK'); 
        repeatFit = 0;    
     end
     
     LSizeOld = LSize;
     eccenOld = eccen;
     XOffsetOld = XOffset;
     
     LSize = LSize - DeltaParam(1);
     eccen = eccen - DeltaParam(2);
     XOffset = XOffset - DeltaParam(3);     

     % Check error in fit:
     errorSqOld = errorSq;
     
     lambda = zeros(noPoints, 1);

     for iCount = 1:noPoints
        x = xCoords(iCount);
        y = yCoords(iCount);

        lambda(iCount) = ( ConicFunction(x,y,LSize,eccen,XOffset) ...
                          - derivLSize(x,y,LSize,eccen,XOffset)*DeltaParam(1) ...
                          - derivEccen(x,y,LSize,eccen,XOffset)*DeltaParam(2) ...
                          - derivXOffset(x,y,LSize,eccen,XOffset)*DeltaParam(3) ) ...
                         / LGrad(iCount);      
     end
  
     % Now calculate error
     errorSq = 0.0;
  
     for iCount = 1:noPoints
        x = xCoords(iCount);
        y = yCoords(iCount);
        errorSq = errorSq + lambda(iCount)*ConicFunction(x,y,LSize,eccen,XOffset);    
     end

     % 3 model parameters are used so take mean error squared:
     errorSq = abs(errorSq) / (noPoints - 3);


     if (errorSq > 1.2*errorSqOld)
        disp(['DIVERGING',num2str(errorSqOld),'--->',num2str(errorSq)]);
        % Diverging - reset, halve lambda and repeat
        LAMBDA_PARAM = 0.5*LAMBDA_PARAM;
        %errorSq = errorSqOld;
        %LSize = LSizeOld;
        %eccen = eccenOld;
        %XOffset = XOffsetOld;
        %repeatFit = 1;
        
     else
        disp('CONVERGING');
        % Converging - double lambda
        LAMBDA_PARAM = 2.0*LAMBDA_PARAM;
        
     end
     
     
     
     % Back to top of while loop
     
  end
  
     % At this point, have params of best fit. Calculate errors:
  
     % Calculate 'lambda' quantities used in error calculation
  
     lambda = zeros(noPoints, 1);
  
     for iCount = 1:noPoints
        x = xCoords(iCount);
        y = yCoords(iCount);

        lambda(iCount) = ( ConicFunction(x,y,LSize,eccen,XOffset) ...
                          - derivLSize(x,y,LSize,eccen,XOffset)*DeltaParam(1) ...
                          - derivEccen(x,y,LSize,eccen,XOffset)*DeltaParam(2) ...
                          - derivXOffset(x,y,LSize,eccen,XOffset)*DeltaParam(3) ) ...
                         / LGrad(iCount);      
     end
  
     % Now calculate error
     errorSq = 0.0;
  
     for iCount = 1:noPoints
        x = xCoords(iCount);
        y = yCoords(iCount);
        errorSq = errorSq + lambda(iCount)*ConicFunction(x,y,LSize,eccen,XOffset);    
     end

     % 3 model parameters are used so take mean error squared:
     errorSq = errorSq / (noPoints - 3);
  
     disp(['RMS SQR ERROR = ',num2str(errorSq)]);
     % Now calculate approximate error in each parameter:
     RMat = inv(GMat);
  
     errorLSize = sqrt(RMat(1,1))*sqrt(errorSq);
     errorEccen = sqrt(RMat(2,2))*sqrt(errorSq);
     errorXOffset = sqrt(RMat(3,3))*sqrt(errorSq);
     
  LSizeFit = LSize;
  eccenFit = eccen;
  XOffsetFit = XOffset;

  disp(' Final parameters :');
  disp([' LSize : ', num2str(LSizeFit), '+/-', num2str(errorLSize), ...
        ' Eccen : ', num2str(eccenFit), '+/-', num2str(errorEccen), ...
        ' XOff  : ', num2str(XOffsetFit), '+/-', num2str(errorXOffset)]);
  
return



% Some useful functions
function ConicFunctionVal = ConicFunction(xcoord, ycoord, LSize, eccen, XOffset)

ConicFunctionVal = (1.0-eccen*eccen)*(xcoord-XOffset)*(xcoord-XOffset) + ...
                   2.0*eccen*LSize*(xcoord-XOffset) + ycoord*ycoord - LSize*LSize;

return





function derivVar = derivBase(xcoord, ycoord, LSize, eccen, XOffset)
% Computes a useful fundamental quantity used in derivative
% calculations

% EXECUTABLE CODE
   derivVar = ((1.0-eccen*eccen)*(xcoord-XOffset) + eccen*LSize);

return



function derivXVal = derivX(xcoord, ycoord, LSize, eccen, XOffset)

% EXECUTABLE CODE
   derivXVal = 2.0*(1.0-eccen*eccen)*(xcoord-XOffset) + 2.0*eccen*LSize;

return

function derivYVal = derivY(xcoord, ycoord, LSize, eccen, XOffset)

% EXECUTABLE CODE
   derivYVal = 2.0*ycoord;

return




function derivXOffsetVal = derivXOffset(xcoord, ycoord, LSize, eccen, XOffset)

% EXECUTABLE CODE
   derivXOffsetVal = -2.0*(1.0-eccen*eccen)*(xcoord-XOffset) - 2.0*eccen*LSize;

return

function derivLSizeVal = derivLSize(xcoord, ycoord, LSize, eccen, XOffset)

% EXECUTABLE CODE
   derivLSizeVal = 2.0*eccen*(xcoord-XOffset) - 2.0*LSize;

return



function derivEccenVal = derivEccen(xcoord, ycoord, LSize, eccen, XOffset)

% EXECUTABLE CODE
   derivEccenVal = -2.0*eccen*(xcoord-XOffset)*(xcoord-XOffset) + 2.0*LSize*(xcoord-XOffset);

return


% END OF Generate_Conic.m