{ stdenv, lib
, fetchFromGitHub, meson, ninja, pkg-config
, glib, openssl, pam
, glome-src }:

stdenv.mkDerivation {
  pname = "glome";
  version = glome-src.rev;

  src = glome-src;

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ openssl pam ];
  checkInputs = [ glib ];

  outputs = [ "out" "dev" ];
  postPatch = "patchShebangs .";

  doCheck = true;

  meta = with lib; {
    description = "A protocol providing secure authentication and authorization for low dependency environments";
    homepage = "https://github.com/google/glome";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ delroth ];
  };
}

