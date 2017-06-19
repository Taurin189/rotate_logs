rotate_logs
====
## Description
This tool read a config file including rotate date and target directory.
It change \*.log files into \*.log.{YYYYMMDD} file.
Finally it delete files which is expired.

## Usage
1. git clone https://github.com/Taurin189/rotate_logs.git
1. cp template_config_file/rotate.config config_file/
1. modify config_file/rotate.config(default) as following.
  * modify the number of the RETENTION_PERIOD from 7 to the number which you need(1 ~ 365).
  * modify the directory path of the TARGET_DIRECTORY from ~/logs to the directory path which you need.

## Author
[Taura,Koichi|Taurin](https://github.com/Taurin189)
