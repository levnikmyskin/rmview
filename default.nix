{
  lib,
  python3Packages,
  wrapQtAppsHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "rmview";
  version = "3.1.3";
  pyproject = true;

  src = ./.;

  nativeBuildInputs = with python3Packages; [
    pyqt5
    setuptools
    wrapQtAppsHook
  ];
  propagatedBuildInputs = with python3Packages; [
    pyqt5
    paramiko
    twisted
    pyjwt
    pyopenssl
    service-identity
    sshtunnel
  ];

  preBuild = ''
    pyrcc5 -o src/rmview/resources.py resources.qrc
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Fast live viewer for reMarkable 1 and 2";
    mainProgram = "rmview";
    homepage = "https://github.com/bordaigorl/rmview";
    license = licenses.gpl3Only;
    maintainers = [maintainers.nickhu];
  };
}
