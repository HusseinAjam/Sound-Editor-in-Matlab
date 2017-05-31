function [ hms ] = sec2hms( t )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%REFERENCE 1 BEGIN 
% from StackOverflow web site
%REFERENCE 1 END


 
    hours = floor(t / 3600); % I am doing this but wavrear dose not support very long files,
                             % Any way just to show you that I can do it.
    t = t - hours * 3600;
    mins = floor(t / 60);
    secs = floor(t - mins * 60);
    hms = sprintf('%02d:%02d', mins, secs);



end

