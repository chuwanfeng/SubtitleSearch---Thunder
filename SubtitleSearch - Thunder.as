/*
	subtitle search by thunder
*/

// void OnInitialize()
// void OnFinalize()
// string GetTitle() 																-> get title for UI
// string GetVersion																-> get version for manage
// string GetDesc()																	-> get detail information
// string GetLoginTitle()															-> get title for login dialog
// string GetLoginDesc()															-> get desc for login dialog
// string GetUserText()																-> get user text for login dialog
// string GetPasswordText()															-> get password text for login dialog
// string ServerCheck(string User, string Pass) 									-> server check
// string ServerLogin(string User, string Pass) 									-> login
// void ServerLogout() 																-> logout
//------------------------------------------------------------------------------------------------
// string GetLanguages()															-> get support language
// string SubtitleWebSearch(string MovieFileName, dictionary MovieMetaData)			-> search subtitle bu web browser
// array<dictionary> SubtitleSearch(string MovieFileName, dictionary MovieMetaData)	-> search subtitle
// string SubtitleDownload(string id)												-> download subtitle
// string GetUploadFormat()															-> upload format
// string SubtitleUpload(string MovieFileName, dictionary MovieMetaData, string SubtitleName, string SubtitleContent)	-> upload subtitle

string API_URL = "https://api-shoulei-ssl.xunlei.com/oracle/subtitle?name=";

array<array<string>> LangTable = {
  { "en", "English" },
  { "zh-TW", "Chinese" },
  { "zh-CN", "Mandarin" }
};

string GetTitle()
{
    return "迅雷字幕";
}

string GetVersion()
{
    return "1.2";
}

string GetDesc()
{
    return "https://github.com/chuwanfeng/SubtitleSearch---Thunder";
}

string GetLanguages()
{
    string ret = "";
    for(int i = 0, len = LangTable.size(); i < len; i++)
    {
        string lang = LangTable[i][0];
        if (!lang.empty())
        {
            if (ret.empty()) ret = lang;
            else ret = ret + "," + lang;
        }
    }
    return ret;
}

string ServerCheck(string User, string Pass)
{
    string ret = HostUrlGetString(API_URL);
    if (ret.empty()) return "失败";

    JsonReader Reader;
    JsonValue Root;

    if (Reader.parse(ret, Root) && Root.isObject()) {
        if (Root["code"].asInt() == 200) {
            return "成功";
        }
    }

    return "失败";
}

array<dictionary> SubtitleSearch(string MovieFileName, dictionary MovieMetaData)
{
    array < dictionary > ret;
    string title = string(MovieMetaData["title"]);
    if (title.empty()) return ret;

    string api = API_URL + title;
    string json = HostUrlGetString(api);
    if (json.empty()) return ret;

    JsonReader Reader;
    JsonValue Root;

    if (Reader.parse(json, Root) && Root.isObject()) {
        if(Root["code"].asInt() == 0){
            JsonValue data = Root["data"];
            if (data.isArray()) {
                for(int i = 0, len = data.size(); i < len; i++){
                    dictionary item;
                    item["id"] = data[i]["url"].asString();
                    item["title"] = data[i]["extra_name"].asString();
                    item["fileName"] = data[i]["name"].asString();
                    item["format"] = data[i]["ext"].asString();
                    if (data[i]["languages"].isArray() && data[i]["languages"].size() > 0) {
                        item["lang"] = data[i]["languages"][0].asString();
                    }
                    item["url"] = data[i]["url"].asString();
                    ret.insertLast(item);
                }
            }
        }
    }
    return ret;
}

string SubtitleDownload(string url)
{
    return HostUrlGetString(url);
}