public virtual class Util_Query implements Util_IQuery {
    public List<SObject> query(String queryString) {
        return Database.query(String.escapeSingleQuotes(queryString));
    }

    public List<SObject> queryWithBinds(String queryString, Map<String, Object> bindMap, AccessLevel level) {
        return Database.queryWithBinds(String.escapeSingleQuotes(queryString), bindMap, level);
    }

    public List<List<SObject>> search(String searchString) {
        return Search.query(String.escapeSingleQuotes(searchString));
    }
}