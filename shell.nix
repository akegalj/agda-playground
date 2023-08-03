{ pkgs ? import <nixpkgs> {} }:

with pkgs; mkShell {
  buildInputs = [
    (agda.withPackages (p: with p; [
      p.standard-library
    ]))
    (emacsWithPackages (p: with p; [
      emacsPackages.agda2-mode
    ]))
  ];
}