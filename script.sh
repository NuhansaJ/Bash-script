if [ $# -ne 1 ]; then
  echo "Pls enter it like : $0 <target>" 
exit 1 
fi 

target="$1"  
ping -c 4 "$target"  
pingStatus=$?  

if [ $pingStatus -eq 0 ]; then  
echo "Host $target is reachable. Starting Nmap scan..."   
fi 

nmap -sV -oN nmapScan.txt $target  
nikto -h "http://$target" -o vulnerability.txt  
dirb "http://$target" -o foundDirectories.txt  
transferStatus="transfer.txt" 
 
if grep -q '80/tcp\s*open' nmapScan.txt; then 
echo "Port 80 (HTTP) is open. Sending an HTTP request..." 
echo -e "HTTP Response for Port 80:\n" >> "$transferStatus" 
echo -e "GET / HTTP/1.1\r\nHost: $target\r\n\r\n" | nc  $target 80 >> "$transferStatus" 
2>&1  
fi 

if grep -q '21/tcp\s*open' nmapScan.txt; then 
echo "Port 21 (FTP) is open. Sending an FTP request..." 
echo -e "FTP Response for Port 21:\n" >> "$transferStatus" 
(echo -e "USER anonymous\r\nPASS \r\nPUT localFile.txt remoteFile.txt\r\nQUIT\r\n") | 
nc $target 21 >> "$transferStatus" 2>&1 
fi 
echo "Scans completed. Results saved to:" 
echo "Nmap results: nmapScan.txt" 
echo "Vulnerability results: vulnerability.txt" 
echo "Dirb scan Results: foundDirectories.txt" 
echo "File transfer status results:transfer.txt" 
