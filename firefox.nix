{ pkgs, ... }:
let 
  settings = {
    "browser.startup.page" = 3; # Resume previous session: http://kb.mozillazine.org/index.php?title=Browser.startup.page&redirect=no

    # The following settings are loosely based on:
    # https://github.com/gvolpe/nix-config/blob/master/home/programs/browsers/firefox.nix
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
    multi-account-containers
  ];
  kv-extensions = with pkgs.nur.repos.rycee.firefox-addons; base-extensions ++ [
    dashlane
  ];
  bekk-extensions = with pkgs.nur.repos.rycee.firefox-addons; base-extensions ++ [
    bitwarden
    raindropio
  ];

  search = {
    force = true;
    default = "DuckDuckGo";
    order = [ "DuckDuckGo" "Google" ];
    engines = {
      "Google".metaData.alias = "!g";
      "GitHub code search" = {
        urls = [{
          template = "https://github.com/search";
          params = [
            { name = "type"; value = "code"; }
            { name = "q"; value = "{searchTerms}"; }
          ];
        }];
        iconUpdateURL = "https://github.com/favicon.ico";
        updateInterval = 24 * 60 * 60 * 1000; # every day
        definedAliases = [ "!gc" ];
      };
      "GitHub repository search" = {
        urls = [{
          template = "https://github.com/search";
          params = [
            { name = "type"; value = "repositories"; }
            { name = "q"; value = "{searchTerms}"; }
          ];
        }];
        iconUpdateURL = "https://github.com/favicon.ico";
        updateInterval = 24 * 60 * 60 * 1000; # every day
        definedAliases = [ "!gr" ];
      };
      "Nix Packages" = {
        urls = [{
          template = "https://search.nixos.org/packages";
          params = [
            { name = "type"; value = "packages"; }
            { name = "query"; value = "{searchTerms}"; }
          ];
        }];
        icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "!np" ];
      };
      "NixOS Wiki" = {
        urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
        iconUpdateURL = "https://nixos.wiki/favicon.png";
        updateInterval = 24 * 60 * 60 * 1000; # every day
        definedAliases = [ "!nw" ];
      };
      "Home Manager options" = {
        urls = [{ template = "https://home-manager-options.extranix.com/?query={searchTerms}"; }];
        iconUpdateURL = "https://home-manager-options.extranix.com/images/favicon.png";
        updateInterval = 24 * 60 * 60 * 1000; # every day
        definedAliases = [ "!hm" ];
      };
      "Bing".metaData.hidden = true;
    };
  };
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
        extensions = {
          packages = bekk-extensions;
        };
        inherit settings search;
        containersForce = true; # https://github.com/nix-community/home-manager/pull/5057
        containers = {
          personal = {
            id = 11;
            icon = "fingerprint";
            color = "purple";
          };
          fb = {
            id = 12;
            icon = "fence";
            color = "blue";
          };
          bekk = {
            id = 21;
            icon = "circle";
            color = "red";
          };
        };
      };
      ff-default = {
        id = 1;
        name = "ff-default";
        extensions = {
          packages = kv-extensions;
        };
        inherit settings search;
      };
    };
  };
}
