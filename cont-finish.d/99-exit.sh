#!/command/execlineb -P
/package/admin/s6-overlay/command/with-contenv bash -c "

# Perform any cleanup actions here
echo Container initialization complete. Exiting...

# Ensure the script exits properly
exit 0
"