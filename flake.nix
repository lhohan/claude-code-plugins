{
  description = "Claude Code plugins - hanlho-plugins marketplace";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            jq
          ];

          shellHook = ''
            echo "🔧 Claude Code plugins dev environment loaded"
            echo "jq version: $(jq --version)"
          '';
        };
      }
    );
}
