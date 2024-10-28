namespace eOneSolutions.SmartConnect.API;

using System.Text;
codeunit 66102 "SmartConnect Run Map"
{
    procedure RunIntegration(IntegrationId: Text; GlobalVariable: Text; GlobalValue: Text) success: Boolean
    var
        SmartConnectSetup: Record "SmartConnect Setup";
        SmartConnectAuthMgt: Codeunit "SmartConnect Auth. Mgt.";
        SmartConnectAccessToken: SecretText;
        URL: Text;
        Body: Text;
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        RequestBody: JsonObject;
        HttpClient: HttpClient;
        RequestHeaders: HttpHeaders;
        ContentHeaders: HttpHeaders;
        RequestHttpContent: HttpContent;
        HttpResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        HttpRequestErrorInfo: ErrorInfo;
    begin
        SmartConnectSetup.FindFirst();
        URL := StrSubstNo('%1/v1/run-integration/%2?returnErrors=true', SmartConnectSetup."Service URL", IntegrationId);
        //Generate JSON Body
        JsonObject.Add('Name', GlobalVariable);
        JsonObject.Add('Value', GlobalValue);
        JsonArray.Add(JsonObject);
        RequestBody.Add('Variables', JsonArray);
        RequestBody.WriteTo(Body);
        RequestHttpContent.WriteFrom(Body);
        //Add Authorization Header
        SmartConnectAccessToken := SmartConnectAuthMgt.ValidateToken();
        RequestHeaders := HttpClient.DefaultRequestHeaders();
        RequestHeaders.Add('Accept', 'application/json');
        RequestHeaders.Add('Authorization', SmartConnectAccessToken);

        RequestHttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        //Send HTTP Request
        HttpClient.Post(URL, RequestHttpContent, HttpResponseMessage);
        if not HttpResponseMessage.IsSuccessStatusCode then begin
            HttpResponseMessage.Content().ReadAs(ResponseText);
            HttpRequestErrorInfo.Message := ResponseText;
            Error(HttpRequestErrorInfo);
        end else
            HttpResponseMessage.Content().ReadAs(ResponseText);
        SaveHistory(ResponseText, GlobalVariable, GlobalValue)
    end;

    local procedure SaveHistory(JsonText: Text; GlobalVariable: Text; GlobalValue: Text)
    var
        SCHistory: Record "SmartConnect History";
    begin
        SCHistory.Init();
        SCHistory.Id := parseJsonText(JsonText, 'Id');
        SCHistory.Description := parseJsonText(JsonText, 'Description');
        SCHistory.Key := parseJsonText(JsonText, 'Key');
        SCHistory."Error Message" := parseJsonText(JsonText, 'ErrorMessage');
        SCHistory."Global Value" := GlobalValue;
        SCHistory."Global Variable" := GlobalVariable;
        SCHistory."Run Number" := parseJsonInteger(JsonText, 'RunNumber');
        SCHistory."Error Count" := parseJsonInteger(JsonText, 'ErrorCount');
        SCHistory."Record Count" := parseJsonInteger(JsonText, 'RecordCount');
        if parseJsonText(JsonText, 'Status') = 'Successful' then begin
            SCHistory.Successful := true;
            Message('SmartConnect Run Successful')
        end
        else begin
            Message(SCHistory."Error Message");
            SCHistory.Successful := false;
        end;
        SCHistory.Insert();
    end;

    internal procedure parseJsonText(JsonText: Text; FieldName: Text) Value: Text
    var
        JsonResponse: JsonObject;
        JsonTokenValue: JsonToken;
        JsonTokenType: JsonToken;
    begin
        if JsonResponse.ReadFrom(JsonText) then begin
            JsonResponse.Get(FieldName, JsonTokenType);
            Value := JsonTokenType.AsValue().AsText;
        end
    end;

    internal procedure parseJsonInteger(JsonText: Text; FieldName: Text) Value: Integer
    var
        JsonResponse: JsonObject;
        JsonTokenValue: JsonToken;
        JsonTokenType: JsonToken;
    begin
        if JsonResponse.ReadFrom(JsonText) then begin
            JsonResponse.Get(FieldName, JsonTokenType);
            Value := JsonTokenType.AsValue().AsInteger();
        end
    end;
}
