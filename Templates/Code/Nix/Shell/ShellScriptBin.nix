{ pkgs }:

pkgs.writeShellScriptBin "script-name" ''
  echo '{"message": "Hello World"}' | {pkgs.jq}/bin/jq
''
