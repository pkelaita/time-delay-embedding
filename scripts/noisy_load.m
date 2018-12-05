READSIZE = 1000000;

% - Open file.
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
returns.RET(strcmp(returns.RET,'C')) = {'0.0'};
returns.RET = str2double(returns.RET);
assets.RET = returns.RET;   

% Data cleaning: PRC, VOL, RET
assets.PRC(isnan(assets.PRC)) = 0.0;
assets.VOL(isnan(assets.VOL)) = 0.0;
assets.RET(isnan(assets.RET)) = 0.0;

save 'vars/noisy_assets.mat' assets;