clear
read -p " DOMAIN: " domain
  [ -z "${domain}" ] && domain=xnxx.com
read -p " APIKEY: " apikey
  [ -z "${apikey}" ] && apikey=xnxx.com
read -p " NODE ID 1: " node_id1
  [ -z "${node_id1}" ] && node_id1=0
  
read -p " NODE ID 2: " node_id2
  [ -z "${node_id2}" ] && node_id2=0
  
read -p " DeviceLimit: " DeviceLimit
  [ -z "${DeviceLimit}" ] && DeviceLimit=0
  
read -p " CertDomain: " CertDomain
  [ -z "${CertDomain}" ] && CertDomain="vn.speed4g.me"
rm -rf /etc/XrayR/4gviet.crt
rm -rf /etc/XrayR/4gviet.key
openssl req -newkey rsa:2048 -x509 -sha256 -days 365 -nodes -out /etc/XrayR/4gviet.crt -keyout /etc/XrayR/4gviet.key -subj "/C=JP/ST=Tokyo/L=Chiyoda-ku/O=Google Trust Services LLC/CN=google.com"
bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)
cd /etc/XrayR

cat >config.yml <<EOF
Log:
  Level: none 
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json
InboundConfigPath: # /etc/XrayR/custom_inbound.json
RouteConfigPath: # /etc/XrayR/route.json
OutboundConfigPath: # /etc/XrayR/custom_outbound.json
ConnetionConfig:
  Handshake: 4 
  ConnIdle: 30 
  UplinkOnly: 2 
  DownlinkOnly: 4 
  BufferSize: 64 
Nodes:
  -
    PanelType: "V2board" 
    ApiConfig:
      ApiHost: "https://$domain"
      ApiKey: "$apikey"
      NodeID: $node_id1
      NodeType: V2ray 
      Timeout: 30 
      EnableVless: false 
      EnableXTLS: false 
      SpeedLimit: 0 
      DeviceLimit: $DeviceLimit
      RuleListPath: # /etc/XrayR/rulelist
    ControllerConfig:
      DisableSniffing: True
      ListenIP: 0.0.0.0 
      SendIP: 0.0.0.0 
      UpdatePeriodic: 60 
      EnableDNS: false 
      DNSType: AsIs 
      EnableProxyProtocol: false 
      EnableFallback: false 
      FallBackConfigs:  
        -
          SNI: 
          Path: 
          Dest: 80 
          ProxyProtocolVer: 0 
      CertConfig:
        CertMode: file 
        CertDomain: "$CertDomain" 
        CertFile: /etc/XrayR/4gviet.crt
        KeyFile: /etc/XrayR/4gviet.key
        Provider: cloudflare 
        Email: test@me.com
        DNSEnv: 
          CLOUDFLARE_EMAIL:
          CLOUDFLARE_API_KEY:
  -
    PanelType: "V2board" 
    ApiConfig:
      ApiHost: "https://$domain"
      ApiKey: "$apikey"
      NodeID: $node_id2
      NodeType: V2ray 
      Timeout: 30 
      EnableVless: false 
      EnableXTLS: false 
      SpeedLimit: 0 
      DeviceLimit: $DeviceLimit
      RuleListPath: # /etc/XrayR/rulelist
    ControllerConfig:
      DisableSniffing: True
      ListenIP: 0.0.0.0 
      SendIP: 0.0.0.0 
      UpdatePeriodic: 60 
      EnableDNS: false 
      DNSType: AsIs 
      EnableProxyProtocol: false 
      EnableFallback: false 
      FallBackConfigs:  
        -
          SNI: 
          Path: 
          Dest: 80 
          ProxyProtocolVer: 0 
      CertConfig:
        CertMode: file 
        CertDomain: "$CertDomain" 
        CertFile: /etc/XrayR/4gviet.crt 
        KeyFile: /etc/XrayR/4gviet.key
        Provider: cloudflare 
        Email: test@me.com
        DNSEnv: 
          CLOUDFLARE_EMAIL: 
          CLOUDFLARE_API_KEY: 
EOF
cd /root
xrayr restart
