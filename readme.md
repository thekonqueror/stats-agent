# stats-agent

stats-agent is a python daemon to collect cpu, memory and process statistics on cloud instances. Collected data is posted in json format to user specified endpoint for further analysis and storage. 

Thanks to [amonapp/amonagent](https://github.com/amonapp/amonagent) for core.py snippet.

Stats-agent collects following information about running instance:
  - Memory usage
  - CPU Utilization
  - Load averages
  - Disk usage
  - Network traffic
  - Uptime
  - WAN IP
  - UUID from user specified file

Stats-agent also creates a new user account with sudo access. This account can be used for remedial actions initiated by API endpoint based on posted values. RSA Key is used for authentication of this account. For added security, SSH access can be limited to API endpoint IP.

### Version
1.0.0

### Installation

```sh
$ wget https://code.stats.io/install.sh
$ bash install.sh
```


License
----

MIT
