#!/command/execlineb -P
/package/admin/s6-overlay/command/with-contenv bash -c "
exec bash -c 'service nscd start && service ssh start && sleep infinity'
"