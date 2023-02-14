{ inputs =
    { mohex = { url = "github:cgao3/benzene-vanilla-cmake"; flake = false; };
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      utils.url = "github:ursi/flake-utils/8";
    };

  outputs = inputs:
    inputs.utils.apply-systems { inherit inputs; }
      ({ pkgs, ...}:
         let p = pkgs; in
         { packages.default =
             p.stdenv.mkDerivation
               { name = "mohex";
                 src = inputs.mohex;
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
