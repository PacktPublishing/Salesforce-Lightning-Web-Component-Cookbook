public with sharing class DisplayAssetsService {

    public AssetSelector selector = new AssetSelector();

    public List<Asset> getAssetsByAccount(Id accountId, Integer lim, Integer offset){
        return selector.retrieveAssetsByAccount(accountId, lim, offset);
    }

    public Integer getAssetCount(Id accountId) {
        return selector.countAssets(accountId);
    }
}