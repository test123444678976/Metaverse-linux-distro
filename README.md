# 💜 Metaverse Linux 1.0.0 - Framboesa

> LFS-based distro. Powered by Meta AI.
> X.org + Mesa + MATE

![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)
![Build](https://img.shields.io/github/actions/workflow/status/test123444678976/Metaverse-linux-distro/build-iso.yml?branch=main&label=Build&color=purple)
![Version](https://img.shields.io/badge/Version-1.0.0-cyan.svg)
![Base](https://img.shields.io/badge/Base-LFS_12.2-blue.svg)

![Metaverse Linux](branding/logo.png)

## ✨ O que é?

Metaverse Linux é uma distro feita do zero com **LFS 12.2**, com desktop **MATE 1.28** roxo, **X.org + Mesa**, e **LightDM com autologin**.

Feita em Portugal, para toda a gente. Open Source com licença MIT.

## 🖥️ Specs

| Componente | Versão |
| --- | --- |
| Base | LFS 12.2 |
| Kernel | 6.10.5 |
| X.org | 21.1.13 |
| Mesa | 24.1.0 |
| Desktop | MATE 1.28 |
| Display Manager | LightDM 1.32.0 |
| Codename | Framboesa |

## 👤 Login

- **User:** `metaverse`
- **Pass:** `metaverse`
- **Root:** `metaverse`

Autologin ligado por defeito.

## 🚀 Build

```bash
sudo bash scripts/build-all.sh
```

Ou faz push para main e o GitHub Actions builda sozinho.
O ISO fica em **Actions > Artifacts** e em Releases.

## ▶️ Testar no QEMU
```bash
chmod +x run-qemu.sh
./run-qemu.sh
```
Requisitos: 4GB RAM, 4 CPU, KVM ligado.

## 🎨 Branding

- Logo: `branding/logo.png`
- Wallpaper: `branding/wallpaper.png`
- Tema: `branding/metaverse-theme/` -> `/usr/share/themes/Metaverse/`
- Definições: `branding/schemas/99-metaverse.gschema.override`

## 📁 Estrutura
```
metaverse-linux/
├── .github/workflows/build-iso.yml
├── branding/
│   ├── logo.png
│   ├── wallpaper.png
│   ├── schemas/
│   │   └── 99-metaverse.gschema.override
│   └── metaverse-theme/
│       ├── gtk-3.0/gtk.css
│       ├── gtk-2.0/gtkrc
│       ├── metacity-1/metacity-theme-1.xml
│       └── index.theme
├── config/
│   ├── kernel.config
│   ├── grub.cfg
│   └── packages.txt
├── scripts/
│   ├── build-all.sh
│   ├── 00-prepare.sh
│   ├── 01-toolchain.sh
│   ├── 02-system.sh
│   ├── 03-kernel.sh
│   ├── 04-xorg-mesa.sh
│   ├── 05-mate.sh
│   ├── 06-display-manager.sh
│   └── 07-make-iso.sh
├── LICENSE
├── README.md
└── run-qemu.sh
```

## 🤝 Contribuir

1. Fork
2. Cria branch
3. Push + Pull Request

Toda a ajuda é bem-vinda!

## 📜 Licença

MIT - Livre para usar, modificar e partilhar, mesmo em projetos comerciais.
Vê o ficheiro [LICENSE](LICENSE).

---
**Metaverse Linux - Powered by Meta AI 💜**
