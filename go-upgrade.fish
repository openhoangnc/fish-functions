# note: this function only works on macOS
function go-upgrade
    set curVer (go version | grep -o -E 'go\d+\.\d+(.\d+)?')
    set arch (go version | grep -o -E '[^ ]+$' | sed 's/\//-/g')
    echo Current Go version: $curVer

    echo Getting latest Go version...
    set goDevDL (curl -sS https://go.dev/dl/ 2>/dev/null)

    set pkgReg "go\\d+\\.\\d+(\\.\\d+)?\\.$arch\\.pkg"
    set latestPkg (echo $goDevDL | grep -o -E -m 1 $pkgReg | head -1)
    set latestVer (echo $latestPkg | grep -o -E 'go\d+\.\d+(\.\d+)?')
    # echo Latest Go version: $latestVer

    set curMajor (echo $curVer | grep -o -E 'go\d+\.\d+' | sed 's/\\./\\\./g')
    set pkgRegMajor $curMajor"\\.\\d+\\.$arch\\.pkg"
    set latestMajorPkg (echo $goDevDL | grep -o -E -m 1 $pkgRegMajor | head -1)
    set latestMajorVer (echo $latestMajorPkg | grep -o -E 'go\d+\.\d+(\.\d+)?')
    # echo Latest Go same major version: $latestMajorVer

    if [ "$curVer" = "$latestVer" ]
        echo You have latest Go version
    else
        if [ "$latestVer" != "$latestMajorVer" ]
            echo "Upgrade Go version to"
            echo "  - $latestMajorVer (Enter)"
            echo "  - $latestVer (1 - Enter)"
            read -P "Select: " -l select
            if [ "$select" = "" ]
                set -x latestVer $latestMajorVer
                set -x latestPkg $latestMajorPkg
            end
        end

        echo Download $latestPkg
        curl https://dl.google.com/go/$latestPkg -o /tmp/$latestPkg
        echo Next command is \"sudo installer\", you need to enter your password.
        sudo installer -store -pkg "/tmp/$latestPkg" -target /
        rm -f "/tmp/$latestPkg"
    end
end
