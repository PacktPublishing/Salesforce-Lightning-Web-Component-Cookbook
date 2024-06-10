public interface Util_IQuery {
    List<SObject> query(String queryString);
    List<SObject> queryWithBinds(String queryString, Map<String, Object> bindMap, AccessLevel level);
    List<List<SObject>> search(String searchString);
}