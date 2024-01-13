{ pkgs, ... }:
let 
  # Loosely based on https://github.com/gvolpe/nix-config/blob/master/home/programs/browsers/firefox.nix
  settings = {
    "app.normandy.first_run" = false;
    # Updates/nix specific
    "app.update.channel" = "default"; # Disable updates
    "extensions.update.enabled" = false;
    "browser.shell.checkDefaultBrowser" = false;

    ## Privacy ##
    "app.shield.optoutstudies.enabled" = false;
    "browser.contentblocking.category" = "standard"; # "strict"
    "privacy.donottrackheader.enabled" = true;

    ## Telemetry ##
    # disable new data submission
    "datareporting.policy.dataSubmissionEnabled" = false;
    # disable Health Reports
    "datareporting.healthreport.uploadEnabled" = false;
    # 0332: disable telemetry
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    # disable Telemetry Coverage
    "toolkit.telemetry.coverage.opt-out" = true; # [HIDDEN PREF]
    "toolkit.coverage.opt-out" = true; # [FF64+] [HIDDEN PREF]
    "toolkit.coverage.endpoint.base" = "";
    # disable PingCentre telemetry (used in several System Add-ons) [FF57+]
    "browser.ping-centre.telemetry" = false;
    # disable Firefox Home (Activity Stream) telemetry
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "toolkit.telemetry.reportingpolicy.firstRun" = false;
    "toolkit.telemetry.shutdownPingSender.enabledFirstsession" = false;
    "browser.vpn_promo.enabled" = false;
  };

  # Extensions from this list: https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/addons.json
  base-extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
  ];
  kv-extensions = with pkgs.nur.repos.rycee.firefox-addons; base-extensions ++ [
    dashlane
  ];
  bekk-extensions = with pkgs.nur.repos.rycee.firefox-addons; base-extensions ++ [
    bitwarden
    raindropio
  ];
in
{
  # Install both firefox and developer edition
  # -bin version are used from an overlay for darwin
  # Firefox is installed separately, but profiles for both are managed below
  home.packages = [
    pkgs.firefox-bin
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition-bin;
    profiles = {
      bekk = {
        id = 0;
        name = "bekk";
        isDefault = true;
        extensions = bekk-extensions;
        inherit settings;
      };
      ff-default = {
        id = 1;
        name = "ff-default";
        extensions = kv-extensions; 
        inherit settings;
      };
    };
  };
}
