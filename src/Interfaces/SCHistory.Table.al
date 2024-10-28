namespace eOneSolutions.SmartConnect.API;

table 66101 "SmartConnect History"
{
    Caption = 'SmartConnect History';
    DataClassification = SystemMetadata;
    fields
    {
        field(1; "Id"; Text[200])
        {
            Caption = 'Integration Id';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(2; "Run Number"; Integer)
        {
            Caption = 'Run Number';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(3; "Key"; Text[40])
        {
            Caption = 'Integration Key';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(4; "Description"; Text[200])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(5; "Successful"; Boolean)
        {
            Caption = 'Successful';
            DataClassification = SystemMetadata;
        }
        field(6; "Record Count"; Integer)
        {
            Caption = 'Record Count';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(7; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(8; "Global Variable"; Text[50])
        {
            Caption = 'Global Variable';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(9; "Global Value"; Text[100])
        {
            Caption = 'Global Value';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(11; "Error Message"; Text[2048])
        {
            Caption = 'Error Message';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
    }
    keys
    {
        key(PrimaryKey; ID, "Run Number")
        {
            Clustered = true;
        }
        key(SecondaryKey; SystemCreatedAt)
        {
        }
    }
}