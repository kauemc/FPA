% Add dependencies.
addpath('..');
addpath(genpath('../common'));

% Fiber-photometry data recorded with Doric DAQ.
inputDataFile = '../data/Doric.csv';
signalColumn = 5;
data = loadData(inputDataFile);
time = data(:, 1);
signal = data(:, signalColumn);
reference = []; % There is no reference channel.

configuration = struct();
configuration.conditionEpochs = {'Data', [2 * 60, 4 * 60]};
configuration.baselineEpochs = [2 * 60, 4 * 60];

% Call FPA with given configuration.
results = FPA(time, signal, reference, configuration);
cellfun(@warning, results.warnings);

% Save dff for statistical analysis.
[folder, basename] = fileparts(inputDataFile);
output = fullfile(folder, sprintf('%s dff.csv', basename));
fid = fopen(output, 'w');
fprintf(fid, 'Time (s), df/f, epoch\n');
fprintf(fid, '%.4f, %.4f, %d\n', [results.time(results.epochIds), results.dff(results.epochIds), results.epochGroups]');
fclose(fid);