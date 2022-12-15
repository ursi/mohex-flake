{ inputs =
    { nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      src = { url = "github:cgao3/benzene-vanilla-cmake"; flake = false; };
      utils.url = "github:ursi/flake-utils/8";
    };

  outputs = inputs:
    inputs.utils.apply-systems { inherit inputs; }
      ({ pkgs, ...}:
         let p = pkgs; in
         { packages.default =
             p.stdenv.mkDerivation
               { name = "mohex";
                 inherit (inputs) src;
                 nativeBuildInputs = [ p.cmake ];
                 buildInputs = [ p.boost p.db ];

                 installPhase =
                   ''
                   mkdir -p $out/bin
                   find src -executable -type f | xargs cp -t $out/bin
                   cp -r $src/share/. $out/bin
                   '';
               };
         }
      );
}
