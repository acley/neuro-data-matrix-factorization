function [conditions,movIDs] = sqr_logextract(fileName)
% Eisenbahn
% extraction of time points from presentation logfile
%
% including automatic normalization to first pulse and extraction of button
% press onsets 
%
% written by Michael Gaebler, 04/2012, Charite Berlin
% updated 09/2012 - baseline (first fixation) included in fixation cond
% updated 11/2013 - adapted for SEQUREA
%
% Example:
% [conditions,movIDs] = sqr_logextract(fileName)
% condition:
% first col is movie id, 
% second col is color condition (1 yes, 0 no)
% third col is depth condition (1 yes, 0 no)


if nargin<1
    [fileName,pathName] = uigetfile('*.*','Select the log file'); 
    fileName = fullfile(pathName,fileName);
end

movIDs = {'Cherryblossom','Deepsea','Rallyekorea','testPeakRamp1','testPeakRamp2','testPeakRamp3'};


[type,code,time] = textread(fileName,'%*s%s%s%n%*[^\n]','delimiter','\t','headerlines', 5);

pulse_indices = find(~cellfun('isempty',strfind(type,'Pulse')));

conditions = zeros(length(pulse_indices),3);
% for each scanner trigger
for ip = 1:length(pulse_indices)-1
    tmpcode = regexprep(regexprep(code{pulse_indices(ip)+1},'_BW',''),'_[l|r].avi','');
    movidx = find(~cellfun('isempty',strfind(movIDs,tmpcode)));
    if ~isempty(movidx)
       conditions(ip,1) = movidx;
       conditions(ip,2) = isempty(strfind(code{pulse_indices(ip)+1},'_BW_'));
       if movidx>3,
           conditions(ip,2)=0;
       end
       conditions(ip,3) = ~strcmp(code{pulse_indices(ip)+1}, code{pulse_indices(ip)+2});
    end
end

