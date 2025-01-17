# セットアップ
$wsl2Address = (wsl hostname -I).Trim()
$hostAddress = (Get-NetIPAddress -InterfaceAlias "Wi-Fi" -AddressFamily IPv4).IPAddress
$port = 5173
$fwRuleName = "WSL 2 Firewall Unlock"

echo "WSL 2 Address: $wsl2Address"
echo "Host Address: $hostAddress"
echo "Port: $port"
echo "Firewall Rule Name: $fwRuleName"

# ポートフォワーディング設定

netsh interface portproxy add v4tov4 listenport=$port listenaddress=$hostAddress connectport=$port connectaddress=$wsl2Address

# ファイアウォールルール追加
New-NetFirewallRule -DisplayName $fwRuleName -Direction Inbound -Action Allow -Protocol TCP -LocalPort $port -RemoteAddress LocalSubnet

# セットアップ確認
netsh interface portproxy show all 
Get-NetFireWallRule | Where-Object { $_.DisplayName -like "*WSL*" }


