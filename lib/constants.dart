const baseUrl = "http://10.0.2.2:8080";

const ws = "ws://10.0.2.2:8080/ws";

const allLists = "$baseUrl/";
const newList = "$baseUrl/lists/";
const singleList = newList;

const items = "/items";
const itemsByList = "$baseUrl$items/";
const singleItem = "$items/";

const db = "/db";
const firebase = "$baseUrl$db/fbase/";

const postgresql = "$baseUrl/postgresql/";

const cache = "$baseUrl/cache/redis/";

const auth = "$baseUrl/authentication";
const basicAuth = "$auth/basic/";
const bearerAuth = "$auth/bearer/";

const api = "$baseUrl/api";
const restapi = "$api/restapi/";
