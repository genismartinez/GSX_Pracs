$TTL 604800
@ IN SOA server.dmz.gsx. admin.dmz.gsx. (
            1     ; Serial
       604800     ; Refresh
        86400     ; Retry
      2419200     ; Expire
       604800 )   ; Negative Cache TTL
;
@     IN      NS      server.dmz.gsx.
server.dmz.gsx.   IN  A   198.18.88.1
www.dmz.gsx.      IN  CNAME   server.dmz.gsx.

