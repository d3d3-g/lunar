# audit_dns_server
#
# The Domain Name System (DNS) is a hierarchical distributed naming system
# for computers, services, or any resource connected to the Internet or a
# private network. It associates various information with domain names
# assigned to each of the participating entities.
# In general servers will be clients of an upstream DNS server within an
# organisation so do not need to provide DNS server services themselves.
# An obvious exception to this is DNS servers themselves and servers that
# provide boot and install services such as Jumpstart or Kickstart servers.
#
# Refer to Section 3.9 Page(s) 65-66 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section 3.6 Page(s) 11 CIS FreeBSD Benchmark v1.0.5
#.

audit_dns_server () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    funct_verbose_message "DNS Server"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/network/dns/server:default"
        funct_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      for service_name in dnsmasq named; do
        funct_chkconfig_service $service_name 3 off
        funct_chkconfig_service $service_name 5 off
      done
      if [ "$os_vendor" = "CentOS" ]; then
        funct_linux_package uninstall bind
      fi
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/rc.conf"
      funct_file_value $check_file named_enable eq NO hash
    fi
  fi
}