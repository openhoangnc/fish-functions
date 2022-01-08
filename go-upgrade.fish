function go-upgrade
    set curVer (go version | grep -o -E 'go\d+\.\d+\.\d+')
    set arch (go version | grep -o -E '[^ ]+$' | sed 's/\//-/g') 
    echo Current Go version: $curVer
    set pkgReg "go\\d+\\.\\d+\\.\\d+\\.$arch\\.pkg"
    echo Getting latest Go version...
    set latestPkg (curl -sS https://go.dev/dl/ 2>/dev/null | grep -o -E -m 1 $pkgReg | head -1)
    set latestVer (echo $latestPkg | grep -o -E 'go\d+\.\d+\.\d+')
    if [ "$curVer" = "$latestVer" ]
        echo You have latest Go version
    else
        echo Latest Go version: $latestVer
        echo Download $latestPkg
        curl https://dl.google.com/go/$latestPkg -o $latestPkg
        echo Next command is \"sudo installer\", you need to enter your password.
        sudo installer -store -pkg "./$latestPkg" -target /
        rm -f "./$latestPkg"
    end
end