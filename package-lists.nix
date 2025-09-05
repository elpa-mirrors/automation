{
  lib,
  runCommand,
  elisp-helpers,
  gnu-elpa,
  nongnu,
}:
let
  inherit (elisp-helpers.lib.makeLib { inherit lib; }) parseElpaPackages;

  makePackageList =
    src:
    lib.pipe (parseElpaPackages (builtins.readFile src)) [
      builtins.attrNames
      (builtins.concatStringsSep "\n")
    ];
in
runCommand "package-lists"
  {
    gnuElpa = makePackageList gnu-elpa;
    nongnu = makePackageList nongnu;
    passAsFile = [
      "gnuElpa"
      "nongnu"
    ];
  }
  ''
    mkdir -p $out
    install -m 644 $gnuElpaPath $out/elpa.txt
    install -m 644 $nongnuPath $out/nongnu.txt
  ''
