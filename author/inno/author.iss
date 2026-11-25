; pBielli author tag for Inno Setup 6 installers.
; Usage, in the app's .iss (before [Setup]):   #include "author\author.iss"
; then inside [Setup] add:                     {#AuthorSetup}
; Files: copy this folder next to the .iss as "author\" (the build script downloads it from
; https://raw.githubusercontent.com/pBielli/utils/main/author/inno/).
#define AuthorName "pBielli"
#define AuthorUrl "https://pbielli.com"
#define AuthorGithub "https://github.com/pBielli"
#define AuthorCopyright "© pBielli"
#define AuthorSetup "AppPublisher=" + AuthorName + "\nAppPublisherURL=" + AuthorUrl + "\nAppSupportURL=" + AuthorGithub + "\nAppCopyright=" + AuthorCopyright + "\nVersionInfoCompany=" + AuthorName + "\nVersionInfoCopyright=" + AuthorCopyright + "\nWizardSmallImageFile=author\pbielli-small-55.bmp,author\pbielli-small-110.bmp"
; Text for the welcome page, e.g. WelcomeLabel2=...%n%n{#AuthorLine}
#define AuthorLine "by " + AuthorName + " · " + AuthorUrl
