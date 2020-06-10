var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var _this = this;
var got = require('got');
var ChannelName;
(function (ChannelName) {
    ChannelName[ChannelName["RADIO2"] = 0] = "RADIO2";
    ChannelName[ChannelName["RADIO3"] = 1] = "RADIO3";
})(ChannelName || (ChannelName = {}));
// Export for use by other apps
var getNowPlaying = function (channelName) { return __awaiter(_this, void 0, void 0, function () {
    var nowonairResponse, _a, artist, title, last_updated, songversion, songImageUrl, broadcastResponse, _b, name_1, image, imageUrl, nowonairResponse, _c, artist, title, image, enddatetime, broadcastResponse, _d, name_2, presenters, image_url;
    return __generator(this, function (_e) {
        switch (_e.label) {
            case 0:
                if (!(channelName === ChannelName.RADIO2)) return [3 /*break*/, 3];
                return [4 /*yield*/, got('https://radiobox2.omroep.nl/data/radiobox2/nowonair/2.json').json()];
            case 1:
                nowonairResponse = _e.sent();
                _a = nowonairResponse.results[0].songfile, artist = _a.artist, title = _a.title, last_updated = _a.last_updated, songversion = _a.songversion;
                songImageUrl = songversion && songversion.image && songversion.image[0].url ? songversion.image[0].url : '';
                return [4 /*yield*/, got('https://radiobox2.omroep.nl/data/radiobox2/currentbroadcast/2.json').json()];
            case 2:
                broadcastResponse = _e.sent();
                _b = broadcastResponse.results[0], name_1 = _b.name, image = _b.image;
                imageUrl = image && image.url ? image.url : '';
                return [2 /*return*/, { artist: artist, title: title, last_updated: last_updated, songImageUrl: songImageUrl, name: name_1, imageUrl: imageUrl }];
            case 3:
                if (!(channelName === ChannelName.RADIO3)) return [3 /*break*/, 6];
                return [4 /*yield*/, got('https://www.npo3fm.nl/api/tracks').json()];
            case 4:
                nowonairResponse = _e.sent();
                _c = nowonairResponse.data[0], artist = _c.artist, title = _c.title, image = _c.image, enddatetime = _c.enddatetime;
                return [4 /*yield*/, got('https://www.npo3fm.nl/api/broadcasts').json()];
            case 5:
                broadcastResponse = _e.sent();
                _d = broadcastResponse.data[0], name_2 = _d.title, presenters = _d.presenters, image_url = _d.image_url;
                return [2 /*return*/, {
                        artist: artist,
                        title: title,
                        last_updated: enddatetime,
                        songImageUrl: image,
                        name: name_2 + " / " + presenters,
                        imageUrl: image_url
                    }];
            case 6: return [2 /*return*/];
        }
    });
}); };
module.exports = {
    getNowPlaying: getNowPlaying,
    ChannelName: ChannelName
};
