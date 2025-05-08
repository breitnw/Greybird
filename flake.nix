{
  description = "Desktop Suite for Xfce";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          greybird-with-accent = accent-color:
            pkgs.stdenvNoCC.mkDerivation rec {
              pname = "greybird";
              version = "3.23.4";

              src = ./.;

              theme-name = "greybird-generated";

              preConfigure = ''
                # rename Greybird to theme-name to prevent conflicts
                sed -i -e 's\Greybird\${theme-name}\g' \
                       ./light/index.theme
                sed -i -e 's\Greybird\${theme-name}\g' \
                       ./dark/index.theme
                mv light/Greybird.emerald light/${theme-name}.emerald
                mv dark/Greybird.emerald dark/${theme-name}.emerald
                find . -type f -name 'meson.build' \
                       | xargs sed -i -e 's\Greybird\${theme-name}\g'

                # replace the accent color
                sed -i -e 's\#398ee7\#${accent-color}\g' \
                       ./light/gtk-3.0/_colors.scss
              '';

              nativeBuildInputs = with pkgs; [ meson ninja pkg-config sassc ];
              buildInputs = with pkgs; [ gdk-pixbuf librsvg ];
              propagatedUserEnvPkgs = with pkgs; [ gtk-engine-murrine ];
              passthru.updateScript = pkgs.gitUpdater { rev-prefix = "v"; };
            };

          greybird-with-theme = colorScheme:
            pkgs.stdenvNoCC.mkDerivation {
              pname = "greybird";
              version = "3.23.4";

              src = ./.;

              preConfigure = with colorScheme.palette; ''
                # rename Greybird to theme-name to prevent conflicts
                sed -i -e 's\Greybird\${theme-name}\g' \
                       ./light/index.theme
                sed -i -e 's\Greybird\${theme-name}\g' \
                       ./dark/index.theme
                mv light/Greybird.emerald light/${theme-name}.emerald
                mv dark/Greybird.emerald dark/${theme-name}.emerald
                find . -type f -name 'meson.build' \
                       | xargs sed -i -e 's\Greybird\${theme-name}\g'

                # replace the colors
                sed -i -e 's\#fcfcfc\lighten(#${base01}, 3%)\g' \
                       -e 's\#2d2e30\lighten(#${base01}, 3%)\g' \
                       -e 's\white\#${base06}\g' \
                       -e 's\#212121\#${base06}\g' \
                       -e 's\#cecece\lighten(#${base01}, 8%)\g' \
                       -e 's\#3b3e3f\lighten(#${base01}, 8%)\g' \
                       -e 's\#3c3c3c\#${base05}\g' \
                       -e 's\#eeeeec\#${base05}\g' \
                       -e 's\#398ee7\#${base0E}\g' \
                       -e 's\#eeeeee\#${base05}\g' \
                       -e 's\#686868\#${base02}\g' \
                       -e 's\#dae0e6\lighten(#${base01}, 5%)\g' \
                       -e 's\#222\lighten(#${base01}, 5%)\g' \
                       ./light/gtk-3.0/_colors.scss
              '';

              nativeBuildInputs = with pkgs; [ meson ninja pkg-config sassc ];

              buildInputs = with pkgs; [ gdk-pixbuf librsvg ];

              propagatedUserEnvPkgs = with pkgs; [ gtk-engine-murrine ];

              passthru.updateScript = pkgs.gitUpdater { rev-prefix = "v"; };
            };

          default = greybird-with-accent "00beef";
        };
      });
}
