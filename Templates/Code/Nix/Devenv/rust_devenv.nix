{ pkgs, ... }: {
    languages.rust = {
        enable = true;
        # https://devenv.sh/reference/options/#languagesrustversion
        version = "nightly";
    };
    
    pre-commit.hooks = {
        clippy.enable = true;
        rustfmt.enable = true;
    };
}
