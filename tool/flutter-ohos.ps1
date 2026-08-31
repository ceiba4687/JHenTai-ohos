param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]] $FlutterArgs
)

$ErrorActionPreference = 'Stop'

$flutterVersion = '3.44.9+ohos-0.0.1-canary1'
$flutterHome = if ($env:JHENTAI_FLUTTER_OHOS_HOME) {
    $env:JHENTAI_FLUTTER_OHOS_HOME
} else {
    "C:\devlope\flutter-ohos\$flutterVersion"
}
$toolHome = if ($env:JHENTAI_DEVECO_TOOL_HOME) {
    $env:JHENTAI_DEVECO_TOOL_HOME
} else {
    'C:\devlope\command-line-tools'
}
$javaHome = if ($env:JHENTAI_JAVA_HOME) {
    $env:JHENTAI_JAVA_HOME
} else {
    'C:\Program Files\Huawei\DevEco Studio\jbr'
}

$flutter = Join-Path $flutterHome 'bin\flutter.bat'
$requiredPaths = @(
    $flutter,
    (Join-Path $toolHome 'sdk'),
    (Join-Path $toolHome 'bin\ohpm.bat'),
    (Join-Path $toolHome 'bin\hvigorw.bat'),
    (Join-Path $toolHome 'tool\node\node.exe'),
    (Join-Path $toolHome 'sdk\default\openharmony\toolchains\hdc.exe'),
    (Join-Path $javaHome 'bin\java.exe')
)

foreach ($requiredPath in $requiredPaths) {
    if (-not (Test-Path -LiteralPath $requiredPath)) {
        throw "Required Flutter OH tool was not found: $requiredPath"
    }
}

$env:JAVA_HOME = $javaHome
$env:TOOL_HOME = $toolHome
$env:DEVECO_SDK_HOME = Join-Path $toolHome 'sdk'
$env:HOS_SDK_HOME = $env:DEVECO_SDK_HOME
$env:PUB_CACHE = 'C:\devlope\flutter-ohos\pub-cache'
$env:FLUTTER_GIT_URL = 'https://gitcode.com/CPF-Flutter/flutter_flutter.git'
$env:FLUTTER_STORAGE_BASE_URL = 'https://storage.flutter-io.cn'

if ($env:JHENTAI_GIT_PROXY) {
    $env:HTTP_PROXY = $env:JHENTAI_GIT_PROXY
    $env:HTTPS_PROXY = $env:JHENTAI_GIT_PROXY
}

$toolPaths = @(
    (Join-Path $flutterHome 'bin'),
    (Join-Path $javaHome 'bin'),
    (Join-Path $toolHome 'bin'),
    (Join-Path $toolHome 'tool\node'),
    (Join-Path $toolHome 'sdk\default\openharmony\toolchains')
)
$env:Path = ($toolPaths -join ';') + ';' + $env:Path

& $flutter @FlutterArgs
exit $LASTEXITCODE
