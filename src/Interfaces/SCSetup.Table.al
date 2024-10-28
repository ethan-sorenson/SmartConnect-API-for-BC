
namespace eOneSolutions.SmartConnect.API;

table 66100 "SmartConnect Setup"
{
    Caption = 'SmartConnect Setup';
    DataClassification = SystemMetadata;
    fields
    {
        field(1; "Service URL"; Text[100])
        {
            Caption = 'API REST Service URL';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(2; "Client Id"; Text[100])
        {
            Caption = 'API Client Id';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(3; "Username"; Text[100])
        {
            Caption = 'SmartConnect Username';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(4; "Token Expiry"; DateTime)
        {
            Caption = 'Access token expiry date';
            DataClassification = SystemMetadata;
        }
        field(5; "Refresh Token Expiry"; DateTime)
        {
            Caption = 'Refresh token expiry date';
            DataClassification = SystemMetadata;
        }
    }
}