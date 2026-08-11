{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in
  lib.mkIf cfg.system.graphics (lib.mkMerge [
    {
      programs.firefox = let
        firefox-addons = inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.rycee.firefox-addons;
      in {
        enable = true;

        policies = {
          DNSOverHTTPS = {
            Enabled = true;
            ProviderURL = "https://security.cloudflare-dns.com/dns-query";
            Locked = true;
          };
          HardwareAcceleration = true;
          DisableTelemetry = true;
          DisablePasswordReveal = true;
          OfferToSaveLogins = false;
          ExtensionUpdate = false; # extensions should only be updated through nix, as defined below
          UseSystemPrintDialog = true;
          HttpsOnlyMode = "force_enabled";
        };

        profiles.ryan = {
          search = {
            force = true;
            default = "google";
            privateDefault = "ddg";
            order = ["google" "ddg"];
          };
          extensions = {
            force = true; # make sure that all extensions are declarative
            packages = with firefox-addons;
              [
                ublock-origin-upstream
                skip-redirect
                sponsorblock
                don-t-fuck-with-paste
                return-youtube-dislikes
                multi-account-containers
                darkreader
                github-file-icons
                lovely-forks
              ]
              ++ lib.optionals cfg.system.isLowRam [auto-tab-discard];
            settings = {
              "uBlock0@raymondhill.net" = {
                force = true;
                settings = let
                  enabledImportedLists = [
                    "https://www.i-dont-care-about-cookies.eu/abp/"
                    "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
                  ];
                in {
                  uiAccentCustom = true;
                  externalLists = lib.concatLines enabledImportedLists;
                  importedLists = enabledImportedLists;
                  selectedFilterLists =
                    [
                      "user-filters"
                      "ublock-filters"
                      "ublock-badware"
                      "ublock-privacy"
                      "ublock-quick-fixes"
                      "ublock-unbreak"
                      "easylist"
                      "easyprivacy"
                      "urlhaus-1"
                      "plowe-0"
                      "fanboy-cookiemonster"
                      "ublock-cookies-easylist"
                      "adguard-cookies"
                      "ublock-cookies-adguard"
                    ]
                    ++ enabledImportedLists;
                };
              };
              "github-forks-addon@musicallyut.in" = {
                force = true;
                permissions = ["*://github.com/*" "*://api.github.com/*" "storage"];
              };
            };
          };
          containers = {
            Personal = {
              id = 1;
              icon = "fingerprint";
              color = "blue";
            };
            "Work/School" = {
              id = 2;
              icon = "briefcase";
              color = "red";
            };
          };
          settings = {
            # Disable irritating first-run stuff
            "browser.disableResetPrompt" = true;
            "browser.download.panel.shown" = true;
            "browser.feeds.showFirstRunUI" = false;
            "browser.messaging-system.whatsNewPanel.enabled" = false;
            "browser.rights.3.shown" = true;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.shell.defaultBrowserCheckCount" = 1;
            "browser.startup.homepage_override.mstone" = "ignore";
            "browser.uitour.enabled" = false;
            "startup.homepage_override_url" = "";
            "trailhead.firstrun.didSeeAboutWelcome" = true;
            "browser.bookmarks.restore_default_bookmarks" = false;
            "browser.bookmarks.addedImportButton" = true;

            # Don't ask for download directory
            "browser.download.useDownloadDir" = false;

            # Don't ask whether to enable a new plugin.
            "extensions.autoDisableScopes" = 0;

            # Disables telemetry
            "app.shield.optoutstudies.enabled" = false;
            "browser.discovery.enabled" = false;
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "browser.ping-centre.telemetry" = false;
            "datareporting.healthreport.service.enabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.sessions.current.clean" = true;
            "devtools.onboarding.telemetry.logged" = false;
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.hybridContent.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.prompted" = 2;
            "toolkit.telemetry.rejected" = true;
            "toolkit.telemetry.reportingpolicy.firstRun" = false;
            "toolkit.telemetry.server" = "";
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.unifiedIsOptIn" = false;
            "toolkit.telemetry.updatePing.enabled" = false;

            # Other selective features
            "privacy.resistFingerprinting" = true;
            "privacy.fingerprintingProtecting" = true;
            "image.jxl.enabled" = true; # enable JPEG-XL support
            "browser.tabs.insertRelatedAfterCurrent" = false;
            "general.smoothScroll.msdPhysics.enabled" = true;
            "browser.tabs.min_inactive_duration_before_unload" =
              if cfg.system.isLowRam # check if the system is a Low RAM machine
              then 60000 # unload tabs after 1 minute.
              else 90000; # unload tabs after 1:30 minutes.
            "gfx.font_rendering.cleartype_params.rendering_mode" = 5;
            "gfx.font_rendering.cleartype_params.force_gdi_classic_max_size" = 0;
            "dom.animations.offscreen-throttling" = false;
            "browser.tabs.loadDivertedInBackground" = true;
            "browser.tabs.loadInBackground" = false;
            "sidebar.verticalTabs" = true;

            "browser.nova.enabled" = true;
          };
        };
      };
    }
    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = ["firefox.desktop"];
          "text/xml" = ["firefox.desktop"];
          "x-scheme-handler/http" = ["firefox.desktop"];
          "x-scheme-handler/https" = ["firefox.desktop"];
        };
        associations.added = {
          "application/pdf" = ["firefox.desktop"];
        };
      };
    })
  ])
