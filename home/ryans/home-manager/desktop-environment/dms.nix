{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  programs.dank-material-shell = {
    enable = true;

    systemd = {
      enable = true;
      target = "default.target";
    };

    session = {
      isLightMode = false;
    };

    enableDynamicTheming = true;
    enableAudioWavelength = true; # cava (audio visualizer)
    enableSystemMonitoring = true;

    settings = {
      currentThemeName = "dynamic";
      currentThemeCategory = "dynamic";
      mutugenScheme = "scheme-vibrant";
      cornerRadius = 12;

      touchpadAccelProfile = "adaptive";
      animationVariant = true;

      blurEnabled = true;

      showWorkspaceIndex = true;
      showWorkspacePadding = true;

      fontFamily = "SF Pro Rounded";
      monoFontFamily = "JetBrains Mono";

      textRenderType = 1;
      notificationBodyFontSize = 10;

      # Bar (Waybar-like) configurations
      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;

          position = 0;
          screenPreferences = ["all"];
          showOnLastDisplay = true;

          leftWidgets = [
            {
              id = "workspaceSwitcher";
              enabled = true;
            }
            "focusedWindow"
          ];

          centerWidgets = [
            "music"
            "clock"
            "weather"
          ];

          rightWidgets = [
            {
              id = "systemTray";
              enabled = true;
            }
            "clipboard"
            {
              id = "cpuUsage";
              enabled = true;
              minimumWidth = false;
            }
            {
              id = "memUsage";
              enabled = true;
              minimumWidth = false;
              showInGb = true;
              showSwap = true;
            }
            "notificationButton"
            {
              id = "battery";
              enabled = true;
              showBatteryPercentOnlyOnBattery = false;
            }
            {
              id = "controlCenterButton";
              enabled = true;
              showAudioPercent = true;
            }
            {
              id = "powerMenuButton";
              enabled = true;
            }
          ];

          spacing = 0;
          innerPadding = 9;
          barInsetPadding = 6;
          bottomGap = 0;
          transparency = 1;
          widgetTransparency = 1;
          squareCorners = true;
          noBackground = false;
          maximizeWidgetIcons = false;
          maximizeWidgetText = false;
          removeWidgetPadding = false;
          widgetPadding = 6;
          gothCornersEnabled = true;
          gothCornerRadiusOverride = false;
          gothCornerRadiusValue = 12;
          borderEnabled = true;
          borderColor = "primary";
          borderOpacity = 1;
          borderThickness = 2;
          widgetOutlineEnabled = false;
          fontScale = 1.1;
          iconScale = 1;
          visible = true;
          maximizeDetection = true;
          useOverlayLayer = true;
          scrollEnabled = true;
          scrollXBehavior = "column";
          scrollYBehavior = "workspace";
          hoverPopouts = true;
          hoverPopoutDelay = 250;
        }
      ];
    };
  };
}
