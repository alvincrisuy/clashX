cd `dirname "${BASH_SOURCE[0]}"`
sudo mkdir -p "/Library/Application Support/clashX/"
sudo cp ProxyConfig "/Library/Application Support/clashX/"
sudo chown root:admin "/Library/Application Support/clashX/ProxyConfig"
sudo chmod +s "/Library/Application Support/clashX/ProxyConfig"
echo done
