
dots
├── LAYOUT.md             This file
├── setup.clj             Setup helper
└── modules               All the programs
    ├── nvim                    Neovim module
    │   ├── config              Neovim configuration
    │   │   ├── init.fnl        Initialization file
    │   │   ├── core
    │   │   │   ├── binds.fnl   Keybind mappings
    │   │   │   └── autocmd.fnl Autocommands
    │   │   ├── plugins.fnl     Add plugins
    │   │   └── plugins         Plugin configuration directory
    │   │       └── ....fnl     File for each plugin config
    │   └── setup.clj           Specific program installer file 
    └── program                 Subdir for each program
        ├── config              Contains the programs config
        └── setup.clj           Specific program installer file


