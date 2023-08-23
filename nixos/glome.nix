{ config, lib, pkgs, ... }:

let
  cfg = config.security.glome-login;

  glomeConfigIni = pkgs.writeText "glome-config.ini" ''
    [service]
    key = ${cfg.publicKey}
    key-version = 1
  '';
in {
  options.security.glome-login = with lib; {
    enable = mkEnableOption "low dependency TTY login using GLOME";

    publicKey = mkOption {
      type = types.str;
      description = ''
        Hex-encoded public key for which GLOME authentication tokens will be
        authorized to log in.
      '';
      example = "0BADC0DE0BADC0DE0BADC0DE0BADC0DE0BADC0DE0BADC0DE0BADC0DE0BADC0DE";
    };

    urlPrefix = mkOption {
      type = types.str;
      default = "";
      description = ''
        URL prefix to display before authentication tokens, if using a server
        to respond to GLOME requests and generate responses.
      '';
      example = "https://my.glome.service";
    };
  };

  config = lib.mkIf cfg.enable {
    services.getty = {
      loginProgram = "${pkgs.glome}/bin/glome-login";
      loginOptions = "-l ${pkgs.shadow}/bin/login -c ${glomeConfigIni} -- \\u";
    };
  };
}
