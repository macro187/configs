. $HOTBOX/lib/sh.sh


install_ubuntu() {
    # https://www.mono-project.com/download/stable/#download-lin-ubuntu
    echo_on
    doas env DEBIAN_FRONTEND=noninteractive \
        apt install -y --no-install-recommends ca-certificates gnupg
    doas gpg \
        --homedir /tmp \
        --no-default-keyring \
        --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
    echo \
        "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/ubuntu stable-focal main" \
        | doas tee /etc/apt/sources.list.d/mono-official-stable.list
    doas env DEBIAN_FRONTEND=noninteractive \
        apt update
    doas env DEBIAN_FRONTEND=noninteractive \
        apt install -y --no-install-recommends mono-complete
    echo_off
}


program=mono
if ! which $program >/dev/null ; then
    install=install_$(current_distro)
    function_exists $install || die "Don't know how to install $program on $(current_distro) os"
    $install
fi
