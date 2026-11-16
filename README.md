# Emacs Configuration

A single-file Emacs setup (`init.el`) for C/C++ development on Windows. It provides:

- Modal editing with Vim keybindings (Evil)
- A modern completion stack (Vertico, Corfu, Orderless)
- Tree-sitter syntax highlighting for C and C++
- Language Server Protocol support through `lsp-mode` and `clangd`
- A dark theme, icons and a Nerd Font

Packages are managed with `use-package` and installed automatically from MELPA on first launch.

## Contents

- [Host requirements](#host-requirements)
- [Installation](#installation)
- [What the configuration does](#what-the-configuration-does)
- [Packages](#packages)
- [Key bindings and commands](#key-bindings-and-commands)
- [Project requirements](#project-requirements)
- [Troubleshooting](#troubleshooting)

## Host requirements

These must be installed on the machine **before** the configuration works fully.

| Requirement | Why it is needed | Notes |
|---|---|---|
| **Emacs 29.1 or newer**, built with tree-sitter | `treesit`, `c-ts-mode`, `c++-ts-mode`, built-in `use-package` | Check with `M-: (treesit-available-p)`, which should return `t`. The official GNU Windows builds include tree-sitter support. |
| **LLVM (clangd)** | Language server for C/C++ | The config expects `C:/Program Files/LLVM/bin/clangd.exe`. Install with `winget install LLVM.LLVM`. clang-tidy is built into clangd. |
| **FiraCode Nerd Font** | Default frame font (`FiraCode Nerd Font-14`) | Install from [nerdfonts.com](https://www.nerdfonts.com/font-downloads) and restart Emacs. |
| **Symbols Nerd Font Mono** | Icons shown by `nerd-icons` and `nerd-icons-dired` | Run `M-x nerd-icons-install-fonts` once, then install the downloaded `.ttf` files manually on Windows. |
| **Git** | Used by `treesit-install-language-grammar` to clone the grammars | Must be on `PATH`. |
| **C and C++ compiler** (`cc`/`c++`, e.g. MinGW-w64 gcc from MSYS2) | Used to compile the tree-sitter grammars | Needed only for the one-time grammar build. Alternatively, drop prebuilt grammar libraries into `~/.emacs.d/tree-sitter/`. |
| **Internet access** | Downloads packages from MELPA and grammars from GitHub | Needed on first launch and for grammar installation. |

Optional, for building the projects you edit:

- **CMake** and a build tool such as **Ninja**
- **Visual Studio** (MSVC) or another compiler toolchain

## Installation

1. Install the host requirements above.
2. Copy `init.el` to your Emacs configuration directory:
   - `%APPDATA%\.emacs.d\init.el`, or
   - `%USERPROFILE%\.emacs.d\init.el`
3. Start Emacs. On the first launch it downloads and installs all packages, which can take a minute or two.
4. Install the tree-sitter grammars (once):
   ```
   M-x treesit-install-language-grammar RET c RET
   M-x treesit-install-language-grammar RET cpp RET
   ```
   Accept the default URLs. The repositories are preconfigured in `init.el`.
5. Install the icon fonts: `M-x nerd-icons-install-fonts`.
6. Restart Emacs.

If the `clangd.exe` path differs on your machine, edit `lsp-clients-clangd-executable` in the `lsp-mode` block.

## What the configuration does

### General

- **Encoding:** sets the language environment to UTF-8.
- **Package sources:** adds MELPA alongside the default archives and initializes the package system.
- **`use-package`:** `use-package-always-ensure` is on, so every `use-package` form installs its package automatically. Built-in features use `:ensure nil`.
- **Customize file:** output from the Customize interface goes to `custom.el` in your Emacs directory instead of cluttering `init.el`.
- **Backups and auto-save:** backup files go to `backups/` and auto-save files to `auto-save/` inside your Emacs directory, so they never appear next to your source files. Lock files (`.#file`) are disabled.
- **Server:** starts the Emacs server if it isn't running, so files can be opened with `emacsclient`.

### Appearance

- **Font:** FiraCode Nerd Font at size 14, set for all new frames.
- **Theme:** `ef-owl` from `ef-themes`.
- **Icons:** `nerd-icons` everywhere, with file icons in Dired.

### Editing

- **Evil mode** is enabled globally for Vim-style editing.

### Completion

- **Minibuffer:** Vertico provides a vertical completion list, and `savehist` remembers your minibuffer history between sessions.
- **In-buffer:** Corfu shows a completion popup while typing (global mode). `Tab` completes when the line is already indented (`tab-always-indent 'complete`).
- **Matching:** Orderless matches space-separated parts of your input in any order. Files use `partial-completion` so path completion like `/u/l/b` still works.
- **Minibuffer settings:** recursive minibuffers are enabled, the minibuffer prompt is read-only and the cursor cannot enter it (`cursor-intangible-mode`), the right-click context menu is enabled, and `M-x` only lists commands relevant to the current mode.
- **Which-key:** shows available key bindings after you type a prefix.

### Tree-sitter (C and C++)

- Registers the grammar repositories for `c` and `cpp`.
- Remaps `c-mode`, `c++-mode` and `c-or-c++-mode` to `c-ts-mode`, `c++-ts-mode` and `c-or-c++-ts-mode`, so the usual extensions (`.c`, `.cpp`, `.h`, ...) open with tree-sitter automatically.
- Sets `treesit-font-lock-level` to 4, the most detailed highlighting.

### LSP

- **Performance:** raises `gc-cons-threshold` to 100 MB and `read-process-output-max` to 1 MB, as recommended by `lsp-mode`.
- **Activation:** `lsp-deferred` starts the language server in `c-ts-mode` and `c++-ts-mode` buffers.
- **Prefix:** all LSP commands live under `C-c l`, with which-key integration.
- **Completion:** `lsp-mode` does not configure its own completion UI (`lsp-completion-provider :none`). Corfu and Orderless handle it.
- **clangd arguments:**
  - `--background-index` indexes the project in the background
  - `--clang-tidy` enables clang-tidy diagnostics
  - `--header-insertion=iwyu` inserts headers following include-what-you-use rules
  - `--completion-style=detailed` shows full signatures in completions
  - `--compile-commands-dir=build` reads `compile_commands.json` from `build/`
- **Diagnostics:** `flycheck` is not installed, so `lsp-mode` reports diagnostics through the built-in Flymake.
- **UI:** `lsp-ui` shows documentation popups at point and sideline diagnostics. `lsp-treemacs` provides `lsp-treemacs-errors-list`.

## Packages

### Installed from MELPA / GNU ELPA

| Package | Purpose |
|---|---|
| `ef-themes` | Theme collection (`ef-owl` is loaded) |
| `nerd-icons` | Icon set based on Nerd Fonts |
| `nerd-icons-dired` | Icons in Dired buffers |
| `evil` | Vim emulation |
| `vertico` | Vertical minibuffer completion UI |
| `corfu` | In-buffer completion popup |
| `orderless` | Space-separated, out-of-order completion matching |
| `which-key` | Key binding hints (built into Emacs 30+, installed from GNU ELPA on 29) |
| `lsp-mode` | Language Server Protocol client |
| `lsp-ui` | Documentation popups and sideline diagnostics |
| `lsp-treemacs` | Tree view of LSP errors; also installs `treemacs` and other dependencies |

### Built-in features that are configured

| Feature | Purpose |
|---|---|
| `package` | Package manager, with MELPA added |
| `use-package` | Declarative package configuration (built in since Emacs 29) |
| `server` | Emacs server for `emacsclient` |
| `savehist` | Persistent minibuffer history |
| `treesit` | Tree-sitter support |
| `emacs` | Core settings (minibuffer, completion, context menu) |

## Key bindings and commands

| Key / command | Action |
|---|---|
| `C-c l` | LSP command prefix (rename, code actions, find references, ...) |
| `M-x treesit-install-language-grammar` | Build and install a tree-sitter grammar |
| `M-x nerd-icons-install-fonts` | Download the icon fonts |
| `M-x lsp-treemacs-errors-list` | Show diagnostics in a Treemacs tree |
| `M-x lsp-workspace-restart` | Restart clangd (for example after regenerating `compile_commands.json`) |
| `Tab` | Complete at point when the line is already indented |

## Project requirements

For clangd to understand a CMake project, `compile_commands.json` must exist in the project's `build/` directory:

```
cmake -G Ninja -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

If you build with MSVC and Ninja, run CMake from a shell with the MSVC environment loaded (a Developer Command Prompt, or `vcvars64.bat`), otherwise the compiler cannot find the standard library headers.

## Troubleshooting

- **"Unable to find installed server supporting this file":** clangd was not found. Check that the path in `lsp-clients-clangd-executable` exists, or add `C:\Program Files\LLVM\bin` to `PATH` and restart Emacs completely, including any Emacs daemon.
- **"Cannot activate tree-sitter, because language grammar for c is unavailable":** the grammars are not installed. Follow step 4 of the installation.
- **Icons show as empty boxes:** run `M-x nerd-icons-install-fonts` and install the fonts in Windows, then restart Emacs.
- **STL1000 "Unexpected compiler version" in the editor:** the installed LLVM/clangd is older than your MSVC standard library expects. Update LLVM.
- **Wrong diagnostics or missing symbols:** check that `build/compile_commands.json` exists and restart the language server with `M-x lsp-workspace-restart`.
- **Package installation errors on first launch:** run `M-x package-refresh-contents` and restart Emacs.
