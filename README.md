# Bash-script overview

The main functionality of this script is to perform recon on a target. The target must be specified 
as a URL or IP address. This script performs a host reachability test through ping, scans and 
checks for open ports using nmap, checks for web server vulnerabilities through a nikto scan, 
finds hidden directories by using dirb and attempts to transfer files or packets if there are relevant 
open ports, by using netcat. 
