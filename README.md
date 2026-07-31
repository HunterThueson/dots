# Hunter's NixOS Homelab

Personal NixOS flake managing two hosts, multiple users, and a shared pool of system and environment modules. Designed around a hub-and-spoke architecture where hosts and users are declared in simple syntax and the backend enables opinionated defaults automatically; per-user and per-host overrides are supported for edge cases where the default settings should not apply.

## Hosts

| Host | Type | Role | Hardware |
|------|------|------|----------|
| **hephaestus** | Desktop | Workstation, gaming, writing | RTX 3090, ZSA Moonlander, dual monitors |
| **artemis** | Laptop | Workstation, writing | Lenovo ThinkPad X1 Carbon Gen 12 |

---

## Design Principles & Core Values

1. **Simplicity**
    - Deploying a new user or host should be easy. Declare what you want in just a few lines and let the backend take care of the rest.
    - Sensible defaults are applied automatically, reducing the time each new user or host must spend configuring their own system.
2. **Flexibility**
    - Everything is overrideable. Users and hosts with special requirements or different preferences retain the ability to override the default settings with relative ease.
3. **Extensibility**
    - Certain types of users have shared requirements; for example, developers need access to version control and support for programming languages. Instead of declaring those needs in each user's personal config over and over, the system administrator can assign each user a `role` and add functionality to every relevant user at the same time from just one file.
4. **Transparency**
    - Extensive documentation is extremely important. The codebase and design decisions will (eventually) be thoroughly documented in the project wiki. **This is still a work in progress.** Documentation is next on the to-do list.
    - AI is used openly as a tool while building and maintaining this config — see the AI Usage note below. Nothing here is presented as hand-written that wasn't.

---

## Architecture

### Hub-and-spoke

`flake.nix` is the hub. It defines each host and user as pure data, then hands them to two builder functions:

- **`mkHosts`** builds full NixOS systems (`nixos-rebuild switch`) — system config + Home Manager for all users
- **`mkHomes`** builds standalone Home Manager configs (`home-manager switch`) — just one user's environment, no root required, much faster iteration

Both consume the same host and user definitions and the same pool of modules. The difference is scope: `mkHosts` wires everything; `mkHomes` only wires the user-facing parts.

### The two layers

Configuration is split into two directories based on a simple question: **does the user perceive the change?**

| Layer | Contents | Examples |
|-------|----------|----------|
| **`system/`** | Invisible plumbing the user never directly sees | Bootloader, GPU drivers, kernel params, user account creation, printer drivers |
| **`environment/`** | Things the user sees, feels, or interacts with | Color scheme, keybinds, editor config, terminal, shell prompt, window rules |

Some features straddle both layers — Hyprland needs a NixOS module enabled *and* per-user keybinds configured. These use the **dual-export pattern**: a single file returns `{ nixos = <module>; home = <module>; }`, and the builder functions extract the right part for each context. One file per feature, no duplication.

### Schemas vs backends

The `modules/` directory contains **option schemas only** — it defines *what* can be configured (GPU type, desktop environment, editor preference, user roles, etc.) but doesn't *do* anything. The actual implementation lives in `system/` and `environment/`, which read the schema values and configure the system accordingly. This separation means you can read `modules/` to understand the interface and `system/`/`environment/` to understand the implementation.

### Desktop sessions

Which desktop sessions a host installs is decided by merging lists: each user declares the sessions they want selectable at login (`desktop.environments`), each host declares sessions that should always be available on it (`availableSessions`), and the host enables the union of all of them. A user's per-session Home Manager config (keybinds, bars, window rules) follows their own list. The canonical session names and merge rule live in `lib/sessions.nix`.

### Roles

Users can be assigned roles (`wizard`, `developer`, `gamer`, `filmmaker`, `writer`) which automatically enable relevant features. Role modules live in `modules/userSettings/roles/` and use the dual-export pattern:

- **wizard** — creates the `wizard` group, manages `/etc/nixos` permissions, auto-enables git, adds the `cdn` shell function for quick navigation to `/etc/nixos/`
- **gamer** — enables Steam runtime, installs game clients (Discord, Bolt Launcher)
- **filmmaker** — installs OBS Studio (Nvidia NVENC + PipeWire/Wayland capture, obs-vkcapture game capture, virtual camera) for recording/streaming, plus the Kdenlive and DaVinci Resolve video editors

*Note: the role system is a work in progress. Some roles are defined in the schema but have not yet been implemented on the backend.*

---

## Directory Structure

```
.
├── flake.nix                  # Hub: defines hosts and users as pure data,
│                                wires everything together
├── lib/
│   ├── default.nix            # Single import for all lib utilities (mkHosts, mkHomes, presets)
│   ├── mkHosts.nix            # Builds nixosSystem for each host; detects dual-export modules
│   ├── mkHomes.nix            # Builds standalone homeConfigurations for fast HM iteration
│   ├── sessions.nix           # Desktop session names + host/user availability rules
│   └── presets/               # Hardware preset attrsets (GPUs, keyboards, monitor layouts)
│
├── modules/                   # Option schemas only (no implementation)
│   ├── hostSettings/          # Host-level options (type, role, hardware, display)
│   └── userSettings/          # User-level options (editor, shell, desktop, browser, fonts, roles)
│       └── roles/             # Dual-export role modules (wizard, gamer, writer, etc.)
│
├── system/                    # System-level backend implementation via hostSettings + userSettings
│   ├── boot/                  # Bootloader: GRUB or systemd-boot (via hostSettings.hardware.boot)
│   ├── display/               # Xorg (via hostSettings.hardware.display), Wayland
│   ├── hardware/              # GPU, input devices, networking, printers
│   │   ├── gpu/               # Generic multi-GPU support (Nvidia, AMD, Intel)
│   │   └── inputDevices/      # Keyboard layout, touchpad, ZSA (via hostSettings.hardware)
│   ├── login-manager/         # greetd or SDDM (via hostSettings.loginManager)
│   ├── nix/                   # Nix daemon settings, garbage collection
│   ├── security/              # Security modules & secrets (sops-nix, age keys, etc.)
│   └── users.nix              # Creates user accounts from userSettings (groups, SDDM nickname)
│
├── environment/               # User-level backends (HM modules or dual-export)
│   ├── browser/               # Firefox (HM module, reads userSettings.browser)
│   ├── desktop/               # Hyprland (keybinds, window rules, hyprland.conf), Niri, Plasma (dual-export)
│   ├── dev/                   # Developer tooling - Git config, GitHub CLI, Python/Rust support, etc.
│   ├── editor/                # Emacs + Org-Roam, Nixvim (dual-export)
│   ├── games/                 # Steam, OSRS, Discord (dual-export, gated on "gamer" role)
│   ├── media/                 # OBS Studio (dual-export, gated on "filmmaker" role)
│   ├── services/              # Privacy (VPN/Tor), Syncthing (OSRS sync); Firefly III, OpenVPN stubs
│   ├── shell/                 # Bash, Starship prompt (dual-export)
│   ├── terminal/              # Alacritty (HM module)
│   └── themes/                # Colors, fonts, Stylix, wallpaper management, etc. (dual-export)
│
├── users/                     # Per-user HM module directories
│   ├── hunter/                # packages.nix, services.nix, future overrides (Firefox, etc.)
│   └── ash/                   # packages.nix, services.nix
│
└── hosts/                     # Per-host hardware config and overrides
    ├── hephaestus/
    └── artemis/
```

---

## How It Works

### Adding a host

Define it in `flake.nix` with its settings:

```nix
hostDefs = {
  my-new-host = {
    users = [ "hunter" ];
    stateVersion = "25.11";

    hostSettings = {
      system = "x86_64-linux";
      type = "laptop";
      role = [ "workstation" ];
      loginManager = "sddm";
      availableSessions = [ "plasma" ];   # always available, on top of users' lists
      hardware = {
        boot.loader = "systemd-boot";
        gpu = [ gpuPresets."integrated-intel" ];
        keyboard = {
          layout = "qwerty";
          model = keyboardPresets.lenovoThinkPad."built-in";
        };
      };
    };
  };
};
```

Then create `hosts/my-new-host/` with a `default.nix`, `configuration.nix` (host-specific overrides), and `hardware.nix` (generated by `nixos-generate-config`).

Once the host has been deployed, decrypt the master key with your password to enable editing secrets:

```
nix-shell -p age --run \
  'mkdir -p ~/.config/sops/age && \
  age -d -o ~/.config/sops/age/keys.txt system/security/secrets/master-key.age'
```

Generate an age key using `ssh-to-age`:

```
nix-shell -p ssh-to-age --run \
  'ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub'
```

This outputs an age public key like `age1qx...`. Add the public key to `.sops.yaml` under the top-level `keys:` block:

```
keys:
  # Per-user keys
  - &hunter age1xxxxxxxx...

  # Per-host keys
  - &hephaestus age1yyyyyyy...
  - &artemis age1zzzzzz...
  - &[new-hostname] age1aaaaaa...
```

Then add the new host to the `creation_rules` block.

### Adding a user

Define the user's identity and preferences in `flake.nix`:

```nix
userDefs = {
  my-user = {
    nickname    = "My User";
    fullName    = "My Name";
    email       = "me@example.com";
    role        = [ "wizard" "developer" ];
    shell       = "bash";
    editor      = { terminal = "vim"; gui = "emacs"; };
    desktop     = {
      environments = [ "plasmax11" "plasma" ];
      colorScheme  = "electro-swing";
    };
    browser.name = "firefox";
  };
};
```

Then create `users/my-user/` with a `default.nix` that imports `packages.nix` and `services.nix` for user-specific packages and HM services. Add the username to a host's `users` list in `flake.nix`. The system automatically creates the user account, sets up Home Manager, and applies all environment modules based on the user's preferences and roles.

Once the user has been created, hash the user's password and add it to `system/security/secrets/secrets.yaml`:

```
nix-shell -p libxcrypt sops age --run bash

# Generate a hashed password (will prompt for input):
mkpasswd -m sha-512 -R 500000

# Add the hashed password to `.../secrets.yaml`
sops system/security/secrets/secrets.yaml
```

Generate a personal age key for the user:

```
nix-shell -p sops age xclip --run bash

# Generate the age key:
mkdir -p ~/.config/sops/age && age-keygen -o ~/.config/sops/age/keys.txt

# Add the public key to the clipboard for easy copy-paste:
awk '/^# public key:/ {print $NF}' ~/.config/sops/age/keys.txt | xclip -selection c
```

Then add the resulting public key to `.sops.yaml` as in the section above ("Adding a host").

Allow the user's key to decrypt existing secrets:

```
nix-shell -p sops age --run \
  'sops updatekeys system/security/secrets/secrets.yaml'
```

Finally, declare the user's secret in `system/security/sops.nix`.

*Note: make sure to use the format `[username]-hashed-password` in `secrets.yaml` and `sops.nix` so the user account creation function can find it properly.*

### Two rebuild paths

```bash
# Full system + all users' Home Manager (requires root)
sudo nixos-rebuild switch --flake .#hephaestus

# Just one user's Home Manager (no root, fast)
home-manager switch --flake .#hunter@hephaestus
```

---

## Project History

This configuration has been my daily driver and learning project since **July 2022**. The commit history tells the story:

**2022 - 2025** — Built the initial configuration from scratch: GRUB and systemd-boot setup, Nvidia GPU configuration, Hyprland and Plasma desktop environments, SDDM and greetd login managers, Xorg dual-monitor support, Home Manager integration, Starship shell prompt, Alacritty terminal, package management, and all the iterative debugging that comes with learning NixOS. All of this work was done manually.

**Early 2026** — Added Emacs configuration (Evil mode, Org-Roam, Magit, capture templates), printer support, hardware monitoring tools (LACT, nvtop), development toolchains (Rust, Python), and continued refining the system. Also began planning a structural rework to support multi-host deployment and faster iteration — the configuration had grown organically and needed a more principled architecture.

**April - May 2026** — Executed the structural rework (hub-and-spoke, dual-export modules, `mkHosts` / `mkHomes`) on the `structural-rework` branch and merged it into `master`, with AI assistance — see the AI Usage note below. Also added `sops-nix` secrets management, a custom live graphical installer ISO, and the `artemis` laptop host.

**May 2026 - present** — Ongoing iteration with AI as a standard part of the toolkit: package and desktop refinements, the NixOS 26.05 upgrade, and continued work toward a Hyprland + Quickshell daily driver.

---

## What's Next

- **Primary goal — the daily-driver desktop:** a Hyprland (tiling/scrolling) setup with a Quickshell topbar, widgets, and an integrated search/launch bar, polished enough to replace Plasma as the everyday environment
- Adopt Emacs (likely a lightly-customized Doom or Spacemacs) for Org-Roam and Magit — currently daily-driving nvim
- Make monitor config dynamic instead of hardcoded in hyprland.lua, add monitor presets
- Create a project wiki for this repository - write extensive & thorough documentation
- Implement easy-to-use shell wrapper functions for `nixos-rebuild` and `home-manager switch`
- Implement remaining role modules (developer, writer) with role-specific defaults
- Create & deploy a new server host for use as a personal NAS/web server
- Automate garbage collection, flake updates, and file backups
- Declaratively configure Firefox preferences - default values for all users & user-specific overrides
- Wire remaining environment/ modules to userSettings (remaining shell options, desktop fine-tuning)
- Wire remaining system/ modules to hostSettings (inputDevices, display, login-manager refinements)

---

## AI Usage

I use AI (Claude Code) as an ordinary tool while building and maintaining this configuration. I'd rather say so plainly than pretend otherwise.

Why I'm fine with that here: this is a personal system configuration, not a product or a coding portfolio. Its job is to make my machines work the way I want them to. Getting there efficiently—with AI, upstream modules, community configs, and whatever else the ecosystem offers—is the point, not a shortcut I feel any need to apologize for.

Two lines I hold to:

- **Credit where it's due.** Anything adapted from someone else's work is attributed, never passed off as my own.
- **No false authorship.** I don't present code as hand-written by me when it wasn't.

The pre-2026 configuration—roughly four years of it—was built by hand while I learned NixOS, and that foundation is mine. The 2026 structural rework and the ongoing work since lean on AI assistance.
