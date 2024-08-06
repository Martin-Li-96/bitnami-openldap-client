#!/command/execlineb -P
/package/admin/s6-overlay/command/with-contenv bash -c "

#URI_LDAP=ip:port
URI_LDAP= \${URI_LDAP}

#BASE_DC= dc=exampe,dc=com
BASE_DC= \${BASE_DC}

#BIND_DN= \"cn=admin,dc=example,dc=com\"
BIND_DN = \${BIND_DN}

#BIND_PW= passwd
BIND_PW= \${BIND_PW}

cat >/etc/ldap.conf<<EOF
# /etc/ldap.conf

# The distinguished name of the search base
base \$BASE_DC

# The LDAP server's URI
uri ldap://\$URI_LDAP

# The LDAP version to use
ldap_version 3

# Bind credentials (if required)
binddn \$BIND_DN
bindpw \$BIND_PW

# Search scope (subtree)
scope sub

# Use LDAP extended operation for password changes
pam_password exop
EOF



cat >/etc/nsswitch.conf<<EOF
# /etc/nsswitch.conf

passwd:         compat ldap
group:          compat ldap
shadow:         compat ldap
EOF



cat >/etc/pam.d/common-auth<<EOF
# /etc/pam.d/common-auth
auth    sufficient      pam_ldap.so
auth    required        pam_unix.so nullok_secure try_first_pass

EOF

cat >/etc/pam.d/common-account<<EOF
# /etc/pam.d/common-account

account sufficient      pam_ldap.so
account required        pam_unix.so

EOF

cat >/etc/pam.d/common-password<<EOF
# /etc/pam.d/common-password
# /etc/pam.d/common-password

password sufficient     pam_ldap.so
password required       pam_unix.so obscure use_authtok try_first_pass sha512
EOF

cat >/etc/pam.d/common-session<<EOF
# /etc/pam.d/common-session

session required        pam_mkhomedir.so skel=/etc/skel umask=0077
session sufficient      pam_ldap.so
session required        pam_unix.so

EOF


"