// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.Globalization;

/// <summary>
/// Management codeunit that exposes various functions to work with languages.
/// </summary>
codeunit 43 Language
{
    Access = Public;
    SingleInstance = true;
    InherentEntitlements = X;
    InherentPermissions = X;

    /// <summary>
    /// Gets the current user's language code.
    /// The function emits the <see cref="OnGetUserLanguageCode"/> event.
    /// To change the language code returned from this function, subscribe for this event and change the passed language code.
    /// </summary>
    /// <seealso cref="OnGetUserLanguageCode"/>
    /// <returns>The language code of the user's language, for example 'ENU' for 'English (United States)'</returns>
    procedure GetUserLanguageCode(): Code[10]
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.GetUserLanguageCode());
    end;

    /// <summary>
    /// Gets the current user's language tag.
    /// </summary>
    /// <returns>The language tag of the user's language, for example 'en-US' for 'English (United States)'</returns>
    procedure GetUserLanguageTag(): Text[80]
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.GetUserLanguageTag());
    end;

    /// <summary>
    /// Gets the language ID based on its code. Or defaults to the current user language.
    /// </summary>
    /// <param name="LanguageCode">The code of the language</param>
    /// <returns>The ID for the language code that was provided for this function. If no ID is found for the language code, then it returns the ID of the current user's language.</returns>
    procedure GetLanguageIdOrDefault(LanguageCode: Code[10]): Integer;
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.GetLanguageIdOrDefault(LanguageCode));
    end;


    /// <summary>
    /// Returns format region for a given language. If format region is provided it itself will be returned. If format region is empty the region is taken from UserSessionSettings.
    /// If no valid tag is found, the default 'en-US' tag is returned.
    /// </summary>
    /// <param name="FormatRegion">The variable for the format region id.</param>
    /// <returns>The ID for the format region that was found.</returns>
    procedure GetFormatRegionOrDefault(FormatRegion: Text[80]): Text[80]
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.GetFormatRegionOrDefault(FormatRegion));
    end;

    /// <summary>
    /// Gets the language ID based on its code.
    /// </summary>
    /// <param name="LanguageCode">The code of the language</param>
    /// <returns>The ID for the language code that was provided for this function. If no ID is found for the language code, then it returns 0.</returns>
    procedure GetLanguageId(LanguageCode: Code[10]): Integer
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.GetLanguageId(LanguageCode));
    end;

    /// <summary>  
    /// Overrides the language ID returned by the GetLanguageIdOrDefault function. 
    /// </summary>  
    /// <param name="LanguageId">The ID of the language to use. This must be a valid language ID.</param>  
    /// <remarks>  
    /// This override will be reset after it's used once in the GetLanguageIdOrDefault function. To keep the override throughout the application, use SetOverrideLanguageId(LanguageId: Integer; ResetOverride: Boolean) method.  
    /// </remarks>  
    procedure SetOverrideLanguageId(LanguageId: Integer)
    begin
        SetOverrideLanguageId(LanguageId, true);
    end;

    /// <summary>  
    /// Overrides the language ID returned by the GetLanguageIdOrDefault function.  
    /// </summary>  
    /// <param name="LanguageId">The ID of the language to use. This must be a valid language ID.</param>  
    /// <param name="ResetOverride">A boolean value indicating whether the override should be reset after use in the GetLanguageIdOrDefault function. If set to true, the override is reset after it's used once. If set to false, the override remains until it's manually reset or the session is restarted.</param>  

    procedure SetOverrideLanguageId(LanguageId: Integer; ResetOverride: Boolean)
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        LanguageImpl.SetOverrideLanguageId(LanguageId, ResetOverride);
    end;

    /// <summary>  
    /// Overrides the format region returned by the GetFormatRegionOrDefault function.  
    /// </summary>  
    /// <param name="FormatRegion">The region to use for formatting purposes. This must be a valid region code.</param>  
    /// <remarks>  
    /// This override will be reset after it's used once in the GetFormatRegionOrDefault function. To keep the override throughout the session, use SetOverrideFormatRegion(FormatRegion: Text[80]; ResetOverride: Boolean) method.  
    /// </remarks>  
    procedure SetOverrideFormatRegion(FormatRegion: Text[80])
    begin
        SetOverrideFormatRegion(FormatRegion, true);
    end;

    /// <summary>  
    /// Overrides the format region returned by the GetFormatRegionOrDefault function.
    /// </summary>  
    /// <param name="FormatRegion">The region to use for formatting purposes. This must be a valid region code.</param>  
    /// <param name="ResetOverride">A boolean value indicating whether the override should be reset after use in the GetFormatRegionOrDefault function. If set to true, the override is reset after it's used once. If set to false, the override remains until it's manually reset or the session is restarted.</param>  
    procedure SetOverrideFormatRegion(FormatRegion: Text[80]; ResetOverride: Boolean)
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        LanguageImpl.SetOverrideFormatRegion(FormatRegion, ResetOverride);
    end;

    /// <summary>
    /// Gets the code for a language based on its ID.
    /// </summary>
    /// <param name="LanguageId">The ID of the language.</param>
    /// <returns>The code of the language that corresponds to the ID, or an empty code if the language with the specified ID does not exist.</returns>
    procedure GetLanguageCode(LanguageId: Integer): Code[10]
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.GetLanguageCode(LanguageId));
    end;

    /// <summary>
    /// Gets the name of a language based on the language code.
    /// </summary>
    /// <param name="LanguageCode">The code of the language.</param>
    /// <returns>The name of the language corresponding to the code or empty string, if language with the specified code does not exist</returns>
    procedure GetWindowsLanguageName(LanguageCode: Code[10]): Text
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.GetWindowsLanguageName(LanguageCode));
    end;

    /// <summary>
    /// Gets the name of a windows language based on its ID.
    /// </summary>
    /// <param name="LanguageId">The ID of the language.</param>
    /// <returns>The name of the language that corresponds to the ID, or an empty string if a language with the specified ID does not exist.</returns>
    procedure GetWindowsLanguageName(LanguageId: Integer): Text
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.GetWindowsLanguageName(LanguageId));
    end;

    /// <summary>
    /// Gets all available languages in the application.
    /// </summary>
    /// <param name="TempLanguage">A temporary record to place the result in</param>
    procedure GetApplicationLanguages(var TempLanguage: Record "Windows Language" temporary)
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        LanguageImpl.GetApplicationLanguages(TempLanguage);
    end;

    /// <summary>
    /// Gets the default application language ID.
    /// </summary>
    /// <returns>The ID of the default language for the application.</returns>
    procedure GetDefaultApplicationLanguageId(): Integer
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.GetDefaultApplicationLanguageId());
    end;

    /// <summary>
    /// Formats the provided value in default language.
    /// </summary>
    /// <param name="ValueVariant">The provided value to be returned in default language.</param>
    /// <returns>The value in default language.</returns>
    procedure ToDefaultLanguage(ValueVariant: Variant): Text
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.ToDefaultLanguage(ValueVariant));
    end;

    /// <summary>
    /// Checks whether the provided language is a valid application language.
    /// If it isn't, the function displays an error.
    /// </summary>
    /// <param name="LanguageId">The ID of the language to validate.</param>
    procedure ValidateApplicationLanguageId(LanguageId: Integer)
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        LanguageImpl.ValidateApplicationLanguageId(LanguageId);
    end;

    /// <summary>
    /// Checks whether the provided language exists. If it doesn't, the function displays an error.
    /// </summary>
    /// <param name="LanguageId">The ID of the language to validate.</param>
    procedure ValidateWindowsLanguageId(LanguageId: Integer)
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        LanguageImpl.ValidateWindowsLanguageId(LanguageId);
    end;

    /// <summary>
    /// Opens a list of the languages that are available for the application so that the user can choose a language.
    /// </summary>
    /// <param name="LanguageId">Exit parameter that holds the chosen language ID.</param>
    procedure LookupApplicationLanguageId(var LanguageId: Integer)
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        LanguageImpl.LookupApplicationLanguageId(LanguageId);
    end;

    /// <summary>
    /// Opens a list of languages that are available for the Windows version.
    /// </summary>
    /// <param name="LanguageId">Exit parameter that holds the chosen language ID.</param>
    procedure LookupWindowsLanguageId(var LanguageId: Integer)
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        LanguageImpl.LookupWindowsLanguageId(LanguageId);
    end;

    /// <summary>
    /// Opens a list of the languages that are available for the application so that the user can choose a language.
    /// </summary>
    /// <param name="LanguageCode">Exit parameter that holds the chosen language code.</param>
    procedure LookupLanguageCode(var LanguageCode: Code[10])
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        LanguageImpl.LookupLanguageCode(LanguageCode);
    end;

    /// <summary>
    /// Gets the parent language ID based on Windows Culture Info.
    /// </summary>
    /// <param name="LanguageId">Exit parameter that holds the chosen language ID.</param>
    /// <returns>The ID of the parent language</returns>
    procedure GetParentLanguageId(LanguageId: Integer): Integer
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.GetParentLanguageId((LanguageId)));
    end;

    /// <summary>
    /// Sets the preferred language for the provided user.
    /// </summary>
    /// <param name="UserSecID">The user security ID for the user for whom the preferred language is changed.</param>
    /// <param name="NewLanguageID">The new preferred language for the user.</param>
    procedure SetPreferredLanguageID(UserSecID: Guid; NewLanguageID: Integer)
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        LanguageImpl.SetPreferredLanguageID(UserSecID, NewLanguageID);
    end;

    /// <summary>
    /// Retrieves the two-letter ISO language name for the specified language ID.
    /// </summary>
    /// <param name="LanguageID">The language ID.</param>
    /// <returns>The two-letter ISO language name. For example, "en" or "es"</returns>
    procedure GetTwoLetterISOLanguageName(LanguageID: Integer): Text[2]
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.GetTwoLetterISOLanguageName(LanguageID));
    end;

    /// <summary>
    /// Retrieves the language ID for the specified culture name.
    /// </summary>
    /// <param name="CultureName">The Culture name.</param>
    /// <returns>The language ID. See https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/a29e5c28-9fb9-4c49-8e43-4b9b8e733a05.</returns>
    /// <example>
    /// <code>
    /// Language.GetLanguageIdFromLanguageName('en-US');
    /// Language.GetLanguageIdFromLanguageName('en');
    /// </code>
    /// </example>
    procedure GetLanguageIdFromCultureName(CultureName: Text): Integer
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.GetLanguageIdFromCultureName(CultureName));
    end;

    /// <summary>
    /// Retrieves the culture name for the specified language ID.
    /// </summary>
    /// <param name="LanguageID">The language ID. See https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/a29e5c28-9fb9-4c49-8e43-4b9b8e733a05.</param>
    /// <returns>The culture name. For example, 'en-US'.</returns>
    procedure GetCultureName(LanguageID: Integer): Text
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.GetCultureName(LanguageID));
    end;

    /// <summary>
    /// Retrieves the current culture name for the session.
    /// </summary>
    /// <returns>The culture name. For example, 'en-US'.</returns>
    procedure GetCurrentCultureName(): Text
    var
        LanguageImpl: Codeunit "Language Impl.";
    begin
        exit(LanguageImpl.GetCurrentCultureName());
    end;

    /// <summary>
    /// Integration event, emitted from <see cref="GetUserLanguageCode"/>.
    /// Subscribe to this event to change the default behavior by changing the provided parameter(s).
    /// </summary>
    /// <seealso cref="GetUserLanguageCode"/>
    /// <param name="UserLanguageCode">Exit parameter that holds the user language code.</param>
    /// <param name="Handled">To change the default behavior of the function that emits the event, set this parameter to true.</param>
    [IntegrationEvent(false, false)]
    internal procedure OnGetUserLanguageCode(var UserLanguageCode: Code[10]; var Handled: Boolean)
    begin
    end;
}

