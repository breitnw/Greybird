{
  description = "Desktop Suite for Xfce";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          greybird = colorScheme:
            pkgs.stdenvNoCC.mkDerivation {
              pname = "greybird";
              version = "3.23.4";

              src = ./.;

              preConfigure = with colorScheme.palette; ''
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

          default = greybird {
            slug = "tokyo-night-dark";
            name = "Tokyo Night Dark";
            palette = {
              base00 = "1A1B26";
              base01 = "16161E";
              base02 = "2F3549";
              base03 = "444B6A";
              base04 = "787C99";
              base05 = "A9B1D6";
              base06 = "CBCCD1";
              base07 = "D5D6DB";
              base08 = "C0CAF5";
              base09 = "A9B1D6";
              base0A = "0DB9D7";
              base0B = "9ECE6A";
              base0C = "B4F9F8";
              base0D = "2AC3DE";
              base0E = "BB9AF7";
              base0F = "F7768E";
            };
          };
        };
      });
}
