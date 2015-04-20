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
        return _processReq(http.get(url), cb);
    }

    function get(cb = null) {
        local url = format("%s/output/%s.json", _baseUrl, _publicKey);

        return _processReq(http.get(url), cb);
    }

    function clear(cb = null) {
        local url = format("%s/input/%s/clear", _baseUrl, _publicKey);
        local headers = { "phant-private-key": _privateKey };

        return _processReq(http.httpdelete(url, headers), cb);
    }

    /******************** PRIVATE METHODS (DO NOT CALL) ********************/
    function _processReq(req, cb) {
        if (cb == null) return _processResp(req.sendsync());

        return req.sendasync(function(resp) {
            local respData = _processResp(resp);
            cb(respData.err, respData.data);
        }.bindenv(this));
    }

    function _processResp(resp) {
        local data = null;
        local err = null;

        try {
            if (resp.statuscode >= 200 && resp.statuscode < 300) {
                data = http.jsondecode(resp.body);
            } else {
                err = { code = resp.statuscode, error = resp.body };
            }
        } catch (ex) {
            err = { code = -1, error = ex };
        }

        return { err = err, data = data };
    }
}
