param(
    [ValidateSet('debug', 'profile', 'release')]
    [string] $Mode = 'debug',

    [ValidateSet('ohos-arm64', 'ohos-x64')]
    [string] $TargetPlatform = 'ohos-arm64',

    [switch] $NoCodesign
)

$flutterArgs = @(
    'build',
    'hap',
    "--$Mode",
    '--target-platform',
    $TargetPlatform,
    '--target',
    'lib/src/main.dart'
)

if ($NoCodesign) {
    $flutterArgs += '--no-codesign'
}

& "$PSScriptRoot\flutter-ohos.ps1" @flutterArgs
exit $LASTEXITCODE
