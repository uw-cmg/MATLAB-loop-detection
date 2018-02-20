function imb = invert(im)
% invert the image intensity values. Making black to white, white to black
% inputs:
% im: original image
% outputs:
% imb: inverted image

imb = max(im(:)) - im;