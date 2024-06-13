router    IN   A   172.24.88.1
server    IN   A   172.24.88.2
client1   IN   A   172.24.88.3
client2   IN   A   172.24.88.4

$TTL 604800
@ IN SOA ns.example.com. root.ns.example.com. (
	2 ; Serial
	604800 ; Refresh
	86400 ; Retry
	2419200 ; Expire
	604800 ) ; Negative Cache TTL
;
@ IN NS ns.example.com.
  IN NS 10 mail.example.com.

@   IN   NS   server.intranet.gsx.

www   IN   CNAME   server

