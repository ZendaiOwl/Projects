{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs.buildPackages; [
    	bash shellcheck micro gitFull git-lfs jq wget curl xz gawk gnupg socat
    	coreutils-full binutils dateutils cpufrequtils elfutils sysvinit lm_sensors
    	rustc rustup rustfmt cargo cargo-c cargo-asm cargo-cross cargo-binutils
    	rust-bindgen rust-cbindgen rust-analyzer rust-audit-info rust-code-analysis
    ];
}
