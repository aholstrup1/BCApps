// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.Email;

/// <summary>Holds the payload for emails.</summary>
table 8900 "Email Message"
{
    Access = Internal;
    InherentPermissions = X;
    InherentEntitlements = X;
    Description = 'Table is internal as it holds the payload that is sent to connectors. Extending it doesn''t make sense if the connectors don''t know how to consume the fields';

    fields
    {
        field(1; Id; Guid)
        {
            DataClassification = SystemMetadata;
        }
        field(2; Subject; Text[2048])
        {
            Access = Internal;
            DataClassification = CustomerContent;
        }
        field(3; Body; Blob)
        {
            Access = Internal;
            DataClassification = CustomerContent;
        }
        field(4; Editable; Boolean)
        {
            InitValue = true;
            Access = Internal;
            DataClassification = SystemMetadata;
        }
        field(5; "HTML Formatted Body"; Boolean)
        {
            Access = Internal;
            DataClassification = SystemMetadata;
            InitValue = true;
        }
        field(6; "No. of Modifies"; Integer)
        {
            Access = Internal;
            InitValue = 0;
            DataClassification = SystemMetadata;
        }
        field(7; "External Id"; Text[2048])
        {
            Access = Internal;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }
}