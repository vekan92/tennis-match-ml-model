function [] = makeMultipleBeeps()

numBeeps = 3;
pauseBetweenBeeps = 1;

% Define frequency and duration for the custom beep sound
% frequency = 1500; % Frequency in Hz
% duration = 0.5; % Duration in seconds
% 
% % Generate a sinusoidal waveform for the custom beep sound
% t = 0:1/44100:duration; % Sampling at 44.1 kHz
% waveform = sin(2*pi*frequency*t);
% sound(waveform, 44100); % 44100 is the sampling rate (samples per second)
% pause(pauseBetweenBeeps);

for i=1:1:numBeeps
    % Play the custom beep sound
% Define musical notes and their frequencies (in Hz)
notes = [261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88]; % C4, D4, E4, F4, G4, A4, B4
duration = 0.5; % Duration of each note in seconds

% Generate beeps for each note in the sequence
for j = 1:length(notes)
    % Generate sinusoidal waveform for the current note
    t = 0:1/44100:duration; % Sampling at 44.1 kHz
    waveform = sin(2*pi*notes(j)*t);

    % Play the note
    sound(waveform, 44100);
    
    % Pause briefly between notes for musical separation
    pause(0.1); % You can adjust this pause duration for the desired musical feel
end
pause(pauseBetweenBeeps);

end
end