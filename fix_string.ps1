$content = Get-Content lib\dashboard\create_page_page.dart -Raw
$content = $content -replace "'You currently have `$\{coinsProvider\.coins\} coins\.?
?
'", "'You currently have `$\{coinsProvider\.coins\} coins.

'"
Set-Content lib\dashboard\create_page_page.dart -Value $content
