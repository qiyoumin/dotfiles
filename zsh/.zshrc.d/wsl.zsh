if ! grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then
  return
fi

if [ -d /opt/node-v22/bin ] && [[ ":$PATH:" != *":/opt/node-v22/bin:"* ]]; then
  export PATH="/opt/node-v22/bin:$PATH"
fi

# Reuse the Windows host address from WSL's resolver so shell tools can route
# traffic through Clash Verge's local HTTP/SOCKS proxies running on Windows.
proxy_port=7897
hostip=$(awk '/nameserver/ {print $2}' /etc/resolv.conf 2>/dev/null)

if [ -n "$hostip" ]; then
  export http_proxy="http://${hostip}:${proxy_port}"
  export https_proxy="http://${hostip}:${proxy_port}"
  export HTTP_PROXY="http://${hostip}:${proxy_port}"
  export HTTPS_PROXY="http://${hostip}:${proxy_port}"
  export all_proxy="socks5://${hostip}:${proxy_port}"
  export ALL_PROXY="socks5://${hostip}:${proxy_port}"
fi
