public with sharing class DisplayAssetsService {
    public List<Asset> getAssetsByAccount(Id accountId, Integer lim, Integer offset){
        return new AssetSelector().assetsByAccount(accountId, lim, offset);
    }

    public Integer getAssetCount(Id accountId) {
        return new AssetSelector().countAssets(accountId);
    }
}