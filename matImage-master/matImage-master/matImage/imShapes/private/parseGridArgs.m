function [lx ly varargin] = parseGridArgs(varargin)
%PARSEGRIDARGS  Extract or compute position vectors for meshgrid
%
%   [LX LY] = parseGridArgs(LX, LY)
%   simply returns LX and LY.
%
%   [LX LY] = parseGridArgs([NX NY])
%   assumes LX = 1:NX and LY = 1:NY
%
%   [LX LY] = parseGridArgs([NX NY])
%   assumes LX = 1:NX and LY = 1:NY
%
%
%   Example
%   [lx ly] = parseGridArgs([100 100]);
%   [lx ly] = parseGridArgs(1:2:50, 1:4:100);
%   [lx ly varargin] = parseGridArgs(varargin{:});
%   for usage within another function.
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-05-29,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.
% Licensed under the terms of the LGPL, see the file "license.txt"


% If empty arguments, return default values
if isempty(varargin)
    lx = 1:100;
    ly = 1:100;
    return
end

var = varargin{1};

% case of a 2x3 matrix with starting position, increment, end position for
% each coordinate
if size(var, 1)>1 && size(var, 2)>2
    lx = var(1,1):var(1,2):var(1,3);
    ly = var(2,1):var(2,2):var(2,3);
    varargin(1) = [];
    return;
end

% first argument contains maximal position for each coordinate
if size(var, 1)==1 && size(var, 2)==2
    lx = 1:var(1);
    ly = 1:var(2);
    varargin(1) = [];
    return;
end

% first and second arguments contain vector for each coordinate
% respectively
if length(varargin)>1
    lx = varargin{1};
    ly = varargin{2};
    varargin(1:2) = [];
    return
end

% otherwise, throws error
error('Error in parsing grid arguments');
