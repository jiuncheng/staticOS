FROM ghcr.io/ublue-os/silverblue-main:latest AS staticOS

COPY usr /usr

RUN rpm-ostree install fish neovim gnome-console libgda libgda-sqlite aria2
RUN rpm-ostree override remove gnome-terminal gnome-terminal-nautilus \
    firefox firefox-langpacks

RUN rm -rf /tmp/* /var/* && \  
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp


FROM staticOS AS staticOS-dx

COPY etc/yum.repos.d/ /etc/yum.repos.d/
RUN rpm-ostree install code jetbrains-mono-fonts-all \
    google-go-mono-fonts google-droid-sans-mono-fonts \
    fira-code-fonts mozilla-fira-sans-fonts powerline-fonts

RUN rpm-ostree install cockpit-system cockpit-bridge \
    cockpit-networkmanager cockpit-ostree cockpit-pcp \
    cockpit-podman cockpit-selinux cockpit-storaged cockpit-system

RUN rm -f /etc/yum.repos.d/vscode.repo && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp

FROM staticOS-dx AS staticOS-dx-virt

RUN rpm-ostree install cockpit-machines libvirt \
    lxc qemu virt-manager virt-viewer

RUN rm -rf /tmp/* /var/* && \
    ostree container commit
