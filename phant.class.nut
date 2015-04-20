class Phant {
    _baseUrl = null;

    _publicKey = null;
    _privateKey = null;

    constructor(publicKey, privateKey, baseUrl = null) {
        if (baseUrl == null) baseUrl = "https://data.sparkfun.com";

        _baseUrl = baseUrl;
        _privateKey = privateKey;
        _publicKey = publicKey;
    }

    function push(data, cb = null) {
        assert(typeof(data == "table"));

        // add private key to table
        data["private_key"] <- _privateKey;
        local url = format("%s/input/%s?%s", _baseUrl, _publicKey, http.urlencode(data));

        // make the request
        local request = http.get(url);
        if (cb == null) {
            return request.sendsync();
        }

        request.sendasync(cb);
    }

    function get(cb = null) {
        local url = format("%s/output/%s.json", _baseUrl, _publicKey);

        local request = http.get(url);
        if(cb == null) {
            return request.sendsync();
        }
        return request.sendasync(cb);
    }

    function clear(cb = null) {
        local url = format("%s/input/%s/clear", _baseUrl, _publicKey);
        local headers = { "phant-private-key": _privateKey };

        local request = http.httpdelete(url, headers);
        if (cb == null) {
            return request.sendsync();
        }
        return request.sendasync(cb);
    }
}
