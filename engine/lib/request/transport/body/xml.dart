/**
 *@author DICKY
 *@email <dicky.maulana@pitik.id>
 *@create date 31/07/23
 */

class XmlBody {
    Map<String, dynamic>? _params;

    XmlBody() {
        _params = {};
    }

    XmlBody addStringValue(String key, String value) {
        _params![key] = value;
        return this;
    }

    XmlBody addXmlValue(String key, XmlBody value) {
        _params![key] = value;
        return this;
    }

    XmlBody addIntValue(String key, int value) {
        _params![key] = value;
        return this;
    }

    XmlBody addDoubleValue(String key, double value) {
        _params![key] = double;
        return this;
    }

    XmlBody addBoolValue(String key, bool value) {
        _params![key] = value;
        return this;
    }

    Map<String, dynamic> getParams() {
        return _params!;
    }
}