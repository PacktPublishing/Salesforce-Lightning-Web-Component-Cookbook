public virtual class Util_Query {
    public List<SObject> query(String queryString, AccessLevel level) {
        return Database.query(String.escapeSingleQuotes(queryString), level);
    }

    public List<SObject> queryWithBinds(String queryString, Map<String, Object> bindMap, AccessLevel level) {
        return Database.queryWithBinds(String.escapeSingleQuotes(queryString), bindMap, level);
    }

    public List<List<SObject>> search(String searchString, AccessLevel level) {
        return Search.query(String.escapeSingleQuotes(searchString), level);
    }
}