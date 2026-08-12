{
  networking.wireless.iwd = {
    enable = true;
    settings.general = {
      EnableNetworkConfiguration = true;
      AddressRandomization = true;
      AddressRandomizationRange = "full";
    };
  };

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  networking.nameservers = [
    # CloudFlare DNS
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];
}
