function V_territory=GetTerritoryVol(V_tissue,skelIdx)
% This function gets volumn of tissue terriotory along vessel linepath

dim=size(V_tissue);
V_territory=zeros(dim);
V_territory(~(V_tissue-skelIdx))=1;
V_territory=logical(V_territory);