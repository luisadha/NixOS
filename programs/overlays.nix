{ pkgs, inputs, system, lib, getDefaultNixs, getNixs, basename, genImports, ... }:let
  gnome-overlay = self: super: {
    gnome = super.gnome.overrideScope (gself: gsuper: {
      nautilus = gsuper.nautilus.overrideAttrs (nsuper: {
        buildInputs = nsuper.buildInputs ++ (with pkgs.gst_all_1; [
          gst-plugins-good
          gst-plugins-bad
        ]);
      });
    });
  };
  git-overlay = _final: prev: {
    git = prev.git.override { withLibsecret = true; };
  };
  nixpkgs-overlay = _final: _prev: {
    _23_11 = import inputs.nixpkgs-23_11 {
      inherit system;
      config.allowUnfree = true;
    };
    _24_05 = import inputs.nixpkgs-24_05 {
      inherit system;
      config.allowUnfree = true;
    };
    _master = import inputs.nixpkgs-master {
      inherit system;
      config.allowUnfree = true;
    };
  };

  custom-overlay = _final: _prev: {
    custom = builtins.foldl' (acc: curr: {
        "${curr}" = pkgs.callPackage (lib.path.append ./customs curr) { };
      } // acc) {} (getDefaultNixs ./customs);
  };

  custom-closure = _final: _prev: let
    toList = { attr, prefix, base ? ./. }: 
      builtins.map (x: { 
        path = base + ("/" + x); 
        prefix = if prefix == "" then x else prefix + ("/" + x);
        type = builtins.getAttr x attr;
      }) (builtins.attrNames attr);
    # filtered = list: builtins.filter (val: (builtins.getAttr "type" val) == "regular") list;
    condition = val: 
      let
        type = builtins.getAttr "type" val;
        path = builtins.getAttr "path" val;
        prefix = builtins.getAttr "prefix" val;
      in
      if type == "regular" then
        prefix
      else
        all { dir = path; prefix = prefix; };
    all = { dir, prefix }: builtins.map condition (toList {
      attr = builtins.readDir dir;
      prefix = prefix;
      base = dir;
    });
  in  rec {
    inherit getDefaultNixs getNixs genImports basename;
    tree-path = var: let
      dir = if builtins.isAttrs var && builtins.hasAttr "dir" var then 
          builtins.getAttr "dir" var 
        else var;
      prefix = if builtins.isAttrs var && builtins.hasAttr"prefix" var then
          builtins.getAttr "prefix" var 
        else dir;
    in  lib.flatten (all { dir = dir; prefix = prefix; });
    readEnv = file: builtins.foldl' (acc: curr: {
      "${builtins.elemAt curr 0}" = "${builtins.elemAt curr 1}";
    } // acc) {} (
      builtins.map (x: builtins.elemAt (builtins.split "^([^= ]+)=(.*)$" x) 1) (builtins.filter (x: x != "") (lib.splitString "\n" (builtins.readFile file)))); # Just to parse .env file to mapAttrs
    getEnv = entity: readEnv (lib.path.append ../secrets "${entity}.env");
    genPaths = home: paths: builtins.foldl' (acc: curr: [ "${home}/${curr}/bin" ] ++ acc) [] (lib.reverseList paths);
  };

  package-overlay = final: prev: {
    qutebrowser = prev.qutebrowser.override { enableWideVine = true; }; 
  };

in {
  nixpkgs.overlays = [
    gnome-overlay
    git-overlay
    nixpkgs-overlay
    custom-closure
    custom-overlay
    package-overlay
    inputs.nixgl.overlay
  ];
}
