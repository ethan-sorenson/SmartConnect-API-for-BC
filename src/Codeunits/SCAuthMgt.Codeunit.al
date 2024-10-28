namespace eOneSolutions.SmartConnect.API;

using System.Text;
using System.Apps;
codeunit 66101 "SmartConnect Auth. Mgt."
{
    Access = Internal;

    var
        EnableHttpRequestActionLbl: Label 'Allow HTTP requests';

    [NonDebuggable]
    procedure GetToken()
    var
        SmartConnectSetup: Record "SmartConnect Setup";
        SmartConnectPassword: SecretText;
        SmartConnectClientSecret: SecretText;
        URL: Text;
        Body: Text;
        HttpClient: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestHttpContent: HttpContent;
        HttpResponseMessage: HttpResponseMessage;
        JObject: JsonObject;
        RequestBody: SecretText;
        HttpRequestErrorInfo: ErrorInfo;
    begin
        IsolatedStorage.Get('SmartConnectPassword', SmartConnectPassword);
        IsolatedStorage.Get('SmartConnectClientSecret', SmartConnectClientSecret);
        SmartConnectSetup.FindFirst();
        RequestBody := SecretStrSubstNo('grant_type=password&username=%1&password=%2&client_id=%3&client_secret=%4', SmartConnectSetup.Username, SmartConnectPassword, SmartConnectSetup."Client Id", SmartConnectClientSecret);
        URL := SmartConnectSetup."Service URL" + '/token';

        RequestHttpContent.WriteFrom(RequestBody);
        RequestHttpContent.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        RequestHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        HttpClient.Post(URL, RequestHttpContent, HttpResponseMessage);
        if not HttpResponseMessage.IsSuccessStatusCode then begin
            Clear(Body);
            HttpResponseMessage.Content().ReadAs(Body);
            HttpRequestErrorInfo.Message := Body;
            Error(HttpRequestErrorInfo);
        end else
            Clear(Body);
        HttpResponseMessage.Content().ReadAs(Body);
        SaveTokenInfo(parseJsonText(Body, 'access_token'), parseJsonText(Body, 'refresh_token'));
    end;

    [NonDebuggable]
    procedure RefreshToken()
    var
        SmartConnectSetup: Record "SmartConnect Setup";
        SmartConnectClientSecret: SecretText;
        SmartConnectRefreshToken: SecretText;
        ClientId: SecretText;
        URL: Text;
        Body: Text;
        HttpClient: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestHttpContent: HttpContent;
        HttpResponseMessage: HttpResponseMessage;
        JObject: JsonObject;
        RequestBody: SecretText;
        HttpRequestErrorInfo: ErrorInfo;
    begin
        IsolatedStorage.Get('SmartConnectClientSecret', SmartConnectClientSecret);
        IsolatedStorage.Get('SmartConnectRefreshToken', SmartConnectRefreshToken);
        SmartConnectSetup.FindFirst();
        RequestBody := SecretStrSubstNo('grant_type=refresh_token&refresh_token=%1&client_id=%2&client_secret=%3', SmartConnectRefreshToken, SmartConnectSetup."Client Id", SmartConnectClientSecret);
        URL := SmartConnectSetup."Service URL" + '/token';

        RequestHttpContent.WriteFrom(RequestBody);
        RequestHttpContent.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        RequestHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        HttpClient.Post(URL, RequestHttpContent, HttpResponseMessage);
        if not HttpResponseMessage.IsSuccessStatusCode then begin
            Clear(Body);
            HttpResponseMessage.Content().ReadAs(Body);
            HttpRequestErrorInfo.Message := Body;
            Error(HttpRequestErrorInfo);
        end else
            Clear(Body);
        HttpResponseMessage.Content().ReadAs(Body);
        SaveTokenInfo(parseJsonText(Body, 'access_token'), parseJsonText(Body, 'refresh_token'));
    end;

    procedure ValidateToken() AccessToken: SecretText
    var
        SmartConnectSetup: Record "SmartConnect Setup";
        SmartConnectAccessToken: SecretText;
    begin
        SmartConnectSetup.FindFirst();
        if SmartConnectSetup."Token Expiry" < CurrentDateTime then
            if SmartConnectSetup."Refresh Token Expiry" > CurrentDateTime then
                RefreshToken()
            else
                GetToken();

        IsolatedStorage.Get('SmartConnectAccessToken', SmartConnectAccessToken);
        AccessToken := SecretStrSubstNo('Bearer %1', SmartConnectAccessToken);
    end;



    local procedure SaveTokenInfo(access_token: SecretText; refresh_token: SecretText)
    var
        SmartConnectSetup: Record "SmartConnect Setup";
        DatePart: Date;
        TimePart: Time;
    begin
        IsolatedStorage.Set('SmartConnectAccessToken', access_token);
        IsolatedStorage.Set('SmartConnectRefreshToken', refresh_token);
        SmartConnectSetup.FindFirst();
        SmartConnectSetup."Token Expiry" := CurrentDateTime + (1798 * 1000);
        SmartConnectSetup."Refresh Token Expiry" := CurrentDateTime + (604800 * 1000);
        SmartConnectSetup.Modify()
    end;

    internal procedure EnableHttpRequestForExtension(ErrorInfo: ErrorInfo)
    var
        ExtensionManagement: Codeunit "Extension Management";
        CallerModuleInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(CallerModuleInfo);
        ExtensionManagement.ConfigureExtensionHttpClientRequestsAllowance(CallerModuleInfo.PackageId(), true);
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
}