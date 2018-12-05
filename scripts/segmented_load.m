READSIZE = 1000000;
READ = true;

% - Read and standardize data
if (READ)
    ds1  = datastore('../data/data1.csv','TreatAsMissing','NA');
    ds2  = datastore('../data/data1.csv','TreatAsMissing','NA');

    ds1.SelectedVariableNames = {
        'PERMNO','date','TICKER','COMNAM','PRC','VOL'};
    ds2.SelectedVariableNames = { 'RET' };
    ds2.SelectedFormats = {'%q'};

    ds1.ReadSize = READSIZE;
    ds2.ReadSize = READSIZE;

    assets = read(ds1);
    returns = read(ds2);

    % Convert return to numeric
    returns.RET(strcmp(returns.RET,'C')) = {'NaN'};
    returns.RET = str2double(returns.RET);
    assets.RET = returns.RET;

    % Remove rows with no ticker symbol
    assets(strcmp(assets.TICKER,''),:) = [];
end
disp('done loading');

% Segment by ticker
segs = {};
comps = unique(assets.TICKER);
for (i = 1:length(comps))
   tickercol = table2array(assets(:,3));
   segs{i} = assets(strcmp(tickercol, comps(i)), :);
end
segs = segs.';
disp('done segmenting')

save 'vars/assets.mat' assets;
save 'vars/segs.mat' segs;
save 'vars/comps.mat' comps;
