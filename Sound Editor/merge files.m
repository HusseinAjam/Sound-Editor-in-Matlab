[snd1, fs] = audioread('bensound-dubstep.mp3');
leftChan=snd1(:,1); % store the left channel of the first audio

[snd2, fs] = audioread('road.wav');
rightChan=snd2(:,2);  % store the right channel of the second audio

LenghtOfFirstFile = length(leftChan)   % calculate the duration size of audio 
LenghtOfSecondFile = length(rightChan)   % calculate the duration size of audio 

if any(LenghtOfFirstFile > LenghtOfSecondFile)           % check which audio is the smaller so we merge the entire small audio and some of the longest audio
    MixSnd = leftChan(1:LenghtOfSecondFile) + rightChan; % Cut the same size of audio2(the smaller) from audio 1(the longer) and merje it with the entire audio2 (the smaller)
else
     MixSnd = leftChan + rightChan(1:LenghtOfFirstFile); % same process but in this time audio2 is the longer
end

% now 'MixSnd' is the new combined file, has two chanels, each channals from
% two independant audio files 
 sound (MixSnd,fs) % you can use MixSnd inside audioplayer and treat it as a new file
                   % note that we don't care from about using 'fs' from which
                   % sound file because it is in most cases = 44100.
                   
audiowrite('theNeFileName.wav',MixSnd,fs) % save the new file to the disk